#==============
# Install fisher
#==============
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end


#==============
# Install NVM
#==============
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash


#==============
# Install vim-plug for neovim
#==============
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim



#==============
# And we are done
#==============
echo -e "\n====== All Done!! ======\n"
echo
echo "Don't forget to run :UpdateRemotePlugins in neovim"
