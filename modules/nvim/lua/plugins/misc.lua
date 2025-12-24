return {
	-- Comment out/in lines. Language agnostic
	-- https://github.com/numToStr/Comment.nvim
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
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
