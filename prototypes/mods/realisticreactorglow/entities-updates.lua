-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE.md in the project directory for license information.

---@using Reskins.Assets.Base.Entities

local _framework = {
	settings = require("__reskins-framework__.api.settings"),
	tiers = require("__reskins-framework__.api.tiers"),
}
local _sprite_utils = { icons = require("__reskins-sprite-utils__.icons") }

local NuclearReactor = require("__reskins-assets-api__.assets.base.entities.nuclear-reactor")

if not mods["RealisticReactorGlow"] then
	return
end

local reactors = {
	["nuclear-reactor"] = { tier = 1, prog_tier = 3, material = "aluminum-invar" },
	["bob-nuclear-reactor-2"] = { tier = 2, prog_tier = 4, material = "silver-titanium" },
	["bob-nuclear-reactor-3"] = { tier = 3, prog_tier = 5, material = "gold-copper" },
}

local light_color = ""
---@type NuclearReactorGlowColor
local glow_color = "blue"
if _framework.settings.get_value("RealisticReactorGlow-cyan") then
	light_color = "_cyan"
	glow_color = "cyan"
end

-- Fix lighting
for name, map in pairs(reactors) do
	local entity = data.raw.reactor[name]
	local tint = entity and ReactorArtwork.get_reskins_tint(entity)

	if not tint then
		goto continue
	end

	entity.working_light_picture = {
		filename = "__RealisticReactorGlow__/graphics/entity/nuclear-reactor/reactor-lights-color" .. light_color .. ".png",
		blend_mode = "additive",
		draw_as_glow = true,
		width = 320,
		height = 320,
		scale = 0.5,
		shift = { -0.03125, -0.1875 },
	}

	-- Handle ambient-light
	entity.energy_source.light_flicker = {
		color = { 0, 0, 0 },
		minimum_light_size = 0,
		light_intensity_to_size_coefficient = 0,
	}

	entity.default_fuel_glow_color = nil
	entity.use_fuel_glow_color = nil

	local tier = _framework.tiers.get_tier(map)
	local composition = NuclearReactor.get_realistic_icon_composition({
		glow_color = glow_color,
		material = map.material,
		tint = tint,
	})
	local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
		tier = tier,
		name = entity.name,
		type_name = entity.type,
		composition = composition,
	})
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	::continue::
end
