return {
	{
		"linrongbin16/lsp-progress.nvim",
		config = function()
			vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				group = "lualine_augroup",
				pattern = "LspProgressStatusUpdated",
				callback = require("lualine").refresh,
			})
			require("lsp-progress").setup({
				spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
				client_format = function(client_name, spinner, series_messages)
					if #series_messages > 0 then
						return ("[" .. client_name .. "] " .. spinner)
					else
						return nil
					end
				end,
				-- TODO Before the LSP starts loading, will show checkmark
				format = function(client_messages)
					local api = require("lsp-progress.api")
					if #client_messages > 0 then
						return table.concat(client_messages, " ")
					end
					if #api.lsp_clients() > 0 then
						return " "
					end
					return nil
				end,
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		-- src: https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#lazynvim
		dependencies = { "nvim-tree/nvim-web-devicons", "linrongbin16/lsp-progress.nvim" },
		opts = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "diagnostics" },
				lualine_c = {},
				lualine_w = { "filename" },
				lualine_x = { { "filetype", icon_only = true } },
				lualine_y = {
					function()
						return require("lsp-progress").progress()
					end,
				},
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_w = {},
				lualine_x = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		},
	},
}
