
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    -- { import = "plugins" },
		{
  		"folke/tokyonight.nvim",
  		lazy = false,      -- load immediately
  		priority = 1000,   -- load before other UI plugins
		},
		{ 
			"ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...
		},
		{
    		'nvim-telescope/telescope.nvim', version = '*',
    		dependencies = {
    		    'nvim-lua/plenary.nvim',
    		    -- optional but recommended
    		    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    		}
		},
		{
		  "williamboman/mason.nvim",
		  -- Configure mason to include the Roslyn registrysilent = true
		  config = function()
		    require("mason").setup({
		      registries = {
		        "github:Crashdummyy/mason-registry", -- Contains the Roslyn register
		        "github:mason-org/mason-registry",
		      },
		    })
		  end
		},
		{ "williamboman/mason-lspconfig.nvim" },
		-- { "neovim/nvim-lspconfig" },
		-- {
		--   "seblyng/roslyn.nvim",
		--   enabled = true,
		--   ft = "cs", -- Enable only for C# file types
		--   config = function()
		--     -- Optional: basic on_attach function
		--     vim.lsp.config("roslyn", {
		--       on_attach = function(client, bufnr)
		--         -- set up keymaps, etc. here
		--       end,
		--     })
		--   end,
		-- },
		{ -- Main LSP Configuration
        'neovim/nvim-lspconfig',
        dependencies = {
          { 'williamboman/mason.nvim', config = true }, -- Automatically install LSPs and related tools to stdpath for Neovim
          'williamboman/mason-lspconfig.nvim',
          'WhoIsSethDaniel/mason-tool-installer.nvim',
          { 'j-hui/fidget.nvim', opts = {} },
          'hrsh7th/cmp-nvim-lsp',
          'Hoffs/omnisharp-extended-lsp.nvim',
        },
        config = function()
          vim.api.nvim_create_autocmd('LspAttach', { -- This function gets run when an LSP attaches to a particular buffer
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
              local map = function(keys, func, desc, mode) -- Sets the mode, buffer and description for us each time
                mode = mode or 'n'
                vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
              end

              local client = vim.lsp.get_client_by_id(event.data.client_id)
              if client and client.name == 'omnisharp' then
                map('gd', ":lua require('omnisharp_extended').lsp_definition()<cr>", '[G]oto [D]efinition Omnisharp')
                map('gr', ":lua require('omnisharp_extended').telescope_lsp_references()<cr>", '[G]oto [R]eferences Omnisharp')
              else
                map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition') -- To jump back, press <C-t>
                map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences') -- Find references for the word under your cursor
              end

              map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation') -- Jump to the implementation of the word under your cursor
              map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition') -- Jump to the type of the word under your cursor
              map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols') -- Fuzzy find all the symbols in your current document
              map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols') -- Fuzzy find all the symbols in your current workspace
              map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame') -- Rename the variable under your cursor
              map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' }) -- Execute a code action, usually your cursor needs to be on top of an error or a suggestion
              map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration') -- This is not Goto Definition, this is Goto Declaration

              if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

                vim.api.nvim_create_autocmd('LspDetach', {
                  group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                  callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                  end,
                })
              end

              if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then -- Toggle inlay hints in your code
                map('<leader>th', function()
                  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                end, '[T]oggle Inlay [H]ints')
              end
            end,
          })

          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
          local servers = {
            -- pyright = {},
            omnisharp = {},
            -- jsonls = {},
            -- ts_ls = {},
            lua_ls = {
              settings = {
                Lua = {
                  completion = {
                    callSnippet = 'Replace',
                  },
                },
              },
            },
          }

          require('mason').setup()

          local ensure_installed = vim.tbl_keys(servers or {})
          vim.list_extend(ensure_installed, { -- You can add other tools here that you want Mason to install for you, so that they are available from within Neovim
            'stylua',
            'csharpier',
          })
          require('mason-tool-installer').setup { ensure_installed = ensure_installed }

          require('mason-lspconfig').setup {
            handlers = {
              function(server_name)
                local server = servers[server_name] or {}
                server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                require('lspconfig')[server_name].setup(server)
              end,
            },
          }
        end,
  		},
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
