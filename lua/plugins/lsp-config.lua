return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = true,
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				-- Inline text disabled: rely on squiggly underlines + signs to spot
				-- diagnostics, and `[d` / `]d` to open the float with the message.
				virtual_text = false,
			})
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				ts_ls = {},
				cssls = {},
				html = {},
				jsonls = {},
				bashls = {},

				-- Lint diagnostics for JS/TS (only active when the project has an
				-- eslint config). `:LspEslintFixAll` fixes auto-fixable issues.
				-- NOTE: eslint's `before_init` is force-overridden after
				-- mason-lspconfig setup below (see the ESLint 9/10 fix).
				eslint = {},

				-- Tailwind class completion + hover (only active in projects
				-- with a tailwind config).
				tailwindcss = {},

				-- Emmet abbreviation expansion (e.g. `ul>li*3` + completion) for
				-- HTML/CSS/JSX/TSX.
				emmet_language_server = {},

				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"prettier", -- Used to format JS/TS/JSON/YAML/MD
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			-- ESLint 9/10 fix: nvim-lspconfig's default `before_init` force-enables
			-- the legacy `experimental.useFlatConfig` flag whenever it finds an
			-- `eslint.config.*` file. That flag routes ESLint 9/10 down a removed
			-- code path ("doesn't export a FlatESLint class") and silently disables
			-- linting. The mason-lspconfig handler's `setup()` merge keeps the
			-- framework `before_init`, so we replace it directly via `vim.lsp.config`
			-- (force-merge) -- keeping `workspaceFolder` and letting the server
			-- auto-detect flat config via `loadESLint()`.
			vim.lsp.config("eslint", {
				before_init = function(_, config)
					local root_dir = config.root_dir
					if root_dir then
						config.settings = config.settings or {}
						config.settings.workspaceFolder = {
							uri = root_dir,
							name = vim.fn.fnamemodify(root_dir, ":t"),
						}
					end
					config.settings = config.settings or {}
					config.settings.experimental = config.settings.experimental or {}
					config.settings.experimental.useFlatConfig = false
				end,
			})
		end,
	},
}
