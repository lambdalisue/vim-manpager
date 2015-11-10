let s:save_cpo = &cpo
set cpo&vim

function! s:MANPAGER() abort
  " the content contains ^H if the content is passed from man via stdin
  if !empty($MAN_PN)
    silent file $MAN_PN
  endif
  call manpager#manpagerlize()
endfunction
function! s:MAN(...) abort
  let sect = get(a:000, 0, '')
  let page = get(a:000, 1, sect)
  let sect = sect ==# page ? '' : sect
  if empty(page)
    call manpager#open('', expand('<cword>'))
  else
    call manpager#open(sect, page)
  endif
endfunction

command! -nargs=0 MANPAGER call s:MANPAGER()
command! -nargs=+ Man      call s:MAN(<q-args>)

let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
