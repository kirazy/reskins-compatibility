-- cspell: words minifiable

-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

---@using data
---@using Reskins.Framework
---@using Reskins.SpriteUtils

if not (mods["mini-machines"] or mods["micro-machines"]) then
	return
end

local _assets = {
	defines = require("__reskins-assets-api__.api.defines"),
	icons = require("__reskins-assets-api__.api.icons"),
}
local _framework = { tiers = require("__reskins-framework__.api.tiers") }
local _sprite_utils = {
	icons = require("__reskins-sprite-utils__.icons"),
	sprites = require("__reskins-sprite-utils__.sprites"),
}

local IconComposition = require("__reskins-sprite-utils__.icon-composition")

local Corpses = require("__reskins-assets-api__.api.corpses")

local AssemblingMachineOriginal = require("__reskins-assets-api__.assets.assorted.entities.assembling-machine-original")
local ChemicalPlantTechnology = require("__reskins-assets-api__.assets.bobs.technologies.chemical-plant")
local Electrolyser1Technology = require("__reskins-assets-api__.assets.bobs.technologies.electrolyser-1")
local MiningDrillTechnology = require("__reskins-assets-api__.assets.bobs.technologies.mining-drill")
local OilRefineryTechnology = require("__reskins-assets-api__.assets.bobs.technologies.oil-refinery")
local RadarTechnology = require("__reskins-assets-api__.assets.bobs.technologies.radar")
local StorageTankTechnology = require("__reskins-assets-api__.assets.bobs.technologies.storage-tank")

---Defines a size of the machines that Mini Machines and Micro Machines make from full-size machines.
---@class MachineSize
---The machines of the size, with the type name of each machine under its name.
---@field machines table<EntityID, string>
---The scale at which the icon of a machine draws the icon of its full-size machine.
---@field scale double
---The overlay on the icons of the machines.
---@field symbol_overlay SafeIconData
---The overlay on the technology icons of the machines.
---@field technology_overlay SafeIconData
---The technology on which the technologies of the machines depend.
---@field basic_technology TechnologyID

---Defines the fields that Mini Machines and Micro Machines set on each machine they make.
---@class MiniMicroMachinePrototype : EntityWithHealthPrototype
---The name of the full-size machine from which the machine is made.
---@field base_machine EntityID
---The name of the technology from which the technology of the machine is copied, if any.
---@field base_tech? TechnologyID
---The ratio of the tile size of the machine to the tile size of its full-size machine, if any.
---@field scale_value? double

---The sizes of the machines that Mini Machines and Micro Machines make, under the name of each size.
---@type table<"mini"|"micro", MachineSize>
local machine_sizes = {
	mini = {
		---@diagnostic disable-next-line: undefined-global
		machines = (added_mini_machines or {}) --[[@as table<EntityID, string>]],
		scale = 0.8,
		symbol_overlay = _assets.icons.get_minified_symbol_overlay(),
		technology_overlay = _assets.icons.get_minified_technology_overlay(),
		basic_technology = "mini-basic",
	},
	micro = {
		---@diagnostic disable-next-line: undefined-global
		machines = (added_micro_machines or {}) --[[@as table<EntityID, string>]],
		scale = 0.6,
		symbol_overlay = _assets.icons.get_twice_minified_symbol_overlay(),
		technology_overlay = _assets.icons.get_twice_minified_technology_overlay(),
		basic_technology = "micro-basic",
	},
}

---Defines the technology icon from a technology icon catalog for the technologies of the machines made from a
---full-size machine.
---@class MiniTechnologyIconParameters
---The creator of the technology icon, which is given the tint of the tier and `icon_params`.
---@field get_icon_composition fun(params: table): IconComposition
---The parameters of `get_icon_composition` other than the tint, if any.
---@field icon_params? table
---The tier of the technology icon.
---@field tier Tier
---The progression tier of the technology icon, if any.
---@field prog_tier? Tier

---The technology icons from the technology icon catalogs, under the name of the full-size machine. An icon is used when
---the full-size machine is reskinned.
---@type table<EntityID, MiniTechnologyIconParameters>
local technology_icons = {}

-- With Angel's Petrochemical Processing, the chemical plant draws the artwork of Angel's mods.
if not data.raw["assembling-machine"]["angels-chemical-plant-2"] then
	technology_icons["chemical-plant"] = {
		get_icon_composition = ChemicalPlantTechnology.get_icon_composition,
		tier = 1,
		prog_tier = 2,
	}
end

--stylua: ignore start
technology_icons["bob-electrolyser"] = { get_icon_composition = Electrolyser1Technology.get_icon_composition, tier = 1 }
technology_icons["electric-mining-drill"] = { get_icon_composition = MiningDrillTechnology.get_icon_composition, icon_params = { variant = "standard" }, tier = 1 }
technology_icons["radar"] = { get_icon_composition = RadarTechnology.get_icon_composition, tier = 1 }
technology_icons["oil-refinery"] = { get_icon_composition = OilRefineryTechnology.get_icon_composition, tier = 1, prog_tier = 2 }
technology_icons["storage-tank"] = { get_icon_composition = StorageTankTechnology.get_icon_composition, tier = 1, prog_tier = 2 }
technology_icons["bob-storage-tank-2"] = { get_icon_composition = StorageTankTechnology.get_icon_composition, tier = 2, prog_tier = 3 }
technology_icons["bob-storage-tank-3"] = { get_icon_composition = StorageTankTechnology.get_icon_composition, tier = 3, prog_tier = 4 }
technology_icons["bob-storage-tank-4"] = { get_icon_composition = StorageTankTechnology.get_icon_composition, tier = 4, prog_tier = 5 }

-- The technologies that unlock the refineries of Angel's Petrochemical Processing have no refinery icon.
technology_icons["angels-oil-refinery-2"] = { get_icon_composition = OilRefineryTechnology.get_icon_composition, tier = 2, prog_tier = 3 }
technology_icons["angels-oil-refinery-3"] = { get_icon_composition = OilRefineryTechnology.get_icon_composition, tier = 3, prog_tier = 4 }
technology_icons["angels-oil-refinery-4"] = { get_icon_composition = OilRefineryTechnology.get_icon_composition, tier = 4, prog_tier = 5 }
--stylua: ignore end

---The names of the full-size assembly furnaces for which the mini and micro machines draw the pipe pictures of the
---original assembling machine.
local ASSEMBLY_FURNACES = {
	["bob-electric-chemical-furnace"] = true,
	["bob-electric-mixing-furnace"] = true,
	["bob-electric-chemical-mixing-furnace"] = true,
	["bob-electric-chemical-mixing-furnace-2"] = true,
}

---The prefix of the files for the overlays that Mini/Micro Machines Core Mod adds to the icons of the full-size
---machines.
local CORE_MOD_OVERLAY_PREFIX = "__mini-micro-settings__/graphics/overlay/"

---The folder of the artwork for the generic remnants from the base game.
local GENERIC_REMNANTS_FOLDER = "__base__/graphics/entity/remnants/"

---The fields of a full-size machine that hold its graphics.
local GRAPHICS_FIELDS = {
	"graphics_set",
	"wet_mining_graphics_set",
	"pictures",
}

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

---Indicates whether the graphics of the given full-size `machine` use files of an Artisanal Reskins mod.
---@param machine EntityPrototype
---@return boolean
local function is_reskinned(machine)
	for _, field in pairs(GRAPHICS_FIELDS) do
		if machine[field] and is_using_reskins_files(machine[field]) then
			return true
		end
	end

	return false
end

---The group of the overlay that indicates the size of a machine, which the icon draws and the pictures do not.
---@type IconCompositionGroup
local size_overlay_group = {
	name = "machine-size-overlay",
	stratum = "symbol",
	tintable = false,
	projections = { pictures = false },
}

---The group of the numerals from Angel's mods, which the icon and the pictures draw at the size of the icon.
---@type IconCompositionGroup
local numeral_group = {
	name = "angels-numeral",
	stratum = "label",
	tintable = false,
	projections = { pictures = {} },
}

---Gets the group for the given `icon_datum`, which is the group of the numerals from Angel's mods for a layer of a
---numeral and the canvas group for any other layer.
---@param icon_datum IconData
---@return IconCompositionGroup
local function classify_numeral_layers(icon_datum)
	if icon_datum.icon:find("^__angelsrefininggraphics__/graphics/icons/numerals/") then
		return numeral_group
	end

	return IconComposition.canvas_group
end

---Gets a composition of the given `icon_data`, with its tier labels and the numerals from Angel's mods in label groups,
---which `minify` does not resize.
---@param icon_data IconData[]
---@param defaults_type IconDefaultsType
---@return IconComposition
local function get_machine_icon_composition(icon_data, defaults_type)
	local artwork, tier_labels = _framework.tiers.remove_tier_labels_from_icons(icon_data)
	local composition = IconComposition:from_classified_icons(artwork, classify_numeral_layers, defaults_type)

	if tier_labels then
		composition = composition:add(_framework.tiers.tier_label_group, tier_labels)
	end

	return composition
end

---Gets the icon for a machine of the given `size` as a composition, which draws the icon of the given full-size
---`machine` at the scale of the size, with the overlay of the size.
---@param machine EntityPrototype
---@param size MachineSize
---@return IconComposition
local function get_sized_icon_composition(machine, size)
	return get_machine_icon_composition(_sprite_utils.icons.get_icon_from_prototype(machine), "item")
		:minify(size.scale)
		:add(size_overlay_group, size.symbol_overlay)
end

---Gets the technology that unlocks the full-size machine of the given `entity`, as Mini Machines or Micro Machines
---records it, if any.
---@param entity MiniMicroMachinePrototype
---@return TechnologyPrototype?
local function get_full_size_technology(entity)
	local name = entity.base_tech

	-- Micro Machines copies the technology of a micro machine from that of its mini machine, if one exists.
	local mini_type = name and machine_sizes.mini.machines[name]
	if mini_type then
		local mini = data.raw[mini_type][name] --[[@as MiniMicroMachinePrototype?]]
		name = mini and mini.base_tech
	end

	-- The basic technology is recorded for a full-size machine that no technology unlocks.
	for _, size in pairs(machine_sizes) do
		if name == size.basic_technology then
			return nil
		end
	end

	return name and data.raw["technology"][name]
end

---Gets the content of the technology icon for the given `entity` made from the given full-size `machine`, which is the
---catalog icon for `machine` when `machine` is reskinned, the icon of the technology that unlocks `machine`, or the
---icon of `machine`, in that order of preference.
---@param entity MiniMicroMachinePrototype
---@param machine EntityPrototype
---@return IconCompositionContent
local function get_technology_icon_content(entity, machine)
	local options = technology_icons[machine.name]
	if options and is_reskinned(machine) then
		local params = util.copy(options.icon_params or {})
		params.tint = _framework.tiers.get_tint(_framework.tiers.get_tier(options.tier, options.prog_tier))

		return options.get_icon_composition(params)
	end

	local technology = get_full_size_technology(entity)
	if technology then
		return technology
	end

	return get_machine_icon_composition(_sprite_utils.icons.get_icon_from_prototype(machine), "item")
end

---Gets the definition of the technology icon for a machine of the given `size`, which draws the given `content` at the
---scale of the size, with the technology overlay of the size.
---@param content IconCompositionContent
---@param size MachineSize
---@return IconDefinition
local function get_technology_icon_definition(content, size)
	return {
		composition = IconComposition:from_icon(_sprite_utils.icons.empty_icon("technology"), nil, "technology")
			:add_canvas(content, { scale = size.scale })
			:add_symbol(size.technology_overlay),
	}
end

---Adds each file that the given table, or a table in it, names in a `filename` or `filenames` field to the given
---`filenames`, in place.
---@param graphics table
---@param filenames string[]
local function add_filenames(graphics, filenames)
	for key, value in pairs(graphics) do
		if key == "filename" and type(value) == "string" then
			filenames[#filenames + 1] = value
		elseif key == "filenames" and type(value) == "table" then
			for _, filename in pairs(value) do
				filenames[#filenames + 1] = filename
			end
		elseif type(value) == "table" then
			add_filenames(value, filenames)
		end
	end
end

---Indicates whether the corpses of the given full-size `machine` draw only the artwork of the generic remnants from the
---base game.
---@param machine EntityWithHealthPrototype
---@return boolean
local function has_generic_remnants(machine)
	local corpse_names = type(machine.corpse) == "table" and machine.corpse or { machine.corpse }

	---@type string[]
	local filenames = {}
	for _, corpse_name in pairs(corpse_names) do
		local corpse = data.raw["corpse"][corpse_name]
		if corpse then
			add_filenames(corpse, filenames)
		end
	end

	for _, filename in pairs(filenames) do
		if filename:find(GENERIC_REMNANTS_FOLDER, 1, true) ~= 1 then
			return false
		end
	end

	return #filenames > 0
end

---Sets the corpse of the given `entity` to a copy of each corpse of the given full-size `machine`, rescaled by the
---given `scale`, in place. Each copy is added to `data.raw` under a name made from the name of `entity`, with the
---localised name of the remnants of `entity`.
---@param entity MiniMicroMachinePrototype
---@param machine EntityWithHealthPrototype
---@param scale double
local function rescale_remnants(entity, machine, scale)
	local corpse_names = type(machine.corpse) == "table" and machine.corpse or { machine.corpse }

	local localised_name = { "remnant-name", util.copy(entity.localised_name) or { "entity-name." .. entity.name } }

	---@type EntityID[]
	local rescaled_names = {}
	for index, corpse_name in pairs(corpse_names) do
		local corpse = data.raw["corpse"][corpse_name]
		if corpse then
			local rescaled = _sprite_utils.sprites.get_rescaled_prototype(corpse, scale)
			rescaled.name = "ar-" .. entity.name .. "-remnants" .. (index > 1 and "-" .. index or "")
			rescaled.localised_name = util.copy(localised_name)
			data:extend({ rescaled })

			rescaled_names[#rescaled_names + 1] = rescaled.name
		end
	end

	if #rescaled_names > 1 then
		entity.corpse = rescaled_names
	elseif #rescaled_names == 1 then
		entity.corpse = rescaled_names[1]
	end
end

---Gets the tint of the mask layer in the east pipe picture of the first fluid box of the given `furnace`, if any.
---@param furnace AssemblingMachinePrototype
---@return Color?
local function get_pipe_picture_tint(furnace)
	local fluid_box = furnace.fluid_boxes and furnace.fluid_boxes[1]
	local pipe_picture = fluid_box and fluid_box.pipe_picture
	local east = pipe_picture and pipe_picture.east
	local mask = east and east.layers and east.layers[2]

	return mask and mask.tint
end

---Sets the icon of each effect that has an icon in the given `technology` to a copy of the given `icon_data`, in place.
---@param technology TechnologyPrototype
---@param icon_data IconData[]
local function set_effect_icons(technology, icon_data)
	for _, effect in pairs(technology.effects or {}) do
		if effect.icons then
			effect.icons = util.copy(icon_data)
		end
	end
end

---Indicates whether the given `icon_datum` is an overlay from Mini/Micro Machines Core Mod.
---@param icon_datum IconData
---@return boolean
local function is_core_mod_overlay(icon_datum)
	return icon_datum.icon:find(CORE_MOD_OVERLAY_PREFIX, 1, true) == 1
end

---Indicates whether the icon of the given `prototype` has an overlay from Mini/Micro Machines Core Mod.
---@param prototype ItemPrototype
---@return boolean
local function has_core_mod_overlay(prototype)
	if not (prototype.icons or prototype.icon) then
		return false
	end

	for _, icon_datum in pairs(_sprite_utils.icons.get_icon_from_prototype(prototype)) do
		if is_core_mod_overlay(icon_datum) then
			return true
		end
	end

	return false
end

---Assigns the icon of the given full-size `machine`, with the overlay of a machine that can be minified, to `machine`
---and its related prototypes.
---@param machine EntityPrototype
local function assign_minifiable_icon(machine)
	local icon_data = _sprite_utils.icons.get_icon_from_prototype(machine)
	local composition = get_machine_icon_composition(icon_data, machine.type):add(
		size_overlay_group,
		_assets.icons.get_minifiable_symbol_overlay()
	)

	_sprite_utils.icons.apply_icon_assignment({ name = machine.name, type_name = machine.type, composition = composition })
end

---The full-size machines from which Mini Machines or Micro Machines makes machines, under their names.
---@type table<EntityID, EntityWithHealthPrototype>
local full_size_machines = {}

---@type table<string, IconDefinition>
local technology_icon_definitions = {}

for _, size in pairs(machine_sizes) do
	for name, type_name in pairs(size.machines) do
		local entity = data.raw[type_name][name] --[[@as MiniMicroMachinePrototype?]]
		local machine = entity and data.raw[type_name][entity.base_machine] --[[@as EntityWithHealthPrototype?]]
		if not (entity and machine) then
			goto continue
		end

		full_size_machines[machine.name] = machine

		local is_machine_reskinned = is_reskinned(machine)
		if is_machine_reskinned and has_generic_remnants(machine) then
			Corpses.apply(entity, _assets.defines.generic_remnants)
		elseif is_machine_reskinned and entity.scale_value then
			rescale_remnants(entity, machine, entity.scale_value)
		end

		local composition = get_sized_icon_composition(machine, size)
		_sprite_utils.icons.apply_icon_assignment({ name = name, type_name = type_name, composition = composition })

		local technology = data.raw["technology"][name]
		if technology then
			local content = get_technology_icon_content(entity, machine)
			technology_icon_definitions[name] = get_technology_icon_definition(content, size)
			set_effect_icons(technology, (composition:build({ to = "item" })))
		end

		if is_machine_reskinned and ASSEMBLY_FURNACES[machine.name] then
			local furnace = entity --[[@as AssemblingMachinePrototype]]
			local fluid_box = furnace.fluid_boxes and furnace.fluid_boxes[1]
			local tint = get_pipe_picture_tint(machine --[[@as AssemblingMachinePrototype]])

			if fluid_box and tint then
				fluid_box.pipe_picture = AssemblingMachineOriginal.get_pipe_pictures({ tint = tint })
			end
		end

		::continue::
	end
end

for _, size in pairs(machine_sizes) do
	technology_icon_definitions[size.basic_technology] = { icon_datum = size.technology_overlay }
end

_sprite_utils.icons.assign_icons("technology", technology_icon_definitions)

for name, machine in pairs(full_size_machines) do
	local item = data.raw["item"][name]
	if item and has_core_mod_overlay(item) then
		assign_minifiable_icon(machine)
	end
end
