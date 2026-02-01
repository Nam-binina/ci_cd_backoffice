#!/bin/bash

echo "=== Déploiement Framework-Test (WAR) ==="

# Aller dans le dossier framework-test
cd /home/nam/Documents/GitHub/ci_cd_entrainement/framework-test

# Vérifier si le WAR existe
if [ -f "framework-test.war" ]; then
    echo "✅ WAR trouvé: framework-test.war"
else
    echo "Building WAR..."
    if [ -f "deploy.sh" ]; then
        ./deploy.sh
    else
        echo "❌ Pas de script de build trouvé et WAR manquant"
        exit 1
    fi
fi

# Initialiser Railway si pas déjà fait
if [ ! -f ".railway" ]; then
    echo "Initialisation Railway..."
    railway init
fi

# Déployer sur Railway
echo "Déploiement sur Railway..."
railway up --detach

echo "✅ Déploiement terminé!"
railway status
