-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

---@using data
---@using Reskins.Framework
---@using Reskins.Library.Internal
---@using Reskins.SpriteUtils

-- Check for mini-machines
if not mods["mini-machines"] then
	return
end

local _assets = { icons = require("__reskins-assets-api__.api.icons") }
local _framework = {
	settings = require("__reskins-framework__.api.settings"),
	tiers = require("__reskins-framework__.api.tiers"),
}

local MiniAngelsChemicalPlant = require("__reskins-assets-api__.assets.assorted.items.mini-angels-chemical-plant")
local MiniAssemblingMachine = require("__reskins-assets-api__.assets.assorted.items.mini-assembling-machine")
local MiniBeacon = require("__reskins-assets-api__.assets.assorted.items.mini-beacon")
local MiniBeaconOriginal = require("__reskins-assets-api__.assets.assorted.items.mini-beacon-original")
local MiniCentrifuge = require("__reskins-assets-api__.assets.assorted.items.mini-centrifuge")
local MiniChemicalPlant = require("__reskins-assets-api__.assets.assorted.items.mini-chemical-plant")
local MiniElectrolyser = require("__reskins-assets-api__.assets.assorted.items.mini-electrolyser")
local MiniFurnaceElectric = require("__reskins-assets-api__.assets.assorted.items.mini-furnace-electric")
local MiniFurnaceElectricChemical =
	require("__reskins-assets-api__.assets.assorted.items.mini-furnace-electric-chemical")
local MiniFurnaceElectricChemicalMixing =
	require("__reskins-assets-api__.assets.assorted.items.mini-furnace-electric-chemical-mixing")
local MiniFurnaceElectricMixing = require("__reskins-assets-api__.assets.assorted.items.mini-furnace-electric-mixing")
local MiniMiningDrillElectric = require("__reskins-assets-api__.assets.assorted.items.mini-mining-drill-electric")
local MiniMiningDrillElectricOriginal =
	require("__reskins-assets-api__.assets.assorted.items.mini-mining-drill-electric-original")
local MiniOilRefinery = require("__reskins-assets-api__.assets.assorted.items.mini-oil-refinery")
local MiniRadar = require("__reskins-assets-api__.assets.assorted.items.mini-radar")
local MiniStorageTank = require("__reskins-assets-api__.assets.assorted.items.mini-storage-tank")

-- Setup technologies table
local technology_source_mapping = {}

---@type CreateIconsFromListTable
local technology_icons_to_create = {}

---Maps a standard-sized prototype to a miniature-sized prototype.
---@class MiniMachineParameters
---@field source string # The name of the source standard-sized prototype.
---@field scale double # The ratio of bounding box side length in tiles of the source and target prototypes.
---@field type_name string # The type name of the source and target prototypes.
---The tier of the source prototype.
---@field tier Tier
---The progression tier of the source prototype, if any.
---@field prog_tier? Tier
---The tint of the source prototype. When `nil`, the tint of the tier is used.
---@field tint? Color
---The creator of the icon of the target prototype, which is given the tint and `icon_params`.
---@field get_icon_composition fun(params: table): IconComposition
---The parameters of `get_icon_composition` other than the tint, if any.
---@field icon_params? table

---@type { [string]: MiniMachineParameters }
local mini_machine_maps = {}

-- Chemical plants
if reskins.compatibility.triggers.minimachines.chemplants.angels then
	-- Use Angel's chemical plants.
	local get_chemical_plant_icon = MiniAngelsChemicalPlant.get_icon_composition
	if _framework.settings.get_value("reskins-angels-use-vanilla-chemical-plant-sprites") then
		get_chemical_plant_icon = MiniChemicalPlant.get_icon_composition
	end

	mini_machine_maps["mini-chemplant-1"] = {
		source = "chemical-plant",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 1,
		get_icon_composition = get_chemical_plant_icon,
	}
	mini_machine_maps["mini-chemplant-2"] = {
		source = "angels-chemical-plant-2",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 2,
		get_icon_composition = get_chemical_plant_icon,
	}
	mini_machine_maps["mini-chemplant-3"] = {
		source = "angels-chemical-plant-3",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 3,
		get_icon_composition = get_chemical_plant_icon,
	}
	mini_machine_maps["mini-chemplant-4"] = {
		source = "angels-chemical-plant-4",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 4,
		get_icon_composition = get_chemical_plant_icon,
	}

	-- Technologies
	-- TODO: Add icons for Angel's chem plants.
	-- originated_technologies["mini-chemplant-1"] = {mod = "bobs", group = "assembly", tier = 1, prog_tier = 2, icon_name = "chemical-plant"}
	-- linked_technologies["mini-chemplant-2"] = "chemical-plant-2"
	-- linked_technologies["mini-chemplant-3"] = "chemical-plant-3"
	-- linked_technologies["mini-chemplant-4"] = "chemical-plant-4"
elseif reskins.compatibility.triggers.minimachines.chemplants.bobs then
	-- Use Bob's chemical plants.
	mini_machine_maps["mini-chemplant-1"] = {
		source = "chemical-plant",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 1,
		prog_tier = 2,
		get_icon_composition = MiniChemicalPlant.get_icon_composition,
	}
	mini_machine_maps["mini-chemplant-2"] = {
		source = "bob-chemical-plant-2",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 2,
		prog_tier = 3,
		get_icon_composition = MiniChemicalPlant.get_icon_composition,
	}
	mini_machine_maps["mini-chemplant-3"] = {
		source = "bob-chemical-plant-3",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 3,
		prog_tier = 4,
		get_icon_composition = MiniChemicalPlant.get_icon_composition,
	}
	mini_machine_maps["mini-chemplant-4"] = {
		source = "bob-chemical-plant-4",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 4,
		prog_tier = 5,
		get_icon_composition = MiniChemicalPlant.get_icon_composition,
	}

	technology_icons_to_create["mini-chemplant-1"] = {
		mod = "bobs",
		group = "assembly",
		tier = 1,
		prog_tier = 2,
		icon_name = "chemical-plant",
	}

	technology_source_mapping["mini-chemplant-2"] = "bob-chemical-plant-2"
	technology_source_mapping["mini-chemplant-3"] = "bob-chemical-plant-3"
	technology_source_mapping["mini-chemplant-4"] = "bob-chemical-plant-4"
end

-- Electrolysers
if reskins.compatibility.triggers.minimachines.electrolysers then
	mini_machine_maps["mini-bobelectro-1"] = {
		source = "bob-electrolyser",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 1,
		get_icon_composition = MiniElectrolyser.get_icon_composition,
		icon_params = { tier = 1 },
	}
	mini_machine_maps["mini-bobelectro-2"] = {
		source = "bob-electrolyser-2",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 2,
		get_icon_composition = MiniElectrolyser.get_icon_composition,
		icon_params = { tier = 2 },
	}
	mini_machine_maps["mini-bobelectro-3"] = {
		source = "bob-electrolyser-3",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 3,
		get_icon_composition = MiniElectrolyser.get_icon_composition,
		icon_params = { tier = 3 },
	}
	mini_machine_maps["mini-bobelectro-4"] = {
		source = "bob-electrolyser-4",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 4,
		get_icon_composition = MiniElectrolyser.get_icon_composition,
		icon_params = { tier = 4 },
	}
	mini_machine_maps["mini-bobelectro-5"] = {
		source = "bob-electrolyser-5",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 5,
		get_icon_composition = MiniElectrolyser.get_icon_composition,
		icon_params = { tier = 5 },
	}

	technology_icons_to_create["mini-bobelectro-1"] = {
		mod = "bobs",
		group = "assembly",
		tier = 1,
		technology_icon_size = 256,
		icon_name = "electrolyser",
		icon_base = "electrolyser-1",
		icon_mask = "electrolyser-1",
		icon_highlights = "electrolyser-1",
	}

	technology_source_mapping["mini-bobelectro-2"] = "bob-electrolyser-2"
	technology_source_mapping["mini-bobelectro-3"] = "bob-electrolyser-3"
	technology_source_mapping["mini-bobelectro-4"] = "bob-electrolyser-4"
	technology_source_mapping["mini-bobelectro-5"] = "bob-electrolyser-5"
end

-- Assembling machines
if reskins.compatibility.triggers.minimachines.assemblers then
	mini_machine_maps["mini-assembler-1"] = {
		source = "assembling-machine-1",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 1,
		get_icon_composition = MiniAssemblingMachine.get_icon_composition,
		icon_params = { machine_tier = 1 },
	}
	mini_machine_maps["mini-assembler-2"] = {
		source = "assembling-machine-2",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 2,
		get_icon_composition = MiniAssemblingMachine.get_icon_composition,
		icon_params = { machine_tier = 2 },
	}
	mini_machine_maps["mini-assembler-3"] = {
		source = "assembling-machine-3",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 3,
		get_icon_composition = MiniAssemblingMachine.get_icon_composition,
		icon_params = { machine_tier = 3 },
	}
	mini_machine_maps["mini-assembler-4"] = {
		source = "bob-assembling-machine-4",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 4,
		get_icon_composition = MiniAssemblingMachine.get_icon_composition,
		icon_params = { machine_tier = 4 },
	}
	mini_machine_maps["mini-assembler-5"] = {
		source = "bob-assembling-machine-5",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 5,
		get_icon_composition = MiniAssemblingMachine.get_icon_composition,
		icon_params = { machine_tier = 5 },
	}
	mini_machine_maps["mini-assembler-6"] = {
		source = "bob-assembling-machine-6",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 6,
		get_icon_composition = MiniAssemblingMachine.get_icon_composition,
		icon_params = { machine_tier = 6 },
	}

	-- Technologies
	technology_source_mapping["mini-assembler-1"] = "automation"
	technology_source_mapping["mini-assembler-2"] = "automation-2"
	technology_source_mapping["mini-assembler-3"] = "automation-3"
	technology_source_mapping["mini-assembler-4"] = "automation-4"
	technology_source_mapping["mini-assembler-5"] = "automation-5"
	technology_source_mapping["mini-assembler-6"] = "automation-6"
end

-- Mining drills
if reskins.compatibility.triggers.minimachines.miners then
	local get_mining_drill_icon = MiniMiningDrillElectric.get_icon_composition
	if mods["classic-mining-drill"] then
		get_mining_drill_icon = MiniMiningDrillElectricOriginal.get_icon_composition
	end

	mini_machine_maps["mini-miner-1"] = {
		source = "electric-mining-drill",
		type_name = "mining-drill",
		scale = 2 / 3,
		tier = 1,
		prog_tier = 1,
		get_icon_composition = get_mining_drill_icon,
	}
	mini_machine_maps["mini-miner-2"] = {
		source = "bob-mining-drill-1",
		type_name = "mining-drill",
		scale = 2 / 3,
		tier = 2,
		prog_tier = 2,
		get_icon_composition = get_mining_drill_icon,
	}
	mini_machine_maps["mini-miner-3"] = {
		source = "bob-mining-drill-2",
		type_name = "mining-drill",
		scale = 2 / 3,
		tier = 3,
		prog_tier = 3,
		get_icon_composition = get_mining_drill_icon,
	}
	mini_machine_maps["mini-miner-4"] = {
		source = "bob-mining-drill-3",
		type_name = "mining-drill",
		scale = 2 / 3,
		tier = 4,
		prog_tier = 4,
		get_icon_composition = get_mining_drill_icon,
	}
	mini_machine_maps["mini-miner-5"] = {
		source = "bob-mining-drill-4",
		type_name = "mining-drill",
		scale = 2 / 3,
		tier = 5,
		prog_tier = 5,
		get_icon_composition = get_mining_drill_icon,
	}

	technology_icons_to_create["mini-miner-1"] = { mod = "bobs", group = "mining", tier = 1, icon_name = "mining-drill" }

	technology_source_mapping["mini-miner-2"] = "bob-drills-2"
	technology_source_mapping["mini-miner-3"] = "bob-drills-3"
	technology_source_mapping["mini-miner-4"] = "bob-drills-4"
	technology_source_mapping["mini-miner-5"] = "bob-drills-5"
end

-- Radars
if reskins.compatibility.triggers.minimachines.radar then
	mini_machine_maps["mini-radar-1"] = {
		source = "radar",
		type_name = "radar",
		scale = 2 / 3,
		tier = 1,
		get_icon_composition = MiniRadar.get_icon_composition,
	}
	mini_machine_maps["mini-radar-2"] = {
		source = "bob-radar-2",
		type_name = "radar",
		scale = 2 / 3,
		tier = 2,
		get_icon_composition = MiniRadar.get_icon_composition,
	}
	mini_machine_maps["mini-radar-3"] = {
		source = "bob-radar-3",
		type_name = "radar",
		scale = 2 / 3,
		tier = 3,
		get_icon_composition = MiniRadar.get_icon_composition,
	}
	mini_machine_maps["mini-radar-4"] = {
		source = "bob-radar-4",
		type_name = "radar",
		scale = 2 / 3,
		tier = 4,
		get_icon_composition = MiniRadar.get_icon_composition,
	}
	mini_machine_maps["mini-radar-5"] = {
		source = "bob-radar-5",
		type_name = "radar",
		scale = 2 / 3,
		tier = 5,
		get_icon_composition = MiniRadar.get_icon_composition,
	}

	technology_icons_to_create["mini-radar-1"] = { mod = "bobs", group = "warfare", tier = 1, icon_name = "radar" }

	technology_source_mapping["mini-radar-2"] = "bob-radar-2"
	technology_source_mapping["mini-radar-3"] = "bob-radar-3"
	technology_source_mapping["mini-radar-4"] = "bob-radar-4"
	technology_source_mapping["mini-radar-5"] = "bob-radar-5"
end

if reskins.compatibility.triggers.minimachines.refineries then
	mini_machine_maps["mini-refinery-1"] = {
		source = "oil-refinery",
		type_name = "assembling-machine",
		scale = 3 / 5,
		tier = 1,
		prog_tier = 2,
		get_icon_composition = MiniOilRefinery.get_icon_composition,
	}
	mini_machine_maps["mini-refinery-2"] = {
		source = "bob-oil-refinery-2",
		type_name = "assembling-machine",
		scale = 3 / 5,
		tier = 2,
		prog_tier = 3,
		get_icon_composition = MiniOilRefinery.get_icon_composition,
	}
	mini_machine_maps["mini-refinery-3"] = {
		source = "bob-oil-refinery-3",
		type_name = "assembling-machine",
		scale = 3 / 5,
		tier = 3,
		prog_tier = 4,
		get_icon_composition = MiniOilRefinery.get_icon_composition,
	}
	mini_machine_maps["mini-refinery-4"] = {
		source = "bob-oil-refinery-4",
		type_name = "assembling-machine",
		scale = 3 / 5,
		tier = 4,
		prog_tier = 5,
		get_icon_composition = MiniOilRefinery.get_icon_composition,
	}

	technology_icons_to_create["mini-refinery-1"] = {
		mod = "bobs",
		group = "assembly",
		tier = 1,
		prog_tier = 2,
		icon_name = "oil-refinery",
	}

	technology_source_mapping["mini-refinery-2"] = "oil-processing-2"
	technology_source_mapping["mini-refinery-3"] = "oil-processing-3"
	technology_source_mapping["mini-refinery-4"] = "oil-processing-4"
end

if reskins.compatibility.triggers.minimachines.centrifuges then
	--stylua: ignore start
	mini_machine_maps["mini-centrifuge-1"] = { source = "centrifuge", type_name = "assembling-machine", scale = 2 / 3, tier = 1, prog_tier = 3, get_icon_composition = MiniCentrifuge.get_icon_composition }
	mini_machine_maps["mini-centrifuge-2"] = { source = "bob-centrifuge-2", type_name = "assembling-machine", scale = 2 / 3, tier = 2, prog_tier = 4, get_icon_composition = MiniCentrifuge.get_icon_composition }
	mini_machine_maps["mini-centrifuge-3"] = { source = "bob-centrifuge-3", type_name = "assembling-machine", scale = 2 / 3, tier = 3, prog_tier = 5, get_icon_composition = MiniCentrifuge.get_icon_composition }
	--stylua: ignore end

	technology_source_mapping["mini-centrifuge-2"] = "bob-centrifuge-2"
	technology_source_mapping["mini-centrifuge-3"] = "bob-centrifuge-3"
end

if reskins.compatibility.triggers.minimachines.storagetanks then
	mini_machine_maps["mini-tank-1"] = {
		source = "storage-tank",
		type_name = "storage-tank",
		scale = 2 / 3,
		tier = 1,
		prog_tier = 2,
		get_icon_composition = MiniStorageTank.get_icon_composition,
	}
	mini_machine_maps["mini-tank-2"] = {
		source = "bob-storage-tank-2",
		type_name = "storage-tank",
		scale = 2 / 3,
		tier = 2,
		prog_tier = 3,
		get_icon_composition = MiniStorageTank.get_icon_composition,
	}
	mini_machine_maps["mini-tank-3"] = {
		source = "bob-storage-tank-3",
		type_name = "storage-tank",
		scale = 2 / 3,
		tier = 3,
		prog_tier = 4,
		get_icon_composition = MiniStorageTank.get_icon_composition,
	}
	mini_machine_maps["mini-tank-4"] = {
		source = "bob-storage-tank-4",
		type_name = "storage-tank",
		scale = 2 / 3,
		tier = 4,
		prog_tier = 5,
		get_icon_composition = MiniStorageTank.get_icon_composition,
	}

	--stylua: ignore start
	technology_icons_to_create["mini-tank-1"] = { group = "mini-machine", tier = 1, prog_tier = 2, icon_name = "storage-tank" }
	technology_icons_to_create["mini-tank-2"] = { group = "mini-machine", tier = 2, prog_tier = 3, icon_name = "storage-tank" }
	technology_icons_to_create["mini-tank-3"] = { group = "mini-machine", tier = 3, prog_tier = 4, icon_name = "storage-tank" }
	technology_icons_to_create["mini-tank-4"] = { group = "mini-machine", tier = 4, prog_tier = 5, icon_name = "storage-tank" }
	--stylua: ignore end
end

if reskins.compatibility.triggers.minimachines.beacons then
	local get_beacon_icon = MiniBeacon.get_icon_composition
	if mods["classic-beacon"] then
		get_beacon_icon = MiniBeaconOriginal.get_icon_composition
	end

	mini_machine_maps["mini-beacon-1"] = {
		source = "beacon",
		type_name = "beacon",
		scale = 2 / 3,
		tier = 1,
		prog_tier = 3,
		get_icon_composition = get_beacon_icon,
	}
	mini_machine_maps["mini-beacon-2"] = {
		source = "bob-beacon-2",
		type_name = "beacon",
		scale = 2 / 3,
		tier = 2,
		prog_tier = 4,
		get_icon_composition = get_beacon_icon,
	}
	mini_machine_maps["mini-beacon-3"] = {
		source = "bob-beacon-3",
		type_name = "beacon",
		scale = 2 / 3,
		tier = 3,
		prog_tier = 5,
		get_icon_composition = get_beacon_icon,
	}
	technology_source_mapping["mini-beacon-1"] = "effect-transmission"
	technology_source_mapping["mini-beacon-2"] = "effect-transmission-2"
	technology_source_mapping["mini-beacon-3"] = "effect-transmission-3"
end

if reskins.compatibility.triggers.minimachines.furnaces then
	-- The chemical mixing furnaces have the artwork of the mixing furnace when Angel's Smelting is active.
	local get_chemical_mixing_furnace_icon = MiniFurnaceElectricChemicalMixing.get_icon_composition
	if mods["angelssmelting"] then
		get_chemical_mixing_furnace_icon = MiniFurnaceElectricMixing.get_icon_composition
	end

	mini_machine_maps["mini-furnace-1"] = {
		source = "electric-furnace",
		type_name = "furnace",
		scale = 2 / 3,
		tier = 3,
		tint = reskins.bobs.furnace_tint_index.standard,
		get_icon_composition = MiniFurnaceElectric.get_icon_composition,
	}
	mini_machine_maps["mini-furnace-2"] = {
		source = "bob-electric-furnace-2",
		type_name = "furnace",
		scale = 2 / 3,
		tier = 4,
		get_icon_composition = MiniFurnaceElectric.get_icon_composition,
	}
	mini_machine_maps["mini-furnace-3"] = {
		source = "bob-electric-furnace-3",
		type_name = "furnace",
		scale = 2 / 3,
		tier = 5,
		get_icon_composition = MiniFurnaceElectric.get_icon_composition,
	}
	mini_machine_maps["mini-bobchem-1"] = {
		source = "bob-electric-chemical-furnace",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 3,
		tint = reskins.bobs.furnace_tint_index.chemical,
		get_icon_composition = MiniFurnaceElectricChemical.get_icon_composition,
	}
	mini_machine_maps["mini-bobmetal-1"] = {
		source = "bob-electric-mixing-furnace",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 3,
		tint = reskins.bobs.furnace_tint_index.mixing,
		get_icon_composition = MiniFurnaceElectricMixing.get_icon_composition,
	}
	mini_machine_maps["mini-bobmulti-1"] = {
		source = "bob-electric-chemical-mixing-furnace",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 4,
		get_icon_composition = get_chemical_mixing_furnace_icon,
	}
	mini_machine_maps["mini-bobmulti-2"] = {
		source = "bob-electric-chemical-mixing-furnace-2",
		type_name = "assembling-machine",
		scale = 2 / 3,
		tier = 5,
		get_icon_composition = get_chemical_mixing_furnace_icon,
	}

	technology_source_mapping["mini-furnace-1"] = "advanced-material-processing-2"
	technology_source_mapping["mini-furnace-2"] = "advanced-material-processing-3"
	technology_source_mapping["mini-furnace-3"] = "advanced-material-processing-4"
	technology_source_mapping["mini-bobmetal-1"] = "bob-electric-mixing-furnace"
	technology_source_mapping["mini-bobchem-1"] = "bob-electric-chemical-furnace"
	technology_source_mapping["mini-bobmulti-1"] = "bob-multi-purpose-furnace-1"
	technology_source_mapping["mini-bobmulti-2"] = "bob-multi-purpose-furnace-2"

	-- Handle fluid boxes for the assembly furnaces
	local assembly_furnaces = {
		"mini-bobchem-1",
		"mini-bobmetal-1",
		"mini-bobmulti-1",
		"mini-bobmulti-2",
	}

	for _, name in pairs(assembly_furnaces) do
		local entity = data.raw["assembling-machine"][name]
		if not entity then
			goto continue
		end

		if entity.fluid_boxes then
			-- Fetch tint
			local tint = entity.fluid_boxes[1].pipe_picture.east.layers[2].tint

			-- Set to standard pipe pictures for now; TODO: Custom pipe pictures
			entity.fluid_boxes[1].pipe_picture = reskins.bobs.assembly_pipe_pictures(tint)
		end

		::continue::
	end
end

---@type data.IconData
local mini_machine_icon_overlay = {
	icon = "__reskins-library__/graphics/icons/mini-machine-overlay.png",
	icon_size = 64,
	scale = 0.5,
}

local mini_recycler = data.raw["furnace"]["mini-recycler-1"]
if mini_recycler then
	---@type DeferrableIconData
	local deferrable_icon = {
		name = "mini-recycler-1",
		type_name = "furnace",
		icon_data = {
			{
				icon = "__reskins-compatibility__/graphics/icons/mini-machines/mini-recycler.png",
				icon_size = 64,
				scale = 0.5,
			},
			mini_machine_icon_overlay,
		},
	}

	reskins.lib.icons.assign_deferrable_icon(deferrable_icon)

	technology_source_mapping["mini-recycler-1"] = "recycling"
end

---
---Copies the standard-sized technology icon from the source technology, rescales it to 80% of its
---original size, adds the mini-machine overlay, and sets it on the target technology.
---
---### Parameters
---@param target_name string # The name of the target item to receive the miniature-sized technology.
---@param source_name string # The name of the source item with the standard-sized technology.
local function set_rescaled_version_of_source_technology_on_target(target_name, source_name)
	-- Setup source and destination locals
	local source = data.raw["technology"][source_name]
	local target = data.raw["technology"][target_name]

	if not target or not source then
		return
	end

	---@type data.IconData
	local base_layer = {
		icon = "__reskins-library__/graphics/technology/mini-machine-underlay.png",
		icon_size = 256,
	}

	---@type data.IconData
	local overlay_layer = {
		icon = "__reskins-library__/graphics/technology/mini-machine-overlay.png",
		icon_size = 256,
	}

	local sourced_icon_data = reskins.lib.icons.get_icon_from_prototype_by_reference(source)
	local scaled_icon_data = reskins.lib.icons.scale_icon(sourced_icon_data, 0.8)
	local combined_icon_data = reskins.lib.icons.combine_icons(true, base_layer, scaled_icon_data, overlay_layer)

	reskins.lib.icons.clear_icon_from_prototype_by_reference(target)
	target.icons = combined_icon_data
end

-- Create new technology icons.
reskins.internal.create_icons_from_list(technology_icons_to_create, { mod = "compatibility", type = "technology" })

-- Miniaturize the new technology icons.
for name, _ in pairs(technology_icons_to_create) do
	set_rescaled_version_of_source_technology_on_target(name, name)
end

-- Miniaturize the linked techs
for name, source in pairs(technology_source_mapping) do
	set_rescaled_version_of_source_technology_on_target(name, source)
end

---The group of the mini-machine overlay, which the item icon draws and the item pictures do not.
---@type IconCompositionGroup
local mini_machine_overlay_group = {
	name = "mini-machine-overlay",
	stratum = "symbol",
	tintable = false,
	projections = { pictures = false },
}

---Gets the definition of the icon of the target prototype for the given `map`, with the tint and tier of the source
---prototype and the mini-machine overlay, if the icon of the source item uses images from Artisanal Reskins.
---@param map MiniMachineParameters
---@return TieredIconDefinition?
local function get_mini_icon_definition(map)
	local source = data.raw["item"][map.source]
	local icons = reskins.lib.icons.get_icon_from_prototype_by_reference(source)
	if not icons then
		return nil
	end

	if not reskins.lib.icons.is_icons_using_reskins_images(icons) then
		return nil
	end

	local tier = _framework.tiers.get_tier(map.tier, map.prog_tier)
	local params = util.copy(map.icon_params or {})
	params.tint = map.tint or _framework.tiers.get_tint(tier)

	local overlay = _assets.icons.get_minified_symbol_overlay()
	local composition = map.get_icon_composition(params):add(mini_machine_overlay_group, overlay)

	return { composition = composition, tier = tier }
end

---@type table<string, TieredIconDefinition>
local mini_machine_icons = {}

for name, map in pairs(mini_machine_maps) do
	local source_prototype = data.raw[map.type_name][map.source]
	local target_prototype = data.raw[map.type_name][name]

	if source_prototype and target_prototype then
		reskins.lib.prototypes.rescale_remnants_of_prototype(target_prototype, map.scale)
		mini_machine_icons[name] = get_mini_icon_definition(map)
	end
end

_framework.tiers.assign_icons_with_tier_labels("item", mini_machine_icons)
