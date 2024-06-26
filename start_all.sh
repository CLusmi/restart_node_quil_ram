#!/bin/bash

#Demarrage du Node
cd /root/ceremonyclient/node && chmod +x release_autorun.sh && screen -dmS nodequil release_autorun.sh

#Demarrage du Check de RAM
cd /root/ceremonyclient/node && chmod +x ram_start.sh && screen -dmS checkram ram_start.sh