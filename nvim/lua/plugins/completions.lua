return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local ls = require("luasnip") -- Need this for the manual expansion

			-- 1. LOAD VSCODE SNIPPETS (Standard)
			require("luasnip.loaders.from_vscode").lazy_load()

			-- 2. FIX: LOAD YOUR CUSTOM LUA SNIPPETS (For your C++ template)
			require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets/" })

			cmp.setup({
				snippet = {
					expand = function(args)
						ls.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-c>"] = cmp.mapping(function()
						if cmp.get_config().completion.autocomplete then
							cmp.setup({ completion = { autocomplete = false } })
							vim.notify("Autocomplete: OFF")
						else
							cmp.setup({
								completion = { autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged } },
							})
							vim.notify("Autocomplete: ON")
						end
					end),
					["<C-h>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(), -- Manual trigger
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),

					-- 3. FIX: Add a specific key to expand snippets instantly
					-- Since you disabled auto-popup, this lets you hit Ctrl+K to expand 'cp'
					["<C-k>"] = cmp.mapping(function()
						if ls.expand_or_jumpable() then
							ls.expand_or_jump()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "luasnip" }, -- Snippets go FIRST so they appear at the top
					{ name = "nvim_lsp" },
					{ name = "obsidian" }, -- For existing notes
					{ name = "obsidian_new" }, -- For creating new notes on the fly
				}, {
					{ name = "buffer" },
				}),

				-- Your C++ specific config
				-- cmp.setup.filetype("cpp", {
				-- 	completion = {
				-- 		autocomplete = true, -- Kept off as you requested
				-- 	},
				-- }),
			})
		end,
	},
}
