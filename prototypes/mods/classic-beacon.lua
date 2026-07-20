-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

---@using data

-- Check to see if reskinning needs to be done.
if not mods["classic-beacon"] then
	return
end
if not (reskins.bobs and reskins.bobs.triggers.modules.entities) then
	return
end

-- Flag available for Mini-Machines compatibility pass
if reskins.compatibility then
	reskins.compatibility.triggers.minimachines.beacons = true
end

---@param tint Color
---@return BeaconGraphicsSet
---@nodiscard
local function get_classic_graphics_set(tint)
	---@type BeaconGraphicsSet
	return {
		module_icons_suppressed = false,
		animation_list = {
			{
				render_layer = "lower-object-above-shadow",
				always_draw = true,
				animation = {
					layers = {
						{
							filename = "__classic-beacon__/graphics/entity/beacon/beacon-base.png",
							width = 116,
							height = 93,
							shift = util.by_pixel(11, 1.5),
						},
						{
							filename = "__reskins-compatibility__/graphics/entity/classic-beacon/beacon/beacon-mask.png",
							width = 116,
							height = 93,
							shift = util.by_pixel(11, 1.5),
							tint = tint,
						},
						{
							filename = "__reskins-compatibility__/graphics/entity/classic-beacon/beacon/beacon-highlights.png",
							width = 116,
							height = 93,
							blend_mode = "additive-soft",
							shift = util.by_pixel(11, 1.5),
						},
						{
							filename = "__classic-beacon__/graphics/entity/beacon/beacon-base-shadow.png",
							width = 116,
							height = 93,
							draw_as_shadow = true,
							shift = util.by_pixel(11, 1.5),
						},
					},
				},
			},
			{
				render_layer = "object",
				always_draw = true,
				animation = {
					layers = {
						{
							filename = "__classic-beacon__/graphics/entity/beacon/beacon-antenna.png",
							width = 54,
							height = 50,
							line_length = 8,
							frame_count = 32,
							animation_speed = 0.5,
							shift = util.by_pixel(-1, -55),
						},
						{
							filename = "__classic-beacon__/graphics/entity/beacon/beacon-antenna-shadow.png",
							width = 63,
							height = 49,
							line_length = 8,
							frame_count = 32,
							animation_speed = 0.5,
							draw_as_shadow = true,
							shift = util.by_pixel(100.5, 15.5),
						},
					},
				},
			},
		},
	}
end

---@param tint Color
---@return BeaconGraphicsSet
---@nodiscard
local function get_upscaled_graphics_set(tint)
	---@type data.BeaconGraphicsSet
	return {
		module_icons_suppressed = false,
		animation_list = {
			{
				render_layer = "lower-object-above-shadow",
				always_draw = true,
				animation = {
					layers = {
						{
							filename = "__classic-beacon__/graphics/entity/beacon/upscale-beacon-base.png",
							width = 232,
							height = 186,
							shift = util.by_pixel(11, 1.5),
							scale = 0.5,
						},
						{
							filename = "__reskins-compatibility__/graphics/entity/classic-beacon/beacon/upscale-beacon-mask.png",
							width = 232,
							height = 186,
							tint = tint,
							shift = util.by_pixel(11, 1.5),
							scale = 0.5,
						},
						{
							filename = "__reskins-compatibility__/graphics/entity/classic-beacon/beacon/upscale-beacon-highlights.png",
							width = 232,
							height = 186,
							blend_mode = "additive-soft",
							shift = util.by_pixel(11, 1.5),
							scale = 0.5,
						},
						{
							filename = "__classic-beacon__/graphics/entity/beacon/upscale-beacon-base-shadow.png",
							width = 232,
							height = 186,
							draw_as_shadow = true,
							shift = util.by_pixel(11, 1.5),
							scale = 0.5,
						},
					},
				},
			},
			{
				render_layer = "object",
				always_draw = true,
				animation = {
					layers = {
						{
							filename = "__classic-beacon__/graphics/entity/beacon/upscale-beacon-antenna.png",
							width = 108,
							height = 100,
							line_length = 8,
							frame_count = 32,
							animation_speed = 0.5,
							shift = util.by_pixel(-1, -55),
							scale = 0.5,
						},
						{
							filename = "__classic-beacon__/graphics/entity/beacon/upscale-beacon-antenna-shadow.png",
							width = 126,
							height = 98,
							line_length = 8,
							frame_count = 32,
							animation_speed = 0.5,
							draw_as_shadow = true,
							shift = util.by_pixel(100.5, 15.5),
							scale = 0.5,
						},
					},
				},
			},
		},
	}
end

-- Set input parameters
local inputs = {
	type = "beacon",
	icon_name = "beacon",
	base_entity_name = "beacon",
	mod = "compatibility",
	group = "classic-beacon",
	particles = { ["small"] = 3 },
	make_remnants = false,
}

local tier_map = {
	["beacon"] = { tier = 1, prog_tier = 3 },
	["bob-beacon-2"] = { tier = 2, prog_tier = 4 },
	["bob-beacon-3"] = { tier = 3, prog_tier = 5 },
}

-- Reskin entities, create and assign extra details
for name, map in pairs(tier_map) do
	---@type data.BeaconPrototype
	local entity = data.raw[inputs.type][name]
	if not entity then
		goto continue
	end

	-- Fix order shenanigans
	if name == "beacon" then
		data.raw["item"][name].order = "a[beacon]-1"
		entity.order = "z-a[beacon]-1"
	end

	local tier = reskins.lib.tiers.get_tier(map)
	inputs.tint = reskins.lib.tiers.get_tint(tier)

	reskins.lib.setup_standard_entity(name, tier, inputs)

	local use_upscaled = reskins.lib.settings.get_value("classic-beacon-do-high-res") == true
	entity.corpse = "medium-remnants"
	entity.graphics_set = use_upscaled and get_upscaled_graphics_set(inputs.tint) or get_classic_graphics_set(inputs.tint)
	entity.water_reflection = {
		pictures = {
			filename = "__classic-beacon__/graphics/entity/beacon/beacon-reflection.png",
			priority = "extra-high",
			width = 24,
			height = 28,
			shift = util.by_pixel(0, 55),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}

	::continue::
end
