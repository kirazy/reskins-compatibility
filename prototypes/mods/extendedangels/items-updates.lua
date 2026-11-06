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
if not (mods["reskins-angels"] and mods["angelssmelting"]) then
	return
end

local _framework = { tiers = require("__reskins-framework__.api.tiers") }

local Powders = require("__reskins-assets-api__.assets.angels.items.powders")
local get_angels_numeral = require("__reskins-compatibility__.prototypes.functions.angels-numerals")

---Gets the numeral of the given `tier`, in the style of Angel's smelting.
---@param tier integer The number of the numeral.
---@return IconData[]
local function numeral(tier)
	return get_angels_numeral(tier, "smelting")
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
	["angels-tungsten-carbide-smelting-1"] = { composition = tungsten_carbide(), label = numeral(1) },
	["angels-tungsten-carbide-smelting-2"] = { composition = tungsten_carbide(), label = numeral(2) },
	["angels-tungsten-carbide-smelting-3"] = { composition = tungsten_carbide(), label = numeral(3) },
})
