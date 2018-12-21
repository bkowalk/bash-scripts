#!/bin/bash

cd $GIT_HOME/pluralsight.com
git pull
mvn clean install -PautoInstallPackage64StageAuthor -DdeployHost.pass=$MVN_INSTALL_PASS

curl -u mvn-installer:$MVN_INSTALL_PASS \
    -X POST \
    -F path="/etc/packages/com.pluralsight.aem.packages/pluralsight-application-1.1-SNAPSHOT.zip" \
    -F cmd="activate" http://aem-staging-author1.vnerd.com:4502/bin/replicate.json
curl -u mvn-installer:$MVN_INSTALL_PASS \
    -X POST \
    -F path="/etc/packages/com.pluralsight.aem.packages/pluralsight-bundle-install-1.1-SNAPSHOT.zip" \
    -F cmd="activate" http://aem-staging-author1.vnerd.com:4502/bin/replicate.json

./remove-target-dirs.sh