-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["black-rubber-belts-remastered"] then
	return
end

local _framework = {
	tiers = require("__reskins-framework__.api.tiers"),
}
local _sprite_utils = {
	icons = require("__reskins-sprite-utils__.icons"),
}

local actions = require("__black-rubber-belts-remastered__.code.functions")

-- Black Rubber Belts styles every belt from these startup settings.
local is_using_alternate_bases = settings.startup["rail-style"].value == "ir3-alt"
local is_using_colored_rails = settings.startup["rail-style"].value == "colored"
local arrow_style = settings.startup["arrow-style"].value
local tier_style = settings.startup["tier-style"].value
local stripe_style = settings.startup["stripe-style"].value
local arrow_glow = settings.startup["arrow-glow"].value
local rail_glow = settings.startup["rail-glow"].value
local stripe_glow = settings.startup["stripe-glow"].value

-- The arrows are drawn in a dark tint over the stripes of the "stripe-thick" and "full-paint" stripe styles.
---@type data.Color?
local arrow_tint = (stripe_style == "stripe-thick" or stripe_style == "full-paint")
		and { r = 0.18, g = 0.18, b = 0.18, a = 1 }
	or nil

local inputs = {
	type = "transport-belt",
}

-- The `base` material and the arrows of each belt are those that Black Rubber Belts gives the belt.
--stylua: ignore start
local tier_map = {
	["bob-basic-transport-belt"] = { tier = 0, base = is_using_alternate_bases and "iron" or "steel", arrows = "single", underground_belt = "bob-basic-underground-belt", splitter = "bob-basic-splitter" },
	["transport-belt"] = { tier = 1, base = is_using_alternate_bases and "copper" or "steel", arrows = "single", underground_belt = "underground-belt", splitter = "splitter" },
	["fast-transport-belt"] = { tier = 2, base = is_using_alternate_bases and "iron" or "steel", arrows = "doubled", underground_belt = "fast-underground-belt", splitter = "fast-splitter" },
	["express-transport-belt"] = { tier = 3, base = "steel", arrows = "doubled", underground_belt = "express-underground-belt", splitter = "express-splitter" },
	["turbo-transport-belt"] = { tier = 4, base = is_using_alternate_bases and not mods["boblogistics"] and "tungsten" or "steel", arrows = "quadrupled", underground_belt = "turbo-underground-belt", splitter = "turbo-splitter" },
	["bob-ultimate-transport-belt"] = { tier = 5, base = "steel", arrows = "quadrupled", underground_belt = "bob-ultimate-underground-belt", splitter = "bob-ultimate-splitter" },
}
--stylua: ignore end

---Gets the icon layer of Black Rubber Belts for the given `name`.
---@param name string The name of the icon file, without extension.
---@param tint? data.Color The tint of the layer, if any.
---@return data.IconData
local function get_icon_layer(name, tint)
	return {
		icon = actions.get_icon_path(name),
		icon_size = 64,
		scale = 0.5,
		tint = tint,
	}
end

-- Reskin entities
for name, map in pairs(tier_map) do
	---@type data.TransportBeltPrototype
	local entity = data.raw[inputs.type][name]
	if not entity then
		goto continue
	end
	inputs.tint = _framework.tiers.get_tint(map.tier)

	---@type data.IconData[]
	local base_icon_data = { get_icon_layer("rubber-belt-" .. map.base) }

	if stripe_style ~= "no-stripe" then
		table.insert(base_icon_data, get_icon_layer("rubber-belt-mask-" .. stripe_style, inputs.tint))
	end

	if arrow_style ~= "no-arrows" then
		table.insert(base_icon_data, get_icon_layer("rubber-belt-mask", arrow_tint or inputs.tint))
	end

	if is_using_colored_rails then
		table.insert(base_icon_data, get_icon_layer("rubber-rail-mask", inputs.tint))
	end

	local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
		tier = map.tier,
		name = name,
		type_name = "transport-belt",
		icon_data = base_icon_data,
	})
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	-- Reskin entity
	local arrows = arrow_style .. "-" .. (tier_style == "tier-based" and map.arrows or tier_style)
	entity.belt_animation_set.animation_set =
		actions.get_belt_animation_set(inputs.tint, map.base, arrows, stripe_style, arrow_glow, rail_glow, stripe_glow)

	-- Share the belt animation set with the underground belt and the splitter of the tier. In the tiers that Artisanal
	-- Reskins: Bob's Mods reskins, each of them has a copy of the belt animation set.
	for _, connectable in pairs({
		data.raw["underground-belt"][map.underground_belt],
		data.raw["splitter"][map.splitter],
	}) do
		connectable.belt_animation_set = entity.belt_animation_set
	end

	::continue::
end
