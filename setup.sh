#==============
# Install all the packages
#==============
sudo chown -R $(whoami):admin /usr/local
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew update

# So we use all of the packages we are about to install
echo "export PATH='/usr/local/bin:$PATH'\n" >> ~/.bashrc
source ~/.bashrc

#==============
# Remove old dot flies
#==============
sudo rm -rf ~/.tmux > /dev/null 2>&1
sudo rm -rf ~/.tmux.conf > /dev/null 2>&1
sudo rm -rf ~/.gitconfig > /dev/null 2>&1
sudo rm -rf ~/.tigrc > /dev/null 2>&1
sudo rm -rf ~/.config > /dev/null 2>&1
sudo rm -rf ~/Brewfile > /dev/null 2>&1

#==============
# Create symlinks in the home folder
#==============
SYMLINKS=()
ln -sf ~/dotfiles/tmux ~/.tmux
SYMLINKS+=('.tmux')
ln -sf ~/dotfiles/config ~/.config
SYMLINKS+=('.config')
ln -sf ~/dotfiles/Brewfile ~/Brewfile
SYMLINKS+=('Brewfile')
ln -s ~/dotfiles/gitconfig ~/.gitconfig
SYMLINKS+=('.gitconfig')
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
SYMLINKS+=('.tmux.conf')
ln -s ~/dotfiles/tigrc ~/.tigrc
SYMLINKS+=('.tigrc')

echo ${SYMLINKS[@]}

cd ~
brew bundle
cd -

#==============
# Install vim-plug for neovim
#==============
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#==============
# Set fish as the default shell
#==============
chsh -s /usr/local/bin/fish

#==============
# Set up python for neovim
#==============
# Install pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
exec $SHELL
# When updating the python version, the path in config/nvim/init.vim will need
# to be updated as well
# == Python 2
pyenv install 2.7.17
pyenv virtualenv 2.7.17 neovim2
pyenv activate neovim2
pip install neovim
# == Python 3
pyenv install 3.8.0
pyenv virtualenv 3.8.0 neovim3
pyenv activate neovim3
pip install neovim
pip install flake8
ln -s (pyenv which flake8) /usr/local/bin/flake8


#==============
# And we are done
#==============
echo -e "\n====== All Done!! ======\n"
echo
echo "Don't forget to run :UpdateRemotePlugins in neovim"
