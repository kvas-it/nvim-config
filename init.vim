" Vasily Kuznetsov's config for NeoVim.

set nocompatible  " Use Vim settings instead of Vi.

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set visualbell          " less annoying
set nobackup		" don't keep a backup file
set history=100		" keep 100 lines of command line history
set ruler		" show the cursor position all the time
set number		" number lines
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase          " ignore case when searching
set hidden		" allow hidden unsaved buffers
set colorcolumn=80      " show maximal line length aid

if has('mouse')
  set mouse=a
endif

" Configure the clipboard depending on the OS
if has('macunix')
  set clipboard=unnamed   	" use primary OS clipboard
else
  set clipboard=unnamedplus	" use X Window CLIPBOARD clipboard
endif

""" Plugin system

" Install vim-plug if missing.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Load the plugins.
call plug#begin('~/.vim/plugged')

" RipGrep support via Rg command
Plug 'jremmen/vim-ripgrep'

" Ctrl+P to find files
Plug 'kien/ctrlp.vim'

" Airline and other prettification
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'flazz/vim-colorschemes'

" Show VCS status in the gutter
Plug 'mhinz/vim-signify'

" Comment management
Plug 'tpope/vim-commentary'

" Completion with tab
Plug 'ervandew/supertab'

" Async linting
Plug 'dense-analysis/ale'

" Snipmate -- snippet expansion via Tab
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

" Ranger FS manager
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'

call plug#end()

" Airline config
let g:airline_powerline_fonts = 1
set laststatus=2

" Color scheme:
colorscheme jellybeans

""" General handy key bindings
" use Q for formatting
map Q gq
" \\ to open parent directory of current file
map <leader>\ :e %:h<CR>
" \g to ripgrep search for ... (space at the end of next line is significant)
map <leader>g :Rg 

" Signify key bindings
map <leader>s :SignifyToggle<CR>
map <leader>S :SignifyRefresh<CR>

""" Bindings for running terminals
" Exit from insert mode in the terminal window.
tnoremap <Esc> <C-\><C-n>
" Send <Esc> to inside of the terminal (handy if you run another vim there).
tnoremap <leader><Esc> <Esc>
" Open shell
command! Bash e term://bash

""" Other

" Commands to configure indentation
command! TW4 setlocal sw=4 sts=4 et
command! TW2 setlocal sw=2 sts=2 et
command! TT8 setlocal sw=8 sts=8 noet
command! TT4 setlocal sw=4 sts=4 noet

" ALE configuration
let g:ale_sign_error = '!'
let g:ale_sign_warning = '?'
let g:ale_echo_msg_format = '[%linter%] %s'

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif
