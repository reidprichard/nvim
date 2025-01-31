vim.cmd('source ~/.vimrc')

require("mini")
--require("plugins")

-- Configuration
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.Unicode_no_default_mappings = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- vim.opt.indentexpr = "" -- Had to do this to prevent weird spacing being added when I typed "else" in a cpp file?
vim.opt.guifont = "CaskaydiaCove Nerd Font:h18"
vim.opt.wrap = false
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen" -- When a hsplit opens, scrolls the buffer so that the text maintains the same on-screen position
vim.opt.smartindent = true -- https://www.reddit.com/r/neovim/comments/14n6iiy/if_you_have_treesitter_make_sure_to_disable/
-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,resize"

-- GUI settings --
if vim.g.neovide then
  -- vim.g.neovide_transparency = 0.99
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_refresh_rate_idle = 60
  vim.g.neovide_cursor_animation_length = 0
  vim.keymap.set("t", "<MouseMove>", "<NOP>")
end
-- vim.opt.guifont = "Consolas:h18"

vim.diagnostic.config({
  virtual_text = false, -- Turn off inline diagnostics
})

Platform = vim.loop.os_uname().sysname
if Platform == "Windows_NT" then
  vim.g.python3_host_prog = "python.exe"
end

-- Install package manager
--  -- Git related plugins
--  'tpope/vim-fugitive',
--  -- Detect tabstop and shiftwidth automatically
--  'tpope/vim-sleuth',
--  -- Useful plugin to show you pending keybinds.
--  -- { 'folke/which-key.nvim',  opts = {} },
--  {  { 'folke/which-key.nvim',  opts = {
--      icons = {
--        mappings = false,
--        keys = {
--          Up = "↑",
--          Down = "↓",
--          Left = "←",
--          Right = "→",
--          C = "Ctrl",
--          M = "Win",
--          D = "?",
--          S = "Shift",
--          CR = "Enter",
--          Esc = "Esc",
--          NL = "?",
--          BS = "Bck",
--          Space = "Spc",
--          Tab = "Tab",
--          F1 = "F1",
--          F2 = "F2",
--          F3 = "F3",
--          F4 = "F4",
--          F5 = "F5",
--          F6 = "F6",
--          F7 = "F7",
--          F8 = "F8",
--          F9 = "F9",
--          F10 = "F10",
--          F11 = "F11",
--          F12 = "F12",
--        }
--      }
--    }
--  },
--  -- "gc" to comment visual regions/lines
--  { 'numToStr/Comment.nvim', opts = {} },
--  -- Fuzzy Finder (files, lsp, etc)
--  {
--    'nvim-telescope/telescope.nvim',
--  },
--
--  {
--    -- Highlight, edit, and navigate code
--    'nvim-treesitter/nvim-treesitter',
--    dependencies = {
--      'nvim-treesitter/nvim-treesitter-textobjects',
--    },
--    build = ':TSUpdate',
--  },
 
-- [[ Setting options ]]
-- Sync clipboard between OS and Neovim.
-- vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
--local cmp = require 'cmp'
--local luasnip = require 'luasnip'
--require('luasnip.loaders.from_vscode').lazy_load()
--luasnip.config.setup {}
--
--cmp.setup {
--  snippet = {
--    expand = function(args)
--      luasnip.lsp_expand(args.body)
--    end,
--  },
--  mapping = {
--    ['<C-n>'] = cmp.mapping.select_next_item(),
--    ['<C-p>'] = cmp.mapping.select_prev_item(),
--    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--    ['<C-f>'] = cmp.mapping.scroll_docs(4),
--    ['<C-Space>'] = cmp.mapping.complete {},
--    ['<C-y>'] = cmp.mapping.confirm {
--      behavior = cmp.ConfirmBehavior.Replace,
--      select = false, -- If true, top item will be autoselected
--    },
--  },
--  sources = {
--    { name = 'nvim_lsp', max_item_count = 10 },
--    { name = 'luasnip', max_item_count = 2 },
--  },
--}

require('keymap')
require("python")
require("git")
require("sessions")
