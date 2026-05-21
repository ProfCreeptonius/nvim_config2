vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig'
})

vim.lsp.config['clangd'] = {
  cmd = {
    'clangd21',
    '--background-index',
    '-j=32',
    '--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++',
    '--clang-tidy',
    '--clang-tidy-checks=*',
    '--all-scopes-completion',
    '--cross-file-rename',
    '--completion-style=detailed',
    '--header-insertion-decorators',
    '--header-insertion=iwyu',
    '--pch-storage=memory',
  },
  filetypes = { 'c', 'cpp', 'h', 'hpp'},
  root_markers = { "cmakelists.txt" }
}

vim.lsp.enable('clangd')

vim.lsp.enable('denols')

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
    src = 'https://github.com/JavaHello/spring-boot.nvim',
    version = '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0',
  },
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/nvim-java/nvim-java',
  'https://github.com/seblyng/roslyn.nvim',
})

require('java').setup()
vim.lsp.enable('jdtls')

vim.lsp.enable('ts_ls')
vim.lsp.enable('texlab')

