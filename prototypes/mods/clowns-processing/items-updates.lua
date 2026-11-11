-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Angel's Mods
--
-- See LICENSE.md in the project directory for license information.

---@using data
---@using Reskins.SpriteUtils
---@using Reskins.Framework

if not mods["Clowns-Processing"] then
	return
end

local _framework = {
	settings = require("__reskins-framework__.api.settings"),
	tiers = require("__reskins-framework__.api.tiers"),
}

local Ingots = require("__reskins-assets-api__.assets.angels.items.ingots")
local LiquidMaterial = require("__reskins-assets-api__.assets.angels.items.liquid-material")
local Pellets = require("__reskins-assets-api__.assets.angels.items.pellets")
local Plates = require("__reskins-assets-api__.assets.angels.items.plates")
local Powders = require("__reskins-assets-api__.assets.angels.items.powders")
local ProcessedOres = require("__reskins-assets-api__.assets.assorted.items.processed-ores")

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

---Gets the definition of the magnesium ingot, with its picture variations when item variations are enabled.
---@return TieredIconDefinition
local function magnesium_ingot()
	if _framework.settings.get_value("reskins-angels-use-item-variations") then
		return { composition = Ingots.get_icon_composition({ material = "magnesium" }) }
	end

	return {
		icon_datum = {
			icon = "__reskins-assets-angels__/graphics/icons/ingots/magnesium/ingot-magnesium.png",
			icon_size = 64,
		},
	}
end

_framework.tiers.assign_icons_with_tier_labels("item", {
	-- Processed ores
	["clowns-processed-depleted-uranium"] = {
		composition = ProcessedOres.get_icon_composition({ material = "depleted-uranium" }),
	},
	["clowns-processed-magnesium"] = { composition = ProcessedOres.get_icon_composition({ material = "magnesium" }) },
	["clowns-processed-osmium"] = { composition = ProcessedOres.get_icon_composition({ material = "osmium" }) },

	-- The powders have picture variations.
	["clowns-powder-depleted-uranium"] = { composition = Powders.get_icon_composition({ material = "depleted-uranium" }) },
	["clowns-casting-powder-depleted-uranium"] = {
		composition = Powders.get_icon_composition({ material = "depleted-uranium-mixture" }),
	},
	["clowns-powder-osmium"] = { composition = Powders.get_icon_composition({ material = "osmium" }) },
	["clowns-casting-powder-osmium"] = { composition = Powders.get_icon_composition({ material = "osmium-mixture" }) },

	-- Plates
	["clowns-plate-depleted-uranium"] = { composition = Plates.get_icon_composition({ material = "depleted-uranium" }) },
	["clowns-plate-magnesium"] = { composition = Plates.get_icon_composition({ material = "magnesium" }) },
	["clowns-plate-osmium"] = { composition = Plates.get_icon_composition({ material = "osmium" }) },

	-- Pellets
	["clowns-pellet-depleted-uranium"] = { composition = Pellets.get_icon_composition({ material = "depleted-uranium" }) },
	["clowns-pellet-magnesium"] = { composition = Pellets.get_icon_composition({ material = "magnesium" }) },
	["clowns-pellet-osmium"] = { composition = Pellets.get_icon_composition({ material = "osmium" }) },

	-- Ingots
	["clowns-ingot-magnesium"] = magnesium_ingot(),
})

_framework.tiers.assign_icons_with_tier_labels("fluid", {
	["clowns-liquid-molten-magnesium"] = { composition = LiquidMaterial.get_icon_composition({ material = "magnesium" }) },
})

-- Assign the recipes after the items they read.
_framework.tiers.assign_icons_with_tier_labels("recipe", {
	["angels-pellet-magnesium-titanium-smelting"] = numbered(Ingots.get_icon_composition({ material = "titanium" }), 3),
	["clowns-casting-powder-depleted-uranium-1"] = numbered(
		Powders.get_icon_composition({ material = "depleted-uranium-mixture" }),
		1
	),
	["clowns-casting-powder-depleted-uranium-2"] = numbered(
		Powders.get_icon_composition({ material = "depleted-uranium-mixture" }),
		2
	),
	["clowns-casting-powder-depleted-uranium-3"] = numbered(
		Powders.get_icon_composition({ material = "depleted-uranium-mixture" }),
		3
	),
	["clowns-casting-powder-depleted-uranium-4"] = numbered(
		Powders.get_icon_composition({ material = "depleted-uranium-mixture" }),
		4
	),
	["clowns-magnesium-pellet-smelting"] = magnesium_ingot(),
})
