#!/bin/bash -i

# Get git credentials
read -p "Enter git email: " gitEmail
read -p "Enter git username: " gitUser
read -p "Enter git token: " gitToken
read -p "Enter git host: " gitHost

# Update packages
sudo pacman -Syu --noconfirm

# Install dependencies
sudo pacman -S --noconfirm --needed $(curl -s https://raw.githubusercontent.com/KendleMintJed/Linuxendle/arch/packages.txt)
# Install fzf
git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc
git clone https://github.com/junegunn/fzf-git.sh.git --depth=1 ~/.fzf-git.sh

# Set git config
curl -o ~/.gitconfig https://raw.githubusercontent.com/KendleMintJed/Linuxendle/arch/.gitconfig
git config --global user.name "$gitUser"
git config --global user.email $gitEmail
echo "https://$gitUser:$gitToken@$gitHost" > ~/.git-credentials

# Set lazygit config
mkdir -p ~/.config/lazygit
curl -o ~/.config/lazygit/config.yml https://raw.githubusercontent.com/kendlemintjed/Linuxendle/arch/lazygit.config.yml

# Install Node.js
bash < (curl -s https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 21

# Install Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install Haskell
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_GHC_VERSION=latest BOOTSTRAP_HASKELL_CABAL_VERSION=latest BOOTSTRAP_HASKELL_INSTALL_STACK=1 BOOTSTRAP_HASKELL_INSTALL_HLS=0 BOOTSTRAP_HASKELL_ADJUST_BASHRC=N sh
curl -o ~/.ghci https://raw.githubusercontent.com/KendleMintJed/Linuxendle/arch/.ghci

# Install NVChendle
git clone https://github.com/KendleMintJed/nvchendle ~/.config/nvim 

# Configure Zsh
sudo chsh -s $(which zsh) $(whoami)
curl -o ~/.zshrc https://raw.githubusercontent.com/KendleMintJed/Linuxendle/arch/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
curl -o ~/.p10k.zsh https://raw.githubusercontent.com/KendleMintJed/Linuxendle/arch/.p10k.zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.local/share/zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.local/share/zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.local/share/zsh/zsh-history-substring-search
git clone https://github.com/MichaelAquilina/zsh-you-should-use ~/.local/share/zsh/zsh-you-should-use

# Autoremove packages
sudo pacman -R --noconfirm $(pacman -Qdtq)

# Launch NeoVim
nvim

# Launch Zsh
zsh
