#!/usr/bin/env bash
# Met à jour les paquets et installe Node.js
sudo apt update -y
sudo apt install -y curl nodejs npm

# Télécharge l'application Node.js depuis GitHub
curl -o ~/app.js https://raw.githubusercontent.com/guiraudj/devops/main/tds/td1/sample-app/app.js

# Lance l'application en arrière-plan et enregistre les logs
nohup node ~/app.js > ~/app.log 2>&1 &
