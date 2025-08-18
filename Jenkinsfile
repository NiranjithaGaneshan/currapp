pipeline {
    agent any

    environment {
        MAVEN_HOME = "C:\\ProgramData\\chocolatey\\lib\\maven\\apache-maven-3.9.9"
    }

    stages {

        stage('Checkout Code') {
            steps {
                // Checkout repository configured in the Jenkins job
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
                // Run SonarQube analysis via Maven using the properties file
                 bat "\"%MAVEN_HOME%\\bin\\mvn\" sonar:sonar -Dproject.settings=sonar-project.properties"
            }
        }

        stage('Snyk Scan') {
            steps {
                // Run Snyk security scan
                bat 'snyk test'
            }
        }

        stage('Deploy to Nexus / Sonatype') {
           steps {
               // Deploy artifact to Nexus using the same settings.xml
               bat "\"%MAVEN_HOME%\\bin\\mvn\" deploy -s \"%MAVEN_HOME%\\conf\\settings.xml\""
           }
        }

        stage('Deploy to Tomcat') {
            steps {
                // Copy the WAR file to Tomcat webapps folder on Windows
                bat 'copy target\\currency-app.war "C:\\Program Files\\apache-tomcat-9.0.108-src\\webapps\\"'
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
