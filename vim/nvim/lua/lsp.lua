-- Server definitions come from nvim-lspconfig's lsp/*.lua; blink.cmp adds its capabilities itself
vim.lsp.config('jsonls', {
  before_init = function(_, config)
    config.settings.json.schemas = require('schemastore').json.schemas()
  end,
  settings = { json = { validate = { enable = true } } },
})
vim.lsp.config('yamlls', {
  before_init = function(_, config)
    config.settings.yaml.schemas = require('schemastore').yaml.schemas()
  end,
  settings = { yaml = { schemaStore = { enable = false, url = '' } } },
})

local servers = {
  'ts_ls', 'clangd', 'rust_analyzer', 'csharp_ls', 'pyright', 'lua_ls',
  'jsonls', 'yamlls', 'html', 'cssls', 'marksman', 'bashls', 'taplo',
}

for _, name in ipairs(servers) do
  local cmd = vim.lsp.config[name].cmd
  if type(cmd) ~= 'table' or vim.fn.executable(cmd[1]) == 1 then
    vim.lsp.enable(name)
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
