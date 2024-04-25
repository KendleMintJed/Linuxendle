#!/bin/bash -i

touch ~/.hushlogin

# Get git credentials
read -p "Enter git email: " gitEmail
read -p "Enter git username: " gitUser
read -p "Enter git token: " gitToken
read -p "Enter git host: " gitHost

# Update packages
sudo apt update -y
sudo apt upgrade -y

# Install dependencies
sudo apt install -y git zsh build-essential luarocks dotnet6 ripgrep libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5 python3 python3.10-venv pip gdb
sudo snap install go --classic

# Install LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit
curl -o ~/.config/lazygit/config.yml https://raw.githubusercontent.com/KendleMintJed/Ubendle/main/lazygit.config.yml

# Install fzf
git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc
git clone https://github.com/junegunn/fzf-git.sh.git --depth=1 ~/.fzf-git.sh

# Set git config
curl -o ~/.gitconfig https://raw.githubusercontent.com/KendleMintJed/Ubendle/main/.gitconfig
git config --global user.name "$gitUser"
git config --global user.email $gitEmail
echo "https://$gitUser:$gitToken@$gitHost" > touch ~/.git-credentials

# Install Node.js
bash <(curl -s https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 21

# Install Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install eza
cargo install eza
# Install bat
cargo install bat --locked
# Install fd
cargo install fd-find
# Install git-delta
cargo install git-delta
# Install tldr
cargo install tlrc
# Install zoxide
cargo install zoxide --locked

# Install Haskell
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_GHC_VERSION=latest BOOTSTRAP_HASKELL_CABAL_VERSION=latest BOOTSTRAP_HASKELL_INSTALL_STACK=1 BOOTSTRAP_HASKELL_INSTALL_HLS=0 BOOTSTRAP_HASKELL_ADJUST_BASHRC=N sh
curl -o ~/.ghci https://raw.githubusercontent.com/KendleMintJed/Ubendle/main/.ghci

# Install NeoVim
sudo snap install nvim --classic
# Install NVChendle
git clone https://github.com/KendleMintJed/nvchendle ~/.config/nvim 

# Configure Zsh
sudo chsh -s $(which zsh) $(whoami)
curl -o ~/.zshrc https://raw.githubusercontent.com/KendleMintJed/Ubendle/main/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
curl -o ~/.p10k.zsh https://raw.githubusercontent.com/KendleMintJed/Ubendle/main/.p10k.zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.local/share/zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.local/share/zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.local/share/zsh/zsh-history-substring-search
git clone https://github.com/MichaelAquilina/zsh-you-should-use ~/.local/share/zsh/zsh-you-should-use

# Autoremove packages
sudo apt autoremove -y

# Launch NeoVim
nvim

# Launch Zsh
zsh
