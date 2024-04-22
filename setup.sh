#!/bin/bash -i

touch ~/.hushlogin

# Get git credentials
read -p "Enter git username: " gitUser
read -p "Enter git email: " gitEmail

# Update packages
sudo apt update -y
sudo apt upgrade -y

# Install dependencies
sudo apt install -y git zsh build-essential luarocks dotnet6 ripgrep exa libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5 python3.10-venv
sudo snap install go --classic

# Set git config
git config --global user.name "$gitUser"
git config --global user.email $gitEmail

# Install Node.js
bash <(curl -s https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 21

# Install Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install Haskell
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_GHC_VERSION=latest BOOTSTRAP_HASKELL_CABAL_VERSION=latest BOOTSTRAP_HASKELL_INSTALL_STACK=1 BOOTSTRAP_HASKELL_INSTALL_HLS=0 BOOTSTRAP_HASKELL_ADJUST_BASHRC=N sh

# Install NeoVim
sudo snap install nvim --classic
# Install NVChendle
git clone https://github.com/KendleMintJed/nvchendle ~/.config/nvim 

# Install lf
env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
sudo cp ~/go/bin/lf /usr/bin/
sudo rm -rf ~/go

# Configure Zsh
sudo chsh -s $(which zsh) $(whoami)
curl -o ~/.zshrc https://raw.githubusercontent.com/KendleMintJed/Ubendle/main/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
curl -o ~/.p10k.zsh https://raw.githubusercontent.com/KendleMintJed/Ubendle/main/.p10k.zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.local/share/zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.local/share/zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.local/share/zsh/zsh-history-substring-search
git clone https://github.com/MichaelAquilina/zsh-you-should-use ~/.local/share/zsh/zsh-you-should-use

# Launch NeoVim
nvim

# Launch Zsh
zsh
