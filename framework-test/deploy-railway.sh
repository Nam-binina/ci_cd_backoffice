#!/bin/bash
name="ci_cd_backoffice"

echo "🚀 Build Railway (JAR)"

# Nettoyage
chmod -R 777 *
rm -rf build "$name".jar

# Création des répertoires
mkdir -p build/classes
mkdir -p build/lib

# Compilation des sources Java
echo "📦 Compilation des sources Java..."
javac --release 21 -parameters -cp "lib/framework.jar" -d build/classes/ src/main/java/com/nam/java/*.java

if [ $? -ne 0 ]; then
    echo "❌ Erreur de compilation"
    exit 1
fi

# Copie des ressources webapp
if [ -d src/main/webapp ]; then
    cp -r src/main/webapp/* build/
    echo "✅ Ressources webapp copiées"
else
    echo "⚠️  Aucun répertoire src/main/webapp trouvé"
fi

# Copie des librairies
if [ -d lib ]; then
    cp -r lib/* build/lib/
    echo "✅ Librairies copiées"
else
    echo "⚠️  Aucun répertoire lib trouvé"
fi

# Création du JAR
echo "📦 Création du JAR..."
jar -cvf "$name".jar -C build .

if [ -f "$name".jar ]; then
    echo "🎉 JAR créé avec succès : $name.jar"
else
    echo "❌ Erreur lors de la création du JAR"
    exit 1
fi

chmod -R 777 *
