set runtimepath^=~/.vim/YouCompleteMe
set runtimepath^=~/.vim/vim-code-dark
set runtimepath^=~/.vim/tagbar
set runtimepath^=~/.vim/vim-glsl
" set runtimepath^=~/.vim/minimap.vim

" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''

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
        " NOT SURE IF BELOW WORKS -> test that!
        " let g:ycm_clangd_args = [ '--query-driver=/home/mbp666/Documents/projects/emsdk/upstream/emscripten/em++' ]
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

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
endif

" To unfuck using with tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

command -nargs=* CodeEnv call SetupCodeEnv(<args>)

" REMOVE TRAILING WHITESPACES
autocmd BufWritePre * try | undojoin | call TrimWhiteSpace() | catch /^Vim\%((\a\+)\)\=:E790/ | endtry
autocmd FileAppendPre * try | undojoin | call TrimWhiteSpace() | catch /^Vim\%((\a\+)\)\=:E790/ | endtry
autocmd FilterWritePre * try | undojoin | call TrimWhiteSpace() | catch /^Vim\%((\a\+)\)\=:E790/ | endtry
autocmd BufWritePre * try | undojoin | call TrimWhiteSpace() | catch /^Vim\%((\a\+)\)\=:E790/ | endtry

" Display trailing whitespaces
"set list listchars=trail:.,extends:>

map <F2> :call TrimWhiteSpace()<CR>
map! <F2> :call TrimWhiteSpace()<CR>

"END WHITESPACE REMOVAL

" Set specific settings for js and html
autocmd Filetype js call UseSettingsJS()
autocmd Filetype html call UseSettingsJS()

" Custom commands

" Open tagbar with tab
map <Tab> :TagbarToggle<CR>
