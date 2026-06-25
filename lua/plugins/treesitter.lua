return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TSInstall", "TSInstallSync", "TSUpdate", "TSUpdateSync" },
	build = ":TSUpdate",
	dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	config = function()
		-- [[ Configure Treesitter ]] `:help nvim-treesitter`

		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
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
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Markdown currently crashes Neovim 0.12's built-in highlighter
				-- for some buffers when nvim-treesitter and bundled queries mix.
				disable = { "markdown", "markdown_inline" },
			},
			indent = {
				enable = true,
				disable = { "markdown", "markdown_inline" },
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					goto_next_start = { ["]f"] = "@function.outer" },
					goto_previous_start = { ["[f"] = "@function.outer" },
				},
			},
		})
	end,
}
