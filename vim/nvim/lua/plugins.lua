require('lazy').setup({
  {
    'nvim-telescope/telescope.nvim',
    commit = '427b576c16792edad01a92b89721d923c19ad60f',
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
    dependencies = {
      { 'giuxtaposition/blink-cmp-copilot', commit = '439cff78780c033aa23cf061d7315314b347e3c1' },
    },
    opts = {
      keymap = { preset = 'super-tab' },
      appearance = { nerd_font_variant = 'mono' },
      sources = {
        default = { 'copilot', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 100,
            async = true,
          },
        },
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
    -- Optional; disabled by default. Enable at install time:
    --   ./install.sh copilot
    enabled = vim.uv.fs_stat(vim.fn.stdpath('config') .. '/copilot.enabled') ~= nil,
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      -- Inline suggestions disabled; Copilot is surfaced through blink.cmp
      -- (blink-cmp-copilot) and accepted via <Tab>.
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  { 'tpope/vim-sleuth', commit = 'be69bff86754b1aa5adcbb527d7fcd1635a84080' },

  {
    'akinsho/bufferline.nvim',
    commit = '655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = {
      options = {
        diagnostics = 'nvim_lsp',
        separator_style = 'slant',
        indicator = { style = 'underline' },
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
    keys = {
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
      { '<leader>bd', '<cmd>bdelete<cr>', desc = 'Delete buffer' },
      { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = 'Pin buffer' },
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    commit = '221ce6b2d999187044529f49da6554a92f740a96',
    opts = {
      options = {
        theme = 'auto',
        globalstatus = true,
      },
      sections = {
        lualine_b = { 'branch', 'diff', 'diagnostics' },
      },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    commit = '2038c666bd9d8a0b7349a0b6ee00dc83104b9ecf',
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
