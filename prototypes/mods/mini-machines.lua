-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Check for mini-machines
if not mods["mini-machines"] then return end

-- Setup technologies table
local technology_source_mapping = {}

---@type CreateIconsFromListTable
local technology_icons_to_create = {}

---Maps a standard-sized prototype to a miniature-sized prototype.
---@class MiniMachineParameters
---@field source string # The name of the source standard-sized prototype.
---@field scale double # The ratio of bounding box side length in tiles of the source and target prototypes.
---@field type_name string # The type name of the source and target prototypes.
---@field pattern? string # The pattern to search for within each filename. If omitted, searches for `type_name`.
---@field replacement? string # The string to substitute within each filename to point to the miniature version. If omitted, uses `type_name`.

---@type { [string]: MiniMachineParameters }
local mini_machine_maps = {}

-- Chemical plants
if reskins.compatibility.triggers.minimachines.chemplants.angels then
    -- Use Angel's chemical plants.
    mini_machine_maps["mini-chemplant-1"] = { source = "angels-chemical-plant", type_name = "assembling-machine", scale = 2 / 3, pattern = "chemical%-plant", replacement = "chemical-plant" }
    mini_machine_maps["mini-chemplant-2"] = { source = "angels-chemical-plant-2", type_name = "assembling-machine", scale = 2 / 3, pattern = "chemical%-plant", replacement = "chemical-plant" }
    mini_machine_maps["mini-chemplant-3"] = { source = "angels-chemical-plant-3", type_name = "assembling-machine", scale = 2 / 3, pattern = "chemical%-plant", replacement = "chemical-plant" }
    mini_machine_maps["mini-chemplant-4"] = { source = "angels-chemical-plant-4", type_name = "assembling-machine", scale = 2 / 3, pattern = "chemical%-plant", replacement = "chemical-plant" }

    -- Technologies
    -- TODO: Add icons for Angel's chem plants.
    -- originated_technologies["mini-chemplant-1"] = {mod = "bobs", group = "assembly", tier = 1, prog_tier = 2, icon_name = "chemical-plant"}
    -- linked_technologies["mini-chemplant-2"] = "chemical-plant-2"
    -- linked_technologies["mini-chemplant-3"] = "chemical-plant-3"
    -- linked_technologies["mini-chemplant-4"] = "chemical-plant-4"
elseif reskins.compatibility.triggers.minimachines.chemplants.bobs then
    -- Use Bob's chemical plants.
    mini_machine_maps["mini-chemplant-1"] = { source = "chemical-plant", type_name = "assembling-machine", scale = 2 / 3, pattern = "chemical%-plant", replacement = "chemical-plant" }
    mini_machine_maps["mini-chemplant-2"] = { source = "chemical-plant-2", type_name = "assembling-machine", scale = 2 / 3, pattern = "chemical%-plant", replacement = "chemical-plant" }
    mini_machine_maps["mini-chemplant-3"] = { source = "chemical-plant-3", type_name = "assembling-machine", scale = 2 / 3, pattern = "chemical%-plant", replacement = "chemical-plant" }
    mini_machine_maps["mini-chemplant-4"] = { source = "chemical-plant-4", type_name = "assembling-machine", scale = 2 / 3, pattern = "chemical%-plant", replacement = "chemical-plant" }

    technology_icons_to_create["mini-chemplant-1"] = {
        mod = "bobs",
        group = "assembly",
        tier = 1,
        prog_tier = 2,
        icon_name = "chemical-plant",
    }

    technology_source_mapping["mini-chemplant-2"] = "chemical-plant-2"
    technology_source_mapping["mini-chemplant-3"] = "chemical-plant-3"
    technology_source_mapping["mini-chemplant-4"] = "chemical-plant-4"
end

-- Electrolysers
if reskins.compatibility.triggers.minimachines.electrolysers then
    mini_machine_maps["mini-electro-1"] = { source = "electrolyser", type_name = "assembling-machine", scale = 2 / 3, pattern = "electrolyser", replacement = "electrolyser" }
    mini_machine_maps["mini-electro-2"] = { source = "electrolyser-2", type_name = "assembling-machine", scale = 2 / 3, pattern = "electrolyser", replacement = "electrolyser" }
    mini_machine_maps["mini-electro-3"] = { source = "electrolyser-3", type_name = "assembling-machine", scale = 2 / 3, pattern = "electrolyser", replacement = "electrolyser" }
    mini_machine_maps["mini-electro-4"] = { source = "electrolyser-4", type_name = "assembling-machine", scale = 2 / 3, pattern = "electrolyser", replacement = "electrolyser" }
    mini_machine_maps["mini-electro-5"] = { source = "electrolyser-5", type_name = "assembling-machine", scale = 2 / 3, pattern = "electrolyser", replacement = "electrolyser" }

    technology_icons_to_create["mini-electro-1"] = {
        mod = "bobs",
        group = "assembly",
        tier = 1,
        technology_icon_size = 256,
        technology_icon_mipmaps = 4,
        icon_name = "electrolyser",
        icon_base = "electrolyser-1",
        icon_mask = "electrolyser-1",
        icon_highlights = "electrolyser-1"
    }

    technology_source_mapping["mini-electro-2"] = "electrolyser-2"
    technology_source_mapping["mini-electro-3"] = "electrolyser-3"
    technology_source_mapping["mini-electro-4"] = "electrolyser-4"
    technology_source_mapping["mini-electro-5"] = "electrolyser-5"
end

-- Assembling machines
if reskins.compatibility.triggers.minimachines.assemblers then
    mini_machine_maps["mini-assembler-1"] = { source = "assembling-machine-1", type_name = "assembling-machine", scale = 2 / 3, pattern = "assembling%-machine" }
    mini_machine_maps["mini-assembler-2"] = { source = "assembling-machine-2", type_name = "assembling-machine", scale = 2 / 3, pattern = "assembling%-machine" }
    mini_machine_maps["mini-assembler-3"] = { source = "assembling-machine-3", type_name = "assembling-machine", scale = 2 / 3, pattern = "assembling%-machine" }
    mini_machine_maps["mini-assembler-4"] = { source = "assembling-machine-4", type_name = "assembling-machine", scale = 2 / 3, pattern = "assembling%-machine" }
    mini_machine_maps["mini-assembler-5"] = { source = "assembling-machine-5", type_name = "assembling-machine", scale = 2 / 3, pattern = "assembling%-machine" }
    mini_machine_maps["mini-assembler-6"] = { source = "assembling-machine-6", type_name = "assembling-machine", scale = 2 / 3, pattern = "assembling%-machine" }

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
    mini_machine_maps["mini-miner-1"] = { source = "electric-mining-drill", type_name = "mining-drill", scale = 2 / 3, pattern = "electric%-mining%-drill", replacement = "electric-mining-drill" }
    mini_machine_maps["mini-miner-2"] = { source = "bob-mining-drill-1", type_name = "mining-drill", scale = 2 / 3, pattern = "electric%-mining%-drill", replacement = "electric-mining-drill" }
    mini_machine_maps["mini-miner-3"] = { source = "bob-mining-drill-2", type_name = "mining-drill", scale = 2 / 3, pattern = "electric%-mining%-drill", replacement = "electric-mining-drill" }
    mini_machine_maps["mini-miner-4"] = { source = "bob-mining-drill-3", type_name = "mining-drill", scale = 2 / 3, pattern = "electric%-mining%-drill", replacement = "electric-mining-drill" }
    mini_machine_maps["mini-miner-5"] = { source = "bob-mining-drill-4", type_name = "mining-drill", scale = 2 / 3, pattern = "electric%-mining%-drill", replacement = "electric-mining-drill" }

    technology_icons_to_create["mini-miner-1"] = { mod = "bobs", group = "mining", tier = 1, icon_name = "mining-drill" }

    technology_source_mapping["mini-miner-2"] = "bob-drills-1"
    technology_source_mapping["mini-miner-3"] = "bob-drills-2"
    technology_source_mapping["mini-miner-4"] = "bob-drills-3"
    technology_source_mapping["mini-miner-5"] = "bob-drills-4"
end

-- Radars
if reskins.compatibility.triggers.minimachines.radar then
    mini_machine_maps["mini-radar-1"] = { source = "radar", type_name = "radar", scale = 2 / 3 }
    mini_machine_maps["mini-radar-2"] = { source = "radar-2", type_name = "radar", scale = 2 / 3 }
    mini_machine_maps["mini-radar-3"] = { source = "radar-3", type_name = "radar", scale = 2 / 3 }
    mini_machine_maps["mini-radar-4"] = { source = "radar-4", type_name = "radar", scale = 2 / 3 }
    mini_machine_maps["mini-radar-5"] = { source = "radar-5", type_name = "radar", scale = 2 / 3 }

    if reskins.lib.version.is_same_or_newer(mods["bobpower"], "1.1.6") then
        technology_icons_to_create["mini-radar-1"] = { mod = "bobs", group = "warfare", tier = 1, icon_name = "radar" }

        technology_source_mapping["mini-radar-2"] = "radars-2"
        technology_source_mapping["mini-radar-3"] = "radars-3"
        technology_source_mapping["mini-radar-4"] = "radars-4"
        technology_source_mapping["mini-radar-5"] = "radars-5"
    else
        technology_icons_to_create["mini-radar-1"] = { mod = "bobs", group = "warfare", tier = 1, icon_name = "radar" }

        technology_source_mapping["mini-radar-2"] = "radars"
        technology_source_mapping["mini-radar-3"] = "radars-2"
        technology_source_mapping["mini-radar-4"] = "radars-3"
        technology_source_mapping["mini-radar-5"] = "radars-4"
    end
end

if reskins.compatibility.triggers.minimachines.refineries then
    mini_machine_maps["mini-refinery-1"] = { source = "oil-refinery", type_name = "assembling-machine", scale = 3 / 5, pattern = "oil%-refinery", replacement = "oil-refinery" }
    mini_machine_maps["mini-refinery-2"] = { source = "oil-refinery-2", type_name = "assembling-machine", scale = 3 / 5, pattern = "oil%-refinery", replacement = "oil-refinery" }
    mini_machine_maps["mini-refinery-3"] = { source = "oil-refinery-3", type_name = "assembling-machine", scale = 3 / 5, pattern = "oil%-refinery", replacement = "oil-refinery" }
    mini_machine_maps["mini-refinery-4"] = { source = "oil-refinery-4", type_name = "assembling-machine", scale = 3 / 5, pattern = "oil%-refinery", replacement = "oil-refinery" }

    technology_icons_to_create["mini-refinery-1"] = { mod = "bobs", group = "assembly", tier = 1, prog_tier = 2, icon_name = "oil-refinery" }

    technology_source_mapping["mini-refinery-2"] = "oil-processing-2"
    technology_source_mapping["mini-refinery-3"] = "oil-processing-3"
    technology_source_mapping["mini-refinery-4"] = "oil-processing-4"
end

if reskins.compatibility.triggers.minimachines.storagetanks then
    mini_machine_maps["mini-tank-1"] = { source = "storage-tank", type_name = "storage-tank", scale = 2 / 3, pattern = "storage%-tank", replacement = "storage-tank" }
    mini_machine_maps["mini-tank-2"] = { source = "storage-tank-2", type_name = "storage-tank", scale = 2 / 3, pattern = "storage%-tank", replacement = "storage-tank" }
    mini_machine_maps["mini-tank-3"] = { source = "storage-tank-3", type_name = "storage-tank", scale = 2 / 3, pattern = "storage%-tank", replacement = "storage-tank" }
    mini_machine_maps["mini-tank-4"] = { source = "storage-tank-4", type_name = "storage-tank", scale = 2 / 3, pattern = "storage%-tank", replacement = "storage-tank" }

    technology_icons_to_create["mini-tank-1"] = { group = "mini-machine", tier = 1, prog_tier = 2, icon_name = "storage-tank" }
    technology_icons_to_create["mini-tank-2"] = { group = "mini-machine", tier = 2, prog_tier = 3, icon_name = "storage-tank" }
    technology_icons_to_create["mini-tank-3"] = { group = "mini-machine", tier = 3, prog_tier = 4, icon_name = "storage-tank" }
    technology_icons_to_create["mini-tank-4"] = { group = "mini-machine", tier = 4, prog_tier = 5, icon_name = "storage-tank" }
end

if reskins.compatibility.triggers.minimachines.beacons then
    mini_machine_maps["mini-beacon-1"] = { source = "beacon", type_name = "beacon", scale = 2 / 3 }
    mini_machine_maps["mini-beacon-2"] = { source = "beacon-2", type_name = "beacon", scale = 2 / 3 }
    mini_machine_maps["mini-beacon-3"] = { source = "beacon-3", type_name = "beacon", scale = 2 / 3 }
end

if reskins.compatibility.triggers.minimachines.furnaces then
    mini_machine_maps["mini-furnace-1"]          = { source = "electric-furnace", type_name = "furnace", scale = 2 / 3, pattern = "electric%-furnace", replacement = "electric-furnace" }
    mini_machine_maps["mini-furnace-2"]          = { source = "electric-furnace-2", type_name = "furnace", scale = 2 / 3, pattern = "electric%-furnace", replacement = "electric-furnace" }
    mini_machine_maps["mini-furnace-3"]          = { source = "electric-furnace-3", type_name = "furnace", scale = 2 / 3, pattern = "electric%-furnace", replacement = "electric-furnace" }
    mini_machine_maps["mini-bobchem-1"]          = { source = "electric-chemical-furnace", type_name = "assembling-machine", scale = 2 / 3, pattern = "electric%-chemical%-furnace", replacement = "electric-chemical-furnace" }
    mini_machine_maps["mini-bobmetal-1"]         = { source = "electric-mixing-furnace", type_name = "assembling-machine", scale = 2 / 3, pattern = "electric%-mixing%-furnace", replacement = "electric-mixing-furnace" }
    mini_machine_maps["mini-bobmulti-1"]         = { source = "electric-chemical-mixing-furnace", type_name = "assembling-machine", scale = 2 / 3, pattern = "electric%-chemical%-mixing%-furnace", replacement = "electric-chemical-mixing-furnace" }
    mini_machine_maps["mini-bobmulti-2"]         = { source = "electric-chemical-mixing-furnace-2", type_name = "assembling-machine", scale = 2 / 3, pattern = "electric%-chemical%-mixing%-furnace", replacement = "electric-chemical-mixing-furnace" }

    technology_source_mapping["mini-furnace-1"]  = "advanced-material-processing-2"
    technology_source_mapping["mini-furnace-2"]  = "advanced-material-processing-3"
    technology_source_mapping["mini-furnace-3"]  = "advanced-material-processing-4"
    technology_source_mapping["mini-bobmetal-1"] = "electric-mixing-furnace"
    technology_source_mapping["mini-bobchem-1"]  = "electric-chemical-furnace"
    technology_source_mapping["mini-bobmulti-1"] = "multi-purpose-furnace-1"
    technology_source_mapping["mini-bobmulti-2"] = "multi-purpose-furnace-2"

    -- Handle fluid boxes for the assembly furnaces
    local assembly_furnaces                      = {
        "mini-bobchem-1",
        "mini-bobmetal-1",
        "mini-bobmulti-1",
        "mini-bobmulti-2",
    }

    for _, name in pairs(assembly_furnaces) do
        local entity = data.raw["assembling-machine"][name]
        if not entity then return end

        if entity.fluid_boxes then
            -- Fetch tint
            local tint = entity.fluid_boxes[1].pipe_picture.east.layers[2].tint

            -- Set to standard pipe pictures for now; TODO: Custom pipe pictures
            entity.fluid_boxes[1].pipe_picture = reskins.bobs.assembly_pipe_pictures(tint)
        end
    end
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

    if not target or not source then return end

    ---@type data.IconData
    local base_layer = {
        icon = "__reskins-library__/graphics/technology/mini-machine-underlay.png",
        icon_size = 256,
        icon_mipmaps = 1,
        scale = 1,
    }

    ---@type data.IconData
    local overlay_layer = {
        icon = "__reskins-library__/graphics/technology/mini-machine-overlay.png",
        icon_size = 256,
        icon_mipmaps = 3,
        scale = 1,
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

---@type data.IconData
local mini_machine_icon_overlay = {
    icon = "__reskins-library__/graphics/icons/mini-machine-overlay.png",
    icon_size = 64,
    icon_mipmaps = 2,
    scale = 0.5,
}

---
---Copies the standard-sized icons from the source item, switches them to the miniature version, and
---sets them on the target prototype.
---
---### Parameters
---@param target_name string # The name of the target item to receive the miniature-sized icons.
---@param source_name string # The name of the source item with the standard-sized icons.
---@param pattern string # The pattern to search for within each filename.
---@param replacement string # The string to substitute within each filename to point to the miniature version.
local function set_mini_version_of_source_icon_on_target(target_name, source_name, pattern, replacement)
    local source = data.raw["item"][source_name]
    local icons = reskins.lib.icons.get_icon_from_prototype_by_reference(source)
    if not icons then return end

    if not reskins.lib.icons.is_icons_using_reskins_images(icons) then return end

    -- Switch to mini image set.
    for n = 1, #icons do

        icons[n].icon = string.gsub(icons[n].icon, "/" .. pattern .. "/", "/" .. replacement .. "/mini-")
    end

    table.insert(icons, mini_machine_icon_overlay)

    local pictures = util.copy(source.pictures)
    if pictures then
        if pictures.layers then
            for n = 1, #pictures.layers do
                pictures.layers[n].filename = string.gsub(pictures.layers[n].filename, "/" .. pattern .. "/", "/" .. replacement .. "/mini-")
            end
        else
            pictures[1].filename = string.gsub(pictures[1].filename, "/" .. pattern .. "/", "/" .. replacement .. "/mini-")
        end
    end

    ---@type DeferrableIconData
    local deferrable_icon = {
        name = target_name,
        type_name = "item",
        icon_data = icons,
        pictures = pictures,
    }

    reskins.lib.icons.assign_deferrable_icon(deferrable_icon)
end

for name, map in pairs(mini_machine_maps) do
    local source_prototype = data.raw[map.type_name][map.source]
    local target_prototype = data.raw[map.type_name][name]

    if not source_prototype or not target_prototype then return end

    reskins.lib.prototypes.rescale_remnants_of_prototype(target_prototype, map.scale)
    set_mini_version_of_source_icon_on_target(name, map.source, map.pattern or map.type_name, map.replacement or map.type_name)
end
