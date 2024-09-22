return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function()
      require('lazy').load { plugins = { 'markdown-preview.nvim' } }
      vim.fn['mkdp#util#install']()
    end,
    keys = {
      {
        '<leader>cp',
        ft = 'markdown',
        '<cmd>MarkdownPreviewToggle<cr>',
        desc = 'Markdown Preview',
      },
    },
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_browser = 'wslview'
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {}, -- Mermaid support for UML diagrams
        maid = {}, -- Mermaid support
        disable_sync_scroll = 0, -- Enable sync scroll
        sync_scroll_type = 'middle', -- Sync scroll to the middle
        hide_yaml_meta = 1, -- Hide YAML metadata in preview
      }
    end,
  },
  {
    'nvimtools/none-ls.nvim',
    optional = true,
    opts = function(_, opts)
      local nls = require 'null-ls'
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.markdownlint_cli2,
      })
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'norg', 'rmd', 'org' },
      code = {
        sign = false,
        width = 'block',
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
    },
    ft = { 'markdown', 'norg', 'rmd', 'org' }, -- Load the plugin only for specified file types
    config = function(_, opts)
      -- Setting up the plugin with the provided options
      require('render-markdown').setup(opts)

      -- Keybinding to toggle render-markdown functionality
      vim.api.nvim_set_keymap('n', '<leader>um', [[:lua require('render-markdown').toggle()<CR>]], { noremap = true, silent = true })

      -- Optionally, you can add a command as well for manual toggling
      vim.api.nvim_create_user_command('ToggleMarkdownRender', function()
        require('render-markdown').toggle()
      end, { desc = 'Toggle Markdown Render' })
    end,
  },
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require('window-picker').setup()
    end,
  },
  { 'github/copilot.vim', lazy = false },
  {
    'lervag/vimtex',
    lazy = false,
    config = function()
      vim.opt.conceallevel = 1
    end,
  },
}
