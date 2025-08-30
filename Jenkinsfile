pipeline {
    agent any

    environment {
        MAVEN_HOME = "C:\\ProgramData\\chocolatey\\lib\\maven\\apache-maven-3.9.9"
        SONAR_SCANNER_HOME = tool 'MySonarScanner'
        JAVA_TOOL_OPTIONS = "-Dfile.encoding=UTF-8"
    }

    stages {

        stage('Checkout Code') {
            steps {
                // Checkout repository configured in the Jenkins job.....
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                // Build project using Maven with the correct settings.xml path
                bat "\"%MAVEN_HOME%\\bin\\mvn\" clean install -s \"%MAVEN_HOME%\\conf\\settings.xml\""
            }
        }

        stage('Unit Test & Jacoco') {
            steps {
                // Run unit tests and generate Jacoco report
                bat "\"%MAVEN_HOME%\\bin\\mvn\" test"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonarServer') {  // the name you gave in Jenkins config
                    bat "${SONAR_SCANNER_HOME}\\bin\\sonar-scanner -Dproject.settings=sonar-project.properties"
                }
            }
        }

       stage('Snyk Scan') {
    steps {
        snykSecurity(
                    snykInstallation: 'snyk-cli',
                    snykTokenId: 'snyk-token',
                    monitorProjectOnBuild: true,
                    failOnIssues: false,
                    additionalArguments: '--json --no-ansi'
                )
    }
}




        stage('Deploy to Nexus / Sonatype') {
            steps {
                // Deploy artifact to Nexus using the same settings.xml
                bat "\"%MAVEN_HOME%\\bin\\mvn\" deploy -s \"%MAVEN_HOME%\\conf\\settings.xml\""
            }
        }

        // Commented out Tomcat deployment
        /*
        stage('Deploy to Tomcat') {
            steps {
                bat 'copy target\\currency-app.war "C:\\apache-tomcat-9.0.108\\webapps\\"'
            }
        }
        */

        stage('Push Docker Image to Hub') {
    steps {
        // Login to Docker Hub (Jenkins credentials store)
        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            bat 'docker login -u %DOCKER_USER% -p %DOCKER_PASS%'
        }
        
        // Tag the image for Docker Hub
        bat 'docker tag currency-app:latest niru262000/currency-app:latest'
        
        // Push the image
        bat 'docker push niru262000/currency-app:latest'
    }
}


    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed, please check logs.'
        }
    }
}
