require("nvim-autopairs").setup({
	check_ts = true,
	-- Don't add pairs if it already has a close pair in the same line
	enable_check_bracket_line = false,
	-- will ignore alphanumeric and `.` symbol
	ignored_next_char = "[%w%.]",
	fastwrap = {},
})

-- If you want insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
