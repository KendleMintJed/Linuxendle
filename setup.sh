#!/bin/bash -i

touch ~/.hushlogin

# Get git credentials
read -p "Enter git username: " gitUser
read -p "Enter git email: " gitEmail

# Update packages
sudo apt update -y
sudo apt upgrade -y

# Install dependencies
sudo apt install git zsh build-essential luarocks cargo dotnet6 ripgrep -y

# Set git config
git config --global user.name "$gitUser"
git config --global user.email $gitEmail

# Install Node.js
bash <(curl -s https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh)
. ~/.bashrc
nvm install 21

# Install NeoVim
sudo snap install nvim --classic
# Install NVChendle
git clone https://github.com/NvChad/starter ~/.config/nvim 

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo chsh -s $(which zsh) $(whoami)
curl -o ~/.zshrc https://raw.githubusercontent.com/KendleMintJed/Ubendle/main/.zshrc

# Launch NeoVim
nvim
