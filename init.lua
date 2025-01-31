vim.cmd('source ~/.vimrc')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.Unicode_no_default_mappings = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- vim.opt.indentexpr = "" -- Had to do this to prevent weird spacing being added when I typed "else" in a cpp file?
vim.opt.guifont = "CaskaydiaCove Nerd Font:h18"
-- vim.opt.guifont = "Consolas:h18"
vim.opt.wrap = false
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen" -- When a hsplit opens, scrolls the buffer so that the text maintains the same on-screen position
vim.opt.smartindent = true -- https://www.reddit.com/r/neovim/comments/14n6iiy/if_you_have_treesitter_make_sure_to_disable/
-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,resize"

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

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


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

require('reid')
--require("python")
--require("git")
--require("sessions")
