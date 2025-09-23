return {
  {
    "itchyny/lightline.vim",
    dependencies = {
      "shinchu/lightline-gruvbox.vim"
    },
    config = function()
      vim.g.lightline = {
        colorscheme = 'gruvbox',
        active = {
          right = {
            {'lineinfo'}, {'percent'},
            {'fileformat', 'fileencoding', 'filetype'}
          }
        },
        inactive = {
          right = {{'lineinfo'}, {'percent'}}
        }
      }
    end
  },
  { "shinchu/lightline-gruvbox.vim" },
}