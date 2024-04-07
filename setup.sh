#!/bin/bash

cd
touch ~/.hushlogin

# Update packages
sudo apt update -y
sudo apt upgrade -y

# Install dependencies
sudo apt install git zsh build-essential luarocks cargo dotnet6 ripgrep -y

# Install Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
use exec bash
nvm install 21

# Install NeoVim
sudo snap install nvim --classic
# Install NVChendle
git clone https://github.com/NvChad/starter ~/.config/nvim 

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s $(which zsh)

# Launch NeoVim
nvim
