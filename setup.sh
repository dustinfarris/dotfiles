#==============
# Install all the packages
#==============
echo "==== IMPORTANT! ===="
echo
echo "You must disable SIP protection on this machine before homebrew can be installed."
echo "This is done by restarting and entering recovery mode (hold cmd+R)"
echo "and then enter terminal and run `csrutil disable` and then restart"
echo
echo "BUT IT MAY NOT BE NECESSARY!!!!  Maybe MacOS works just fine with the perms it has"
echo "out of the box, so try that first."
echo
echo "===================="
# I really don't think we should have to do this
# sudo chown -R $(whoami):admin /usr/local
# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# brew doctor
# brew update

# So we use all of the packages we are about to install
#echo "export PATH='/usr/local/bin:$PATH'\n" >> ~/.bashrc
#source ~/.bashrc

#==============
# Remove old dot flies
#==============
rm -rf ~/.tmux > /dev/null 2>&1
rm -rf ~/.tmux.conf > /dev/null 2>&1
rm -rf ~/.gitconfig > /dev/null 2>&1
rm -rf ~/.tigrc > /dev/null 2>&1
rm -rf ~/.config > /dev/null 2>&1
rm -rf ~/.doom.d > /dev/null 2>&1
rm -rf ~/Brewfile > /dev/null 2>&1

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
ln -s ~/dotfiles/doom ~/.doom.d
SYMLINKS+=('.doom.d')

echo ${SYMLINKS[@]}

cd ~
brew bundle
cd -
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
ln -sf /usr/local/opt/emacs-plus/Emacs.app /Applications/.

#==============
# Set fish as the default shell
#==============
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish

#==============
# Change screenshot capture location
#==============
defaults write com.apple.screencapture location ~/Documents/Screenshots/
killall SystemUIServer

echo "Restart the shell (fish)"
echo "then run setup.fish"
