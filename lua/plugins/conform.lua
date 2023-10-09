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
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			css = { "prettierd" },
			dart = { "dart_format" },
			go = { "goimports" },
			html = { "prettierd" },
			javascript = { "prettierd" },
			json = { "prettierd" },
			lua = { "stylua" },
			markdown = { "prettierd" },
			proto = { "clang_format" },
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
				if err and err:match("timeout%") then
					slow_format_filetypes[vim.bo[bufnr].filetype] = true
				end
			end

			return { timeout = 200, lsp_fallback = true }, on_format
		end,
		format_after_save = function(bufnr)
			if not slow_format_filetypes[vim.bo[bufnr].filetype] then
				return
			end

			return { lsp_fallback = true }
		end,
	},
}
