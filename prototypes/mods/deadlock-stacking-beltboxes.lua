-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["deadlock-beltboxes-loaders-continued"] then
	return
end

local _framework = {
	tiers = require("__reskins-framework__.api.tiers"),
}
local _sprite_utils = {
	colors = require("__reskins-sprite-utils__.colors"),
	icons = require("__reskins-sprite-utils__.icons"),
}

local Applicators = require("__reskins-assets-api__.api.applicators")
local UndergroundBeltExplosion = require("__reskins-assets-api__.assets.base.explosions.underground-belt")

local tier_map = {
	["bob-basic-transport-belt-loader"] = { tier = 0, is_loader = true },
	["transport-belt-loader"] = { tier = 1, is_loader = true },
	["fast-transport-belt-loader"] = { tier = 2, is_loader = true },
	["express-transport-belt-loader"] = { tier = 3, is_loader = true },
	["turbo-transport-belt-loader"] = { tier = 4, is_loader = true },
	["bob-ultimate-transport-belt-loader"] = { tier = 5, is_loader = true },
	["bob-basic-transport-belt-beltbox"] = { tier = 0 },
	["transport-belt-beltbox"] = { tier = 1 },
	["fast-transport-belt-beltbox"] = { tier = 2 },
	["express-transport-belt-beltbox"] = { tier = 3 },
	["turbo-transport-belt-beltbox"] = { tier = 4 },
	["bob-ultimate-transport-belt-beltbox"] = { tier = 5 },
}

local function light_tint(tint)
	local white = 0.95
	return { r = (tint.r + white) / 2, g = (tint.g + white) / 2, b = (tint.b + white) / 2 }
end

local function tweak_tint(tint)
	local hsl_tint = _sprite_utils.colors.rgba_to_hsla(tint)
	hsl_tint.s = (hsl_tint.s - 0.1 >= 0) and hsl_tint.s - 0.1 or 0
	-- hsl_tint.l = (hsl_tint.l - 0.2 >= 0) and hsl_tint.l - 0.2 or 0

	return _sprite_utils.colors.hsla_to_rgba(hsl_tint)
end

-- Reskin entities
for name, map in pairs(tier_map) do
	-- Determine type
	local type_name = map.is_loader and "loader-1x1" or "furnace"

	---@type data.FurnacePrototype|data.Loader1x1Prototype
	local entity = data.raw[type_name][name]
	if not entity then
		goto continue
	end
	local tint = tweak_tint(_framework.tiers.get_tint(map.tier))

	-- Give the entity the dying explosion of the underground belt, with the small and the yellow medium metal particles
	-- tinted.
	Applicators.apply_corpse_and_explosion(entity, {
		dying_explosion = UndergroundBeltExplosion.get_explosion({
			tints = {
				["underground-belt-metal-particle-small"] = tint,
				["underground-belt-metal-particle-medium-yellow"] = tint,
			},
		}),
	})

	---@type data.IconData[]
	local icon_data
	if map.is_loader then
		---@cast entity data.Loader1x1Prototype

		-- Retint the mask
		entity.structure.direction_in.sheets[3].tint = tint
		entity.structure.direction_out.sheets[3].tint = tint

		-- Retint the masks of the frozen patches, if any.
		if entity.structure.frozen_patch_in then
			entity.structure.frozen_patch_in.sheets[3].tint = tint
			entity.structure.frozen_patch_out.sheets[3].tint = tint
		end

		icon_data = {
			{
				icon = "__deadlock-beltboxes-loaders-continued__/graphics/icons/mipmaps/loader-icon-base.png",
				icon_size = 64,
				scale = 0.5,
			},
			{
				icon = "__deadlock-beltboxes-loaders-continued__/graphics/icons/mipmaps/loader-icon-mask.png",
				icon_size = 64,
				scale = 0.5,
				tint = tint,
			},
		}
	else
		---@cast entity data.FurnacePrototype

		-- Retint the mask
		entity.graphics_set.animation.layers[2].tint = tint
		entity.graphics_set.working_visualisations[1].animation.tint = light_tint(tint)
		entity.graphics_set.working_visualisations[1].light.color = light_tint(tint)

		-- Retint the mask of the frozen patch, if any.
		if entity.graphics_set.frozen_patch then
			entity.graphics_set.frozen_patch.layers[2].tint = tint
		end

		icon_data = {
			{
				icon = "__deadlock-beltboxes-loaders-continued__/graphics/icons/mipmaps/beltbox-icon-base.png",
				icon_size = 64,
				scale = 0.5,
			},
			{
				icon = "__deadlock-beltboxes-loaders-continued__/graphics/icons/mipmaps/beltbox-icon-mask.png",
				icon_size = 64,
				scale = 0.5,
				tint = tint,
			},
		}
	end

	-- The tier labels of the loaders and the beltboxes follow the setting for tier labels on belts. The beltboxes are
	-- furnaces, to which the framework does not apply that setting.
	local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
		tier = _framework.tiers.show_labels_on_belts and map.tier or 0,
		name = entity.name,
		type_name = entity.type,
		icon_data = icon_data,
	})
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	::continue::
end

-- Technology
local tech_map = {
	["bob-basic-transport-belt-beltbox"] = 0,
	["deadlock-stacking-1"] = 1,
	["deadlock-stacking-2"] = 2,
	["deadlock-stacking-3"] = 3,
	["deadlock-stacking-4"] = 4,
	["deadlock-stacking-5"] = 5,
}

-- Reskin technologies
for name, tier in pairs(tech_map) do
	if data.raw.technology[name] then
		_sprite_utils.icons.apply_icon_assignment({
			name = name,
			type_name = "technology",
			icon_data = {
				{
					icon = "__deadlock-beltboxes-loaders-continued__/graphics/icons/square/beltbox-icon-base-128.png",
					icon_size = 128,
				},
				{
					icon = "__deadlock-beltboxes-loaders-continued__/graphics/icons/square/beltbox-icon-mask-128.png",
					icon_size = 128,
					tint = _framework.tiers.get_tint(tier),
				},
			},
		})
	end
end
