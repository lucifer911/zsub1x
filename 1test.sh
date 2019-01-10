#!/bin/bash
# install.sh
# Installs smartnode on Ubuntu 16.04 LTS x64
# ATTENTION: The anti-ddos part will disable http, https and dns ports.

if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

while true; do
 if [ -d ~/.chaincoincore ]; then
   printf "~/.chaincoincore/ already exists! The installer will delete this folder. Continue anyway?(Y/n)"
   read REPLY
   if [ ${REPLY} == "Y" ]; then
      pID=$(ps -ef | grep chaincoind | awk '{print $2}')
      kill ${pID}
      rm -rf ~/.chaincoincore/
      break
   else
      if [ ${REPLY} == "n" ]; then
        exit
      fi
   fi
 else
   break
 fi
done

# Warning that the script will reboot the server
#echo "WARNING: This script will reboot the server when it's finished."
#printf "Press Ctrl+C to cancel or Enter to continue: "
#read IGNORE

cd
# Changing the SSH Port to a custom number is a good security measure against DDOS attacks
#printf "Custom SSH Port(Enter to ignore): "
#read VARIABLE
#_sshPortNumber=${VARIABLE:-22}

# Get a new privatekey by going to console >> debug and typing smartnode genkey
printf "Masternode GenKey: "
read _nodePrivateKey

# The RPC node will only accept connections from your localhost
_rpcUserName=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12 ; echo '')

# Choose a random and secure password for the RPC
_rpcPassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')

# Get the IP address of your vps which will be hosting the smartnode
_nodeIpAddress=$(ip route get 1 | awk '{print $NF;exit}')

# Make a new directory for chaincoin daemon
mkdir ~/.chaincoincore/
touch ~/.chaincoincore/chaincoin.conf

# Change the directory to ~/.chaincoin
cd ~/.chaincoincore/

# Create the initial chaincoin.conf file
echo "rpcuser=${_rpcUserName}
rpcpassword=${_rpcPassword}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
masternode=1
masternodeprivkey=${_nodePrivateKey}
" > chaincoin.conf

# Create a directory for chcnode's cronjobs and the anti-ddos script
cd
cd .chaincoincore
