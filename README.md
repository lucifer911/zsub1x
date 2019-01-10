# zsub1x
1 liner for zsub1x Master Node
Tested Systems:

-Ubuntu 16.04

To install run the following commands. It will ask you to enter your private key.

wget https://raw.githubusercontent.com/lucifer911/zsub1x/master/install-sub.sh

bash ./install-sub.sh

rm -r install-sub.sh

# Local wallet

Once the script is done It will spit out a line that you need to enter into your masternode.conf file of your local wallet.

MN-label VpsIpAddress:5721 Privatekey Taxid index

Change it according to your needs, save the file and restart the wallet. Once wallet is started and fully sync then you can start you MN form masternode tab.

I am not a developer. All credit go to Chaoabunga.I use his structure and change the codes to my needs. His github is https://github.com/chaoabunga

# Setup 2nd Masternode by using IPV6.

create user

> useradd -m -s /bin/bash sub1

create password 

> passwd sub1

Now copy .zsub1x over to new user

> cp -R /root/.zsub1x /home/sub1

grand owner permission to that folder

> shown -R sub1:sub1 /home/sub1

Now login as sub1 user and do the following to edit the conf file.

> nano .zsub1x/zsub1x.conf

In this file your will change the following

> rcpport=1332

> bind=[ipv6]

> externalip=[IPV6]:5721

> masternodeprivkey=your 2nd private key

hit control "x" then y to save the file and hit enter.

Run 

> zsub1xd 

You can to top to see if both processer running.

# usefull commands

>zsub1xd

>zsub1x-cli getingo

>zsub1x-cli masternode status

>zsub1x-cli stop

#good luch.

donations are always welcome.
BTC :
zsub1x :
