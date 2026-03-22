-- https://github.com/vuejs/language-tools/wiki/Neovim
-- https://github.com/microsoft/TypeScript/wiki/Writing-a-Language-Service-Plugin
-- https://github.com/vuejs/language-tools/discussions/5931
-- https://www.reddit.com/r/neovim/comments/1kwjip4/how_to_properly_set_up_vue_3_typescript_in_neovim/
local vue_language_server_path = vim.fn.stdpath("data")
	.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local styled_plugin_path = vim.fn.system("npm root -g"):gsub("\n", "") .. "/@styled/typescript-styled-plugin"

vim.lsp.config("ts_ls", {
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			},
			{
				name = "@styled/typescript-styled-plugin",
				location = styled_plugin_path,
				languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
			},
		},
		hostInfo = "neovim",
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})
