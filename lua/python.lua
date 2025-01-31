vim.g.doge_python_settings = { single_quotes = 0, omit_redundant_param_types = 0 }
vim.g.doge_doc_standard_python = "numpy"

local function run_python(background)
  vim.cmd.write()
  print("Running...")
  local script_path = vim.fn.expand("%:p"):gsub(" ", "\\ ")
  local command = "python \"" .. script_path .. "\""
  if background then
    vim.fn.jobstart(command, {
      on_exit = function() print("Done executing Python.") end,
      on_stderr = function(chan_id, data, name)
        local error_len = 0
        for _, value in ipairs(data) do
          if value ~= nil then
            error_len = error_len + string.len(value)
          end
        end
        if error_len == 0 then
          return
        else
          float_error_message("Python error", data)
        end
      end,
      stderr_buffered = true

    })
  else
    -- toggleterm.exec("clear")
    -- toggleterm.exec(command)
  end
end

local function python_add_type_ignore_statement()
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local line_errors = vim.diagnostic.get(0, { lnum = line_number - 1, severity = vim.diagnostic.severity.ERROR })
  local unique_error_codes = {}
  for _, error in ipairs(line_errors) do
    if error.source == "mypy" then
      unique_error_codes[error.code] = true
    end
  end
  -- Surely there's a better way of accomplishing this?
  local error_count = 0
  local error_codes_table = {}
  for key, _ in pairs(unique_error_codes) do
    table.insert(error_codes_table, key)
    error_count = error_count + 1
  end

  if error_count > 0 then
    local line_text = vim.api.nvim_get_current_line()
    line_text = line_text .. "  # type: ignore[" .. table.concat(error_codes_table, ", ") .. "]"
    vim.api.nvim_set_current_line(line_text)
  end
end


vim.keymap.set("n", "<leader>rp", run_python, { desc = "[R]un [P]ython" })
vim.keymap.set("n", "<leader>brp", function() run_python(true) end, { desc = "[B]ackground [R]un [P]ython" })
vim.keymap.set("n", "<leader>pti", python_add_type_ignore_statement, { desc = "[P]ython [T]ype [I]gnore" })
vim.keymap.set("n", "<leader>dg", function() vim.cmd("DogeGenerate") end, { desc = "[D]ocumentation [G]enerate" })
