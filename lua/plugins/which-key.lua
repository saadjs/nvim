return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		spec = {
			{ "<leader>s", group = "Search/Split" },
			{ "<leader>h", group = "Harpoon" },
			{ "<leader>w", group = "Window" },
			{ "<leader>x", group = "Diagnostics" },
			{ "gr", group = "LSP" },
		},
	},
}
