local slow_format_filetypes = {}

return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<Leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			css = { "prettierd" },
			dart = { "dart_format" },
			go = { "goimports-reviser", prepend_args = { "-rm-unused", "-set-alias" } },
			html = { "prettierd" },
			javascript = { "prettierd" },
			json = { "prettierd" },
			lua = { "stylua" },
			markdown = { "prettierd" },
			proto = { "clang-format" },
			rust = { "rustfmt" },
			scss = { "prettierd" },
			sh = { "shfmt" },
			svelte = { "prettierd" },
			typescript = { "prettierd" },
			yaml = { "prettierd" },
			["*"] = { "trim_whitespace" },
			["_"] = { "trim_whitespace" },
		},
		format_on_save = function(bufnr)
			if slow_format_filetypes[vim.bo[bufnr].filetype] then
				return
			end

			local function on_format(err)
				if err and err:match("timeout$") then
					slow_format_filetypes[vim.bo[bufnr].filetype] = true
				end
			end

			return { timeout = 200, lsp_format = "fallback" }, on_format
		end,
		format_after_save = function(bufnr)
			if not slow_format_filetypes[vim.bo[bufnr].filetype] then
				return
			end

			return { lsp_format = "fallback" }
		end,
	},
}
