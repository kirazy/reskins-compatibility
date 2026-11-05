-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Angel's Mods
--
-- See LICENSE.md in the project directory for license information.

---@using data
---@using Reskins.Framework

-- Check to see if reskinning needs to be done.
if not (reskins.angels and reskins.angels.triggers.mad_clowns.is_active) then
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

---Gets the numeral of the given `tier`, in the style of Angel's smelting.
---@param tier integer The number of the numeral.
---@return IconData[]
local function numeral(tier)
	return reskins.angels.num_tier(tier, "smelting")
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
	["clowns-processed-depleted-uranium"] = { composition = ProcessedOres.get_icon_composition({ material = "depleted-uranium" }) },
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
	["angels-pellet-magnesium-titanium-smelting"] = {
		composition = Ingots.get_icon_composition({ material = "titanium" }),
		label = numeral(3),
	},
	["clowns-casting-powder-depleted-uranium-1"] = {
		composition = Powders.get_icon_composition({ material = "depleted-uranium-mixture" }),
		label = numeral(1),
	},
	["clowns-casting-powder-depleted-uranium-2"] = {
		composition = Powders.get_icon_composition({ material = "depleted-uranium-mixture" }),
		label = numeral(2),
	},
	["clowns-casting-powder-depleted-uranium-3"] = {
		composition = Powders.get_icon_composition({ material = "depleted-uranium-mixture" }),
		label = numeral(3),
	},
	["clowns-casting-powder-depleted-uranium-4"] = {
		composition = Powders.get_icon_composition({ material = "depleted-uranium-mixture" }),
		label = numeral(4),
	},
	["clowns-magnesium-pellet-smelting"] = magnesium_ingot(),
})
