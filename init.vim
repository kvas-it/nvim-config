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
call plug#begin('~/.config/nvim/plugged')

" RipGrep support via Rg command (
Plug 'jremmen/vim-ripgrep'

map <leader>g :FRg 

" Ctrl+P to find files and Ctrl+B to find buffers
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

let g:fzf_command_prefix = 'F'
map <C-p> :FGFiles<CR>
map <C-b> :FBuffers<CR>
map <C-h> :FHistory<CR>

" Prettification
Plug 'itchyny/lightline.vim'
Plug 'flazz/vim-colorschemes'

set laststatus=2
set noshowmode

" Show VCS status in the gutter
Plug 'mhinz/vim-signify'

map <leader>s :SignifyToggle<CR>
map <leader>S :SignifyRefresh<CR>

" Comment management
Plug 'tpope/vim-commentary'

" Completion with tab
Plug 'ervandew/supertab'

" Async linting
Plug 'dense-analysis/ale'

let g:ale_sign_error = '!'
let g:ale_sign_warning = '?'
let g:ale_echo_msg_format = '[%linter%] %s'

" Snipmate -- snippet expansion via Tab
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

" End of plugins
call plug#end()

" Set color scheme (can't be done before plugins load)
colorscheme jellybeans

""" General handy key bindings
" use Q for formatting
map Q gq
" \\ to open parent directory of current file
map <leader>\ :e %:h<CR>

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

au FileType markdown TW2

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif

""" Running files via \R and \r
let g:run_cmd = 'vimrun'

" command and function to run files via vimrun or other command
command! -complete=file -nargs=? Run call Run(<q-args>)
function! Run(...)
  if a:0 > 0 && a:1 != ''
    let g:run_target=a:1
  endif
  if exists('g:run_target')
    wa
    execute 'sp term://' . g:run_cmd . ' ' . g:run_target
  else
    Run %:p
  endif
endfunction

" key bindings to run current file and last file
map <leader>R :wa<CR>:Run %:p<CR>
map <leader>r :wa<CR>:Run<CR>
