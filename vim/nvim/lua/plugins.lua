require('lazy').setup({
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      integrations = {
        telescope = true,
        which_key = true,
        gitsigns = true,
        neotree = true,
        lsp_trouble = true,
        blink_cmp = true,
        lualine = true,
        treesitter = true,
        native_lsp = { enabled = true },
      },
    },
  },

  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'folke/trouble.nvim' },
    keys = {
      { '<C-p>', '<cmd>Telescope find_files<cr>' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>' },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { 'node_modules', '%.swp', '%.zip', '%.exe', '%.git/' },
        mappings = {
          i = { ['<c-t>'] = function(...) return require('trouble.sources.telescope').open(...) end },
          n = { ['<c-t>'] = function(...) return require('trouble.sources.telescope').open(...) end },
        },
      },
      pickers = {
        find_files = { hidden = true },
        live_grep = { additional_args = { '--hidden' } },
      },
    },
  },

  {
    'saghen/blink.cmp',
    version = '*',
    lazy = false,
    dependencies = (function()
      local deps = {}
      if vim.uv.fs_stat(vim.fn.stdpath('config') .. '/copilot.enabled') then
        table.insert(deps, 'giuxtaposition/blink-cmp-copilot')
      end
      return deps
    end)(),
    opts = function()
      local copilot_enabled = vim.uv.fs_stat(vim.fn.stdpath('config') .. '/copilot.enabled') ~= nil
      local default = copilot_enabled
        and { 'copilot', 'lsp', 'path', 'snippets', 'buffer' }
        or { 'lsp', 'path', 'snippets', 'buffer' }
      return {
        keymap = { preset = 'super-tab' },
        appearance = { nerd_font_variant = 'mono' },
        sources = {
          default = default,
          per_filetype = { lua = { inherit_defaults = true, 'lazydev' } },
          providers = {
            lazydev = {
              name = 'LazyDev',
              module = 'lazydev.integrations.blink',
              score_offset = 100,
            },
            copilot = {
              name = 'copilot',
              module = 'blink-cmp-copilot',
              score_offset = 100,
              async = true,
            },
          },
        },
        signature = { enabled = true },
      }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- Parser installs need the tree-sitter CLI; nvim bundles c, lua, vim, vimdoc, markdown and query
      if vim.fn.executable('tree-sitter') == 1 then
        require('nvim-treesitter').install({
          'typescript', 'tsx', 'javascript', 'c', 'cpp', 'rust', 'python', 'c_sharp', 'lua', 'vim', 'vimdoc',
          'json', 'yaml', 'html', 'css', 'markdown', 'markdown_inline', 'bash', 'toml',
        })
      end
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    'mason-org/mason.nvim',
    lazy = false,
    priority = 900,
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    cmd = { 'MasonToolsInstall', 'MasonToolsInstallSync', 'MasonToolsUpdate', 'MasonToolsUpdateSync', 'MasonToolsClean' },
    opts = function()
      local tools = {
        'typescript-language-server', 'clangd', 'rust-analyzer', 'pyright', 'lua-language-server',
        'json-lsp', 'yaml-language-server', 'html-lsp', 'css-lsp', 'marksman', 'bash-language-server', 'taplo',
        'prettier', 'stylua', 'ruff', 'clang-format', 'shfmt', 'shellcheck', 'tree-sitter-cli',
      }
      if vim.fn.executable('dotnet') == 1 then
        vim.list_extend(tools, { 'csharp-language-server', 'csharpier' })
      end
      -- Installed by vim/install.sh or :MasonToolsInstall rather than on every startup
      return { ensure_installed = tools, run_on_start = false }
    end,
  },

  { 'neovim/nvim-lspconfig', lazy = false },
  { 'b0o/SchemaStore.nvim', lazy = true },
  { 'folke/lazydev.nvim', ft = 'lua', opts = {} },

  {
    'stevearc/conform.nvim',
    cmd = 'ConformInfo',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        markdown = { 'prettier' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        rust = { 'rustfmt' },
        cs = { 'csharpier' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        toml = { 'taplo' },
      },
      default_format_opts = { lsp_format = 'fallback' },
    },
    keys = {
      {
        '<leader>=',
        function()
          local hunks = require('gitsigns').get_hunks()
          if not hunks or #hunks == 0 then
            vim.notify('No changed lines to format')
            return
          end
          -- Bottom-up so formatting a hunk doesn't shift the ones above it
          for i = #hunks, 1, -1 do
            local added = hunks[i].added
            if added.count > 0 then
              local last = added.start + added.count - 1
              local len = #vim.api.nvim_buf_get_lines(0, last - 1, last, true)[1]
              require('conform').format({ range = { start = { added.start, 0 }, ['end'] = { last, len } } })
            end
          end
        end,
        desc = 'Format changed lines',
      },
      { '<leader>=', function() require('conform').format() end, mode = 'v', desc = 'Format selection' },
    },
  },

  {
    'NeogitOrg/neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    cmd = 'Neogit',
    opts = {},
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit' },
    },
  },

  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
  { 'kylechui/nvim-surround', event = 'VeryLazy', opts = {} },

  {
    'zbirenbaum/copilot.lua',
    -- Optional; disabled by default. Enable at install time:
    --   ./install.sh copilot
    enabled = vim.uv.fs_stat(vim.fn.stdpath('config') .. '/copilot.enabled') ~= nil,
    dependencies = { 'copilotlsp-nvim/copilot-lsp' },
    cmd = 'Copilot',
    event = 'InsertEnter',
    init = function()
      vim.g.copilot_nes_debounce = 500
    end,
    opts = {
      -- Inline suggestions disabled; Copilot is surfaced through blink.cmp
      -- (blink-cmp-copilot) and accepted via <Tab>.
      suggestion = { enabled = false },
      panel = { enabled = false },
      -- Next Edit Suggestions (NES) via copilot-lsp.
      nes = {
        enabled = true,
        keymap = {
          accept_and_goto = '<leader>p',
          accept = false,
          dismiss = '<Esc>',
        },
      },
    },
  },

  'tpope/vim-sleuth',

  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = {
      options = {
        diagnostics = 'nvim_lsp',
        separator_style = 'thin',
        show_buffer_close_icons = false,
        show_close_icon = false,
        offsets = {
          {
            filetype = 'neo-tree',
            text = '',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
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
    dependencies = { 'folke/trouble.nvim' },
    opts = function(_, opts)
      opts.options = { theme = 'auto', globalstatus = true }
      opts.sections = {
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
      }
      local symbols = require('trouble').statusline({
        mode = 'symbols',
        groups = {},
        title = false,
        filter = { range = true },
        format = '{kind_icon}{symbol.name:Normal}',
        hl_group = 'lualine_c_normal',
      })
      table.insert(opts.sections.lualine_c, { symbols.get, cond = symbols.has })
    end,
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

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        '<leader>?',
        function() require('which-key').show({ global = false }) end,
        desc = 'Buffer local keymaps',
      },
    },
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
    keys = {
      { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'Toggle file explorer' },
    },
  },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'Trouble',
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer diagnostics (Trouble)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix (Trouble)' },
      { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location list (Trouble)' },
    },
  },
})

-- colors/matugen.lua is generated per-machine by matugen from the wallpaper
-- and is not tracked; fall back to catppuccin where it doesn't exist.
if not pcall(vim.cmd.colorscheme, 'matugen') then
  vim.cmd('colorscheme catppuccin')
  vim.api.nvim_set_hl(0, 'LineNr', { ctermfg = 'darkgrey', fg = '#606060' })
end
