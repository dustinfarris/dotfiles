alias run='./manage.py runserver 0.0.0.0:8000'
alias mkenv='mkvirtualenv --python=/usr/local/bin/python3 `basename $PWD` && setvirtualenvproject'
alias pycclean='find . -name "*.pyc" -exec rm {} \;'
alias dsh='./manage.py shell'
alias sm='./manage.py schemamigration'
alias mm='./manage.py makemigrations'
alias ipy='ipython3'
alias activate='source env/bin/activate'
alias gs='git status'
alias nv='nvim'

set --export PYENV_VIRTUALENV_DISABLE_PROMPT 1
set --export DJANGO_ENV local
set --export PATH "/usr/local/opt/openssl/bin:./node_modules/.bin:$PATH"
set --export GPG_TTY (tty)
set --export VISUAL nvim
set --export EDITOR "$VISUAL"
set --export GIT_EDITOR "$VISUAL"
# For curl and anything else: https://stackoverflow.com/questions/32772895/python-pip-install-error-ssl-certificate-verify-failed#37688849
set --export SSL_CERT_FILE /usr/local/etc/openssl@1.1/cert.pem
# for python openssl
set --export LDFLAGS "-L/usr/local/opt/openssl@1.1/lib"
set --export CPPFLAGS "-I/usr/local/opt/openssl@1.1/include"
set --export PKG_CONFIG_PATH "/usr/local/opt/openssl@1.1/lib/pkgconfig"

# for aws-shib
set --export PATH "$HOME/go/bin:$PATH"

# for pyenv
set --export PYENV_ROOT "$HOME/.pyenv"
set --export PATH "$PYENV_ROOT/bin:$PATH"
pyenv init - | source

# remember iex history
set --export ERL_AFLAGS "-kernel shell_history enabled"

# empty greeting
set fish_greeting

# name: Informative Vcs
# author: Mariusz Smykula <mariuszs at gmail.com>

function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -l last_status $status

    if not set -q __fish_git_prompt_show_informative_status
        set -g __fish_git_prompt_show_informative_status 1
    end
    if not set -q __fish_git_prompt_hide_untrackedfiles
        set -g __fish_git_prompt_hide_untrackedfiles 1
    end
    if not set -q __fish_git_prompt_color_branch
        set -g __fish_git_prompt_color_branch white --bold
    end
    if not set -q __fish_git_prompt_showupstream
        set -g __fish_git_prompt_showupstream "informative"
    end
    if not set -q __fish_git_prompt_char_upstream_ahead
        set -g __fish_git_prompt_char_upstream_ahead "↑"
    end
    if not set -q __fish_git_prompt_char_upstream_behind
        set -g __fish_git_prompt_char_upstream_behind "↓"
    end
    if not set -q __fish_git_prompt_char_upstream_prefix
        set -g __fish_git_prompt_char_upstream_prefix ""
    end
    if not set -q __fish_git_prompt_char_stagedstate
        set -g __fish_git_prompt_char_stagedstate "●"
    end
    if not set -q __fish_git_prompt_char_dirtystate
        set -g __fish_git_prompt_char_dirtystate "+"
    end
    if not set -q __fish_git_prompt_char_untrackedfiles
        set -g __fish_git_prompt_char_untrackedfiles "…"
    end
    if not set -q __fish_git_prompt_char_invalidstate
        set -g __fish_git_prompt_char_invalidstate "✖"
    end
    if not set -q __fish_git_prompt_char_cleanstate
        set -g __fish_git_prompt_char_cleanstate "●"
    end
    if not set -q __fish_git_prompt_color_dirtystate
        set -g __fish_git_prompt_color_dirtystate blue
    end
    if not set -q __fish_git_prompt_color_stagedstate
        set -g __fish_git_prompt_color_stagedstate yellow
    end
    if not set -q __fish_git_prompt_color_invalidstate
        set -g __fish_git_prompt_color_invalidstate red
    end
    if not set -q __fish_git_prompt_color_untrackedfiles
        set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
    end
    if not set -q __fish_git_prompt_color_cleanstate
        set -g __fish_git_prompt_color_cleanstate green --bold
    end

    set -l color_cwd
    set -l prefix
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '>'
    end

    echo -n (pyenv_version)

    # PWD
    set_color $color_cwd
    echo -n (prompt_pwd)
    set_color normal

    printf '%s ' (__fish_git_prompt)

    set -l pipestatus_string (__fish_print_pipestatus "[" "] " "|" (set_color yellow) (set_color --bold yellow) $last_pipestatus)
    echo -n "$pipestatus_string"

    if not test $last_status -eq 0
        set_color $fish_color_error
        echo -n "[$last_status] "
        set_color normal
    end

    echo -n "$suffix "
end

function pyenv_version
    if set -q PYENV_VERSION
        set_color "#5f5f5f"
        echo '('$PYENV_VERSION') '
    else
        return 0
    end
end

function fish_right_prompt
  #intentionally left blank
end

function reverse_history_search
  history | fzf --no-sort | read -l command
  if test $command
    commandline -rb $command
  end
end

function fish_user_key_bindings
    fish_vi_key_bindings
    fzf_key_bindings
    # bind \cr reverse_history_search
    # bind $argv \cr history-token-search-backward
    # bind $argv \cg history-token-search-forward
end
