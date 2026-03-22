-- https://github.com/nvim-telescope/telescope.nvim/issues/3328#issuecomment-2472420006
local filterDuplicates = function(array)
	local uniqueArray = {}
	for _, tableA in ipairs(array) do
		local isDuplicate = false
		for _, tableB in ipairs(uniqueArray) do
			if vim.deep_equal(tableA, tableB) then
				isDuplicate = true
				break
			end
		end
		if not isDuplicate then
			table.insert(uniqueArray, tableA)
		end
	end
	return uniqueArray
end

local on_list = function(options)
	options.items = filterDuplicates(options.items)
	vim.fn.setqflist({}, " ", options)
	vim.cmd("botright copen")
end

-- vim.keymap.set("n", "gr", function()
-- 	vim.lsp.buf.references(nil, { on_list = on_list })
-- end, { noremap = true })
