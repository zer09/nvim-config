return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"fdschmidt93/telescope-egrepify.nvim",
			{
				"nvim-telescope/telescope-file-browser.nvim",
				dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
			},
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local act = require("telescope.actions")
			local act_layout = require("telescope.actions.layout")
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					winblend = 10,
					layout_config = { -- :help telescope.layout
						horizontal = { width = 0.9 },
						mirror = false,
						-- prompt_position = "top",
					},
					prompt_prefix = "❯ ",
					selection_caret = "❯ ",
					file_ignore_patterns = {
						"node_modules/.*",
						"%.env",
						"yarn.lock",
						"package%-lock.json",
						"pnpm%-lock.yaml",
						"lazy%-lock.json",
						"init.sql",
						"target/.*",
						".git/.*",
						".venv/.*",
						"__pycache__/.*",
						"%.pyc",
						"dist/.*",
						"build/.*",
						"%.min%.js",
						"%.min%.css",
					},
					mappings = {
						n = {
							["<M-p>"] = act_layout.toggle_preview,
						},
						i = {
							["<esc>"] = act.close,
							["<M-p>"] = act_layout.toggle_preview,
							["<C-h>"] = "which_key",
							["<C-u>"] = false,
						},
					},
					preview = {
						mime_hook = function(filepath, bufnr, opts)
							local is_image = function(image_filepath)
								-- catimg
								local image_extensions = { "png", "jpg", "ico" } -- Supported image formats
								local split_path = vim.split(image_filepath:lower(), ".", { plain = true })
								local extension = split_path[#split_path]
								return vim.tbl_contains(image_extensions, extension)
							end
							if is_image(filepath) then
								local term = vim.api.nvim_open_term(bufnr, {})
								local function send_output(_, data, _)
									for _, d in ipairs(data) do
										vim.api.nvim_chan_send(term, d .. "\r\n")
									end
								end
								vim.fn.jobstart({
									"catimg",
									filepath, -- Terminal image viewer command
								}, { on_stdout = send_output, stdout_buffered = true, pty = true })
							else
								require("telescope.previewers.utils").set_preview_message(
									bufnr,
									opts.winid,
									"Binary cannot be previewed"
								)
							end
						end,
					},
				},
				extensions = {
					file_browser = {
						path = "%:p:h",
						grouped = false,
						create_from_prompt = false,
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
			telescope.load_extension("egrepify")

			local nnoremap = require("helper").nnoremap
			nnoremap("<Leader>th", "<CMD>Telescope help_tags<CR>")
			nnoremap("<Leader>tm", "<CMD>Telescope keymaps<CR>")
			nnoremap("<Leader>tp", "<CMD>Telescope find_files hidden=true<CR>")
			nnoremap("<Leader>ts", "<CMD>Telescope live_grep<CR>")
			nnoremap("<Leader>tS", "<CMD>Telescope egrepify<CR>")
			nnoremap("<Leader>bb", "<CMD>Telescope buffers<CR>")
			nnoremap("<Leader>tt", "<CMD>Telescope file_browser hidden=true<CR>")
		end,
	},
	{
		{
			"AckslD/nvim-neoclip.lua",
			event = "VeryLazy",
			dependencies = {
				"nvim-telescope/telescope.nvim",
				"kkharji/sqlite.lua",
			},
			opts = function()
				require("telescope").load_extension("neoclip")
				require("helper").nnoremap("<Leader>tc", "<CMD>Telescope neoclip<CR>")

				return {
					enable_persistent_history = true,
				}
			end,
		},
	},
}
