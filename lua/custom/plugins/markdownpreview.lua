return {
  {
    'iamcco/markdown-preview.nvim',
    lazy = true,
    ft = { 'markdown' },
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      -- Set the browser path
      vim.g.mkdp_browser = '/mnt/c/Program Files/Mozilla Firefox/firefox.exe'

      -- Define a global Vim function for opening the browser
      vim.cmd [[
        function! MarkdownOpenBrowser(url) abort
          let l:browser = expand(g:mkdp_browser)
          let l:cmd = printf('"%s" "%s"', l:browser, a:url)
          call system(l:cmd)
        endfunction
      ]]

      -- Use the global Vim function for the browser
      vim.g.mkdp_browserfunc = 'MarkdownOpenBrowser'

      -- Markdown preview options
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
