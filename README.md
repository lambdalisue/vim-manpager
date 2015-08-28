vim-manpager
===============================================================================
*vim-manpager* is plugin to use Vim as a MANPAGER.
It also improve the behavior of `:Man` command and mappings in `man` file.
See [lambdalisue/vim-pager](https://github.com/lambdalisue/vim-pager) for PAGER.

![Screencast](http://g.recordit.co/nnvpuIKOKK.gif)


Install
-------------------------------------------------------------------------------

```vim
" Vundle.vim
Plugin 'lambdalisue/vim-manpager'

" neobundle.vim
NeoBundle 'lambdalisue/vim-manpager'

" neobundle.vim (Lazy)
NeoBundleLazy 'lambdalisue/vim-manpager', {
        \ 'autoload': {
        \   'commands': 'MANPAGER',
        \}}
```


Usage
-------------------------------------------------------------------------------

To open vim via `man` command, use the following settings in your shell.

```
$ export MANPAGER="vim -c MANPAGER -"
$ man git
```

In Vim, you can use `Man` command to open a man page (the plugin overwrite the
default `Man` command defined in default `ftplugin/man.vim` to improve the
behavior)

```
:Man git
```

In man buffer, you can use the following keymaps

- `K`		Open the manual page for the word uner the cursor
- `Enter`		Open the manual page for the word uner the cursor
- `Ctrl-]`		Open the manual page for the word uner the cursor
- `2-LeftMouse`	Open the manual page for the word uner the cursor
- `Ctrl-n`		Open next manual page in the history
- `Tab`		Open next manual page in the history
- `Ctrl-p`		Open previous manual page in the history
- `Shift-Tab`	Open previous manual page in the history
- `]t`		Find next keyword and move the cursor onto
- `[t`		Find previous keyword and move the cursor onto
- `q`		Close the manual page


License
-------------------------------------------------------------------------------
The MIT License (MIT)

Copyright (c) 2015 Alisue, hashnote.net

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
