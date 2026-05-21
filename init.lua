-- Inspired by nvim kickstart

vim.cmd 'set laststatus=3'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'
vim.opt.showmode = false

vim.schedule(function ()
	vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true


vim.opt.signcolumn = 'yes'

-- How long before writing swapfile
vim.opt.updatetime = 250

-- How long before which-key shows up
-- vim.opt.timeoutlen = 300

-- Keep default splitting behavior instead
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- show substitutions live while typing
vim.opt.inccommand = 'split'

vim.opt.cursorline = true

vim.opt.scrolloff = 10

-- Esc to clear highlight of search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-c>', '<cmd>nohlsearch<CR>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.pack.add({
	'https://github.com/tpope/vim-sleuth',
	'https://github.com/kylechui/nvim-surround'
})


vim.pack.add({
  'https://github.com/echasnovski/mini.nvim',
})

require('mini.ai').setup {n_lines = 500}
require('mini.move').setup()
require('mini.colors').setup()

vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope.nvim'
})

require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },

}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')


vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    map('gtd', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype [D]efinition')

    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    map('<leader>sh', vim.lsp.buf.signature_help, '[S]ignature [H]elp')
    map('<C-s>', vim.lsp.buf.signature_help, '[S]ignature [H]elp', 'i')

    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
	buffer = event.buf,
	group = highlight_augroup,
	callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
	buffer = event.buf,
	group = highlight_augroup,
	callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
	group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
	callback = function(event2)
	  vim.lsp.buf.clear_references()
	  vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
	end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    -- changed by
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>lh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, 'Toggle In[l]ay [H]ints')
    end
  end,
})

vim.pack.add({
    'https://github.com/stevearc/conform.nvim',
})

require('conform').setup{
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    }

vim.pack.add({
    'https://github.com/stevearc/oil.nvim',
})

require('oil').setup {
    columns = {
      'permissions',
      'size',
      'mtime',
      'icon',
    },
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<gv>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
      ['<gh>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
      ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = 'actions.close',
      ['<gl>'] = 'actions.refresh',
      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory', mode = 'n' },
      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
      ['g\\'] = 'actions.toggle_trash',
    },
    use_default_keymaps = false,
  }


-- Compile mode
vim.pack.add({
  'https://github.com/ej-shafran/compile-mode.nvim'
})

vim.g.compile_mode = {
  -- The string to show in the compile prompt as a default.
  -- For an empty prompt, you can use:
  -- default_command = "",
  -- :h compile_mode.default_command
  default_command = '',
  -- Use `baleia` for parsing ANSI escape codes in the output.
  -- :h compile_mode.baleia_setup
  baleia_setup = false,
  -- Expand commands, like `:!` (e.g. `:Compile echo %`)
  -- :h compile_mode.bang_expansion
  bang_expansion = false,
  -- Configure additional error regexes.
  -- :h compile-mode-errors
  error_regexp_table = {},
  -- List of filename regexes to ignore errors from.
  -- :h compile-mode.error_ignore_file_list
  error_ignore_file_list = {},
  -- The minimum error level to jump to.
  -- :h compile-mode.error_threshold
  error_threshold = require('compile-mode').level.WARNING,
  -- Automatically jump to the first error.
  -- :h compile-mode.auto_jump_to_first_error
  auto_jump_to_first_error = false,
  -- How long to highlight an error's location when jumping to it.
  -- :h compile-mode.error_locus_highlight
  error_locus_highlight = 500,
  -- Use Neovim diagnostics instead of opening the compilation buffer.
  -- :h compile-mode.use_diagnostics
  use_diagnostics = true,
  -- Default to calling `:Compile` for `:Recompile`
  -- when there's no previous command.
  -- :h compile-mode.recompile_no_fail
  recompile_no_fail = false,
  -- Ask to save unsaved buffers before compiling.
  -- :h compile-mode.ask_about_save
  ask_about_save = true,
  -- Ask to interrupt already running commands.
  -- :h compile-mode.ask_to_interrupt
  ask_to_interrupt = true,
  -- The name for the compilation buffer.
  -- :h compile-mode.buffer_name
  buffer_name = '*compilation*',
  -- The format for the time information
  -- at the top of the compilation buffer
  -- :h compile-mode.time_format
  time_format = '%a %b %e %H:%M:%S',
  -- List of regexes to hide from the output.
  -- :h compile-mode.hidden_output
  hidden_output = {},
  -- A table of environment variables to pass to commands.
  -- :h compile-mode.environment
  environment = nil,
  -- Clear all environment variables for each command.
  -- :h compile-mode.clear_environment
  clear_environment = false,
  -- Fix compilation for plugins like `nvim-cmp`.
  -- :h compile-mode.input_word_completion
  input_word_completion = false,
  -- Hide the compliation buffer.
  -- :h compile-mode.hidden_buffer
  hidden_buffer = false,
  -- Automatically focus the compilation buffer.
  -- :h compile-mode.focus_compilation_buffer
  focus_compilation_buffer = false,
  -- Jump back past the end/beginning of the errors
  -- with `:NextError`/`:PrevError`
  -- :h compile-mode.use_circular_error_navigation
  use_circular_error_navigation = false,
  -- Print debug information.
  -- :h compile-mode.debug
  debug = false,
}

vim.pack.add({
  'https://github.com/folke/flash.nvim'
})

require('flash').setup {
  modes = {
    char = {
      enabled = false,
    },
  },
  jump = {
    -- pos = 'range',
    -- autojump = 'true',
    inclusive = true,
  },
}


vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/hiphish/rainbow-delimiters.nvim',
})

vim.api.nvim_create_autocmd({'BufWinEnter', 'CmdwinEnter'}, {
  desc = "Enable treesitter automatically",
  group = vim.api.nvim_create_augroup('maki-start-treesitter', {clear = true}),
  callback = function() 
    pcall(vim.treesitter.start)
  end
})


vim.pack.add({
  'https://github.com/saghen/blink.lib',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/ribru17/blink-cmp-spell',
  'https://github.com/archie-judd/blink-cmp-words'
})

local cmp = require('blink.cmp')
cmp.build():wait(60000)
cmp.setup({
  -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
  -- 'super-tab' for mappings similar to vscode (tab to accept)
  -- 'enter' for enter to accept
  -- 'none' for no mappings
  --
  -- All presets have the following mappings:
  -- C-space: Open menu or open docs if already open
  -- C-n/C-p or Up/Down: Select next/previous item
  -- C-e: Hide menu
  -- C-k: Toggle signature help (if signature.enabled = true)
  --
  -- See :h blink-cmp-config-keymap for defining your own keymap
  keymap = {
    preset = 'default',
    ['<A-y>'] = {
      function(cmp)
        cmp.show { providers = { 'minuet' } }
      end,
    },
    ['<C-l>'] = {
      function(cmp)
        cmp.snippet_forward()
      end,
    },
    ['<C-S-l>'] = {
      function(cmp)
        cmp.snippet_backward()
      end,
    },
    ['<F2>'] = { 'select_and_accept' },
    ['<F3>'] = { 'select_next' },
    ['<F4>'] = { 'select_prev' },
  },

  signature = {
    enabled = true,
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
    use_nvim_cmp_as_default = true,
  },

  -- (Default) Only show the documentation popup when manually triggered
  completion = {
    ghost_text = {
      enabled = true,
    },
    keyword = {
      range = 'prefix',
    },
    accept = {
      auto_brackets = {
        kind_resolution = {
          blocked_filetypes = { 'tex' },
        },
        semantic_token_resolution = {
          blocked_filetypes = { 'tex' },
        },
      },
    },
    menu = {
      border = 'none',
      auto_show = true,
      draw = {
        align_to = 'label', -- or 'none' to disable, or 'cursor' to align to the cursor
        padding = 1,
        gap = 1,
        -- Use treesitter to highlight the label text
        treesitter = { 'lsp' },
        -- Components to render, grouped by column
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind', gap = 1 },
        },
      },
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
      treesitter_highlighting = true,
      window = {
        border = 'padded',
      },
    },
    -- documentation = { auto_show = true },
  },

  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  -- snippets = {
    --   preset = 'luasnip',
    -- },
    sources = {
      default = { 'lsp', 'snippets', 'buffer' },
      providers = {
        snippets = {
          name = 'snippets',
          async = true,
          score_offset = 4,
        },
        lsp = {
          name = 'lsp',
          async = true,
          score_offset = 5,
        },
        buffer = {
          name = 'buffer',
          async = true,
          score_offset = -1,
        },
        spell = {
          name = 'spell',
          module = 'blink-cmp-spell',
          opts = {},
          async = true,
          score_offset = -2,
        },
        minuet = {
          name = 'minuet',
          module = 'minuet.blink',
          score_offset = 5,
          opts = {},
          async = true,
        },
      },
    }, -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = {

      implementation = 'prefer_rust_with_warning',
      sorts = {
        'score',
        function(a, b)
          local sort = require 'blink.cmp.fuzzy.sort'
          if a.source_id == 'spell' and b.source_id == 'spell' then
            return sort.label(a, b)
          end
        end,
        'sort_text',
      },
    },

})


-- vim.pack.add({
--   'https://github.com/hrsh7th/nvim-cmp',
--   'https://github.com/hrsh7th/cmp-nvim-lsp',
--   'https://github.com/hrsh7th/cmp-buffer',
--   'https://github.com/hrsh7th/cmp-path',
--   'https://github.com/hrsh7th/cmp-cmdline',
--   'https://github.com/L3MON4D3/LuaSnip'
-- })
--
--
-- local cmp = require'cmp'
--
-- cmp.setup({
--   preselect = cmp.PreselectMode.Item,
--   confirmation = {
--     completeopt = 'menu,menuone,noinsert'
--   },
--   snippet = {
--     -- REQUIRED - you must specify a snippet engine
--     expand = function(args)
--       -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--       require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
--       -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
--       -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
--       -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
--
--       -- For `mini.snippets` users:
--       -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
--       -- insert({ body = args.body }) -- Insert at cursor
--       -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
--       -- require("cmp.config").set_onetime({ sources = {} })
--     end,
--   },
--   window = {
--     -- completion = cmp.config.window.bordered(),
--     -- documentation = cmp.config.window.bordered(),
--   },
--   mapping = cmp.mapping.preset.insert({
--     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.abort(),
--     ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--   }),
--   sources = cmp.config.sources({
--     { name = 'nvim_lsp' },
--     -- { name = 'vsnip' }, -- For vsnip users.
--     { name = 'luasnip' }, -- For luasnip users.
--     -- { name = 'ultisnips' }, -- For ultisnips users.
--     -- { name = 'snippy' }, -- For snippy users.
--   }, {
--     { name = 'buffer' },
--   })
-- })
--
-- -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- -- Set configuration for specific filetype.
-- --[[ cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'git' },
--   }, {
--     { name = 'buffer' },
--   })
-- })
-- require("cmp_git").setup() ]]--
--
-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })
--
-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   }),
--   matching = { disallow_symbol_nonprefix_matching = false }
-- })
--
--


-- vim.cmd "set completeopt=menuone,noselect,fuzzy,nosort"
-- vim.cmd "set completeopt=menuone,fuzzy"

require('lsps')
require('themes')

vim.pack.add({ -- Add indentation guides even on blank lines
    'https://github.com/lukas-reineke/indent-blankline.nvim',
})

local highlight = {
  'RainbowYellow',
  'RainbowViolet',
  'RainbowBlue',
  'RainbowOrange',
  'RainbowGreen',
  'RainbowCyan',
}
local hooks = require 'ibl.hooks'
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes

vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })

vim.g.rainbow_delimiters = { highlight = highlight }
require('ibl').setup { scope = { highlight = highlight } }

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

vim.pack.add({
  'https://github.com/lervag/vimtex'
})

vim.g.vimtex_view_method = "zathura"

vim.pack.add({
  'https://github.com/jake-stewart/multicursor.nvim'
})

-- colorscheme stuff
require('base46_config')

require('mappings')


