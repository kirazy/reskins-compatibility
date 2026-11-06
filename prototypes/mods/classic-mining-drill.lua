-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

local _framework = { tiers = require("__reskins-framework__.api.tiers") }
local _sprite_utils = { icons = require("__reskins-sprite-utils__.icons") }
local _assets = {
	icons = require("__reskins-assets-api__.api.icons"),
	defines = require("__reskins-assets-api__.api.defines"),
}

local Applicators = require("__reskins-assets-api__.api.applicators")
local MiningDrillElectricOriginal =
	require("__reskins-assets-api__.assets.assorted.entities.mining-drill-electric-original")

-- Check to see if reskinning needs to be done.
if not mods["classic-mining-drill"] then
	return
end
if not mods["bobmining"] then
	return
end

local entities = {
	["electric-mining-drill"] = { tier = 1 },
	["bob-mining-drill-1"] = { tier = 2 },
	["bob-mining-drill-2"] = { tier = 3 },
	["bob-mining-drill-3"] = { tier = 4 },
	["bob-mining-drill-4"] = { tier = 5 },
	["bob-area-mining-drill-1"] = { tier = 1, prog_tier = 2, is_area_drill = true },
	["bob-area-mining-drill-2"] = { tier = 2, prog_tier = 3, is_area_drill = true },
	["bob-area-mining-drill-3"] = { tier = 3, prog_tier = 4, is_area_drill = true },
	["bob-area-mining-drill-4"] = { tier = 4, prog_tier = 5, is_area_drill = true },
}

local TYPE = "mining-drill"

-- Rescale mining drill animation playback speed to something visually appealing
local max_playback = 2 -- Maximum animation playback speed
local min_playback = 0.5 -- Minimum animation playback speed

local mining_speeds = {}

-- Loop through all the drills, figure out the mining speeds
for name, _ in pairs(entities) do
	local entity = data.raw[TYPE][name]
	if entity then
		table.insert(mining_speeds, entity.mining_speed)
	end
end

-- Determine max and min mining speeds
table.sort(mining_speeds)
local max_speed = mining_speeds[#mining_speeds] or 0
local min_speed = mining_speeds[1] or 0

-- Reskin entities, create and assign extra details
for name, options in pairs(entities) do
	local entity = data.raw[TYPE][name]
	if not entity then
		goto continue
	end

	local tier = _framework.tiers.get_tier(options)
	local tint = _framework.tiers.get_tint(tier)

	-- Calculate new animation playback speed
	local speed
	if max_speed - min_speed == 0 then
		speed = entity.mining_speed
	else
		speed = (((entity.mining_speed / (max_speed - min_speed)) - (min_speed / (max_speed - min_speed))) * max_playback)
			+ ((max_speed / (max_speed - min_speed)) - (entity.mining_speed / (max_speed - min_speed))) * min_playback
	end

	local sprite_set = MiningDrillElectricOriginal.get_sprite_set({
		tint = tint,
		belt_output = options.is_area_drill and "blue" or nil,
		animation_speed = speed,
	})
	Applicators.apply_sprite_set(entity, sprite_set)

	local icon_assignment
	if options.is_area_drill then
		local composition = MiningDrillElectricOriginal.get_area_icon_composition({ tint = tint })
			:add_symbol(_assets.icons.get_symbol(_assets.defines.symbol.area_drill, tint))

		icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
			tier = tier,
			name = entity.name,
			type_name = entity.type,
			composition = composition,
		})
	else
		icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
			tier = tier,
			name = entity.name,
			type_name = entity.type,
			composition = MiningDrillElectricOriginal.get_icon_composition({ tint = tint }),
		})
	end
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	::continue::
end
