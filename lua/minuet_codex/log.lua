local M = {}

local levels = {
	debug = 10,
	info = 20,
	warn = 30,
	error = 40,
}

local function cfg()
	return require("minuet_codex.config").get()
end

local function redact(value)
	local text = tostring(value or "")
	text = text:gsub("Bearer%s+[%w%._%-]+", "Bearer [REDACTED]")
	text = text:gsub('("access_token"%s*:%s*")[^"]+', '%1[REDACTED]')
	text = text:gsub('("refresh_token"%s*:%s*")[^"]+', '%1[REDACTED]')
	text = text:gsub('([Kk][Ee][Yy]"?%s*[:=]%s*")[^"]+', '%1[REDACTED]')
	text = text:gsub('([Tt][Oo][Kk][Ee][Nn]"?%s*[:=]%s*")[^"]+', '%1[REDACTED]')
	text = text:gsub(vim.pesc(vim.fn.expand("~")), "~")
	return text
end

local function should_log(level)
	local config = cfg()
	if config.log_enabled == false then
		return false
	end
	local configured = config.log_level or "info"
	return (levels[level] or levels.info) >= (levels[configured] or levels.info)
end

function M.path()
	local config = cfg()
	return config.log_file or vim.fs.joinpath(vim.fn.stdpath("state"), "minuet-codex.log")
end

function M.write(level, message, data)
	level = level or "info"
	if not should_log(level) then
		return
	end

	local file = M.path()
	local dir = vim.fn.fnamemodify(file, ":h")
	vim.fn.mkdir(dir, "p")

	local line = ("%s %-5s %s"):format(os.date("%Y-%m-%dT%H:%M:%S"), level:upper(), redact(message))
	if data ~= nil then
		local ok, encoded = pcall(vim.json.encode, data)
		if ok then
			line = line .. " " .. redact(encoded)
		else
			line = line .. " " .. redact(data)
		end
	end

	pcall(vim.fn.writefile, { line }, file, "a")
end

function M.clear()
	pcall(vim.fn.writefile, {}, M.path())
end

function M.redact(value)
	return redact(value)
end

return M
