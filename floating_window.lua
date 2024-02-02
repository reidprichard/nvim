local width = vim.api.nvim_win_get_width(0)
local height = vim.api.nvim_win_get_height(0)
width = vim.o.columns
height = vim.o.lines
local opts = {
  relative = 'editor',
  width = width * 0.5,
  col = width * 0.25,
  height = math.floor(height * 0.25),
  row = height * 0.5,
  style = "minimal",
  border = "single",
  title = "Git Commit Error",
  title_pos = "center",
  -- border = "single",
  -- winblend = 5,
}
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, 1, false, { "Hello", "World", "Test", })
-- local opts = {relative = 'win', width= 40, height= 20, col= 0, row= 1, style= 'minimal'}
local win = vim.api.nvim_open_win(buf, true, opts)
