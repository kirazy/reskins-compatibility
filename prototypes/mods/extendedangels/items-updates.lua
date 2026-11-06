-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

---@using data
---@using Reskins.Framework
---@using Reskins.SpriteUtils

if not mods["extendedangels"] then
	return
end

local _framework = { tiers = require("__reskins-framework__.api.tiers") }

local Powders = require("__reskins-assets-api__.assets.angels.items.powders")

---Gets the definition of the icon from the given `composition` with the numeral of the given `tier`, drawn by Angel's
---mods in the number tint of Angel's smelting.
---@param composition IconComposition The icon under the numeral.
---@param tier integer The number of the numeral.
---@return TieredIconDefinition
local function numbered(composition, tier)
	return {
		icon_data = angelsmods.functions.add_number_icon_layer(
			composition:build({ to = "recipe" }),
			tier,
			angelsmods.smelting.number_tint
		),
	}
end

local function tungsten_carbide_powder()
	return Powders.get_icon_composition({ material = "tungsten-carbide" })
end

_framework.tiers.assign_icons_with_tier_labels("item", {
	["angels-powder-tungsten-carbide"] = { composition = tungsten_carbide_powder() },
})

_framework.tiers.assign_icons_with_tier_labels("recipe", {
	["angels-tungsten-carbide-smelting-1"] = numbered(tungsten_carbide_powder(), 1),
	["angels-tungsten-carbide-smelting-2"] = numbered(tungsten_carbide_powder(), 2),
	["angels-tungsten-carbide-smelting-3"] = numbered(tungsten_carbide_powder(), 3),
})
