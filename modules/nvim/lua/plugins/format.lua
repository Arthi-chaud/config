ignored_dirs = { "spegion" }

return {
	{
		"stevearc/conform.nvim",
		opts = {
			default_format_opts = { async = true, lsp_format = "fallback" },
			format_on_save = function()
				local file_cwd = vim.fn.getcwd()
				for _, ignored_dir in pairs(ignored_dirs) do
					if string.find(file_cwd, ignored_dir) then
						return
					end
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			formatters_by_ft = {
				haskell = { "fourmolu" },
				python = { "ruff_format" },
				lua = { "stylua" },
				c = { "clang-format" },
				sql = { "pg_format" },
				typescript = { "biome-check" },
				typescriptreact = { "biome-check" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "biome-check" },
				javascriptreact = { "biome-check" },
				tex = { "latexindent" },
				nix = { "nixfmt" },
			},
		},
	},
}
