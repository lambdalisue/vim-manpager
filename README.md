vim-manpager
===============================================================================
![Version 0.1.0](https://img.shields.io/badge/version-0.1.0-yellow.svg?style=flat-square)
![Support Vim 7.4 or above](https://img.shields.io/badge/support-Vim%207.4%20or%20above-yellowgreen.svg?style=flat-square)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20vim--manpager-orange.svg?style=flat-square)](doc/vim-manpager.txt)

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

- `K`		Open the manual page for the word under the cursor
- `Enter`	Open the manual page for the word under the cursor
- `Ctrl-]`	Open the manual page for the word under the cursor
- `2-LeftMouse`	Open the manual page for the word under the cursor
- `Tab`		Open next manual page in the history
- `Shift-Tab`	Open previous manual page in the history
- `]t`		Find next keyword and move the cursor onto
- `[t`		Find previous keyword and move the cursor onto
- `q`		Close the manual page
