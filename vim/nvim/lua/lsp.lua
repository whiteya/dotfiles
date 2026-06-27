-- Set blink.cmp capabilities for all LSP servers (native 0.11+ API)
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

local servers = {
  {
    name = 'ts_ls',
    exe = 'typescript-language-server',
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
    root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  },
  {
    name = 'clangd',
    exe = 'clangd',
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
  },
  {
    name = 'rust_analyzer',
    exe = 'rust-analyzer',
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', '.git' },
  },
}

for _, server in ipairs(servers) do
  vim.lsp.config(server.name, {
    cmd = server.cmd,
    filetypes = server.filetypes,
    root_markers = server.root_markers,
  })
  if vim.fn.executable(server.exe) == 1 then
    vim.lsp.enable(server.name)
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gi', '<cmd>Trouble lsp_implementations toggle focus=true<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>Trouble lsp_references toggle focus=true<cr>', opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>f', vim.lsp.buf.format, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>qf', function()
      vim.lsp.buf.code_action({ apply = true, context = { only = { 'quickfix' } } })
    end, opts)
    vim.keymap.set('n', '[g', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
    vim.keymap.set('n', ']g', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
    vim.keymap.set('n', '<space>a', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<space>o', '<cmd>Trouble symbols toggle focus=true<cr>', opts)
    vim.keymap.set('n', '<space>s', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', opts)
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})
