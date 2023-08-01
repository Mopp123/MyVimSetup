set runtimepath^=~/.vim/YouCompleteMe
set runtimepath^=~/.vim/vim-code-dark
set runtimepath^=~/.vim/minimap.vim

set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
filetype plugin indent on

" Specific tab settings for js and html
function UseSettingsJS()
    setlocal softtabstop=2
    setlocal shiftwidth=2
endfunction


" Removes trailing whitespaces
function TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction


let g:minimap_highlight_search = 1
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1
function SetupCodeEnv()
    " Highlight search
    set hlsearch
    " When searching word under cursor using '*' -> dont jump immediately
    colorscheme codedark
    set number
    nnoremap <Tab> :MinimapJump <CR>
endfunction

command CodeEnv call SetupCodeEnv()


" REMOVE TRAILING WHITESPACES
autocmd BufWritePre * try | undojoin | call TrimWhiteSpace() | catch /^Vim\%((\a\+)\)\=:E790/ | endtry
autocmd FileAppendPre * try | undojoin | call TrimWhiteSpace() | catch /^Vim\%((\a\+)\)\=:E790/ | endtry
autocmd FilterWritePre * try | undojoin | call TrimWhiteSpace() | catch /^Vim\%((\a\+)\)\=:E790/ | endtry
autocmd BufWritePre * try | undojoin | call TrimWhiteSpace() | catch /^Vim\%((\a\+)\)\=:E790/ | endtry

" Display trailing whitespaces
"set list listchars=trail:.,extends:>

" *Old whitespace removal
"autocmd FileWritePre * call TrimWhiteSpace()
"autocmd FileAppendPre * call TrimWhiteSpace()
"autocmd FilterWritePre * call TrimWhiteSpace()
"autocmd BufWritePre * call TrimWhiteSpace()

map <F2> :call TrimWhiteSpace()<CR>
map! <F2> :call TrimWhiteSpace()<CR>

"END WHITESPACE REMOVAL

" Set specific settings for js and html
autocmd Filetype js call UseSettingsJS()
autocmd Filetype html call UseSettingsJS()

" Custom commands

