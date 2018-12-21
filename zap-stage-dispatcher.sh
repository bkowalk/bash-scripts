#!/bin/bash

cd $GIT_HOME/dispatcher
git pull
tar -czf dispatcher.zip conf*

echo "Copying SD1 Config"
scp dispatcher.zip $NEW_SSH_USER@aem-staging-dispatcher1.vnerd.com:~/
rm dispatcher.zip

echo "Deploying SD1 Config"
ssh -t $NEW_SSH_USER@aem-staging-dispatcher1.vnerd.com \
    "sudo tar -xzf ~/dispatcher.zip
     sudo rm -rf /etc/httpd/conf.d/*
     sudo mv ~/conf.d/* /etc/httpd/conf.d/
     sudo mv ~/conf/* /etc/httpd/conf/
     sudo chown -R root:root /etc/httpd/conf*
     sudo chcon -R --type=httpd_config_t /etc/httpd/conf*
     sudo service httpd restart
     sudo rm -rf ~/conf*
     sudo rm ~/dispatcher.zip"