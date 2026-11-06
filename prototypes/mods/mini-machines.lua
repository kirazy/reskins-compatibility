-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

---@using data
---@using Reskins.Framework
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
local _sprite_utils = {
	icons = require("__reskins-sprite-utils__.icons"),
	sprites = require("__reskins-sprite-utils__.sprites"),
}

local IconComposition = require("__reskins-sprite-utils__.icon-composition")

local AssemblingMachineOriginal = require("__reskins-assets-api__.assets.assorted.entities.assembling-machine-original")
local ChemicalPlantTechnology = require("__reskins-assets-api__.assets.bobs.technologies.chemical-plant")
local Electrolyser1Technology = require("__reskins-assets-api__.assets.bobs.technologies.electrolyser-1")
local MiningDrillTechnology = require("__reskins-assets-api__.assets.bobs.technologies.mining-drill")
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
local MiniRecycler = require("__reskins-assets-api__.assets.assorted.items.mini-recycler")
local MiniStorageTank = require("__reskins-assets-api__.assets.assorted.items.mini-storage-tank")
local OilRefineryTechnology = require("__reskins-assets-api__.assets.bobs.technologies.oil-refinery")
local RadarTechnology = require("__reskins-assets-api__.assets.bobs.technologies.radar")
local StorageTankTechnology = require("__reskins-assets-api__.assets.bobs.technologies.storage-tank")

-- Setup technologies table
local technology_source_mapping = {}

---Defines the technology icon of a miniature machine technology that is taken from a technology icon catalog.
---@class MiniTechnologyIconParameters
---The creator of the technology icon, which is given the tint of the tier and `icon_params`.
---@field get_icon_composition fun(params: table): IconComposition
---The parameters of `get_icon_composition` other than the tint, if any.
---@field icon_params? table
---The tier of the technology icon.
---@field tier Tier
---The progression tier of the technology icon, if any.
---@field prog_tier? Tier

---The technology icon of each miniature machine technology that takes its icon from a technology icon catalog, by the
---name of the technology.
---@type table<string, MiniTechnologyIconParameters>
local technology_icons = {}

---Maps a standard-sized prototype to a miniature-sized prototype.
---@class MiniMachineParameters
---@field source string # The name of the source standard-sized prototype.
---@field scale double # The ratio of bounding box side length in tiles of the source and target prototypes.
---@field type_name string # The type name of the source and target prototypes.
---The tier of the source prototype.
---@field tier Tier
---The progression tier of the source prototype, if any.
---@field prog_tier? Tier
---When `true`, indicates that the icon of the target prototype takes the tint of the first tinted layer of the
---animation of the source prototype, and the tint of the tier when the animation has no tinted layer. Default `false`.
---@field uses_source_tint? boolean
---The creator of the icon of the target prototype, which is given the tint and `icon_params`.
---@field get_icon_composition fun(params: table): IconComposition
---The parameters of `get_icon_composition` other than the tint, if any.
---@field icon_params? table

---@type { [string]: MiniMachineParameters }
local mini_machine_maps = {}

---The fields of a source prototype that hold its graphics.
local GRAPHICS_FIELDS = { "graphics_set", "wet_mining_graphics_set", "pictures" }

---Indicates whether the given table, or a table in it, has a `filename` or `filenames` field that names a file of an
---Artisanal Reskins mod.
---@param graphics table
---@return boolean
local function is_using_reskins_files(graphics)
	for key, value in pairs(graphics) do
		if key == "filename" and type(value) == "string" and value:find("^__reskins%-") then
			return true
		elseif key == "filenames" and type(value) == "table" then
			for _, filename in pairs(value) do
				if filename:find("^__reskins%-") then
					return true
				end
			end
		elseif type(value) == "table" and is_using_reskins_files(value) then
			return true
		end
	end

	return false
end

---Indicates whether the source prototype of the given `map` exists and its graphics use files of an Artisanal Reskins
---mod.
---@param map MiniMachineParameters
---@return boolean
local function is_source_reskinned(map)
	local source = data.raw[map.type_name][map.source]
	if not source then
		return false
	end

	for _, field in pairs(GRAPHICS_FIELDS) do
		if source[field] and is_using_reskins_files(source[field]) then
			return true
		end
	end

	return false
end

---Gets the tint of the first tinted layer of the animation of the source prototype of the given `map`, if any.
---@param map MiniMachineParameters
---@return Color?
local function get_source_tint(map)
	local source = data.raw[map.type_name][map.source]
	local animation = source and source.graphics_set and source.graphics_set.animation
	if not (animation and animation.layers) then
		return nil
	end

	for _, layer in ipairs(animation.layers) do
		if layer.tint then
			return layer.tint
		end
	end

	return nil
end

-- Chemical plants
-- Mini Machines makes the miniature chemical plants from the upgrades of the chemical plant, which are the chemical
-- plants of Angel's Petrochemical Processing when it has them, and those of Bob's Assembling Machines otherwise.
if data.raw["assembling-machine"]["angels-chemical-plant-2"] then
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
else
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

	technology_icons["mini-chemplant-1"] = {
		get_icon_composition = ChemicalPlantTechnology.get_icon_composition,
		tier = 1,
		prog_tier = 2,
	}

	technology_source_mapping["mini-chemplant-2"] = "bob-chemical-plant-2"
	technology_source_mapping["mini-chemplant-3"] = "bob-chemical-plant-3"
	technology_source_mapping["mini-chemplant-4"] = "bob-chemical-plant-4"
end

-- Electrolysers
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

technology_icons["mini-bobelectro-1"] = {
	get_icon_composition = Electrolyser1Technology.get_icon_composition,
	tier = 1,
}

technology_source_mapping["mini-bobelectro-2"] = "bob-electrolyser-2"
technology_source_mapping["mini-bobelectro-3"] = "bob-electrolyser-3"
technology_source_mapping["mini-bobelectro-4"] = "bob-electrolyser-4"
technology_source_mapping["mini-bobelectro-5"] = "bob-electrolyser-5"

-- Assembling machines
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

-- Mining drills
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

technology_icons["mini-miner-1"] = {
	get_icon_composition = MiningDrillTechnology.get_icon_composition,
	icon_params = { variant = "standard" },
	tier = 1,
}

technology_source_mapping["mini-miner-2"] = "bob-drills-2"
technology_source_mapping["mini-miner-3"] = "bob-drills-3"
technology_source_mapping["mini-miner-4"] = "bob-drills-4"
technology_source_mapping["mini-miner-5"] = "bob-drills-5"

-- Radars
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

technology_icons["mini-radar-1"] = { get_icon_composition = RadarTechnology.get_icon_composition, tier = 1 }

technology_source_mapping["mini-radar-2"] = "bob-radar-2"
technology_source_mapping["mini-radar-3"] = "bob-radar-3"
technology_source_mapping["mini-radar-4"] = "bob-radar-4"
technology_source_mapping["mini-radar-5"] = "bob-radar-5"

-- Mini Machines makes the miniature refineries from the upgrades of the oil refinery, which are the oil refineries of
-- Angel's Petrochemical Processing when it has them, and those of Bob's Assembling Machines otherwise.
local is_using_angels_refineries = data.raw["assembling-machine"]["angels-oil-refinery-2"] ~= nil
local refinery_prefix = is_using_angels_refineries and "angels-oil-refinery-" or "bob-oil-refinery-"

mini_machine_maps["mini-refinery-1"] = {
	source = "oil-refinery",
	type_name = "assembling-machine",
	scale = 3 / 5,
	tier = 1,
	prog_tier = 2,
	get_icon_composition = MiniOilRefinery.get_icon_composition,
}
mini_machine_maps["mini-refinery-2"] = {
	source = refinery_prefix .. "2",
	type_name = "assembling-machine",
	scale = 3 / 5,
	tier = 2,
	prog_tier = 3,
	get_icon_composition = MiniOilRefinery.get_icon_composition,
}
mini_machine_maps["mini-refinery-3"] = {
	source = refinery_prefix .. "3",
	type_name = "assembling-machine",
	scale = 3 / 5,
	tier = 3,
	prog_tier = 4,
	get_icon_composition = MiniOilRefinery.get_icon_composition,
}
mini_machine_maps["mini-refinery-4"] = {
	source = refinery_prefix .. "4",
	type_name = "assembling-machine",
	scale = 3 / 5,
	tier = 4,
	prog_tier = 5,
	get_icon_composition = MiniOilRefinery.get_icon_composition,
}

technology_icons["mini-refinery-1"] = {
	get_icon_composition = OilRefineryTechnology.get_icon_composition,
	tier = 1,
	prog_tier = 2,
}

if is_using_angels_refineries then
	-- The technologies that unlock the refineries of Angel's Petrochemical Processing have no refinery icon.
	--stylua: ignore start
	technology_icons["mini-refinery-2"] = { get_icon_composition = OilRefineryTechnology.get_icon_composition, tier = 2, prog_tier = 3 }
	technology_icons["mini-refinery-3"] = { get_icon_composition = OilRefineryTechnology.get_icon_composition, tier = 3, prog_tier = 4 }
	technology_icons["mini-refinery-4"] = { get_icon_composition = OilRefineryTechnology.get_icon_composition, tier = 4, prog_tier = 5 }
	--stylua: ignore end
else
	technology_source_mapping["mini-refinery-2"] = "oil-processing-2"
	technology_source_mapping["mini-refinery-3"] = "oil-processing-3"
	technology_source_mapping["mini-refinery-4"] = "oil-processing-4"
end

--stylua: ignore start
mini_machine_maps["mini-centrifuge-1"] = { source = "centrifuge", type_name = "assembling-machine", scale = 2 / 3, tier = 1, prog_tier = 3, get_icon_composition = MiniCentrifuge.get_icon_composition }
mini_machine_maps["mini-centrifuge-2"] = { source = "bob-centrifuge-2", type_name = "assembling-machine", scale = 2 / 3, tier = 2, prog_tier = 4, get_icon_composition = MiniCentrifuge.get_icon_composition }
mini_machine_maps["mini-centrifuge-3"] = { source = "bob-centrifuge-3", type_name = "assembling-machine", scale = 2 / 3, tier = 3, prog_tier = 5, get_icon_composition = MiniCentrifuge.get_icon_composition }
--stylua: ignore end

technology_source_mapping["mini-centrifuge-2"] = "bob-centrifuge-2"
technology_source_mapping["mini-centrifuge-3"] = "bob-centrifuge-3"

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
technology_icons["mini-tank-1"] = { get_icon_composition = StorageTankTechnology.get_icon_composition, tier = 1, prog_tier = 2 }
technology_icons["mini-tank-2"] = { get_icon_composition = StorageTankTechnology.get_icon_composition, tier = 2, prog_tier = 3 }
technology_icons["mini-tank-3"] = { get_icon_composition = StorageTankTechnology.get_icon_composition, tier = 3, prog_tier = 4 }
technology_icons["mini-tank-4"] = { get_icon_composition = StorageTankTechnology.get_icon_composition, tier = 4, prog_tier = 5 }
--stylua: ignore end

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
	uses_source_tint = true,
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
	uses_source_tint = true,
	get_icon_composition = MiniFurnaceElectricChemical.get_icon_composition,
}
mini_machine_maps["mini-bobmetal-1"] = {
	source = "bob-electric-mixing-furnace",
	type_name = "assembling-machine",
	scale = 2 / 3,
	tier = 3,
	uses_source_tint = true,
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
	if not (entity and is_source_reskinned(mini_machine_maps[name])) then
		goto continue
	end

	if entity.fluid_boxes then
		-- Fetch tint
		local tint = entity.fluid_boxes[1].pipe_picture.east.layers[2].tint

		-- Set to standard pipe pictures for now; TODO: Custom pipe pictures
		entity.fluid_boxes[1].pipe_picture = AssemblingMachineOriginal.get_pipe_pictures({ tint = tint })
	end

	::continue::
end

---The group of the mini-machine overlay, which the item icon draws and the item pictures do not.
---@type IconCompositionGroup
local mini_machine_overlay_group = {
	name = "mini-machine-overlay",
	stratum = "symbol",
	tintable = false,
	projections = { pictures = false },
}

local mini_recycler = data.raw["furnace"]["mini-recycler-1"]
if mini_recycler then
	local overlay = _assets.icons.get_minified_symbol_overlay()

	_sprite_utils.icons.apply_icon_assignment({
		name = "mini-recycler-1",
		type_name = "furnace",
		composition = MiniRecycler.get_icon_composition():add(mini_machine_overlay_group, overlay),
	})
end

---Gets the definition of the icon of a miniature machine technology, which draws the given `content` at 80% of its
---size between the underlay and the overlay of a miniature machine technology icon.
---@param content IconCompositionContent
---@return IconDefinition
local function get_mini_technology_icon_definition(content)
	local underlay = _assets.icons.get_minified_technology_underlay()

	return {
		composition = IconComposition:from_icon(underlay, nil, "technology")
			:add_canvas(content, { scale = 0.8 })
			:add_symbol(_assets.icons.get_minified_technology_overlay()),
	}
end

---@type table<string, IconDefinition>
local technology_icon_definitions = {}

-- Miniaturize the technology icon of each catalog in the tint of the tier of each technology.
for name, options in pairs(technology_icons) do
	if is_source_reskinned(mini_machine_maps[name]) then
		local params = util.copy(options.icon_params or {})
		params.tint = _framework.tiers.get_tint(_framework.tiers.get_tier(options.tier, options.prog_tier))

		technology_icon_definitions[name] = get_mini_technology_icon_definition(options.get_icon_composition(params))
	end
end

-- Miniaturize the linked techs
for name, source_name in pairs(technology_source_mapping) do
	local source = data.raw["technology"][source_name]
	if source and is_source_reskinned(mini_machine_maps[name]) then
		technology_icon_definitions[name] =
			get_mini_technology_icon_definition(_sprite_utils.icons.get_icon_from_prototype(source))
	end
end

local recycling = data.raw["technology"]["recycling"]
if mini_recycler and recycling then
	technology_icon_definitions["mini-recycler-1"] =
		get_mini_technology_icon_definition(_sprite_utils.icons.get_icon_from_prototype(recycling))
end

_sprite_utils.icons.assign_icons("technology", technology_icon_definitions)

---Gets the definition of the icon of the target prototype for the given `map`, with the tint and tier of the source
---prototype and the mini-machine overlay.
---@param map MiniMachineParameters
---@return TieredIconDefinition
local function get_mini_icon_definition(map)
	local tier = _framework.tiers.get_tier(map.tier, map.prog_tier)
	local params = util.copy(map.icon_params or {})
	params.tint = map.uses_source_tint and get_source_tint(map) or _framework.tiers.get_tint(tier)

	local overlay = _assets.icons.get_minified_symbol_overlay()
	local composition = map.get_icon_composition(params):add(mini_machine_overlay_group, overlay)

	return { composition = composition, tier = tier }
end

---@type table<string, TieredIconDefinition>
local mini_machine_icons = {}

for name, map in pairs(mini_machine_maps) do
	local target_prototype = data.raw[map.type_name][name]

	if target_prototype and is_source_reskinned(map) then
		_sprite_utils.sprites.rescale_remnants_of_prototype(target_prototype, map.scale)
		mini_machine_icons[name] = get_mini_icon_definition(map)
	end
end

_framework.tiers.assign_icons_with_tier_labels("item", mini_machine_icons)
