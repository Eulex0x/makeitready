#!/bin/bash

set -e

echo "[*] Updating system..."
sudo apt update -y && sudo apt install -y git make gcc unzip wget

# Install Go 1.24.2 if not installed
if ! command -v go &> /dev/null; then
    echo "[*] Installing Go 1.24.2..."
    wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.profile
    source ~/.profile
    rm go1.24.2.linux-amd64.tar.gz
fi

# Set Go environment immediately
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

# Install MassDNS
echo "[*] Installing MassDNS..."
git clone https://github.com/blechschmidt/massdns.git
cd massdns
make
sudo cp bin/massdns /usr/local/bin/
cd ..
rm -rf massdns

# Install Shuffledns
echo "[*] Installing Shuffledns..."
GO111MODULE=on go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
sudo cp ~/go/bin/shuffledns /usr/local/bin/

# Confirm installation
echo "[*] Verifying installation..."
if command -v massdns &> /dev/null && command -v shuffledns &> /dev/null; then
    echo "[+] Installation completed successfully!"
else
    echo "[-] Something went wrong!"
    exit 1
fi