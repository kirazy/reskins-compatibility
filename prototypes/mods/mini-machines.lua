-- Copyright (c) 2023 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Check for mini-machines
if not mods["mini-machines"] then return end

-- Setup technologies table
local linked_technologies = {}
local originated_technologies = {}

-- Chemical plants
if reskins.compatibility.triggers.minimachines.chemplants.angels then
    local chemplants = {
        ["mini-chemplant-1"] = "angels-chemical-plant",
        ["mini-chemplant-2"] = "angels-chemical-plant-2",
        ["mini-chemplant-3"] = "angels-chemical-plant-3",
        ["mini-chemplant-4"] = "angels-chemical-plant-4",
    }

    reskins.lib.rescale_minimachine(chemplants, "assembling-machine", 2 / 3, "chemical%-plant", "chemical-plant")

    -- Technologies
    -- originated_technologies["mini-chemplant-1"] = {mod = "bobs", group = "assembly", tier = 1, prog_tier = 2, icon_name = "chemical-plant"}
    -- linked_technologies["mini-chemplant-2"] = "chemical-plant-2"
    -- linked_technologies["mini-chemplant-3"] = "chemical-plant-3"
    -- linked_technologies["mini-chemplant-4"] = "chemical-plant-4"
elseif reskins.compatibility.triggers.minimachines.chemplants.bobs then
    local chemplants = {
        ["mini-chemplant-1"] = "chemical-plant",
        ["mini-chemplant-2"] = "chemical-plant-2",
        ["mini-chemplant-3"] = "chemical-plant-3",
        ["mini-chemplant-4"] = "chemical-plant-4",
    }

    reskins.lib.rescale_minimachine(chemplants, "assembling-machine", 2 / 3, "chemical%-plant", "chemical-plant")

    -- Technologies
    originated_technologies["mini-chemplant-1"] = { mod = "bobs", group = "assembly", tier = 1, prog_tier = 2, icon_name = "chemical-plant" }
    linked_technologies["mini-chemplant-2"] = "chemical-plant-2"
    linked_technologies["mini-chemplant-3"] = "chemical-plant-3"
    linked_technologies["mini-chemplant-4"] = "chemical-plant-4"
end

-- Electrolysers
if reskins.compatibility.triggers.minimachines.electrolysers then
    local electrolysers = {
        ["mini-electro-1"] = "electrolyser",
        ["mini-electro-2"] = "electrolyser-2",
        ["mini-electro-3"] = "electrolyser-3",
        ["mini-electro-4"] = "electrolyser-4",
        ["mini-electro-5"] = "electrolyser-5",
    }

    reskins.lib.rescale_minimachine(electrolysers, "assembling-machine", 2 / 3, "electrolyser", "electrolyser")

    -- Technologies
    originated_technologies["mini-electro-1"] = { mod = "bobs", group = "assembly", tier = 1, technology_icon_size = 256, technology_icon_mipmaps = 4, icon_name = "electrolyser", icon_base = "electrolyser-1", icon_mask = "electrolyser-1", icon_highlights = "electrolyser-1" }
    linked_technologies["mini-electro-2"] = "electrolyser-2"
    linked_technologies["mini-electro-3"] = "electrolyser-3"
    linked_technologies["mini-electro-4"] = "electrolyser-4"
    linked_technologies["mini-electro-5"] = "electrolyser-5"
end

-- Assembling machines
if reskins.compatibility.triggers.minimachines.assemblers then
    local assemblers = {
        ["mini-assembler-1"] = "assembling-machine-1",
        ["mini-assembler-2"] = "assembling-machine-2",
        ["mini-assembler-3"] = "assembling-machine-3",
        ["mini-assembler-4"] = "assembling-machine-4",
        ["mini-assembler-5"] = "assembling-machine-5",
        ["mini-assembler-6"] = "assembling-machine-6",
    }

    reskins.lib.rescale_minimachine(assemblers, "assembling-machine", 2 / 3, "assembling%-machine", "assembling-machine")

    -- Technologies
    linked_technologies["mini-assembler-1"] = "automation"
    linked_technologies["mini-assembler-2"] = "automation-2"
    linked_technologies["mini-assembler-3"] = "automation-3"
    linked_technologies["mini-assembler-4"] = "automation-4"
    linked_technologies["mini-assembler-5"] = "automation-5"
    linked_technologies["mini-assembler-6"] = "automation-6"
end

-- Mining drills
if reskins.compatibility.triggers.minimachines.miners then
    local miners = {
        ["mini-miner-1"] = "electric-mining-drill",
        ["mini-miner-2"] = "bob-mining-drill-1",
        ["mini-miner-3"] = "bob-mining-drill-2",
        ["mini-miner-4"] = "bob-mining-drill-3",
        ["mini-miner-5"] = "bob-mining-drill-4",
    }

    reskins.lib.rescale_minimachine(miners, "mining-drill", 2 / 3, "electric%-mining%-drill", "electric-mining-drill")

    -- Technologies
    originated_technologies["mini-miner-1"] = { mod = "bobs", group = "mining", tier = 1, icon_name = "mining-drill" }
    linked_technologies["mini-miner-2"] = "bob-drills-1"
    linked_technologies["mini-miner-3"] = "bob-drills-2"
    linked_technologies["mini-miner-4"] = "bob-drills-3"
    linked_technologies["mini-miner-5"] = "bob-drills-4"
end

-- Radars
if reskins.compatibility.triggers.minimachines.radar then
    local radars = {
        ["mini-radar-1"] = "radar",
        ["mini-radar-2"] = "radar-2",
        ["mini-radar-3"] = "radar-3",
        ["mini-radar-4"] = "radar-4",
        ["mini-radar-5"] = "radar-5",
    }

    reskins.lib.rescale_minimachine(radars, "radar", 2 / 3, "radar", "radar")

    -- Technologies
    if reskins.lib.migration.is_version_or_newer(mods["bobpower"], "1.1.6") then
        originated_technologies["mini-radar-1"] = { mod = "bobs", group = "warfare", tier = 1, icon_name = "radar" }
        linked_technologies["mini-radar-2"] = "radars-2"
        linked_technologies["mini-radar-3"] = "radars-3"
        linked_technologies["mini-radar-4"] = "radars-4"
        linked_technologies["mini-radar-5"] = "radars-5"
    else
        originated_technologies["mini-radar-1"] = { mod = "bobs", group = "warfare", tier = 1, icon_name = "radar" }
        linked_technologies["mini-radar-2"] = "radars"
        linked_technologies["mini-radar-3"] = "radars-2"
        linked_technologies["mini-radar-4"] = "radars-3"
        linked_technologies["mini-radar-5"] = "radars-4"
    end
end

-- Oil refineries
if reskins.compatibility.triggers.minimachines.refineries then
    local refineries = {
        ["mini-refinery-1"] = "oil-refinery",
        ["mini-refinery-2"] = "oil-refinery-2",
        ["mini-refinery-3"] = "oil-refinery-3",
        ["mini-refinery-4"] = "oil-refinery-4",
    }

    reskins.lib.rescale_minimachine(refineries, "assembling-machine", 3 / 5, "oil%-refinery", "oil-refinery")

    -- Technologies
    originated_technologies["mini-refinery-1"] = { mod = "bobs", group = "assembly", tier = 1, prog_tier = 2, icon_name = "oil-refinery" }
    linked_technologies["mini-refinery-2"] = "oil-processing-2"
    linked_technologies["mini-refinery-3"] = "oil-processing-3"
    linked_technologies["mini-refinery-4"] = "oil-processing-4"
end

-- Storage tanks
if reskins.compatibility.triggers.minimachines.storagetanks then
    local storagetanks = {
        ["mini-tank-1"] = "storage-tank",
        ["mini-tank-2"] = "storage-tank-2",
        ["mini-tank-3"] = "storage-tank-3",
        ["mini-tank-4"] = "storage-tank-4",
    }

    reskins.lib.rescale_minimachine(storagetanks, "storage-tank", 2 / 3, "storage%-tank", "storage-tank")

    -- Technologies
    originated_technologies["mini-tank-1"] = { group = "mini-machine", tier = 1, prog_tier = 2, icon_name = "storage-tank" }
    originated_technologies["mini-tank-2"] = { group = "mini-machine", tier = 2, prog_tier = 3, icon_name = "storage-tank" }
    originated_technologies["mini-tank-3"] = { group = "mini-machine", tier = 3, prog_tier = 4, icon_name = "storage-tank" }
    originated_technologies["mini-tank-4"] = { group = "mini-machine", tier = 4, prog_tier = 5, icon_name = "storage-tank" }
end

-- Beacons
if reskins.compatibility.triggers.minimachines.beacons then
    local beacons = {
        ["mini-beacon-1"] = "beacon",
        ["mini-beacon-2"] = "beacon-2",
        ["mini-beacon-3"] = "beacon-3",
    }

    reskins.lib.rescale_minimachine(beacons, "beacon", 2 / 3, "beacon", "beacon")
end

-- Furnaces
if reskins.compatibility.triggers.minimachines.furnaces then
    local furnaces = {
        ["mini-furnace-1"] = { source = "electric-furnace", pattern = "electric%-furnace", replacement = "electric-furnace" },
        ["mini-furnace-2"] = { source = "electric-furnace-2", pattern = "electric%-furnace", replacement = "electric-furnace" },
        ["mini-furnace-3"] = { source = "electric-furnace-3", pattern = "electric%-furnace", replacement = "electric-furnace" },
    }

    local assembly_furnaces = {
        ["mini-bobchem-1"]  = { source = "electric-chemical-furnace", pattern = "electric%-chemical%-furnace", replacement = "electric-chemical-furnace" },
        ["mini-bobmetal-1"] = { source = "electric-mixing-furnace", pattern = "electric%-mixing%-furnace", replacement = "electric-mixing-furnace" },
        ["mini-bobmulti-1"] = { source = "electric-chemical-mixing-furnace", pattern = "electric%-chemical%-mixing%-furnace", replacement = "electric-chemical-mixing-furnace" },
        ["mini-bobmulti-2"] = { source = "electric-chemical-mixing-furnace-2", pattern = "electric%-chemical%-mixing%-furnace", replacement = "electric-chemical-mixing-furnace" },
    }

    reskins.lib.rescale_minimachine(furnaces, "furnace", 2 / 3)
    reskins.lib.rescale_minimachine(assembly_furnaces, "assembling-machine", 2 / 3)

    -- Handle fluid boxes for the assembly furnaces
    for name, _ in pairs(assembly_furnaces) do
        local entity = data.raw["assembling-machine"][name]
        if not entity then return end

        if entity.fluid_boxes then
            -- Fetch tint
            local tint = entity.fluid_boxes[1].pipe_picture.east.layers[2].tint

            -- Set to standard pipe pictures for now; TODO: Custom pipe pictures
            entity.fluid_boxes[1].pipe_picture = reskins.bobs.assembly_pipe_pictures(tint)
        end
    end

    -- Technologies
    linked_technologies["mini-furnace-1"] = "advanced-material-processing-2"
    linked_technologies["mini-furnace-2"] = "advanced-material-processing-3"
    linked_technologies["mini-furnace-3"] = "advanced-material-processing-4"
    linked_technologies["mini-bobmetal-1"] = "electric-mixing-furnace"
    linked_technologies["mini-bobchem-1"] = "electric-chemical-furnace"
    linked_technologies["mini-bobmulti-1"] = "multi-purpose-furnace-1"
    linked_technologies["mini-bobmulti-2"] = "multi-purpose-furnace-2"
end

-- Miniaturize the linked techs
for name, source in pairs(linked_technologies) do
    reskins.lib.rescale_minimachine_technology(name, source)
end

-- Generate tech icons from files
local inputs = {
    mod = "compatibility",
    type = "technology"
}

-- Miniaturize the originated techs
reskins.lib.create_icons_from_list(originated_technologies, inputs)
for name, _ in pairs(originated_technologies) do
    reskins.lib.rescale_minimachine_technology(name, name)
end
