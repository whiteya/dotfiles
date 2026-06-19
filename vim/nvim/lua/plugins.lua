require('lazy').setup({
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<C-p>', '<cmd>Telescope find_files<cr>' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>' },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { 'node_modules', '%.swp', '%.zip', '%.exe' },
      },
    },
  },

  {
    'saghen/blink.cmp',
    version = '*',
    lazy = false,
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      signature = { enabled = true },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local ok, configs = pcall(require, 'nvim-treesitter.configs')
      if not ok then return end
      configs.setup({
        ensure_installed = { 'typescript', 'tsx', 'javascript', 'c', 'cpp', 'rust', 'lua', 'vim', 'vimdoc' },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<M-l>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = false },
    },
  },

  { 'tpope/vim-sleuth' },

  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        theme = 'auto',
        globalstatus = true,
      },
      sections = {
        lualine_b = { 'branch', 'diff', 'diagnostics' },
      },
      tabline = {
        lualine_a = { 'buffers' },
        lualine_z = { 'tabs' },
      },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 700,
        virt_text_pos = 'eol',
      },
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Hunk navigation
        map('n', ']c', function() gs.nav_hunk('next') end, 'Next git hunk')
        map('n', '[c', function() gs.nav_hunk('prev') end, 'Previous git hunk')

        -- Hunk actions
        map({ 'n', 'v' }, '<leader>hs', gs.stage_hunk, 'Stage hunk')
        map({ 'n', 'v' }, '<leader>hr', gs.reset_hunk, 'Reset hunk')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
        map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
        map('n', '<leader>hd', gs.diffthis, 'Diff against index')

        -- Toggles
        map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle line blame')
      end,
    },
  },
})
