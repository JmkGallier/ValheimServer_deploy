#!/bin/bash

# Initial step
sudo apt update
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux netcat lib32gcc1 lib32stdc++6 steamcmd

# Steam User Prep
sudo useradd -m steam
sudo mkdir /home/steam/ValheimServ
sudo touch /home/steam/ValheimServ/InstallUpdate.sh && echo 'InstallUpdate.sh Created...'
sudo touch /home/steam/ValheimServ/valheim.sh && echo 'valheim.sh Created...'

# Installation/Validation Script
sudo echo '#!/bin/sh
steamcmd +@sSteamCmdForcePlatformType linux +login <user> <pass> +force_install_dir /path/to/server +app_update 896660 validate +quit' >> /home/steam/ValheimServ/InstallUpdate.sh
sudo chmod +x /home/steam/ValheimServ/InstallUpdate.sh

## Sub Steam User
sudo -iu steam
cd /home/steam/Steam
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

echo '#!/bin/sh 
export templdpath=$LD_LIBRARY_PATH  
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH  
export SteamAppID=896660

echo "Starting server PRESS CTRL-C to exit"  
./valheim_server.x86_64 -name "SSD Viking Lounge" -port 2456 <-nographics> <-batchmode> -world "Bearclawheim" -password "brick" -public 1  
export LD_LIBRARY_PATH=$templdpath' >> /home/steam/ValheimServ/valheim.sh

