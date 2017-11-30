if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.nvim/plugins')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rhubarb'
Plug 'vim-erlang/vim-erlang-compiler'
Plug 'vim-erlang/vim-erlang-runtime'
Plug 'vim-erlang/vim-erlang-omnicomplete'
Plug 'junegunn/fzf.vim'
Plug 'janko-m/vim-test'
Plug 'slim-template/vim-slim'
Plug 'elixir-lang/vim-elixir'
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'mbbill/undotree'
Plug 'python-mode/python-mode'
Plug 'vim-ruby/vim-ruby'
Plug 'mxw/vim-jsx'
Plug 'mtscout6/vim-cjsx'
Plug 'aliva/vim-fish'
Plug 'idris-hackers/idris-vim'
Plug 'godlygeek/csapprox'
Plug 'itchyny/lightline.vim'

call plug#end()

colorscheme molokai               " Color theme
syntax enable                     " Turn on syntax highlighting
filetype plugin indent on 	      " Enable file type detection.
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
set scrolloff=3                   " Have some context around the current line always on screen
set autoread                      " Watch out for file changes
set splitbelow                    " Put new window below the current one
set complete+=kspell              " Autocomplete with dictionary words when spell check is on
set nobackup
set nowritebackup
set undofile                      " Maintain undo history between sessions
set undodir=~/.nvim/_undo
set directory=~/.nvim/_temp
set foldmethod=indent
set foldnestmax=10
set nofoldenable                  " All folds are open
set foldlevel=1
set previewheight=20              " Preview split height
set shell=/usr/local/bin/fish
set rtp+=/usr/local/opt/fzf
set guicursor=                    " Do not change the cursor
set mouse=a                       " Enable mouse for all modes

" Use ripgrep for grepping
if executable('rg')
  set grepprg=rg\ --vimgrep\ --fixed-strings
  set grepformat^=%f:%l:%c:%m
endif

let mapleader = ","

" Leave terminal mode
tnoremap <esc> <C-\><C-n>

" Clear highlighted text
nnoremap <silent> <cr> :nohl<cr>

" Disable Q
nnoremap Q <nop>

" Forget about the damn arrow keys!
nnoremap <Up> <nop>
inoremap <Up> <nop>
vnoremap <Up> <nop>
nnoremap <Down> <nop>
inoremap <Down> <nop>
vnoremap <Down> <nop>
nnoremap <Left> <nop>
inoremap <Left> <nop>
vnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Right> <nop>
vnoremap <Right> <nop>

" Esc is harder to reach
inoremap <C-c> <esc>
inoremap jk <esc>

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>yy "+yy

" fzf
let g:fzf_layout = { 'down': '~30%' }
nnoremap <silent> <C-j> :Files<cr>
nnoremap <silent> <C-k> :GFiles<cr>
nnoremap <silent> <C-f> :Buffers<cr>

nnoremap <silent> K :call SearchWordWithRg()<cr>
vnoremap <silent> K :call SearchVisualSelectionWithRg()<cr>

function! SearchWordWithRg()
  execute 'Rg' expand('<cword>')
endfunction

function! SearchVisualSelectionWithRg() range
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
  execute 'Rg' selection
endfunction

" Expand current path
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" vim-test
let test#ruby#rspec#options = {'suite': '-f p -r ~/.rspec_support/quickfix_formatter.rb -f QuickfixFormatter -o spec/quickfix.out'}

" Populate QuickFix with test suite run result
nnoremap <leader>q :cg spec/quickfix.out<cr>:echo "QuickFix populated"<cr>

function! TestRunner(cmd)
  let opts = {'suffix': ' # vim-test'}

  function! opts.on_exit(job_id, exit_code, event)
    if a:exit_code == 0
      call self.close_terminal()
    endif
  endfunction

  function! opts.close_terminal()
    if bufnr(self.suffix) != -1
      execute 'bdelete!' bufnr(self.suffix)
    end
  endfunction

  call opts.close_terminal()

  vertical botright new
  call termopen(a:cmd . opts.suffix, opts)
  au BufDelete <buffer> wincmd p
  normal G
  wincmd p
endfunction

" Rubocop
function! RunRubocop()
  let opts = {'suffix': ' # rubocop'}

  function! opts.on_exit(job_id, exit_code, event)
    if a:exit_code == 0
      call self.close_terminal()
    endif
  endfunction

  function! opts.close_terminal()
    if bufnr(self.suffix) != -1
      execute 'bdelete!' bufnr(self.suffix)
    end
  endfunction

  call opts.close_terminal()

  vertical botright new

  call termopen('bin/rubocop' . opts.suffix, opts)

  wincmd p
endfunction

nnoremap <silent> <leader>c :call RunRubocop()<cr>

let g:test#custom_strategies = {'testrunner': function('TestRunner')}
let g:test#strategy = 'testrunner'

nnoremap <silent> <leader>s :TestNearest<cr>
nnoremap <silent> <leader>f :TestFile<cr>
nnoremap <silent> <leader>a :TestSuite<cr>
nnoremap <silent> <leader>l :TestLast<cr>
nnoremap <silent> <leader>v :TestVisit<cr>


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

nnoremap <leader>r :call RenameFile()<cr>

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

nnoremap <silent> <leader>wc :call MarkWindowSwap()<cr>
nnoremap <silent> <leader>wp :call DoWindowSwap()<cr>

" Copy current file path to clipboard
nnoremap <silent> <leader>yp :call CopyFilePathToClipboard()<cr>

function! CopyFilePathToClipboard()
  silent call system('pbcopy', expand('%'))
  echo "Copied file path to clipboard"
endfunction

" .rb keywords
autocmd FileType ruby set iskeyword+=?,!

" Because I constantly type :W istead of :w
cnoreabbrev W w

" Because :rg is easier
cnoreabbrev rg Rg

nnoremap <leader>ve :vsplit $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

" Undotree
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 20
let g:undotree_SplitWidth = 40

" Python Mode
let g:pymode_options_colorcolumn = 0
let g:pymode_options = 0

" Spell check on git commit messages
autocmd FileType gitcommit setlocal spell

" Quick search shortcut
nnoremap \ :Rg<space>

" lightline.vim
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste', 'spell' ],
      \             [ 'fugitive', 'readonly', 'filename', 'gitmerge', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ], [ 'obsession' ] ]
      \ },
      \ 'component_function': {
      \   'mode': 'LightlineMode',
      \   'fugitive': 'LightlineFugitive',
      \   'readonly': 'LightlineReadonly',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'gitmerge': 'LightlineGitmerge',
      \ },
      \ 'component_expand': {
      \   'obsession': 'LightlineObsession'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! LightlineReadonly()
  return &readonly ? '⌀' : ''
endfunction

function! LightlineFugitive()
  if exists("*fugitive#head(7)")
    return winwidth(0) > 60 ? fugitive#head(7) : ''
  endif
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 30 ? lightline#mode() : ''
endfunction

function! LightlineGitmerge()
  let fullname = expand('%')
  let gitversion = ''
  if fullname =~? 'fugitive://.*/\.git//0/.*'
      let gitversion = 'git index'
  elseif fullname =~? 'fugitive://.*/\.git//2/.*'
      let gitversion = 'git target'
  elseif fullname =~? 'fugitive://.*/\.git//3/.*'
      let gitversion = 'git merge'
  elseif &diff == 1
      let gitversion = 'working copy'
  endif
  return gitversion
endfunction

function! LightlineObsession()
    return '%{ObsessionStatus("●", "○")}'
endfunction

let g:jsx_ext_required = 0

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --fixed-strings --smart-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
