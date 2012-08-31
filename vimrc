call pathogen#infect()

filetype plugin indent on 	      " Enable file type detection.
colorscheme molokai               " Color theme
syntax enable                     " Turn on syntax highlighting
set encoding=utf-8                " Set default encoding to UTF-8
set nocompatible                  " Use vim, no vi defaults
set number                        " Show line numbers
set hidden                        " Allow unsaved background buffers and remember marks/undo for them
set showcmd                       " Display incomplete commands
set nowrap
set history=200
set ttyfast                       " Improve smoothness of redrawing
set nocompatible                  " Use vim, no vi defaults
set laststatus=2
set novisualbell
set previewheight=30
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
set gdefault
set wildmenu
set wildmode=list:longest
set cursorline                    " Highlights current line
set shell=bash
set synmaxcol=2048
set scrolloff=3                   " Have some context around the current line always on screen

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

set backupdir=~/.vim/_backup    " where to put backup files
set directory=~/.vim/_temp      " where to put swap files

set switchbuf=usetab,newtab

" Don't use Ex mode, use Q for formatting
map Q gq

" Clear the search buffer when hitting return
:nnoremap <cr> :nohlsearch<cr>

" Paste lines from unnamed register and fix indentation
nmap <leader>p pV`]=
nmap <leader>P PV`]=

nnoremap <leader><leader> <c-^>

" Find merge conflict markers
nmap <silent> <leader>cf <esc>/\v^[<=>]{7}( .*\|$)<cr>

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

let g:Powerline_symbols = 'fancy'
let mapleader = ","

" Easier navigation between split windows
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Tabs navigation
map <C-l> :tabn<CR>
map <C-h> :tabp<CR>
map <C-n> :tabnew<CR>

" Disable cursor keys in normal mode
map <Left>  :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up>    :echo "no!"<cr>
map <Down>  :echo "no!"<cr>

imap jj <ESC>
noremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %
autocmd BufWritePre * :%s/\s\+$//e

" Remap W to w -- save a file
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'w')?('W'):('w'))

cnoremap %% <C-R>=expand('%:h').'/'<cr>:w
map <leader>e :edit %%
map <leader>v :view %%
nnoremap <leader><leader> <c-^>

" Insert a hash rocket (=>) with <c-l>
imap <c-l> <space>=><space>

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

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

" Fugitive mappings
map <leader>gb :Gblame<CR>
map <leader>gs :Gstatus<CR>
map <leader>gd :Gdiff<CR>
map <leader>gl :Glog<CR>
map <leader>gc :Gcommit<CR>
map <leader>gp :Git push<CR>

