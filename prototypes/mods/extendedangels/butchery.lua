-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

local _framework = { tiers = require("__reskins-framework__.api.tiers") }
local _sprite_utils = { icons = require("__reskins-sprite-utils__.icons") }

local Applicators = require("__reskins-assets-api__.api.applicators")
local Butchery = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.butchery")

if not mods["extendedangels"] then
	return
end
if not (mods["reskins-angels"] and mods["angelsbioprocessing"]) then
	return
end

local entities = {
	["angels-bio-butchery"] = { tier = 1, prog_tier = 2 },
	["angels-bio-butchery-2"] = { tier = 2, prog_tier = 3 },
	["angels-bio-butchery-3"] = { tier = 3, prog_tier = 4 },
}

local TYPE = "furnace"

for name, options in pairs(entities) do
	local entity = data.raw[TYPE][name]
	if not entity then
		goto continue
	end

	local tier = _framework.tiers.get_tier(options)
	local tint = _framework.tiers.get_tint(tier)

	local sprite_set = Butchery.get_sprite_set({ tint = tint })
	Applicators.apply_sprite_set(entity, sprite_set)

	local composition = Butchery.get_icon_composition({ tint = tint })
	local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
		tier = tier,
		name = entity.name,
		type_name = entity.type,
		composition = composition,
	})
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	::continue::
end
