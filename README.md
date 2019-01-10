# zsub1x
1 liner for zsub1x Master Node
Tested Systems:

-Ubuntu 16.04

use the following line to install the 1 liner. 

curl https://raw.githubusercontent.com/lucifer911/zsub1x/master/install.sh | bash

After script is done. you need to do the following.

zsub1x-cli stop

cd .zsub1x

nano zsub1x.conf 

enter your privkey, save the file by "control X" then hit "Y" and then hit enter.

start the deamon by zsub1xd

# Local wallet

Once the script is done It will spit out a line that you need to enter into your masternode.conf file of your local wallet.

MN-label VpsIpAddress:5721 Privatekey Taxid index

Change it according to your needs, save the file and restart the wallet. Once wallet is started and fully sync then you can start you MN form masternode tab.

I am not a developer. All credit go to Chaoabunga.I use his structure and change the codes to my needs. His github is https://github.com/chaoabunga
