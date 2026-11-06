-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

if not mods["vanilla-loaders-hd"] then
	return
end

local _framework = {
	tiers = require("__reskins-framework__.api.tiers"),
}
local _sprite_utils = { icons = require("__reskins-sprite-utils__.icons") }

local _defines = require("__reskins-assets-api__.api.defines")
local Applicators = require("__reskins-assets-api__.api.applicators")
local VanillaLoader1x2 = require("__reskins-assets-api__.assets.assorted.entities.vanilla-loader-1x2")

local tier_map = {
	["bob-basic-loader"] = { tier = 0 },
	["loader"] = { tier = 1 },
	["fast-loader"] = { tier = 2 },
	["express-loader"] = { tier = 3 },
	["turbo-loader"] = { tier = 4 },
	["bob-ultimate-loader"] = { tier = 5 },
}

for name, map in pairs(tier_map) do
	local entity = data.raw["loader"][name]
	if not entity then
		goto continue
	end

	local tint = _framework.tiers.get_tint(map.tier)
	local sprite_set =
		VanillaLoader1x2.get_sprite_set({ tint = tint, belt_sprite = _defines.get_belt_sprites(entity.speed) })

	-- The loader keeps the belt animation set of its belt.
	local belt_animation_set = entity.belt_animation_set
	Applicators.apply_sprite_set(entity, sprite_set)
	entity.belt_animation_set = belt_animation_set

	local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
		tier = map.tier,
		name = entity.name,
		type_name = entity.type,
		icon_data = VanillaLoader1x2.get_icon({ tint = tint }),
	})
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	::continue::
end
