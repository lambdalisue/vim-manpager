let s:save_cpo = &cpo
set cpo&vim

function! s:get_history() abort " {{{
  let w:_manpager_history = get(w:, '_manpager_history', deepcopy({
        \ 'history': [],
        \ 'index': -2,
        \}))
  return w:_manpager_history
endfunction " }}}

function! manpager#history#add() abort " {{{
  let history = s:get_history()
  let pos = extend([bufnr('%')], getpos('.')[1:])
  call add(history.history, pos)
  let history.index = -2
endfunction " }}}
function! manpager#history#open(index) abort " {{{
  let index = a:index
  let history = s:get_history()
  if index == -2 || index >= len(history.history)
    let index = len(history.history) - 1
  elseif index < 0
    let index = 0
  endif
  call setpos('.', history.history[index])
  let history.index = index
endfunction " }}}
function! manpager#history#next() abort " {{{
  let history = s:get_history()
  let index = history.index + 1
  if history.index == -2 || index >= len(history.history)
    let index = len(history.history) - 1
  elseif index < 0
    let index = 0
  endif
  let [bufnum, lnum, col, off] = history.history[index]
  execute printf('%dbuffer', bufnum)
  call setpos('.', [0, lnum, col, off])
  let history.index = index
endfunction " }}}
function! manpager#history#previous() abort " {{{
  let history = s:get_history()
  let index = history.index - 1
  if history.index == -2 || index >= len(history.history)
    let index = len(history.history) - 1
  elseif index < 0
    let index = 0
  endif
  let [bufnum, lnum, col, off] = history.history[index]
  execute printf('%dbuffer', bufnum)
  call setpos('.', [0, lnum, col, off])
  let history.index = index
endfunction " }}}

let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
