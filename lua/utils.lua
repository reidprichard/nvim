local Utils = {}

function Utils.get_visual_selection()
  local pos_1 = vim.fn.getpos(".")
  local pos_2 = vim.fn.getpos("v")
  local s_start
  local s_end

  if pos_1[2] > pos_2[2] or (pos_1[2] == pos_2[2] and pos_1[3] > pos_2[3]) then
    -- This means pos_1 comes after pos_2
    s_start = pos_2
    s_end = pos_1
  else
    s_start = pos_1
    s_end = pos_2
  end
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return lines
end

function Utils.yank_without_breaks()
  local pos_1 = vim.fn.getpos(".")
  local pos_2 = vim.fn.getpos("v")
  local s_start
  local s_end

  if pos_1[2] > pos_2[2] or (pos_1[2] == pos_2[2] and pos_1[3] > pos_2[3]) then
    -- This means pos_1 comes after pos_2
    s_start = pos_2
    s_end = pos_1
  else
    s_start = pos_1
    s_end = pos_2
  end
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  vim.fn.setreg("+", table.concat(lines, ''))
end

function Utils.float_error_message(title, error_text)
  -- local width = vim.api.nvim_win_get_width(0)
  -- local height = vim.api.nvim_win_get_height(0)
  -- local chars = 0
  -- for str in error_text do chars = chars + str.len() end
  -- if chars == 0 then return end
  local width = vim.o.columns
  local height = vim.o.lines
  local opts = {
    relative = 'editor',
    width = width * 0.5,
    col = width * 0.25,
    height = math.floor(height * 0.25),
    row = height * 0.5,
    style = "minimal",
    border = "single",
    title = title,
    title_pos = "center",
  }
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 1, 1, false, error_text)
  -- vim.lsp.util.open_floating_preview(error_text, "", opts)
  vim.api.nvim_open_win(buf, true, opts)
end

-- function ToggleBackgroundColor()
--   local setting_1 = 2632756
--   local setting_2 = 2632756
--   if vim.api.nvim_get_hl(0, {name="bg"}) == setting_1 then
--     vim.api.nvim_set_hl(0, "Normal", {bg=setting_2})
--   else
--     vim.api.nvim_set_hl(0, "Normal", {bg=setting_1})
--   end
-- end


function Utils.telescope_live_grep()
  if vim.fn.executable("rg") then
    require("telescope.builtin").live_grep({ grep_open_files = true })
  else
    print("Error: ripgrep must be installed.")
  end
end

return Utils
