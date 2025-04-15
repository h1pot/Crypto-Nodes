# Crypto Nodes

This project sets up a Docker container running four cryptocurrency nodes in regtest (Bitcoin, Dogecoin, Litecoin) and dev mode (Ethereum). It includes a script to check wallet balances for each node. The setup is designed for testing and development, with pre-configured wallets and RPC access.

## Features
- **Bitcoin Core** (v27.0): Regtest mode, RPC port `18444`.
- **Dogecoin Core** (v1.14.8): Regtest mode, RPC port `22556`, P2P port `44555`.
- **Litecoin Core** (v0.21.3): Regtest mode, RPC port `19335`.
- **Ethereum (Geth)**: Dev mode, HTTP RPC port `8545`.
- **Balance Checker**: Script (`check_balances.sh`) to display wallet balances for all nodes.

## Prerequisites
- **Docker**: Installed and running (Docker Desktop on Windows).
- **Disk Space**: ~2GB for node binaries and blockchain data.
- **Ports**: Ensure `18444`, `22556`, `19335`, `8545`, `44555` are free.

## Project Structure
crypto-nodes/
├── Dockerfile
├── bitcoin.conf
├── dogecoin.conf
├── litecoin.conf
├── geth.json
├── check_balances.sh
└── README.md

- **Dockerfile**: Defines the container with node installations and startup commands.
- **bitcoin.conf**: Bitcoin regtest configuration.
- **dogecoin.conf**: Dogecoin regtest configuration (avoids port conflicts).
- **litecoin.conf**: Litecoin regtest configuration.
- **geth.json**: Ethereum genesis file for dev mode.
- **check_balances.sh**: Script to check balances for all wallets.

## Setup Instructions

### 1. Clone or Prepare Files
Ensure all files (`Dockerfile`, `bitcoin.conf`, `dogecoin.conf`, `litecoin.conf`, `geth.json`, `check_balances.sh`) are in the project directory (e.g., `F:\Dropbox\@Wady\2025\crypto-nodes`).

### 2. Build the Docker Image
Navigate to the project directory in a terminal:
```bash
cd /home/user/crypto-nodes

Build the image:
docker build -t crypto-nodes .

### 3. Run the Container
Start the container, mapping RPC ports:
docker run -d -p 18444:18444 -p 22556:22556 -p 19335:19335 -p 8545:8545 --name crypto-nodes crypto-nodes

### 4. Access the Container
Enter the container’s shell:
docker exec -it crypto-nodes bash

### 5. Verify Nodes
Check running processes:
ps aux | grep -E 'bitcoind|dogecoind|litecoind|geth'

Expected output includes bitcoind, dogecoind, litecoind, and geth.

Test node connectivity:
bitcoin-cli -regtest -rpcport=18444 getblockchaininfo
dogecoin-cli -regtest -rpcport=22556 getblockchaininfo
litecoin-cli -regtest -rpcport=19335 getblockchaininfo
geth --exec 'eth.blockNumber' attach http://localhost:8545

### 6. Create Wallets
Create wallets for testing:
bitcoin-cli -regtest -rpcport=18444 createwallet "testwallet"
dogecoin-cli -regtest -rpcport=22556 getnewaddress
litecoin-cli -regtest -rpcport=19335 createwallet "testwallet"
geth --datadir /root/.ethereum account new

## Dogecoin uses the default wallet (wallet.dat) since v1.14.8 doesn’t support createwallet.
## Save the Ethereum account password securely.

### 7. Generate Test Funds
Mine blocks to fund wallets (regtest requires 100 blocks for coinbase maturity):
bitcoin-cli -regtest -rpcport=18444 generatetoaddress 101 $(bitcoin-cli -regtest -rpcport=18444 getnewaddress)
dogecoin-cli -regtest -rpcport=22556 generatetoaddress 101 $(dogecoin-cli -regtest -rpcport=22556 getnewaddress)
litecoin-cli -regtest -rpcport=19335 generatetoaddress 101 $(litecoin-cli -regtest -rpcport=19335 getnewaddress)
Ethereum’s dev mode pre-funds accounts (no mining needed).

### 8. Check Balances
Run the balance checker:
bash /usr/local/bin/check_balances.sh

Expected output:
Checking Bitcoin balance...
50.00000000
Checking Dogecoin balance...
50.00000000
Checking Litecoin balance...
50.00000000
Checking Ethereum balance...
Balance for 0x...: 115792089237316195423570985008687907853269984665564039457584007913129639927 ETH

### 9. Save the Setup
Commit the container to preserve wallets and funds:
docker commit crypto-nodes crypto-nodes:working

Restart later:
docker run -d -p 18444:18444 -p 22556:22556 -p 19335:19335 -p 8545:8545 --name crypto-nodes crypto-nodes:working

### Persistence
Regtest data is ephemeral unless persisted. To keep wallets:

## Use a Docker volume:
docker run -d -p 18444:18444 -p 22556:22556 -p 19335:19335 -p 8545:8545 \
  -v crypto_data:/root --name crypto-nodes crypto-nodes

## Backup wallets:
docker cp crypto-nodes:/root/.bitcoin/regtest/wallet.dat ./bitcoin_wallet.dat
docker cp crypto-nodes:/root/.dogecoin/regtest/wallet.dat ./dogecoin_wallet.dat
docker cp crypto-nodes:/root/.litecoin/regtest/wallet.dat ./litecoin_wallet.dat
docker cp crypto-nodes:/root/.ethereum/keystore ./ethereum_keystore

### Troubleshooting

## Port Conflicts: Check ports:
netstat -tuln | grep -E '18444|22556|19335|8545|44555'
Update dogecoin.conf (e.g., rpcport=22557) if needed.

## Node Not Running: Check logs:
cat /root/.bitcoin/regtest/debug.log
cat /root/.dogecoin/regtest/debug.log
cat /root/.litecoin/regtest/debug.log
cat /root/.ethereum/geth.log

## Balance Issues: Verify block count:
bitcoin-cli -regtest -rpcport=18444 getblockcount
dogecoin-cli -regtest -rpcport=22556 getblockcount
litecoin-cli -regtest -rpcport=19335 getblockcount

## Ethereum Balance Display: If scientific notation persists:
geth --exec "web3.fromWei(eth.getBalance('0x...'), 'ether').toFixed(0)" attach http://localhost:8545

### License

### Instructions
1. Copy the above Markdown content.
2. Paste it into a new file named `README.md` in `F:\Dropbox\@Wady\2025\crypto-nodes`.
3. Save the file.

### Verification
To ensure everything works with the README:
1. Confirm all files are in `F:\Dropbox\@Wady\2025\crypto-nodes`:
   - `Dockerfile`
   - `bitcoin.conf`
   - `dogecoin.conf`
   - `litecoin.conf`
   - `geth.json`
   - `check_balances.sh`
   - `README.md`
2. Follow the README’s setup steps:
   ```bash
   cd F:\Dropbox\@Wady\2025\crypto-nodes
   docker build -t crypto-nodes .
   docker rm -f crypto-nodes
   docker run -d -p 18444:18444 -p 22556:22556 -p 19335:19335 -p 8545:8545 --name crypto-nodes crypto-nodes
   docker exec -it crypto-nodes bash

Run through steps 5–8 (verify nodes, create wallets, generate funds, check balances).
Share the output of:
 check_balances.sh






