vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
})



local clangd_exe = "clangd"
if vim.loop.os_uname().sysname == "FreeBSD" then clangd_exe = "clangd22" end


vim.lsp.config["clangd"] = {
	cmd = {
		clangd_exe,
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

vim.pack.add({ "https://github.com/AlexandrosAlexiou/kotlin.nvim" })
require("kotlin").setup({
	-- Optional: Specify root markers for multi-module projects
	-- Default: { "build.gradle", "build.gradle.kts", "pom.xml", "mvnw" }
	root_markers = {
		"gradlew",
		".git",
		"mvnw",
		"settings.gradle",
	},

	-- Optional: Java Runtime to run the kotlin-lsp server itself
	-- LEGACY ONLY — ignored on v262.4739.0+ (bin/intellij-server manages
	-- its own JBR; a warning is shown if this is set on a new install).
	-- Only useful with older builds that ship kotlin-lsp.sh / kotlin-lsp.cmd.
	--
	-- When set, the plugin parses JVM args from the bundled launcher script
	-- and invokes your custom JRE with the correct flags
	-- Must point to JAVA_HOME (directory containing bin/java)
	-- Examples:
	--   macOS:   "/Library/Java/JavaVirtualMachines/jdk-25.jdk/Contents/Home"
	--   Linux:   "/usr/lib/jvm/java-25-openjdk"
	--   Windows: "C:\\Program Files\\Java\\jdk-25"
	--   Env var: os.getenv("JAVA_HOME") or os.getenv("JDK25")
	jre_path = nil,

	-- Optional: JDK for symbol resolution (analyzing your Kotlin code)
	-- This is the JDK that your project code will be analyzed against
	-- Different from jre_path (which runs the server)
	-- Required for: Analyzing JDK APIs, standard library symbols, platform types
	--
	-- Usually should match your project's target JDK version
	-- Examples:
	--   macOS:   "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home"
	--   Linux:   "/usr/lib/jvm/java-17-openjdk"
	--   Windows: "C:\\Program Files\\Java\\jdk-17"
	--   SDKMAN:  os.getenv("HOME") .. "/.sdkman/candidates/java/17.0.8-tem"
	jdk_for_symbol_resolution = nil, -- Auto-detect from project

	-- Optional: Specify additional JVM arguments for the kotlin-lsp server
	jvm_args = {
		"-Xmx12g", -- Increase max heap (useful for large projects)
	},

	-- Optional: Configure inlay hints (requires kotlin-lsp v261+)
	-- All settings default to true, set to false to disable specific hints
	inlay_hints = {
		enabled = true,       -- Enable inlay hints (auto-enable on LSP attach)
		parameters = true,    -- Show parameter names
		parameters_compiled = true, -- Show compiled parameter names
		parameters_excluded = false, -- Show excluded parameter names
		types_property = true, -- Show property types
		types_variable = true, -- Show local variable types
		function_return = true, -- Show function return types
		function_parameter = true, -- Show function parameter types
		lambda_return = true, -- Show lambda return types
		lambda_receivers_parameters = true, -- Show lambda receivers/parameters
		value_ranges = true,  -- Show value ranges
		kotlin_time = true,   -- Show kotlin.time warnings
	},

	-- Optional: LSP-driven folding (requires kotlin-lsp v262.4739.0+)
	-- Enabled by default; set folding.enabled = false to opt out.
	folding = { enabled = false },

	-- Optional: build-importer preference (requires kotlin-lsp v262.4739.0+)
	-- Mirrors the VSCode `intellij.buildTool` setting:
	--   nil = let the server pick (default)
	--   "gradle" or "maven" = force a specific importer
	--   ""    = none (single-file / no build system)
	-- build_tool = "gradle",

	-- Optional: file templates for new Kotlin files (requires kotlin-lsp v262.4739.0+)
	-- When you create a new .kt file the plugin asks the server to interpolate the
	-- chosen template. Pass a table of name → Velocity template to override the
	-- defaults (Class, File, Interface, Data Class, Enum, Annotation, Object).
	-- Set { enabled = false } on the table to disable the prompt entirely.
	-- file_templates = {
	--     enabled = true,
	--     -- Class = "package ${PACKAGE_NAME}\n\nclass ${NAME} {\n\t|\n}",
	-- },
})

vim.lsp.config["kotlin_lsp"] = {
	filetypes = { "kotlin" },
	root_markers = {
		"gradlew",
		".git",
		"mvnw",
		"settings.gradle",
	},
}
vim.lsp.enable("kotlin_lsp")
