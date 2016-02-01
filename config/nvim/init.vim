call plug#begin('~/.nvim/plugins')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'vim-erlang/vim-erlang-compiler'
Plug 'vim-erlang/vim-erlang-runtime'
Plug 'junegunn/fzf.vim'
Plug 'dkprice/vim-easygrep'
Plug 'kassio/neoterm'
Plug 'janko-m/vim-test'
call plug#end()

colorscheme molokai               " Color theme
filetype plugin indent on 	      " Enable file type detection.
syntax enable                     " Turn on syntax highlighting
set encoding=utf-8                " Set default encoding to UTF-8
set nonumber                      " Do not show line numbers
set hidden                        " Allow unsaved background buffers and remember marks/undo for them
set noshowcmd                     " Do not display incomplete commands
set history=10000                 " Lines to keep in history
set noruler                       " Do not show the ruler
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
set synmaxcol=128
set scrolloff=3                   " Have some context around the current line always on screen
set autoread                      " Watch out for file changes
set splitbelow                    " Put new window below the current one
set nobackup
set nowritebackup
set undodir=~/.nvim/_undo
set backupdir=~/.nvim/_backup
set directory=~/.nvim/_temp
set nofoldenable                  " All folds are open
set undofile                      " Maintain undo history between sessions
set switchbuf=usetab,newtab
set shell=/bin/bash
set rtp+=/usr/local/opt/fzf

let mapleader = ","

let g:airline#extensions#tabline#enabled = 0
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

tnoremap <Esc> <C-\><C-n>

" Disable Q
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

" Easy buffer navigation
nnoremap <silent> <C-l> :bnext<CR>
nnoremap <silent> <C-k> :bprevious<CR>

" Copy to clipboard
vnoremap <leader>y "*y

" Esc is harder to reach
inoremap <C-c> <ESC>

" fzf
let g:fzf_layout = { 'down': '~30%' }
nnoremap <silent> <C-j> :Files<CR>
nnoremap <silent> <C-f> :Buffers<CR>

nnoremap <silent> K :call SearchWordWithAg()<CR>
vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>

function! SearchWordWithAg()
  execute 'Ag' expand('<cword>')
endfunction

function! SearchVisualSelectionWithAg() range
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
  execute 'Ag' selection
endfunction

" Expand current path
cnoremap %% <C-R>=expand('%:h').'/'<CR>

" neoterm
let test#strategy = 'neoterm'
let g:neoterm_size = '15%'
nnoremap <silent> <Leader>t :call neoterm#toggle()<CR>
nnoremap <silent> <Leader>k :call neoterm#kill()<CR>
nnoremap <silent> <Leader>c :call neoterm#clear()<CR>

" vim-test
nnoremap <silent> <leader>s :TestNearest<CR>
nnoremap <silent> <leader>f :TestFile<CR>
nnoremap <silent> <leader>a :TestSuite<CR>
nnoremap <silent> <leader>l :TestLast<CR>
nnoremap <silent> <leader>g :TestVisit<CR>

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
map <leader>r :call RenameFile()<CR>

" Easy widows swap
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction

nnoremap <silent> <leader>wc :call MarkWindowSwap()<CR>
nnoremap <silent> <leader>wp :call DoWindowSwap()<CR>

" Copy current file path to clipboard
nnoremap <Leader>yp :let @*=expand("%")<cr>:echo "Copied file path to clipboard"<cr>

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" .rb keywords
autocmd FileType ruby set iskeyword+=?,!
