-- cspell: words mdrn

-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

local _framework = {
	settings = require("__reskins-framework__.api.settings"),
	tiers = require("__reskins-framework__.api.tiers"),
}
local _sprite_utils = { icons = require("__reskins-sprite-utils__.icons") }

local _defines = require("__reskins-assets-api__.api.defines")
local VanillaLoader1x1 = require("__reskins-assets-api__.assets.assorted.entities.vanilla-loader-1x1")
local VanillaLoader1x1Technology = require("__reskins-assets-api__.assets.assorted.technologies.vanilla-loader-1x1")

local is_modern_using_aai_graphics = _framework.settings.get_value("mdrn-use-aai-graphics") == true

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

---Gets the layers of the given `icons` that mark the variant of the loader from Loaders Modernized.
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

for name, map in pairs(loader_map) do
	if name:find("mdrn") and is_modern_using_aai_graphics then
		goto continue
	end

	---@type data.Loader1x1Prototype
	local entity = data.raw["loader-1x1"][name]
	local base_belt = data.raw["transport-belt"][map.base_belt]
	if not entity then
		goto continue
	end

	local tint = _framework.tiers.get_tint(map.tier)

	-- Keep the layers that mark the loader variants.
	local icon_data = VanillaLoader1x1.get_icon({ tint = tint })
	for _, mark in pairs(get_variant_marks(entity.icons)) do
		table.insert(icon_data, mark)
	end

	-- Replace the structure in each direction. The loader keeps its patches, corpse, and dying explosion.
	local sprite_set =
		VanillaLoader1x1.get_sprite_set({ tint = tint, belt_sprite = _defines.get_belt_sprites(entity.speed) })
	entity.structure.direction_in = sprite_set.set.structure.direction_in
	entity.structure.direction_out = sprite_set.set.structure.direction_out

	-- Apply belt set
	if base_belt then
		entity.belt_animation_set = base_belt.belt_animation_set
	end

	local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
		tier = map.tier,
		name = entity.name,
		type_name = entity.type,
		icon_data = icon_data,
	})
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	::continue::
end

-- The inserter of each Miniloader (Redux) draws the structure of its loaders.
for name, _ in pairs(tier_map) do
	local inserter = data.raw["inserter"][name]
	local loader = data.raw["loader-1x1"][name .. "-l"]
	if inserter and loader then
		inserter.platform_picture.sheets = util.copy(loader.structure.direction_in.sheets)
	end
end

for name, map in pairs(item_map) do
	if name:find("mdrn") and is_modern_using_aai_graphics then
		goto continue
	end

	local item = data.raw["item"][name]
	if not item then
		goto continue
	end

	-- Tier labels on belt-like items when set via the type directly are not caught and must be handled special.
	local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
		tier = _framework.tiers.show_labels_on_belts and map.tier or 0,
		name = name,
		type_name = map.type or "item",
		icon_data = VanillaLoader1x1.get_icon({ tint = _framework.tiers.get_tint(map.tier) }),
	})
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	-- Handle grouping and ordering in the UI
	local base_item = map.base_item and data.raw["item"][map.base_item] or nil
	if not base_item then
		base_item = data.raw["item"][string.gsub(name, "miniloader", "transport-belt")]
	end

	if base_item then
		local order = string.gsub(string.gsub(item.order, "^[a-z]", "d"), "transport%-belt", "miniloader")
		local entity = map.type and data.raw[map.type][name]

		for _, prototype in pairs({ entity, item }) do
			prototype.order = order
			prototype.subgroup = base_item.subgroup
		end
	end

	::continue::
end

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

for name, map in pairs(technology_map) do
	if name:find("mdrn") and is_modern_using_aai_graphics then
		goto continue
	end

	local technology = data.raw["technology"][name]
	if not technology then
		goto continue
	end

	_sprite_utils.icons.apply_icon_assignment({
		name = technology.name,
		type_name = technology.type,
		icon_data = VanillaLoader1x1Technology.get_icon({ tint = _framework.tiers.get_tint(map.tier) }),
	})

	::continue::
end
