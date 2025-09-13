# Setup

1. Clone vimconfig into /home/username/.config/nvim
2. Create an init.vim in /home/username/.config/nvim:

    ```
    source ~/.config/nvim/vimconfig/vim/.vimrc

    lua require("vimconfig.nvim.init")
    ```