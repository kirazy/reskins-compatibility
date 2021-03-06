-- Copyright (c) 2021 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["miniloader"] then return end
if reskins.bobs and (reskins.bobs.triggers.logistics.entities == false) then return end

-- Set input parameters
local inputs = {
    icon_name = "miniloader",
    base_entity = "splitter",
    mod = "compatibility",
    group = "miniloader",
    particles = {["medium"] = 1, ["big"] = 4},
    icon_layers = 2,
    technology_icon_layers = 2,
    make_remnants = false,
}

-- Handle belt tier labels
inputs.tier_labels = reskins.lib.setting("reskins-bobs-do-belt-entity-tier-labeling") and true or false

local tier_map = {
    -- 1x1 Loader Entities
    ["basic-miniloader-loader"] = {tier = 0, sprite_variant = 1},
    ["chute-miniloader-loader"] = {tier = 0, sprite_variant = 1},
    ["miniloader-loader"] = {tier = 1, sprite_variant = 1},
    ["fast-miniloader-loader"] = {tier = 2, sprite_variant = 2},
    ["express-miniloader-loader"] = {tier = 3, sprite_variant = 2},
    ["turbo-miniloader-loader"] = {tier = 4, sprite_variant = 2},
    ["ultimate-miniloader-loader"] = {tier = 5, sprite_variant = 2},
    ["filter-miniloader-loader"] = {tier = 1, sprite_variant = 1},
    ["fast-filter-miniloader-loader"] = {tier = 2, sprite_variant = 2},
    ["express-filter-miniloader-loader"] = {tier = 3, sprite_variant = 2},
    ["turbo-filter-miniloader-loader"] = {tier = 4, sprite_variant = 2},
    ["ultimate-filter-miniloader-loader"] = {tier = 5, sprite_variant = 2},

    -- Inserter Entities
    ["basic-miniloader-inserter"] = {tier = 0, is_inserter = true},
    ["chute-miniloader-inserter"] = {tier = 0, is_inserter = true},
    ["miniloader-inserter"] = {tier = 1, is_inserter = true},
    ["fast-miniloader-inserter"] = {tier = 2, is_inserter = true},
    ["express-miniloader-inserter"] = {tier = 3, is_inserter = true},
    ["turbo-miniloader-inserter"] = {tier = 4, is_inserter = true},
    ["ultimate-miniloader-inserter"] = {tier = 5, is_inserter = true},
    ["filter-miniloader-inserter"] = {tier = 1, is_inserter = true},
    ["fast-filter-miniloader-inserter"] = {tier = 2, is_inserter = true},
    ["express-filter-miniloader-inserter"] = {tier = 3, is_inserter = true},
    ["turbo-filter-miniloader-inserter"] = {tier = 4, is_inserter = true},
    ["ultimate-filter-miniloader-inserter"] = {tier = 5, is_inserter = true},
}

local item_map = {
    ["basic-miniloader"] = {tier = 0},
    ["chute-miniloader"] = {tier = 0},
    ["miniloader"] = {tier = 1},
    ["fast-miniloader"] = {tier = 2},
    ["express-miniloader"] = {tier = 3},
    ["turbo-miniloader"] = {tier = 4},
    ["ultimate-miniloader"] = {tier = 5},
    ["filter-miniloader"] = {tier = 1, icon_base = "filter-miniloader"},
    ["fast-filter-miniloader"] = {tier = 2, icon_base = "filter-miniloader"},
    ["express-filter-miniloader"] = {tier = 3, icon_base = "filter-miniloader"},
    ["turbo-filter-miniloader"] = {tier = 4, icon_base = "filter-miniloader"},
    ["ultimate-filter-miniloader"] = {tier = 5, icon_base = "filter-miniloader"},
}

-- Reskin entities
for name, map in pairs(tier_map) do
    if map.is_inserter then
        inputs.type = "inserter"
        inputs.make_explosions = true
    else
        inputs.type = "loader-1x1"
        inputs.make_explosions = false
    end

    -- Fetch entity
    local entity = data.raw[inputs.type][name]

    -- Check if entity exists, if not, skip this iteration
    if not entity then goto continue end

    -- Determine what tint we're using
    inputs.tint = reskins.lib.belt_tint_index[map.tier]

    reskins.lib.setup_standard_entity(name, map.tier, inputs)

    -- Retint the mask
    if map.is_inserter then
        entity.corpse = "small-remnants"
        entity.platform_picture.sheets[2].tint = inputs.tint
        entity.platform_picture.sheets[2].hr_version.tint = inputs.tint
    else
        entity.structure.direction_in.sheets[2].tint = inputs.tint
        entity.structure.direction_in.sheets[2].hr_version.tint = inputs.tint
        entity.structure.direction_out.sheets[2].tint = inputs.tint
        entity.structure.direction_out.sheets[2].hr_version.tint = inputs.tint

        -- Apply belt set
        entity.belt_animation_set = reskins.lib.transport_belt_animation_set(inputs.tint, map.sprite_variant)
    end

    -- Label to skip to next iteration
    ::continue::
end

-- Reskin icons
for name, map in pairs(item_map) do
    -- Fetch item
    local item = data.raw["item"][name]

    -- Check if item exists, if not, skip this iteration
    if not item then goto continue end

    -- Setup icon details
    inputs.icon_base = map.icon_base or "miniloader"

    -- Determine what tint we're using
    inputs.tint = reskins.lib.belt_tint_index[map.tier]

    reskins.lib.construct_icon(name, map.tier, inputs)

    -- Handle grouping and ordering in the UI
    local base_item
    if name ~= "chute-miniloader" then
        base_item = data.raw["item"][string.gsub(string.gsub(name, "filter%-", ""), "miniloader", "transport-belt")]
    elseif data.raw["item"]["basic-transport-belt"] then
        base_item = data.raw["item"]["basic-transport-belt"]
    end

    if base_item then
        inputs.sort_order = string.gsub(string.gsub(item.order,"^[a-z]","d"),"transport%-belt","miniloader")
        inputs.sort_group = base_item.group
        inputs.sort_subgroup = base_item.subgroup

        if string.find(name, "filter") then
            inputs.sort_order = string.gsub(inputs.sort_order, "filter", "n-filter")
        elseif name == "chute-miniloader" then
            inputs.sort_order = string.gsub(inputs.sort_order, "miniloader", "z-miniloader")
        end

        reskins.lib.assign_order(name, inputs)
    end

    -- Label to skip to next iteration
    ::continue::
end

-- Technologies
local technology_map = {
    ["basic-miniloader"] = 0,
    ["miniloader"] = 1,
    ["fast-miniloader"] = 2,
    ["express-miniloader"] = 3,
    ["turbo-miniloader"] = 4,
    ["ultimate-miniloader"] = 5,
}

-- Reskin technologies
for name, tier in pairs(technology_map) do
    -- Fetch technology
    local technology = data.raw["technology"][name]

    -- Check if entity exists, if not, skip this iteration
    if not technology then goto continue end

    -- Fix inputs
    inputs.icon_base = nil

    -- Determine what tint we're using
    inputs.tint = reskins.lib.belt_tint_index[tier]

    reskins.lib.construct_technology_icon(name, inputs)

    -- Label to skip to next iteration
    ::continue::
end