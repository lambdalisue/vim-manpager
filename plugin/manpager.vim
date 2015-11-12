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
    let cWORD = expand('<cWORD>')
    let pagesect_pattern = '\v[a-zA-Z-]+\(\w+\)'
    let sect = ''
    let page = matchstr(cWORD, pagesect_pattern)
  else
    let sect = (a:1 =~ '\v^((\d+(\+\d+|\w+)?)|(\w$))$' ? a:1 : '')
    let page = join(a:000[ (empty(sect) ? 0 : 1) :], '-')
  endif

  if empty(sect)
    let sectpattern = '\v\(\w+\)$'
    let sect = substitute(matchstr(page, sectpattern),'\v[()]','','g')
    let page = substitute(page, sectpattern,'','')
  endif

  call manpager#open(sect, page)
endfunction

command! -nargs=0 MANPAGER call s:MANPAGER()
command! -nargs=* Man      call s:MAN(<f-args>)

let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
