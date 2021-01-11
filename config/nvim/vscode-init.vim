" Configuration for Neovim for use by VS Code
" Dustin Farris (2019)
" ==================================================

" Core configuration {
let g:python_host_prog = $HOME . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'
" }

let mapleader = " "

function! s:split(...) abort
    let direction = a:1
    let file = exists('a:2') ? a:2 : ''
    call VSCodeCall(direction ==# 'h' ? 'workbench.action.splitEditorDown' : 'workbench.action.splitEditorRight')
    if !empty(file)
        call VSCodeExtensionNotify('open-file', expand(file), 'all')
    endif
endfunction

nnoremap <Leader>\ <Cmd>call <SID>split('v')<CR>
xnoremap <Leader>\ <Cmd>call <SID>split('v')<CR>

function! s:vscodeGoToDefinition(str)
    if exists('b:vscode_controlled') && b:vscode_controlled
        exe "normal! m'"
        call VSCodeNotify('editor.action.reveal' . a:str)
    else
        " Allow to funcionar in help files
        exe "normal! \<C-]>"
    endif
endfunction

xnoremap <silent> <Leader>] :<C-u>call <SID>vscodeGoToDefinition()<CR>
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker:
