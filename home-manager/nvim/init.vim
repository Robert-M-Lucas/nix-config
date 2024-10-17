" -------------------------------------
"
"   SixthSurge's Neovim configuration
"
"   Last updated 2024-04-18
"
" -------------------------------------

" Test Comment

" Options

syntax on                       " Enable syntax highlighting
filetype plugin indent on       " Indent based of file type
let mapleader = " "
set nocompatible
set showcmd
set noswapfile
set noerrorbells
set laststatus=2
set mouse=a                     " Allow mouse to move the cursor
set cursorline                  " Highlight the line under the cursor
set clipboard+=unnamedplus      " Use system clipboard as primary register
set shortmess=I                 " Prevent Vim startup screen
set backspace=indent,eol,start  " Fix backspace in Insert mode
set nowrap                      " Do not wrap lines
set ic
set sc
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab                   " Expand a tab key into spaces
set autoindent                  " Simple indentation for text files
set number                      " Display line number
set relativenumber              " Display line numbers relative to cursor
set hidden                      " Allow hidden buffers (more than one tab)
set exrc                        " Execute .vimrc in project directory
set secure                      " .vimrc in project directory can not run system commands
set textwidth=100
set completeopt-=preview
set nobackup                    " Recommended by CoC
set nowritebackup
set wildchar=<Tab>
set wildmenu
set wildmode=full
set shell=fish

" Stop 'cindent' from indenting namespace contents or group labels.
set cino+=N-s
set cino+=g0

" Enable proper text colours in Neovim.
if has('nvim')
    set termguicolors
endif

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
else
    set signcolumn=yes
endif

" Use '//' style comments in C++
autocmd FileType cpp setlocal commentstring=//\ %s

" Make escape instant when leaving insert mode.
augroup FASTESCAPE
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
augroup END

augroup FORMATOPTIONS
    autocmd!
    autocmd FileType * set fo-=c fo-=r fo-=o " Disable continuation of comments to the next line
    autocmd FileType * set formatoptions+=j  " Remove a comment leader when joining lines
    autocmd FileType * set formatoptions+=l  " Don't break a line after a one-letter word
    autocmd FileType * set formatoptions+=n  " Recognize numbered lists
    autocmd FileType * set formatoptions-=q  " Don't format comments
    autocmd FileType * set formatoptions-=t  " Don't autowrap text using 'textwidth'
augroup END

" Enable 100-column warning
augroup OVERLENGTH
    autocmd BufEnter * highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    autocmd BufEnter * match OverLength /\%101v.*/
augroup END

" <ESC> in normal mode clears search
nnoremap <silent> <ESC> :noh<CR><ESC>

" F5 to quick switch buffers
nnoremap <F5> :buffers<CR>:buffer<Space>

" Move lines up and down with <C-j> and <C-k>
" Credit to u/-romainl- on Reddit
nnoremap <C-k> :<C-u>move-2<CR>==
nnoremap <C-j> :<C-u>move+<CR>==
xnoremap <C-k> :move-2<CR>='[gv
xnoremap <C-j> :move'>+<CR>='[gv

" Terminal mode mappings
tnoremap <ESC> <C-\><C-n>
tnoremap <C-ESC> <ESC>
tnoremap <C-w> <C-\><C-n><C-w>

" Plugins:
"
call plug#begin(expand('~/.vim/plugged'))
Plug 'preservim/nerdtree'                                " NERDTree file tree explorer
Plug 'neoclide/coc.nvim', {'branch': 'release'}          " Provides autocomplete and LSP
Plug 'nvim-lua/plenary.nvim'                             " Required for Telescope
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' } " Fuzzy finder with preview
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'liuchengxu/vista.vim'                              " LSP/ctag symbol viewer
Plug 'ahmedkhalf/project.nvim'                           " Project management
Plug 'sheerun/vim-polyglot'                              " Syntax hightlighting for lots of languages
Plug 'https://github.com/DingDean/wgsl.vim'              " wgsl syntax highlighting
Plug 'tpope/vim-commentary'                              " Automatically comment and uncomment regions
Plug 'tpope/vim-surround'                                " Automatically surround regions
Plug 'unblevable/quick-scope'                            " Highlights each unique character on a line
Plug 'jiangmiao/auto-pairs'                              " Automatically insert matching brackets
Plug 'kshenoy/vim-signature'                             " Improves Vim marks
Plug 'vim-airline/vim-airline'                           " Enhanced status bar
Plug 'vim-airline/vim-airline-themes'                    " Themes for airline
Plug 'frazrepo/vim-rainbow'                              " Rainbow brackets
Plug 'editorconfig/editorconfig-vim'                     " Load project style settings from .editorconfig
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }           " Catppuccin colour theme
Plug 'morhetz/gruvbox'
Plug 'ryanoasis/vim-devicons'                            " Icons for NERDTree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'           " NERDTree colouring
Plug 'PhilRunninger/nerdtree-buffer-ops'        " More operations for NERDTree
call plug#end()

" --- Plugin configuration ---

" CoC:
"
set updatetime=300
set shortmess+=c

" Strip trailing whitespace on file save
" https://unix.stackexchange.com/questions/75430/how-to-automatically-strip-trailing-spaces-on-save-in-vi-and-vim answer from Runium
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

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
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

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

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>fs <Plug>(coc-format-selected)
nmap <leader>fs <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" NERDTree
"
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

" Telescope
"
lua << EOF
require('telescope').setup {
  defaults = { 
    file_ignore_patterns = { 
      "node_modules" 
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  }
}

require('telescope').load_extension('fzf')
EOF

nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>k <cmd>Telescope buffers<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fp <cmd>Telescope projects<cr>

" vista.vim

" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista_default_executive = 'coc'

nmap <leader>v :Vista!!<CR>

" (old) YCM:
"
" nmap gr :YcmCompleter GoToReferences<CR>
" nmap <leader>fix :YcmCompleter FixIt<CR>
" nmap <F2> :YcmCompleter RefactorRename

" Quickscope:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Rust:
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

" Catpuccin:

lua << EOF
    require("catppuccin").setup({
    no_italic = true, -- Force no italic
})
EOF

" project.nvim

lua << EOF
  require("project_nvim").setup {
  }

require('telescope').load_extension('projects')
EOF

nnoremap <leader>pr :ProjectRoot<CR>

" Themes: (must be after plugin config)
"
colo catppuccin-mocha
set bg=dark
let g:airline_theme='catppuccin'
let g:airline_powerline_fonts=1

" vim-rainbow
"
let g:rainbow_active = 1
let g:rainbow_guifgs = ['#89b4fa', '#89dceb', '#94e2d5', '#f9e2af', '#fab387', '#f83ba8', '#f5c2e7', '#cba6f7', '#bfbefe']

" Enter insert mode in terminal by default
autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

" Set C as the default language for .h files
let g:c_syntax_for_h = 1

" Recognize wgsl
au BufNewFile,BufRead *.wgsl set filetype=wgsl
