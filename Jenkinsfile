pipeline {
    agent any

    stages {

        stage('Clone Git Repository') {
            steps {
                // Clone your repository from GitHub
                bat 'git clone -b master https://github.com/NiranjithaGaneshan/currapp.git'
            }
        }

        stage('Build with Maven') {
            steps {
                // Build project using Maven with your settings.xml for Nexus credentials
                bat 'mvn clean install -s %USERPROFILE%\\.m2\\settings.xml'
            }
        }

        stage('Unit Test & Jacoco') {
            steps {
                // Run unit tests and generate Jacoco report
                bat 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Analyze project using SonarQube
                bat 'mvn sonar:sonar'
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
                // Deploy artifact to Nexus using credentials in settings.xml
                bat 'mvn deploy -s %USERPROFILE%\\.m2\\settings.xml'
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
