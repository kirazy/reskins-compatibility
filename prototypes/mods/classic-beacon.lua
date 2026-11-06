-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

---@using data

local _framework = { tiers = require("__reskins-framework__.api.tiers") }
local _sprite_utils = { icons = require("__reskins-sprite-utils__.icons") }

local Applicators = require("__reskins-assets-api__.api.applicators")
local BeaconOriginal = require("__reskins-assets-api__.assets.assorted.entities.beacon-original")

if not mods["classic-beacon"] then
	return
end
if not mods["bobmodules"] then
	return
end

local entities = {
	["beacon"] = { tier = 1, prog_tier = 3 },
	["bob-beacon-2"] = { tier = 2, prog_tier = 4 },
	["bob-beacon-3"] = { tier = 3, prog_tier = 5 },
}

local TYPE = "beacon"

for name, options in pairs(entities) do
	---@type data.BeaconPrototype
	local entity = data.raw[TYPE][name]
	if not entity then
		goto continue
	end

	-- Fix order shenanigans
	if name == "beacon" then
		data.raw["item"][name].order = "a[beacon]-1"
		entity.order = "z-a[beacon]-1"
	end

	local tier = _framework.tiers.get_tier(options)
	local tint = _framework.tiers.get_tint(tier)

	-- Strip module art styles; the applicator retains any art style it does not own and the classic
	-- beacon does not support art styles.
	if entity.graphics_set then
		entity.graphics_set.module_visualisations = nil
	end

	local sprite_set = BeaconOriginal.get_sprite_set({ tint = tint })
	Applicators.apply_sprite_set(entity, sprite_set)

	local composition = BeaconOriginal.get_icon_composition({ tint = tint })
	local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
		tier = tier,
		name = entity.name,
		type_name = entity.type,
		composition = composition,
	})
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	::continue::
end
