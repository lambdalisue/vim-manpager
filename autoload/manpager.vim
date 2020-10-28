let s:save_cpo = &cpo
set cpo&vim

let s:Process = vital#manpager#import('Process')
let s:BufferManager = vital#manpager#import('Vim.BufferManager')
let s:buffer_manager = s:BufferManager.new()
let s:is_windows = has('win16') || has('win32') || has('win64')

function! s:args(section, page) abort
  if empty(a:section)
    return [a:page]
  else
    return [a:section, a:page]
  endif
endfunction

function! s:remove_backspaces() abort
  let saved_modifiable = &l:modifiable
  let saved_modified = &l:modified
  let saved_pos = getpos('.')
  setlocal modifiable
  silent keepjumps execute '%s/.//ge'
  let &l:modifiable = saved_modifiable
  let &l:modified = saved_modified
  call setpos('.', saved_pos)
endfunction

function! s:remove_ansi_sequences() abort
  let saved_modifiable = &l:modifiable
  let saved_modified = &l:modified
  let saved_pos = getpos('.')
  setlocal modifiable
  silent keepjumps execute '%s/\v\e\[%(%(\d;)?\d{1,2})?[mK]//ge'
  let &l:modifiable = saved_modifiable
  let &l:modified = saved_modified
  call setpos('.', saved_pos)
endfunction

function! s:find_keyword(flag, ...) abort
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
    keepjump execute a:flag =~# '^b' ? 'normal! GG' : 'normal! gg'
    while search(pattern, a:flag, saved_pos[1]) > 0
      let name = synIDattr(synID(line('.'), col('.'), 0), 'name')
      if name ==# 'manReference'
        return
      endif
    endwhile
  endif
  " no available jump is found
  call setpos('.', saved_pos)
endfunction

function! manpager#load(section, page) abort
  let args = extend(
        \ split(g:manpager#man_executable, '\v\s+'),
        \ s:args(a:section, a:page),
        \)
  let stdout = s:Process.system(args)
  let status = s:Process.get_last_status()
  return {
        \ 'args': args,
        \ 'stdout': stdout,
        \ 'status': status,
        \}
endfunction

function! manpager#open(section, page) abort
  let page = substitute(a:page, '\s\+', '-', 'g')
  let name = empty(a:section) ? page : printf('%s(%s)', page, a:section)
  let result = manpager#load(a:section, page)
  if result.status
    if g:manpager#debug
      echo join(result.args, ' ')
    endif
    echohl Error
    echo printf('man page for "%s" could not be loaded.', name)
    echohl None
    echo result.stdout
    return result.status
  endif
  let contents = split(result.stdout, '\v\r?\n')

  let bufname = join(['MAN', name], s:is_windows ? '_' : ':')
  call s:buffer_manager.open(bufname, {
        \ 'opener': g:manpager#buffer_opener,
        \ 'range': g:manpager#buffer_range,
        \})
  setlocal buftype=nofile noswapfile nobuflisted
  setlocal modifiable
  normal! 1GdG
  call setline(1, contents)
  call s:remove_backspaces()
  call s:remove_ansi_sequences()
  " To fix "Error detected while processing function man#init_pager: in neovim
  let b:man_sect = ''
  silent! setfiletype man
  setlocal nomodifiable
  setlocal nomodified
  call manpager#history#add()
endfunction

function! manpager#find_next_keyword() abort
  call s:find_keyword('W')
endfunction

function! manpager#find_previous_keyword() abort
  call s:find_keyword('bW')
endfunction

function! manpager#manpagerlize() abort
  setlocal buftype=nofile noswapfile nobuflisted
  setlocal modifiable
  call s:remove_backspaces()
  call s:remove_ansi_sequences()
  silent! setfiletype man
  setlocal nomodifiable
  setlocal nomodified
  call s:buffer_manager.add(bufnr('%'))
  call manpager#history#add()
endfunction

function! manpager#get_visual_selection() abort
  " From https://github.com/xolox/vim-notes/blob/d30601243d989c8df11956f0637106d7f255a051/autoload/xolox/notes.vim#L249
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, ' ')
endfunction


let s:default_settings = {
      \ 'debug': 0,
      \ 'man_executable': has('mac') ? 'man -P cat' : 'man --pager=',
      \ 'man_sect_arg': '',
      \ 'man_find_arg': '-w',
      \ 'buffer_opener': 'new',
      \ 'buffer_range': 'tabpage',
      \ 'wrapscan': 1,
      \}
function! s:init() abort
  for [key, value] in items(s:default_settings)
    if !exists(printf('g:manpager#%s', key))
      execute printf('let g:manpager#%s = %s', key, string(value))
    endif
  endfor
endfunction
call s:init()

let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
