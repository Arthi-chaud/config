return {
	"isovector/cornelis",
	name = "cornelis",
	ft = "agda",
	build = "stack install",
	dependencies = { "neovimhaskell/nvim-hs.vim", "kana/vim-textobj-user" },
	version = "*",
	config = function()
		local map = vim.api.nvim_set_keymap
		map("n", "<leader>cl", "<Cmd>:CornelisLoad<CR>", { desc = "Agda: Load" })
		map("n", "<leader>cr", "<Cmd>:CornelisRefine<CR>", { desc = "Agda: Refine" })
		map("n", "<leader>cd", "<Cmd>:CornelisMakeCase<CR>", { desc = "Agda: Make Case" })
		map("n", "<leader>ct", "<Cmd>:CornelisTypeContext<CR>", { desc = "Adga: Type Context" })
		map("n", "<leader>cs", "<Cmd>:CornelisSolve<CR>", { desc = "Agda: Solve" })

		vim.g.cornelis_split_location = "bottom"

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				vim.api.nvim_command(":CornelisLoad")
			end,
		})
	end,
}
