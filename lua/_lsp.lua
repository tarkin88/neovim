-- load packages
vim.cmd('packadd nvim-lspconfig')
vim.cmd('packadd completion-nvim')
vim.cmd('packadd diagnostic-nvim')
vim.cmd('packadd nlua.nvim')

local lsp = require'nvim_lsp'
local utils = require'utils'

local on_attach = function(client)
	require'diagnostic'.on_attach(client)
  -- require'completion'.on_attach(client)

	local map_opts = { noremap=true, silent=true }
	utils.map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', map_opts)
	utils.map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', map_opts)
	utils.map('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', map_opts)
	utils.map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', map_opts)
	utils.map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', map_opts)
	utils.map('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', map_opts)
	utils.map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', map_opts)
	utils.map('n', '<leader>ld', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', map_opts)
end

require('nlua.lsp.nvim').setup(lsp, {
	on_attach = on_attach
})

local servers = {
  {name = 'bashls'},
  {name = 'vimls'},
  {name = 'tsserver'},
  {name = 'jsonls'},
  {name = 'rust_analyzer'},
  {name = 'vuels'},
	{
		name = 'html',
		config = {
			filetypes = { "html", "jinja" }
		}
	},
	{
		name = 'sumneko_lua',
		config = {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = vim.split(package.path, ';'),
					},
					completion = {
						keywordSnippet = "Disable",
					},
					diagnostics = {
						enable = true,
						globals = {"vim"}
					},
				}
			},
		}
	}
  -- {name = 'cssls'},
}

for _, server in ipairs(servers) do
	local config = server.config or {}
	config.on_attach = on_attach
  lsp[server.name].setup(config)
end