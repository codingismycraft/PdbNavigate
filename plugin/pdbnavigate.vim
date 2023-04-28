" Title:        pdbnavigate Pluggin                                             
" Description:  A plugin for python debugging using vim and pdb

if exists("g:pdb_navigate_plugin")
    finish
endif

let g:pdb_navigate_plugin = 1 

autocmd Bufleave * call pdbnavigate#ResetCursor()

nnoremap <C-F8> <Esc>:call pdbnavigate#AddToDebug()<CR>                         
nnoremap <C-F7> <Esc>:call pdbnavigate#ClearDebug()<CR>

augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END


highlight Debug ctermbg=Red ctermfg=Cyan

