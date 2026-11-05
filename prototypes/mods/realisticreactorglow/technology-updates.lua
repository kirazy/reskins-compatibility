-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE.md in the project directory for license information.

---@using Reskins.Framework

-- Check to see if reskinning needs to be done.
if not mods["RealisticReactorGlow"] then
	return
end
if not (reskins.bobs and reskins.bobs.triggers.power.technologies) then
	return
end
if not (reskins.bobs and reskins.bobs.triggers.power.nuclear) then
	return
end

local _framework = { tiers = require("__reskins-framework__.api.tiers") }

local NuclearPower = require("__reskins-assets-api__.assets.base.technologies.nuclear-power")

local nuclear_reactors = require("__reskins-bobs__.prototypes.functions.nuclear-reactors")

local glow_color = "blue"
if reskins.lib.settings.get_value("RealisticReactorGlow-cyan") then
	glow_color = "cyan"
end

local material_tiers = {
	"aluminum-invar",
	"silver-titanium",
	"gold-copper",
}

local technologies = {
	["nuclear-power"] = {
		tier = 1,
		prog_tier = 3,
		material = material_tiers[1],
		tint = nuclear_reactors["nuclear-reactor"].tint,
	},
	["bob-nuclear-power-2"] = {
		tier = 2,
		prog_tier = 4,
		material = material_tiers[2],
		tint = nuclear_reactors["bob-nuclear-reactor-2"].tint,
	},
	["bob-nuclear-power-3"] = {
		tier = 3,
		prog_tier = 5,
		material = material_tiers[3],
		tint = nuclear_reactors["bob-nuclear-reactor-3"].tint,
	},
}

---@type table<string, TieredIconDefinition>
local definitions = {}

for name, options in pairs(technologies) do
	definitions[name] = {
		composition = NuclearPower.get_realistic_icon_composition({
			glow_color = glow_color,
			material = options.material,
			tint = options.tint or _framework.tiers.get_tint(_framework.tiers.get_tier(options)),
		}),
	}
end

_framework.tiers.assign_icons_with_tier_labels("technology", definitions)
