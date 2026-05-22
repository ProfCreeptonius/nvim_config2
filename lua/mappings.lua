
local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map('i', 'jk', '<ESC>')
map('i', '<C-Enter>', '<ESC>o')
map('n', '<C-Enter>', 'o<ESC>')
map('n', 'citn', '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = '[C]hange [I]nner [T]ag [N]ame' })
map('t', '<ESC><ESC>', '<C-\\><C-n>', { silent = true })
vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true, desc = '[G]et [H]elp' })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- map({ 'n', 'v' }, '<leader>st', require('stay-centered').toggle, { desc = 'Toggle stay-centered.nvim' })
map('n', '<space>lh', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle In[l]ay [H]ints' })
map('n', '<leader>db', '<cmd>DapToggleBreakpoint<CR>', { desc = 'Toggle [D]ap [B]reakpoint' })
map('n', '<leader>dr', '<cmd>DapContinue<CR>', { desc = '[D]ap [R]un' })
-- map('n', '<leader>tp', "<cmd>lua require('base46').toggle_transparency()<CR>", { desc = 'Toggle [T]rans[p]arency' })
map('t', '<C-z>', 'pwd | xclip -selection clipboard<CR><C-\\><C-n>:cd <C-r>+<CR>i')
map('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open file [E]xplorer' })

local builtin = require 'telescope.builtin'

-- telescope
vim.keymap.set('n', '<leader>fz', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_ivy {
    layout_config = {
      height = 10,
    },
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'telescope find buffers' })
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'telescope help page' })
map('n', '<leader>ma', '<cmd>Telescope marks<CR>', { desc = 'telescope find marks' })
map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'telescope find files' })
-- map('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = 'telescope find in current buffer' })
map('n', '<leader>cm', '<cmd>Telescope git_commits<CR>', { desc = 'telescope git commits' })
map('n', '<leader>gt', '<cmd>Telescope git_status<CR>', { desc = 'telescope git status' })
map('n', '<leader>ft', '<cmd>Telescope terms<CR>', { desc = '[F]ind [T]erminals' })
map('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
map('n', '<leader>fss', builtin.builtin, { desc = '[F]ind [S]earche[s]' })
map('n', '<leader>fw', builtin.live_grep, { desc = '[F]ind [W]ord' })
map('n', '<leader>fds', builtin.diagnostics, { desc = '[F]ind [D]iagno[s]tics' })
map('n', '<leader>fts', builtin.treesitter, { desc = '[F]ind [T]ree[S]itter' })
map('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
map('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = '[G]oto [D]efinition' })
map('n', 'gr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eferences' })
map('n', 'gI', require('telescope.builtin').lsp_implementations, { desc = '[G]oto [I]mplementation' })
-- map('n', 'gtd', require('telescope.builtin').lsp_type_definitions, { desc = '[G]oto [T]ype [D]efinition' })
map('n', '<leader>fdb', require('telescope.builtin').lsp_document_symbols, { desc = '[F]ind [D]ocument Sym[b]ols' })
map('n', '<leader>fsb', require('telescope.builtin').lsp_workspace_symbols, { desc = '[F]ind Workspace [S]ym[b]ols' })
map('n', '<leader>rd', require('telescope.builtin').resume, { desc = '[R]e[d]o search.' })
map('n', '<leader>fn', require('telescope.builtin').man_pages, { desc = '[F]ind [M]an pages.' })
map('n', '<leader>fm', function() vim.lsp.buf.format() end, { desc = '[F]or[m]at' })
-- map('n', '<leader>rn', vim.lsp.buf.rename(), { desc = '[R]e[n]ame' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })

map('n', 's', '*Ncgn', { noremap = true, silent = true, desc = '[S]ubstitute current word and prepare to replace' })

-- Quickfix list
local function quickfixerrors()
  local compile = require 'compile-mode'
  compile.send_to_qflist()
  local diag_table = vim.diagnostic.get(nil)
  local quickfix_items = vim.diagnostic.toqflist(diag_table)
  vim.fn.setqflist(quickfix_items, 'a')
  vim.cmd 'Trouble qflist toggle'
end

map('n', '<leader>mk', '<cmd>make<CR>', { desc = 'Run [M]a[k]e' })
map('n', '<leader>q', quickfixerrors, { desc = 'Open diagnostic [Q]uickfix list' })

-- Small terminal

local function smallterm()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 5)
end

map('n', '<leader>st', smallterm, { desc = 'Open [S]mall [T]erminal' })
-- map('i', 'df', '<BS>')
-- map('i', '<F1>', vim.cmd 'vsplit')
map('i', '<C-w><C-s>', '<ESC><C-w><C-s>')
map('i', '<C-w><C-v>', '<ESC><C-w><C-s>')
map('i', '<C-w><C-h>', '<ESC><C-w><C-h>')
map('i', '<C-w><C-j>', '<ESC><C-w><C-j>')
map('i', '<C-w><C-k>', '<ESC><C-w><C-k>')
map('i', '<C-w><C-l>', '<ESC><C-w><C-l>')
map('n', '<C-1>', '1<C-w><C-w>')
map('n', '<C-2>', '2<C-w><C-w>')
map('n', '<C-3>', '3<C-w><C-w>')
map('n', '<C-4>', '4<C-w><C-w>')
map('n', '<C-5>', '5<C-w><C-w>')
map('n', '<C-6>', '6<C-w><C-w>')
map('n', '<C-7>', '7<C-w><C-w>')
map('n', '<C-8>', '8<C-w><C-w>')
map('n', '<C-9>', '9<C-w><C-w>')
map('n', '<C-0>', '10<C-w><C-w>')
map('n', '<C-/>', '<C-w><C-s>')
map('n', '<C-S-/>', '<C-w><C-v>')
map('n', '<C-c>', '<C-w><C-c>')
map('n', '<leader>to', function()
  Snacks.explorer.reveal()
end, { desc = 'Nvim [T]ree [O]pen' })
map('n', '<leader>tse', function()
  pcall(vim.treesitter.start)
end, { desc = '[T]ree[S]itter [E]nable' })

-- map('n', 'm/', vim.cmd 'MarksListBuf')

vim.keymap.set({ 'n', 'v' }, 'm/', ':MarksListBuf<CR>')
-- map('i', '<c-x><c-]>', function()
--   require('blink.cmp')['show'] { providers = { 'lsp' } }
-- end, {})
-- map('i', '<c-x><c-a>', function()
--   require('blink.cmp')['show'] { providers = { 'minuet' } }
-- end, {})
-- map('i', '<c-x><c-n>', function()
--   require('blink.cmp')['show'] { providers = { 'buffer' } }
-- end, {})
-- map('i', '<c-x><c-f>', function()
--   require('blink.cmp')['show'] { providers = { 'path' } }
-- end)
--
-- map('i', '<c-x>s', function()
--   require('blink.cmp')['show'] { providers = { spell = { name = 'Spell', module = 'blink-cmp-spell' } } }
-- end)
--
-- map('i', '<c-x><c-t>', function()
--   require('blink.cmp')['show'] { providers = { thesaurus = { name = 'blink-cmp-words', module = 'blink-cmp-words.thesaurus' } } }
-- end)
--
-- map('i', '<c-x><c-k>', function()
--   require('blink.cmp')['show'] { providers = { thesaurus = { name = 'blink-cmp-words', module = 'blink-cmp-words.dictionary' } } }
-- end)
--
-- map('n', '<c-x><c-k>', ':let @+ = expand(" % ")<CR>')
map('n', '<leader>cx', ':Compile<CR>')
local compile_mode = require 'compile-mode'
map('n', '<leader>cd', compile_mode.close_buffer)


--

if vim.g.neovide then
  vim.keymap.set({ 'n', 'v' }, '<C-+>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>')
  vim.keymap.set({ 'n', 'v' }, '<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>')
  vim.keymap.set({ 'n', 'v' }, '<C-0>', ':lua vim.g.neovide_scale_factor = 1<CR>')
end

vim.keymap.set({'n', 'x', 'o'}, 'x', function() require("flash").jump() end)
vim.keymap.set({'n', 'x', 'o'}, 'X', function() require("flash").treesitter() end)
vim.keymap.set({'n', 'x', 'o'}, 'X', function() require("flash").treesitter_search() end)


vim.keymap.set('x', 'z/', '<C-\\><C-n>`</\\%V', { desc = 'Search forward within visual selection' })
vim.keymap.set('x', 'z?', '<C-\\><C-n>`>?\\%V', { desc = 'Search backward within visual selection ' })

vim.api.nvim_create_user_command('TSBufEnable', function(unused)
  pcall(vim.treesitter.start)
end, { nargs = '?' })

vim.api.nvim_create_user_command('TSBufDisable', function(unused)
  pcall(vim.treesitter.stop)
end, { nargs = '?' })


-- local ls = require("luasnip")

vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s", "n"}, "<C-l>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s", "n"}, "<C-S-l>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
if ls.choice_active() then
        ls.change_choice(1)
end
end, {silent = true})


local mc = require 'multicursor-nvim'
mc.setup()

local set = vim.keymap.set

-- Add or skip cursor above/below the main cursor.
set({ 'n', 'x' }, '<up>', function()
  mc.lineAddCursor(-1)
end)
set({ 'n', 'x' }, '<down>', function()
  mc.lineAddCursor(1)
end)
set({ 'n', 'x' }, '<leader><up>', function()
  mc.lineSkipCursor(-1)
end)
set({ 'n', 'x' }, '<leader><down>', function()
  mc.lineSkipCursor(1)
end)

-- Add or skip adding a new cursor by matching word/selection
set({ 'n', 'x' }, '<leader>n', function()
  mc.matchAddCursor(1)
end)
set({ 'n', 'x' }, '<leader>s', function()
  mc.matchSkipCursor(1)
end)
set({ 'n', 'x' }, '<leader>N', function()
  mc.matchAddCursor(-1)
end)
set({ 'n', 'x' }, '<leader>S', function()
  mc.matchSkipCursor(-1)
end)

-- Add and remove cursors with control + left click.
set('n', '<c-leftmouse>', mc.handleMouse)
set('n', '<c-leftdrag>', mc.handleMouseDrag)
set('n', '<c-leftrelease>', mc.handleMouseRelease)

-- Disable and enable cursors.
set({ 'n', 'x' }, '<c-q>', mc.toggleCursor)

-- Mappings defined in a keymap layer only apply when there are
-- multiple cursors. This lets you have overlapping mappings.
mc.addKeymapLayer(function(layerSet)
  -- Select a different cursor as the main one.
  layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
  layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

  -- Delete the main cursor.
  layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

  -- Enable and clear cursors using escape.
  layerSet('n', '<esc>', function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end)
end)
-- Pressing `gaip` will add a cursor on each line of a paragraph.
set('n', 'ga', mc.addCursorOperator)

-- Clone every cursor and disable the originals.
set({ 'n', 'x' }, '<leader><c-q>', mc.duplicateCursors)

-- Align cursor columns.
set('n', '<leader>a', mc.alignCursors)

-- Split visual selections by regex.
set('x', 'S', mc.splitCursors)

-- match new cursors within visual selections by regex.
set('x', 'M', mc.matchCursors)

-- bring back cursors if you accidentally clear them
set('n', '<leader>gv', mc.restoreCursors)

-- Add a cursor for all matches of cursor word/selection in the document.
set({ 'n', 'x' }, '<leader>A', mc.matchAllAddCursors)

-- Rotate the text contained in each visual selection between cursors.
set('x', '<leader>t', function()
  mc.transposeCursors(1)
end)
set('x', '<leader>T', function()
  mc.transposeCursors(-1)
end)

-- Append/insert for each line of visual selections.
-- Similar to block selection insertion.
set('x', 'I', mc.insertVisual)
set('x', 'A', mc.appendVisual)

-- Increment/decrement sequences, treaing all cursors as one sequence.
set({ 'n', 'x' }, 'g<c-a>', mc.sequenceIncrement)
set({ 'n', 'x' }, 'g<c-x>', mc.sequenceDecrement)

-- Add a cursor and jump to the next/previous search result.
set('n', '<leader>/n', function()
  mc.searchAddCursor(1)
end)
set('n', '<leader>/N', function()
  mc.searchAddCursor(-1)
end)

-- Jump to the next/previous search result without adding a cursor.
set('n', '<leader>/s', function()
  mc.searchSkipCursor(1)
end)
set('n', '<leader>/S', function()
  mc.searchSkipCursor(-1)
end)

-- Add a cursor to every search result in the buffer.
set('n', '<leader>/A', mc.searchAllAddCursors)

-- Pressing `<leader>miwap` will create a cursor in every match of the
-- string captured by `iw` inside range `ap`.
-- This action is highly customizable, see `:h multicursor-operator`.
set({ 'n', 'x' }, '<leader>m', mc.operator)

-- Add or skip adding a new cursor by matching diagnostics.
set({ 'n', 'x' }, ']d', function()
  mc.diagnosticAddCursor(1)
end)
set({ 'n', 'x' }, '[d', function()
  mc.diagnosticAddCursor(-1)
end)
set({ 'n', 'x' }, ']s', function()
  mc.diagnosticSkipCursor(1)
end)
set({ 'n', 'x' }, '[S', function()
  mc.diagnosticSkipCursor(-1)
end)

-- Press `mdip` to add a cursor for every error diagnostic in the range `ip`.
set({ 'n', 'x' }, 'md', function()
  -- See `:h vim.diagnostic.GetOpts`.
  mc.diagnosticMatchCursors { severity = vim.diagnostic.severity.ERROR }
end)
-- Customize how cursors look.
local hl = vim.api.nvim_set_hl
hl(0, 'MultiCursorCursor', { reverse = true })
hl(0, 'MultiCursorVisual', { link = 'Visual' })
hl(0, 'MultiCursorSign', { link = 'SignColumn' })
hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
hl(0, 'MultiCursorDisabledCursor', { reverse = true })
hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
