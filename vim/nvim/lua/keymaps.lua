vim.keymap.set('i', 'kj', '<esc>')
vim.keymap.set('v', '//', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>')
vim.keymap.set('n', '<space>', 'i_<esc>r')
vim.keymap.set({ 'n', 'v' }, '<up>', 'g<up>')
vim.keymap.set({ 'n', 'v' }, '<down>', 'g<down>')
vim.keymap.set('n', 'g=', 'gg=G``')

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  callback = function() vim.cmd('silent! update') end,
})

-- Reload files changed on disk (autoread only re-reads when nvim checks)
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  callback = function()
    if vim.fn.mode() ~= 'c' then vim.cmd('silent! checktime') end
  end,
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
