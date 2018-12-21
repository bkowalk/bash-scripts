#!/bin/bash

echo "Flushing SD1 Cache"
ssh -t $NEW_SSH_USER@aem-staging-dispatcher1.vnerd.com \
    "sudo rm -rf /mnt/var/www/html/*"
