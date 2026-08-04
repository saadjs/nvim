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
			-- Use single-letter source-control decorations.
			git_status = {
				symbols = {
					added = "A",
					modified = "M",
					deleted = "D",
					renamed = "R",
					untracked = "U",
					ignored = "",
					-- Avoid a second symbol beside the change-type letter.
					unstaged = "",
					staged = "",
					conflict = "C",
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

		-- Neo-tree disables numbers by default; show relative row numbers in the
		-- tree pane as well as in regular editor windows.
		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				handler = function()
					vim.opt_local.number = true
					vim.opt_local.relativenumber = true
				end,
			},
		},

		filesystem = {
			-- Replace netrw: opening a directory opens neo-tree in its configured
			-- sidebar position, leaving a normal editor window available for files.
			hijack_netrw_behavior = "open_default",
			-- Prefer the non-tree window when opening a file from the sidebar.
			open_files_in_last_window = true,
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
