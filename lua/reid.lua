if vim.g.neovide then
  -- vim.g.neovide_transparency = 0.99
  vim.g.neovide_scroll_animation_length = 1
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_refresh_rate_idle = 60
  vim.g.neovide_cursor_animation_length = 0
  vim.keymap.set("t", "<MouseMove>", "<NOP>")
end

local lspconfig = require("lspconfig")

-- lspconfig.pylsp.setup {
--   settings = {
--     pylsp = {
--       plugins = {
--         flake8 = {enabled = false},
--         pycodestyle = {enabled = false},
--         mccabe = {enabled = false},
--       }
--     }
--   }
-- }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local function custom_attach(client, bufnr)
  require("lsp_signature").on_attach({
    bind = true,
    use_lspsaga = false,
    floating_window = true,
    fix_pos = true,
    hint_enable = true,
    hi_parameter = "Search",
    handler_opts = { "double" },
  })
end

local ahk2_configs = {
  autostart = true,
  cmd = {
    "node",
    vim.fn.expand("$HOME/vscode-autohotkey2-lsp/server/dist/server.js"),
    "--stdio"
  },
  filetypes = { "ahk", "autohotkey", "ah2" },
  init_options = {
    locale = "en-us",
    AutoLibInclude = "Disabled",
    CommentTags = "^;;\\s*(?<tag>.+)",
    CompleteFunctionParens = false,
    Diagnostics = {
      ClassStaticMemberCheck = true,
      ParamsCheck = true
    },
    DisableV1Script = true,
    FormatOptions = {
      break_chained_methods = false,
      ignore_comment = false,
      indent_string = "\t",
      keep_array_indentation = true,
      max_preserve_newlines = 2,
      one_true_brace = "1",
      preserve_newlines = true,
      space_before_conditional = true,
      space_in_empty_paren = false,
      space_in_other = true,
      space_in_paren = false,
      wrap_line_length = 0
    },
    InterpreterPath = "C:/Program Files/AutoHotkey/v2/AutoHotkey.exe",
    SymbolFoldingFromOpenBrace = false
  },
  single_file_support = true,
  flags = { debounce_text_changes = 500 },
  capabilities = capabilities,
  on_attach = custom_attach,
}
local configs = require "lspconfig.configs"
configs["ahk2"] = { default_config = ahk2_configs }
lspconfig.ahk2.setup({})

require('onedark').setup {
  -- toggle_style_key = '<leader>ts',
  toggle_style_list = { 'dark', 'cool', 'deep', 'warm' }
}
vim.keymap.set("n", "<leader>ts", require("onedark").toggle, { desc = "[T]oggle [S]tyle" } )

require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets/" } })

-- require("lspconfig").pyright.setup {
--   settings = {
--     python = {
--       analysis = {
--         diagnosticMode = "off",
--         typeCheckingMode = "off",
--       }
--     }
--   }
-- }

vim.diagnostic.config({
  virtual_text = false, -- Turn off inline diagnostics
})

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.inde = "" -- Had to do this to prevent weird spacing being added when I typed "else" in a cpp file?
vim.opt.indentexpr = ""
vim.opt.guifont = "CaskaydiaCove Nerd Font:h16"
vim.opt.wrap = false
vim.opt.number = true

-- ************** Key mappings ************

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local function RunPython()
  vim.cmd.write()
  local script_path = vim.fn.expand("%"):gsub(" ", "\\ ")
  vim.cmd("TermExec cmd=\"python " .. script_path .. "\"")
end
vim.keymap.set("n", "<leader>rp", RunPython, { desc = "[R]un [P]ython" })
-- vim.keymap.set("n", "<leader>rp", function() vim.cmd.write() vim.cmd("TermExec cmd=\"python %\"") end, { desc = "[R]un [P]ython" } )
vim.keymap.set("n", "<leader>cb", function()
  vim.cmd.write()
  vim.cmd("!cmake --build \"%:p:h\"")
end, { desc = "[C]make [B]uild" })

vim.keymap.set("n", "<leader>cp", function() vim.cmd("let @* = expand('%:p:h')") end, { desc = "[C]opy [P]ath" })

-- Use <leader>[direction] to swap between panes
local keys = { "h", "j", "k", "l", "H", "J", "K", "L" }
for _, key in pairs(keys) do
  vim.keymap.set("n", "<leader>" .. key, "<C-w>" .. key)
end

-- Use this if you want it to automatically show all diagnostics on the
-- current line in a floating window. Personally, I find this a bit
-- distracting and prefer to manually trigger it (see below). The
-- CursorHold event happens when after `updatetime` milliseconds. The
-- default is 4000 which is much too long
-- vim.cmd('autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()')
-- vim.o.updatetime = 300

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
vim.keymap.set("n", "<leader>ss", function() vim.cmd("SessionManager save_current_session") end,
  { desc = "[S]ession [S]ave" })
vim.keymap.set("n", "<leader>sl", function() vim.cmd("SessionManager load_session") end, { desc = "[S]ession [L]oad" })
vim.keymap.set("n", "<leader>sd", function() vim.cmd("SessionManager delete_session") end,
  { desc = "[S]ession [D]elete" })

vim.keymap.set({ "n", "v" }, "<leader>lf", function() vim.lsp.buf.format { timeout_ms = 2500 } end,
  { desc = "[L]SP [F]ormat" })

-- vim.keymap.set('i', "<c-space>", "coc#refresh", { desc = "autocomplete" } )
-- vim.keymap.set('i', "<NUL>", "coc#refresh", { desc = "autocomplete" } )
-- vim.keymap.set('n', '<leader>h', function() vim.diagnostic.open_float() end, { desc = "Show [H]over" })

-- ** LuaSnip setup **
local ls = require("luasnip")
vim.keymap.set({ "i", "n" }, "<C-I>", function() ls.expand() end, { desc = "[I]nsert Snippet" })
-- vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
-- vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

local function GetVisualSelection()
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

-- ** Copy to system clipboard **
vim.keymap.set("v", "<leader>yc", '"+y', { desc = "[Y]ank to [C]lipboard" })
local function YankWithoutBreaks()
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
vim.keymap.set("v", "<leader>yC", YankWithoutBreaks, { desc = "[Y]ank to [C]lipboard (remove newlines)" })

-- ** NoNeckPain binds **
vim.keymap.set("n", "<leader>tc", function() vim.cmd(":NoNeckPain") end, { desc = "[T]oggle [C]enter" })
vim.keymap.set("n", "<leader>cu", function() vim.cmd(":NoNeckPainWidthUp") end, { desc = "[C]enter width [U]p" })
vim.keymap.set("n", "<leader>cd", function() vim.cmd(":NoNeckPainWidthDown") end, { desc = "[C]enter width [D]own" })

local function TelescopeLiveGrep()
  if vim.fn.executable("rg") then
    require("telescope.builtin").live_grep({ grep_open_files = true })
  else
    print("Error: ripgrep must be installed.")
  end
end

-- ** Search all buffers' contents **
vim.keymap.set("n", "<leader>sb", TelescopeLiveGrep, { desc = "[S]earch [B]uffers" })

-- ** Move selected lines up/down **
vim.keymap.set("n", "<M-j>", function() vim.cmd(":m+1") end, { desc = "Move selected line down one line" })
vim.keymap.set("n", "<M-k>", function() vim.cmd(":m-2") end, { desc = "Move selected line up one line" })

vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down one line" })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up one line" })

vim.keymap.set("n", "<C-/>", function() vim.cmd(":noh") end, { desc = "Disable search highlighting" })

vim.keymap.set("n", "<leader>tb", function() vim.cmd(":ToggleAlternate") end,
  { desc = "[T]oggle [B]oolean (rmagatti/alternate-toggler)" })
