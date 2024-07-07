vim.diagnostic.config({
	virtual_text = false,
})

local iconKinds = require("helper").icons.kinds
local navbuddyexclude = { tailwindcss = true, eslint = true, angularls = true }
local function tableHaskey(table, Key)
	return table[Key] ~= nil
end

local on_attach = function(client, bufnr)
	client.server_capabilities.document_formatting = false
	client.server_capabilities.document_range_formatting = false

	local opts = { buffer = bufnr }
	local nnoremap = require("helper").nnoremap

	nnoremap("gp", "<CMD>lua vim.diagnostic.goto_prev()<CR>")
	nnoremap("gn", "<CMD>lua vim.diagnostic.goto_next()<CR>")
	nnoremap("gd", "<CMD>lua vim.lsp.buf.definition()<CR>", opts)
	nnoremap("gi", "<CMD>lua vim.lsp.buf.implementation()<CR>", opts)
	nnoremap("gr", "<CMD>lua vim.lsp.buf.references()<CR>", opts)

	nnoremap("K", "<CMD>lua vim.lsp.buf.hover()<CR>", opts)
	nnoremap("<C-k>", "<CMD>lua vim.lsp.buf.signature_help()<CR>", opts)
	nnoremap("<Leader>wl", "<CMD>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)

	nnoremap("<Leader>rn", "<CMD>lua vim.lsp.buf.rename()<CR>", opts)
	nnoremap("<Leader>ca", "<CMD>lua vim.lsp.buf.code_action()<CR>", opts)

	-- disable diagnostic on current buffer
	nnoremap("gq", "<CMD>lua vim.diagnostic.disable(0)<CR>", opts)

	if tableHaskey(navbuddyexclude, client.config.name) ~= true then
		local navbuddy = require("nvim-navbuddy")
		navbuddy.attach(client, bufnr)
	end
end

return {
	-- {
	-- 	"folke/neodev.nvim",
	-- 	version = false,
	-- 	event = "VeryLazy",
	-- 	opts = {},
	-- 	dependencies = { "hrsh7th/nvim-cmp" },
	-- },
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- vim.env.LAZY .. "/luvit-meta/library",
				vim.env.VIMRUNTIME,
				"${3rd}/luv/library",
			},
		},
		dependencies = {
			"Bilal2453/luvit-meta",
			lazy = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{
				"b0o/SchemaStore.nvim",
				version = false,
				lazy = true,
			},
			{
				-- "williamboman/mason.nvim",
				dir = "/home/gc/devtools/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
					registries = {
						"file:/home/gc/devtools/mason-registry",
						-- "github:mason-org/mason-registry",
					},
				},
			},
			{
				"williamboman/mason-lspconfig.nvim",
				opts = {
					ensure_installed = {
						"angularls@17.3.2",
						"bashls",
						"bufls",
						"cssls",
						"eslint",
						"gopls",
						"html",
						"jsonls",
						"lua_ls",
						"rust_analyzer",
						"svelte",
						"tailwindcss",
						"yamlls",
					},
				},
			},
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = {
					lsp = { auto_attach = true },
					icons = {
						File = iconKinds.File,
						Module = iconKinds.Module,
						Namespace = iconKinds.Namespace,
						Package = iconKinds.Package,
						Class = iconKinds.Class,
						Method = iconKinds.Method,
						Property = iconKinds.Property,
						Field = iconKinds.Field,
						Constructor = iconKinds.Constructor,
						Enum = iconKinds.Enum,
						Interface = iconKinds.Interface,
						Function = iconKinds.Function,
						Variable = iconKinds.Variable,
						Constant = iconKinds.Constant,
						String = iconKinds.String,
						Number = iconKinds.Number,
						Boolean = iconKinds.Boolean,
						Array = iconKinds.Array,
						Object = iconKinds.Object,
						Key = iconKinds.Key,
						Null = iconKinds.Null,
						EnumMember = iconKinds.EnumMember,
						Struct = iconKinds.Struct,
						Event = iconKinds.Event,
						Operator = iconKinds.Operator,
						TypeParameter = iconKinds.TypeParameter,
					},
				},
				init = function()
					require("helper").nnoremap("<Leader>oo", "<CMD>Navbuddy<CR>")
				end,
			},
		},
		config = function()
			local lsp = require("lspconfig")

			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					lsp[server_name].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				-- ["lua_ls"] = function()
				-- 	require("neodev").setup({})
				--
				-- 	lsp.lua_ls.setup({
				-- 		on_attach = on_attach,
				-- 		capabilities = capabilities,
				-- 		settings = {
				-- 			Lua = {
				-- 				runtime = {
				-- 					version = "LuaJIT",
				-- 				},
				-- 				workspace = {
				-- 					checkThirdParty = false,
				-- 					library = {
				-- 						vim.env.VIMRUNTIME,
				-- 						"${3rd}/luv/library",
				-- 						"${3rd}/busted/library",
				-- 					},
				-- 				},
				-- 				completion = {
				-- 					callSnippet = "Replace",
				-- 				},
				-- 			},
				-- 		},
				-- 	})
				-- end,
				["jsonls"] = function()
					lsp.jsonls.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						},
					})
				end,
				["yamlls"] = function()
					lsp.yamlls.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							yaml = {
								schemaStore = {
									enable = false,
									url = "",
								},
								schemas = require("schemastore").yaml.schemas(),
								validate = { enable = true },
							},
						},
					})
				end,
			})

			for name, icon in pairs(require("helper").icons.diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
		end,
	},
	{
		"akinsho/flutter-tools.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			require("flutter-tools").setup({
				lsp = {
					on_attach = on_attach,
					capabilities = capabilities,
				},
			})
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {},
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			require("typescript-tools").setup({
				on_attach = function(client, bufnr)
					local opts = { buffer = bufnr }
					local nnoremap = require("helper").nnoremap

					nnoremap("gld", "<CMD>TSToolsGoToSourceDefinition<CR>", opts)
					nnoremap("glf", "<CMD>TSToolsFixAll<CR>", opts)
					nnoremap("gli", "<CMD>TSToolsAddMissingImports<CR>", opts)
					nnoremap("glo", "<CMD>TSToolsOrganizeImports<CR>", opts)

					on_attach(client, bufnr)
				end,
				capabilities = capabilities,
				settings = {
					expose_as_code_action = "all",
					complete_function_calls = true,
				},
			})
		end,
	},
}
