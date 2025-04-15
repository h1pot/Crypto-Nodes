# Crypto Nodes

This project deploys a Docker container with cryptocurrency nodes in regtest mode (Bitcoin, Dogecoin, Litecoin) and dev mode (Ethereum). It's optimized for testing and development purposes, featuring pre-configured wallets, RPC access, and balance checking.

## Features
- **Bitcoin Core (v27.0)**: Regtest, RPC port `18444`
- **Dogecoin Core (v1.14.8)**: Regtest, RPC port `22556`, P2P port `44555`
- **Litecoin Core (v0.21.3)**: Regtest, RPC port `19335`
- **Ethereum (Geth)**: Dev mode, HTTP RPC port `8545`
- **Balance Checker**: Convenient script (`check_balances.sh`) to display wallet balances

## Prerequisites
- **Docker**: Ensure Docker Desktop is installed and running
- **Disk Space**: Approximately 2GB
- **Available Ports**: `18444`, `22556`, `19335`, `8545`, `44555`

## Project Structure
```
crypto-nodes/
├── Dockerfile
├── bitcoin.conf
├── dogecoin.conf
├── litecoin.conf
├── geth.json
├── check_balances.sh
└── README.md
```

## Setup Instructions

### 1. Prepare Files
Ensure all necessary files (`Dockerfile`, config files, `check_balances.sh`) are in your project directory, e.g., `/home/user/crypto-nodes`.

### 2. Build Docker Image
```bash
cd /home/user/crypto-nodes
docker build -t crypto-nodes .
```

### 3. Run the Container
```bash
docker run -d \
  -p 18444:18444 -p 22556:22556 -p 19335:19335 -p 8545:8545 \
  --name crypto-nodes crypto-nodes
```

### 4. Access Container Shell
```bash
docker exec -it crypto-nodes bash
```

### 5. Verify Nodes
Confirm nodes are operational:
```bash
ps aux | grep -E 'bitcoind|dogecoind|litecoind|geth'
```
Test connectivity:
```bash
bitcoin-cli -regtest -rpcport=18444 getblockchaininfo
dogecoin-cli -regtest -rpcport=22556 getblockchaininfo
litecoin-cli -regtest -rpcport=19335 getblockchaininfo
geth --exec 'eth.blockNumber' attach http://localhost:8545
```

### 6. Wallet Creation
Generate wallets:
```bash
bitcoin-cli -regtest -rpcport=18444 createwallet "testwallet"
dogecoin-cli -regtest -rpcport=22556 getnewaddress
litecoin-cli -regtest -rpcport=19335 createwallet "testwallet"
geth --datadir /root/.ethereum account new
```
*Note: Dogecoin utilizes the default wallet (`wallet.dat`). Securely store Ethereum wallet passwords.*

### 7. Generate Test Funds
Regtest mode requires mining blocks for coinbase maturity:
```bash
bitcoin-cli -regtest -rpcport=18444 generatetoaddress 101 $(bitcoin-cli -regtest -rpcport=18444 getnewaddress)
dogecoin-cli -regtest -rpcport=22556 generatetoaddress 101 $(dogecoin-cli -regtest -rpcport=22556 getnewaddress)
litecoin-cli -regtest -rpcport=19335 generatetoaddress 101 $(litecoin-cli -regtest -rpcport=19335 getnewaddress)
```
Ethereum dev mode accounts are pre-funded.

### 8. Check Balances
Use the balance checker script:
```bash
bash /usr/local/bin/check_balances.sh
```

Expected results:
```
Checking Bitcoin balance...
50.00000000
Checking Dogecoin balance...
50.00000000
Checking Litecoin balance...
50.00000000
Checking Ethereum balance...
Balance for 0x...: 115792089237316195423570985008687907853269984665564039457584007913129639927 ETH
```

### 9. Persist Setup
Save your container state to preserve wallets:
```bash
docker commit crypto-nodes crypto-nodes:working
```
Restart:
```bash
docker run -d -p 18444:18444 -p 22556:22556 -p 19335:19335 -p 8545:8545 --name crypto-nodes crypto-nodes:working
```

### Persistent Data
Persist wallets and blockchain data:
- **Docker volume**:
```bash
docker run -d -p 18444:18444 -p 22556:22556 -p 19335:19335 -p 8545:8545 \
  -v crypto_data:/root --name crypto-nodes crypto-nodes
```

- **Backup wallets**:
```bash
docker cp crypto-nodes:/root/.bitcoin/regtest/wallet.dat ./bitcoin_wallet.dat
docker cp crypto-nodes:/root/.dogecoin/regtest/wallet.dat ./dogecoin_wallet.dat
docker cp crypto-nodes:/root/.litecoin/regtest/wallet.dat ./litecoin_wallet.dat
docker cp crypto-nodes:/root/.ethereum/keystore ./ethereum_keystore
```

### Troubleshooting
- **Port Conflicts**:
```bash
netstat -tuln | grep -E '18444|22556|19335|8545|44555'
```
Modify `dogecoin.conf` if needed.

- **Node Issues**:
Check logs:
```bash
cat /root/.bitcoin/regtest/debug.log
cat /root/.dogecoin/regtest/debug.log
cat /root/.litecoin/regtest/debug.log
cat /root/.ethereum/geth.log
```

- **Balance Issues**:
Confirm blockchain height:
```bash
bitcoin-cli -regtest -rpcport=18444 getblockcount
dogecoin-cli -regtest -rpcport=22556 getblockcount
litecoin-cli -regtest -rpcport=19335 getblockcount
```

- **Ethereum Balance Display**:
Avoid scientific notation:
```bash
geth --exec "web3.fromWei(eth.getBalance('0x...'), 'ether').toFixed(0)" attach http://localhost:8545
```

## License

This project is for educational purposes. Use at your own risk.

## Final Verification
To ensure everything works with the README:
1. Confirm all files are in `/home/user/crypto-nodes`:
   - `Dockerfile`
   - `bitcoin.conf`
   - `dogecoin.conf`
   - `litecoin.conf`
   - `geth.json`
   - `check_balances.sh`
   - `README.md`
2. Follow the README’s setup steps:
   ```bash
   cd /home/user/crypto-nodes
   docker build -t crypto-nodes .
   docker rm -f crypto-nodes
   docker run -d -p 18444:18444 -p 22556:22556 -p 19335:19335 -p 8545:8545 --name crypto-nodes crypto-nodes
   docker exec -it crypto-nodes bash

Run through steps 5–8 (verify nodes, create wallets, generate funds, check balances).
Share the output of:
 check_balances.sh
