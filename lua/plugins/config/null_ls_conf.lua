vim.cmd([[autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 100)]])

local null_ls = require("null-ls")
null_ls.setup({ sources = { null_ls.builtins.formatting.stylua } })
