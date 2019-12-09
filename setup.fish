#==============
# Install fisher
#==============
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

#==============
# Install vim-plug for neovim
#==============
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#==============
# Set up python for neovim
#==============
# Install pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source
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
