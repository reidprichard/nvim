if vim.g.neovide then
  -- vim.g.neovide_transparency = 0.99
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_refresh_rate_idle = 60
  vim.g.neovide_cursor_animation_length = 0
  vim.keymap.set("t", "<MouseMove>", "<NOP>")
end

local toggleterm = require("toggleterm")
local lspconfig = require("lspconfig")

-- lspconfig.pyright.setup {
--   settings = {
--     python = {
--       analysis = {
--         stubPath = vim.fn.expand("$HOME/python-type-stubs"),
--         -- typeCheckingMode = "off",
--         -- pythonPath = "C:/Users/Reid/AppData/Local/Programs/Python/Python310/python.exe",
--       }
--     }
--   }
-- }

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
vim.keymap.set("n", "<leader>ts", require("onedark").toggle, { desc = "[T]oggle [S]tyle" })

require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "./snippets/" } })

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

local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    b = { name = "[B]ackground" },
    g = { name = "[G]it" },
    l = { name = "[L]SP" },
    r = { name = "[R]un" },
    s = { name = "[S]earch, [S]ession" },
    t = { name = "[T]oggle" },
    w = { name = "[W]orkspace" }, -- This one doesn't work for some reason?
  }
})

vim.diagnostic.config({
  virtual_text = false, -- Turn off inline diagnostics
})

Platform = vim.loop.os_uname().sysname
if Platform == "Windows_NT" then
  vim.g.python3_host_prog = "python.exe"
end

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.inde = "" -- Had to do this to prevent weird spacing being added when I typed "else" in a cpp file?
vim.opt.indentexpr = ""
vim.opt.guifont = "CaskaydiaCove Nerd Font:h18"
vim.opt.wrap = false
vim.opt.number = true
vim.opt.hlsearch = true
vim.g.mapleader = " "
vim.opt.splitright = true
vim.opt.splitbelow = true
-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,resize"

-- function ToggleBackgroundColor()
--   local setting_1 = 2632756
--   local setting_2 = 2632756
--   if vim.api.nvim_get_hl(0, {name="bg"}) == setting_1 then
--     vim.api.nvim_set_hl(0, "Normal", {bg=setting_2})
--   else
--     vim.api.nvim_set_hl(0, "Normal", {bg=setting_1})
--   end
-- end
--
-- vim.api.nvim_create_autocmd({"FocusGained", "FocusLost"}, { callback = ToggleBackgroundColor } )

local function FloatErrorMessage(title, error_text)
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

-- ************** Key mappings ************


vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local function RunPython(background)
  vim.cmd.write()
  print("Running...")
  local script_path = vim.fn.expand("%"):gsub(" ", "\\ ")
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
          FloatErrorMessage("Python error", data)
        end
      end,
      stderr_buffered = true

    })
  else
    toggleterm.exec("clear")
    toggleterm.exec(command)
  end
end
vim.keymap.set("n", "<leader>rp", RunPython, { desc = "[R]un [P]ython" })
vim.keymap.set("n", "<leader>brp", function() RunPython(true) end, { desc = "[B]ackground [R]un [P]ython" })
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

-- vim.keymap.set('n', '<leader>h', function() vim.diagnostic.open_float() end, { desc = "Show [H]over" })

-- ** LuaSnip setup **
local ls = require("luasnip")
vim.keymap.set({"n", "i"}, "<C-S>", function() ls.expand() end, { desc = "Insert [S]nippet" })
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
vim.keymap.set("n", "<leader>sb", TelescopeLiveGrep, { desc = "[S]earch open [B]uffers contents" })

-- ** Move selected lines up/down **
vim.keymap.set("n", "<M-j>", function() vim.cmd(":m+1") end, { desc = "Move selected line down one line" })
vim.keymap.set("n", "<M-k>", function() vim.cmd(":m-2") end, { desc = "Move selected line up one line" })

vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down one line" })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up one line" })

-- The below must be done twice - <C-_> is for in a terminal, while <C-/> is for in a GUI. Both map to Ctrl-/
vim.keymap.set("n", "<C-_>", function() vim.cmd(":noh") end, { desc = "Disable search highlighting" })
vim.keymap.set("n", "<C-/>", function() vim.cmd(":noh") end, { desc = "Disable search highlighting" })

vim.keymap.set("n", "<leader>tb", function() vim.cmd(":ToggleAlternate") end,
  { desc = "[T]oggle [B]oolean (rmagatti/alternate-toggler)" })

vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)

-- vim.keymap.set({ "i", "n", "t" }, "<C-j>",
--   function() vim.cmd("ToggleTerm size=" .. vim.api.nvim_win_get_height(0) * 0.5) end)
-- " optional: change highlight, otherwise Pmenu is used
-- call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')


local function GitAddCommit()
  require("dressing.config").update({ input = { relative = "editor" } })
  vim.ui.input(
    { prompt = "Enter commit message." },
    function(input)
      if input == nil then
        return
      end
      if Platform == "Windows_NT" then
        input = input:gsub("'", "''")
      else
        input = input:gsub("'", "\\'")
      end
      vim.fn.jobstart("git add . && git commit -m '" .. input .. "'",
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
              FloatErrorMessage("Git Commit Error", data)
            end
          end,
          stderr_buffered = true
        })
    end
  )
  require("dressing.config").update({ input = { relative = "cursor" } })
end

vim.keymap.set("n", "<leader>gc", GitAddCommit, { desc = "[G]it [C]ommit: add and commit current directory" })
vim.keymap.set("n", "<leader>gp", function() toggleterm.exec("git push origin main") end,
  { desc = "[G]it [P]ush origin main" })
vim.keymap.set("n", "<leader>gu",
  function()
    vim.ui.input({ prompt = "Reset the last commit? [Y]es/[N]o" },
      function(input)
        if input == "y" or input == "Y" or input == "yes" or input == "Yes" then
          toggleterm.exec("git reset --soft HEAD~1")
        else
          print("Reset cancelled.")
          return
        end
      end
    )
  end
)
vim.keymap.set("n", "<leader>gu", function() toggleterm.exec("git reset --soft HEAD~1") end,
  { desc = "[G]it [U]ndo: undo last commit" })
-- function ResizeWindow(offset, window)
--   -- if window == nil then
--   --   window = 0
--   -- end
--   local old_height = vim.api.nvim_win_get_height(window)
--   vim.api.nvim_win_set_height(window, old_height + offset)
-- end
--
-- vim.keymap.set("t", "<C-.", function() ResizeWindow(5) end)
-- vim.keymap.set("t", "<C-,", function() ResizeWindow(5) end)

-- vim.keymap.set("n", "<leader>ss", require("telescope.builtin").symbols, { desc = "[S]earch [S]ymbols" })
vim.keymap.set("i", "<C-i>", require("telescope.builtin").symbols, { desc = "[I]nsert symbol" })

vim.keymap.set({ "n", "i" }, "<C-S-N>", function() vim.cmd("tabnext") end, { desc = "Go to next tab" })
vim.keymap.set({ "n", "i" }, "<C-S-P>", function() vim.cmd("tabprevious") end, { desc = "Go to previous tab" })
vim.keymap.set({ "n" }, "<C-S-W>", function() vim.cmd("tabclose") end, { desc = "Close current tab" })
