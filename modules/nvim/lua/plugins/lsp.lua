-- Hover groups LSP Diagnostic and Hover Info

local expand_macro = function()
	vim.lsp.buf_request_all(0, "rust-analyzer/expandMacro", vim.lsp.util.make_position_params(), function(result)
		-- Create a new tab
		vim.cmd("vsplit")

		-- Create an empty scratch buffer (non-listed, non-file i.e scratch)
		-- :help nvim_create_buf
		local buf = vim.api.nvim_create_buf(false, true)

		-- and set it to the current window
		-- :help nvim_win_set_buf
		vim.api.nvim_win_set_buf(0, buf)

		if result then
			-- set the filetype to rust so that rust's syntax highlighting works
			-- :help nvim_set_option_value
			vim.api.nvim_set_option_value("filetype", "rust", { buf = 0 })

			-- Insert the result into the new buffer
			for client_id, res in pairs(result) do
				if res and res.result and res.result.expansion then
					-- :help nvim_buf_set_lines
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(res.result.expansion, "\n"))
				else
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
						"No expansion available.",
					})
				end
			end
		else
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
				"Error: No result returned.",
			})
		end
	end)
end

local setup_lsp_bindings = function()
	local function hover()
		vim.lsp.buf.hover({
			border = "rounded",
			max_width = 80,
			max_height = 30,
		})
	end
	local function set(mode, binding, action, desc)
		vim.keymap.set(mode, binding, action, { noremap = true, desc = desc })
	end
	set("n", "<leader>ca", vim.lsp.buf.code_action, "Show Code actions")
	set("n", "<leader>cl", vim.lsp.codelens.run, "Show Code lenses")
	set("n", "<leader>me", expand_macro, "Expand Macro")
	set("n", "<leader>li", "<cmd>checkhealth vim.lsp<CR>", "Open LSP Info")
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
		"neovim/nvim-lspconfig",
		lazy = false,
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		init = function()
			vim.lsp.codelens.enable(true)
			setup_lsp_bindings()

			---@param lsp_name string
			---@param lsp_config? vim.lsp.Config
			local function setup_lsp(
				--[[required]]
				lsp_name,
				--[[optional]]
				lsp_config
			)
				vim.lsp.config[lsp_name] = lsp_config or {}
				vim.lsp.enable(lsp_name)
			end
			vim.lsp.enable({ "jsonls", "nixd", "pyright", "gopls" })
			setup_lsp("yamlls", {
				settings = { yaml = { format = { enable = false } } },
			})
			setup_lsp("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("lua", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
			setup_lsp("hls", {
				settings = {
					haskell = {
						formattingProvider = "fourmolu",
						plugin = {
							hlint = {
								globalOn = true,
							},
							splice = {
								globalOn = true,
							},
						},
					},
				},
			})
			setup_lsp("rust_analyzer", {
				settings = {
					rust = {
						procMacro = { enable = true },
					},
				},
			})

			setup_lsp("ts_ls", {
				single_file_support = false,
			})
			setup_lsp("ltex", {
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
			})
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
