return {
  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' }, -- Load the plugin only for markdown files
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_preview_options = {
        mkit = {}, -- markdown-it options
        katex = {}, -- KaTeX support for math rendering
        uml = {}, -- Mermaid support for UML diagrams
        maid = {}, -- Mermaid support
        disable_sync_scroll = 0, -- Enable sync scroll
        sync_scroll_type = 'middle', -- Sync scroll to the middle
        hide_yaml_meta = 1, -- Hide YAML metadata in preview
      }
    end,
    keys = {
      {
        '<leader>cp',
        '<cmd>MarkdownPreviewToggle<cr>',
        desc = 'Markdown Preview',
        mode = 'n',
      },
    },
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
  { 'github/copilot.vim', event = 'InsertEnter' },
  {
    'lervag/vimtex',
    lazy = false,
    ft = { 'tex', 'bib', 'latex' },
    config = function()
      vim.opt.conceallevel = 1
    end,
  },
}
