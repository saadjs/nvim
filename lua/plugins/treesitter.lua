local parsers = {
	"bash",
	"c",
	"html",
	"lua",
	"markdown",
	"markdown_inline",
	"vim",
	"vimdoc",
	"typescript",
	"tsx",
	"javascript",
	"python",
	"json",
	"yaml",
	"css",
}

return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
			config = function()
				require("nvim-treesitter-textobjects").setup({
					select = { lookahead = true },
				})

				local select = require("nvim-treesitter-textobjects.select")
				local move = require("nvim-treesitter-textobjects.move")

				vim.keymap.set({ "x", "o" }, "af", function()
					select.select_textobject("@function.outer", "textobjects")
				end)
				vim.keymap.set({ "x", "o" }, "if", function()
					select.select_textobject("@function.inner", "textobjects")
				end)
				vim.keymap.set({ "x", "o" }, "ac", function()
					select.select_textobject("@class.outer", "textobjects")
				end)
				vim.keymap.set({ "x", "o" }, "ic", function()
					select.select_textobject("@class.inner", "textobjects")
				end)
				vim.keymap.set({ "n", "x", "o" }, "]f", function()
					move.goto_next_start("@function.outer", "textobjects")
				end)
				vim.keymap.set({ "n", "x", "o" }, "[f", function()
					move.goto_previous_start("@function.outer", "textobjects")
				end)
			end,
		},
	},
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(event)
				local language = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
				if not language or not vim.list_contains(parsers, language) then
					return
				end

				if pcall(vim.treesitter.start, event.buf, language) and language ~= "markdown" then
					vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
