vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
})

vim.lsp.config["clangd"] = {
	cmd = {
		"clangd",
		"--background-index",
		"-j=32",
		"--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
		"--clang-tidy",
		"--clang-tidy-checks=*",
		"--all-scopes-completion",
		"--cross-file-rename",
		"--completion-style=detailed",
		"--header-insertion-decorators",
		"--header-insertion=iwyu",
		"--pch-storage=memory",
	},
	filetypes = { "c", "cpp", "h", "hpp" },
	root_markers = { "cmakelists.txt" },
}

vim.lsp.enable("clangd")

vim.lsp.enable("denols")

-- vim.lsp.config['denols'] = {
--   cmd = {
--     'deno',
--     'lsp',
--   },
--   filetypes = {'ts'},
--   root_markers = { "deno.json" }
-- }

vim.pack.add({
	{
		src = "https://github.com/JavaHello/spring-boot.nvim",
		version = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
	},
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/nvim-java/nvim-java",
	"https://github.com/seblyng/roslyn.nvim",
})

require("java").setup()
vim.lsp.enable("jdtls")
vim.lsp.enable("lua_ls")

vim.lsp.enable("ts_ls")
vim.lsp.enable("texlab")

vim.pack.add({ "https://github.com/scalameta/nvim-metals" })

local metals = require("metals")
local metals_config = metals.bare_config()
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "scala", "sbt" },
	callback = function()
		require("metals").initialize_or_attach({})
	end,
	group = nvim_metals_group,
})

vim.lsp.enable("metals")
vim.lsp.enable("cssls")

vim.pack.add({ "https://github.com/TheLeoP/powershell.nvim" })
require("powershell").setup({
	bundle_path = "~/.local/bin/PowerShellEditorServices/",
})

vim.pack.add({ "https://github.com/mason-org/mason.nvim", "https://github.com/mason-org/mason-lspconfig.nvim" })
require("mason").setup()
require("mason-lspconfig").setup()
