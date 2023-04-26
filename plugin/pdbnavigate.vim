" Title:        pdbnavigate Pluggin                                             
" Description:  A plugin for python debugging using vim and pdb

if exists("g:pdb_navigate_plugin")
    finish
endif

let g:pdb_navigate_plugin = 1 

function! AddToDebug()
    echo "here"
endfunction


command! MyJunk call AddToDebug() 

nnoremap <C-F8> <Esc>:call pdbnavigate#AddToDebug()<CR>                         
nnoremap <C-F7> <Esc>:call pdbnavigate#ClearDebug()<CR>

