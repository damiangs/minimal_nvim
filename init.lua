-- ===============================
--        BASIC SETTINGS
-- ===============================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.incsearch = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"

-- ===============================
--          KEYMAPS
-- ===============================
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ async = true })
end)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- ===============================
--          LAZY.NVIM
-- ===============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"vague2k/vague.nvim",
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"stevearc/conform.nvim",
	"nvim-telescope/telescope.nvim",
	"nvim-lua/plenary.nvim",
})

-- ===============================
--             MASON
-- ===============================
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "gopls", "pylsp" },
})

-- ===============================
--              LSP
-- ===============================
local lspconfig = require("lspconfig")
local servers = { "lua_ls", "gopls", "pylsp" }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({})
end

-- ===============================
--            CMP
-- ===============================
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args) end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "buffer" },
	}),
})
vim.cmd([[set completeopt=menuone,noselect]])

-- ===============================
--         TREESITTER
-- ===============================
require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "bash", "python", "json", "go" },
	highlight = { enable = true },
	indent = { enable = true },
})

-- ===============================
--         CONFORM.NVIM
-- ===============================
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		go = { "gofmt" },
		json = { "jq" },
		bash = { "shfmt" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- ===============================
--          TELESCOPE
-- ===============================
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", function()
	telescope.find_files()
end)
vim.keymap.set("n", "<leader>fg", function()
	telescope.live_grep()
end)
vim.keymap.set("n", "<leader>fb", function()
	telescope.buffers()
end)
vim.keymap.set("n", "<leader>fh", function()
	telescope.help_tags()
end)

-- ===============================
--          COLORS & UI
-- ===============================
vim.cmd("colorscheme vague")
vim.cmd(":hi StatusLine guibg=NONE")
