vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.shortmess:append 'I'
vim.g.have_nerd_font = true
vim.cmd.colorscheme 'retrobox'
vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#282828' })
vim.g.mkdp_browser = 'firefox'

local function command_exists(cmd)
  local handle = io.popen('where ' .. cmd .. ' 2>nul')
  local result = handle:read '*a'
  handle:close()
  return result ~= ''
end

if vim.loop.os_uname().sysname == 'Windows_NT' then
  if command_exists 'mingw32-make' then
    vim.opt.makeprg = 'mingw32-make'
  elseif command_exists 'make' then
    vim.opt.makeprg = 'make'
  else
    vim.opt.makeprg = 'wsl make'
  end
else
  vim.opt.makeprg = 'make'
end

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.colorcolumn = '80'
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.lazyredraw = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.guicursor = 'a:block-blinkon0'
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.hidden = true
vim.opt.mouse = ''
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.scrolloff = 10
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.o.autochdir = true

if vim.fn.has 'win32' == 1 then
  vim.o.shell = 'pwsh'
  vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
  vim.o.shellredir = '2>&1 | Tee-Object -FilePath %s; exit $LastExitCode'
  vim.o.shellpipe = '2>&1 | Tee-Object -FilePath %s; exit $LastExitCode'
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
  vim.o.shellxescape = ''
end

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
vim.keymap.set('t', 'jk', [[<C-\><C-n>]], { noremap = true, silent = true, desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

local statusline_group = vim.api.nvim_create_augroup('CustomStatusline', { clear = true })
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI' }, {
  group = statusline_group,
  callback = function()
    vim.cmd.redrawstatus()
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove 'c'
    vim.opt.formatoptions:remove 'r'
    vim.opt.formatoptions:remove 'o'
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove 'c'
    vim.opt_local.formatoptions:remove 'r'
    vim.opt_local.formatoptions:remove 'o'
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local is_windows = vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1
local line_ending = is_windows and 'CRLF' or 'LF'

require('lazy').setup({
  {
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
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
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
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
      },
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
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

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
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
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        clangd = {
          capabilities = {
            offsetEncoding = { 'utf-16' },
          },
          cmd = {
            'clangd',
            '--background-index',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
          },
        },
        jedi_language_server = {},
        texlab = {},
        marksman = {},
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'black',
        'isort',
        'prettier',
        'prettierd',
        'bibtex-tidy',
        'clang-format',
        'latexindent',
        'codespell',
        'textlint',
        'vale',
        'markdownlint',
        'markdownlint-cli2',
        'markdown-toc',
        'flake8',
        'eslint_d',
        'codespell',
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'

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

      local battery_cache = {
        info = '',
        last_update = 0,
      }

      local function get_battery()
        if not is_laptop() then
          return ''
        end

        local current_time = os.time()
        if current_time - battery_cache.last_update > 360 then
          local battery_info = ''
          local os_name = vim.loop.os_uname().sysname:lower()

          if os_name == 'darwin' then
            battery_info = vim.fn.trim(vim.fn.system 'pmset -g batt | grep -Eo "\\d+%"')
          elseif os_name == 'linux' then
            if vim.fn.has 'wsl' == 1 then
              battery_info = vim.fn.system('powershell.exe "Get-WmiObject -Class Win32_Battery | Select-Object EstimatedChargeRemaining"'):match '%d+'
              if battery_info then
                battery_info = battery_info .. '%'
              end
            else
              local acpi = vim.fn.system 'acpi -b 2>/dev/null'
              battery_info = acpi:match '(%d+)%%'
              if not battery_info then
                local bat_file = '/sys/class/power_supply/BAT0/capacity'
                if vim.fn.filereadable(bat_file) == 1 then
                  battery_info = vim.fn.readfile(bat_file)[1] .. '%'
                end
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

      local icons = {
        battery_full = '󰁹',
        battery_three_quarters = '󰂂',
        battery_half = '󰁾',
        battery_quarter = '󰁻',
        battery_empty = '󰂎',
        clock = '󰥔',
      }

      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
            local git = statusline.section_git { trunc_width = 75 }
            local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
            local filename = statusline.section_filename { trunc_width = 140 }
            local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
            local location = statusline.section_location {
              trunc_width = 100, -- optional, adjust width if needed
              func = function()
                return '%2l:%-2v'
              end,
            }
            local search = statusline.section_searchcount { trunc_width = 75 }

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
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'vhdl' },
      auto_install = true,
      highlight = {
        enable = true,
        disable = { 'latex' },
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
      vim.filetype.add {
        extension = {
          dwv = 'vhdl',
          dwa = 'vhdl',
          tsv = 'vhdl',
        },
      }
    end,
  },

  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',

  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font
        and {
          -- Basic Operations
          cmd = '', -- Command (⌘)
          config = '', -- Configuration (🛠)
          event = '', -- Event (📅)
          ft = '', -- File type (📂)
          init = '', -- Initialization (⚙)
          keys = '', -- Keys (🗝)
          plugin = '', -- Plugin (🔌)
          runtime = '', -- Runtime (💻)
          require = '', -- Require (🌙)
          source = '', -- Source (📄)
          start = '', -- Start (🚀)
          task = '', -- Task (📌)
          lazy = '鈴', -- Lazy (💤)
          -- File/Folder States
          open_folder = '', -- Open folder (📂)
          closed_folder = '', -- Closed folder (📁)
          file = '', -- File (📄)
          modified = '', -- Modified (✏️)
          readonly = '', -- Read-only (🔒)
          new_file = '', -- New file (🆕)
          deleted = '', -- Deleted (🗑)
          -- Git/GitHub
          git_add = '', -- Git Add (➕)
          git_remove = '', -- Git Remove (➖)
          git_commit = 'ﰖ', -- Git Commit (🔖)
          git_merge = '', -- Git Merge (🔀)
          git_branch = '', -- Git Branch (🌿)
          git_pull = '', -- Git Pull (⬇️)
          git_push = '', -- Git Push (⬆️)
          -- Diagnostics and Debugging
          error = '', -- Error (❌)
          warning = '', -- Warning (⚠️)
          info = '', -- Info (ℹ️)
          hint = '', -- Hint (💡)
          bug = '', -- Bug (🐛)
          breakpoint = '', -- Breakpoint (🔴)
          debug = '', -- Debug (🐞)
          -- UI Elements
          arrow_right = '', -- Arrow Right (➡️)
          arrow_left = '', -- Arrow Left (⬅️)
          collapse = '', -- Collapse (⏷)
          expand = '', -- Expand (⏵)
          tab = '', -- Tab (↹)
          lock = '', -- Lock (🔒)
          unlock = '', -- Unlock (🔓)
          pin = '車', -- Pin (📌)
          check = '', -- Check (✔️)
          close = '', -- Close (❎)
        }
      or {
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
        lazy = '💤',
        open_folder = '📂',
        closed_folder = '📁',
        file = '📄',
        modified = '✏️',
        readonly = '🔒',
        new_file = '🆕',
        deleted = '🗑',
        git_add = '➕',
        git_remove = '➖',
        git_commit = '🔖',
        git_merge = '🔀',
        git_branch = '🌿',
        git_pull = '⬇️',
        git_push = '⬆️',
        error = '❌',
        warning = '⚠️',
        info = 'ℹ️',
        hint = '💡',
        bug = '🐛',
        breakpoint = '🔴',
        debug = '🐞',
        arrow_right = '➡️',
        arrow_left = '⬅️',
        collapse = '⏷',
        expand = '⏵',
        tab = '↹',
        lock = '🔒',
        unlock = '🔓',
        pin = '📌',
        check = '✔️',
        close = '❎',
      },
  },
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
