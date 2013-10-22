" Removes the related-highlight when searching.
set nohlsearch

set viminfo='20,\"9001

" Highlight matching ()'s, []'s and {}'s.
set showmatch
set matchtime=3

" Convert tabs to spaces, auto-indent where applicable, and set tabs to be
" 4 spaces instead of 8.
set expandtab
set autoindent
set tabstop=4

" Some filetype plugins have their own indenting intelligence. This
" suppliments auto-indent.
:filetype plugin indent on

" Some special highlighting. The horizontal line the cursor is on will be
" underlined, and the vertical line will be slightly brighter than the
" background.
set cursorline
hi CursorLine cterm=underline
set cursorcolumn
hi CursorColumn ctermbg=black

" If no file-extension is found, treat the file as a text file. This is useful
" and reasonable for any configuration settings you may have for text files,
" and in general just allows you to have a default type.
autocmd BufEnter * if &filetype == "" | setlocal ft=txt | endif

" Use your own custom colorscheme, which will override certain values to your
" preferences.
colo custom

" This function removes trailing whitespace. This is good practice for coding
" as it prevents unecessary diffs in version controlled environments and, in
" general, cuts down on filesize. Below, this will apply it to only certain
" files.
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" Apply the above command to only the listed filetypes, when the file is being
" written to..
autocmd FileType 
    \ c,cpp,groovy,java,php,python,ruby 
    \ autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

