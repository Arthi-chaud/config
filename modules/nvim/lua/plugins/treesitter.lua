return {
	-- Note: Just keeping this here, in case I want to go back to dark theme
	-- {
	-- 	"briones-gabriel/darcula-solid.nvim",
	-- 	dependencies = { "rktjmp/lush.nvim" },
	-- 	config = function()
	-- 		vim.cmd([[ colorscheme darcula-solid ]])
	-- 		vim.cmd([[ set termguicolors ]])
	-- 	end,
	-- },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup()

			vim.cmd.colorscheme("catppuccin")
		end,
		opts = function()
			return {
				flavour = "latte",
				integrations = {
					telescope = {
						enabled = true,
					},
				},
			}
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"c",
				"haskell",
				"typescript",
				"python",
				"go",
				"rust",
				"yaml",
				"json",
				"lua",
				"markdown",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["a="] = "@assignment.outer",
							["i="] = "@assignment.inner",
							["l="] = "@assignment.lhs",
							["r="] = "@assignment.rhs",

							["af"] = "@function.outer",
							["if"] = "@function.inner",

							["ac"] = "@class.outer",
							["ic"] = "@class.inner",

							["aC"] = "@call.outer",
							["iC"] = "@call.inner",

							["ai"] = "@conditional.outer",
							["ii"] = "@conditional.inner",

							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",

							["ar"] = "@return.outer",
							["ir"] = "@return.inner",

							["al"] = "@loop.outer",
							["il"] = "@loop.inner",

							["as"] = "@statement.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.inner",
							["]a"] = "@parameter.inner",
							["]i"] = "@conditional.outter",
							["]l"] = "@loop.outter",
							["]s"] = "@scope",
							["]="] = "@assignment.lhs",
							["]r"] = "@return.inner",
						},
						goto_next_end = {
							["]F"] = "@function.inner",
							["]A"] = "@parameter.inner",
							["]I"] = "@conditional.outter",
							["]L"] = "@loop.outter",
							["]S"] = "@scope",
							["]R"] = "@return.outer",
						},

						goto_previous_start = {
							["[f"] = "@function.inner",
							["[a"] = "@parameter.inner",
							["[i"] = "@conditional.outter",
							["[l"] = "@loop.outter",
							["[s"] = "@scope",
							["[="] = "@assignment.lhs",
							["]r"] = "@return.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.inner",
							["[A"] = "@parameter.inner",
							["[I"] = "@conditional.outter",
							["[L"] = "@loop.outter",
							["[S"] = "@scope",
							["[R"] = "@return.outer",
						},
					},
				},
			})
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			-- Repeat movement with ; and ,
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
			-- make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
		end,
	},
}
