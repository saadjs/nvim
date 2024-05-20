return {
	-- Theme inspired by Atom
	-- "rose-pine/neovim",
	-- priority = 1000,
	-- config = function()
	-- 	vim.cmd.colorscheme("rose-pine")
	-- end,
	"oxfist/night-owl.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("night-owl").setup()
		vim.cmd.colorscheme("night-owl")
	end,
}
