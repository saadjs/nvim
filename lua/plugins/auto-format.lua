return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>ff",
			function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 3000,
				})
			end,
			mode = { "n", "v" },
			desc = "Format file or range",
		},
	},
	opts = {
		formatters_by_ft = {
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			lua = { "stylua" },
			python = { "isort", "black" },
		},
		format_on_save = function(bufnr)
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			-- Disable for files in node_modules
			if bufname:match("/node_modules/") then
				return
			end

			-- For prettier filetypes, only format if config exists
			local prettier_fts = { javascript = true, typescript = true, json = true, yaml = true, markdown = true }
			local ft = vim.bo[bufnr].filetype
			if prettier_fts[ft] then
				local prettier_config = vim.fs.find({
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yml",
					".prettierrc.yaml",
					".prettierrc.js",
					".prettierrc.cjs",
					"prettier.config.js",
					"prettier.config.cjs",
					".prettierrc.toml",
				}, { upward = true, path = vim.fs.dirname(bufname) })

				if #prettier_config == 0 then
					return -- No prettier config found, skip formatting
				end
			end

			return {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			}
		end,
		formatters = {
			prettier = {
				require_cwd = false,
			},
		},
		notify_on_error = true,
	},
}
