vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/NvChad/ui',
  'https://github.com/NvChad/base46'
})

require('nvchad')


-- put this in your main init.lua file ( before lazy setup )
 vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46_cache/"

-- put this after lazy setup 
-- -- (method 1, For heavy lazyloaders)
--  dofile(vim.g.base46_cache .. "defaults")
--  dofile(vim.g.base46_cache .. "statusline")

-- (method 2, for non lazyloaders) to load all highlights at once
 for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
   dofile(vim.g.base46_cache .. v)
 end
require('base46').load_all_highlights()

