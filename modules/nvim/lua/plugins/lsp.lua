-- Hover groups LSP Diagnostic and Hover Info
local function hover()
	local bufnr = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()

	-- Get diagnostics at cursor
	local diag = vim.diagnostic.get(bufnr, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
	local diag_msg = ""
	for _, d in ipairs(diag) do
		-- Split each diagnostic
		diag_msg = diag_msg .. d.message .. "\n--\n"
	end

	-- Get hover info
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if clients == nil or #clients == 0 then
		return
	end
	vim.lsp.buf_request(
		0,
		"textDocument/hover",
		vim.lsp.util.make_position_params(win, clients[1].offset_encoding or "utf-16"),
		function(_, result, _, _)
			if not (result and result.contents) then
				if diag_msg ~= "" then
					vim.diagnostic.open_float(nil, { scope = "cursor" })
				end
				return
			end
			local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)

			-- Merge diagnostics + hover
			if diag_msg ~= "" then
				table.insert(markdown_lines, 1, "**Diagnostics:**")
				local line_count = 1
				for line in diag_msg:gmatch("([^\n]*)\n?") do
					if line == "--" then
						table.insert(markdown_lines, line_count + 1, line)
						line_count = line_count + 1
					elseif line ~= "" then
						line = string.gsub(line, "%[", "\\["):gsub("%]", "\\]")
						table.insert(markdown_lines, line_count + 1, "- " .. line)
						line_count = line_count + 1
					end
				end
				-- spacer between diagns and hover info
				-- only if hover info
				if line_count ~= #markdown_lines then
					table.insert(markdown_lines, line_count + 1, "---")
				end
			end

			if vim.tbl_isempty(markdown_lines) then
				return
			end

			vim.lsp.util.open_floating_preview(markdown_lines, "markdown", { border = "rounded" })
		end
	)
end

local function run_codelens()
	local bufnr = vim.api.nvim_get_current_buf()
	local lenses = vim.lsp.codelens.get(bufnr)

	if not lenses or #lenses == 0 then
		vim.notify("No code lenses available", vim.log.levels.INFO)
		return
	end
	vim.lsp.codelens.run() -- NOTE: Cannot run just one lens, has to be all of then on the current line
end

local lsp_keymaps = function()
	local function set(mode, binding, action, desc)
		vim.keymap.set(mode, binding, action, { noremap = true, desc = desc })
	end
	set("n", "<leader>ca", vim.lsp.buf.code_action, "Show Code actions")
	set("n", "<leader>cl", run_codelens, "Show Code lenses")
	set("n", "<leader>li", "<cmd>LspInfo<CR>", "Open LSP Info")
	set("n", "<leader>i", hover, "Get var/type info")
	set("n", "<leader>gR", "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol")
	set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition")
	set("n", "<leader>gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation")
	set("n", "[g", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, "Jump to previous Diagnostic")
	set("n", "]g", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, "Jump to next Diagnostic")
end

return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = { library = {
			"lazy.nvim",
		} },
	},
	{
		"dundalek/lazy-lsp.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = function()
			lsp_keymaps()
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufWritePost", "BufNewFile", "LspAttach" }, {
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()
					vim.lsp.codelens.refresh({ bufnr = bufnr })
				end,
			})
			-- local lspconfig = require("lspconfig")
			-- local configs = require("lspconfig.configs")
			--
			-- configs.agda_ls = {
			-- 	default_config = {
			-- 		cmd = { "als" },
			-- 		filetypes = { "agda" },
			-- 		root_dir = lspconfig.util.root_pattern("*.agda"),
			-- 		single_file_support = true,
			-- 	},
			-- }
			--
			-- lspconfig.agda_ls.setup({})
			return {
				prefer_local = true,
				-- https://github.com/dundalek/lazy-lsp.nvim/issues/63
				use_vim_lsp_config = true,
				excluded_servers = {
					"denols",
					"quick_lint_js",
					"tailwindcss",
					"efm",
					"texlab",
				},
				preferred_servers = {
					haskell = { "hls" },
					c = { "clangd" },
					typescript = { "ts_ls", "biome" },
					tsx = { "ts_ls", "biome" },
					typescriptreact = { "ts_ls", "biome" },
					markdown = { "ltex" },
					latex = { "ltex" },
					python = { "ruff_lsp", "pyright" },
				},
				configs = {
					rust_analyzer = {
						settings = {
							rust = {
								procMacro = { enable = true },
							},
						},
					},
					hls = {
						settings = {
							haskell = {
								formattingProvider = "fourmolu",
								plugin = {
									hlint = {
										globalOn = true,
									},
								},
							},
						},
					},
					ts_ls = {
						single_file_support = false,
					},
					ltex = {
						flags = { debounce_text_changes = 300 },
						settings = {
							ltex = {
								language = "en-GB",
								additionalRules = {
									enablePickyRules = true,
									motherTongue = "en-GB",
								},
								disabledRules = {
									["en-GB"] = { "OXFORD_SPELLING_Z_NOT_S" },
								},
							},
						},
					},
				},
			}
		end,
	},
	-- {
	-- 	-- Allows adding words to dictionary
	-- 	"barreiroleo/ltex_extra.nvim",
	-- 	ft = { "markdown", "tex" },
	-- 	opts = {
	-- 		load_langs = { "en-GB" },
	-- 	},
	-- },
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		config = function(_, opts)
			local lint = require("lint")
			lint.linters_by_ft = opts
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
				callback = function()
					require("lint").try_lint(nil, { ignore_errors = true })
				end,
			})
		end,
		opts = {
			python = { "ruff" },
			typescript = { "biomejs", "eslint" },
			typescriptreact = { "biomejs", "eslint" },
			haskell = { "hlint" },
			swift = { "swiftlint" },
		},
	},
}

-- local setup_lambdananas = function()
-- 	local lspconfig = require("lspconfig")
-- 	local configs = require("lspconfig.configs")
--
-- 	if not configs.lambdananas then
-- 		configs.lambdananas = {
-- 			default_config = {
-- 				cmd = { "lambdananas-language-server", "." },
-- 				filetypes = { "haskell", "lhaskell" },
-- 				root_dir = lspconfig.util.root_pattern("hie.yaml", "stack.yaml", "*.cabal", "package.yaml"),
-- 				single_file_support = true,
-- 			},
-- 		}
-- 	end
-- 	lspconfig.lambdananas.setup({})
-- end
