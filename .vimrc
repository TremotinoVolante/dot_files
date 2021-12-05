"Vundle is short for Vim bundle and is a Vim plugin manager.
set nocompatible              " be iMproved, required, disables vi
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'mbbill/undotree'            "history tree
"Plugin 'powerline/powerline'        "comand line
Plugin 'vim-airline/vim-airline'
Plugin 'Raimondi/delimitMate'       "provides automatic closing of quotes, parenthesis, brackets, etc
Plugin 'vim-syntastic/syntastic'    "syntax checking
Plugin 'gruvbox-community/gruvbox'

Plugin 'ycm-core/YouCompleteMe'
"Bundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" basic customizations
set viminfo='100,<1000,s100,h "last edited files, number of lines saved for each register
set relativenumber 		" show line numbers
set number
"set showcmd            " show command in bottom bar
set cursorline			" highlight current line
"filetype indent on     " load filetype-specific indent files ~/.vim/indent/c.vim not active se above
set wildmode=list "longest,list,full
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set hidden

"TODO:check what they do
set noswapfile  "test
set nobackup
set undodir=~/.vim/undodir
set undofile 

set tabstop=4       	" number of visual spaces per TAB 
set softtabstop=4   	" number of spaces in tab when editing
set autoindent 			" automatically inset tabs
set expandtab			" replacing tabs with white spaces
set shiftwidth=4

set incsearch           " search as characters are entered
set hlsearch            " highlight matches
"set nohlsearch         " deactivates highlighting matches

"set nowrap             "too long line do not wrap
set scrolloff=8
syntax enable           " enable syntax processing
set background=dark
autocmd vimenter * ++nested colorscheme gruvbox
"colorscheme gruvbox
let g:airline#extensions#tabline#enabled = 1

let mapleader = ' '

" turn off search highlight
nnoremap <leader>/ :nohlsearch<CR>

" highlight last inserted text
nnoremap <leader>v `[v`]

" toggle undotree
nnoremap <leader>u :UndotreeToggle<CR> "open and closes undotree 
nnoremap <leader>e :wincmd v<bar> :Explore <bar> :vertical resize 30<CR>

" YCM
nnoremap <silent> <leader>gt :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>fi :YcmCompleter FixIt<CR>

nnoremap <leader>j :m .+1<CR>
nnoremap <leader>k :m .-1<CR>
"setting for vimspector
"let g:vimspector_enable_mappings = 'HUMAN'
"packadd! vimspector

"this function should build my c code I'm working on and if no errors are
"detected run vimspector 
"The function should be called with <F5>
function s:get_buildmetrics() abort
  let qf = getqflist()
  let recognized = filter(qf, 'get(v:val, "valid", 1)')
  " TODO: support other locales, see lh#po#context().tranlate()
  let errors   = filter(copy(recognized), 'v:val.type == "E" || v:val.text =~ "\\v^ *(error|erreur)"')
  let warnings = filter(copy(recognized), 'v:val.type == "W" || v:val.text =~ "\\v^ *(warning|attention)"')
  let res = { 'all': len(qf), 'errors': len(errors), 'warnings': len(warnings) }
  return res
endfunction

function s:build_and_run() abort
  " to make sure the buffer is saved
  %update
  make CONF=Debug -C ./.vim

  if s:get_buildmetrics().errors
    echom "Error detected, execution aborted"
    copen
    return
  endif

  call vimspector#Launch()
endfunction

nnoremap <silent> <F5> :<c-u>call <sid>build_and_run()<cr>
