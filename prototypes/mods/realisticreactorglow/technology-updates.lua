-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE.md in the project directory for license information.

---@using Reskins.Framework
---@using Reskins.Assets.Base.Entities

local _framework = {
	settings = require("__reskins-framework__.api.settings"),
	tiers = require("__reskins-framework__.api.tiers"),
}

local NuclearPower = require("__reskins-assets-api__.assets.base.technologies.nuclear-power")

if not mods["RealisticReactorGlow"] then
	return
end

if not (mods["reskins-bobs"] and _framework.settings.get_value("bobmods-power-nuclear")) then
	return
end

local nuclear_reactors = require("__reskins-bobs__.prototypes.functions.nuclear-reactors")

---@type NuclearReactorGlowColor
local glow_color = "blue"
if _framework.settings.get_value("RealisticReactorGlow-cyan") then
	glow_color = "cyan"
end

local technologies = {
	["nuclear-power"] = "nuclear-reactor",
	["bob-nuclear-power-2"] = "bob-nuclear-reactor-2",
	["bob-nuclear-power-3"] = "bob-nuclear-reactor-3",
}

---@type table<string, TieredIconDefinition>
local definitions = {}

for name, reactor_name in pairs(technologies) do
	local reactor = nuclear_reactors[reactor_name]

	definitions[name] = {
		composition = NuclearPower.get_realistic_icon_composition({
			glow_color = glow_color,
			material = reactor.material,
			tint = reactor.tint,
		}),
	}
end

_framework.tiers.assign_icons_with_tier_labels("technology", definitions)
