let s:save_cpo = &cpo
set cpo&vim

function! s:remove_backspaces() abort " {{{
  let saved_modifiable = &l:modifiable
  let saved_readonly = &l:readonly
  let saved_modified = &l:modified
  let saved_pos = getpos('.')
  keepjumps silent :%s/.//g
  call setpos('.', saved_pos)
  let &l:modifiable = saved_modifiable
  let &l:readonly = saved_readonly
  let &l:modified = saved_modified
endfunction " }}}

function! manpager#enable(bang) abort " {{{
  augroup vim-manpager-ac
    autocmd! *
    autocmd FileType man call s:remove_backspaces()
  augroup END
  if a:bang ==# '!'
    setfiletype man
  endif
endfunction " }}}
function! manpager#disable() abort " {{{
  augroup vim-manpager-ac
    autocmd! *
  augroup END
endfunction " }}}

command! -nargs=0 -bang MANPAGER call manpager#enable(<q-bang>)

let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
