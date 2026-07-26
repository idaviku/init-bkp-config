" ==========================================================
" ARCHIVO DE CONFIGURACIÓN VIM (.vimrc) - VERSIÓN OPTIMIZADA
" ==========================================================

" ----------------------------------------------------------
" 1. CONFIGURACIÓN BÁSICA Y CORE DEL EDITOR
" ----------------------------------------------------------

syntax on
set nocompatible
filetype plugin indent on

set number
set relativenumber
set numberwidth=1
set encoding=utf-8
set mouse=a
set laststatus=2
set showcmd
set ruler
set cursorline
set splitbelow splitright
set hidden

" Gestión de rendimiento en renderizado
set lazyredraw
set ttyfast

" Búsqueda inteligente e idempotente
set incsearch
set ignorecase
set smartcase
set showmatch
set hlsearch
set nohlsearch

" Tabuladores, Sangrías y Ajustes de Línea
set sw=2
set tabstop=2
set expandtab
set autoindent
set nowrap
set linebreak
set showbreak=->
set breakindent
set colorcolumn=120

" Alertas de Sistema e Integridad de Archivos
set noerrorbells
set vb t_vb=
set autoread
set backspace=indent,eol,start
set spelllang=es
"set guifont=CaskaydiaCove\ Nerd\ Font:h14

" Configuración estricta de seguridad para CoC (Evitar corrupción)
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes

" Permitir caracteres alfabéticos en formatos de numeración incremento/decremento
set nrformats+=alpha

" Ajustes True-Color (Termguicolors) preventivos para Tmux / Zsh
let &t_ut=''
let &t_8f = "\e[38;2;%lu;%lu;%lum"
let &t_8b = "\e[48;2;%lu;%lu;%lum"
set termguicolors
set bg=dark
colorscheme retrobox

" ----------------------------------------------------------
" 2. GESTIÓN DE COMPLEMENTOS (VIM-PLUG)
" ----------------------------------------------------------
call plug#begin('~/.vim/plugged')

" Interfaz y Temas
Plug 'maximbaz/lightline-ale'
Plug 'itchyny/lightline.vim'

" Productividad, Navegación e IDE
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-signify', {'tag':'legacy'}
Plug 'yggdroot/indentline'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'vimwiki/vimwiki'
Plug 'rhysd/vim-healthcheck'

" Utilidades de Escritura y Edición
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'lilydjwg/colorizer'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'dhruvasagar/vim-table-mode'

" Motores de Autocompletado y Snippets (Entorno de Desarrollo)
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch':'release'}

" Gestión de Base de Datos Integrada (Investigación/Desarrollo)
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'

call plug#end()

" Parámetros de Plugins individuales
let NERDTreeQuitOnOpen=1
let g:user_emmet_install_global = 0
let g:table_mode_corner_corner='+'
autocmd FileType html,css EmmetInstall
autocmd FileType markdown,json setl conceallevel=2
" Forzar a CoC a usar el binario ejecutable directo de NVM (Evita conflictos de Lazy Load)
let g:coc_node_path = '~/.nvm/versions/node/v22.5.1/bin/node'

" ----------------------------------------------------------
" 3. MAPEO DE ATAJOS DE TECLADO & LIDER
" ----------------------------------------------------------
let mapleader=" "

" Deshabilitar Flechas de Dirección (Obligar uso de teclas de movimiento estándar HJKL)
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
nnoremap <C-a> <nop>

" Atajos de Navegación Rápida y FZF
map <Leader>p :Files<CR>
map <Leader>ag :Ag<CR>
nmap <Leader>nt :NERDTreeFind<CR>
nnoremap <Leader><Leader>v <C-V>

" Navegación Asíncrona nativa de Ventanas Tmux
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <Leader><C-h> :<C-U>TmuxNavigateLeft<CR>
nnoremap <silent> <Leader><C-j> :<C-U>TmuxNavigateDown<CR>
nnoremap <silent> <Leader><C-k> :<C-U>TmuxNavigateUp<CR>
nnoremap <silent> <Leader><C-l> :<C-U>TmuxNavigateRight<CR>

" Movimientos Easymotion y Desplazamiento Veloz
let g:EasyMotion_use_upper = 1
let g:EasyMotion_smartcase = 1
  nmap <Leader>s <Plug>(easymotion-s2)
nnoremap <silent> <C-j> 10<C-e><CR>
nnoremap <silent> <C-k> 10<C-y><CR>

" Utilidades de Edición Rápidas
vnoremap <leader>uu :s/\v<\w/\U&/g<CR>
nnoremap <leader>kp :let @"=expand("%:p")<CR>
nnoremap <leader>vr :vsplit $VIMRC<CR>
nnoremap <leader><leader>sp :setlocal spell!<CR>

" Estampado de Fechas
nnoremap <leader>dt i<C-r>=strftime('%d/%m/%Y %A')<CR><Esc>
nnoremap <leader>dth i<C-r>=strftime('%d/%m/%Y %T %A')<CR><Esc>

" Comandos de Servidores Web de Desarrollo
command! BrowserSync silent !browser-sync start --server %:p:h --files %:p:h --browser "google-chrome-stable"&

" ----------------------------------------------------------
" 4. INTEGRACIÓN ASÍNCRONA DE RESPALDOS (BKP4DUMMIES) 
" ----------------------------------------------------------
augroup AutobkpDummies
  autocmd!
  if has('job') && !has('nvim')
    autocmd BufWritePre ~/.vimrc,~/.zshrc,~/.tmux.conf call RunBkpAsync(expand('<afile>:p'))
  elseif has('nvim')
    autocmd BufWritePre ~/.vimrc,~/.zshrc,~/.tmux.conf call jobstart(['/home/davik/rootx56/config/init-bkp-config/scripts/bkp4dummies.sh', expand('<afile>:p')])
  else
    autocmd BufWritePre ~/.vimrc,~/.zshrc,~/.tmux.conf silent! :!/home/davik/rootx56/config/init-bkp-config/scripts/bkp4dummies.sh %
  endif
augroup END

function! RunBkpAsync(filepath)
  let l:cmd = ['/home/davik/rootx56/config/init-bkp-config/scripts/bkp4dummies.sh', a:filepath]
  call job_start(l:cmd, {"stoponexit": ""})
endfunction

" ----------------------------------------------------------
" 5. CONFIGURACIÓN ASÍNCRONA DE COALESCENCIA (COC.NVM) & COMPLETADO
" ----------------------------------------------------------
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-@> coc#refresh()

" Desplazamiento en Ventanas Flotantes de CoC
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Atajos de Navegación de Código (LSP)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>cl <Plug>(coc-codelens-action)
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" RESOLUCIÓN DE CONFLICTO COCVSP vs ULTISNIPS: Mapeo alternativo para Snippets
let g:UltiSnipsExpandTrigger="<c-space>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" ----------------------------------------------------------
" 6. PORTAPAPELES COMPARTIDO INTER-PLATAFORMAS (WSL / LOCAL)
" ----------------------------------------------------------
if has('clipboard') && has('unnamedplus')
  set clipboard=unnamedplus
endif

if system('uname -r') =~? "microsoft"
  augroup WSLClipboard
    autocmd!
    autocmd TextYankPost * :call system('clip.exe', @")
  augroup END
endif

" ----------------------------------------------------------
" 7. FUNCIONES EXTENDIDAS DE USUARIO (AUTOMATIZACIONES DE TEXTO)
" ----------------------------------------------------------

" --- Ejecutor de Archivos en Caliente de Forma Segura ---
function! RunFile()
  let l:filetype = expand('%:e')
  execute 'w'
  if l:filetype == 'py'
    execute '!python3 ' . shellescape(expand('%:p'))
  elseif l:filetype == 'js'
    execute '!node ' . shellescape(expand('%:p'))
  elseif l:filetype == 'cpp'
    execute '!g++ ' . shellescape(expand('%:p')) . ' -o ' . shellescape(expand('%:p:r')) . ' && ' . shellescape(expand('%:p:r'))
  elseif l:filetype == 'sh'
    execute '!bash ' . shellescape(expand('%:p'))
  else
    echo "No hay soporte nativo de ejecución rápida para extensiones ." . l:filetype
  endif
endfunction
nnoremap <F5> :call RunFile()<CR>

" --- Formateador y Resaltador de Duplicados e Hitos Visuales ---
let g:highlighted_lines = []

highlight SpellBad ctermfg=White ctermbg=red
highlight SpellCap ctermfg=LightYellow ctermbg=red
highlight resaltado1 ctermfg=yellow ctermbg=red guifg=yellow guibg=red
highlight resaltado2 ctermfg=black ctermbg=cyan guifg=black guibg=cyan
highlight resaltado3 ctermfg=black ctermbg=green guifg=black guibg=green

function! HighlightSelection(style)
  let l:selection = escape(@", '\')
  let l:id = matchadd(a:style, l:selection)
  call add(g:highlighted_lines, [a:style . "\t" . l:selection, l:id])
endfunction

function! UnhighlightSelection()
  let l:selection = escape(@", '\')
  for idx in range(len(g:highlighted_lines))
    let parts = split(g:highlighted_lines[idx][0], '\t')
    if parts[1] == l:selection
      call matchdelete(g:highlighted_lines[idx][1])
      call remove(g:highlighted_lines, idx)
      break
    endif
  endfor
endfunction

vnoremap <leader>re1 y:call HighlightSelection('resaltado1')<CR>
vnoremap <leader>re2 y:call HighlightSelection('resaltado2')<CR>
vnoremap <leader>re3 y:call HighlightSelection('resaltado3')<CR>
vnoremap <leader>reu y:call UnhighlightSelection()<CR>

augroup HighlightPersistence
  autocmd!
  autocmd BufWritePost * call SaveHighlightedLines()
  autocmd BufReadPost * call LoadHighlightedLines()
augroup END

function! SaveHighlightedLines()
  if !empty(g:highlighted_lines)
    let l:file = expand('%:p:h') . '/.' . expand('%:t') . '.highlight'
    let lines = map(copy(g:highlighted_lines), 'v:val[0]')
    call writefile(lines, l:file)
  elseif filereadable(expand('%:p:h') . '/.' . expand('%:t') . '.highlight')
    call delete(expand('%:p:h') . '/.' . expand('%:t') . '.highlight')
  endif
endfunction

function! LoadHighlightedLines()
  let l:file = expand('%:p:h') . '/.' . expand('%:t') . '.highlight'
  if filereadable(l:file)
    let lines = readfile(l:file)
    for line in lines
      let parts = split(line, '\t')
      let id = matchadd(parts[0], parts[1])
      call add(g:highlighted_lines, [line, id])
    endfor
  endif
endfunction

" --- Procesador de Líneas Duplicadas y Fragmentación ---
function! FragmentLines(max_length)
  let l:current_line = getline('.')
  if len(l:current_line) <= a:max_length | return | endif
  let l:fragments = []
  let l:words = split(l:current_line, '\s\+')
  let l:fragment = ''
  for l:word in l:words
    if len(l:fragment) + len(l:word) + 1 <= a:max_length
      let l:fragment = (l:fragment == '') ? l:word : l:fragment . ' ' . l:word
    else
      if len(l:word) > a:max_length
        if l:fragment != '' | call add(l:fragments, l:fragment) | endif
        call add(l:fragments, l:word)
        let l:fragment = ''
      else
        call add(l:fragments, l:fragment)
        let l:fragment = l:word
      endif
    endif
  endfor
  if l:fragment != '' | call add(l:fragments, l:fragment) | endif
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
    if l:count > 1 && !empty(l:line)
      execute 'syntax match Duplicates "' . escape(l:line, '"\^$*[]') . '"'
    endif
  done
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
  call setline(1, l:unique_lines)
  execute (len(l:unique_lines) + 1) . ",$d"
  redraw!
endfunction
nnoremap <leader>rpd :call RemoveDuplicates()<CR>

function! SortArray()
  for l:line in getline("'<", "'>")
    let l:sorted_line = join(sort(split(l:line, '\s\+')), ' ')
    call setline('.', l:sorted_line)
  endfor
endfunction
vnoremap <leader>sa :call SortArray()<CR>

" --- Habilitación Estricta de Tablas Inteligentes ---
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar> <SID>isAtStartOfLine('\|\|') ? '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __ <SID>isAtStartOfLine('__') ? '<c-o>:silent! TableModeDisable<cr>' : '__'
