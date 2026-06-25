return { -- Resizable, toggleable sidebar file tree with git status
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	-- Load at startup so neo-tree can take over directory buffers (`nvim .`)
	-- instead of falling back to netrw. It still defers its own heavy work.
	lazy = false,
	keys = {
		{ "<leader>ee", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
		{ "<leader>ef", "<cmd>Neotree reveal<cr>", desc = "Reveal current file in tree" },
		{ "<leader>eg", "<cmd>Neotree float git_status<cr>", desc = "Git status (Neo-tree)" },
		{ "<leader>eb", "<cmd>Neotree toggle buffers<cr>", desc = "Buffers (Neo-tree)" },
	},
	opts = {
		-- Quit Neovim if the tree is the last window left open
		close_if_last_window = true,
		-- Git status decorations in the tree (the marks next to files)
		enable_git_status = true,
		enable_diagnostics = true,

		default_component_configs = {
			-- Basic Unicode symbols that render in any font (no Nerd Font glyphs)
			git_status = {
				symbols = {
					added = "✚",
					modified = "●",
					deleted = "✖",
					renamed = "➜",
					untracked = "★",
					ignored = "◌",
					unstaged = "✗",
					staged = "✓",
					conflict = "",
				},
			},
		},

		window = {
			position = "left",
			width = 32, -- starting width; resize live (see notes below)
			mappings = {
				["q"] = "close_window", -- hide the tree
				["H"] = "toggle_hidden", -- show/hide dotfiles + gitignored
				["P"] = { "toggle_preview", config = { use_float = true } },
				["<space>"] = "none", -- don't shadow the leader key inside the tree
			},
		},

		filesystem = {
			-- Replace netrw: opening a directory opens neo-tree in that window
			hijack_netrw_behavior = "open_current",
			-- Keep the tree in sync with the file you're editing
			follow_current_file = { enabled = true, leave_dirs_open = false },
			-- Auto-refresh when files change on disk (e.g. after lazygit)
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = false, -- press `H` in the tree to reveal these
				hide_dotfiles = false, -- show dotfiles by default
				hide_gitignored = true, -- hide node_modules etc. (toggle with H)
				hide_by_name = { ".git", ".DS_Store", "thumbs.db" },
			},
		},
	},
}
