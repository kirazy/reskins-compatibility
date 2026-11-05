-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

---@using Reskins.Library.Internal

-- Check to see if reskinning needs to be done.
if not mods["deadlock-beltboxes-loaders-continued"] then
	return
end
if mods["ScienceCostTweakerM"] then
	return
end
if not (reskins.bobs and reskins.bobs.triggers.technology.items) then
	return
end

---@type CreateIconsFromListInputs
local inputs = {
	mod = "compatibility",
	group = "deadlock-stacking",
	subgroup = "science-packs",
	icon_name = "stacked-science-pack",
	flat_icon = true,
	tier_labels = false,
}

---@type data.IconData[]
local recipe_stack_icon_extras = {
	{
		icon = "__deadlock-beltboxes-loaders-continued__/graphics/icons/square/arrow-d-64.png",
		icon_size = 64,
		scale = 0.25,
	},
}

---@type data.IconData[]
local recipe_unstack_icon_extras = {
	{
		icon = "__deadlock-beltboxes-loaders-continued__/graphics/icons/square/arrow-u-64.png",
		icon_size = 64,
		scale = 0.25,
	},
}

---@type CreateIconsFromListTable
local science_packs = {
	["automation-science-pack"] = {},
	["logistic-science-pack"] = {},
	["chemical-science-pack"] = {},
	["production-science-pack"] = {},
	["utility-science-pack"] = {},
	["bob-advanced-logistic-science-pack"] = { image = "stacked-advanced-logistic-science-pack" },
	["military-science-pack"] = {},
	["space-science-pack"] = {},
}

if reskins.lib.settings.get_value("bobmods-enemies-enablenewartifacts") == true then
	science_packs["bob-alien-science-pack"] = { image = "stacked-alien-science-pack" }
	science_packs["bob-alien-science-pack-blue"] = { image = "stacked-alien-science-pack-blue" }
	science_packs["bob-alien-science-pack-orange"] = { image = "stacked-alien-science-pack-orange" }
	science_packs["bob-alien-science-pack-purple"] = { image = "stacked-alien-science-pack-purple" }
	science_packs["bob-alien-science-pack-yellow"] = { image = "stacked-alien-science-pack-yellow" }
	science_packs["bob-alien-science-pack-green"] = { image = "stacked-alien-science-pack-green" }
	science_packs["bob-alien-science-pack-red"] = { image = "stacked-alien-science-pack-red" }
	science_packs["bob-science-pack-gold"] = { image = "stacked-science-pack-gold" }
end

---@type CreateIconsFromListTable
local stacking_items = {}

for name, map in pairs(science_packs) do
	-- Setup working items
	local item_name = "deadlock-stack-" .. name
	local recipe_stack_name = "deadlock-stacks-stack-" .. name
	local recipe_unstack_name = "deadlock-stacks-unstack-" .. name

	-- Check if item exists, if not, skip this iteration
	if not data.raw.item[item_name] then
		goto continue
	end

	---@type CreateIconsFromListOverrides
	local parameters = { image = map.image or ("stacked-" .. name) }

	-- Add items and recipes to list
	stacking_items[item_name] = util.copy(parameters)

	stacking_items[recipe_stack_name] = util.copy(parameters)
	stacking_items[recipe_stack_name].type = "recipe"
	stacking_items[recipe_stack_name].icon_extras = recipe_stack_icon_extras

	stacking_items[recipe_unstack_name] = util.copy(parameters)
	stacking_items[recipe_unstack_name].type = "recipe"
	stacking_items[recipe_unstack_name].icon_extras = recipe_unstack_icon_extras

	::continue::
end

reskins.internal.create_icons_from_list(stacking_items, inputs)
