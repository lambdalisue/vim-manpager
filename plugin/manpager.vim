let s:save_cpo = &cpo
set cpo&vim

function! s:remove_backspaces() abort " {{{
  let saved_modifiable = &l:modifiable
  let saved_readonly = &l:readonly
  let saved_modified = &l:modified
  setl modifiable noreadonly
  let saved_pos = getpos('.')
  keepjumps :%s/.//ge
  call setpos('.', saved_pos)
  let &l:modifiable = saved_modifiable
  let &l:readonly = saved_readonly
  let &l:modified = saved_modified
endfunction " }}}

function! manpager#enable() abort " {{{
  call s:remove_backspaces()
  setfiletype man
  setlocal nomodified
endfunction " }}}

command! -nargs=0 MANPAGER call manpager#enable()

let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
