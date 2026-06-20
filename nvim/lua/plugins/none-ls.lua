return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- LUA
				null_ls.builtins.formatting.stylua,

				-- JAVASCRIPT / TYPESCRIPT / HTML / CSS (Prettier covers all of these)
				null_ls.builtins.formatting.prettier,

				-- PYTHON
				null_ls.builtins.formatting.black, -- Popular Python formatter
				null_ls.builtins.formatting.isort, -- Sorts imports automatically

				-- C++
				null_ls.builtins.formatting.clang_format,
			},

			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})

		-- Keymap to format the current buffer
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
