-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["aai-loaders"] then return end

local loaders = {
    ["aai-basic-loader"] = { tier = 0 },
    ["aai-loader"] = { tier = 1 },
    ["aai-fast-loader"] = { tier = 2 },
    ["aai-express-loader"] = { tier = 3 },
    ["aai-turbo-loader"] = { tier = 4 },
    ["aai-ultimate-loader"] = { tier = 5 },
}

for name, map in pairs(loaders) do
    -- AAI Loaders sets the icon only on the entity.
    local loader = data.raw["loader-1x1"][name]

    if reskins.bobs and (reskins.bobs.triggers.logistics.entities == true) then
        if loader and loader.icons and loader.icons[2] then
            loader.icons[2].tint = reskins.lib.tiers.get_belt_tint(map.tier)

            reskins.lib.tiers.add_tier_labels_to_prototype_by_reference(map.tier, loader)
        end
    end

    local technology = data.raw["technology"][name]
    if reskins.bobs and (reskins.bobs.triggers.logistics.technology == true) then
        if technology and technology.icons and technology.icons[2] then
            technology.icons[2].tint = reskins.lib.tiers.get_belt_tint(map.tier)
        end
    end
end
