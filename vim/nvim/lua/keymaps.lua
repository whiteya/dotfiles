vim.keymap.set('i', 'kj', '<esc>')
vim.keymap.set('v', '//', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>')
vim.keymap.set('n', '<space>', 'i_<esc>r')
vim.keymap.set({ 'n', 'v' }, '<up>', 'g<up>')
vim.keymap.set({ 'n', 'v' }, '<down>', 'g<down>')
vim.keymap.set('n', 'g=', 'gg=G``')

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  callback = function() vim.cmd('silent! update') end,
})

-- Terminal
vim.keymap.set('t', 'kj', '<C-\\><C-n>')
vim.keymap.set('t', '<C-W>', '<C-\\><C-n><C-W>')
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})
