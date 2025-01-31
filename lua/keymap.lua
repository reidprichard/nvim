-- vim.api.nvim_create_autocmd({"FocusGained", "FocusLost"}, { callback = ToggleBackgroundColor } )

-- ************** Key mappings ************
-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set("n", "<leader>cb", function()
  vim.cmd.write()
  vim.cmd("!cmake --build \"%:p:h\"")
end, { desc = "[C]make [B]uild" })

vim.keymap.set("n", "<leader>cp", function() vim.cmd("let @* = expand('%:p:h')") end, { desc = "[C]opy [P]ath" })

-- Use <leader>[direction] to swap between panes
local keys = { "h", "j", "k", "l" }
for _, key in pairs(keys) do
  vim.keymap.set("n", "<C-" .. key .. ">", "<C-w>" .. key)
  vim.keymap.set("t", "<C-" .. key .. ">", "<C-\\><C-n><C-w>" .. key)
end

-- Go to next diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
vim.keymap.set(
  'n', '<Leader>n', vim.diagnostic.goto_next,
  { noremap = true, silent = true, desc = "[N]ext Diagnostic" }
)

-- Go to prev diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
vim.keymap.set(
  'n', '<Leader>p', vim.diagnostic.goto_prev,
  { noremap = true, silent = true, desc = "[P]revious Diagnostic" }
)

-- Search auto-session sessions
--vim.keymap.set("n", "<leader>ss", function() vim.cmd("SessionManager save_current_session") end,
--  { desc = "[S]ession: [S]ave" })
--vim.keymap.set("n", "<leader>sl", function() vim.cmd("SessionManager load_session") end, { desc = "[S]ession [L]oad" })
--vim.keymap.set("n", "<leader>sd", function() vim.cmd("SessionManager delete_session") end,
--  { desc = "[S]ession: [D]elete" })

vim.keymap.set({ "n", "v" }, "<leader>lf", function() vim.lsp.buf.format { timeout_ms = 2500 } end,
  { desc = "[L]SP [F]ormat" })

-- vim.keymap.set('n', '<leader>h', function() vim.diagnostic.open_float() end, { desc = "Show [H]over" })

-- ** LuaSnip **
-- local ls = require("luasnip")
-- vim.keymap.set({ "n", "i" }, "<C-S>", function() ls.expand() end, { desc = "Insert [S]nippet" })
-- vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
-- vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

-- ** Copy to system clipboard **
vim.keymap.set("v", "<leader>yc", '"+y', { desc = "[Y]ank to [C]lipboard" })
vim.keymap.set("n", "<leader>yc", '"+yy', { desc = "[Y]ank to [C]lipboard" })
vim.keymap.set("v", "<leader>yC", require("utils").yank_without_breaks, { desc = "[Y]ank to [C]lipboard (remove newlines)" })

-- ** NoNeckPain binds **
-- vim.keymap.set("n", "<leader>tc", function() vim.cmd(":NoNeckPain") end, { desc = "[T]oggle [C]enter" })
-- vim.keymap.set("n", "<leader>cu", function() vim.cmd(":NoNeckPainWidthUp") end, { desc = "[C]enter width [U]p" })
-- vim.keymap.set("n", "<leader>cd", function() vim.cmd(":NoNeckPainWidthDown") end, { desc = "[C]enter width [D]own" })

-- ** Search all buffers' contents **
vim.keymap.set("n", "<leader>sb", require("utils").telescope_live_grep, { desc = "[S]earch open [B]uffers contents" })

-- ** Move selected lines up/down **
vim.keymap.set("n", "<M-j>", function() vim.cmd(":m+1") end, { desc = "Move selected line down one line" })
vim.keymap.set("n", "<M-k>", function() vim.cmd(":m-2") end, { desc = "Move selected line up one line" })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down one line" })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up one line" })

-- The below must be done twice - <C-_> is for in a terminal, while <C-/> is for in a GUI. Both map to Ctrl-/
vim.keymap.set({ "n", "i", "t" }, "<C-_>", function() vim.cmd(":noh") end, { desc = "Disable search highlighting" })
vim.keymap.set({ "n", "i", "t" }, "<C-/>", function() vim.cmd(":noh") end, { desc = "Disable search highlighting" })

-- vim.keymap.set("n", "<leader>tb", function() vim.cmd(":ToggleAlternate") end,
--   { desc = "[T]oggle [B]oolean (rmagatti/alternate-toggler)" })

vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)

-- vim.keymap.set({ "i", "n", "t" }, "<C-j>",
--   function() vim.cmd("ToggleTerm size=" .. vim.api.nvim_win_get_height(0) * 0.5) end)
-- " optional: change highlight, otherwise Pmenu is used
-- call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')

vim.keymap.set({ "n", "i" }, "<A-H>", function() vim.cmd("tabnext") end, { desc = "Go to next tab" })
vim.keymap.set({ "n", "i" }, "<A-L>", function() vim.cmd("tabprevious") end, { desc = "Go to previous tab" })
vim.keymap.set({ "n" }, "<C-S-W>", function() vim.cmd("tabclose") end, { desc = "Close current tab" })
