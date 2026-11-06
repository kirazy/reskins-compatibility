-- cspell: words beltbox

-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

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

---@return data.Color
local function tweak_tint(tint)
	local hsl_tint = _sprite_utils.colors.rgba_to_hsla(tint)
	hsl_tint.s = (hsl_tint.s - 0.1 >= 0) and hsl_tint.s - 0.1 or 0
	return _sprite_utils.colors.hsla_to_rgba(hsl_tint) --[[@as data.Color]]
end

for name, map in pairs(tier_map) do
	local type_name = map.is_loader and "loader-1x1" or "furnace"

	---@type data.FurnacePrototype|data.Loader1x1Prototype
	local entity = data.raw[type_name][name]
	if not entity then
		goto continue
	end
	local tint = tweak_tint(_framework.tiers.get_tint(map.tier))

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

		entity.structure.direction_in.sheets[3].tint = tint
		entity.structure.direction_out.sheets[3].tint = tint

		-- The third sheet of each frozen patch is a copy of the mask, which Deadlock's loaders draw over the ice.
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

		entity.graphics_set.animation.layers[2].tint = tint
		entity.graphics_set.working_visualisations[1].animation.tint = light_tint(tint)
		entity.graphics_set.working_visualisations[1].light.color = light_tint(tint)

		-- The second layer of the frozen patch is a copy of the mask, which Deadlock's beltboxes draw over the ice.
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

	-- The tier labels of the loaders and the beltboxes follow the setting for tier labels on belts.
	-- The beltboxes are furnaces, to which the framework does not apply that setting.
	local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
		tier = _framework.tiers.show_labels_on_belts and map.tier or 0,
		name = entity.name,
		type_name = entity.type,
		icon_data = icon_data,
	})
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	::continue::
end

local tech_map = {
	["bob-basic-transport-belt-beltbox"] = 0,
	["deadlock-stacking-1"] = 1,
	["deadlock-stacking-2"] = 2,
	["deadlock-stacking-3"] = 3,
	["deadlock-stacking-4"] = 4,
	["deadlock-stacking-5"] = 5,
}

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
