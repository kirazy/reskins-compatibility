-- Copyright (c) 2026 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

---@using data

---Gets the numeral of the given `tier` in the style of Angel's mods, in the number tint of the Angel's mod with the
---given key in the `angelsmods` global, such as `"smelting"`.
---
---The numeral has the default scale and shift of an icon, for use as label content. When the Angel's mod has no number
---tint, the numeral is black.
---@param tier integer The number of the numeral.
---@param mod string The key of the Angel's mod in the `angelsmods` global.
---@return IconData[] # The icon of the numeral.
return function(tier, mod)
	local tint = angelsmods[mod] and angelsmods[mod].number_tint or util.color("#000000")
	local icon_data = angelsmods.functions.add_number_icon_layer({}, tier, util.get_color_with_alpha(tint, 1))

	for _, icon_datum in pairs(icon_data) do
		icon_datum.scale = nil
		icon_datum.shift = nil
	end

	return icon_data
end
