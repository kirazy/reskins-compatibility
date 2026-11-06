-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Angel's Mods
--
-- See LICENSE.md in the project directory for license information.

-- Check to see if reskinning needs to be done.
if
	not (
		mods["Clowns-AngelBob-Nuclear"]
		or mods["Clowns-Extended-Minerals"]
		or mods["Clowns-Nuclear"]
		or mods["Clowns-Processing"]
	)
then
	return
end

local _framework = { tiers = require("__reskins-framework__.api.tiers") }

local Casting = require("__reskins-assets-api__.assets.angels.technologies.casting")

_framework.tiers.assign_icons_with_tier_labels("technology", {
	["advanced-depleted-uranium-smelting-1"] = { icon_data = Casting.get_icon({ material = "depleted-uranium" }) },
	["advanced-depleted-uranium-smelting-2"] = { icon_data = Casting.get_icon({ material = "depleted-uranium" }) },
	["advanced-magnesium-smelting"] = { icon_data = Casting.get_icon({ material = "magnesium" }) },
	["advanced-magnesium-smelting-2"] = { icon_data = Casting.get_icon({ material = "magnesium" }) },
	["advanced-osmium-smelting"] = { icon_data = Casting.get_icon({ material = "osmium" }) },
})
