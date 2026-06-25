return { -- Autocompletion (blink.cmp) -- LSP/path/buffer only, no snippets
	"saghen/blink.cmp",
	-- Pulls a prebuilt fuzzy-matcher binary from the release, so no Rust
	-- toolchain or build step is required.
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = { "folke/lazydev.nvim" },

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default': C-y accept, C-n/C-p select, C-space open menu, C-e hide.
		-- Matches the old nvim-cmp keymaps so nothing changes for you.
		keymap = { preset = "default" },

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			-- Menu pops up automatically as you type
			menu = { auto_show = true },
			-- Show LSP docs for the selected item after a short delay
			documentation = { auto_show = true, auto_show_delay_ms = 250 },
			-- No inline preview of the selected item
			ghost_text = { enabled = false },
		},

		-- No 'snippets' source -> pure LSP / path / buffer autocompletion.
		-- (lazydev gives better completions while editing your own nvim config.)
		sources = {
			default = { "lazydev", "lsp", "path", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100, -- show its items above LSP
				},
			},
		},

		-- Signature help while typing function args
		signature = { enabled = true },

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
