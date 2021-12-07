set nocompatible              		        " be iMproved, required for Vundle, disables vi

filetype off                  		        " required
set rtp+=~/.vim/bundle/Vundle.vim           " set the runtime path to include Vundle and initialize

call vundle#begin()
	Plugin 'VundleVim/Vundle.vim' 		    " let Vundle manage Vundle, required
	Plugin 'mbbill/undotree'            	" history tree
	Plugin 'vim-airline/vim-airline'	    " comand line 
"	Plugin 'Raimondi/delimitMate'       	" provides automatic closing of quotes, parenthesis, brackets, etc
    Plugin 'jiangmiao/auto-pairs'
"	Plugin 'vim-syntastic/syntastic'    	" syntax checking
    Plugin 'puremourning/vimspector'        " debugger
    Plugin 'gruvbox-community/gruvbox'	    " color scheme
	Plugin 'ycm-core/YouCompleteMe'		    " syntax completition
    Plugin 'rdnetto/YCM-Generator'
call vundle#end()                           " required

filetype plugin indent on                   " required

" basic customizations
set viminfo='100,<1000,s100,h               " last edited files, number of lines saved for each register
set relativenumber 				            " show line numbers relative to cursor
set number					                " show line numbers
set showcmd            			        " show command in bottom bar
set cursorline					            " highlight current line
set wildmode=list 				            " longest,list,full
set wildmenu            			        " visual autocomplete for command menu
set lazyredraw          			        " redraw only when we need to.
set showmatch           			        " highlight matching [{()}]
set hidden

"TODO:check what they do
set noswapfile  "test
"set nobackup
set undodir=~/.vim/undodir
set undofile 

set tabstop=4      				" number of visual spaces per TAB 
set softtabstop=4   				" number of spaces in tab when editing
set autoindent 					" automatically inset tabs
set expandtab					" replacing tabs with white spaces
set shiftwidth=4

set incsearch           			" search as characters are entered
set hlsearch            			" highlight matches
"set nohlsearch         			" deactivates highlighting matches

set scrolloff=8
syntax enable           			" enable syntax processing
set background=dark
autocmd vimenter * ++nested colorscheme gruvbox
"colorscheme gruvbox
let g:airline#extensions#tabline#enabled = 1

let mapleader = ' '

" turn off search highlight
nnoremap <leader>/ :nohlsearch<CR>

" highlight last inserted text
nnoremap <leader>v `[v`]
" find and replace
nnoremap <leader>r :%s///gc

" open terminal
nnoremap <leader>t :ter<CR>

"toggle undotree
nnoremap <leader>u :UndotreeToggle<CR> "open and closes undotree 
nnoremap <leader>e :wincmd v<bar> :Explore <bar> :vertical resize 30<CR>

" YCM
nnoremap <silent> <leader>gt :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>fi :YcmCompleter FixIt<CR>
"let g:ycm_register_as_syntastic_checker = 1             "default 1
"let g:Show_diagnostics_ui = 1                           "default 1
"let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
 
"let g:ycm_server_python_interpreter='/usr/bin/python'
"let g:ycm_python_binary_path = '/usr/bin/python'
"let g:ycm_always_populate_location_list = 1
"let g:ycm_seed_identifiers_with_syntax = 1
"let g:ycm_use_clangd = 1
"set completeopt=menu

nnoremap <leader>k :m .-2<CR>
nnoremap <leader>j :m .+1<CR>

" Buffer
nnoremap <leader>l :bnext<CR>
nnoremap <leader>h :bprevious<CR>
nnoremap <leader>bq :bp <BAR> bd #<CR>

" general
nnoremap <leader>q <ESC>:q<CR>   " quit shortcut 
nnoremap <leader>w <ESC>:w<CR>   " save shortcut 

"fzf fuzzy finder 
fun! s:openFileAtLocation(result)
  if len(a:result) == 0
    return
  endif
  let filePos = split(a:result, ':')
  exec 'edit +' . l:filePos[1] . ' ' . l:filePos[0]
endfun

nnoremap <silent> <Leader>s :call fzf#run(fzf#wrap({
  \ 'source': 'rg --line-number ''.*''',
  \ 'options': '--delimiter : --preview "bat --style=plain --color=always {1} -H {2}" --preview-window "+{2}/2"',
  \ 'sink': function('<sid>openFileAtLocation'),
  \ }))<CR>

"setting for vimspector
let g:vimspector_enable_mappings = 'HUMAN'
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
  make CONF=Debug -C ./.debug/

  if s:get_buildmetrics().rrors
    echom "Error detected, execution aborted"
    copen
    return
  endif

  call vimspector#Launch()
endfunction

nnoremap <silent> <F5> :<c-u>call <sid>build_and_run()<cr>"
