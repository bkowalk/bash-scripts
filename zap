#!/bin/bash

cd $GIT_HOME/pluralsight.com
git pull
mvn clean install -PautoInstallPackage -Dcrx.password=$LOCAL_INSTALL_PASS
$GIT_HOME/bash/remove-target-dirs