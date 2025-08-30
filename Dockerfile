# Use official Tomcat image with JDK 11
FROM tomcat:9.0-jdk11-openjdk

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file from Maven target folder
COPY target/currency-app.war /usr/local/tomcat/webapps/

# Expose Tomcat port
EXPOSE 9090

# Start Tomcat
CMD ["catalina.sh", "run"]
