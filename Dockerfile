# Use the official Tomcat image as the base image
FROM tomcat:latest

# Remove default apps (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your application .war file to the webapps directory
COPY target/your-app.war /usr/local/tomcat/webapps/

# Expose port 8080
EXPOSE 8080
