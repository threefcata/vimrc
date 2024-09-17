runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" NERDTree related

map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" YouCompleteMe
let g:ycm_auto_trigger = 1   

syn on " Syntax highlighting on
if has("unix")
    colorscheme desert
endif

filetype plugin on
filetype plugin indent on
filetype indent on
autocmd FileType markdown setlocal nocindent
autocmd FileType text setlocal nocindent
autocmd FileType latex setlocal nocindent
autocmd FileType asciidoc setlocal nocindent noautoindent nosmartindent
autocmd FileType asciidoc setlocal fo=want 
autocmd FileType asciidoc hi clear ExtraWhitespace

if version >= 700
  set omnifunc=syntaxcomplete#Complete
  set completeopt=menuone,menu,longest
  let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
  highlight   clear
  highlight   Pmenu         ctermfg=0 ctermbg=2
  highlight   PmenuSel      ctermfg=0 ctermbg=7
  highlight   PmenuSbar     ctermfg=7 ctermbg=0
  highlight   PmenuThumb    ctermfg=0 ctermbg=7
end

if has("gui_running")
  if has("macunix")
    set guifont=Monaco:h14 " use this font
    set lines=70 " height = 50 lines
    set columns=90 " width = 100 columns
  elseif has("unix")
    set guifont=Lucida\ Console:h10 " use this font
    set lines=70 " height = 50 lines
    set columns=90 " width = 100 columns
  endif
endif
set tw=90
set mouse=a

" Tab and indent options =======================================================
set number
set relativenumber
set tabstop=4 " Tab is 4 spaces and NOT the default 8
set shiftwidth=4 " numbers of spaces to (auto)indent
set expandtab " Expand tab to spaces
set cindent " cindent
set smartindent " smart indent
set autoindent " always set autoindenting on
set softtabstop=4 " makes the spaces feel like real tabs. E.g. back deletes all 4 chars
set backspace=indent,eol,start " backspace deletes indent, eol and start lineset hlsearch
set cinoptions=l1
nnoremap H gT
nnoremap L gt
set fo+=mM
" Display options ===============================================================
set cursorline
" hi CursorLine cterm=NONE ctermbg=black guibg=black
set ruler
if exists('+autochdir')
    set autochdir
else
    autocmd BufEnter * silent! lcd %:p:h:gs/ /\ /
endif
set langmenu=none
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/
" Tags related ==================================================================
"let Tlist_Ctags_Cmd = "ctags.exe"
set tags=./tags,tags;
set tags+=~/.vim/tags/c
"set tags+=~/.vim/tags/c++
set grepprg=grep\ -nH\ $*

let g:ale_linters = {'rust': ['analyzer']}
let g:ale_linters_explicit = 1
augroup filetype_rust
    if tagfiles() == []
        au!
        au BufRead,BufNewFile *.rs nnoremap K :ALEHover<CR>
        au BufRead,BufNewFile *.rs nnoremap <C-]> :ALEGoToDefinition<CR>
    endif
augroup END


let g:tex_flavor = "pdftex"
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_MultipleCompileFormats="pdf,bib,pdf"
let g:Tex_GotoError = 0
let g:Tex_ShowErrorContext = 0
let g:tex_comment_nospell = 1

if has("macunix")
    let g:Tex_TreatMacViewersAsUNIX = 1
    let g:Tex_ExecuteUNIXViewerInForeground = 1
    let g:Tex_ViewRule_ps = 'open -a Skim'
    let g:Tex_ViewRule_pdf = 'open -a /Applications/Skim.app'
    let g:Tex_ViewRule_dvi = 'open -a /Applications/Skim.app'
elseif has("unix")
    let g:Tex_ViewRule_pdf = "okular"
endif
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
let php_sql_query = 1
let php_htmlInStrings = 1
" File operations ===============================================================
set hidden
set confirm
set nobackup
set hidden
" Search options ================================================================
set incsearch
set hlsearch
" Keymaps =======================================================================
nnoremap <c-l> <c-l>:noh<return>
nnoremap <F12> :TlistToggle<return>
"inoremap ( ()i
"inoremap " ""i
"inoremap ¡® "i
"inoremap [ []i
"inoremap { {}i
" for php:
"imap vv $
"imap .. ->
" Autocmd for different behavior based on filetype==============================
autocmd FileType tex set spell nocindent nosmartindent noautoindent nocursorline tw=90
" Disable logging of the JS indent plugin
let g:js_indent_log = 0

function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose             " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
    set cscopetag
    set cst
    set csto=0
  endif
endfunction
au BufEnter /* call LoadCscope()

function! UpdateTags()
  execute ":!ctags -R --languages=C,C++ --c++-kinds=+p --fields=+iaS --extra=+q ./"
  echohl StatusLine | echo "C/C++ tag updated" | echohl None
endfunction
nnoremap <F4> :call UpdateTags()
set csre

" Aligns backslash characters at the end of lines.
" Useful when writing multiline macros or multiline strings.
function AlignBackslash()
   :silent! s@\s\+\\$@ \\@
   :silent! s/s*\\$/\=repeat(' ', 80-col('.')).'\'
   :let @/ = ""
endfunction

function RemoveDuplicateBackslash()
   :silent! s/\\\\$/\\/g
endfunction

" In normal mode align the whole file.
nmap \\ mxggVG:call RemoveDuplicateBackslash()<cr>ggVG:call AlignBackslash()<cr>'x

" In visual select mode align selected lines.
vmap \\ :call RemoveDuplicateBackslash()<cr>gv:call AlignBackslash()<cr>

" Insert backslash at the end of current line and align it
nmap <c-\> A\<esc>:call AlignBackslash()<cr>

" Insert backslash at the end of selected lines and align them
vmap <c-\> :norm A\<esc>gv:call AlignBackslash()<cr>
