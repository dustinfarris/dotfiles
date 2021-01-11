Install Homebrew first
	
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

NOTE that you do NOT need to sudo or chown ANYTHING!

then install fonts:

	brew tap homebrew/cask-fonts
	brew cask install font-hack-nerd-font

then insstall base packages and change shell to fish:

	zsh setup.sh

restart shell, then install a few more dependencies:

	fish setup.fish

restart shell, then do the following (this doesn't script so well):

Set up python for neovim:

Install pyenv:

	curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
	pyenv init - | source
	pyenv virtualenv-init - | source

When updating the python version, the path in config/nvim/init.vim will need
to be updated as well

## Python 2
	pyenv install 2.7.17
	pyenv virtualenv 2.7.17 neovim2
	pyenv activate neovim2
	pip install neovim
## Python 3
	pyenv install 3.8.0
	pyenv virtualenv 3.8.0 neovim3
	pyenv activate neovim3
	pip install neovim
	pip install flake8
	ln -s (pyenv which flake8) /usr/local/bin/flake8

Finally, start neovim and UpdateRemotePlugins and PlugInstall
