local function git_commit()
  require("dressing.config").update({ input = { relative = "editor" } })
  vim.ui.input(
    { prompt = "Enter commit message." },
    function(input)
      if input == nil then
        return
      end
      if Platform == "Windows_NT" then
        input = "'" .. input:gsub("'", "''") .. "'"
      else
        input = '"' .. input:gsub('"', '\\"') .. '"'
      end
      local current_file = vim.fn.expand("%")
      vim.fn.jobstart("git commit " .. current_file .." -m " .. input,
        {
          on_exit = function() print("Commit successful.") end,
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
              float_error_message("Git Commit Error", data)
            end
          end,
          stderr_buffered = true
        })
    end
  )
  require("dressing.config").update({ input = { relative = "cursor" } })
end

local function git_undo()
	local choice = vim.fn.confirm('Reset the last commit?', '&Yes\n&No')
	if choice == 1 then
	  toggleterm.exec("git reset --soft HEAD~1")
	else
	  print("Reset cancelled.")
	  return
	end
end

vim.keymap.set("n", "<leader>ga", function() vim.cmd("!git add %") end, { desc = "[G]it [A]dd: add the current file" })
vim.keymap.set("n", "<leader>gc", git_commit, { desc = "[G]it [C]ommit" })
vim.keymap.set("n", "<leader>gp", function() toggleterm.exec("git push origin main") end,
  { desc = "[G]it [P]ush origin main" })
vim.keymap.set("n", "<leader>gu", git_undo)
vim.keymap.set("n", "<leader>gu", function() toggleterm.exec("git reset --soft HEAD~1") end,
  { desc = "[G]it [U]ndo: undo last commit" })


