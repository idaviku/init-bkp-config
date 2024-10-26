" Habilitar la sintaxis resaltada
syntax on 
" configuracion basica
set number
set encoding=utf-8
set numberwidth=1
set mouse=a
set noerrorbells " desactivar pitido 
set vb t_vb= " desactiva alertas visuales
set nocompatible
set showcmd
set spelllang=es
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
set nrformats+=alpha  " sets foreground color (ANSI, true-color mode)
set backspace=indent,eol,start
let &t_8f = "\e[38;2;%lu;%lu;%lum"
" sets background color (ANSI, true-color mode)
let &t_8b = "\e[48;2;%lu;%lu;%lum"
set termguicolors
colorscheme retrobox
filetype plugin on 

" CONF - CONFIGURACION DE COMPLEMENTOS PLUGINS
call plug#begin('~/.vim/plugged')

" Temas
"Plug 'morhetz/gruvbox'
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
Plug 'mattn/emmet-vim' " <c-y>,
Plug 'scrooloose/nerdcommenter' " <leader>c<space>
Plug 'vimwiki/vimwiki' " :VimWikiUISelect
Plug 'rhysd/vim-healthcheck'

" Typing
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'lilydjwg/colorizer'

" Autocomplete
Plug 'SirVer/ultisnips' " :UltiSnipsEdit
Plug 'honza/vim-snippets'
"Plug 'thomasfaingnaert/vim-lsp-snippets'
"Plug 'thomasfaingnaert/vim-lsp-ultisnips'
"Plug 'prabirshrestha/async.vim'
Plug 'neoclide/coc.nvim', {'branch':'release'} 
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround' " cs<caracter> ds<char> ysiw<char> , mode(v) S
Plug 'dhruvasagar/vim-table-mode' " <leader>tm
"Plug 'prabirshrestha/ vim-lsp'
"Plug 'mattn/vim-lsp-settings'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui' " :DBUI
Plug 'kristijanhusak/vim-dadbod-completion' 

call plug#end()

" Configuracion de tema gruvbox
"colorscheme gruvbox
"let g:gruvbox_contrast_dark = "hard"

let NERDTreeQuitOnOpen=1


" CONF - MAPEO DE ATAJOS 
let mapleader=" "
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Busqueda de cadena con fzf
map <Leader>p :Files<CR>
map <Leader>ag :Ag<CR>
nmap <Leader>nt :NERDTreeFind<CR>

" Entrar A Modo Visual Block 
nnoremap <Leader><Leader>v <C-V>

" Navegacion De Ventanas Tmux
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <Leader><C-h> :<C-U>TmuxNavigateLeft<CR>
nnoremap <silent> <Leader><C-j> :<C-U>TmuxNavigateDown<CR>
nnoremap <silent> <Leader><C-k> :<C-U>TmuxNavigateUp<CR>
nnoremap <silent> <Leader><C-l> :<C-U>TmuxNavigateRight<CR>

" Movimiento Rapido Scroll
nmap <Leader>s <Plug>(easymotion-s2)
nnoremap <silent> <C-j> 10<C-e><CR>
nnoremap <silent> <C-k> 10<C-y><CR>

" Modificar Texto Marcado Primara Letra En Mayuscula 
vnoremap <leader>uu :s/\v<\w/\U&/g<CR>

" Corrector Ortografico Y Forzar Resaltado De Color
nnoremap <leader><leader>sp :setlocal spell!<CR>
highlight SpellBad ctermfg=White ctermbg=red
highlight SpellCap ctermfg=LightYellow ctermbg=red
highlight SpellRare ctermfg=LightBlue ctermbg=red
highlight SpellLocal ctermfg=LightCyan ctermbg=red

" Configuracion de coc falta depurar
" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

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
 
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" configuracion de vim-table-mode
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\') let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\') return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$') 
endfunction
inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'

let g:table_mode_corner_corner='+'

let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
 
autocmd FileType markdown,json setl conceallevel=2
nnoremap <Leader>kp :let @"=expand("%:p")<CR>

" Configuración Del Copiado y pegado Entre Plataformas Wsl
if has('clipboard') && has('unnamedplus')
    " Habilitar el soporte del portapapeles y usar el registro "+ para copiar " y pegar
  set clipboard=unnamedplus
endif

"if system('uname -r') =~ "microsoft"
"    " Configurar autocmds para copiar y pegar texto entre Vim en WSL y
"    " Windows
"  augroup WSLClipboard
"  autocmd!
"  autocmd TextYankPost * if v:event.operator is# 'y' | call system('/mnt/c/Windows/System32/clip.exe', @0) | endif 
"  autocmd VimLeave * call system('cat /dev/null > /dev/clipboard')
"  augroup END
"endif

"Configuracion UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

if system('uname -r') =~ "microsoft"
	augroup Yank
  autocmd!
  autocmd TextYankPost * :call system('clip.exe',@")
  augroup END
endif

" Configuracion De Vimwiki
let wik_doc={'path':'~/wiki/doc/wik-doc','syntax':'default','ext':'md'}
let wik_life={'path':'~/wiki/life/wik-life','syntax':'default','ext':'md'}
let wik_work={'path':'~/wiki/work/wik-work','syntax':'default','ext':'md'}

let g:vimwiki_list=[wik_doc,wik_life,wik_work]

nnoremap <leader>dt i<C-r>=strftime('%d/%m/%Y %A')<CR><Esc>
nnoremap <leader>vr :vsplit $VIMRC<CR>
"command! LiveServer silent !live-server %:p:h &

command! BrowserSync silent !browser-sync start --server %:p:h --files %:p:h --browser "google-chrome-stable"&

function! RunFile()
  let l:filetype = expand('%:e')  " Obtener la extensión del archivo
  execute 'w'  " Guardar el archivo
  if l:filetype == 'py'
    execute '!python3 %'
  elseif l:filetype == 'js'
    execute '!node %'
  elseif l:filetype == 'cpp'
    execute '!g++ % -o %< && ./%<'
  elseif l:filetype == 'sh'
    execute '!bash %'
  else
    echo "No hay soporte para este tipo de archivo."
  endif
endfunction

nnoremap <F5> :call RunFile()<CR>

function! FragmentLines(max_length)
  let l:current_line = getline('.')
  let l:line_length = len(l:current_line)

  if l:line_length <= a:max_length
    return
  endif

  let l:fragments = []
  let l:words = split(l:current_line, '\s\+')
  let l:fragment = ''

  for l:word in l:words
    if len(l:fragment) + len(l:word) + 1 <= a:max_length
      if l:fragment == ''
        let l:fragment = l:word
      else
        let l:fragment .= ' ' . l:word
      endif
    else
      " Si la palabra es más larga que max_length, agrega la palabra como una nueva línea
      if len(l:word) > a:max_length
        if l:fragment != ''
          call add(l:fragments, l:fragment)
        endif
        call add(l:fragments, l:word)
        let l:fragment = ''
      else
        call add(l:fragments, l:fragment)
        let l:fragment = l:word
      endif
    endif
  endfor

  if l:fragment != ''
    call add(l:fragments, l:fragment)
  endif

  call setline('.', l:fragments)
endfunction

nnoremap <leader>f :call FragmentLines(60)<CR>

function! HighlightDuplicates()
  let l:lines = getline(1, '$')
  let l:counts = {}
  for l:line in l:lines
    let l:counts[l:line] = get(l:counts, l:line, 0) + 1
  endfor

  for [l:line, l:count] in items(l:counts)
    if l:count > 1
      " Resaltar la línea
      execute 'syntax match Duplicates "' . l:line . '"'
    endif
  endfor
  highlight Duplicates ctermfg=darkred ctermbg=white cterm=bold
endfunction

nnoremap <leader>rp :call HighlightDuplicates()<CR>

function! RemoveDuplicates()
  let l:lines = getline(1, '$')
  let l:unique_lines = []
  let l:seen = {}
  for l:line in l:lines
    if !has_key(l:seen, l:line)
      call add(l:unique_lines, l:line)
      let l:seen[l:line] = 1
    endif
  endfor

  "let l:delete_all = input("¿Borrar todos los duplicados? (s/n): ")

  "if l:delete_all == 's'
    call setline(1, l:unique_lines)
    let l:remaining_lines = len(l:unique_lines)
    execute (l:remaining_lines + 1) . ",$d"
  "else
    "" Preguntar sobre cada línea duplicada
    "for l:line in keys(l:seen)
      "if l:seen[l:line] > 1
        "let l:confirm = input("¿Borrar todas las instancias de la línea duplicada: '" . l:line . "'? (s/n): ")
        "if l:confirm == 's'
          "" Borrar todas las instancias menos la primera
          "execute 'g/' . escape(l:line, '/') . '/d'
          "let l:seen[l:line] = 1  " Marcar como ya añadida
        "endif
      "endif
    "endfor

    "" Actualizar la lista de líneas a mantener
    "let l:lines_to_keep = []
    "for l:line in l:unique_lines
      "if has_key(l:seen, l:line)
        "call add(l:lines_to_keep, l:line)
      "endif
    "endfor

    "" Actualizar las líneas en el buffer
    "call setline(1, l:lines_to_keep)
    "let l:remaining_lines = len(l:lines_to_keep)
    "execute (l:remaining_lines + 1) . ",$d"  " Eliminar líneas restantes
  "endif 

  redraw!
endfunction

nnoremap <leader>rpd :call RemoveDuplicates()<CR>
