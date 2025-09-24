return {
  {
    "preservim/nerdtree",
    cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" },
    config = function()
      vim.g.NERDTreeShowHidden = 1
    end
  },
}