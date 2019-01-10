#!/bin/bash
# install.sh
# Installs smartnode on Ubuntu 16.04 LTS x64
# ATTENTION: The anti-ddos part will disable http, https and dns ports.

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
