return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		-- Files
		{
			"<leader>f",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>F",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},

		{
			"<leader>b",
			function()
				Snacks.explorer()
			end,
			desc = "Open file tree",
		},

		{
			"<leader>B",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffer",
		},

		-- LSP
		{
			"<leader>D",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>R",
			function()
				Snacks.picker.lsp_references()
			end,
			desc = "References",
		},
		{
			"<leader>S",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<leader>gT",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Fo to type definition",
		},
		-- Git
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},

		{
			"<leader>gD",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff",
		},
		{
			"<leader>gS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "Git Status",
		},

		-- Key maps
		{
			"<leader>K",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},

		{
			"<leader>T",
			function()
				Snacks.terminal()
			end,
			desc = "Keymaps",
		},
	},
	---@type snacks.Config
	opts = {
		indent = {
			enabled = true,
			animate = {
				enabled = false,
			},
			-- Using top-level char does not work
			indent = {
				char = "▏",
			},
			scope = {
				char = "▏",
			},
			chunk = {
				char = {
					vertical = "▏",
				},
			},
		},

		picker = {
			icons = {
				git = {
					enabled = true,
					staged = "A",
					deleted = "D",
					renamed = "R",
					modified = "C",
					untracked = "U",
				},
				diagnostics = {
					Error = "󰅚 ",
					Hint = "󰌶 ",
					Info = " ",
					Warning = "󰀪 ",
				},
			},
			sources = {
				files = {
					hidden = true,
				},
				explorer = {
					auto_close = true,
					hidden = true,
					prompt = " ",
					win = {
						input = {
							keys = {},
						},
						list = {
							keys = {},
						},
					},
				},
			},
		},
		explorer = {},
		terminal = {},
		notifier = {},
		quickfile = {},
		dashboard = {

			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
			},
			preset = {
				header = [[
           @@@@           
           @@@@           
           @@@@           
          @@@@@@          
      @@@@@@@@@@@@@@      
   @@@@@@@@@  @@@@@@@@@   
  @@@@@ @@@@@@@@@@ @@@@@  
 @@@@ @@@@@@@@@@@@@@ @@@@ 
@@@@ @@@@        @@@@ @@@@
@@@ @@@@  @@@@@   @@@@ @@@
@@@ @@@   @@@@@@   @@@ @@@
@@@ @@@@  @@@@@   @@@@ @@@
@@@@ @@@@        @@@@ @@@@
 @@@@ @@@@@@@@@@@@@@ @@@@ 
  @@@@@ @@@@@@@@@@ @@@@@  
   @@@@@@@@    @@@@@@@@   
  @@@@@@@@@@@@@@@@@@@@@@  
 @@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@ @@@@@@@@ @@@@@@@ 
    @@@  @@@@@@@@  @@@    
         @@@@@@@@         
         @@@@@@@@         
				]],
			},
		},
	},
}
