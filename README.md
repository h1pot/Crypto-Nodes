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


### 5. Verify Nodes


### 6. Create Wallets


### 7. Generate Test Funds


### 8. Check Balances


### 9. Save the Setup


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


## Node Not Running: Check logs:


## Balance Issues: Verify block count:


## Ethereum Balance Display: If scientific notation persists:

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






