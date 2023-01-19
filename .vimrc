set runtimepath^=~/.vim/bundle/YouCompleteMe
set runtimepath^=~/.vim/bundle/vim-code-dark
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap

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
