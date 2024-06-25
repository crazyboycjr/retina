#!/bin/bash

# Install the required tools and dependencies
sudo apt-get update && sudo apt-get install -y lsb-release wget software-properties-common gnupg man-db pv

# Install LLVM 16
export LLVM_VERSION=16
curl -sL https://apt.llvm.org/llvm.sh | sudo bash -s "$LLVM_VERSION"

# export
echo 'alias k=kubectl' >> ~/.bashrc
echo 'export PATH=/usr/lib/llvm-16/bin/:$PATH' >> ~/.bashrc