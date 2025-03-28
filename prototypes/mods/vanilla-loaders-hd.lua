-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["vanilla-loaders-hd"] then
	return
end
if reskins.bobs and (reskins.bobs.triggers.logistics.entities == false) then
	return
end

-- Set input parameters
local inputs = {
	type = "loader",
	icon_name = "loader",
	base_entity_name = "splitter",
	mod = "compatibility",
	group = "vanilla-loaders-hd",
	particles = { ["medium"] = 1, ["big"] = 4 },
	make_remnants = false,
}

-- Handle belt tier labels
inputs.tier_labels = reskins.lib.settings.get_value("reskins-bobs-do-belt-entity-tier-labeling") and true or false

local tier_map = {
	["basic-loader"] = { tier = 0, set_type = reskins.lib.defines.belt_sprites.standard },
	["loader"] = { tier = 1, set_type = reskins.lib.defines.belt_sprites.standard },
	["fast-loader"] = { tier = 2, set_type = reskins.lib.defines.belt_sprites.express },
	["express-loader"] = { tier = 3, set_type = reskins.lib.defines.belt_sprites.express },
	["purple-loader"] = { tier = 4, set_type = reskins.lib.defines.belt_sprites.express },
	["green-loader"] = { tier = 5, set_type = reskins.lib.defines.belt_sprites.express },
}

-- Reskin entities
for name, map in pairs(tier_map) do
	---@type data.LoaderPrototype
	local entity = data.raw[inputs.type][name]

	-- Check if entity exists, if not, skip this iteration
	if not entity then
		goto continue
	end

	-- Determine what tint we're using
	inputs.tint = reskins.lib.tiers.get_belt_tint(map.tier)

	reskins.lib.setup_standard_entity(name, map.tier, inputs)

	-- Retint the entity mask
	entity.structure.direction_in.sheets = {
		-- Base
		{
			filename = "__reskins-compatibility__/graphics/entity/vanilla-loaders-hd/loader/loader-structure-base.png",
			priority = "extra-high",
			width = 212,
			height = 192,
			scale = 0.5,
		},
		-- Mask
		{
			filename = "__reskins-compatibility__/graphics/entity/vanilla-loaders-hd/loader/loader-structure-mask.png",
			priority = "extra-high",
			width = 212,
			height = 192,
			tint = inputs.tint,
			scale = 0.5,
		},
		-- Highlights
		{
			filename = "__reskins-compatibility__/graphics/entity/vanilla-loaders-hd/loader/loader-structure-highlights.png",
			priority = "extra-high",
			width = 212,
			height = 192,
			blend_mode = "additive",
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-shadow.png",
			priority = "extra-high",
			width = 212,
			height = 192,
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	entity.structure.direction_out.sheets = {
		-- Base
		{
			filename = "__reskins-compatibility__/graphics/entity/vanilla-loaders-hd/loader/loader-structure-base.png",
			priority = "extra-high",
			width = 212,
			height = 192,
			y = 192,
			scale = 0.5,
		},
		-- Mask
		{
			filename = "__reskins-compatibility__/graphics/entity/vanilla-loaders-hd/loader/loader-structure-mask.png",
			priority = "extra-high",
			width = 212,
			height = 192,
			y = 192,
			tint = inputs.tint,
			scale = 0.5,
		},
		-- Highlights
		{
			filename = "__reskins-compatibility__/graphics/entity/vanilla-loaders-hd/loader/loader-structure-highlights.png",
			priority = "extra-high",
			width = 212,
			height = 192,
			y = 192,
			blend_mode = "additive",
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-shadow.png",
			priority = "extra-high",
			width = 212,
			height = 192,
			y = 192,
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	-- Apply belt set
	-- entity.belt_animation_set = reskins.lib.sprites.belts.get_belt_animation_set(map.set_type, inputs.tint)

	-- Label to skip to next iteration
	::continue::
end
