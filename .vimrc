syntax on 
set number
set numberwidth=1
set mouse=a
set noerrorbells " desactivar pitido 
set vb t_vb= " desactiva alertas visuales
set nocompatible
set showcmd
set spelllang=es
set spell!
set ruler
set cursorline
set incsearch
set ignorecase
set showmatch
set sw=2 " espacios por autoidentacion
set relativenumber
set nowrap
set tabstop=2 " espacio por tab
set expandtab " cambia la sangria por espacios > <
set autoindent
set laststatus=2 " linea de estado activa (2=always)
set bg=dark
set colorcolumn=120
set autoread " lee automaticamente el archivo si es modificado desde otra fuente
set hlsearch
set hidden
set nohlsearch
let &t_ut=''  " To render properly background of the color scheme
set splitbelow splitright   " Set the splits to open at the right side and below 
set lazyredraw " no renderiza cuando la opcion se ejecuto antes 
set ttyfast " mejora la suavidad cuando hay multiples ventanas
set nrformats+=alpha
filetype plugin on 


"--> CONF - CONFIGURACION DE COMPLEMENTOS PLUGINS
call plug#begin('~/.vim/plugged')

" Temas
Plug 'morhetz/gruvbox'
Plug 'maximbaz/lightline-ale'
Plug 'itchyny/lightline.vim'

 
" IDE
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-signify', {'tag':'legacy'}
Plug 'yggdroot/indentline'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'vimwiki/vimwiki'

" Typing
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'lilydjwg/colorizer'

" Autocomplete
Plug 'sirver/ultisnips'
Plug 'neoclide/coc.nvim', {'branch':'release'} 
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'dhruvasagar/vim-table-mode'

call plug#end()

colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"
let NERDTreeQuitOnOpen=1


"--> CONF - MAPEO DE ATAJOS 
let mapleader=" "
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Busqueda de cadena con fzf
map <Leader>p :Files<CR>
map <Leader>ag :Ag<CR>
" entrar a modo visual block 
nnoremap <Leader><Leader>v <C-V>

nmap <Leader>nt :NERDTreeFind<CR>


" Navegacion de ventanas tmux
nnoremap <silent> <Leader><C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <Leader><C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <Leader><C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <Leader><C-l> :TmuxNavigateRight<CR>

" movimiento rapido de 
nmap <Leader>s <Plug>(easymotion-s2)
nnoremap <C-j> 10<C-e>
nnoremap <C-k> 10<C-y>

" Modificar Texto 
vnoremap <leader>uu :s/\v<\w/\U&/g<CR>

" corrector ortografico
nnoremap <leader><leader>sp :setlocal spell!<CR>

" Configuracion de coc falta depurar
" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
"set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-@> coc#refresh()

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif


" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" configuracion de vim-table-mode
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'

let g:table_mode_corner_corner='+'


if system('uname -r') =~ "microsoft"
	augroup Yank
  autocmd!
  autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
  augroup END
endif

let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
 
autocmd FileType markdown,json setl conceallevel=2
nnoremap <Leader>kp :let @"=expand("%:p")<CR>
