-- return {
-- 	"stevearc/oil.nvim",
-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
-- 	config = function()
-- 		require("oil").setup({
-- 			delete_to_trash = true,
-- 			view_options = {
-- 				show_hidden = true,
-- 				is_always_hidden = function(name, bufnr)
-- 					return name:match(".git") ~= nil
-- 						or name:match(".svn") ~= nil
-- 						or name:match(".hg") ~= nil
-- 						or name:match(".DS_Store") ~= nil
-- 						or name:match("Thumbs.db") ~= nil
-- 				end,
-- 			},
-- 		})
--
-- 		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Oil File Explorer" })
-- 	end,
-- }
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- change color for arrows in tree to light blue
		vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
		local opts = {
			filters = {
				dotfiles = true,
				custom = { ".git", ".svn", ".hg", ".DS_Store" },
			},
			disable_netrw = true,
			hijack_netrw = true,
			hijack_cursor = true,
			hijack_unnamed_buffer_when_opening = false,
			sync_root_with_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = false,
			},
			view = {
				adaptive_size = false,
				side = "left",
				width = 30,
				preserve_window_proportions = true,
			},
			git = {
				enable = false,
				ignore = true,
			},
			filesystem_watchers = {
				enable = true,
			},
			actions = {
				open_file = {
					resize_window = true,
				},
			},
			renderer = {
				root_folder_label = false,
				highlight_git = false,
				highlight_opened_files = "none",

				indent_markers = {
					enable = false,
				},

				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = false,
					},

					glyphs = {
						default = "󰈚",
						symlink = "",
						folder = {
							default = "",
							empty = "",
							empty_open = "",
							open = "",
							symlink = "",
							symlink_open = "",
							arrow_open = "",
							arrow_closed = "",
						},
						git = {
							unstaged = "✗",
							staged = "✓",
							unmerged = "",
							renamed = "➜",
							untracked = "★",
							deleted = "",
							ignored = "◌",
						},
					},
				},
			},
		}

		nvimtree.setup(opts)

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", {
			desc = "Toggle file explorer",
		}) -- toggle file explorer
		keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", {
			desc = "Toggle file explorer on current file",
		}) -- toggle file explorer on current file
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", {
			desc = "Collapse file explorer",
		}) -- collapse file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", {
			desc = "Refresh file explorer",
		}) -- refresh file explorer
		keymap.set("n", "<leader>=", "<cmd>NvimTreeResize +5<CR>", {
			desc = "Increase file explorer width",
		}) -- increase file explorer width
		keymap.set("n", "<leader>-", "<cmd>NvimTreeResize -5<CR>", {
			desc = "Decrease file explorer width",
		}) -- decrease file explorer width
	end,
}
