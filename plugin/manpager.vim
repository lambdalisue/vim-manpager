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
  let sect_pattern = '((\d+(\+\d+|\w+)*)|(\w))'
  let psect_pattern = '\v\(' . sect_pattern . '\)'
  let page_pattern = '\v[a-zA-Z][0-9a-zA-Z-]+'
  let pagesect_pattern = page_pattern . psect_pattern
  if !a:0
    let cWORD = expand('<cWORD>')
    let sect = ''
    let page = matchstr(cWORD, pagesect_pattern)
  else
    let sect = (a:1 =~ '\v^' . sect_pattern . '$' ? a:1 : '')
    let page = join(a:000[ (empty(sect) ? 0 : 1) :], '-')
    " for a visual selection of a linebroken link
    let page = substitute(page, '--', '-', 'g')
  endif

  if empty(sect)
    let sect = substitute(matchstr(page, psect_pattern), '\v[()]', '', 'g')
    let page = substitute(page, psect_pattern, '', '')
  endif

  call manpager#open(sect, page)
endfunction

command! -nargs=0 ASMANPAGER call s:MANPAGER()
command! -nargs=* Man      call s:MAN(<f-args>)

let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
