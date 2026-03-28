return {
	-- Comment out/in lines. Language agnostic
	-- https://github.com/numToStr/Comment.nvim
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
			keywords = {
				TODO = { color = "error" },
				WARN = { color = "warning" },
			},
			highlight = {
				keyword = "bg",
			},
			pattern = [[(KEYWORDS)]],
		},
	},
	-- Show indentations
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			exclude = {
				filetypes = {
					"dashboard",
					"help",
					"man",
					"",
				},
			},
		},
	},
}
