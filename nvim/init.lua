-- Tecla líder (Espaço)
vim.g.mapleader = ' '

-- 1. Instalação do Gerenciador de Plugins (Lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Lista de Plugins
require("lazy").setup({
  -- Mason: O instalador de ferramentas (A "Loja")
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function() require("mason").setup() end
  },
  
  -- Ponte entre Mason e o LSP
  "williamboman/mason-lspconfig.nvim",
  
  -- Configuração do LSP (O cérebro)
  "neovim/nvim-lspconfig",

  -- Autocomplete (O menu flutuante)
  {
    "hrsh7th/nvim-cmp",
    dependencies = { 
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip", -- Snippets são importantes para Java
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        })
      })
    end
  },
  
  -- Cores (Tokyonight)
  {
    "folke/tokyonight.nvim",
    config = function() vim.cmd.colorscheme("tokyonight-night") end
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- Dependências opcionais mas recomendadas
    opts = {}, -- Carrega a configuração padrão (que já é ótima)
}
})

-- 3. Configuração Automática do Java via Mason
-- Isso garante que o JDTLS (Java) seja conectado assim que instalado
require("mason-lspconfig").setup({
  ensure_installed = { "jdtls" }, -- Instala Java automaticamente se não tiver
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup {}
    end,
  }
})

-- Isso esconde os caracteres de formatação (**negrito**, `código`, etc.)
-- O Obsidian faz isso por padrão (Live Preview)
vim.opt.conceallevel = 2


-- Configurações Visuais Básicas
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

