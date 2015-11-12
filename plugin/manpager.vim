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
  if !a:0
    call manpager#open('', expand('<cword>'))
  else
    let sect = a:1 =~ '\v\d+(\+\d+|\w+)?' ? a:1 : ''
    let page = join(a:000[ (empty(sect) ? 0 : 1) :], '-')
    call manpager#open(sect, page)
  endif
endfunction

command! -nargs=0 MANPAGER call s:MANPAGER()
command! -nargs=* Man      call s:MAN(<f-args>)

let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
