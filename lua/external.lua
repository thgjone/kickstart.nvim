function _G.VimDML(choise)
  local dmlfile = '$HOME/.config/nvim/vim.dml'

  -- 1. Temporarily set the variable in the current process
  vim.env.FT = vim.fn.expand '&filetype'

  -- 2. Call systemlist (it automatically inherits all existing env vars)
  -- local lines = vim.fn.systemlist('_dml_composer --browse-prg fmenu -r --history 10 -i "' .. dmlfile .. '"')
  local lines = vim.fn.systemlist('_dml_composer "' .. dmlfile .. '"')

  -- print(lines.result)
  -- return;

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local custom_picker = function(opts)
    opts = opts or {}
    pickers
      .new(opts, {
        prompt_title = 'My Custom Picker',
        finder = finders.new_table {
          results = lines,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            local lines = vim.fn.systemlist('_dml_composer "' .. dmlfile .. '" "' .. selection.value .. '" | tee log.txt')

            for _, line in ipairs(lines) do
              vim.cmd(line)
            end
          end)
          return true
        end,
      })
      :find()
  end

  custom_picker()

  -- -- 3. Use the result
  -- for _, line in ipairs(lines) do
  -- 		vim.cmd(line)

  --     -- print("Output: " .. line)
  -- end
end
