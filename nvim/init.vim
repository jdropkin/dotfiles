
" --- Plugins --- "
call plug#begin('~/.config/nvim/plugged')

" ---- Utilities ---- "
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rust-lang/rust.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ---- Theme ---- "
Plug 'jdropkin/ayu-vim'

call plug#end()

" --- Color Scheme --- "
set termguicolors
let ayucolor="mirage"
colorscheme ayu

" --- General Options --- "
syntax on
set encoding=utf-8 "UTF-8 encoding
set tabstop=4 "4 space tabs
set shiftwidth=4 "4 space shift
set softtabstop=4 "Tab spaces in no hard tab mode
set expandtab "Expand tabs into spaces
set autoindent "Autoindent on new lines
set smartindent "Smart indentation
set showmatch "Show matching braces
set ruler "Show bottom ruler
set equalalways "Split windows equal size
set formatoptions+=croq "Enable comment line auto formatting
set title "Set window title to file
set scrolloff=5 "Never scroll off
set wildmode=longest,list,full "Better unix-like tab completion
set cursorline "Highlight current line
set lazyredraw "Don't redraw while running macros
set backspace=indent,eol,start "Better backspace
set nostartofline "Preserve line position on vertical motion
set number "Show line numbers
set relativenumber "Use relative line numbers
set nowrap "Don't wrap lines
set sidescroll=1 "Smooth scrolling
set listchars=extends:,precedes: "Overflow indicators
set sidescrolloff=1 "Keep cursor from scrolling onto overflow indicators
set mouse=a "Enable mouse
set colorcolumn=81 "Show lines > 80 chars
set laststatus=2 "Always show status bar
set noshowmode "Don't show mode, lightline does anywas
set hidden "Hide unsaved buffers when closing them

" --- Search Options --- "
set hlsearch "Highlight on search
set ignorecase "Search ignoring case
set smartcase "Search using smart case
set incsearch "Start searching immediately

autocmd BufRead *.{c,h} set filetype=c.doxygen

" --- Split Options --- "
set splitbelow "Split to the bottom
set splitright "Split to the right

" --- Leader --- "
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

" --- Splits --- "
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Conveniemt Remaps --- "
inoremap jk <Esc>
nnoremap <leader>w :w<cr>

" --- FZF --- "
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
nnoremap <C-p> :Files<CR>
nnoremap <leader>p :GFiles<CR>

" --- CoC --- "
set updatetime=300 "Lots of people have this

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" --- Bash Language Server --- "
let g:LanguageClient_serverCommands = {
    \ 'sh': ['bash-language-server', 'start']
    \ }

" --- Strip whitespace from EOL on write --- "
function! <SID>StripTrailingWhitespace()
    if &filetype == 'diff'
        return
    endif

    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l,c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespace()

" --- Lightline --- "
let g:lightline = {
    \ 'colorscheme': 'ayu_mirage',
    \ 'active': {
    \ 'left': [ ['mode', 'paste'],
    \           ['cocstatus', 'filename', 'gitbranch', 'modified'] ]
    \ },
    \ 'component_function': {
    \   'cocstatus': 'coc#status',
    \   'filename': 'LightLineFilename',
    \   'gitbranch': 'gitbranch#name'
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }

" ---- Modified ---- "
function! LightLineModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

" ---- Read Only ---- "
function! LightLineReadonly()
    return &ft !~? 'help' && &readonly ? '' : ''
endfunction

" ---- File Name ---- "
function! LightLineFilename()
    let fname = expand('%:t')
    return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
                \ ('' != fname ? fname : '[No Name]') .
                \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

" --- Tags --- "
set tags=.tags,tags;$HOME

" --- RustFmt on Write --- "
let g:rustfmt_autosave = 1

" --- Keep Position When Closing File --- "
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line ("'\"") <= line("$")
      \| exe "normal! g'\"" | endif
endif
