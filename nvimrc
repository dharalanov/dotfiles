call pathogen#infect()
filetype plugin indent on 	      " Enable file type detection.
colorscheme molokai               " Color theme
syntax enable                     " Turn on syntax highlighting
set encoding=utf-8                " Set default encoding to UTF-8
set nocompatible                  " Use vim, no vi defaults
set nonumber                      " Do not show line numbers
set hidden                        " Allow unsaved background buffers and remember marks/undo for them
set noshowcmd                     " Do not display incomplete commands
set history=10000                 " Lines to keep in history
set noruler                       " Do not show the ruler
set ttyscroll=3
set ttyfast
set lazyredraw
set laststatus=2                  " Always show a status line for the last window
set novisualbell
set modelines=0                   " No lines are checked for set commands
set showmode                      " Show the mode you are in
set tabstop=2                     " A tab is two spaces
set shiftwidth=2                  " An autoindent (with <<) is two spaces
set autoindent                    " Copy indent from current line when starting a new line
set expandtab                     " Use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " Backspace through everything in insert mode
set listchars=""                  " Reset the listchars
set listchars=tab:\ \             " A tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.            " Show trailing spaces as dots
set hlsearch                      " Highlight matches
set incsearch                     " Incremental searching
set ignorecase                    " Searches are case insensitive...
set smartcase                     " ... unless they contain at least one capital letter
set wildmenu
set wildmode=longest,list
set cursorline                    " Highlights current line
set synmaxcol=128
set scrolloff=3                   " Have some context around the current line always on screen
set autoread                      " Watch out for file changes
set t_ti= t_te=
set timeout timeoutlen=1000 ttimeoutlen=100
set splitbelow                    " Put new window below the current one
set backup
set backupdir=~/.nvim/_backup    " where to put backup files
set directory=~/.nvim/_temp      " where to put swap files
set nofoldenable                 " All folds are open
set switchbuf=usetab,newtab
set shell=/bin/bash

let mapleader = ","
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tmuxline#enabled = 0
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '',
    \ 'right' : '',
    \ 'right_alt' : '<',
    \ 'space' : ' '}
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let ruby_operators = 1
let ruby_minlines = 1000

nnoremap <cr> :nohlsearch<cr>
nnoremap <leader><leader> <c-^>
nnoremap Q <nop>

" Forget about the damn arrow keys!
nnoremap <Up> <NOP>
inoremap <Up> <NOP>
vnoremap <Up> <NOP>

nnoremap <Down> <NOP>
inoremap <Down> <NOP>
vnoremap <Down> <NOP>

nnoremap <Left> <NOP>
inoremap <Left> <NOP>
vnoremap <Left> <NOP>

nnoremap <Right> <NOP>
inoremap <Right> <NOP>
vnoremap <Right> <NOP>

map <C-l> :tabn<CR>
map <C-h> :tabp<CR>
map <C-n> :tabnew<CR>

map <leader>y "*y

imap <c-c> <esc>

cnoremap %% <C-R>=expand('%:h').'/'<cr>

nnoremap <leader><leader> <c-^>

" Rename current file or even move it to another location
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>r :call RenameFile()<cr>

" Copy current file path to clipboard
nnoremap <Leader>yp :let @*=expand("%")<cr>:echo "Copied file path to clipboard"<cr>

" bind K to grep word under cursor
nnoremap K :Ag! "\b<C-R><C-W>\b"<CR>

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

autocmd FileType ruby
  \ set iskeyword+=?,! |
  \ setlocal re=1

" Use system Ruby
let g:ruby_path="/usr/bin/ruby"

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*,node_modules

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
        \ --ignore .git
        \ --ignore .svn
        \ --ignore .hg
        \ --ignore .DS_Store
        \ --ignore "**/*.pyc"
        \ -g ""'

  " PyMatcher for CtrlP
  if !has('python')
      echo 'In order to use pymatcher plugin, you need +python compiled vim'
  else
      let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  endif
endif
