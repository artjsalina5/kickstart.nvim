return {
  {
    'lervag/vimtex',
    lazy = false,
    ft = { 'tex', 'bib', 'latex' },
    config = function()
      vim.opt.conceallevel = 1
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
