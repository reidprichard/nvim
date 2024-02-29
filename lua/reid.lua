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
  filetypes = { "ahk", "autohotkey" },
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
  toggle_style_key = '<leader>to',
  -- toggle_style_list = { 'dark', 'cool', 'deep', 'warm' }
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
-- vim.opt.guifont = "Consolas:h18"
vim.opt.wrap = false
vim.opt.number = true
vim.opt.hlsearch = true
vim.g.mapleader = " "
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen" -- When a hsplit opens, scrolls the buffer so that the text maintains the same on-screen position
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

local function float_error_message(title, error_text)
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
    toggleterm.exec(command)
  end
end
vim.keymap.set("n", "<leader>rp", run_python, { desc = "[R]un [P]ython" })
vim.keymap.set("n", "<leader>brp", function() run_python(true) end, { desc = "[B]ackground [R]un [P]ython" })
-- vim.keymap.set("n", "<leader>rp", function() vim.cmd.write() vim.cmd("TermExec cmd=\"python %\"") end, { desc = "[R]un [P]ython" } )
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
  { desc = "[S]ession: [S]ave" })
vim.keymap.set("n", "<leader>sl", function() vim.cmd("SessionManager load_session") end, { desc = "[S]ession [L]oad" })
vim.keymap.set("n", "<leader>sd", function() vim.cmd("SessionManager delete_session") end,
  { desc = "[S]ession: [D]elete" })

vim.keymap.set({ "n", "v" }, "<leader>lf", function() vim.lsp.buf.format { timeout_ms = 2500 } end,
  { desc = "[L]SP [F]ormat" })

-- vim.keymap.set('n', '<leader>h', function() vim.diagnostic.open_float() end, { desc = "Show [H]over" })

-- ** LuaSnip setup **
local ls = require("luasnip")
vim.keymap.set({ "n", "i" }, "<C-S>", function() ls.expand() end, { desc = "Insert [S]nippet" })
-- vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
-- vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

local function get_visual_selection()
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
vim.keymap.set("n", "<leader>yc", '"+yy', { desc = "[Y]ank to [C]lipboard" })
local function yank_without_breaks()
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
vim.keymap.set("v", "<leader>yC", yank_without_breaks, { desc = "[Y]ank to [C]lipboard (remove newlines)" })

-- ** NoNeckPain binds **
vim.keymap.set("n", "<leader>tc", function() vim.cmd(":NoNeckPain") end, { desc = "[T]oggle [C]enter" })
vim.keymap.set("n", "<leader>cu", function() vim.cmd(":NoNeckPainWidthUp") end, { desc = "[C]enter width [U]p" })
vim.keymap.set("n", "<leader>cd", function() vim.cmd(":NoNeckPainWidthDown") end, { desc = "[C]enter width [D]own" })

local function telescope_live_grep()
  if vim.fn.executable("rg") then
    require("telescope.builtin").live_grep({ grep_open_files = true })
  else
    print("Error: ripgrep must be installed.")
  end
end

-- ** Search all buffers' contents **
vim.keymap.set("n", "<leader>sb", telescope_live_grep, { desc = "[S]earch open [B]uffers contents" })

-- ** Move selected lines up/down **
vim.keymap.set("n", "<M-j>", function() vim.cmd(":m+1") end, { desc = "Move selected line down one line" })
vim.keymap.set("n", "<M-k>", function() vim.cmd(":m-2") end, { desc = "Move selected line up one line" })

vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down one line" })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up one line" })

-- The below must be done twice - <C-_> is for in a terminal, while <C-/> is for in a GUI. Both map to Ctrl-/
vim.keymap.set({ "n", "i", "t" }, "<C-_>", function() vim.cmd(":noh") end, { desc = "Disable search highlighting" })
vim.keymap.set({ "n", "i", "t" }, "<C-/>", function() vim.cmd(":noh") end, { desc = "Disable search highlighting" })

vim.keymap.set("n", "<leader>tb", function() vim.cmd(":ToggleAlternate") end,
  { desc = "[T]oggle [B]oolean (rmagatti/alternate-toggler)" })

vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)

-- vim.keymap.set({ "i", "n", "t" }, "<C-j>",
--   function() vim.cmd("ToggleTerm size=" .. vim.api.nvim_win_get_height(0) * 0.5) end)
-- " optional: change highlight, otherwise Pmenu is used
-- call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')


local function git_add_and_commit()
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
      vim.fn.jobstart("git add . && git commit -m " .. input,
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

vim.keymap.set("n", "<leader>gc", git_add_and_commit, { desc = "[G]it [C]ommit: add and commit current directory" })
vim.keymap.set("n", "<leader>gp", function() toggleterm.exec("git push origin main") end,
  { desc = "[G]it [P]ush origin main" })
vim.keymap.set("n", "<leader>gu",
  function()
    local choice = vim.fn.confirm('Reset the last commit?', '&Yes\n&No')
    if choice == 1 then
      toggleterm.exec("git reset --soft HEAD~1")
    else
      print("Reset cancelled.")
      return
    end
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
-- vim.keymap.set("i", "<C-i>", require("telescope.builtin").symbols, { desc = "[I]nsert symbol" })

vim.keymap.set({ "n", "i" }, "<A-H>", function() vim.cmd("tabnext") end, { desc = "Go to next tab" })
vim.keymap.set({ "n", "i" }, "<A-L>", function() vim.cmd("tabprevious") end, { desc = "Go to previous tab" })
vim.keymap.set({ "n" }, "<C-S-W>", function() vim.cmd("tabclose") end, { desc = "Close current tab" })

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

vim.keymap.set("n", "<leader>pti", python_add_type_ignore_statement, { desc = "[P]ython [T]ype [I]gnore" })
vim.keymap.set("n", "<leader>psv", require("swenv.api").pick_venv, { desc = "[P]ython [S]elect [V]env" })

vim.keymap.set("n", "<leader>dg", function() vim.cmd("DogeGenerate") end, { desc = "[D]ocumentation [G]enerate" })
vim.g.doge_python_settings = { single_quotes = 0, omit_redundant_param_types = 0 }
vim.g.doge_doc_standard_python = "numpy"

-- require('ayu').setup({
--   overrides = function()
--     if vim.o.background == 'dark' then
--       return { NormalNC = {bg = '#0f151e', fg = '#808080'} }
--     else
--       return { NormalNC = {bg = '#f0f0f0', fg = '#808080'} }
--     end
--   end
-- })
-- vim.keymap.set("n", "<leader>tt", require("themeCycler").open_lazy, { desc = "[T]oggle [T]heme" } )
vim.keymap.set("n", "<leader>tt", require("telescope.builtin").colorscheme, { desc = "[T]oggle [T]heme" })
-- vim.g.sonokai_transparent_background = 2
vim.g.sonokai_dim_inactive_windows = 1
-- vim.g.sonokai_colors_override = {fg = {'#cfccbe', '235'}}
vim.cmd("colorscheme sonokai")

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
-- vim.keymap.set("n", "q", "<Nop>");
-- vim.keymap.set("n", "Q", vim.api.macr);
