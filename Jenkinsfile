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

stage('Deploy to Kubernetes (K3s)') {
    steps {
        script {
             Start K3s cluster using Docker
            bat '''
            docker run -d --name k3s-server --privileged rancher/k3s:v1.27.5-k3s1
            '''

            // Wait a few seconds for the cluster to be ready
            bat 'timeout /t 10'

            // Set KUBECONFIG to connect kubectl with the cluster
            bat 'docker exec k3s-server cat /etc/rancher/k3s/k3s.yaml > kubeconfig.yaml'
            bat 'set KUBECONFIG=kubeconfig.yaml'

            // Apply Kubernetes YAML files
            bat 'kubectl apply -f k8s/namespace.yaml'
            bat 'kubectl apply -f k8s/pvc.yaml'
            bat 'kubectl apply -f k8s/deployment.yaml'
            bat 'kubectl apply -f k8s/service.yaml'

                  }
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
