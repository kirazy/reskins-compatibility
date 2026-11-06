-- cspell: words woodpulp

-- Copyright (c) 2024 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

---@using data
---@using Reskins.Framework

if not mods["Bio_Industries_2"] then
	return
end

-- FIXME: Handle the graphics overhaul when it lands
if helpers.compare_versions(mods["Bio_Industries_2"], "1.2.0") >= 0 then
	return
end

local _framework = {
	settings = require("__reskins-framework__.api.settings"),
	tiers = require("__reskins-framework__.api.tiers"),
}
local _sprite_utils = {
	defines = require("__reskins-sprite-utils__.defines"),
	icons = require("__reskins-sprite-utils__.icons"),
}
local _defines = require("__reskins-assets-api__.api.defines")
local _pipe_pictures = require("__reskins-assets-api__.assets.base.entities.pipe-pictures")

local Applicators = require("__reskins-assets-api__.api.applicators")
local Boiler = require("__reskins-assets-api__.assets.base.entities.boiler")

local upper_left = _sprite_utils.defines.icon_transforms.corners.northwest
local upper_right = _sprite_utils.defines.icon_transforms.corners.northeast

-- Bio Industries makes its own pellet coke when Angel's Petrochemical Processing does not provide it.
local pellet_coke = data.raw.item["angels-pellet-coke"] and "angels-pellet-coke" or "pellet-coke"

-- Bio Industries makes advanced fertilizer from alien artifacts when they exist, and from biomass otherwise.
local is_using_alien_artifacts = data.raw.item["alien-artifact"] ~= nil

---The composite icons of the recipes, under the name of each recipe. The first source of each icon is the product, and
---the other sources are drawn in the upper corners.
---@type table<string, TieredIconDefinition>
local recipes = {
	-- Seeds
	["bi-seed-1"] = {
		sources = {
			{ name = "bi-seed", type_name = "item" },
			{ name = "water", type_name = "fluid", transform = upper_left },
		},
	},
	["bi-seed-2"] = {
		sources = {
			{ name = "bi-seed", type_name = "item" },
			{ name = "bi-ash", type_name = "item", transform = upper_left },
		},
	},
	["bi-seed-3"] = {
		sources = {
			{ name = "bi-seed", type_name = "item" },
			{ name = "fertilizer", type_name = "item", transform = upper_left },
		},
	},
	["bi-seed-4"] = {
		sources = {
			{ name = "bi-seed", type_name = "item" },
			{ name = "bi-adv-fertilizer", type_name = "item", transform = upper_left },
		},
	},

	-- Seedlings
	["bi-seedling-1"] = {
		sources = {
			{ name = "seedling", type_name = "item" },
			{ name = "water", type_name = "fluid", transform = upper_left },
		},
	},
	["bi-seedling-2"] = {
		sources = {
			{ name = "seedling", type_name = "item" },
			{ name = "bi-ash", type_name = "item", transform = upper_left },
		},
	},
	["bi-seedling-3"] = {
		sources = {
			{ name = "seedling", type_name = "item" },
			{ name = "fertilizer", type_name = "item", transform = upper_left },
		},
	},
	["bi-seedling-4"] = {
		sources = {
			{ name = "seedling", type_name = "item" },
			{ name = "bi-adv-fertilizer", type_name = "item", transform = upper_left },
		},
	},

	-- Wood
	["bi-logs-1"] = {
		sources = {
			{ name = "wood", type_name = "item" },
			{ name = "water", type_name = "fluid", transform = upper_left },
		},
	},
	["bi-logs-2"] = {
		sources = {
			{ name = "wood", type_name = "item" },
			{ name = "bi-ash", type_name = "item", transform = upper_left },
		},
	},
	["bi-logs-3"] = {
		sources = {
			{ name = "wood", type_name = "item" },
			{ name = "fertilizer", type_name = "item", transform = upper_left },
		},
	},
	["bi-logs-4"] = {
		sources = {
			{ name = "wood", type_name = "item" },
			{ name = "bi-adv-fertilizer", type_name = "item", transform = upper_left },
		},
	},

	-- Miscellaneous
	["bi-battery"] = {
		sources = {
			{ name = "battery", type_name = "item" },
			{ name = "bi-biomass", type_name = "fluid", transform = upper_left },
		},
	},
	["bi-sulfur"] = {
		sources = {
			{ name = "sulfur", type_name = "item" },
			{ name = "bi-ash", type_name = "item", transform = upper_left },
		},
	},
	["bi-acid"] = {
		sources = {
			{ name = "sulfuric-acid", type_name = "fluid" },
			{ name = "bi-biomass", type_name = "fluid", transform = upper_left },
		},
	},
	["bi-basic-gas-processing"] = {
		sources = {
			{ name = "petroleum-gas", type_name = "fluid" },
			{ name = "coal", type_name = "item", transform = upper_left },
			{ name = "resin", type_name = "item", transform = upper_right },
		},
	},
	["bi-solid-fuel"] = {
		sources = {
			{ name = "solid-fuel", type_name = "item" },
			{ name = "wood-bricks", type_name = "item", transform = upper_left },
		},
	},

	-- Wood and Pulp related recipes
	["bi-woodpulp"] = {
		sources = {
			{ name = "bi-woodpulp", type_name = "item" },
			{ name = "wood", type_name = "item", transform = upper_left },
		},
	},
	["bi-resin-pulp"] = {
		sources = {
			{ name = "resin", type_name = "item" },
			{ name = "bi-woodpulp", type_name = "item", transform = upper_left },
		},
	},
	["bi-wood-from-pulp"] = {
		sources = {
			{ name = "wood", type_name = "item" },
			{ name = "bi-woodpulp", type_name = "item", transform = upper_left },
			{ name = "resin", type_name = "item", transform = upper_right },
		},
	},

	-- Ash
	["bi-ash-1"] = {
		sources = {
			{ name = "bi-ash", type_name = "item" },
			{ name = "wood", type_name = "item", transform = upper_left },
		},
	},
	["bi-ash-2"] = {
		sources = {
			{ name = "bi-ash", type_name = "item" },
			{ name = "bi-woodpulp", type_name = "item", transform = upper_left },
		},
	},

	-- Charcoal
	["bi-charcoal-1"] = {
		sources = {
			{ name = "wood-charcoal", type_name = "item" },
			{ name = "bi-woodpulp", type_name = "item", transform = upper_left },
		},
	},
	["bi-charcoal-2"] = {
		sources = {
			{ name = "wood-charcoal", type_name = "item" },
			{ name = "wood", type_name = "item", transform = upper_left },
		},
	},

	-- Pellets
	["bi-coke-coal"] = {
		sources = {
			{ name = pellet_coke, type_name = "item" },
			{ name = "coal", type_name = "item", transform = upper_left },
		},
	},
	["bi-pellet-coke"] = {
		sources = {
			{ name = pellet_coke, type_name = "item" },
			{ name = "solid-fuel", type_name = "item", transform = upper_left },
		},
	},

	-- Stone and Crushed Stone
	["bi-stone-brick"] = {
		sources = {
			{ name = "stone-brick", type_name = "item" },
			{ name = "bi-ash", type_name = "item", transform = upper_left },
			{ name = "stone-crushed", type_name = "item", transform = upper_right },
		},
	},
	["bi-crushed-stone-1"] = {
		sources = {
			{ name = "stone-crushed", type_name = "item" },
			{ name = "stone", type_name = "item", transform = upper_left },
		},
	},
	["bi-crushed-stone-2"] = {
		sources = {
			{ name = "stone-crushed", type_name = "item" },
			{ name = "concrete", type_name = "item", transform = upper_left },
		},
	},
	["bi-crushed-stone-3"] = {
		sources = {
			{ name = "stone-crushed", type_name = "item" },
			{ name = "hazard-concrete", type_name = "item", transform = upper_left },
		},
	},
	["bi-crushed-stone-4"] = {
		sources = {
			{ name = "stone-crushed", type_name = "item" },
			{ name = "refined-concrete", type_name = "item", transform = upper_left },
		},
	},
	["bi-crushed-stone-5"] = {
		sources = {
			{ name = "stone-crushed", type_name = "item" },
			{ name = "refined-hazard-concrete", type_name = "item", transform = upper_left },
		},
	},

	-- Fertilizer
	["bi-fertilizer-1"] = {
		sources = {
			{ name = "fertilizer", type_name = "item" },
			{ name = "sulfur", type_name = "item", transform = upper_left },
		},
	},
	["bi-adv-fertilizer-1"] = {
		sources = {
			{ name = "bi-adv-fertilizer", type_name = "item" },
			{
				name = is_using_alien_artifacts and "alien-artifact" or "bi-biomass",
				type_name = is_using_alien_artifacts and "item" or "fluid",
				transform = upper_left,
			},
		},
	},
	["bi-adv-fertilizer-2"] = {
		sources = {
			{ name = "bi-adv-fertilizer", type_name = "item" },
			{ name = "bi-biomass", type_name = "fluid", transform = upper_left },
		},
	},

	-- Plastic
	["bi-plastic-1"] = {
		sources = {
			{ name = "plastic-bar", type_name = "item" },
			{ name = "wood", type_name = "item", transform = upper_left },
		},
	},
	["bi-plastic-2"] = {
		sources = {
			{ name = "plastic-bar", type_name = "item" },
			{ name = "bi-cellulose", type_name = "item", transform = upper_left },
		},
	},

	-- Cellulose
	["bi-cellulose-2"] = {
		sources = {
			{ name = "bi-cellulose", type_name = "item" },
			{ name = "steam", type_name = "fluid", transform = upper_left },
		},
	},
}

-- Sodium hydroxide and carbon exist only when another mod provides them.
if data.raw.item["bob-sodium-hydroxide"] then
	recipes["bi-fertilizer-2"] = {
		sources = {
			{ name = "fertilizer", type_name = "item" },
			{ name = "bob-sodium-hydroxide", type_name = "item", transform = upper_left },
		},
	}
end

if data.raw.item["carbon"] then
	recipes["bi-pellet-coke-2"] = {
		sources = {
			{ name = pellet_coke, type_name = "item" },
			{ name = "carbon", type_name = "item", transform = upper_left },
		},
	}
end

-- FIXME: This will need follow-up if and/or when Bio Industries is ported to 2.0
if
	mods["bobelectronics"] and _framework.settings.get_value("reskins-bobs-do-bobelectronics-colored-circuits") == true
then
	recipes["bob-wooden-board"] = {
		sources = {
			{ name = "bob-wooden-board", type_name = "item" },
			{ name = "wood", type_name = "item", transform = upper_left },
		},
	}

	recipes["bi-press-wood"] = {
		sources = {
			{ name = "bob-wooden-board", type_name = "item" },
			{ name = "bi-woodpulp", type_name = "item", transform = upper_left },
			{ name = "resin", type_name = "item", transform = upper_right },
		},
	}
end

_framework.tiers.assign_icons_with_tier_labels("recipe", recipes)

-- BOILER
if mods["bobpower"] then
	local entity = data.raw["boiler"]["bi-bio-boiler"]

	if entity then
		local tint = util.color("#80801a")

		Applicators.apply_sprite_set(entity, Boiler.get_sprite_set({ tint = tint }))

		entity.fluid_box.pipe_covers = _pipe_pictures.pipe_covers(_defines.pipe_material.iron)
		entity.output_fluid_box.pipe_covers = _pipe_pictures.pipe_covers(_defines.pipe_material.iron)

		local icon_assignment = _framework.tiers.icon_assignment_with_tier_labels({
			name = entity.name,
			type_name = entity.type,
			icon_data = Boiler.get_icon({ tint = tint }),
		})
		_sprite_utils.icons.apply_icon_assignment(icon_assignment)
	end
end
