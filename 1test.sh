
#!/bin/sh
#Version 0.1.1.3
mkdir a
touch a/a.conf
read -p "Enter server names separated by 'space' : " input

for i in ${input[@]}
do
echo ""
echo "User entered value :"$i    # or do whatever with individual element of the array
echo ""
done

echo "rpcuser=${_rpcUserName}
rpcpassword=${_rpcPassword}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
masternode=1
masternodeprivkey=${_nodePrivateKey}
" > a.conf

cat a/a.conf
