-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["extendedangels"] then
	return
end
if not (reskins.angels and reskins.angels.triggers.bioprocessing.entities) then
	return
end

-- Set input parameters
local inputs = {
	type = "assembling-machine",
	icon_name = "nutrient-extractor",
	base_entity_name = "assembling-machine-1",
	mod = "compatibility",
	particles = { ["big"] = 1, ["medium"] = 2 },
	group = "extendedangels",
	make_remnants = false,
}

local tier_map = {
	["nutrient-extractor"] = { tier = 1 },
	["nutrient-extractor-2"] = { tier = 2 },
	["nutrient-extractor-3"] = { tier = 3 },
}

-- Adjust for changes in Extended Angels due to modifications to ingredients in Angel's Bioprocessing 0.7.23
if reskins.lib.version.is_same_or_newer(mods["extendedangels"], "0.5.8") then
	tier_map["nutrient-extractor"].prog_tier = 2
	tier_map["nutrient-extractor-2"].prog_tier = 3
	tier_map["nutrient-extractor-3"].prog_tier = 4
end

-- Reskin entities, create and assign extra details
for name, map in pairs(tier_map) do
	---@type data.AssemblingMachinePrototype
	local entity = data.raw[inputs.type][name]

	-- Check if entity exists, if not, skip this iteration
	if not entity then
		goto continue
	end

	-- Handle tier
	local tier = map.tier
	if reskins.lib.settings.get_value("reskins-lib-tier-mapping") == "progression-map" then
		tier = map.prog_tier or map.tier
	end

	-- Determine what tint we're using
	inputs.tint = map.tint or reskins.lib.tiers.get_tint(tier)

	reskins.lib.setup_standard_entity(name, tier, inputs)

	-- Reskin entities
	entity.graphics_set.animation = {
		layers = {
			-- Base
			{
				filename = "__angelsbioprocessinggraphics__/graphics/entity/nutrient-extractor/nutrient-extractor.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				frame_count = 25,
				line_length = 5,
				shift = { 0, 0 },
				animation_speed = 0.5,
			},
			-- Mask
			{
				filename = "__reskins-compatibility__/graphics/entity/extendedangels/nutrient-extractor/nutrient-extractor-mask.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				repeat_count = 25,
				shift = { 0, 0 },
				animation_speed = 0.5,
				tint = inputs.tint,
			},
			-- Highlights
			{
				filename = "__reskins-compatibility__/graphics/entity/extendedangels/nutrient-extractor/nutrient-extractor-highlights.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				repeat_count = 25,
				shift = { 0, 0 },
				animation_speed = 0.5,
				blend_mode = reskins.lib.settings.blend_mode,
			},
		},
	}

	-- Label to skip to next iteration
	::continue::
end
