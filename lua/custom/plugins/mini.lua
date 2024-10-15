return {
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
}
