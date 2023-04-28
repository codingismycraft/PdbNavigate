" Title:        pdbnavigate Pluggin                                             
" Description:  A plugin for python debugging using vim and pdb

if exists("g:pdb_navigate_plugin")
    finish
endif

let g:pdb_navigate_plugin = 1 

function! JunkFunc()
    echo "here 1"
endfunction

autocmd Bufleave * call pdbnavigate#ResetCursor()

command! MyJunk call AddToDebug() 

nnoremap <C-F8> <Esc>:call pdbnavigate#AddToDebug()<CR>                         
nnoremap <C-F7> <Esc>:call pdbnavigate#ClearDebug()<CR>
nnoremap <C-F6> <Esc>:call JunkFunc()<CR>

augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
