# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    jq \
    software-properties-common \
    libevent-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Bitcoin Core (v27.0)
RUN wget https://bitcoincore.org/bin/bitcoin-core-27.0/bitcoin-27.0-x86_64-linux-gnu.tar.gz \
    && tar -xzf bitcoin-27.0-x86_64-linux-gnu.tar.gz \
    && mv bitcoin-27.0/bin/* /usr/local/bin/ \
    && rm -rf bitcoin-27.0*

# Install Dogecoin Core (v1.14.8)
RUN wget https://github.com/dogecoin/dogecoin/releases/download/v1.14.8/dogecoin-1.14.8-x86_64-linux-gnu.tar.gz \
    && tar -xzf dogecoin-1.14.8-x86_64-linux-gnu.tar.gz \
    && mv dogecoin-1.14.8/bin/* /usr/local/bin/ \
    && rm -rf dogecoin-1.14.8*

# Install Litecoin Core (v0.21.3)
RUN wget https://download.litecoin.org/litecoin-0.21.3/linux/litecoin-0.21.3-x86_64-linux-gnu.tar.gz \
    && tar -xzf litecoin-0.21.3-x86_64-linux-gnu.tar.gz \
    && mv litecoin-0.21.3/bin/* /usr/local/bin/ \
    && rm -rf litecoin-0.21.3*

# Install Geth for Ethereum via PPA
RUN add-apt-repository -y ppa:ethereum/ethereum \
    && apt-get update \
    && apt-get install -y ethereum \
    && rm -rf /var/lib/apt/lists/*

# Create data directories
RUN mkdir -p /root/.bitcoin /root/.dogecoin /root/.litecoin /root/.ethereum

# Copy configuration files
COPY bitcoin.conf /root/.bitcoin/
COPY dogecoin.conf /root/.dogecoin/
COPY litecoin.conf /root/.litecoin/
COPY geth.json /root/.ethereum/

# Expose RPC and P2P ports
EXPOSE 18444 22556 19335 8545 8333 44555 9333 30303

# Copy balance check script
COPY check_balances.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/check_balances.sh

# Start nodes with logging and keep container running
CMD ["bash", "-c", "\
    bitcoind -regtest -daemon -debuglogfile=/root/.bitcoin/regtest/debug.log & \
    sleep 5 && \
    dogecoind -regtest -daemon -debuglogfile=/root/.dogecoin/regtest/debug.log & \
    sleep 5 && \
    litecoind -regtest -daemon -debuglogfile=/root/.litecoin/regtest/debug.log & \
    sleep 5 && \
    geth --datadir /root/.ethereum --http --http.addr 0.0.0.0 --http.api eth,web3,net,personal --dev --log.file /root/.ethereum/geth.log & \
    tail -f /dev/null"]
    