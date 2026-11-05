-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["extendedangels"] then
	return
end
if not (reskins.angels and reskins.angels.triggers.storage.technologies) then
	return
end

local _framework = { tiers = require("__reskins-framework__.api.tiers") }

local Icons = require("__reskins-assets-api__.assets.angels.technologies.icons")

_framework.tiers.assign_icons_with_tier_labels("technology", {
	-- Reskin warehouse technologies
	["angels-logistic-warehouses-2"] = { icon_data = Icons.get_logistic_warehouses_icon() },
	["angels-logistic-warehouses-3"] = { icon_data = Icons.get_logistic_warehouses_icon() },
	["angels-logistic-warehouses-4"] = { icon_data = Icons.get_logistic_warehouses_icon() },
	["angels-warehouses-2"] = { icon_data = Icons.get_warehouses_icon() },
	["angels-warehouses-3"] = { icon_data = Icons.get_warehouses_icon() },
	["angels-warehouses-4"] = { icon_data = Icons.get_warehouses_icon() },
})
