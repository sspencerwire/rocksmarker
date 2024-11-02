require("conform").setup({
  formatters_by_ft = {
	lua = { "stylua" },
    	css = { "prettier" },
	html = { "prettier" },
	sh = { "shfmt" },
	bash = { "shfmt" },
	markdown = { "markdownlint" },
    	yaml = { "yamlfmt" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },

})

