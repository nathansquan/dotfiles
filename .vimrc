filetype plugin indent on

syntax enable
"this is a comment
call plug#begin('~/.vim/plugged')
Plug 'junegunn/seoul256.vim' " Color scheme
Plug 'gruvbox-community/gruvbox' " Color scheme
Plug 'vim-pandoc/vim-pandoc' " Pandoc stuff
Plug 'vim-pandoc/vim-pandoc-syntax' " Pandoc stuff
Plug 'jgm/pandoc-citeproc' " Pandoc stuff
Plug 'reedes/vim-pencil' " Super-powered writing things
Plug 'tpope/vim-abolish' " Fancy abbreviation replacements
Plug 'junegunn/limelight.vim' " Highlights only active paragraph
Plug 'junegunn/goyo.vim' " Full screen writing mode
Plug 'reedes/vim-lexical' " Better spellcheck mappings
Plug 'reedes/vim-litecorrect' " Better autocorrections
Plug 'reedes/vim-textobj-sentence' " Treat sentences as text objects
Plug 'reedes/vim-wordy' " Weasel words and passive voice
Plug 'arcticicestudio/nord-vim'
call plug#end()

" Options
set encoding=utf-8
set fileencodings=utf-8
set textwidth=80
set number "Line numbering
"colorscheme seoul256
colorscheme nord
set background=dark

" Goyo remap
nnoremap <C-g> :Goyo<CR>

" Goyo auto open for all markdown files
autocmd FileType markdown Goyo

set incsearch
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

set omnifunc=syntaxcomplete#Complete

" Pencil options
augroup pencil
   autocmd!
   autocmd filetype markdown,mkd call pencil#init()
       \ | call lexical#init()
       \ | call litecorrect#init()
       \ | setl spell spl=en_us fdl=4 noru nonu nornu
       \ | setl fdo+=search
  augroup END
 " Pencil / Writing Controls {{{
   let g:pencil#wrapModeDefault = 'soft'
   let g:pencil#textwidth = 80
   let g:pencil#joinspaces = 0
   let g:pencil#cursorwrap = 1
   let g:pencil#conceallevel = 3
   let g:pencil#concealcursor = 'c'
   let g:pencil#softDetectSample = 20
   let g:pencil#softDetectThreshold = 130
 " }}}


" vim-pandoc
" Requires packages: pandoc, citeproc, 
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
let g:pandoc#modules#disabled = ["folding"]
"Allow vim-pandoc auto execute pandoc on writes
let g:pandoc#command#autoexec_on_writes = 1
let g:pandoc#command#autoexec_command = "Pandoc! pdf"
"bib options
let g:pandoc#biblio#use_bibtool = 1
let g:pandoc#completion#bib#mode = 'citeproc'
let g:pandoc#biblio#sources = 'g'
let g:pandoc#biblio#bibs = ["/home/nathan/Documents/Notes/global.bib"]
