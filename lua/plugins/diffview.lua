return { -- Side-by-side diffs, file history, and merge-conflict resolution
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewFileHistory",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
	},
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff working tree" },
		{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history (all files)" },
		{ "<leader>gh", "<cmd>'<,'>DiffviewFileHistory<cr>", desc = "File history (selection)", mode = "v" },
	},
	opts = {
		enhanced_diff_hl = true,
		view = {
			-- Resolve merge conflicts with a 3-way layout (OURS | result | THEIRS)
			merge_tool = {
				layout = "diff3_mixed",
				disable_diagnostics = true,
			},
		},
		keymaps = {
			view = {
				{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
			},
			file_panel = {
				{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
			},
			file_history_panel = {
				{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
			},
		},
	},
}
