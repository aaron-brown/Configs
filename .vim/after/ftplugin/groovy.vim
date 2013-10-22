setlocal expandtab

setlocal shiftwidth=4
setlocal tabstop=4

highlight OverLength ctermbg=52 ctermfg=214 cterm=bold
match OverLength /\%73v.\+/

set colorcolumn=73
highlight ColorColumn ctermbg=52 ctermfg=214 cterm=bold

colo groovy
