-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

---@using data
---@using Reskins.Framework

-- Check to see if reskinning needs to be done.
if not mods["extendedangels"] then
	return
end

local _framework = { tiers = require("__reskins-framework__.api.tiers") }

local Powders = require("__reskins-assets-api__.assets.angels.items.powders")

---Gets the definition of the icon of the given `composition` with the numeral of the given `tier`, drawn by Angel's
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

---Gets the icon of the tungsten carbide powder, with its picture variations.
---@return IconComposition
local function tungsten_carbide()
	return Powders.get_icon_composition({ material = "tungsten-carbide" })
end

_framework.tiers.assign_icons_with_tier_labels("item", {
	["angels-powder-tungsten-carbide"] = { composition = tungsten_carbide() },
})

-- Assign the recipes after the items they read.
_framework.tiers.assign_icons_with_tier_labels("recipe", {
	["angels-tungsten-carbide-smelting-1"] = numbered(tungsten_carbide(), 1),
	["angels-tungsten-carbide-smelting-2"] = numbered(tungsten_carbide(), 2),
	["angels-tungsten-carbide-smelting-3"] = numbered(tungsten_carbide(), 3),
})
