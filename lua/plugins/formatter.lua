return {
	{

		"mhartington/formatter.nvim",
		config = function()
			local prettierd = require("formatter.defaults.prettierd")
			local rustywind = function()
				return {
					exe = "rustywind",
					args = {
						"--stdin",
					},
					stdin = true,
				}
			end

			require("formatter").setup({
				logging = false,
				filetype = {
					css = {
						prettierd,
					},
					go = {
						require("formatter.filetypes.go").gofmt,
					},
					html = {
						prettierd,
						rustywind,
					},
					javascript = {
						prettierd,
						rustywind,
					},
					json = {
						prettierd,
					},
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					markdown = {
						prettierd,
					},
					rust = {
						require("formatter.filetypes.rust").rustfmt,
					},
					scss = {
						prettierd,
					},
					sh = {
						require("formatter.filetypes.sh").shfmt,
					},
					svelte = {
						prettierd,
						rustywind,
					},
					typescript = {
						prettierd,
						rustywind,
					},
					yaml = {
						prettierd,
					},
					["*"] = {
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})

			local augroup = vim.api.nvim_create_augroup("FormatAutogroup", {})
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = augroup,
				command = "FormatWrite",
			})
		end,
	},
}
