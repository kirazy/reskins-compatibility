-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

local _framework = {
	settings = require("__reskins-framework__.api.settings"),
	tiers = require("__reskins-framework__.api.tiers"),
}
local _sprite_utils = { icons = require("__reskins-sprite-utils__.icons") }

local Applicators = require("__reskins-assets-api__.api.applicators")
local Warehouse = require("__reskins-assets-api__.assets.angels.entities.assorted.warehouse")

if not mods["extendedangels"] then
	return
end

local is_tiered = _framework.settings.get_value("reskins-compatibility-extendedangels-warehouse-tiering") == true

local entities = {
	["angels-warehouse"] = { tier = 1, prog_tier = 2 },
	["angels-warehouse-mk2"] = { tier = 2, prog_tier = 3 },
	["angels-warehouse-mk3"] = { tier = 3, prog_tier = 4 },
	["angels-warehouse-mk4"] = { tier = 4, prog_tier = 5 },
	["angels-warehouse-active-provider"] = { tier = 1, prog_tier = 2, logistic_mode = "active-provider" },
	["angels-warehouse-active-provider-mk2"] = { tier = 2, prog_tier = 3, logistic_mode = "active-provider" },
	["angels-warehouse-active-provider-mk3"] = { tier = 3, prog_tier = 4, logistic_mode = "active-provider" },
	["angels-warehouse-active-provider-mk4"] = { tier = 4, prog_tier = 5, logistic_mode = "active-provider" },
	["angels-warehouse-buffer"] = { tier = 1, prog_tier = 2, logistic_mode = "buffer" },
	["angels-warehouse-buffer-mk2"] = { tier = 2, prog_tier = 3, logistic_mode = "buffer" },
	["angels-warehouse-buffer-mk3"] = { tier = 3, prog_tier = 4, logistic_mode = "buffer" },
	["angels-warehouse-buffer-mk4"] = { tier = 4, prog_tier = 5, logistic_mode = "buffer" },
	["angels-warehouse-passive-provider"] = { tier = 1, prog_tier = 2, logistic_mode = "passive-provider" },
	["angels-warehouse-passive-provider-mk2"] = { tier = 2, prog_tier = 3, logistic_mode = "passive-provider" },
	["angels-warehouse-passive-provider-mk3"] = { tier = 3, prog_tier = 4, logistic_mode = "passive-provider" },
	["angels-warehouse-passive-provider-mk4"] = { tier = 4, prog_tier = 5, logistic_mode = "passive-provider" },
	["angels-warehouse-requester"] = { tier = 1, prog_tier = 2, logistic_mode = "requester" },
	["angels-warehouse-requester-mk2"] = { tier = 2, prog_tier = 3, logistic_mode = "requester" },
	["angels-warehouse-requester-mk3"] = { tier = 3, prog_tier = 4, logistic_mode = "requester" },
	["angels-warehouse-requester-mk4"] = { tier = 4, prog_tier = 5, logistic_mode = "requester" },
	["angels-warehouse-storage"] = { tier = 1, prog_tier = 2, logistic_mode = "storage" },
	["angels-warehouse-storage-mk2"] = { tier = 2, prog_tier = 3, logistic_mode = "storage" },
	["angels-warehouse-storage-mk3"] = { tier = 3, prog_tier = 4, logistic_mode = "storage" },
	["angels-warehouse-storage-mk4"] = { tier = 4, prog_tier = 5, logistic_mode = "storage" },
}

for name, options in pairs(entities) do
	local type_name = options.logistic_mode and "logistic-container" or "container"

	---@type data.LogisticContainerPrototype|data.ContainerPrototype
	local entity = data.raw[type_name][name]
	if not entity then
		goto continue
	end

	local tier = _framework.tiers.get_tier(options)
	local tint = is_tiered and _framework.tiers.get_tint(tier) or nil

	-- The first tier is reskinned by reskins-angels when it is loaded, and takes the sprite set here only when it is
	-- tinted.
	if options.tier > 1 or tint or not mods["reskins-angels"] then
		local sprite_set
		if options.logistic_mode then
			sprite_set = Warehouse.get_logistic_sprite_set({ logistic_mode = options.logistic_mode, tint = tint })
		else
			sprite_set = Warehouse.get_sprite_set({ tint = tint })
		end
		Applicators.apply_sprite_set(entity, sprite_set)
	end

	local icon_data
	if options.logistic_mode then
		icon_data = Warehouse.get_logistic_icon({ logistic_mode = options.logistic_mode, tint = tint })
	else
		icon_data = Warehouse.get_icon({ tint = tint })
	end

	local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
		tier = tier,
		name = entity.name,
		type_name = entity.type,
		icon_data = icon_data,
	})
	_sprite_utils.icons.apply_icon_assignment(icon_assignment)

	::continue::
end
