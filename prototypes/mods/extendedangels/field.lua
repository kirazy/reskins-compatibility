-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

local _framework = { tiers = require("__reskins-framework__.api.tiers") }
local _sprite_utils = { icons = require("__reskins-sprite-utils__.icons") }

local Applicators = require("__reskins-assets-api__.api.applicators")
local CropFarm = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.crop-farm")

if not mods["extendedangels"] then
	return
end
if not (reskins.angels and reskins.angels.triggers.bioprocessing.entities) then
	return
end

local entities = {
	["angels-crop-farm"] = { tier = 1, prog_tier = 1, variant = "basic" },
	["angels-crop-farm-2"] = { tier = 2, prog_tier = 2, variant = "basic" },
	["angels-crop-farm-3"] = { tier = 3, prog_tier = 3, variant = "basic" },
	["angels-temperate-farm"] = { tier = 1, prog_tier = 3, variant = "temperate" },
	["angels-temperate-farm-2"] = { tier = 2, prog_tier = 4, variant = "temperate" },
	["angels-temperate-farm-3"] = { tier = 3, prog_tier = 5, variant = "temperate" },
	["angels-swamp-farm"] = { tier = 1, prog_tier = 3, variant = "swamp" },
	["angels-swamp-farm-2"] = { tier = 2, prog_tier = 4, variant = "swamp" },
	["angels-swamp-farm-3"] = { tier = 3, prog_tier = 5, variant = "swamp" },
	["angels-desert-farm"] = { tier = 1, prog_tier = 3, variant = "desert" },
	["angels-desert-farm-2"] = { tier = 2, prog_tier = 4, variant = "desert" },
	["angels-desert-farm-3"] = { tier = 3, prog_tier = 5, variant = "desert" },
}

local TYPE = "assembling-machine"

for name, options in pairs(entities) do
	local entity = data.raw[TYPE][name]
	if not entity then
		goto continue
	end

	local tier = _framework.tiers.get_tier(options)
	local tint = _framework.tiers.get_tint(tier)

	local sprite_set = CropFarm.get_sprite_set({ tint = tint, variant = options.variant })
	Applicators.apply_sprite_set(entity, sprite_set)

	local icon_data = CropFarm.get_icon({ tint = tint, variant = options.variant })
	local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
		tier = tier,
		name = entity.name,
		type_name = entity.type,
		icon_data = icon_data,
	})
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	::continue::
end
