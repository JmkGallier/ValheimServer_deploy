#!/bin/bash

# Initial step
sudo apt update
sudo dpkg --add-architecture i386
sudo apt update

# Steam User Prep
sudo useradd -m steam
sudo mkdir /home/steam/ValheimServ
sudo mkdir /home/steam/Steam
sudo chmod -R 777 /home/steam/ValheimServ
sudo chmod -R 777 /home/steam/Steam

# Installation/Validation Script
echo '#!/bin/sh
steamcmd +login anonymous +force_install_dir /home/steam/ValheimServ +app_update 896660 validate +exit' >> /home/steam/ValheimServ/InstallUpdate.sh
sudo chmod +x /home/steam/ValheimServ/InstallUpdate.sh

## Sub Steam User
sudo apt install steamcmd lib32gcc1 net-tools

echo '#!/bin/bash

export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

# Tip: Make a local copy of this script to avoid it being overwritten by steam.
# NOTE: Minimum password length is 5 characters & Password cant be in the server name.
# NOTE: You need to make sure the ports 2456-2458 is being forwarded to your server through your local router & firewall.
steamcmd +login anonymous +force_install_dir /home/steam/ValheimServ +app_update 896660 +quit

/home/steam/ValheimServ/valheim_server.x86_64 -name "SSD Viking Lounge" -port 2456 -world "Bearclawheim" -password "<lolstealmycreds>" -public 1 > /dev/null &

export LD_LIBRARY_PATH=$templdpath

echo "Server started"
echo ""
#read -p "Press RETURN to stop server"
#echo 1 > server_exit.drp

#echo "Server exit signal set"
#echo "You can now close this terminal"

while :
do
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "valheim.service: timestamp ${TIMESTAMP}"
sleep 60
done' >> /home/steam/ValheimServ/valheim.sh
sudo chmod +x /home/steam/ValheimServ/valheim.sh

sudo su echo '[Unit]
Description=Valheim service
Wants=network.target
After=syslog.target network-online.target

[Service]
Type=simple
Restart=on-failure
RestartSec=10
User=steam
WorkingDirectory=/home/steam/ValheimServ
ExecStart=/home/steam/ValheimServ/valheim.sh

[Install]
WantedBy=multi-user.target' >> /etc/systemd/system/valheim.service
sudo systemctl daemon-reload

sudo chown -R steam /home/steam/ValheimServ
sudo chown -R steam /home/steam/Steam
