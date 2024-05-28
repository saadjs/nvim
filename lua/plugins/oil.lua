return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				delete_to_trash = true,
				view_options = {
					show_hidden = true,
					is_always_hidden = function(name, bufnr)
						return name:match(".git") ~= nil
							or name:match(".svn") ~= nil
							or name:match(".hg") ~= nil
							or name:match(".DS_Store") ~= nil
							or name:match("Thumbs.db") ~= nil
					end,
				},
			})

			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Oil File Explorer" })
		end,
	},
}
