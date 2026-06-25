-- [[ Setting options ]]
-- `:help vim.opt`

-- Set to false if you don't have a Nerd Font installed
vim.g.have_nerd_font = true

-- Set highlight on search
vim.opt.hlsearch = false

-- Make line numbers default
vim.opt.nu = true

-- Turn on relative line numbers
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.smartindent = true
vim.g.autoformat = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

vim.opt.swapfile = false
vim.opt.backup = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

vim.opt.colorcolumn = "80"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- Confirm before exiting if there are unsaved changes
vim.opt.confirm = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

-- Live preview of :substitute
vim.opt.inccommand = "split"

-- Highlight current line
vim.opt.cursorline = true

-- New splits appear below and to the right
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Treesitter-based folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99 -- Start with all folds open

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(event)
		vim.opt_local.foldmethod = "manual"
		vim.opt_local.foldexpr = "0"
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(event.buf) then
				vim.treesitter.stop(event.buf)
			end
		end)
	end,
})

-- Disable auto-comment on new line
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})
