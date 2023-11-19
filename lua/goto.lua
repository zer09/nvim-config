local function goto_definition()
	local util = vim.lsp.util
	local log = require("vim.lsp.log")
	local api = vim.api

	local handler = function(_, result, ctx)
		if result == nil or vim.tbl_isempty(result) then
			local _ = log.info() and log.info(ctx.method, "No location found")
			return nil
		end

		if result[1].uri ~= ctx.params.textDocument.uri and vim.fn.winwidth(0) >= 80 then
			vim.cmd("vsplit")
		end

		util.jump_to_location(result[1], "utf-8")

		if #result > 1 then
			util.set_qflist(util.locations_to_items(result))
			api.nvim_command("copen")
			api.nvim_command("wincmd p")
		end
	end

	return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition()
