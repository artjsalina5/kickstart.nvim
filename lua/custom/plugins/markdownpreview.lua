return {
  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' }, -- Load the plugin only for markdown files
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
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
}
