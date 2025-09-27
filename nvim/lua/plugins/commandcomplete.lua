return {
  {
    "gelguy/wilder.nvim",
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ":", "/", "?" } })

      -- Use popupmenu renderer (similar to nvim-cmp)
      wilder.set_option("renderer", wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
      }))
    end,
  },
}
