#!/bin/sh
#Version 0.1.1.3
#Info: Installs zsub1x daemon, Masternode based on privkey.
#zsub1x
#Tested OS: Ubuntu 16.04
#All the credit to Chaobunga


noflags() {
	echo "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"
    echo "Usage: install-sub1"
    echo "Example: install-sub1"
    echo "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"
    exit 1
}

message() {
	echo "╒════════════════════════════════════════════════════════════════════════════════>>"
	echo "| $1"
	echo "╘════════════════════════════════════════════<<<"
}

error() {
	message "An error occured, you must fix it to continue!"
	exit 1
}
	
prepdependencies() { #TODO: add error detection
	message "Installing dependencies..."
	sudo apt-get update
	sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
	sudo apt-get install automake libdb++-dev build-essential libtool autotools-dev autoconf pkg-config libssl-dev libboost-all-dev libminiupnpc-dev git software-properties-common python-software-properties g++ bsdmainutils libevent-dev -y
	sudo add-apt-repository ppa:bitcoin/bitcoin -y
	sudo apt-get update
	sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
}
	
createswap() { #TODO: add error detection
	message "Creating 2GB temporary swap file...this may take a few minutes..."
	cd /var
	sudo touch swap.img
	sudo chmod 600 swap.img
	sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
	sudo mkswap /var/swap.img
	sudo swapon /var/swap.img
	sudo free
	sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
	cd
	cd
}


installwallet() { #TODO: add error detection
	message "Downloading the wallet & moving files..."
	sudo wget https://github.com/SuB1X-Coin/zSub1x/releases/download/v1.3.4/zsub1x-1.3.4-x86_64-linux.tar.gz
	sudo tar -xzvf zsub1x-1.3.4-x86_64-linux.tar.gz
	sudo mv zsub1x-cli /usr/local/bin/
	sudo mv zsub1xd /usr/local/bin/
	sudo mv zsub1x-qt /usr/local/bin/
	sudo rm -r zsub1x-1.3.4-x86_64-linux.tar.gz
}	

createconf() {
	#TODO: Can check for flag and skip this
	#TODO: Random generate the user and password

	message "Creating chaincoin.conf..."
	MNPRIVKEY="877wrJqGdeLGZyaaSYisUFzwKnVHQt8rpPpPBb5M1pVEiALyeHG"
	CONFDIR=~/.zsub1x
	CONFILE=$CONFDIR/zsub1x.conf
	if [ ! -d "$CONFDIR" ]; then mkdir $CONFDIR; fi
	if [ $? -ne 0 ]; then error; fi
	mnip=$(curl -s https://api.ipify.org)
	rpcuser=$(date +%s | sha256sum | base64 | head -c 10 ; echo)
	rpcpass=$(openssl rand -base64 32)
	printf "%s\n" "rpcuser=$rpcuser" "rpcpassword=$rpcpass" "rpcallowip=127.0.0.1" "rpcport=1331" "listen=1" "server=1" "daemon=1" "maxconnections=256" "externalip=$mnip" "bind=$mnip" "masternode=1" "masternodeprivkey=$MNPRIVKEY" "masternodeaddr=$mnip:5721" "addnode=sub1x.seeds.mn.zone" > $CONFILE
       
        zsub1xd
        message "Wait 10 seconds for daemon to load..."
        sleep 20s
        MNPRIVKEY=$(zsub1x-cli masternode genkey)
		zsub1x-cli stop
		message "wait 10 seconds for deamon to stop..."
        sleep 10s
		sudo rm $CONFILE
		message "Updating chaincoin.conf..."
        printf "%s\n" "rpcuser=$rpcuser" "rpcpassword=$rpcpass" "rpcallowip=127.0.0.1" "rpcport=1331" "listen=1" "server=1" "daemon=1" "maxconnections=256" "externalip=$mnip" "bind=$mnip" "masternode=1" "masternodeprivkey=$MNPRIVKEY" "masternodeaddr=$mnip:5721" "addnode=sub1x.seeds.mn.zone" > $CONFILE

}

success() {
	zsub1xd
	message "SUCCESS! Your zsub1x has started. Masternode.conf setting below..."
	message "MN $mnip:5721 $MNPRIVKEY TXHASH INDEX"
	exit 0
}

install() {
	prepdependencies
	createswap
	installwallet
	createconf
	success
}

#main
#default to --without-gui
install --without-gui
