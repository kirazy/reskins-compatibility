-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

local _framework = {
	settings = require("__reskins-framework__.api.settings"),
	tiers = require("__reskins-framework__.api.tiers"),
}
local _sprite_utils = { icons = require("__reskins-sprite-utils__.icons") }

local is_modern_using_aai_graphics = _framework.settings.get_value("mdrn-use-aai-graphics") == true

-- The loaders of AAI Loaders are tinted when Artisanal Reskins: Bob's Mods and Bob's Logistics are loaded.
local is_tinting_aai_loaders = mods["reskins-bobs"] ~= nil and mods["boblogistics"] ~= nil

local loaders = {
	["aai-basic-loader"] = { tier = 0 },
	["aai-loader"] = { tier = 1 },
	["aai-fast-loader"] = { tier = 2 },
	["aai-express-loader"] = { tier = 3 },
	["aai-turbo-loader"] = { tier = 4 },
	["aai-ultimate-loader"] = { tier = 5 },
	["mdrn-basic-loader"] = { tier = 0 },
	["mdrn-loader"] = { tier = 1 },
	["mdrn-fast-loader"] = { tier = 2 },
	["mdrn-express-loader"] = { tier = 3 },
	["mdrn-turbo-loader"] = { tier = 4 },
	["mdrn-ultimate-loader"] = { tier = 5 },
}

local function aai_blend_tint()
	local blend = 0.25
	return { blend, blend, blend, 0 }
end

---@param structure_direction? data.Sprite4Way
---@param tint data.Color
local function patch_sheet_tint(structure_direction, tint)
	if not structure_direction then
		return
	end

	local highlight_patch_sheet = nil
	if structure_direction.sheets then
		for _, sheet in pairs(structure_direction.sheets) do
			if sheet.filename and sheet.filename:find("_tint.png") then
				highlight_patch_sheet = util.copy(sheet)
				sheet.tint = tint
			end
		end

		-- Add an analogue of the highlights layer to help soften the saturation
		-- and better align with Artisanal Reskins color handling.
		if highlight_patch_sheet then
			highlight_patch_sheet.tint = aai_blend_tint()
			highlight_patch_sheet.blend_mode = "additive-soft"
			table.insert(structure_direction.sheets, highlight_patch_sheet)
		end
	end
end

---@param icons data.IconData[]
---@param tint data.Color
local function patch_icons_tint(icons, tint)
	local highlight_patch_layer = nil
	for _, layer in pairs(icons) do
		if layer.icon and layer.icon:find("_mask") then
			highlight_patch_layer = util.copy(layer)
			layer.tint = tint
		end
	end

	-- Add an analogue of the highlights layer to help soften the saturation
	-- and better align with Artisanal Reskins color handling.
	if highlight_patch_layer then
		highlight_patch_layer.tint = aai_blend_tint()
		table.insert(icons, highlight_patch_layer)
	end
end

for name, map in pairs(loaders) do
	if name:find("mdrn") and not is_modern_using_aai_graphics then
		goto continue
	end
	if name:find("^aai%-") and not is_tinting_aai_loaders then
		goto continue
	end

	-- AAI Loaders sets the icon only on the entity.
	local loader = data.raw["loader-1x1"][name]
	if not loader then
		goto continue
	end

	local tint = _framework.tiers.get_tint(map.tier)

	if loader.structure then
		patch_sheet_tint(loader.structure.direction_in, tint)
		patch_sheet_tint(loader.structure.direction_out, tint)
	end

	if loader.icons then
		local icon_data = _sprite_utils.icons.get_icon_from_prototype(loader)
		patch_icons_tint(icon_data, tint)

		local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
			tier = map.tier,
			name = loader.name,
			type_name = loader.type,
			icon_data = icon_data,
		})
		_sprite_utils.icons.apply_icon_assignment(icon_assignment)
	end

	local technology = data.raw["technology"][name]
	if technology and technology.icons then
		local icon_data = _sprite_utils.icons.get_icon_from_prototype(technology)
		patch_icons_tint(icon_data, tint)

		_sprite_utils.icons.apply_icon_assignment({
			name = technology.name,
			type_name = technology.type,
			icon_data = icon_data,
		})
	end

	::continue::
end
