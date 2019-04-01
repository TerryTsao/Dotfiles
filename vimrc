set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'Chiel92/vim-autoformat'
Plugin 'JamshedVesuna/vim-markdown-preview'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'oblitum/YouCompleteMe'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-syntastic/syntastic'
Plugin 'tpope/vim-surround'
Plugin 'jiangmiao/auto-pairs'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'gaosld/vim-scripts-taglist'
Plugin 'wesleyche/SrcExpl'
Plugin 'wesleyche/Trinity'
Plugin 'mihais/vim-mark'
Plugin 'tpope/vim-vinegar'
Plugin 'ctrlpvim/ctrlp.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" They say it's necessary
set t_Co=256              " enable 256-color mode.
set laststatus=2          " last window always has a statusline
set ruler                 " Always show info along bottom.
set tabstop=4             " tab spacing
set softtabstop=4         " unify
set shiftwidth=4          " indent/outdent by 4 columns
set shiftround            " always indent/outdent to the nearest tabstop
set expandtab             " use spaces instead of tabs
set smarttab              " use tabs at the start of a line, spaces elsewhere
set nowrap                " don't wrap text
set backspace=2           " for backspace
set shell=/usr/local/bin/zsh

"" solarized colorscheme
syntax enable
set background=dark
colorscheme solarized
set t_Co=256

"" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme='solarized_flood'

"" Everyone loves unicode
set encoding=utf-8

"" Syntastic recommended settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes':   [],'passive_filetypes': [] }
let g:syntastic_python_checkers=['flake8']

"" Setting for cool line numbers
set relativenumber
set number
nnoremap <silent> <C-K> :set relativenumber!<cr>

"" clipboard
set clipboard=unnamedplus

"" general indent
set autoindent   " automatically set indent of new line
set smartindent

"" Searching
set ignorecase   " case insensitive searching
set smartcase   " case-sensitive if expresson contains a capital letter
" set hlsearch
set incsearch   " set incremental search, like modern browsers
" set nolazyredraw   " don't redraw while executing macros
"
set magic   " Set magic on, for regex

set showmatch   " show matching braces
set mat=2   " how many tenths of a second to blink

let mapleader=" "

au BufRead,BufNewFile *.asm   set filetype=nasm

"" remap autoformat
noremap <F3> :Autoformat<CR>

"" highlight current line and number
se cursorline
highlight CursorLineNr cterm=bold ctermfg=91 ctermbg=220
set colorcolumn=80

"" for markdown grip github flavor
let vim_markdown_preview_github=1
let vim_markdown_preview_hotkey='<C-m>'

"" for nerd tree
nnoremap <C-p> :NERDTreeToggle<CR>
let NERDTreeWinPos=1
let g:NERDTreeChDirMode=0
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeIgnore = ['__pycache__[[dir]]', '\.pyc$']

" for fold
set foldmethod=manual
"" noremap <leader><space> za
noremap <C-h> zf%

" for eclim
let g:EclimCompletionMethod = 'omnifunc'
nnoremap <silent> <buffer> <leader>i :JavaImportOrganize<cr>

" for vim to access shell aliases
let $BASH_ENV = "~/.bash_aliases"

" for javacomplete2
" autocmd FileType java setlocal omnifunc=javacomplete#Complete
 
" nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
" imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
" nmap <F5> <Plug>(JavaComplete-Imports-Add)
" imap <F5> <Plug>(JavaComplete-Imports-Add)
" nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
" imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
" nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
" imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)

" for vim to remember last pos
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" for vim scroll
noremap <C-e> 10<C-e>
noremap <C-y> 10<C-y>

" for tags
set tags=./tags,./TAGS,tags;~,TAGS;~

set cscopetag
set csto=0
nnoremap <C-L> :tag<CR>

if filereadable("cscope.out")
   cs add cscope.out   
elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif
set cscopeverbose
" set csre

nnoremap <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <leader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <leader>n :tnext<CR>
nnoremap <leader>p :tNext<CR>

" taglist
nnoremap <F8> :TlistToggle<CR><CR>
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
set ut=100

" SrcExpl
nnoremap <F10> :SrcExplToggle<CR>
let g:SrcExpl_pluginList = [
    \"__Tag_List__",
    \"_NERD_tree_"]

" Trinity
nnoremap <F7> :TrinityToggleAll <CR>
"""au VimEnter * TrinityToggleAll
"""au VimEnter * NERDTreeToggle

" YCM
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_filetype_blacklist = {'pandoc' : 1}
autocmd FileType cuda set ft=cpp.cuda
au BufRead,BufNewFile *.prototxt set filetype=text
au BufRead,BufNewFile *.cuh set filetype=cuda

" Vim mark
let g:mwDefaultHighlightingPalette = 'extended'
let g:mwIgnoreCase = 0

let g:ctrlp_map = '<leader><space>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'c'

