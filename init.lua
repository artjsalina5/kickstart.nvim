--[[
Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

 Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.shortmess:append 'I'
vim.g.have_nerd_font = true
vim.cmd.colorscheme 'retrobox'
-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#000000', reverse = true })

-- Utility function to check if a command exists
local function command_exists(cmd)
  local handle = io.popen('where ' .. cmd .. ' 2>nul')
  local result = handle:read '*a'
  handle:close()
  return result ~= ''
end

-- Set makeprg based on available environment
if vim.loop.os_uname().sysname == 'Windows_NT' then
  if command_exists 'mingw32-make' then
    -- Use MinGW make if available
    vim.opt.makeprg = 'mingw32-make'
  elseif command_exists 'make' then
    -- Use standard make if available
    vim.opt.makeprg = 'make'
  else
    -- Default to wsl make if no MinGW make is found
    vim.opt.makeprg = 'wsl make'
  end
else
  -- On Linux or other OS, just use make
  vim.opt.makeprg = 'make'
end

-- Set the color column at the 80th character
vim.opt.colorcolumn = '80'

-- Enable relative line numbers
vim.opt.relativenumber = true

-- Enable auto-indent
vim.opt.autoindent = true

-- Enable smart indentation
vim.opt.smartindent = true

-- Redraw screen lazily (improves performance)
vim.opt.lazyredraw = true

-- Ignore case in search patterns
vim.opt.ignorecase = true

vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.laststatus = 2
vim.opt.expandtab = true

-- Enable smart tabs
vim.opt.smarttab = true
-- Set tab width
vim.opt.tabstop = 2
-- Set shift width for auto-indent
vim.opt.shiftwidth = 2
-- Set soft tab width (insert/delete the appropriate number of spaces)
vim.opt.softtabstop = 2
-- Set the cursor style (block cursor without blinking)
vim.opt.guicursor = 'a:block-blinkon0'
-- Show the cursor position in the status line
vim.opt.ruler = true

-- Highlight the line with the cursor
vim.opt.cursorline = true

-- Highlight the column with the cursor
vim.opt.cursorcolumn = true

-- Allow switching between buffers without saving
vim.opt.hidden = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = ''
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true
-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.o.autochdir = true

if vim.fn.has 'win32' == 1 then
  -- Set the shell to PowerShell
  vim.o.shell = 'pwsh'
  -- PowerShell command flags
  vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
  -- Redirect and pipe output to handle it as UTF-8 properly
  vim.o.shellredir = '2>&1 | Tee-Object -FilePath %s; exit $LastExitCode'
  vim.o.shellpipe = '2>&1 | Tee-Object -FilePath %s; exit $LastExitCode'
  -- No additional quoting needed in PowerShell
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
  -- Additional safety settings for handling paths and arguments
  vim.o.shellxescape = ''
end
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

local function open_terminal(split_cmd, resize_cmd)
  local cwd = vim.fn.expand '%:p:h'
  vim.cmd(split_cmd)
  vim.cmd 'terminal'
  if resize_cmd then
    vim.cmd(resize_cmd)
  end
  vim.cmd('lcd ' .. cwd)
end

vim.keymap.set('n', '<leader>h', function()
  open_terminal('botright split', 'resize 10')
end, { noremap = true, silent = true, desc = 'Open horizontal terminal in current file directory' })

vim.keymap.set('n', '<leader>v', function()
  open_terminal('vsplit', nil)
  vim.cmd 'wincmd ='
end, { noremap = true, silent = true, desc = 'Open vertical terminal in current file directory' })
-- Exit terminal mode
vim.keymap.set('t', 'jk', [[<C-\><C-n>]], { noremap = true, silent = true, desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
local statusline_group = vim.api.nvim_create_augroup('CustomStatusline', { clear = true })
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI' }, {
  group = statusline_group,
  callback = function()
    vim.cmd.redrawstatus()
  end,
})
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Disable automatic commenting on new lines (global)
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove 'c'
    vim.opt.formatoptions:remove 'r'
    vim.opt.formatoptions:remove 'o'
  end,
})

-- Disable automatic commenting on new lines (local to buffer)
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove 'c'
    vim.opt_local.formatoptions:remove 'r'
    vim.opt_local.formatoptions:remove 'o'
  end,
})

local is_windows = vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1
local line_ending = is_windows and 'CRLF' or 'LF'
-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({

  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  --

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    -- Lazy load on the LspAttach event
    event = { 'LspAttach' },
    config = function()
      -- Set up capabilities with consistent offset encoding
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities.offset_encoding = { 'utf-8' } -- Set all LSPs to use utf-16 encoding

      -- LSP key mappings and configurations
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          -- Key mappings (unchanged as per your request)
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        end,
      })

      -- Language server configurations
      local servers = {
        pyright = {
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            -- Key mappings for Python (e.g., go-to-definition, signature help, and inlay hints)
            local buf_map = function(mode, lhs, rhs, desc)
              vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
            end

            -- Show hover documentation
            buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'Show Hover Documentation')

            -- Trigger signature help
            buf_map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Help')

            -- Format on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              pattern = '*.py',
              callback = function()
                vim.lsp.buf.format()
              end,
            })

            -- Enable virtual text for diagnostics
            vim.diagnostic.config {
              virtual_text = true,
              signs = true,
              update_in_insert = false,
            }
          end,
        },

        ts_ls = {
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            local buf_map = function(mode, lhs, rhs, desc)
              vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
            end

            -- Show hover documentation
            buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'Show Hover Documentation')

            -- Trigger signature help
            buf_map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Help')

            -- Show function definitions and references
            buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', 'Go to Definition')
            buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', 'Find References')

            -- Organize imports for TypeScript
            buf_map('n', '<leader>oi', '<cmd>lua vim.lsp.buf.execute_command({ command = "_typescript.organizeImports" })<CR>', 'Organize Imports')
          end,
        },

        clangd = {
          capabilities = capabilities,
          cmd = { 'clangd', '--offset-encoding=utf-16' }, -- Ensure clangd uses utf-16
          on_attach = function(client, bufnr)
            local buf_map = function(mode, lhs, rhs, desc)
              vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
            end

            -- Show hover documentation
            buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'Show Hover Documentation')

            -- Trigger signature help
            buf_map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Help')

            -- Show diagnostics
            buf_map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', 'Show Line Diagnostics')
            buf_map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'Go to Previous Diagnostic')
            buf_map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', 'Go to Next Diagnostic')

            -- Enable Clang-tidy and Clang-format
            vim.cmd [[ autocmd BufWritePre *.cpp,*.c,*.h lua vim.lsp.buf.format() ]]
          end,
        },

        lua_ls = {
          capabilities = capabilities,
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = {
                globals = { 'vim' }, -- Recognize Neovim's `vim` global variable
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true), -- Include Neovim runtime
                checkThirdParty = false, -- Avoid unnecessary third-party library checks
              },
              telemetry = {
                enable = false, -- Disable telemetry
              },
            },
          },
          on_attach = function(client, bufnr)
            local buf_map = function(mode, lhs, rhs, desc)
              vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
            end

            -- Show hover documentation
            buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'Show Hover Documentation')

            -- Format on save for Lua files
            vim.api.nvim_create_autocmd('BufWritePre', {
              pattern = '*.lua',
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end,
        },
        marksman = {
          capabilities = capabilities,
          cmd = { 'marksman' }, -- Marksman for Markdown
          filetypes = { 'markdown' },
          on_attach = function(client, bufnr)
            local buf_map = function(mode, lhs, rhs, desc)
              vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
            end

            buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'Show Hover Documentation')
            vim.api.nvim_create_autocmd('BufWritePre', {
              pattern = '*.md',
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end,
        },

        texlab = {
          capabilities = capabilities,
          root_dir = function(fname)
            return require('lspconfig.util').root_pattern('.git', '.latexmkrc', '.texlabroot', 'Tectonic.toml')(fname)
              or require('lspconfig.util').path.dirname(fname)
          end,
          settings = {
            texlab = {
              chktex = {
                onOpenAndSave = false,
                onEdit = false,
              },
              diagnosticsDelay = 300,
              latexFormatter = 'latexindent', -- Formatter for LaTeX
              latexindent = {
                ['local'] = nil, -- Reserved keyword workaround
                modifyLineBreaks = false,
              },
              bibtexFormatter = 'texlab', -- BibTeX formatter
              formatterLineLength = 80, -- Enforce 80 character line length
            },
          },
          on_attach = function(client, bufnr)
            -- Enable spell checking for LaTeX files
            vim.api.nvim_buf_set_option(bufnr, 'spell', true)
            vim.api.nvim_buf_set_option(bufnr, 'spelllang', 'en')

            -- Key mappings for LaTeX
            local buf_map = function(mode, lhs, rhs, desc)
              vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
            end

            -- Show hover documentation
            buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'Show Hover Documentation')

            -- Trigger signature help
            buf_map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Show Signature Help')
          end,
        },
      }

      -- Set up all servers with the enhanced configurations
      for server, config in pairs(servers) do
        require('lspconfig')[server].setup(config)
      end
      -- Ensure LSP servers are installed
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      -- Install other tools using Mason
      require('mason-tool-installer').setup {
        ensure_installed = {
          'stylua',
          'black',
          'isort',
          'prettierd',
          'latexindent',
          'bibtex-tidy',
          'clang-format',
          'markdownlint',
          'luacheck',
          'flake8',
          'eslint_d',
          'codespell',
          'trim_whitespace',
          'trim_newlines',
        },
      }
    end,
  },

  -- Autoformat
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        json = { 'prettierd' },
        html = { 'prettierd' },
        css = { 'prettierd' },
        yaml = { 'prettierd' },
        markdown = { 'prettierd', 'markdownlint' },
        tex = { 'latexindent' },
        bib = { 'bibtex-tidy' },
        ['*'] = { 'codespell', 'trim_whitespace', 'trim_newlines' },
        c = {
          'clang_format',
          extra_args = function()
            local config_path = vim.fn.fnamemodify(vim.fn.expand '$MYVIMRC', ':h') .. '/.clang-format'
            return { '--style=file', '-assume-filename=' .. config_path }
          end,
          lsp_fallback = false, -- Disable LSP fallback for C
        },
        formatters = {
          isort = {
            extra_args = { '--line-ending', line_ending },
          },
        },
      },
    },
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'

      -- Utility functions
      local function is_laptop()
        if vim.g.is_laptop ~= nil then
          return vim.g.is_laptop
        end

        local has_battery = false
        local os_name = vim.loop.os_uname().sysname:lower()

        if os_name == 'darwin' then
          has_battery = vim.fn.system('pmset -g batt'):lower():match 'battery' ~= nil
        elseif os_name == 'linux' then
          has_battery = vim.fn.isdirectory '/sys/class/power_supply' == 1 and #vim.fn.globpath('/sys/class/power_supply', 'BAT*', false, true) > 0
        elseif os_name:match 'windows' then
          has_battery = vim.fn.system('wmic path win32_battery get status'):lower():match 'ok' ~= nil
        end

        vim.g.is_laptop = has_battery
        return has_battery
      end

      -- Cache for battery info
      local battery_cache = {
        info = '',
        last_update = 0,
      }

      local function get_battery()
        if not is_laptop() then
          return ''
        end

        -- Update battery info every 60 seconds
        local current_time = os.time()
        if current_time - battery_cache.last_update > 60 then
          local battery_info = ''
          local os_name = vim.loop.os_uname().sysname:lower()

          if os_name == 'darwin' then
            battery_info = vim.fn.trim(vim.fn.system 'pmset -g batt | grep -Eo "\\d+%"')
          elseif os_name == 'linux' then
            local acpi = vim.fn.system 'acpi -b 2>/dev/null'
            battery_info = acpi:match '(%d+)%%'
            if not battery_info then
              local bat_file = '/sys/class/power_supply/BAT0/capacity'
              if vim.fn.filereadable(bat_file) == 1 then
                battery_info = vim.fn.readfile(bat_file)[1] .. '%'
              end
            end
          elseif os_name:match 'windows' then
            battery_info = vim.fn.system('wmic path win32_battery get estimatedchargeremaining'):match '%d+'
            if battery_info then
              battery_info = battery_info .. '%'
            end
          end

          battery_cache.info = battery_info ~= '' and battery_info or ''
          battery_cache.last_update = current_time
        end

        return battery_cache.info
      end

      local function get_time()
        return os.date '%H:%M'
      end

      -- Icons
      local icons = {
        battery_full = '󰁹',
        battery_three_quarters = '󰂂',
        battery_half = '󰁾',
        battery_quarter = '󰁻',
        battery_empty = '󰂎',
        clock = '󰥔',
      }

      -- Custom statusline setup
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
            local git = statusline.section_git { trunc_width = 75 }
            local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
            local filename = statusline.section_filename { trunc_width = 140 }
            local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
            local location = statusline.section_location()
            local search = statusline.section_searchcount { trunc_width = 75 }

            -- Custom sections
            local battery = (function()
              local bat = get_battery()
              if bat == '' then
                return ''
              end
              local icon = icons.battery_full
              local num = tonumber(bat:match '%d+')
              if num <= 25 then
                icon = icons.battery_empty
              elseif num <= 50 then
                icon = icons.battery_quarter
              elseif num <= 75 then
                icon = icons.battery_half
              elseif num < 100 then
                icon = icons.battery_three_quarters
              end
              return string.format(' %s %s', icon, bat)
            end)()

            local time = string.format(' %s %s', icons.clock, get_time())

            -- Combine all sections
            return table.concat({
              mode,
              ' ',
              git,
              ' ',
              diagnostics,
              ' ',
              '%<', -- Start truncating here if needed
              filename,
              ' ',
              '%=', -- Right align the rest
              fileinfo,
              ' ',
              location,
              ' ',
              battery,
              ' ',
              time,
            }, '')
          end,
          inactive = function()
            return '%F'
          end,
        },
      }

      -- Override default sections as needed
      statusline.section_location = function()
        return '%2l:%-2v'
      end
      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  -- Autocommand to update statusline more frequently

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'vhdl' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        disable = { 'latex' },
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- Associate custom extensions with VHDL filetype
      vim.filetype.add {
        extension = {
          dwv = 'vhdl',
          dwa = 'vhdl',
          tsv = 'vhdl',
        },
      }

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
