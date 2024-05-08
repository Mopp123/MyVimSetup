set runtimepath^=~/.vim/YouCompleteMe
set runtimepath^=~/.vim/vim-code-dark
set runtimepath^=~/.vim/tagbar
" set runtimepath^=~/.vim/minimap.vim

" YCM stopped finding stl lib automatically for some reason.. (worked earlier)
" Following fixes it
" https://stackoverflow.com/questions/75971787/youcompleteme-doesnt-find-stl-files
"
" NOTE: What this path should be depends on what stl lib to use and where it
" is located
"   -> for example if using emscripten this cannot be the one installed with
"   build-essentials -> it must be the one in emsdk

" let g:ycm_clangd_args = [ '--query-driver=/usr/bin/c++' ]
" let g:ycm_clangd_args = [ '--query-driver=/home/kalle/Documents/projects/client-app/emsdk/upstream/emscripten/em++' ]

set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
filetype plugin indent on
" Sort tagbar by position instead of alphabetically by default
let g:tagbar_sort = 0

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


" let g:minimap_highlight_search = 1
" let g:minimap_auto_start = 1
" let g:minimap_auto_start_win_enter = 1
function SetupCodeEnv(...)
    " Highlight search
    set hlsearch
    nnoremap * *``
    " When searching word under cursor using '*' -> dont jump immediately
    colorscheme codedark
    set number

    " Set correct path to compiler for ycm
    let lang = "default"
    if len(a:000) > 0
        let lang = a:1
    endif

    echo "Language set to: " . lang

    if lang == "c++"
        let g:ycm_clangd_args = [ '--query-driver=/usr/bin/c++' ]
        YcmRestartServer
    endif

    if lang == "em++"
        let g:ycm_clangd_args = [ '--query-driver=/home/kalle/Documents/projects/emsdk/upstream/emscripten/em++' ]
        YcmRestartServer
    endif

    if lang == "none"
        " NOTE: Not sure if this should be set to 1 in the above cases...
        let g:ycm_auto_trigger = 0
        let g:ycm_show_diagnostics_ui = 0
        YcmRestartServer
        :e
        " This is that column next to line numbers which ycm puts '>>' on
        " lines with errors...
        set signcolumn=no
        echo "YCM disabled!"
    endif

endfunction

command -nargs=* CodeEnv call SetupCodeEnv(<args>)


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

