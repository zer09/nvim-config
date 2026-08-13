local util = require("lspconfig.util")

return {
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root_files = {
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"tailwind.config.ts",
			"theme/static_src/tailwind.config.js",
			"theme/static_src/tailwind.config.cjs",
			"theme/static_src/tailwind.config.mjs",
			"theme/static_src/tailwind.config.ts",
		}

		-- Do not use .git as a fallback. It makes Tailwind watch an entire monorepo.
		root_files = util.insert_package_json(root_files, "tailwindcss", fname)
		root_files = util.root_markers_with_field(root_files, { "mix.lock", "Gemfile.lock" }, "tailwind", fname)
		local root_file = vim.fs.find(root_files, { path = fname, upward = true })[1]

		if root_file then
			on_dir(vim.fs.dirname(root_file))
		end
	end,
	settings = {
		tailwindCSS = {
			lint = {
				invalidConfigPath = "warning",
			},
		},
	},
}
