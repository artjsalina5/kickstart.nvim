return {
  {
    'lervag/vimtex',
    lazy = false,
    ft = { 'tex', 'bib', 'latex' },
    config = function()
      -- General Vim settings
      vim.opt.conceallevel = 2

      -- vimtex-specific settings
      vim.g.vimtex_view_method = 'general'
      vim.g.vimtex_view_general_viewer = vim.fn.expand '~/.local/bin/sumatrapdf.sh'
      vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
      vim.g.vimtex_format_enabled = 1
      vim.g.vimtex_compiler_latexmk = {
        options = {
          '-pdf',
          '-shell-escape',
          '-interaction=nonstopmode',
          '-synctex=1',
        },
      }
    end,
  },
}
