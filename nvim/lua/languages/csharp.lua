local M = {}

function M.setup()
    local using_snippets = 0

    -- Sharpenup configuration
    vim.g.sharpenup_map_prefix = '<Space>os'
    vim.g.sharpenup_statusline_opts = { Text = '%s (%p/%P)' }
    vim.g.sharpenup_statusline_opts.Highlight = 0

    local omnisharp_group = vim.api.nvim_create_augroup('OmniSharpIntegrations', { clear = true })
    vim.api.nvim_create_autocmd('User', {
        group = omnisharp_group,
        pattern = {'OmniSharpProjectUpdated', 'OmniSharpReady'},
        command = 'call lightline#update()'
    })

    -- OmniSharp configuration
    vim.g.OmniSharp_popup_position = 'peek'
    if vim.fn.has('nvim') == 1 then
        vim.g.OmniSharp_popup_options = {
            winhl = 'Normal:NormalFloat'
        }
    else
        vim.g.OmniSharp_popup_options = {
            highlight = 'Normal',
            padding = {0, 0, 0, 0},
            border = {1}
        }
    end

    vim.g.OmniSharp_popup_mappings = {
        sigNext = '<C-n>',
        sigPrev = '<C-p>',
        pageDown = {'<C-f>', '<PageDown>'},
        pageUp = {'<C-b>', '<PageUp>'}
    }

    if using_snippets == 1 then
        vim.g.OmniSharp_want_snippet = 1
    end

    vim.g.OmniSharp_highlight_groups = {
        ExcludedCode = 'NonText'
    }
end

return M