setlocal tabstop=8
setlocal nolist
setlocal nospell
setlocal nocursorline
setlocal readonly
setlocal nomodifiable

nnoremap <buffer><silent> <Plug>(manpager-close) :<C-u>q<CR>
nmap <buffer> q <Plug>(manpager-close)
