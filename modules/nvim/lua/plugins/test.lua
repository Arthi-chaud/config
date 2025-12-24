return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			-- Base deps
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- Languages
			"mrcjkb/neotest-haskell",
			"nvim-neotest/neotest-jest",
			"nvim-neotest/neotest-python",
		},
		opts = function()
			local function set(mode, binding, action, desc)
				vim.keymap.set(mode, binding, action, { noremap = true, desc = desc })
			end
			local neotest = require("neotest")
			set("n", "<leader>tt", function()
				neotest.run.run(vim.fn.expand("%"))
			end, "Run all tests in current file")

			set("n", "<leader>ts", function()
				neotest.summary.toggle()
			end, "Toggle test summary pannel")

			set("n", "<leader>to", function()
				neotest.output_panel.toggle()
			end, "Toggle test output pannel")

			set("n", "<leader>ta", function()
				neotest.run.attach()
			end, "Attach Running tests")

			set("n", "<leader>tS", function()
				neotest.run.stop()
			end, "Stop running tests")

			return {
				adapters = {
					require("neotest-haskell")({
						build_tools = { "stack", "cabal" },
						frameworks = { "hspec" },
					}),
					require("neotest-jest")({
						jestCommand = "yarn test ",
						jestArguments = function(defaultArguments, context)
							return defaultArguments
						end,
						jestConfigFile = "package.json",
					}),
				},
			}
		end,
	},
}
