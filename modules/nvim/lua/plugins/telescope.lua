-- TODO
return {
	"luc-tielen/telescope_hoogle",
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>hs", "<cmd>Telescope hoogle<cr>" },
		},
		lazy = false,
	},
}
