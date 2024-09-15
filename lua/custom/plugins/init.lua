-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { 'ThePrimeagen/vim-be-good' },
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require('window-picker').setup()
    end,
  },
  { 'xigoi/vim-arturo', lazy = true },
  { 'github/copilot.vim', lazy = false },
  {
    'lervag/vimtex',
    lazy = false,
    config = function()
      -- Set Zathura as the PDF viewer
      vim.opt.conceallevel = 1

      -- Any other VimTeX configurations you need
    end,
  },
}
