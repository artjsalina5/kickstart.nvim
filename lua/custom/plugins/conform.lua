return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = false }
        end,
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        local disable_filetypes = {}
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
        tex = { 'latexindent' },
        bib = { 'bibtex-tidy' },
        ['*'] = { 'codespell' },
        c = {
          'clang_format',
        },
      },
      formatters = {
        clang_format = {
          prepend_args = function(self, ctx)
            local config_path = vim.fn.fnamemodify(vim.env.MYVIMRC, ':h') .. '/.clang-format'
            if vim.fn.filereadable(config_path) == 1 then
              print('Using .clang-format file: ' .. config_path)
              return {
                '--style=file:' .. config_path,
                '--fallback-style=none',
                '--assume-filename=' .. ctx.filename,
              }
            else
              print('No .clang-format file found at: ' .. config_path)
              return {}
            end
          end,
        },
        markdown_toc = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find '<!%-%- toc %-%->' then
                return true
              end
            end
          end,
        },
        markdownlint_cli2 = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == 'markdownlint'
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
        isort = {
          extra_args = function()
            -- Handle line endings based on platform or specific condition
            return { '--line-ending', vim.bo.fileformat == 'dos' and 'CRLF' or 'LF' }
          end,
        },
      },
    },
  },
}
