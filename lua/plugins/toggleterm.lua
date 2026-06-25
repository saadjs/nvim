return { -- Togglable terminals + a full lazygit TUI a keystroke away
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{ "<leader>gg", desc = "Lazygit" },
		{ "<C-\\>", desc = "Toggle terminal" },
		{ "<leader>tf", desc = "Floating terminal" },
	},
	config = function()
		require("toggleterm").setup({
			-- <C-\> toggles a horizontal terminal split
			open_mapping = [[<C-\>]],
			direction = "horizontal",
			size = 15,
			shade_terminals = true,
			start_in_insert = true,
			persist_mode = true,
		})

		-- Lazygit as a dedicated full-screen floating terminal
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			direction = "float",
			float_opts = { border = "curved" },
			hidden = true,
			-- Refresh gitsigns/buffers after lazygit makes changes
			on_close = function()
				vim.cmd("checktime")
			end,
		})

		vim.keymap.set("n", "<leader>gg", function()
			lazygit:toggle()
		end, { desc = "Lazygit" })

		-- A general-purpose floating terminal
		local float_term = Terminal:new({ direction = "float", float_opts = { border = "curved" }, hidden = true })
		vim.keymap.set("n", "<leader>tf", function()
			float_term:toggle()
		end, { desc = "Floating terminal" })

		-- Easier escape + window navigation while in terminal mode
		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*toggleterm#*",
			callback = function()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			end,
		})
	end,
}
