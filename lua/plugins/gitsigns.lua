return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Hunk navigation (respects diff mode so it works inside Diffview too)
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, "Next git hunk")

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, "Previous git hunk")

				-- Hunk actions (stage_hunk toggles: stage an unstaged hunk, unstage a staged one)
				map("n", "<leader>gs", gitsigns.stage_hunk, "Stage/unstage hunk")
				map("n", "<leader>gr", gitsigns.reset_hunk, "Reset hunk")
				map("v", "<leader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage/unstage selected hunk")
				map("v", "<leader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset selected hunk")
				map("n", "<leader>gS", gitsigns.stage_buffer, "Stage buffer")
				map("n", "<leader>gR", gitsigns.reset_buffer, "Reset buffer")
				map("n", "<leader>gp", gitsigns.preview_hunk, "Preview hunk")

				-- Blame
				map("n", "<leader>gb", function()
					gitsigns.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>gB", gitsigns.toggle_current_line_blame, "Toggle line blame")

				-- Diff
				map("n", "<leader>gx", gitsigns.diffthis, "Diff against index")
			end,
		},
	},
}
