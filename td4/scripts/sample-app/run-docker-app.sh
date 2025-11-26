#!/bin/bash
# Ce script lance l'application Node.js conteneurisée.

# Arrête le script si une commande échoue
set -e

APP_NAME="sample-app"
APP_VERSION="1.0.0" # Assurez-vous que ceci correspond au tag utilisé dans build-docker-image.sh
IMAGE_NAME="${APP_NAME}:${APP_VERSION}"

# 1. Vérifie si un conteneur du même nom tourne et l'arrête
if [ "$(docker ps -q -f name=${APP_NAME})" ]; then
    echo "Arrêt du conteneur existant: ${APP_NAME}"
    docker stop ${APP_NAME}
fi

# 2. Supprime le conteneur précédent s'il existe (même s'il est arrêté)
if [ "$(docker ps -aq -f name=${APP_NAME})" ]; then
    echo "Suppression de l'ancien conteneur: ${APP_NAME}"
    docker rm ${APP_NAME}
fi

echo "Démarrage du conteneur ${IMAGE_NAME}..."

# 3. Lance le nouveau conteneur en arrière-plan et mappe le port
docker run -d \
           -p 8080:8080 \
           --name ${APP_NAME} \
           ${IMAGE_NAME}

echo "Le conteneur est démarré. Accès à l'application via http://localhost:8080"
echo "Vérifiez l'état avec: docker ps"
