local the_model = "JetBrains/Mellum-4b-sft-all:latest"
-- local the_model = 'qwen3-coder:latest'
-- local the_model = 'gpt-oss:latest'

vim.pack.add({ "https://github.com/milanglacier/minuet-ai.nvim" })

require("minuet").setup({
	mapping = {
		["<A-y>"] = function()
			require("minuet").make_cmp_map()
			local cmp = require("cmp")
			cmp.complete({
				config = {
					sources = {
						name = "minuet",
					},
				},
			})
		end,
	},
	context_window = 100000,
	context_ratio = 0.75,
	provider = "openai_fim_compatible",
	provider_options = {
		openai_fim_compatible = {
			api_key = "TERM",
			name = "Ollama",
			end_point = "http://localhost:11434/v1/completions",
			model = the_model,
		},
	},
	name = "Ollama",
	end_point = "http://localhost:11434/v1/completions",
	model = the_model,
	optional = {
		max_tokens = 5600,
		top_p = 0.9,
	},
})
