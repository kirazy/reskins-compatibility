-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

---@using data
---@using Reskins.SpriteUtils

-- Check to see if reskinning needs to be done.
if not mods["deadlock-beltboxes-loaders-continued"] then
	return
end
if mods["ScienceCostTweakerM"] then
	return
end

local _sprite_utils = {
	icons = require("__reskins-sprite-utils__.icons"),
}

local StackedSciencePacks = require("__reskins-assets-api__.assets.assorted.items.stacked-science-packs")
local StackedSciencePacksAlien = require("__reskins-assets-api__.assets.assorted.items.stacked-science-packs-alien")

---@type IconData[]
local recipe_stack_icon_extras = {
	{
		icon = "__deadlock-beltboxes-loaders-continued__/graphics/icons/square/arrow-d-64.png",
		icon_size = 64,
		scale = 0.25,
	},
}

---@type IconData[]
local recipe_unstack_icon_extras = {
	{
		icon = "__deadlock-beltboxes-loaders-continued__/graphics/icons/square/arrow-u-64.png",
		icon_size = 64,
		scale = 0.25,
	},
}

---@type table<string, IconComposition>
local science_packs = {
	["automation-science-pack"] = StackedSciencePacks.get_icon_composition({ science_pack = "automation-science-pack" }),
	["logistic-science-pack"] = StackedSciencePacks.get_icon_composition({ science_pack = "logistic-science-pack" }),
	["chemical-science-pack"] = StackedSciencePacks.get_icon_composition({ science_pack = "chemical-science-pack" }),
	["production-science-pack"] = StackedSciencePacks.get_icon_composition({ science_pack = "production-science-pack" }),
	["utility-science-pack"] = StackedSciencePacks.get_icon_composition({ science_pack = "utility-science-pack" }),
	["bob-advanced-logistic-science-pack"] = StackedSciencePacks.get_icon_composition({
		science_pack = "advanced-logistic-science-pack",
	}),
	["military-science-pack"] = StackedSciencePacks.get_icon_composition({ science_pack = "military-science-pack" }),
	["space-science-pack"] = StackedSciencePacks.get_icon_composition({ science_pack = "space-science-pack" }),
	["bob-alien-science-pack"] = StackedSciencePacksAlien.get_icon_composition(),
	["bob-alien-science-pack-blue"] = StackedSciencePacksAlien.get_colored_icon_composition({ color = "blue" }),
	["bob-alien-science-pack-orange"] = StackedSciencePacksAlien.get_colored_icon_composition({ color = "orange" }),
	["bob-alien-science-pack-purple"] = StackedSciencePacksAlien.get_colored_icon_composition({ color = "purple" }),
	["bob-alien-science-pack-yellow"] = StackedSciencePacksAlien.get_colored_icon_composition({ color = "yellow" }),
	["bob-alien-science-pack-green"] = StackedSciencePacksAlien.get_colored_icon_composition({ color = "green" }),
	["bob-alien-science-pack-red"] = StackedSciencePacksAlien.get_colored_icon_composition({ color = "red" }),
	["bob-science-pack-gold"] = StackedSciencePacks.get_icon_composition({ science_pack = "science-pack-gold" }),
}

---@type table<string, IconDefinition>
local stacking_items = {}

---@type table<string, IconDefinition>
local stacking_recipes = {}

for name, composition in pairs(science_packs) do
	-- Setup working items
	local item_name = "deadlock-stack-" .. name
	local recipe_stack_name = "deadlock-stacks-stack-" .. name
	local recipe_unstack_name = "deadlock-stacks-unstack-" .. name

	-- Check if item exists, if not, skip this iteration
	if not data.raw.item[item_name] then
		goto continue
	end

	-- Add items and recipes to list
	stacking_items[item_name] = { composition = composition }
	stacking_recipes[recipe_stack_name] = { composition = composition, label = recipe_stack_icon_extras }
	stacking_recipes[recipe_unstack_name] = { composition = composition, label = recipe_unstack_icon_extras }

	::continue::
end

_sprite_utils.icons.assign_icons("item", stacking_items)
_sprite_utils.icons.assign_icons("recipe", stacking_recipes)
