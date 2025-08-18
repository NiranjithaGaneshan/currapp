pipeline {
    agent any

    stages {

        stage('Clone Git Repository') {
            steps {
                // Clone your repository from GitHub
                bat 'rmdir /S /Q currapp'
                bat 'git clone -b master https://github.com/NiranjithaGaneshan/currapp.git'
            }
        }

        stage('Build with Maven') {
            steps {
                // Build project using Maven with the correct settings.xml path
                bat 'mvn clean install -s "C:\\ProgramData\\chocolatey\\lib\\maven\\apache-maven-3.9.9\\conf\\settings.xml"'
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
               // Deploy artifact to Nexus using the same settings.xml
               bat 'mvn deploy -s "C:\\ProgramData\\chocolatey\\lib\\maven\\apache-maven-3.9.9\\conf\\settings.xml"'
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
