-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["miniloader"] then
	return
end
if reskins.bobs and (reskins.bobs.triggers.logistics.entities == false) then
	return
end

-- Set input parameters
local inputs = {
	icon_name = "miniloader",
	base_entity_name = "splitter",
	mod = "compatibility",
	group = "miniloader",
	particles = { ["medium"] = 1, ["big"] = 4 },
	technology_icon_size = 256,
	make_remnants = false,
}

-- Handle belt tier labels
inputs.tier_labels = reskins.lib.settings.get_value("reskins-bobs-do-belt-entity-tier-labeling") and true or false

local tier_map = {
	-- 1x1 Loader Entities
	["basic-miniloader-loader"] = { tier = 0, sprite_variant = 1, base_belt = "bob-basic-transport-belt" },
	["chute-miniloader-loader"] = { tier = 0, sprite_variant = 1, base_belt = "transport-belt" },
	["miniloader-loader"] = { tier = 1, sprite_variant = 1, base_belt = "transport-belt" },
	["fast-miniloader-loader"] = { tier = 2, sprite_variant = 2, base_belt = "fast-transport-belt" },
	["express-miniloader-loader"] = { tier = 3, sprite_variant = 2, base_belt = "express-transport-belt" },
	["turbo-miniloader-loader"] = { tier = 4, sprite_variant = 2, base_belt = "bob-turbo-transport-belt" },
	["ultimate-miniloader-loader"] = { tier = 5, sprite_variant = 2, base_belt = "bob-ultimate-transport-belt" },
	["filter-miniloader-loader"] = { tier = 1, sprite_variant = 1, is_filter = true, base_belt = "transport-belt" },
	["fast-filter-miniloader-loader"] = { tier = 2, sprite_variant = 2, is_filter = true, base_belt = "fast-transport-belt" },
	["express-filter-miniloader-loader"] = { tier = 3, sprite_variant = 2, is_filter = true, base_belt = "express-transport-belt" },
	["turbo-filter-miniloader-loader"] = { tier = 4, sprite_variant = 2, is_filter = true, base_belt = "bob-turbo-transport-belt" },
	["ultimate-filter-miniloader-loader"] = { tier = 5, sprite_variant = 2, is_filter = true, base_belt = "bob-ultimate-transport-belt" },

	-- Inserter Entities
	["basic-miniloader-inserter"] = { tier = 0, is_inserter = true },
	["chute-miniloader-inserter"] = { tier = 0, is_inserter = true },
	["miniloader-inserter"] = { tier = 1, is_inserter = true },
	["fast-miniloader-inserter"] = { tier = 2, is_inserter = true },
	["express-miniloader-inserter"] = { tier = 3, is_inserter = true },
	["turbo-miniloader-inserter"] = { tier = 4, is_inserter = true },
	["ultimate-miniloader-inserter"] = { tier = 5, is_inserter = true },
	["filter-miniloader-inserter"] = { tier = 1, is_inserter = true, is_filter = true },
	["fast-filter-miniloader-inserter"] = { tier = 2, is_inserter = true, is_filter = true },
	["express-filter-miniloader-inserter"] = { tier = 3, is_inserter = true, is_filter = true },
	["turbo-filter-miniloader-inserter"] = { tier = 4, is_inserter = true, is_filter = true },
	["ultimate-filter-miniloader-inserter"] = { tier = 5, is_inserter = true, is_filter = true },
}

local item_map = {
	["basic-miniloader"] = { tier = 0 },
	["chute-miniloader"] = { tier = 0 },
	["miniloader"] = { tier = 1 },
	["fast-miniloader"] = { tier = 2 },
	["express-miniloader"] = { tier = 3 },
	["turbo-miniloader"] = { tier = 4 },
	["ultimate-miniloader"] = { tier = 5 },
	["filter-miniloader"] = { tier = 1, icon_base = "filter-miniloader" },
	["fast-filter-miniloader"] = { tier = 2, icon_base = "filter-miniloader" },
	["express-filter-miniloader"] = { tier = 3, icon_base = "filter-miniloader" },
	["turbo-filter-miniloader"] = { tier = 4, icon_base = "filter-miniloader" },
	["ultimate-filter-miniloader"] = { tier = 5, icon_base = "filter-miniloader" },
}

-- Reskin entities
for name, map in pairs(tier_map) do
	if map.is_inserter then
		inputs.type = "inserter"
		inputs.make_explosions = true
	else
		inputs.type = "loader-1x1"
		inputs.make_explosions = false
	end

	---@type data.InserterPrototype|data.Loader1x1Prototype
	local entity = data.raw[inputs.type][name]
	local base_belt = data.raw["transport-belt"][map.base_belt]
	if not entity then
		goto continue
	end
	inputs.tint = reskins.lib.tiers.get_belt_tint(map.tier)

	reskins.lib.setup_standard_entity(name, map.tier, inputs)

	-- Retint the mask
	if map.is_inserter then
		---@cast entity data.InserterPrototype
		local base_path = map.is_filter and "filter-inserter" or "inserter"

		entity.corpse = "small-remnants"
		entity.platform_picture.sheets = {
			-- Base
			{
				filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-" .. base_path .. "-base.png",
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 192,
			},
			-- Mask
			{
				filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-structure-mask.png",
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 192,
				tint = inputs.tint,
			},
			-- Highlights
			{
				filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-structure-highlights.png",
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 192,
				blend_mode = "additive",
			},
			-- Shadow
			{
				filename = "__miniloader__/graphics/entity/hr-miniloader-structure-shadow.png",
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 192,
				draw_as_shadow = true,
			},
		}
	else
		---@cast entity data.Loader1x1Prototype
		local base_path = map.is_filter and "filter-structure" or "structure"

		entity.structure.direction_in.sheets = {
			-- Base
			{
				filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-" .. base_path .. "-base.png",
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 0,
			},
			-- Mask
			{
				filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-structure-mask.png",
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 0,
				tint = inputs.tint,
			},
			-- Highlights
			{
				filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-structure-highlights.png",
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 0,
				blend_mode = "additive",
			},
			-- Shadow
			{
				filename = "__miniloader__/graphics/entity/hr-miniloader-structure-shadow.png",
				draw_as_shadow = true,
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 0,
			},
		}

		entity.structure.direction_out.sheets = {
			-- Base
			{
				filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-" .. base_path .. "-base.png",
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 192,
			},
			-- Mask
			{
				filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-structure-mask.png",
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 192,
				tint = inputs.tint,
			},
			-- Highlights
			{
				filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-structure-highlights.png",
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 192,
				blend_mode = "additive",
			},
			-- Shadow
			{
				filename = "__miniloader__/graphics/entity/hr-miniloader-structure-shadow.png",
				height = 192,
				priority = "extra-high",
				scale = 0.5,
				width = 192,
				y = 192,
				draw_as_shadow = true,
			},
		}

		-- Apply belt set
		entity.belt_animation_set = base_belt and base_belt.belt_animation_set
	end

	::continue::
end

-- Reskin icons
for name, map in pairs(item_map) do
	-- Fetch item
	local item = data.raw["item"][name]

	-- Check if item exists, if not, skip this iteration
	if not item then
		goto continue
	end

	-- Setup icon details
	inputs.icon_base = map.icon_base or "miniloader"
	inputs.tint = reskins.lib.tiers.get_belt_tint(map.tier)

	reskins.lib.construct_icon(name, map.tier, inputs)

	-- Handle grouping and ordering in the UI
	local base_item
	if name ~= "chute-miniloader" then
		base_item = data.raw["item"][string.gsub(string.gsub(name, "filter%-", ""), "miniloader", "transport-belt")]
	elseif data.raw["item"]["bob-basic-transport-belt"] then
		base_item = data.raw["item"]["bob-basic-transport-belt"]
	end

	if base_item then
		inputs.sort_order = string.gsub(string.gsub(item.order, "^[a-z]", "d"), "transport%-belt", "miniloader")
		inputs.sort_group = base_item.group
		inputs.sort_subgroup = base_item.subgroup

		if string.find(name, "filter") then
			inputs.sort_order = string.gsub(inputs.sort_order, "filter", "n-filter")
		elseif name == "chute-miniloader" then
			inputs.sort_order = string.gsub(inputs.sort_order, "miniloader", "z-miniloader")
		end

		reskins.lib.assign_order(name, inputs)
	end

	::continue::
end

-- Technologies
local technology_map = {
	["basic-miniloader"] = 0,
	["miniloader"] = 1,
	["fast-miniloader"] = 2,
	["express-miniloader"] = 3,
	["turbo-miniloader"] = 4,
	["ultimate-miniloader"] = 5,
}

-- Reskin technologies
for name, tier in pairs(technology_map) do
	-- Fetch technology
	local technology = data.raw["technology"][name]
	if not technology then
		goto continue
	end

	-- Fix inputs
	inputs.icon_base = nil
	inputs.tint = reskins.lib.tiers.get_belt_tint(tier)

	reskins.lib.construct_technology_icon(name, inputs)

	::continue::
end
