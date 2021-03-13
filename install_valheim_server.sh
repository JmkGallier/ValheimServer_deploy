#!/bin/bash

# Initial step
sudo apt update
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux netcat lib32gcc1 lib32stdc++6 steamcmd

# Steam User Prep
sudo useradd -m steam
sudo mkdir /home/steam/ValheimServ
sudo mkdir /home/steam/Steam
sudo touch /home/steam/ValheimServ/InstallUpdate.sh && echo 'InstallUpdate.sh Created...'
sudo touch /home/steam/ValheimServ/valheim.sh && echo 'valheim.sh Created...'

# Installation/Validation Script
sudo echo '#!/bin/sh
steamcmd +login anonymous +force_install_dir /home/steam/Valheim +app_update 896660 validate +exit' >> /home/steam/ValheimServ/InstallUpdate.sh
sudo chmod +x /home/steam/ValheimServ/InstallUpdate.sh

## Sub Steam User
sudo -iu steam
cd /home/steam/Steam
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

echo '#!/bin/bash

export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

# Tip: Make a local copy of this script to avoid it being overwritten by steam.
# NOTE: Minimum password length is 5 characters & Password cant be in the server name.
# NOTE: You need to make sure the ports 2456-2458 is being forwarded to your server through your local router & firewall.
steamcmd +login anonymous +force_install_dir /home/steam/ValheimServ +app_update 896660 +quit

./valheim_server.x86_64 -name "SSD Viking Lounge" -port 2456 -world "Bearclawheim" -password "<lolstealmycreds>" -public 1 > /dev/null &

export LD_LIBRARY_PATH=$templdpath

echo "Server started"
echo ""
#read -p "Press RETURN to stop server"
#echo 1 > server_exit.drp

#echo "Server exit signal set"
#echo "You can now close this terminal"

while :
do
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "valheim.service: timestamp ${TIMESTAMP}"
sleep 60
done' >> /home/steam/ValheimServ/valheim.sh
