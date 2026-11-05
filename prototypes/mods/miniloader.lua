-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not (mods["miniloader-redux"] or mods["loaders-modernized"]) then
	return
end
if reskins.bobs and (reskins.bobs.triggers.logistics.entities == false) then
	return
end

local _framework = {
	tiers = require("__reskins-framework__.api.tiers"),
}

local is_modern_using_aai_graphics = reskins.lib.settings.get_value("mdrn-use-aai-graphics") == true

-- Set input parameters
local inputs = {
	type = "loader-1x1",
	icon_name = "miniloader",
	base_entity_name = "splitter",
	mod = "compatibility",
	group = "miniloader",
	particles = { ["medium"] = 1, ["big"] = 4 },
	technology_icon_size = 256,
	make_explosions = false,
	make_remnants = false,
}

-- Handle belt tier labels
inputs.tier_labels = _framework.tiers.show_labels_on_belts

-- Miniloader (Redux) draws each miniloader with an inserter, which has the name of the item, and with three loaders.
local miniloader_redux_loader_suffixes = { "-l", "-turbo-l", "-turbo-lf-l" }

-- Loaders Modernized makes a split lane, a fill, and a split lane fill variant of each loader.
local loaders_modernized_loader_suffixes = { "", "-split", "-fill", "-split-fill" }

--stylua: ignore start
local tier_map = {
	-- Miniloader (Redux)
	["hps__ml-bob-basic-miniloader"] = { tier = 0, sprite_variant = 1, base_belt = "bob-basic-transport-belt", loader_suffixes = miniloader_redux_loader_suffixes },
	["hps__ml-miniloader"] = { tier = 1, sprite_variant = 1, base_belt = "transport-belt", loader_suffixes = miniloader_redux_loader_suffixes },
	["hps__ml-fast-miniloader"] = { tier = 2, sprite_variant = 2, base_belt = "fast-transport-belt", loader_suffixes = miniloader_redux_loader_suffixes },
	["hps__ml-express-miniloader"] = { tier = 3, sprite_variant = 2, base_belt = "express-transport-belt", loader_suffixes = miniloader_redux_loader_suffixes },
	["hps__ml-turbo-miniloader"] = { tier = 4, sprite_variant = 2, base_belt = "turbo-transport-belt", loader_suffixes = miniloader_redux_loader_suffixes },
	["hps__ml-bob-ultimate-miniloader"] = { tier = 5, sprite_variant = 2, base_belt = "bob-ultimate-transport-belt", loader_suffixes = miniloader_redux_loader_suffixes },

	-- Loaders Modernized
	["mdrn-chute-loader"] = { tier = 0, sprite_variant = 1, loader_suffixes = loaders_modernized_loader_suffixes },
	["mdrn-basic-loader"] = { tier = 0, sprite_variant = 1, base_belt = "bob-basic-transport-belt", loader_suffixes = loaders_modernized_loader_suffixes },
	["mdrn-loader"] = { tier = 1, sprite_variant = 1, base_belt = "transport-belt", loader_suffixes = loaders_modernized_loader_suffixes },
	["mdrn-fast-loader"] = { tier = 2, sprite_variant = 2, base_belt = "fast-transport-belt", loader_suffixes = loaders_modernized_loader_suffixes },
	["mdrn-express-loader"] = { tier = 3, sprite_variant = 2, base_belt = "express-transport-belt", loader_suffixes = loaders_modernized_loader_suffixes },
	["mdrn-turbo-loader"] = { tier = 4, sprite_variant = 2, base_belt = "turbo-transport-belt", loader_suffixes = loaders_modernized_loader_suffixes },
	["mdrn-ultimate-loader"] = { tier = 5, sprite_variant = 2, base_belt = "bob-ultimate-transport-belt", loader_suffixes = loaders_modernized_loader_suffixes },
}
--stylua: ignore end

-- Add the loader entities of each loader.
local loader_map = {}
for name, map in pairs(tier_map) do
	for _, suffix in pairs(map.loader_suffixes) do
		loader_map[name .. suffix] = map
	end
end

local item_map = {
	-- Miniloaders (Redux)
	-- The entity with the name of the item is an inserter.
	["hps__ml-bob-basic-miniloader"] = { tier = 0, base_item = "bob-basic-transport-belt", type = "inserter" },
	["hps__ml-miniloader"] = { tier = 1, base_item = "transport-belt", type = "inserter" },
	["hps__ml-fast-miniloader"] = { tier = 2, base_item = "fast-transport-belt", type = "inserter" },
	["hps__ml-express-miniloader"] = { tier = 3, base_item = "express-transport-belt", type = "inserter" },
	["hps__ml-turbo-miniloader"] = { tier = 4, base_item = "turbo-transport-belt", type = "inserter" },
	["hps__ml-bob-ultimate-miniloader"] = { tier = 5, base_item = "bob-ultimate-transport-belt", type = "inserter" },

	-- Loaders Modernized
	["mdrn-chute-loader"] = { tier = 0, base_item = "bob-basic-transport-belt" },
	["mdrn-basic-loader"] = { tier = 0, base_item = "bob-basic-transport-belt" },
	["mdrn-loader"] = { tier = 1, base_item = "transport-belt" },
	["mdrn-fast-loader"] = { tier = 2, base_item = "fast-transport-belt" },
	["mdrn-express-loader"] = { tier = 3, base_item = "express-transport-belt" },
	["mdrn-turbo-loader"] = { tier = 4, base_item = "turbo-transport-belt" },
	["mdrn-ultimate-loader"] = { tier = 5, base_item = "bob-ultimate-transport-belt" },
}

---Gets the layers of the given `icons` that mark a variant of a loader of Loaders Modernized.
---@param icons? data.IconData[]
---@return data.IconData[]
local function get_variant_marks(icons)
	local marks = {}
	for _, icon_datum in pairs(icons or {}) do
		if icon_datum.icon:find("^__loaders%-modernized__/graphics/icon/") then
			table.insert(marks, icon_datum)
		end
	end

	return marks
end

-- Reskin entities
for name, map in pairs(loader_map) do
	if name:find("mdrn") and is_modern_using_aai_graphics then
		goto continue
	end

	---@type data.Loader1x1Prototype
	local entity = data.raw[inputs.type][name]
	local base_belt = data.raw["transport-belt"][map.base_belt]
	if not entity then
		goto continue
	end
	inputs.tint = reskins.lib.tiers.get_belt_tint(map.tier)

	-- Keep the layers that mark the loader variants.
	inputs.icon_extras = get_variant_marks(entity.icons)

	reskins.lib.setup_standard_entity(name, map.tier, inputs)

	-- Retint the mask
	entity.structure.direction_in.sheets = {
		-- Base
		{
			filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-structure-base.png",
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
			filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-structure-shadow.png",
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
			filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-structure-base.png",
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
			filename = "__reskins-compatibility__/graphics/entity/miniloader/miniloader/miniloader-structure-shadow.png",
			height = 192,
			priority = "extra-high",
			scale = 0.5,
			width = 192,
			y = 192,
			draw_as_shadow = true,
		},
	}

	-- Apply belt set
	if base_belt then
		entity.belt_animation_set = base_belt.belt_animation_set
	end

	::continue::
end

inputs.icon_extras = nil

-- The inserter of each Miniloader (Redux) draws the structure of its loaders.
for name, _ in pairs(tier_map) do
	local inserter = data.raw["inserter"][name]
	local loader = data.raw["loader-1x1"][name .. "-l"]
	if inserter and loader then
		inserter.platform_picture.sheets = util.copy(loader.structure.direction_in.sheets)
	end
end

-- Reskin icons
for name, map in pairs(item_map) do
	if name:find("mdrn") and is_modern_using_aai_graphics then
		goto continue
	end

	-- Fetch item
	local item = data.raw["item"][name]

	-- Check if item exists, if not, skip this iteration
	if not item then
		goto continue
	end

	-- Setup icon details
	inputs.type = map.type
	inputs.icon_base = "miniloader"
	inputs.tint = reskins.lib.tiers.get_belt_tint(map.tier)

	reskins.lib.construct_icon(name, map.tier, inputs)

	-- Handle grouping and ordering in the UI
	local base_item = map.base_item and data.raw["item"][map.base_item] or nil
	if not base_item then
		base_item = data.raw["item"][string.gsub(name, "miniloader", "transport-belt")]
	end

	if base_item then
		inputs.sort_order = string.gsub(string.gsub(item.order, "^[a-z]", "d"), "transport%-belt", "miniloader")
		inputs.sort_group = base_item.group
		inputs.sort_subgroup = base_item.subgroup

		reskins.lib.assign_order(name, inputs)
	end

	::continue::
end

-- Technologies
local technology_map = {
	-- Miniloader (Redux)
	["hps__ml-bob-basic-miniloader"] = { tier = 0 },
	["hps__ml-miniloader"] = { tier = 1 },
	["hps__ml-fast-miniloader"] = { tier = 2 },
	["hps__ml-express-miniloader"] = { tier = 3 },
	["hps__ml-turbo-miniloader"] = { tier = 4 },
	["hps__ml-bob-ultimate-miniloader"] = { tier = 5 },

	-- Loaders Modernized
	["mdrn-basic-loader"] = { tier = 0 },
	["mdrn-loader"] = { tier = 1 },
	["mdrn-fast-loader"] = { tier = 2 },
	["mdrn-express-loader"] = { tier = 3 },
	["mdrn-turbo-loader"] = { tier = 4 },
	["mdrn-ultimate-loader"] = { tier = 5 },
}

-- Reskin technologies
for name, map in pairs(technology_map) do
	if name:find("mdrn") and is_modern_using_aai_graphics then
		goto continue
	end

	-- Fetch technology
	local technology = data.raw["technology"][name]
	if not technology then
		goto continue
	end

	-- Fix inputs
	inputs.icon_base = nil
	inputs.tint = reskins.lib.tiers.get_belt_tint(map.tier)

	reskins.lib.construct_technology_icon(name, inputs)

	::continue::
end
