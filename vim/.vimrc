"|===============================================================
"|  基本設定
"|---------------------------------------------------------

set number
set encoding:utf-8
set display=lastline
set wrap
set showmatch
set matchtime=1
set viminfo='100,<50,s10,h,\"1000
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:>-,space:.
set clipboard+=unnamed


"|===============================================================
"| neobundle 設定
"|---------------------------------------------------------

set nocompatible
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
    call neobundle#begin(expand('~/.vim/bundle/'))
endif

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.vim', {
  \ 'build' : {
  \     'windows' : 'tools\\update-dll-mingw',
  \     'cygwin' : 'make -f make_cygwin.mak',
  \     'mac' : 'make -f make_mac.mak',
  \     'linux' : 'make',
  \     'unix' : 'gmake',
  \    },
  \ }
NeoBundle 'VimClojure'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimshell'
NeoBundle 'violetyk/neocomplete-php.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'jpalardy/vim-slime'
NeoBundle 'fatih/vim-go'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'andviro/flake8-vim'
NeoBundle 'hynek/vim-python-pep8-indent'
NeoBundle 'jmcantrell/vim-virtualenv'

call neobundle#end()
filetype plugin on


"|===============================================================
"| 各プラグイン設定
"|---------------------------------------------------------

"|------ neocomplete-php ------>>

let g:neocomplete_php_locale = 'ja'


"|------ vim-go ------>>

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


"|------ syntastic ------>>

let g:syntastic_go_checkers = ['go', 'golint']
let g:syntastic_mode_map = {
\ "mode" : "active",
\ "active_filetypes" : ["go"],
\}


"|------ colorscheme ------>>

set t_Co=256
syntax on
au ColorScheme * highlight Visual ctermbg=49
colorscheme molokai
au WinEnter,FileType html,css colorscheme monokai
highlight Comment ctermfg=Grey
highlight NonText ctermfg=244
highlight SpecialKey ctermfg=244


"|===============================================================
"| key mapping
"|------------------------------------------------------------

inoremap {} {}<LEFT>
inoremap [] []<LEFT>
inoremap () ()<LEFT>
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>
inoremap <> <><LEFT>

nnoremap [unite]    <Nop>
nmap     <Space>u [unite]


"|===============================================================
"| ファイルタイプ別設定
"|------------------------------------------------------------


"|------ PHPファイルの設定 ------>>

" 保存時に行末の空白を削除
au BufWritePre,FileType php :%s/\s\+$//ge


"|------ Goファイルの設定 ------>>

" err という文字列をハイライト
au FileType go :highlight goErr cterm=bold ctermfg=214
au FileType go :match goErr /\<err\>/
