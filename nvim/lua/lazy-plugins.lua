local plugins = {}

-- Load all plugin modules
local plugin_modules = {
  "plugins.essentials",
  "plugins.finder",
  "plugins.theme",
  "plugins.statusline",
  "plugins.explorer"
}

for _, module in ipairs(plugin_modules) do
  local ok, module_plugins = pcall(require, module)
  if ok then
    vim.list_extend(plugins, module_plugins)
  else
    vim.notify("Failed to load plugin module: " .. module, vim.log.levels.ERROR)
  end
end

return plugins