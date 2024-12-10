require("bamboo").setup({
	-- Main options --
	-- NOTE: to use the light theme, set `vim.o.background = 'light'`
	style = "vulgaris",
	colors = {
		shade = "#2f312c",
		mdSign = "#3a3d37",
		mdOrange = "#ffc1a3",
		mdBgBlue = "#a4cef1",
		mdCoral = "#f6b2b2",
		mdGreen = "#bbd2ab",
		mdPurple = "#ccccff",
		mdRed = "#f09cb0",
		mdYellow = "#e9d396",
		mdBlue = "#8892a3",
		mdGray = "#7c7c7b",
		mdLightGey = "#b4b7b3",
		mdDarkGreen = "#8c9776",
		mdcode = "#c7dab9",
		mdbold = "#ffccb2",
	},
	highlights = {
		["FloatBorder"] = { fg = "$grey" },
		["MarkviewCode"] = { bg = "$bg0" },
		-- ["MarkviewHyperlink"] = { fg = "$purple", underline = false },
		["MarkviewHeading1"] = { fg = "$orange" },
		["MarkviewHeading2"] = { fg = "$blue" },
		["MarkviewHeading3"] = { fg = "$yellow" },
		["MarkviewHeading4"] = { fg = "$green" },
		["MarkviewHeading5"] = { fg = "$coral" },
		["MarkviewHeading6"] = { fg = "$light_grey" },
		["MarkviewInlineCode"] = { fg = "$mdLightGey", bg = "$shade" },
		["markdownUrl"] = { fg = "$yellow", fmt = "none" },
		["markdownCodeBlock"] = { fg = "$mdcode" },
		["markdownBold"] = { fg = "$mdBlue", fmt = "bold" },
		["markdownItalic"] = { fg = "$mdYellow", fmt = "italic" },
		["markdownLinkText"] = { fg = "$light_blue", underline = false },
		["MarkviewListItemStar"] = { fg = "$green" },
		-- ["markdownLink"] = { fg = "$purple", underline = false },
		-- Telescope
		["TelescopePreviewBorder"] = { fg = "$mdDarkGreen" },
		["TelescopePreviewTitle"] = { fg = "$green" },
		["TelescopeResultsBorder"] = { fg = "$mdDarkGreen" },
		["TelescopeResultsTitle"] = { fg = "$green" },
		["TelescopePromptBorder"] = { fg = "$mdDarkGreen" },
		["TelescopePromptTitle"] = { fg = "$green" },
		-- Whichkey
		["WhichKeyBorder"] = { fg = "$light_grey" },
		["WhichKeyTitle"] = { fg = "$green" },
		["WhichKeyDesc"] = { fg = "$fg" },
		["WhichKey"] = { fg = "$light_blue" },
		-- Neotree
		["NeoTreeFloatBorder"] = { fg = "$light_grey" },
		["NeoTreeFloatTitle"] = { fg = "$green" },
		["NeoTreeDirectoryIcon"] = { fg = "$yellow" },
		["NeoTreeDirectoryName"] = { fg = "$green" },
		-- LazyGit
		["LazyGitBorder"] = { fg = "$light_grey" },
		["LazyGitFloat"] = { fg = "$mdLightGey" },
		-- Neogit
		["NeogitBranch"] = { fg = "$yellow" },
		["NeogitPopupActionKey"] = { fg = "$blue" },
		["NeogitSectionHeader"] = { fg = "$orange", fmt = "bold" },
		["NeogitDiffDelete"] = { fg = "$red", bg = "$shade" },
		["NeogitDiffDeleteHighlight"] = { fg = "$red", bg = "$shade" },
		["NeogitDiffAdd"] = { fg = "$green", bg = "$shade" },
		["NeogitDiffAddHighlight"] = { fg = "$green", bg = "$shade" },
		["NeogitChangeModified"] = { fg = "$light_blue", fmt = "bold" },
		["NeogitHunkHeaderHighlight"] = { fg = "$purple", bg = "$bg3" },
	},
})
