return {
  {
    "preservim/nerdtree",
    lazy = false,
    cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" },
    init = function()
      vim.g.NERDTreeHijackNetrw = 1
    end,
    config = function()
      vim.g.NERDTreeShowHidden = 1
    end
  },
}