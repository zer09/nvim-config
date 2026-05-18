local M = {}

local function current_file_name()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		return "[No Name]"
	end
	return vim.fn.fnamemodify(name, ":~:.")
end

function M.build(context, opts)
	opts = opts or {}
	local separator = opts.completion_separator or "<endCompletion>"
	local max_completions = opts.max_completions or 3
	local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "text"
	local before = context and context.lines_before or ""
	local after = context and context.lines_after or ""

	return table.concat({
		"You are a code completion engine. Complete code at the cursor.",
		"",
		"Rules:",
		"- Return only completion text.",
		"- Do not explain.",
		"- Do not use markdown fences.",
		"- Do not repeat text that already appears before the cursor.",
		"- Do not include text that appears after the cursor unless needed for syntax.",
		"- Preserve indentation.",
		("- Provide at most %d candidates."):format(max_completions),
		("- Separate candidates with %s."):format(separator),
		"",
		("File: %s"):format(current_file_name()),
		("Filetype: %s"):format(filetype),
		"",
		"<contextBeforeCursor>",
		before,
		"</contextBeforeCursor>",
		"",
		"<contextAfterCursor>",
		after,
		"</contextAfterCursor>",
		"",
		"Return completions now.",
	}, "\n")
end

return M
