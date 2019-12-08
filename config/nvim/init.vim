" Core configuration {
let g:python_host_prog = $HOME . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'
" }

" Plugins {
call plug#begin(stdpath('data') . '/plugged')
" Deoplete - Async completion {
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
" }
" Ale - Linting (syntax checking and semantic errors) {
Plug 'dense-analysis/ale'
let g:ale_set_highlights = 0
let g:ale_pattern_options = {
			\  '\.py$': {
			\    'ale_linters': ['flake8']
			\   },
			\  '_test\.py$': {
			\    'ale_linters': [],
			\  }
			\}
let g:ale_fixers = {
			\   '*': ['remove_trailing_lines', 'trim_whitespace'],
			\   'javascript': ['prettier', 'eslint'],
			\   'typescript': ['prettier', 'eslint'],
			\}
let g:ale_fix_on_save = 1
map ;j <silent> :ALENext<CR>
map ;k <silent> :ALEPrevious<CR>
" }
" Commentary - Easily comment/uncomment blocks of text {
Plug 'tpope/vim-commentary'
" }
" Auto Pairs - Automatically add closing characters e.g. [ ] {
Plug 'jiangmiao/auto-pairs'
" }
" Sneak - Jump to next 2 character pattern {
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
" }
" Startify - Menu whenever neovim starts {
Plug 'mhinz/vim-startify'
" Don't change the directory when opening a recent file with a shortcut
let g:startify_change_to_dir = 0
" Disable the banner
let g:startify_custom_header = []
" The number of files to list.
let g:startify_show_files_number = 10
" A list of files to bookmark. Always shown
let g:startify_bookmarks = []
" Replace startify buffer when opening file from vimfiler
autocmd User Startified setlocal buftype=

" }
" Defx - Browsing files {
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
" Git
let g:defx_git#column_length=1
let g:defx_git#show_ignored=0
let g:defx_git#raw_mode=0
nnoremap ;n :Defx -split=vertical -winwidth=35 -direction=topleft -columns=git:icons:filename:type -toggle -search=`expand('%:p')` `getcwd()`<CR>
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
	" Define mappings
	nnoremap <silent><buffer><expr> <CR>
				\ defx#do_action('drop')
	nnoremap <silent><buffer><expr> c
				\ defx#do_action('copy')
	nnoremap <silent><buffer><expr> m
				\ defx#do_action('move')
	nnoremap <silent><buffer><expr> p
				\ defx#do_action('paste')
	nnoremap <silent><buffer><expr> l
				\ defx#do_action('open')
	nnoremap <silent><buffer><expr> E
				\ defx#do_action('open', 'vsplit')
	nnoremap <silent><buffer><expr> P
				\ defx#do_action('open', 'pedit')
	nnoremap <silent><buffer><expr> o
				\ defx#do_action('open_or_close_tree')
	nnoremap <silent><buffer><expr> K
				\ defx#do_action('new_directory')
	nnoremap <silent><buffer><expr> N
				\ defx#do_action('new_file')
	nnoremap <silent><buffer><expr> M
				\ defx#do_action('new_multiple_files')
	nnoremap <silent><buffer><expr> C
				\ defx#do_action('toggle_columns',
				\                'mark:indent:icon:filename:type:size:time')
	nnoremap <silent><buffer><expr> S
				\ defx#do_action('toggle_sort', 'time')
	nnoremap <silent><buffer><expr> d
				\ defx#do_action('remove')
	nnoremap <silent><buffer><expr> r
				\ defx#do_action('rename')
	nnoremap <silent><buffer><expr> !
				\ defx#do_action('execute_command')
	nnoremap <silent><buffer><expr> x
				\ defx#do_action('execute_system')
	nnoremap <silent><buffer><expr> yy
				\ defx#do_action('yank_path')
	nnoremap <silent><buffer><expr> .
				\ defx#do_action('toggle_ignored_files')
	nnoremap <silent><buffer><expr> ;
				\ defx#do_action('repeat')
	nnoremap <silent><buffer><expr> h
				\ defx#do_action('cd', ['..'])
	nnoremap <silent><buffer><expr> ~
				\ defx#do_action('cd')
	nnoremap <silent><buffer><expr> q
				\ defx#do_action('quit')
	nnoremap <silent><buffer><expr> <Space>
				\ defx#do_action('toggle_select') . 'j'
	nnoremap <silent><buffer><expr> *
				\ defx#do_action('toggle_select_all')
	nnoremap <silent><buffer><expr> j
				\ line('.') == line('$') ? 'gg' : 'j'
	nnoremap <silent><buffer><expr> k
				\ line('.') == 1 ? 'G' : 'k'
	nnoremap <silent><buffer><expr> <C-l>
				\ defx#do_action('redraw')
	nnoremap <silent><buffer><expr> <C-g>
				\ defx#do_action('print')
	nnoremap <silent><buffer><expr> cd
				\ defx#do_action('change_vim_cwd')
endfunction
" }
" FZF - Fuzzy finder {
Plug 'junegunn/fzf'
noremap <Leader>f :call fzf#run({'source': 'git ls-files', 'sink': 'e', 'down': '20%'})<CR>
" }
" FT: beancount {
Plug 'nathangrigg/vim-beancount'
inoremap php PHP<C-\><C-O>:AlignCommodity<CR>
inoremap php PHP<C-\><C-O>:AlignCommodity<CR>
nnoremap <buffer> <leader>= :AlignCommodity<CR>
vnoremap <buffer> <leader>= :AlignCommodity<CR>
" }
" FT: fish {
Plug 'dag/vim-fish'
" }
" FT: terraform {
Plug 'hashivim/vim-terraform'
" }
" FT: typescript {
Plug 'leafgarland/typescript-vim'
" }
call plug#end()
" }

" General Settings {1
" Set leader {2
let mapleader=" "
" }2
" Keymaps {2
nnoremap <Leader>vu :PlugUpdate<CR>
" Pane splits {3
nnoremap <Leader>\ :vsplit<CR>
nnoremap <Leader>- :split<CR>
" }3
" Arrow keys {3
nnoremap <Left> :vertical resize +1<CR>
nnoremap <Right> :vertical resize -1<CR>
nnoremap <Up> :resize +1<CR>
nnoremap <Down> :resize -1<CR>
nnoremap <C-w><Right> :exe "vertical resize +" . (winwidth(0) * 1/2)<CR>
nnoremap <C-w><Left> :exe "vertical resize -" . (winwidth(0) * 1/2)<CR>
nnoremap <C-w><Up> :exe "resize +" . (winheight(0) * 1/2)<CR>
nnoremap <C-w><Down> :exe "resize -" . (winheight(0) * 1/2)<CR>
" }3
" }2
"" Switch syntax highlighting on. {2
"-----------------------------------------------------------------------------------
syntax on
" }2
" Various settings {2
"-----------------------------------------------------------------------------------
set autoindent                         " Copy indent from current line
set autoread                           " Read open files again when changed outside Vim
set autowrite                          " Write a modified buffer on each :next , ...
set backspace=indent,eol,start         " Backspacing over everything in insert mode
set history=200                        " Keep 200 lines of command line history
set incsearch                          " Do incremental searching
set ignorecase                         " Ignore case when searching....
set smartcase                          " ...unless uppercase letter are used
set hlsearch                           " Highlight the last used search pattern
set list                               " Toggle manually with set list / set nolist or set list!
set listchars=""                       " Empty the listchars
set listchars=tab:>.                   " A tab will be displayed as >...
set listchars+=trail:.                 " Trailing white spaces will be displayed as .
set nobackup                           " Don't constantly write backup files
set noswapfile                         " Ain't nobody got time for swap files
set noerrorbells                       " Don't beep
set nowrap                             " Do not wrap lines
set showbreak=↪\                       " Character to precede line wraps for the times I turn it on
set popt=left:8pc,right:3pc            " Print options
set shiftwidth=4                       " Number of spaces to use for each step of indent
set showcmd                            " Display incomplete commands in the bottom line of the screen
set tabstop=4                          " Number of spaces that a <Tab> counts for
set expandtab                          " Make vim use spaces and not tabs
set undolevels=1000                    " Never can be too careful when it comes to undoing
set hidden                             " Don't unload the buffer when we switch between them. Saves undo history
set visualbell                         " Visual bell instead of beeping
set wildignore=*.swp,*.bak,*.pyc,*.class,node_modules/**  " wildmenu: ignore these extensions
set wildmenu                           " Command-line completion in an enhanced mode
set shell=bash                         " Required to let zsh know how to run things on command line
set ttimeoutlen=50                     " Fix delay when escaping from insert with Esc
set noshowmode                         " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set synmaxcol=256                      " Don't syntax highlight long lines
set nosol                              " Keep cursor in the same column if possible for G, gg, etc.
set termguicolors                      " Welcome to Oz dorothy
" }2
" Treat JSON files like JavaScript {2
"-----------------------------------------------------------------------------------
au BufNewFile,BufRead *.json set ft=javascript
" }2
" Last cursor position {2
"-----------------------------------------------------------------------------------
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
"-----------------------------------------------------------------------------------
if has("autocmd")
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
endif
" }2
" }1

" vim: set foldmarker={,} foldlevel=0 foldmethod=marker:
