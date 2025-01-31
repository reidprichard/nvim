local function new_session(directory_name)
  -- Code ripped from Shatur/neovim-session-manager :)

  -- Scedule buffers cleanup to avoid callback issues and source the session.
  vim.schedule(function()
    -- Delete all buffers first except the current one to avoid entering buffers scheduled for deletion.
    local current_buffer = vim.api.nvim_get_current_buf()
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buffer) and buffer ~= current_buffer then
        vim.api.nvim_buf_delete(buffer, { force = true })
      end
    end
    vim.api.nvim_buf_delete(current_buffer, { force = true })

    local swapfile = vim.o.swapfile
    vim.o.swapfile = false
    vim.api.nvim_set_current_dir(directory_name)
    vim.o.swapfile = swapfile
    vim.cmd.Explore()
  end)

end

local function new_session_prompt(prompt)
  -- Code ripped from Shatur/neovim-session-manager :)

  -- Ask to save files in current session before closing them.
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buffer, 'modified') then
      local choice = vim.fn.confirm('The files in the current session have changed. Save changes?', '&Yes\n&No\n&Cancel')
      if choice == 3 or choice == 0 then
        return -- Cancel.
      elseif choice == 1 then
        vim.api.nvim_command('silent wall')
      end
      break
    end
  end

  vim.ui.input({ prompt = prompt or "Enter the working directory.", relative="editor" },
    function(input)
      if input == nil then
        return
      elseif vim.fn.isdirectory(input) then
        new_session(input)
      else
        new_session_prompt("Enter a valid directory.")
      end
    end
  )
end

vim.keymap.set("n", "<leader>sn", new_session_prompt, { desc = "[S]ession: [N]ew" } )
