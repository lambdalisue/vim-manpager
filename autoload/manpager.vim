let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('manpager')
let s:R = s:V.import('Process')
let s:B = s:V.import('Vim.BufferManager')
let s:b = s:B.new()
let s:is_win = has('win16') || has('win32') || has('win64')

function! s:args(section, page) abort " {{{
  if empty(a:section)
    return [a:page]
  else
    return [s:man_sect_arg, a:section, a:page]
  endif
endfunction " }}}
function! s:remove_backspaces() abort " {{{
  let saved_pos = getpos('.')
  :%s/.//ge
  keepjump call setpos('.', saved_pos)
endfunction " }}}
function! s:find_keyword(flag, ...) abort " {{{
  let saved_pos = getpos('.')
  let pattern = '\w\+\%((\d\+)\)'
  while search(pattern, a:flag) > 0
    let name = synIDattr(synID(line('.'), col('.'), 0), 'name')
    if name ==# 'manReference'
      return
    endif
  endwhile
  let wrapscan = get(a:000, 0, g:manpager#wrapscan)
  if wrapscan
    keepjump silent execute a:flag =~# '^b' ? 'normal GG' : 'normal gg'
    while search(pattern, a:flag, saved_pos[1]) > 0
      let name = synIDattr(synID(line('.'), col('.'), 0), 'name')
      if name ==# 'manReference'
        return
      endif
    endwhile
  endif
  " no available jump is found
  keepjump call setpos('.', saved_pos)
endfunction " }}}

function! manpager#load(section, page) abort " {{{
  let args = extend(
        \ [g:manpager#man_executable, '--pager='],
        \ s:args(a:section, a:page),
        \)
  let stdout = s:R.system(args)
  let status = s:R.get_last_status()
  return {
        \ 'stdout': stdout,
        \ 'status': status,
        \}
endfunction " }}}
function! manpager#open(section, page) abort " {{{
  let name = empty(a:section) ? a:page : printf('%s(%s)', a:page, a:section)
  let result = manpager#load(a:section, a:page)
  if result.status
    echohl Error
    echo printf('man page for "%s" could not be loaded.', name)
    echohl None
    return result.status
  endif
  let contents = split(result.stdout, '\v\r?\n')

  let bufname = join(['MAN', name], s:is_win ? '_' : ':')
  call s:b.open(bufname, {
        \ 'opener': g:manpager#buffer_opener,
        \ 'range': g:manpager#buffer_range,
        \})
  setlocal buftype=nofile noswapfile nobuflisted
  setlocal modifiable
  keepjumps silent execute 'norm 1GdG'
  keepjumps silent call setline(1, contents)
  setlocal nomodifiable
  setlocal nomodified
  setfiletype man
  call manpager#history#add()
endfunction " }}}
function! manpager#find_next_keyword() abort " {{{
  call s:find_keyword('W')
endfunction " }}}
function! manpager#find_previous_keyword() abort " {{{
  call s:find_keyword('bW')
endfunction " }}}
function! manpager#manpagerlize() abort " {{{
  setlocal buftype=nofile noswapfile nobuflisted
  setlocal modifiable
  keepjumps call s:remove_backspaces()
  setlocal nomodifiable
  setlocal nomodified
  setfiletype man
  call s:b.add(bufnr('%'))
  call manpager#history#add()
endfunction " }}}


let s:default_settings = {
      \ 'man_executable': 'man',
      \ 'man_sect_arg': '',
      \ 'man_find_arg': '-w',
      \ 'buffer_opener': 'new',
      \ 'buffer_range': 'tabpage',
      \ 'wrapscan': 1,
      \}
function! s:init() abort " {{{
  for [key, value] in items(s:default_settings)
    execute printf('let g:manpager#%s = %s', key, string(value))
  endfor
endfunction " }}}
call s:init()

let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
