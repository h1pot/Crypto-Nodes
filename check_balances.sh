#!/bin/bash

# Bitcoin balance
echo "Checking Bitcoin balance..."
bitcoin-cli -regtest -rpcport=18444 -rpcuser=bitcoinuser -rpcpassword=bitcoinpass getbalance

# Dogecoin balance
echo "Checking Dogecoin balance..."
dogecoin-cli -regtest -rpcport=22556 -rpcuser=dogeuser -rpcpassword=dogepass getbalance

# Litecoin balance
echo "Checking Litecoin balance..."
litecoin-cli -regtest -rpcport=19335 -rpcuser=liteuser -rpcpassword=litepass getbalance

# Ethereum balance
echo "Checking Ethereum balance..."
ACCOUNT_ADDRESS=$(geth --exec 'eth.accounts[0]' attach http://localhost:8545 2>/dev/null | tr -d '"')
if [ -n "$ACCOUNT_ADDRESS" ]; then
  BALANCE=$(geth --exec "web3.fromWei(eth.getBalance('$ACCOUNT_ADDRESS'), 'ether').toFixed(0)" attach http://localhost:8545 2>/dev/null)
  echo "Balance for $ACCOUNT_ADDRESS: $BALANCE ETH"
else
  echo "No Ethereum account found. Create one using: geth --datadir /root/.ethereum account new"
fi