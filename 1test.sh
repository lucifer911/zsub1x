
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

# Get a new privatekey by going to console >> debug and typing smartnode genkey
pvkey() { #TODO: get pvkey
	message "Get a new privatekey by going to console >> debug and typing smartnode genkey"
	printf "Masternode GenKey: "
	read _nodePrivateKey
}

createconf() {
	#TODO: Can check for flag and skip this
	#TODO: Random generate the user and password

	message "Creating chaincoin.conf..."
	CONFDIR=~/.zsub1x
	CONFILE=$CONFDIR/zsub1x.conf
	if [ ! -d "$CONFDIR" ]; then mkdir $CONFDIR; fi
	if [ $? -ne 0 ]; then error; fi
	mnip=$(curl -s https://api.ipify.org)
	rpcuser=$(date +%s | sha256sum | base64 | head -c 10 ; echo)
	rpcpass=$(openssl rand -base64 32)
	printf "%s\n" "rpcuser=$rpcuser" "rpcpassword=$rpcpass" "rpcallowip=127.0.0.1" "rpcport=1331" "listen=1" "server=1" "daemon=1" "maxconnections=256" "externalip=$mnip" "bind=$mnip" "masternode=1" "masternodeprivkey=${_nodePrivateKey}" "masternodeaddr=$mnip:5721" "addnode=sub1x.seeds.mn.zone" > $CONFILE
       
        zsub1xd
        message "Wait 10 seconds for daemon to load..."
        sleep 20s
        MNPRIVKEY=$(zsub1x-cli masternode genkey)
		zsub1x-cli stop
		message "wait 10 seconds for deamon to stop..."
        sleep 10s
		sudo rm $CONFILE
		message "Updating chaincoin.conf..."
        printf "%s\n" "rpcuser=$rpcuser" "rpcpassword=$rpcpass" "rpcallowip=127.0.0.1" "rpcport=1331" "listen=1" "server=1" "daemon=1" "maxconnections=256" "externalip=$mnip" "bind=$mnip" "masternode=1" "masternodeprivkey=${_nodePrivateKey}" "masternodeaddr=$mnip:5721" "addnode=sub1x.seeds.mn.zone" > $CONFILE

}

install() {
	pvkey
  createconf
}

#main
#default to --without-gui
