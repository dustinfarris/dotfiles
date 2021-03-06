" Configuration for Neovim
" Dustin Farris (2019)
" ==================================================

" Core configuration {
let g:python_host_prog = $HOME . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'
" }
" Plugins {
call plug#begin(stdpath('data') . '/plugged')
" Denite - Fuzzy search {2
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
" }2
" Deoplete - Async completion {
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Disabling in favor of CoC
let g:deoplete#enable_at_startup = 0
" }
" CoC - Completion {
Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
let g:ale_linters = {
            \   'javascript': ['eslint'],
            \   'typescript': ['eslint', 'tsserver'],
            \   'vue': ['eslint']
            \}
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'javascript': ['prettier'],
            \   'typescript': ['prettier'],
            \}
let g:ale_fix_on_save = 1
let g:ale_warn_about_trailing_blank_lines = 0
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_java_javalsp_executable = "~/java-language-server/dist/mac/bin/launcher"
map ;j :ALENext<CR>
map ;k :ALEPrevious<CR>
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
Plug 'kristijanhusak/defx-icons'
Plug 'kristijanhusak/defx-git'

augroup vimrc_defx
  autocmd!
  autocmd FileType defx call s:defx_mappings()
  autocmd VimEnter * call s:setup_defx()
augroup END

" nnoremap <silent> ;n :Defx -split=vertical -winwidth=35 -direction=topleft -columns=git:icons:filename:type -toggle -search=`expand('%:p')` `getcwd()`<CR>
nnoremap <silent> ;n :call <sid>defx_open()<CR>

let g:defx_git#column_length=1
let g:defx_git#show_ignored=0
let g:defx_git#raw_mode=0
let s:default_columns = 'indent:git:icons:filename'

function! s:setup_defx() abort
    call defx#custom#option('_', {
        \ 'columns': s:default_columns,
        \ })
    call defx#custom#column('filename', {
        \ 'min_width': 80,
        \ 'max_width': 80,
        \ })
    call s:defx_open({ 'dir': expand('<afile>') })
endfunction

function s:get_project_root() abort
    let l:git_root = ''
    let l:path = expand('%p:h')
    let l:cmd = systemlist('cd '.l:path.' && git rev-parse --show-toplevel')
    if !v:shell_error && !empty(l:cmd[0])
        let l:git_root = fnamemodify(l:cmd[0], ':p:h')
    endif
    if !empty(l:git_root)
        return l:git_root
    endif
    return getcwd()
endfunction

function! s:defx_open(...) abort
    let l:opts = get(a:, 1, {})
    let l:is_file = has_key(l:opts, 'dir') && !isdirectory(l:opts.dir)
    if &filetype ==? 'defx' || l:is_file
        return
    endif
    let l:path = s:get_project_root()
    if has_key(l:opts, 'dir') && isdirectory(l:opts.dir)
        let l:path = l:opts.dir
    endif
    let l:args = '-winwidth=40 -direction=topleft -split=vertical'
    if has_key(l:opts, 'find_current_file')
        call execute(printf('Defx %s -search=%s %s', l:args, expand('%:p'), l:path))
    else
        call execute(printf('Defx -toggle %s %s', l:args, l:path))
        " call execute('wincmd p')   -- return focus to previous pane
    endif
    return execute("norm!\<C-w>=")
endfunction

function! s:defx_context_menu() abort
  let l:actions = ['new_multiple_files', 'rename', 'copy', 'move', 'paste', 'remove']
  let l:selection = confirm('Action?', "&New file/directory\n&Rename\n&Copy\n&Move\n&Paste\n&Delete")
  silent exe 'redraw'

  return feedkeys(defx#do_action(l:actions[l:selection - 1]))
endfunction

function s:defx_toggle_tree() abort
    if defx#is_directory()
        return defx#do_action('open_or_close_tree')
    endif
    return defx#do_action('drop')
endfunction

function! s:defx_mappings() abort
	nnoremap <silent><buffer><expr> <CR> <sid>defx_toggle_tree()
	nnoremap <silent><buffer><expr> c defx#do_action('copy')
	nnoremap <silent><buffer><expr> m defx#do_action('move')
	nnoremap <silent><buffer><expr> p defx#do_action('paste')
	nnoremap <silent><buffer><expr> l defx#do_action('open')
	nnoremap <silent><buffer><expr> E defx#do_action('open', 'vsplit')
	nnoremap <silent><buffer><expr> P defx#do_action('open', 'pedit')
	nnoremap <silent><buffer><expr> o defx#do_action('open_or_close_tree')
	nnoremap <silent><buffer><expr> K defx#do_action('new_directory')
	nnoremap <silent><buffer><expr> N defx#do_action('new_file')
	nnoremap <silent><buffer><expr> M defx#do_action('new_multiple_files')
	nnoremap <silent><buffer><expr> C defx#do_action('toggle_columns',                'mark:indent:icon:filename:type:size:time')
	nnoremap <silent><buffer><expr> S defx#do_action('toggle_sort', 'time')
	nnoremap <silent><buffer><expr> d defx#do_action('remove')
	nnoremap <silent><buffer><expr> r defx#do_action('rename')
	nnoremap <silent><buffer><expr> !\ defx#do_action('execute_command')
	nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
	nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
	nnoremap <silent><buffer><expr> I defx#do_action('toggle_ignored_files')
	nnoremap <silent><buffer><expr> ; defx#do_action('repeat')
	nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
	nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
	nnoremap <silent><buffer><expr> q defx#do_action('quit')
	nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
	nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
	nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
	nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
	nnoremap <silent><buffer><expr> <C-g> defx#do_action('print')
	nnoremap <silent><buffer><expr> cd defx#do_action('change_vim_cwd')
endfunction
" }
" FZF - Fuzzy finder {
Plug 'junegunn/fzf'
" }
" Surround - wrapping text in parens, brackets, quotes, etc {2
Plug 'tpope/vim-surround'
" }2
" Magit - Managing git workflows {2
Plug 'jreybert/vimagit'
" }2
" Fugitive - Git blame {2
Plug 'tpope/vim-fugitive'
" }
" FT: beancount {
Plug 'nathangrigg/vim-beancount'
inoremap php PHP<C-\><C-O>:AlignCommodity<CR>
inoremap php PHP<C-\><C-O>:AlignCommodity<CR>
inoremap usd USD<C-\><C-O>:AlignCommodity<CR>
inoremap usd USD<C-\><C-O>:AlignCommodity<CR>
nnoremap <Leader>= :AlignCommodity<CR>
vnoremap <Leader>= :AlignCommodity<CR>
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
" FT: elixir {
Plug 'elixir-editors/vim-elixir'
Plug 'joaofcosta/vim-mix-format'
" }
call plug#end()
" }
" General Settings {1
" Set leader {2
let mapleader=" "
" }2
" Denite {
"" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of 'grep'
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
" This needs match_highlight set to 1 before highlighting will work.
" Highlighting is currently broken/disabled in neovim but should be working
" again with 0.5.0 is release:
"   https://github.com/Shougo/denite.nvim/commit/a38ee0dba1e5fef228f728460fe9afa8af9858e5#commitcomment-38539968
let s:denite_options = {'default' : {
            \ 'split': 'floating',
            \ 'start_filter': 1,
            \ 'auto_resize': 1,
            \ 'source_names': 'short',
            \ 'prompt': ' ',
            \ 'highlight_mode_insert': 'WildMenu',
            \ 'match_highlight': 0,
            \ 'highlight_matched_char': 'QuickFixLine',
            \ 'highlight_matched_range': 'Visual',
            \ 'highlight_window_background': 'Visual',
            \ 'highlight_filter_background': 'Visual',
            \ 'winrow': 1,
            \ 'vertical_preview': 1
            \ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)

call denite#custom#var('file/rec/git', 'command',
            \ ['git', 'ls-files', '-co', '--exclude-standard'])

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <Esc>
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> <CR>
                \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
                \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
                \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
                \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
                \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
    imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
    imap <silent><buffer> <Tab> <Plug>(denite_filter_quit)
    imap <silent><buffer><expr> <C-a>
                \ denite#do_map('move_to_next_line')
    inoremap <silent><buffer><expr> <Esc>
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> <Esc>
                \ denite#do_map('quit')
    inoremap <silent><buffer><expr> <CR>
                \ denite#do_map('do_action')
    inoremap <silent><buffer><expr> <C-t>
                \ denite#do_map('do_action', 'tabopen')
    inoremap <silent><buffer><expr> <C-v>
                \ denite#do_map('do_action', 'vsplit')
    inoremap <silent><buffer><expr> <C-h>
                \ denite#do_map('do_action', 'split')
    call deoplete#custom#buffer_option('auto_complete', v:false)
endfunction

nmap , :Denite buffer<CR>
nmap <leader>t :DeniteProjectDir file/rec<CR>
nnoremap <Leader>o :Denite file/rec<CR>
nnoremap <Leader>dg :<C-u>Denite grep:. -no-empty<CR>
nnoremap <Leader>j :<C-u>DeniteCursorWord grep:.<CR>
" }
" Git {
nnoremap <Leader>g :Magit<CR>
nnoremap <Leader>b :0,3Git blame<CR>
" }
" CoC {
" === coc.nvim === "
"   <leader>dd    - Jump to definition of current symbol
"   <leader>dr    - Jump to references of current symbol
"   <leader>dj    - Jump to implementation of current symbol
"   <leader>ds    - Fuzzy search current project symbols
nmap <silent> <leader>] <Plug>(coc-definition)
nmap <silent> <leader>dr <Plug>(coc-references)
nmap <silent> <leader>dj <Plug>(coc-implementation)
nnoremap <silent> <leader>ds :<C-u>CocList -I -N --top symbols<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" }
" FZF {
" nnoremap <Leader>o :call fzf#run({'source': 'git ls-files', 'sink': 'e', 'down': '20%'})<CR>
set rtp+=/usr/local/opt/fzf
" nnoremap <Leader>o :call fzf#run({'source': 'git ls-files', 'sink': 'e'})<CR>
" }
" Keymaps {2
nnoremap <Leader>vu :PlugUpdate<CR>
nnoremap <Leader><Leader> :b#<CR>
" Easier popup navigation with Tab {
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" }
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
" Switch syntax highlighting on. {2
syntax on
" }2
" Colors! {2
colorscheme codeschool
hi LineNr guifg=#626267
hi CursorLineNr ctermfg=gray ctermbg=233 guifg=#aaaaac guibg=#242d39
autocmd BufEnter,BufRead *.py,*.elm set colorcolumn=73,80,100
autocmd BufEnter,BufRead *.ex,*.exs,*.yml,*.html,*.feature,*.js,*.coffee,*.less,*.css,*.sass,*.scss set shiftwidth=2 softtabstop=2 colorcolumn=80,100
" }2
" Folding {2
set foldmethod=syntax
noremap <tab> za
" }2
" Various settings {2
"-----------------------------------------------------------------------------------
set autoindent                         " Copy indent from current line
set autoread                           " Read open files again when changed outside Vim
set autowrite                          " Write a modified buffer on each :next , ...
set backspace=indent,eol,start         " Backspacing over everything in insert mode
set cursorline                         " Highlight the cursor line
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
set nu                                 " Show line numbers
set nuw=6                              " Set line column width
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
set mouse=a                            " Enable mouse scrolling
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
" File Types {1
" Python {2
augroup PYTHON
    autocmd!
    autocmd FileType python setlocal foldmethod=indent foldlevel=0 foldminlines=0
    " autocmd BufRead,BufNewFile *.py setlocal foldlevel=0 foldminlines=0
augroup END
" }2
" Beancount {
let g:beancount_separator_col = 68
augroup BEANCOUNT
    autocmd BufEnter,BufRead *.beancount set shiftwidth=2 softtabstop=2
    autocmd BufEnter,BufRead *.beancount nnoremap <Leader>= :AlignCommodity<CR>
augroup END
" }
" Elixir {
let g:mix_format_on_save = 1
augroup ELIXIR
    autocmd!
    autocmd FileType elixir setlocal foldlevel=1
augroup END
" }
" }1
" Status line {1
setl laststatus=2

let s:currentmode={'n':  {'text': 'NORMAL',  'termColor': 60, 'guiColor': '#076678'},
                 \ 'v':  {'text': 'VISUAL',  'termColor': 58, 'guiColor': '#D65D0E'},
                 \ 'V':  {'text': 'V-LINE',  'termColor': 58, 'guiColor': '#D65D0E'},
                 \ '': {'text': 'V-BLOCK', 'termColor': 58, 'guiColor': '#D65D0E'},
                 \ 'i':  {'text': 'INSERT',  'termColor': 29, 'guiColor': '#8EC07C'},
                 \ 'R':  {'text': 'REPLACE', 'termColor': 88, 'guiColor': '#CC241D'}}

function! TextForCurrentMode()
    set lazyredraw
    if has_key(s:currentmode, mode())
        let modeMap = s:currentmode[mode()]
        execute 'hi! User1 ctermfg=255 ctermbg=' . modeMap['termColor'] . 'guifg=#EEEEEE guibg=' . modeMap['guiColor'] . ' cterm=none'
        return modeMap['text']
    else
        return 'UNKNOWN'
    endif
    set nolazyredraw
endfunction
function! BuildStatusLine(showMode)
    " Dark theme
    hi User1 ctermfg=235 ctermbg=101 guibg=#505050 guifg=#d0d0d0 cterm=reverse
    hi User7 ctermfg=88  ctermbg=235 guibg=#870000 guifg=#e0e0e0 cterm=none
    hi User8 ctermfg=235 ctermbg=101 guibg=#505050 guifg=#d0d0d0 cterm=reverse

    " Light theme
    " hi User1 ctermfg=236 ctermbg=101 guifg=#303030 guibg=#d0d0d0 cterm=reverse
    " hi User7 ctermfg=88  ctermbg=236 guifg=#870000 guibg=#e0e0e0 cterm=none
    " hi User8 ctermfg=236 ctermbg=101 guifg=#303030 guibg=#d0d0d0 cterm=reverse
    setl statusline=
    if a:showMode
        setl statusline+=%1*\ %{TextForCurrentMode()}\ "
    endif
    setl statusline+=%<                              " Truncate contents after when line too long
    setl statusline+=%{&paste?'>\ PASTE':''}         " Alert when in paste mode
    setl statusline+=%8*\ %F                         " File path
    setl statusline+=%7*%m                           " File modified status
    setl statusline+=%8*                             " Set User8 coloring for rest of status line
    setl statusline+=%r%h%w                          " Flags
    setl statusline+=%=                              " Right align the rest of the status line
    setl statusline+=\ [TYPE=%Y]                     " File type
    setl statusline+=\ [POS=L%04l,R%04v]             " Cursor position in the file line, row
    setl statusline+=\ [LEN=%L]                      " Number of line in the file
    setl statusline+=%#warningmsg#                   " Highlights the syntastic errors in red
endfunction
au WinLeave * call BuildStatusLine(0)
au WinEnter,VimEnter,BufWinEnter * call BuildStatusLine(1)
" }1
" Functions {1
" Strip Whitespace {2
function! StripTrailingWhitespace()
  normal mZ
  let l:chars = col("$")
  %s/\s\+$//e
  if (line("'Z") != line(".")) || (l:chars != col("$"))
    echo "Trailing whitespace stripped\n"
  endif
  normal `Z
endfunction
autocmd BufWritePre * :call StripTrailingWhitespace()
" }2
" Navigate term splits {2
function! s:NavigateTermSplits(direction)
  let windowNumber = winnr()
  execute 'wincmd ' . a:direction
  if windowNumber == winnr()
    " We didn't move to a new vim split. Now try to move tmux splits
    silent call system('tmux select-pane -' . tr(a:direction, 'hjkl', 'LDUR'))
  endif
endfunction
nnoremap <silent> <C-h> :call <SID>NavigateTermSplits('h')<CR>
nnoremap <silent> <C-j> :call <SID>NavigateTermSplits('j')<CR>
nnoremap <silent> <C-k> :call <SID>NavigateTermSplits('k')<CR>
nnoremap <silent> <C-l> :call <SID>NavigateTermSplits('l')<CR>
" }2
" Yank to clipboard {
"===============================================================================
" DESCRIPTION:   Yank in visual mode will now do three things
"                1) Default yank behaviour
"                2) Yank selection to "p register
"                3) Yank selection to system clipboard
" EXAMPLE USAGE: Use `y` in visual mode as usual. If the default " register is
"                overwritten you can still access the selection in the p register
"                easily with the shortcut <Leader>p
"===============================================================================
function! EnhancedYank() range
    normal! ""gvy
    let selection = getreg('"')
    let @p = selection
    let @+ = selection
endfunction

function! EnhancedYankToRegister()
  normal! ""gvy
  let selection = getreg('"')
  call inputsave()
  let g:regToYank = input('Register to yank to: ')
  call inputrestore()
  exe "let @" . g:regToYank . " = '" . selection . "'"
endfunction

xnoremap y :call EnhancedYank()<CR>
xnoremap <Leader>" :call EnhancedYankToRegister()<CR>
xnoremap <Leader>p "pp
nnoremap <Leader>p "pp
" }
" Floating FZF {2
" }2
" }1

" vim: set foldmarker={,} foldlevel=0 foldmethod=marker:
