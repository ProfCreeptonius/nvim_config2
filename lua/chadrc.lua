-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

-- M.nvdash = { load_on_startup = true }
M = {
	ui = {
		cmp = {
			icons_left = false, -- only for non-atom styles!
			style = "atom", -- default/flat_light/flat_dark/atom/atom_colored
			abbr_maxwidth = 60,
			-- for tailwind, css lsp etc
			format_colors = { lsp = true, icon = "󱓻" },
		},
		statusline = {
			enabled = true,
			theme = "minimal", -- default/vscode/vscode_colored/minimal
			-- default/round/block/arrow separators work only for default statusline theme
			-- round and block will work for minimal theme only
			separator_style = "block",
			order = { "mode", "f", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
			modules = nil,
		},
	},
	base46 = {
		theme = "catppuccin-custom", -- default theme
		hl_add = {},
		hl_override = {},
		integrations = {},
		changed_themes = {},
		transparency = false,
		theme_toggle = { "onedark", "one_light" },
	},
	lsp = {
		signature = false,
	},
}
-- M.lsp = { signature = false },

return M
