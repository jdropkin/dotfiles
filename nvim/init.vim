
" --- Plugins --- "
call plug#begin('~/.config/nvim/plugged')

" ---- Utilities ---- "
Plug 'itchyny/lightline.vim'
Plug 'rust-lang/rust.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/popup.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'neovim/nvim-lspconfig'
Plug 'ojroques/nvim-lspfuzzy'
Plug 'folke/lsp-colors.nvim'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif


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
"set noshowmode "Don't show mode, lightline does anywas
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

" --- Convenient Remaps --- "
inoremap jk <Esc>
nnoremap <leader>w :w<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>ts :setlocal spell! spell?<CR> " Toggle spell check
nnoremap <leader>h :nohl<CR>
nnoremap <leader>t :tabnext<CR>
nnoremap <leaderT :tabprev<CR>
nnoremap <C-t> :tabnew<CR>
tnoremap jk <C-\><C-n>

" --- FZF --- "
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
nnoremap <C-p> :Files<CR>
nnoremap <leader>p :GFiles<CR>

" --- Deoplete --- "
let g:deoplete#enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

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

" Change these if you want
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '_'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = '~'

" I find the numbers disctracting
let g:signify_sign_show_count = 0
let g:signify_sign_show_text = 1

" --- LSP --- "
lua <<EOF
local lsp = require 'lspconfig'

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    --vim.api.nvim_command 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'

    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    --buf_set_keymap('n', '<space>h', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<space>r', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>n', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>p', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
end

EOF

" --- Tags --- "
set tags=.tags,tags;$HOME

" --- RustFmt on Write --- "
let g:rustfmt_autosave = 1

" --- Keep Position When Closing File --- "
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line ("'\"") <= line("$")
      \| exe "normal! g'\"" | endif
endif


