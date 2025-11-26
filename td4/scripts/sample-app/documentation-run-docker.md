DevOps Lab - Sample Application

This is a sample repository for the DevOps lab. It contains a simple Node.js application (app.js) designed for containerization exercises.

Docker Deployment Instructions

To build and run this application in a Docker container, follow these steps:

1. Build the Docker Image (using Dockerfile)

This step reads the Dockerfile and creates a local Docker image tagged sample-app:1.0.0.

# Assuming this is configured in your package.json / build script
npm run dockerize


2. Run the Container

Use the dedicated script to launch the application. This script handles stopping and removing any previous containers to ensure a clean start.

Required Files: run-docker-app.sh

# Assurez-vous d'abord que le script est exécutable
chmod u+x run-docker-app.sh

# Lance l'application
./run-docker-app.sh


3. Verification

Once the script has finished, confirm the application is running by:

Checking the container status:

docker ps -f name=sample-app


Accessing the application in your browser:

http://localhost:8080