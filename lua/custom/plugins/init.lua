-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

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
    'madox2/vim-ai',
    config = function()
      -- Set up your OpenAI API key
      vim.g.vim_ai_token_file_path = '~/.config/openai.token'
      -- Optional: Configure the plugin
      vim.g.vim_ai_chat = {
        ['options'] = {
          ['model'] = 'gpt-4o',
          ['temperature'] = 0.2,
        },
      }
    end,
  },
  {
    'lervag/vimtex',
    lazy = false,
    config = function()
      vim.opt.conceallevel = 1
      -- Any other VimTeX configurations you need
    end,
  },
}
