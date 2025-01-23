local colors = require'nord.colors'

local highlights = require'nord'.bufferline.highlights {
	italic = true,
	bold = true,
}

local bufferline = require'bufferline'

bufferline.setup {
	options = {
		themable = true,
		-- separator_style = "slant",
		highlights = highlights,
		style_preset = {
			bufferline.style_preset.no_i,
		},
				diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or ""
       		 return " " .. icon .. count

    end,
	}
}

