# Setup

From the repo root, run:

```bash
./install.sh --vim
```

Or run the Vim-only installer directly:

```bash
./vim/install.sh
```

This writes `~/.vimrc` as a shim that sources the shared Vim config and
`vim/VimSpecific.vim`.
