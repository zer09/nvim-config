local function goto_definition(split_cmd)
	local util = vim.lsp.util
	local log = require("vim.lsp.log")
	local api = vim.api

	-- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
	local handler = function(_, result, ctx)
		if result == nil or vim.tbl_isempty(result) then
			local _ = log.info() and log.info(ctx.method, "No location found")
			return nil
		end

		local wc = 0
		local windows = vim.api.nvim_tabpage_list_wins(0)

		for _, v in pairs(windows) do
			local cfg = vim.api.nvim_win_get_config(v)
			local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(v), "filetype")

			if (cfg.relative == "" or cfg.external == false) and ft ~= "qf" then
				wc = wc + 1
			end
		end

		if result[1].uri ~= ctx.params.textDocument.uri and wc < 3 then
			vim.cmd(split_cmd)
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

vim.lsp.handlers["textDocument/definition"] = goto_definition("vsplit")
