# Setup

From the repo root, run:

```bash
./install.sh --nvim
```

Or run the Neovim-only installer directly:

```bash
./nvim/install.sh
```

This writes `~/.config/nvim/init.vim` as a shim that sources the shared Vim
config and loads `nvim/init.lua`.
