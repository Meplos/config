#!/bin/bash

echo "Installing packages "
apt install clang \
	gcc \
	g++ \
	curl \
	git \
	wget \
	python3 \
	lazygit \
	ripgrep -y

apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y

type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
	sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
	sudo apt update &&
	sudo apt install gh -y

echo "Set up cargo"
curl https://sh.rustup.rs -sSf | sh

echo "Set up Go"
curl https://go.dev/dl/go1.21.6.linux-amd64.tar.gz --output go.tar.gz
tar -C /usr/local -xzf go.tar.gz

echo "Set up node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install 14
nvm use 14 --default
npm i -g yarn
npm i -g neovim

echo "setup java"
curl -s "https://get.sdkman.io" | bash
source $HOME/.zshrc
sdk install gradle
sdk install java 14.0.2-open
curl https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz --output maven.tar.gz
rm -rf maven.tar.gz
mkdir $HOME/.gradle $HOME/.m2
touch $HOME/.gradle/gradle.properties
touch $HOME/.m2/settings.xml

echo "Install alacritty"
git clone https://github.com/alacritty/alacritty/

cd "alacritty"
cargo build --release
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
cd $HOME
cp -rf $HOME/config/alacritty/ $HOME/.config

echo "Set up Lazyvim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv ./nvim.appimage /usr/local/bin/nvim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf $HOME/.config/.git

echo "Set up tmux"
apt install tmux -y
cp -rf $HOME/config/tmux $HOME/.config/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Set up ZSH"
apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
apt install fd-find fzf -y
cp $HOME/config/.zshrc $HOME
echo "export PATH=$PATH:/usr/local/go/bin" >>$HOME/.zshrc
echo "export PATH=$PATH:$HOME/apache-maven-3.9.6/bin/" >>$HOME/.zshrc

git config --global user.email "alexandre.erard@ubleam.com"
git config --global user.name "Alexandre Erard"
gh auth login
