local M = {}

local function strip_code_fence(text)
	text = text:gsub("^%s*```[%w_%-%+%.]*\r?\n", "")
	text = text:gsub("\r?\n```%s*$", "")
	return text
end

local function trim_blank_lines(text)
	text = text:gsub("^\r?\n+", "")
	text = text:gsub("\r?\n+$", "")
	return text
end

local function normalize_candidate(text)
	text = text or ""
	text = text:gsub("\r\n", "\n")
	text = strip_code_fence(text)
	text = text:gsub("^%s*[Cc]ompletion:%s*", "")
	text = trim_blank_lines(text)
	return text
end

function M.parse(text, opts)
	opts = opts or {}
	local separator = opts.separator or "<endCompletion>"
	local max_items = opts.max_items or 3
	local items = {}
	local seen = {}

	text = normalize_candidate(text or "")
	if text == "" then
		return items
	end

	local parts
	if text:find(separator, 1, true) then
		parts = vim.split(text, separator, { plain = true })
	else
		parts = { text }
	end

	for _, part in ipairs(parts) do
		local item = normalize_candidate(part)
		if item ~= "" and not seen[item] then
			seen[item] = true
			table.insert(items, item)
		end
		if #items >= max_items then
			break
		end
	end

	return items
end

return M
