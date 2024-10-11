return {
  'github/copilot.vim',
  -- Copilot should be available when starting Neovim
  lazy = false,
  priority = 100, -- Adjust priority as needed
  config = function()
    vim.g.copilot_workspace_folders = { '~/mnt/c/home/Projects' }

    vim.api.nvim_set_hl(0, 'CopilotSuggestion', {
      fg = '#1a1a1a',
      ctermfg = 0,
      force = true,
    })
  end,
}
