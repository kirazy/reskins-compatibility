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

---@type NuclearReactorGlowColor
local glow_color = "blue"
if _framework.settings.get_value("RealisticReactorGlow-cyan") then
	glow_color = "cyan"
end

local material_tiers = {
	"aluminum-invar",
	"silver-titanium",
	"gold-copper",
}

local technologies = {
	["nuclear-power"] = {
		reactor = "nuclear-reactor",
		material = material_tiers[1],
	},
	["bob-nuclear-power-2"] = {
		reactor = "bob-nuclear-reactor-2",
		material = material_tiers[2],
	},
	["bob-nuclear-power-3"] = {
		reactor = "bob-nuclear-reactor-3",
		material = material_tiers[3],
	},
}

---@type table<string, TieredIconDefinition>
local definitions = {}

for name, options in pairs(technologies) do
	local reactor = data.raw.reactor[options.reactor]
	local tint = reactor and ReactorArtwork.get_reskins_tint(reactor)

	if tint then
		definitions[name] = {
			composition = NuclearPower.get_realistic_icon_composition({
				glow_color = glow_color,
				material = options.material,
				tint = tint,
			}),
		}
	end
end

_framework.tiers.assign_icons_with_tier_labels("technology", definitions)
