local M = {}

local function ensure_provider_options()
	local ok, minuet = pcall(require, "minuet")
	if not ok or not minuet.config then
		return
	end

	minuet.config.provider_options = minuet.config.provider_options or {}
	minuet.config.provider_options.codex_acp = minuet.config.provider_options.codex_acp or {}
	minuet.config.provider_options.codex_acp.name = minuet.config.provider_options.codex_acp.name or "Codex Spark"
end

function M.is_available()
	ensure_provider_options()
	return require("minuet_codex.health").is_available()
end

function M.complete(context, callback)
	ensure_provider_options()
	require("minuet_codex").complete(context, callback)
end

return M
