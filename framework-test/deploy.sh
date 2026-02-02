#!/bin/bash
name="ci_cd_backoffice"

chmod -R 777 *
rm -rf build "$name".war

mkdir -p build/WEB-INF/classes
mkdir -p build/WEB-INF/lib

javac --release 21 -parameters -cp "lib/framework.jar" -d build/WEB-INF/classes/ src/main/java/com/nam/java/*.java

if [ -d src/main/webapp ]; then
    cp -r src/main/webapp/* build/
else
    echo "⚠️  Aucun répertoire src/main/webapp trouvé"
fi

if [ -d lib ]; then
    cp -r lib/* build/WEB-INF/lib/
else
    echo "⚠️  Aucun répertoire lib trouvé"
fi

jar -cvf "$name".war -C build .

TOMCAT_PATH="/home/nam/Desktop/server/apache-tomcat-9.0.89/webapps/"

if [ -d "$TOMCAT_PATH" ]; then
    rm -f "$TOMCAT_PATH/$name.war"
    cp "$name".war "$TOMCAT_PATH/"
    echo "✅ WAR déployé dans Tomcat : $TOMCAT_PATH/$name.war"
else
    echo "❌ Dossier Tomcat introuvable : $TOMCAT_PATH"
fi

chmod -R 777 *

echo "🎉 WAR créé avec succès : $name.war"
