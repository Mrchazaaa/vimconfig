-- Add the current directory to the Lua path
local config_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ':p:h')
package.path = config_path .. '/lua/?.lua;' .. config_path .. '/lua/?/init.lua;' .. package.path

-- Bootstrap lazy.nvim (this must happen before requiring lazy)
require('lazy-bootstrap')

-- Setup lazy.nvim with plugins (now lazy.nvim is available)
require('lazy').setup(require('lazy-plugins'), {
  change_detection = { notify = false }
})

-- UI components (theme customizations after lazy loads)
require('ui').setup()

