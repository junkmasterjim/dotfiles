return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim',       opts = {} },
    { 'folke/neodev.nvim',       opts = {} },
  },

  config = function()
    local function map(keys, func, desc)
      vim.keymap.set('n', keys, func, { desc = 'LSP: ' .. desc })
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- Keymaps for LSP actions
        local lsp_map = {
          gd = require('telescope.builtin').lsp_definitions,
          gr = require('telescope.builtin').lsp_references,
          gI = require('telescope.builtin').lsp_implementations,
          ['<leader>D'] = require('telescope.builtin').lsp_type_definitions,
          ['<leader>ds'] = vim.lsp.buf.document_symbol,
          ['<leader>ws'] = vim.lsp.buf.workspace_symbol,
          ['<leader>rn'] = vim.lsp.buf.rename,
          ['<leader>ca'] = vim.lsp.buf.code_action,
          K = vim.lsp.buf.hover,
          gD = vim.lsp.buf.declaration,
        }

        -- Map each LSP action
        for keys, action in pairs(lsp_map) do
          map(keys, action, '[' .. keys .. ']')
        end

        -- Document highlight on hover
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Enable Inlay Hints if supported by the LSP
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Auto-format on save for all LSP clients
    vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

    -- Extend LSP capabilities with completion support
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Define LSP server settings
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      gopls = {
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      },
    }

    -- Setup Mason
    require('mason').setup()

    -- Install LSPs and tools with Mason Tool Installer
    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, {
      'stylua',  -- Formatter for Lua
      'gopls',   -- Go language server
      'gofumpt', -- Go formatter
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Setup mason-lspconfig
    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
