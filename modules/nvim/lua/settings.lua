-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.opt.mouse = ""
-- Mainly to avoid shift caused by git signs
vim.opt.signcolumn = "yes"

-- Custom Keymaps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
--- TODO: Map keys to make window resizing easier
--- TODO: Same for buffers (tabs?)

--- For Visual Mode, allow indenting mulitple time with a single select
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Clear highlight
keymap("n", "<leader>c", "<CMD>:nohl<CR>", opts)

--- Move Lines Up/Down
keymap("n", "<C-j>", ":m .+1<CR>==", opts)
keymap("n", "<C-k>", ":m .-2<CR>==", opts)
keymap("v", "<C-j>", ":m .+1<CR>==", opts)
keymap("v", "<C-k>", ":m .-2<CR>==", opts)

-- Disable Arrows
keymap("n", "<Up>", "<Nop>", opts)
keymap("n", "<Down>", "<Nop>", opts)
keymap("n", "<Left>", "<Nop>", opts)
keymap("n", "<Right>", "<Nop>", opts)

--- TODO: Consider if, when we replace by pasting, we yank the replaced text or not
-- keymap("v", "p", '"_dP', opts)
-- Center cursor when we move
--- Move down/up 1/2 page
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
--- Next/Previous paragraph
keymap("n", "{", "{zz", opts)
keymap("n", "}", "}zz", opts)
-- Next/Previous search result
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)

local hl = "DiagnosticSign"
vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = true,
	severity_sort = false,
	float = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = "  ",
		},

		numhl = {
			[vim.diagnostic.severity.ERROR] = hl .. "Error",
			[vim.diagnostic.severity.WARN] = hl .. "WARN",
			[vim.diagnostic.severity.HINT] = hl .. "HINT",
			[vim.diagnostic.severity.INFO] = hl .. "INFO",
		},
		texthl = {
			[vim.diagnostic.severity.ERROR] = hl .. "Error",
			[vim.diagnostic.severity.WARN] = hl .. "WARN",
			[vim.diagnostic.severity.HINT] = hl .. "HINT",
			[vim.diagnostic.severity.INFO] = hl .. "INFO",
		},
	},
})

-- Not sure what this does
vim.o.updatetime = 250

-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
-- 	group = vim.api.nvim_create_augroup("float_diagnostic_cursor", { clear = true }),
-- 	callback = function()
-- 		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
-- 	end,
-- })
