local colors = require'nord.colors'

local highlights = require'nord'.bufferline.highlights {
	italic = true,
	bold = true,
	fill = colors.nord0_gui,
	indicator = colors.nord9_gui,
  bg = colors.nord0_gui,
  buffer_bg = colors.nord0_gui,
  buffer_bg_selected = colors.nord1_gui,
  buffer_bg_visible = "#2A2F3A",
}

local bufferline = require'bufferline'

bufferline.setup {
	options = {
		separator_style = "slant",
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
