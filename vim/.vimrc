set number
set encoding:utf-8
set display=lastline
set wrap
set showmatch
set matchtime=1
nnoremap Y y$

" neobundle settings {{{
set nocompatible
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
    call neobundle#begin(expand('~/.vim/bundle/'))
endif

" neobundle#begin - neobundle#end の間に導入するプラグインを記載します。
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
    \   'build' : {
    \       'windows' : 'make -f make_mingw32.mak',
    \       'cygwin' : 'make -f make_cygwin.mak',
    \       'mac' : 'make -f make_mac.mak',
    \       'unix' : 'make -f make_unix.mak',
    \   },
    \ } 
NeoBundle 'VimClojure'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : ''
    \ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

NeoBundle 'Shougo/neosnippet'
NeoBundle 'jpalardy/vim-slime'
NeoBundle 'fatih/vim-go'
NeoBundle 'scrooloose/syntastic'

call neobundle#end()

filetype plugin indent on

" どうせだから jellybeans カラースキーマを使ってみましょう
set t_Co=256
syntax on
colorscheme molokai

"http://yuroyoro.hatenablog.com/entry/2014/08/12/144157
autocmd FileType go :highlight goErr cterm=bold ctermfg=214
autocmd FileType go :match goErr /\<err\>/
""quickrunでgo testを走らせる
"autocmd BufRead,BufNewFile *_test.go set filetype=go.test
"let g:quickrun_config['go.test'] = {'command' : 'go', 'exec' : ['%c test']}

"syntasticの設定
let g:syntastic_go_checkers = ['go', 'golint']
let g:syntastic_mode_map = {
\ "mode" : "active",
\ "active_filetypes" : ["go"],
\}

"vim-goの設定
let g:go_fmt_autosave = 1
let g:go_fmt_fail_silently = 1
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>d <Plug>(go-def)
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

cnoremap goi GoImport<space>