if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal tabstop=8
setlocal nolist
setlocal nospell
setlocal nocursorline
setlocal iskeyword+=\.,-

nnoremap <buffer><silent> <Plug>(manpager-jump)  :<C-u>call manpager#open('', expand('<cword>'))<CR>
nnoremap <buffer><silent> <Plug>(manpager-next-jump) :<C-u>call manpager#find_next_jump()<CR>
nnoremap <buffer><silent> <Plug>(manpager-previous-jump) :<C-u>call manpager#find_previous_jump()<CR>
nnoremap <buffer><silent> <Plug>(manpager-close) :<C-u>q<CR>

nmap <buffer> <C-]> <Plug>(manpager-jump)
nmap <buffer> ]t <Plug>(manpager-next-jump)
nmap <buffer> [t <Plug>(manpager-previous-jump)
nmap <buffer> K <Plug>(manpager-jump)
nmap <buffer> q <Plug>(manpager-close)

let b:undo_ftplugin = 'setlocal iskeyword<'
