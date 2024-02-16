-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
Platform = vim.loop.os_uname().sysname
toggleterm_shell = vim.o.shell
if Platform == "Windows_NT" then
	toggleterm_shell = "pwsh.exe"
end
return {
	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		opts = {
			width = 120,
		},
		config = function(_, opts) require("no-neck-pain").setup(opts) end
	},
	{
		"HiPhish/rainbow-delimiters.nvim"
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<S-t>]],
			shell = toggleterm_shell,
		},
		config = function(_, opts)
			if Platform == "Windows_NT" then
				local powershell_options = {
					shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
					shellcmdflag =
					"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
					shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
					shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
					shellquote = "",
					shellxquote = "",
				}
				for option, value in pairs(powershell_options) do
					vim.opt[option] = value
				end
			end
			require("toggleterm").setup(opts)
		end
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {
			-- floating_window_above_cur_line = false,
			-- floating_window_off_x = 6,
			transparency = 0.9,
			toggle_key = '<C-h>',
			toggle_key_flip_floatwin_setting = true,
			bind = true,
			handler_opts = {
				border = "rounded"
			},
			hint_prefix = "",
		},
		config = function(_, opts) require('lsp_signature').setup(opts) end
	},
	{
		"Shatur/neovim-session-manager",
		opts = {
			autosave_only_in_session = true,
		}
	},
	{
		"MDeiml/tree-sitter-markdown",
	},
	-- {
	--   "pocco81/auto-save.nvim"
	-- }
	{
		"mfussenegger/nvim-dap",
	},
	{
		"mfussenegger/nvim-dap-python",
	},
	{
		"rcarriga/nvim-dap-ui",
	},
	-- {
	-- 	"L3MON4D3/LuaSnip",
	-- 	version = "v2.*",
	-- 	build = "make install_jsregexp",
	-- },
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			local opts = {
				sources = {
					-- null_ls.builtins.completion.luasnip,
					null_ls.builtins.diagnostics.mypy.with({
						extra_args = {
							mypy_path = "%PATH%;%PYTHONPATH%;%:p:h",
							"--ignore-missing-imports",
						}
					}),
					null_ls.builtins.formatting.black.with({
						extra_args = { "--line-length=120" },
					}),
				}
			}
			null_ls.setup(opts)
		end
	},
	{
		"debugloop/telescope-undo.nvim",
		dependencies = { -- note how they're inverted to above example
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		keys = {
			{ -- lazy style key map
				"<leader>u",
				"<cmd>Telescope undo<cr>",
				desc = "undo history",
			},
		},
		opts = {
			-- don't use `defaults = { }` here, do this in the main telescope spec
			extensions = {
				undo = {
					-- telescope-undo.nvim config, see below
				},
				-- no other extensions here, they can have their own spec too
			},
		},
		config = function(_, opts)
			-- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
			-- configs for us. We won't use data, as everything is in it's own namespace (telescope
			-- defaults, as well as each extension).
			require("telescope").setup(opts)
			require("telescope").load_extension("undo")
		end,
	},
	{
		"rmagatti/alternate-toggler",
	},
	{
		"stevearc/dressing.nvim",
		opts = {
			input = {
				get_config = function(opts)
					if opts.relative == "window" or opts.relative == "editor" then
						return {
							relative = opts.relative,
						}
					end
				end,
			},
			-- input = {
			-- 	relative = "editor",
			-- },
		},
	},
	{
		"RRethy/vim-illuminate",
	},
	{
		"chrisbra/unicode.vim",
	},
	{
		"nvim-telescope/telescope-symbols.nvim"
	},
	{
		"AckslD/swenv.nvim",
		config = function()
			require("swenv").setup()
			require("swenv.api").set_venv("default")
		end,
	},
	{
		"kkoomen/vim-doge",
		build = function() vim.cmd("call doge#install()") end,
	},
	-- {
	-- 	"lrangell/theme-cycler.nvim",
	-- 	-- opts = {
	-- 	-- 	blacklist_default = true,
	-- 	-- },
	-- 	-- config = function(opts)
	-- 	-- 	require("themeCycler").setup(opts)
	-- 	-- end,
	-- },
	{
		"navarasu/onedark.nvim",
		opts = {
			-- transparent = true,
		},
	},
	-- {
	-- 	"catppuccin/nvim",
	-- },
	{
		"loctvl842/monokai-pro.nvim",
	},
	{
		"rebelot/kanagawa.nvim",
	},
	{
		"sainnhe/sonokai",
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {
			keymaps = {
				normal = '<leader>sa',
				normal_cur = false,
				normal_line = false,
				normal_cur_line = false,
				visual = '<leader>s',
				visual_line = '<leader>s',
				-- delete = '<leader>sd',
				change = '<leader>sr',
			},
			aliases = {
				['i'] = ']', -- Index
				['r'] = ')', -- Round
				['b'] = '}', -- Brackets
			},
			move_cursor = false,
		},
		config = function(_, opts)
			require("nvim-surround").setup(opts)
		end,
	},
}
