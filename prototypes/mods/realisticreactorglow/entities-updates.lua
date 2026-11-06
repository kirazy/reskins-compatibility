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

local EnergySources = require("__reskins-assets-api__.api.energy-sources")
local NuclearReactor = require("__reskins-assets-api__.assets.base.entities.nuclear-reactor")

if not mods["RealisticReactorGlow"] then
	return
end

if not (mods["reskins-bobs"] and _framework.settings.get_value("bobmods-power-nuclear")) then
	return
end

local nuclear_reactors = require("__reskins-bobs__.prototypes.functions.nuclear-reactors")

local light_color = ""
---@type NuclearReactorGlowColor
local glow_color = "blue"
if _framework.settings.get_value("RealisticReactorGlow-cyan") then
	light_color = "_cyan"
	glow_color = "cyan"
end

for name, reactor in pairs(nuclear_reactors) do
	local entity = data.raw.reactor[name]
	if not entity then
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

	EnergySources.zero_out_light_flicker(entity.energy_source)

	entity.default_fuel_glow_color = nil
	entity.use_fuel_glow_color = nil

	local tier = _framework.tiers.get_tier(reactor)
	local composition = NuclearReactor.get_realistic_icon_composition({
		glow_color = glow_color,
		material = reactor.material,
		tint = reactor.tint,
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
