-- -------------------------------------------------
-- Note: Actual amount of each drop is a randomly
-- selected number between 1 and the stated amount.
-- -------------------------------------------------
local _mobDropsTable = {
	
	-- ------------------------------
	-- Kingdom/Wilderness animals
	-- ------------------------------
	["rabbit"] = {
		loot = {
			items = {"rabbit_meat"},
			amounts = {1},
			rates = {67}
		}
	},
	["white_rabbit"] = {
		loot = {
			items = {"rabbit_meat"},
			amounts = {1},
			rates = {67}
		}
	},
	["squirrel"] = {
		loot = {
			items = {"acorn", "acorn", "acorn", "acorn", "gold_acorn"},
			amounts = {1, 2, 3, 50, 1},
			rates = {50, 33, 15, 1, 1}
		}
	},
	["green_squirrel"] = {
		loot = {
			items = {"acorn", "acorn", "acorn", "acorn", "gold_acorn", "green_squirrel_pelt"},
			amounts = {1, 2, 3, 50, 1, 1},
			rates = {50, 33, 15, 1, 3, 5}
		}
	},
	["deer"] = {
		loot = {
			items = {"antler"},
			amounts = {1},
			rates = {50}
		}
	},
	["black_buck"] = {
		loot = {
			items = {"antler"},
			amounts = {1},
			rates = {67}
		}
	},
	["snake"] = {
		loot = {
			items = {"snake_meat"},
			amounts = {2},
			rates = {100}
		}
	},
	["boa"] = {
		rareLoot = {
			items = {"fine_snake_meat", "snake_meat"},
			rates = {34, 85}
		}
	},
	["wolf"] = {
		loot = {
			items = {"wolf_meat"},
			amounts = {1},
			rates = {45}
		}
	},
	["blood_wolf"] = {
		loot = {
			items = {"wolf_meat"},
			amounts = {1},
			rates = {67}
		}
	},
	["bear"] = {
		loot = {
			items = {"bear_fur"},
			amounts = {1},
			rates = {40}
		}
	},
	["lobster"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {10}
		}
	},
	["island_lobster"] = {
		loot = {
			items = {"seaweed", "amber"},
			amounts = {1, 1},
			rates = {34, 10}
		}
	},
	["blue_rooster"] = {
		loot = {
			items = {"amber"},
			amounts = {3},
			rates = {100}
		}
	},
	["sheep"] = {
		loot = {
			items = {"wool"},
			amounts = {1},
			rates = {80}
		}
	},
	["golden_hare_wild"] = {
		loot = {
			items = {"amber", "rabbit_meat"},
			amounts = {1, 1},
			rates = {34, 34}
		}
	},
	["strange_thing"] = {
		rareLoot = {
			items = {"big_axe", "crystal"},
			rates = {1, 75}
		}
	},

	-- ------------------------------
	-- Kingdom/Wilderness rat caves
	-- ------------------------------
	["mouse"] = {
		loot = {
			items = {"rat_meat"},
			amounts = {1},
			rates = {34}
		}
	},
	["rat"] = {
		loot = {
			items = {"rat_meat", "ginseng_piece"},
			amounts = {1, 1},
			rates = {34, 17}
		}
	},
	["white_rat"] = {
		loot = {
			items = {"rat_meat"},
			amounts = {1},
			rates = {34}
		},
		rareLoot = {
			items = {"topaz", "mica"},
			rates = {8, 17}
		}
	},
	["fierce_mouse"] = {
		loot = {
			items = {"rat_meat", "ginseng_piece"},
			amounts = {1, 1},
			rates = {34, 17}
		}
	},
	["big_rat"] = {
		loot = {
			items = {"rat_meat"},
			amounts = {1},
			rates = {34}
		},
		rareLoot = {
			items = {"ginseng", "ginseng_piece"},
			rates = {10, 17}
		}
	},
	["bat"] = {
		loot = {
			items = {"ginseng_piece"},
			amounts = {1},
			rates = {10}
		}
	},
	["big_bat"] = {
		rareLoot = {
			items = {"ginseng", "ginseng_piece"},
			rates = {10, 34}
		}
	},
	["giant_centipede"] = {
		loot = {
			items = {"topaz"},
			amounts = {1},
			rates = {25}
		}
	},
	["large_centipede"] = {
		loot = {
			items = {"topaz"},
			amounts = {1},
			rates = {20}
		}
	},

	-- ------------------------------
	-- Kingdom rabbit caves
	-- ------------------------------
	["hare"] = {
		loot = {
			items = {"rabbit_meat"},
			amounts = {1},
			rates = {67}
		}
	},
	["large_hare"] = {
		loot = {
			items = {"rabbit_meat"},
			amounts = {1},
			rates = {67}
		}
	},
	["red_hare"] = {
		loot = {
			items = {"rabbit_meat"},
			amounts = {1},
			rates = {67}
		}
	},
	["dark_buck"] = {
		loot = {
			items = {"antler"},
			amounts = {1},
			rates = {34}
		}
	},
	["albino_buck"] = {
		loot = {
			items = {"antler", "ginseng"},
			amounts = {1, 1},
			rates = {34, 10}
		}
	},
	["dark_wolf"] = {
		loot = {
			items = {"wolf_pelt"},
			amounts = {1},
			rates = {15}
		}
	},
	["blood_tick"] = {
		rareLoot = {
			items = {"mountain_ginseng", "ginseng"},
			rates = {34, 67}
		}
	},
	["giant_mantis"] = {
		rareLoot = {
			items = {"mountain_ginseng", "ginseng"},
			rates = {34, 67}
		}
	},
	["blood_mantis"] = {
		rareLoot = {
			items = {"mountain_ginseng", "ginseng"},
			rates = {34, 67}
		}
	},

	-- ------------------------------
	-- Kugnae snake caves
	-- ------------------------------
	["wild_piglet"] = {
		loot = {
			items = {"rare_pork"},
			amounts = {1},
			rates = {67}
		}
	},
	["wild_pig"] = {
		loot = {
			items = {"rare_pork"},
			amounts = {1},
			rates = {67}
		}
	},
	["mud_snake"] = {
		loot = {
			items = {"snake_meat"},
			amounts = {2},
			rates = {85}
		}
	},
	["mud_bull"] = {
		loot = {
			items = {"beef"},
			amounts = {1},
			rates = {67}
		}
	},
	["earth_snake"] = {
		loot = {
			items = {"viper_stick"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"fine_snake_meat", "snake_meat"},
			rates = {34, 85}
		}
	},
	["warthog"] = {
		loot = {
			items = {"rare_pork"},
			amounts = {1},
			rates = {67}
		}
	},

	-- ------------------------------
	-- Kingdom fox caves
	-- ------------------------------
	["raven"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {15}
		}
	},
	["terrified_chicken"] = {
		loot = {
			items = {"chicken_meat"},
			amounts = {1},
			rates = {67}
		}
	},
	["dark_fox"] = {
		loot = {
			items = {"fox_fur"},
			amounts = {1},
			rates = {34}
		}
	},
	["blood_fox"] = {
		loot = {
			items = {"red_fox_fur"},
			amounts = {1},
			rates = {34}
		}
	},
	["lava_fox"] = {
		loot = {
			items = {"fox_fur"},
			amounts = {1},
			rates = {34}
		}
	},
	["sun_fox"] = {
		loot = {
			items = {"light_fox_fur"},
			amounts = {1},
			rates = {34}
		}
	},
	["nine_tailed_fox"] = {
		rareLoot = {
			items = {"fox_tail", "fox_blade"},
			rates = {25, 75}
		}
	},
	["white_wolf"] = {
		loot = {
			items = {"amethyst"},
			amounts = {1},
			rates = {20}
		}
	},
	["lightning_wolf"] = {
		loot = {
			items = {"amethyst"},
			amounts = {1},
			rates = {25}
		}
	},

	-- ------------------------------
	-- Forever tree
	-- ------------------------------
	["man_shik_raven"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {7.5}
		}
	},

	-- ------------------------------
	-- Wilderness Iron Labyrinth
	-- ------------------------------
	["iron_panda"] = {
		loot = {
			items = {"bears_liver", "iron_key"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["iron_tiger"] = {
		loot = {
			items = {"iron_key"},
			amounts = {1},
			rates = {2.5}
		},
		rareLoot = {
			items = {"tiger_meat", "tigers_heart"},
			rates = {10, 34}
		}
	},
	["giant_iron_tiger"] = {
		loot = {
			items = {"tigers_heart", "iron_key"},
			amounts = {1, 1},
			rates = {45, 5}
		}
	},
	["gimyi"] = {
		rareLoot = {
			items = {"iron_sword", "iron_statue"},
			rates = {75, 50}
		}
	},

	-- ------------------------------
	-- Sute's Cave
	-- ------------------------------
	["yachi"] = {
		loot = {
			items = {"amber", "muddy_potion"},
			amounts = {1, 1},
			rates = {7.5, 5}
		}
	},
	["seki"] = {
		loot = {
			items = {"tarnished_amber", "muddy_potion"},
			amounts = {1, 1},
			rates = {10, 5}
		}
	},
	["li"] = {
		loot = {
			items = {"dark_amber", "muddy_potion", "steel_dagger"},
			amounts = {1, 1, 1},
			rates = {5, 5, 1}
		}
	},
	["sute"] = {
		loot = {
			items = {"sutes_key"},
			amounts = {1},
			rates = {100}
		}
	},

	-- ------------------------------
	-- Haunted House
	-- ------------------------------
	["pale_zombie"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {2.5}
		},
		rareLoot = {
			items = {"aqua_potion", "muddy_potion"},
			rates = {2, 5}
		}
	},
	["lesser_ghost"] = {
		loot = {
			items = {"muddy_potion"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {2.5, 1.25}
		}
	},
	["wicked_ghost"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {67}
		},
		rareLoot = {
			items = {"moonblade"},
			rates = {34}
		}
	},
	["witch"] = {
		loot = {
			items = {"amber", "aqua_potion"},
			amounts = {1, 1},
			rates = {5, 5}
		}
	},
	["witch_shaman"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {67}
		},
		rareLoot = {
			items = {"deaths_head"},
			rates = {34}
		}
	},
	["lesser_skeleton"] = {
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {2.5, 4}
		}
	},
	["skeleton_ju"] = {
		rareLoot = {
			items = {"bone"},
			rates = {34}
		}
	},
	["skeleton_mage"] = {
		rareLoot = {
			items = {"wicked_staff"},
			rates = {75}
		}
	},
	["skeleton_warrior"] = {
		rareLoot = {
			items = {"maxcaliber"},
			rates = {75}
		}
	},

	-- ------------------------------
	-- Kugnae Spider
	-- ------------------------------
	["carrion_raven"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {10}
		}
	},
	["giant_spider"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["giant_scorpion"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["trapdoor_spider"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {7.5}
		},
		rareLoot = {
			items = {"hunangs_axe"},
			rates = {10}
		}
	},
	["radiant_spider"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["pale_scorpion"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {17}
		}
	},
	["massive_scorpion"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {67}
		},
		rareLoot = {
			items = {"bekyuns_spear"},
			rates = {34}
		}
	},

	-- ------------------------------
	-- Buya Scorpion
	-- ------------------------------
	["vile_scorpion"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {7.5}
		}
	},
	["radiant_scorpion"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {7.5}
		}
	},
	["crimson_scorpion"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {67}
		},
		rareLoot = {
			items = {"poet_whip"},
			rates = {75}
		}
	},

	-- ------------------------------
	-- Wilderness Lobsters
	-- ------------------------------
	["sand_lobster"] = {
		loot = {
			items = {"yellow_amber"},
			amounts = {1},
			rates = {1}
		}
	},
	["rock_lobster"] = {
		loot = {
			items = {"yellow_amber"},
			amounts = {1},
			rates = {2}
		}
	},
	["golden_lobster"] = {
		loot = {
			items = {"yellow_amber"},
			amounts = {1},
			rates = {100}
		},
		rareLoot = {
			items = {"jolt_trident"},
			rates = {34}
		}
	},

	-- ------------------------------
	-- Islets and Hamgyong Nam-Do
	-- ------------------------------
	["ogre_explorer"] = {
		rareLoot = {
			items = {"dark_amber", "tarnished_amber"},
			rates = {5, 17}
		}
	},
	["stone_ogre"] = {
		rareLoot = {
			items = {"dark_amber", "tarnished_amber"},
			rates = {5, 17}
		}
	},

	-- ------------------------------
	-- Mantis
	-- ------------------------------
	["forest_mantis"] = {
		rareLoot = {
			items = {"dark_amber", "tarnished_amber"},
			rates = {5, 17}
		}
	},
	["deep_woods_mantis"] = {
		loot = {
			items = {1, "amber"},
			amounts = {50, 1},
			rates = {100, 7.5}
		}
	},
	["shadow_mantis"] = {
		loot = {
			items = {"white_amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"star_staff", "titanium_glove"},
			rates = {8, 8}
		}
	},
	["dark_mantis"] = {
		rareLoot = {
			items = {"white_amber", "dark_amber"},
			rates = {1, 10}
		}
	},
	["ghost_mantis"] = {
		rareLoot = {
			items = {"dark_amber", "tarnished_amber"},
			rates = {5, 17}
		}
	},
	["dirt_mantis"] = {
		rareLoot = {
			items = {"steelthorn", "sen_glove"},
			rates = {8, 8}
		}
	},
	["chtan"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {67}
		},
		rareLoot = {
			items = {"jade_diamond"},
			rates = {8}
		}
	},
	["sintu"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {67}
		},
		rareLoot = {
			items = {"forest_diamond"},
			rates = {8}
		}
	},
	["sting"] = {
		rareLoot = {
			items = {"yellow_amber"},
			rates = {20}
		}
	},

	-- ------------------------------
	-- Hamgyong nam-do Ogres
	-- ------------------------------
	["grim_ogre"] = {
		loot = {
			items = {1, "amber"},
			amounts = {50, 1},
			rates = {100, 5}
		}
	},
	["southern_ogre"] = {
		rareLoot = {
			items = {"dark_amber", "tarnished_amber"},
			rates = {5, 17}
		}
	},
	["hill_ogre"] = {
		rareLoot = {
			items = {"dark_amber", "tarnished_amber"},
			rates = {5, 17}
		}
	},
	["marsh_ogre"] = {
		rareLoot = {
			items = {"dark_amber", "tarnished_amber"},
			rates = {5, 17}
		}
	},
	["muck_ogre"] = {
		rareLoot = {
			items = {"titanium_lance", "whisper_bracelet"},
			rates = {8, 8}
		}
	},
	["slime_ogre"] = {
		rareLoot = {
			items = {"electra", "holy_ring"},
			rates = {8, 8}}

	},
	["log_ogre"] = {
		loot = {
			items = {"hamgyong_gem_fragment"},
			amounts = {1},
			rates = {67}
		}
	},
	["zangze_ogre"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {67}
		},
		rareLoot = {
			items = {"lazuline_diamond"},
			rates = {8}
		}
	},
	["zinte_ogre"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {67}
		},
		rareLoot = {
			items = {"azure_diamond"},
			rates = {8}
		}
	},

	-- ------------------------------
	-- Arctic Land
	-- ------------------------------

	-- ------------------------------
	-- Northern Ogres
	-- ------------------------------
	["northern_ogre"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {17}
		}
	},
	["frost_ogre"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {17}
		}
	},
	["ice_ogre"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {17}
		}
	},
	["ogre_citelam"] = {
		loot = {
			items = {"white_amber"},
			amounts = {1},
			rates = {18}
		},
		rareLoot = {
			items = {"light_sword"},
			rates = {10}
		}
	},
	["ogre_maletic"] = {
		loot = {
			items = {"white_amber"},
			amounts = {1},
			rates = {18}
		},
		rareLoot = {
			items = {"dark_dagger"},
			rates = {10}
		}
	},
	["ice_panther"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {15}
		}
	},

	-- ------------------------------
	-- Arctic Ogres
	-- ------------------------------
	["snow_rabbit"] = {
		loot = {
			items = {"rabbit_meat"},
			amounts = {1},
			rates = {67}
		}
	},
	["arctic_deer"] = {
		loot = {
			items = {"antler"},
			amounts = {1},
			rates = {34}
		}
	},
	["slush_ogre"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"stardrop"},
			rates = {1}
		}
	},
	["snow_ogre"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"stardrop"},
			rates = {2.5}
		}
	},
	["sleet_ogre"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"stardrop"},
			rates = {5}
		}
	},
	["hail_ogre"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["flurry_ogre"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {10}
		}
	},
	["blizzard_ogre"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {10}
		}
	},
	["avalanche_ogre"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["tempest_ogre"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {12.5}
		}
	},
	["cyclone_ogre"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {12.5}
		}
	},
	["slush_king"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {67}
		},
		rareLoot = {
			items = {"stardrop"},
			rates = {100}
		}
	},
	["snow_king"] = {
		loot = {
			items = {"giasomo_stick"},
			amounts = {1},
			rates = {34}
		},
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {34, 67}
		}
	},
	["sleet_king"] = {
		loot = {
			items = {"angels_tear"},
			amounts = {1},
			rates = {100}
		},
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {34, 67}
		}
	},
	["hail_king"] = {
		loot = {
			items = {"flamefang"},
			amounts = {1},
			rates = {34}
		},
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {34, 67}
		}
	},
	["flurry_king"] = {
		-- @TODO: Add loot
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {34, 67}
		}
	},
	["blizzard_king"] = {
		loot = {
			items = {"frozen_spear"},
			amounts = {1},
			rates = {10}
		},
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {34, 67}
		}
	},
	["avalanche_king"] = {
		-- @TODO: Add loot
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {34, 67}
		}
	},
	["tempest_king"] = {
		-- @TODO: Add loot
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {34, 67}
		}
	},
	["cyclone_king"] = {
		-- @TODO: Add loot
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {34, 67}
		}
	},

	-- ------------------------------
	-- Tiger Palace
	-- ------------------------------
	["tiger_night"] = {
		loot = {
			items = {"dark_amber", "white_amber"},
			amounts = {1, 1},
			rates = {67, 34}
		},
		rareLoot = {
			items = {"dark_scimitar", "light_broadsword", "wand_of_fire", "winter_sceptre"},
			rates = {2, 2, 2, 2}
		}
	},
	["tiger_storm"] = {
		loot = {
			items = {"white_amber"},
			amounts = {1},
			rates = {45}
		},
		rareLoot = {
			items = {"light_broadsword", "wand_of_fire", "winter_sceptre", "dark_scimitar"},
			rates = {2, 2, 2, 2}
		}
	},
	["tiger_blizzard"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {67}
		},
		rareLoot = {
			items = {"wand_of_fire", "winter_sceptre", "dark_scimitar", "light_broadsword"},
			rates = {2, 2, 2, 2}
		}
	},
	["tiger_summit"] = {
		loot = {
			items = {"white_amber"},
			amounts = {1},
			rates = {45}
		},
		rareLoot = {
			items = {"winter_sceptre", "dark_scimitar", "light_broadsword", "wand_of_fire"},
			rates = {2, 2, 2, 2}
		}
	},
	["tiger_twostripes"] = {
		loot = {
			items = {3, "white_amber"},
			amounts = {10000, 5},
			rates = {100, 85}
		}
		-- @TODO: Add a rareLoot drop of some TBD entry-level Ee san weapon
	},

	-- ------------------------------
	-- Mythic Nexus
	-- ------------------------------

	-- ------------------------------
	-- Rabbit 1
	-- ------------------------------
	["golden_hare"] = {
		loot = {
			items = {"amber", "rabbit_meat"},
			amounts = {1, 1},
			rates = {7.5, 34}
		}
	},
	["mad_rabbit"] = {
		loot = {
			items = {"amber", "rabbit_meat"},
			amounts = {1, 1},
			rates = {7.5, 34}
		}
	},
	["giant_hare"] = {
		loot = {
			items = {"amber", "rabbit_meat"},
			amounts = {1, 1},
			rates = {7.5, 34}
		}
	},
	["rabbit_sentry"] = {
		loot = {
			items = {"amber", "fine_rabbit_meat"},
			amounts = {1, 1},
			rates = {35, 25}
		},
		rareLoot = {
			items = {"star_helm", "lucky_coin"},
			rates = {0.1, 1}
		}
	},
	["mythic_hare"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {500, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_earth"},
			rates = {100}
		}
	},
	["hare_witch"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {500, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"star_helm", "lucky_coin"},
			rates = {5, 50}
		}
	},

	-- ------------------------------
	-- Rabbit 2
	-- ------------------------------
	["golden_rabbit"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {8.75}
		}
	},
	["mad_hare"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {8.75}
		}
	},
	["giant_rabbit"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {8.75}
		}
	},
	["rabbit_guardian"] = {
		loot = {
			items = {"fine_rabbit_meat"},
			amounts = {1},
			rates = {35}
		},
		rareLoot = {
			items = {"moon_helm", "lucky_coin"},
			rates = {0.034, 1}
		}
	},
	["divine_rabbit"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1100, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_earth"},
			rates = {100}
		}
	},
	["rabbit_witch"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1100, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"moon_helm", "lucky_coin"},
			rates = {1.67, 50}
		}
	},

	-- ------------------------------
	-- Rabbit 3
	-- ------------------------------
	["hop"] = {
		loot = {
			items = {"dark_amber", "fine_rabbit_meat"},
			amounts = {1, 1},
			rates = {8.5, 25}
		}
	},
	["thump"] = {
		loot = {
			items = {"dark_amber", "fine_rabbit_meat"},
			amounts = {1, 1},
			rates = {8.5, 25}
		}
	},
	["fluff"] = {
		loot = {
			items = {"dark_amber", "fine_rabbit_meat"},
			amounts = {1, 1},
			rates = {10, 25}
		}
	},
	["rabbit_defender"] = {
		loot = {
			items = {"fine_rabbit_meat"},
			amounts = {1},
			rates = {35}
		},
		rareLoot = {
			items = {"sun_helm", "lucky_coin"},
			rates = {0.0167, 1}
		}
	},
	["spirit_rabbit"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2200, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_earth"},
			rates = {100}
		}
	},
	["rabbit_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2200, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"sun_helm", "lucky_coin"},
			rates = {0.834, 50}
		}
	},

	-- ------------------------------
	-- Monkey 1
	-- ------------------------------
	["plain_monkey"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {2.5}
		}
	},
	["sly_monkey"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["spry_monkey"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {7.5}
		}
	},
	["ugly_monkey"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {7.5}
		}
	},
	["monkey_sentry"] = {
		loot = {
			items = {"white_amber"},
			amounts = {1},
			rates = {10}
		},
		rareLoot = {
			items = {"star_helmet", "ambrosia"},
			rates = {0.1, 1}
		}
	},
	["mythic_monkey"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {600, 5, 3, 1, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_fire"},
			rates = {100}
		}
	},
	["monkey_mauler"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {600, 5, 3, 1, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"star_helmet", "ambrosia"},
			rates = {5, 50}
		}
	},

	-- ------------------------------
	-- Monkey 2
	-- ------------------------------
	["simple_monkey"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {7.5}
		}
	},
	["quick_monkey"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {7.5}
		}
	},
	["agile_monkey"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {10}
		}
	},
	["monsterous_monkey"] = {
		rareLoot = {
			items = {"white_amber", "dark_amber"},
			rates = {2.5, 7.5}
		}
	},
	["monkey_guardian"] = {
		rareLoot = {
			items = {"moon_helmet", "ambrosia", "white_amber", "dark_amber"},
			rates = {0.034, 1, 5, 10}
		}
	},
	["divine_monkey"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1300, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_fire"},
			rates = {100}
		}
	},
	["monkey_basher"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1300, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"moon_helmet", "ambrosia"},
			rates = {1.67, 50}
		}
	},

	-- ------------------------------
	-- Monkey 3
	-- ------------------------------
	["bright_monkey"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {10}
		}
	},
	["fast_monkey"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {10}
		}
	},
	["spunky_monkey"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {10}
		}
	},
	["diamond_monkey"] = {
		rareLoot = {
			items = {"white_amber", "dark_amber"},
			rates = {5, 10}
		}
	},
	["monkey_defender"] = {
		rareLoot = {
			items = {"sun_helmet", "ambrosia", "white_amber", "dark_amber"},
			rates = {0.0167, 1, 5, 10}
		}
	},
	["spirit_monkey"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2600, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_fire"},
			rates = {100}
		}
	},
	["monkey_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2600, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"sun_helmet", "ambrosia"},
			rates = {0.834, 50}
		}
	},

	-- ------------------------------
	-- Dog 1
	-- ------------------------------
	["fierce_dog"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {2.5}
		}
	},
	["fighting_dog"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {2.5}
		}
	},
	["mad_dog"] = {
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {1.25, 2.5}
		}
	},
	["pale_dog"] = {
		rareLoot = {
			items = {"dark_amber", "amber"},
			rates = {1.25, 2.5}
		}
	},
	["dog_sentry"] = {
		loot = {
			items = {"amber", "dark_amber"},
			amounts = {1, 1},
			rates = {15, 10}
		},
		rareLoot = {
			items = {"cursed_blade", "fragile_rose"},
			rates = {0.1, 1}
		}
	},
	["mythic_dog"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {600, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_wind"},
			rates = {100}
		}
	},
	["dog_assassin"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {600, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"cursed_blade", "fragile_rose"},
			rates = {5, 50}
		}
	},

	-- ------------------------------
	-- Dog 2
	-- ------------------------------
	["dog_trooper"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {2.5}
		}
	},
	["crazed_mongrel"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {2.5}
		}
	},
	["spunky_dog"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {2.5}
		}
	},
	["death_mongrel"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {2.5}
		}
	},
	["dog_guardian"] = {
		loot = {
			items = {"amber", "white_amber"},
			amounts = {1, 1, 1, 1},
			rates = {25, 10}
		},
		rareLoot = {
			items = {"corrupted_blade", "fragile_rose"},
			rates = {0.05, 1}
		}
	},
	["divine_dog"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1800, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_wind"},
			rates = {100}
		}
	},
	["dog_cutthroat"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1800, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"corrupted_blade", "fragile_rose"},
			rates = {2.5, 50}
		}
	},

	-- ------------------------------
	-- Dog 3
	-- ------------------------------
	["spotted_mutt"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {2.5}
		}
	},
	["frothing_mutt"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {2.5}
		}
	},
	["killer_mongrel"] = {
		rareLoot = {
			items = {"white_amber", "dark_amber"},
			rates = {1.25, 2.5}
		}
	},
	["wolf_kin"] = {
		rareLoot = {
			items = {"white_amber", "dark_amber"},
			rates = {1.25, 2.5}
		}
	},
	["dog_defender"] = {
		loot = {
			items = {"amber", "white_amber"},
			amounts = {1, 1},
			rates = {10, 5}
		},
		rareLoot = {
			items = {"forsaken_blade", "fragile_rose"},
			rates = {0.0167, 1}
		}
	},
	["spirit_dog"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3100, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_wind"},
			rates = {100}
		}
	},
	["dog_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3100, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"forsaken_blade", "fragile_rose"},
			rates = {0.834, 50}
		}
	},

	-- ------------------------------
	-- Rooster 1
	-- ------------------------------
	["black_chick"] = {
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {17, 34}
		}
	},
	["wild_chicken"] = {
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {17, 34}
		}
	},
	["wild_rooster"] = {
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {17, 34}
		}
	},
	["radiant_chick"] = {
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {17, 34}
		}
	},
	["rooster_sentry"] = {
		loot = {
			items = {"white_amber"},
			amounts = {1},
			rates = {15}
		},
		rareLoot = {
			items = {"cursed_ring", "scribes_pen"},
			rates = {0.2, 1}
		}
	},
	["mythic_rooster"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {800, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_heaven"},
			rates = {100}
		}
	},
	["rooster_swordsman"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {800, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"cursed_ring", "scribes_pen"},
			rates = {10, 50}
		}
	},

	-- ------------------------------
	-- Rooster 2
	-- ------------------------------
	["red_chick"] = {
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {34, 67}
		}
	},
	["fiery_chick"] = {
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {17, 34}
		}
	},
	["white_chicken"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {17, 34}
		}
	},
	["white_rooster"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {17, 34}
		}
	},
	["rooster_guardian"] = {
		loot = {
			items = {"white_amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"corrupted_ring", "scribes_pen"},
			rates = {0.1, 1}
		}
	},
	["divine_rooster"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1800, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_heaven"},
			rates = {100}
		}
	},
	["rooster_barbarian"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1800, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"corrupted_ring", "scribes_pen"},
			rates = {5, 50}
		}
	},

	-- ------------------------------
	-- Rooster 3
	-- ------------------------------
	["wild_chick"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {17, 34}
		}
	},
	["black_chicken"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {17, 34}
		}
	},
	["great_roost"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {17, 34}
		}
	},
	["sunfeather"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"egg", "chicken_meat"},
			rates = {17, 34}
		}
	},
	["rooster_defender"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {20}
		},
		rareLoot = {
			items = {"forsaken_ring", "scribes_pen"},
			rates = {1, 0.034}
		}
	},
	["spirit_rooster"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3300, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_heaven"},
			rates = {100}
		}
	},
	["rooster_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3300, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"forsaken_ring", "scribes_pen"},
			rates = {1.67, 50}
		}
	},

	-- ------------------------------
	-- Rat 1
	-- ------------------------------
	["mythic_mouse"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 5}
		}
	},
	["vile_rat"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 5}
		}
	},
	["blood_rat"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 5}
		}
	},
	["killer_rat"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 5}
		}
	},
	["rat_sentry"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {15}
		},
		rareLoot = {
			items = {"cursed_staff", "battle_helm"},
			rates = {0.1, 1}
		}
	},
	["mythic_rat"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_pond"},
			rates = {100}
		}
	},
	["mighty_mouse"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"cursed_staff", "battle_helm"},
			rates = {5, 50}
		}
	},

	-- ------------------------------
	-- Rat 2
	-- ------------------------------
	["divine_mouse"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 6}
		}
	},
	["mud_rat"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 6}
		}
	},
	["hunter_rat"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 6}
		}
	},
	["lava_rat"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 6}
		}
	},
	["rat_guardian"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {15}
		},
		rareLoot = {
			items = {"corrupted_staff", "battle_helm"},
			rates = {0.05, 1}
		}
	},
	["divine_rat"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2100, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_pond"},
			rates = {100}
		}
	},
	["rat_lord"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2100, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"corrupted_staff", "battle_helm"},
			rates = {2.5, 50}
		}
	},

	-- ------------------------------
	-- Rat 3
	-- ------------------------------
	["spirit_mouse"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 7.5}
		}
	},
	["earth_rat"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 7.5}
		}
	},
	["fire_rat"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 7.5}
		}
	},
	["beady_eyed_stalker"] = {
		loot = {
			items = {"rat_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 7.5}
		}
	},
	["rat_defender"] = {
		loot = {
			items = {"white_amber"},
			amounts = {1},
			rates = {15}
		},
		rareLoot = {
			items = {"forsaken_staff", "battle_helm"},
			rates = {0.0167, 1}
		}
	},
	["spirit_rat"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3700, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_pond"},
			rates = {100}
		}
	},
	["rat_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3700, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"forsaken_staff", "battle_helm"},
			rates = {0.834, 50}
		}
	},

	-- ------------------------------
	-- Horse 1
	-- ------------------------------
	["wild_horse"] = {
		loot = {
			items = {"horse_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["skilled_horse"] = {
		loot = {
			items = {"horse_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["elite_horse"] = {
		loot = {
			items = {"horse_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["horse_guardsman_main"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["horse_guardsman"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		},
		rareLoot = {
			items = {"hoof_sabre", "pearl_charm"},
			rates = {0.02, 1}
		}
	},
	["horse_sentry_main"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["horse_sentry"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {10}
		},
		rareLoot = {
			items = {"hoof_sabre", "pearl_charm"},
			rates = {0.02, 1}
		}
	},
	["mythic_horse"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1200, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_thunder"},
			rates = {100}
		}
	},
	["horse_do"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1200, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"hoof_sabre", "pearl_charm"},
			rates = {1, 50}
		}
	},

	-- ------------------------------
	-- Horse 2
	-- ------------------------------
	["spirited_horse"] = {
		loot = {
			items = {"horse_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["golden_horse"] = {
		loot = {
			items = {"horse_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["diamond_horse"] = {
		loot = {
			items = {"horse_meat", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["horse_swordsman_main"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {7.5}
		}
	},
	["horse_swordsman"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {15}
		},
		rareLoot = {
			items = {"mythic_sabre", "pearl_charm"},
			rates = {0.008, 1}
		}
	},
	["horse_guardian_main"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {7.5}
		}
	},
	["horse_guardian"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {15}
		},
		rareLoot = {
			items = {"mythic_sabre", "pearl_charm"},
			rates = {0.008, 1}
		}
	},
	["divine_horse"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2700, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_thunder"},
			rates = {100}
		}
	},
	["horse_chongun"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2700, 5, 3, 1, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"mythic_sabre", "pearl_charm"},
			rates = {0.4, 50}
		}
	},

	-- ------------------------------
	-- Horse 3
	-- ------------------------------
	["wooden_horse"] = {
		loot = {
			items = {"horse_meat", "dark_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["lake_winny"] = {
		loot = {
			items = {"horse_meat", "dark_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["fire_snorter"] = {
		loot = {
			items = {"horse_meat", "dark_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["hooves_main"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["hooves"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {10}
		},
		rareLoot = {
			items = {"flameblade", "pearl_charm"},
			rates = {0.002, 1}
		}
	},
	["horse_defender_main"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["horse_defender"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {10}
		},
		rareLoot = {
			items = {"flameblade", "pearl_charm"},
			rates = {0.002, 1}
		}
	},
	["spirit_horse"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {4500, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_thunder"},
			rates = {100}
		}
	},
	["horse_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {4500, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"flameblade", "pearl_charm"},
			rates = {0.1, 50}
		}
	},

	-- ------------------------------
	-- Ox 1
	-- ------------------------------
	["large_bull"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {2.5}
		},
		rareLoot = {
			items = {"lean_beef", "beef"},
			rates = {17, 34}
		}
	},
	["raging_bull"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {2.5}
		},
		rareLoot = {
			items = {"lean_beef", "beef"},
			rates = {17, 34}
		}
	},
	["charging_ox"] = {
		loot = {
			items = {"amber"},
			amounts = {1},
			rates = {2.5}
		},
		rareLoot = {
			items = {"lean_beef", "beef"},
			rates = {17, 34}
		}
	},
	["ox_sentry"] = {
		rareLoot = {
			items = {"military_fork", "tao_stone"},
			rates = {0.02, 1}
		}
	},
	["mythic_ox"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1500, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_water"},
			rates = {100}
		}
	},
	["ox_gorer"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1500, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"military_fork", "tao_stone"},
			rates = {1, 50}
		}
	},

	-- ------------------------------
	-- Ox 2
	-- ------------------------------
	["giant_bull"] = {
		loot = {
			items = {"lean_beef", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["rampaging_bull"] = {
		loot = {
			items = {"lean_beef", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["angry_ox"] = {
		loot = {
			items = {"lean_beef", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["ox_guardian"] = {
		rareLoot = {
			items = {"might_spear", "tao_stone"},
			rates = {0.008, 1}
		}
	},
	["divine_ox"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_water"},
			rates = {100}
		}
	},
	["ox_charger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3000, 5, 3, 1, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"might_spear", "tao_stone"},
			rates = {0.4, 50}
		}
	},

	-- ------------------------------
	-- Ox 3
	-- ------------------------------
	["great_horns"] = {
		loot = {
			items = {"lean_beef", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["pale_hunger"] = {
		loot = {
			items = {"lean_beef", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["tough_fight"] = {
		loot = {
			items = {"lean_beef", "amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["ox_defender"] = {
		rareLoot = {
			items = {"stone_axe", "tao_stone"},
			rates = {0.002, 1}
		}
	},
	["spirit_ox"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {5500, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_water"},
			rates = {100}
		}
	},
	["ox_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {5500, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"stone_axe", "tao_stone"},
			rates = {0.1, 50}
		}
	},

	-- ------------------------------
	-- Pig 1
	-- ------------------------------
	["stubborn_piglet"] = {
		loot = {
			items = {"rare_pork", "dark_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["stubborn_pig"] = {
		loot = {
			items = {"rare_pork", "dark_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["fat_pig"] = {
		loot = {
			items = {"rare_pork", "dark_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["stubborn_warthog"] = {
		loot = {
			items = {"rare_pork", "dark_amber"},
			amounts = {1, 1},
			rates = {34, 5}
		}
	},
	["boar_sentry"] = {
		rareLoot = {
			items = {"dark_staff", "magical_dust", "white_amber", "dark_amber"},
			rates = {0.04, 1, 5, 15}
		}
	},
	["mythic_boar"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1700, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_mountain"},
			rates = {100}
		}
	},
	["boar_champion"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1700, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"dark_staff", "magical_dust"},
			rates = {2, 50}
		}
	},

	-- ------------------------------
	-- Pig 2
	-- ------------------------------
	["stout_piglet"] = {
		loot = {
			items = {"rare_pork", "dark_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["stout_pig"] = {
		loot = {
			items = {"rare_pork", "dark_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["obese_pig"] = {
		loot = {
			items = {"rare_pork", "dark_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["stout_warthog"] = {
		loot = {
			items = {"rare_pork", "dark_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["pig_guardian"] = {
		rareLoot = {
			items = {"bright_staff", "magical_dust", "white_amber", "dark_amber"},
			rates = {0.016, 1, 5, 15}
		}
	},
	["divine_pig"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3700, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_mountain"},
			rates = {100}
		}
	},
	["pig_champion"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3700, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"bright_staff", "magical_dust"},
			rates = {0.8, 50}
		}
	},

	-- ------------------------------
	-- Pig 3
	-- ------------------------------
	["bold_piglet"] = {
		loot = {
			items = {"rare_pork", "white_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["bold_pig"] = {
		loot = {
			items = {"rare_pork", "white_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["bold_hog"] = {
		loot = {
			items = {"rare_pork", "white_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["bold_boar"] = {
		loot = {
			items = {"rare_pork", "white_amber"},
			amounts = {1, 1},
			rates = {34, 2.5}
		}
	},
	["boar_defender"] = {
		loot = {
			items = {"pork"},
			amounts = {1},
			rates = {67}
		},
		rareLoot = {
			items = {"crystal_staff", "magical_dust", "white_amber"},
			rates = {0.004, 1, 10}
		}
	},
	["spirit_pig"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {7000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"key_to_mountain"},
			rates = {100}
		}
	},
	["pig_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {7000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"crystal_staff", "magical_dust"},
			rates = {0.2, 50}
		}
	},

	-- ------------------------------
	-- Snake 1
	-- ------------------------------
	["plain_snake"] = {
		rareLoot = {
			items = {"fine_snake_meat", "snake_meat"},
			rates = {5, 34}
		}
	},
	["blood_snake"] = {
		rareLoot = {
			items = {"fine_snake_meat", "snake_meat"},
			rates = {5, 34}
		}
	},
	["radiant_snake"] = {
		rareLoot = {
			items = {"fine_snake_meat", "snake_meat"},
			rates = {5, 34}
		}
	},
	["fire_snake"] = {
		rareLoot = {
			items = {"fine_snake_meat", "snake_meat"},
			rates = {17, 34}
		}
	},
	["snake_sentry"] = {
		rareLoot = {
			items = {"charm", "scribes_book"},
			rates = {0.1, 1}
		}
	},
	["mythic_snake"] = {
		rareLoot = {
			items = {"hyun_moo_key"},
			rates = {50}
		}
	},
	["snake_shaman"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {1200, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"charm", "scribes_book"},
			rates = {5, 50}
		}
	},

	-- ------------------------------
	-- Snake 2
	-- ------------------------------
	["simple_snake"] = {
		loot = {
			items = {"fine_snake_meat", "amber"},
			amounts = {1, 1},
			rates = {5, 2.5}
		}
	},
	["lava_snake"] = {
		loot = {
			items = {"fine_snake_meat", "amber"},
			amounts = {1, 1},
			rates = {5, 2.5}
		}
	},
	["glowing_snake"] = {
		loot = {
			items = {"fine_snake_meat", "amber"},
			amounts = {1, 1},
			rates = {5, 2.5}
		}
	},
	["dark_snake"] = {
		loot = {
			items = {"fine_snake_meat", "amber"},
			amounts = {1, 1},
			rates = {5, 2.5}
		}
	},
	["snake_guardian"] = {
		rareLoot = {
			items = {"il_san_charm", "scribes_book"},
			rates = {0.034, 1}
		}
	},
	["divine_snake"] = {
		rareLoot = {
			items = {"hyun_moo_key"},
			rates = {50}
		}
	},
	["snake_mage"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"il_san_charm", "scribes_book"},
			rates = {1.67, 50}
		}
	},

	-- ------------------------------
	-- Snake 3
	-- ------------------------------
	["meter_worm"] = {
		loot = {
			items = {"fine_snake_meat", "dark_amber"},
			amounts = {1, 1},
			rates = {5, 2.5}
		}
	},
	["spasm"] = {
		loot = {
			items = {"fine_snake_meat", "dark_amber"},
			amounts = {1, 1},
			rates = {5, 2.5}
		}
	},
	["slitherly"] = {
		loot = {
			items = {"fine_snake_meat", "dark_amber"},
			amounts = {1, 1},
			rates = {5, 2.5}
		}
	},
	["storm_snake"] = {
		loot = {
			items = {"fine_snake_meat", "dark_amber"},
			amounts = {1, 1},
			rates = {5, 2.5}
		}
	},
	["snake_defender"] = {
		rareLoot = {
			items = {"ee_san_charm", "scribes_book"},
			rates = {0.0167, 1}
		}
	},
	["spirit_snake"] = {
		rareLoot = {
			items = {"hyun_moo_key"},
			rates = {50}
		}
	},
	["snake_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {8000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"ee_san_charm", "scribes_book"},
			rates = {0.834, 50}
		}
	},

	-- ------------------------------
	-- Sheep 1
	-- ------------------------------
	["fierce_sheep"] = {
		loot = {
			items = {"wool", "amber"},
			amounts = {1, 1},
			rates = {20, 2.5}
		}
	},
	["ugly_sheep"] = {
		loot = {
			items = {"wool", "amber"},
			amounts = {1, 1},
			rates = {20, 2.5}
		}
	},
	["sheep_sentry"] = {
		rareLoot = {
			items = {"surge", "lucky_silver_coin"},
			rates = {0.1, 1}
		}
	},
	["mythic_sheep"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {2400, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"ju_jak_key"},
			rates = {50}
		}
	},
	["sheep_veteran"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {2400, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"surge", "lucky_silver_coin"},
			rates = {5, 30}
		}
	},

	-- ------------------------------
	-- Sheep 2
	-- ------------------------------
	["black_sheep"] = {
		loot = {
			items = {"wool", "amber"},
			amounts = {1, 1},
			rates = {25, 2.5}
		}
	},
	["red_sheep"] = {
		loot = {
			items = {"wool", "amber"},
			amounts = {1, 1},
			rates = {25, 2.5}
		}
	},
	["sheep_guardian"] = {
		rareLoot = {
			items = {"il_san_surge", "lucky_silver_coin"},
			rates = {0.034, 1}
		}
	},
	["divine_sheep"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {5500, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"ju_jak_key"},
			rates = {50}
		}
	},
	["sheep_shepherd"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {5500, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"il_san_surge", "lucky_silver_coin"},
			rates = {1.67, 50}
		}
	},

	-- ------------------------------
	-- Sheep 3
	-- ------------------------------
	["flaming_sheep"] = {
		loot = {
			items = {"wool", "white_amber"},
			amounts = {1, 1},
			rates = {30, 2.5}
		}
	},
	["dark_sheep"] = {
		loot = {
			items = {"wool", "white_amber"},
			amounts = {1, 1},
			rates = {30, 2.5}
		}
	},
	["sheep_defender"] = {
		rareLoot = {
			items = {"ee_san_surge", "lucky_silver_coin"},
			rates = {0.0167, 1}
		}
	},
	["spirit_sheep"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {9000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"ju_jak_key"},
			rates = {50}
		}
	},
	["sheep_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {9000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"ee_san_surge", "lucky_silver_coin"},
			rates = {0.834, 50}
		}
	},

	-- ------------------------------
	-- Tiger 1
	-- ------------------------------
	["restless_tiger"] = {
		loot = {
			items = {"splendid_tiger_pelt", "amber"},
			amounts = {1, 1},
			rates = {1, 2.5}
		}
	},
	["golden_tiger"] = {
		loot = {
			items = {"splendid_tiger_pelt", "amber"},
			amounts = {1, 1},
			rates = {1, 2.5}
		}
	},
	["dark_tiger"] = {
		loot = {
			items = {"splendid_tiger_pelt", "amber"},
			amounts = {1, 1},
			rates = {1, 2.5}
		}
	},
	["giant_tiger"] = {
		loot = {
			items = {"splendid_tiger_pelt", "amber"},
			amounts = {1, 1},
			rates = {1, 2.5}
		}
	},
	["tiger_sentry"] = {
		loot = {
			items = {"splendid_tiger_pelt", "amber"},
			amounts = {1, 1},
			rates = {2, 5}
		},
		rareLoot = {
			items = {"blood", "purified_water"},
			rates = {0.1, 1}
		}
	},
	["mythic_tiger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2700, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"baekho_key"},
			rates = {50}
		}
	},
	["tiger_warrior"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2700, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"blood", "purified_water"},
			rates = {5, 50}
		}
	},

	-- ------------------------------
	-- Tiger 2
	-- ------------------------------
	["raging_tiger"] = {
		loot = {
			items = {"splendid_tiger_pelt", "amber"},
			amounts = {1, 1},
			rates = {1, 2.5}
		}
	},
	["black_tiger"] = {
		loot = {
			items = {"splendid_tiger_pelt", "amber"},
			amounts = {1, 1},
			rates = {1, 2.5}
		}
	},
	["huge_tiger"] = {
		loot = {
			items = {"splendid_tiger_pelt", "amber"},
			amounts = {1, 1},
			rates = {1, 2.5}
		}
	},
	["tiger_guardian"] = {
		loot = {
			items = {"splendid_tiger_pelt", "amber"},
			amounts = {1, 1},
			rates = {2, 5}
		},
		rareLoot = {
			items = {"il_san_blood", "purified_water"},
			rates = {0.034, 1}
		}
	},
	["divine_tiger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3800, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"baekho_key"},
			rates = {50}
		}
	},
	["tiger_slasher"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {3800, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"il_san_blood", "purified_water"},
			rates = {1.67, 50}
		}
	},

	-- ------------------------------
	-- Tiger 3
	-- ------------------------------
	["brazen"] = {
		loot = {
			items = {"splendid_tiger_pelt", "dark_amber"},
			amounts = {1, 1},
			rates = {1, 2.5}
		}
	},
	["knap"] = {
		loot = {
			items = {"splendid_tiger_pelt", "dark_amber"},
			amounts = {1, 1},
			rates = {1, 2.5}
		}
	},
	["crazy_claw"] = {
		loot = {
			items = {"splendid_tiger_pelt", "dark_amber"},
			amounts = {1, 1},
			rates = {1, 2.5}
		}
	},
	["tiger_defender"] = {
		loot = {
			items = {"splendid_tiger_pelt", "dark_amber"},
			amounts = {1, 1},
			rates = {2, 5}
		},
		rareLoot = {
			items = {"ee_san_blood", "purified_water"},
			rates = {0.0167, 1}
		}
	},
	["spirit_tiger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {5000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"baekho_key"},
			rates = {50}
		}
	},
	["tiger_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {5000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"ee_san_blood", "purified_water"},
			rates = {0.834, 50}
		}
	},

	-- ------------------------------
	-- Dragon 1
	-- ------------------------------
	["drake"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {25}
		}
	},
	["dragon_hatchling"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {25}
		}
	},
	["young_dragon"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {25}
		}
	},
	["dragon_sentry"] = {
		rareLoot = {
			items = {"spike", "dragons_liver"},
			rates = {0.1, 1}
		}
	},
	["mythic_dragon"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {2400, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"chung_ryong_key"},
			rates = {50}
		}
	},
	["dragon_mage"] = {
		loot = {
			items = {2, "amber", "dark_amber", "white_amber"},
			amounts = {2400, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"spike", "dragons_liver"},
			rates = {5, 50}
		}
	},

	-- ------------------------------
	-- Dragon 2
	-- ------------------------------
	["ancient_drake"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {25}
		}
	},
	["adolescent_dragon"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {25}
		}
	},
	["mature_dragon"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {25}
		}
	},
	["serpentine_dragon"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {25}
		}
	},
	["dragon_guardian"] = {
		rareLoot = {
			items = {"il_san_spike", "dragons_liver"},
			rates = {0.034, 1}
		}
	},
	["divine_dragon"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2750, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"chung_ryong_key"},
			rates = {50}
		}
	},
	["dragon_slayer"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {2750, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"il_san_spike", "dragons_liver"},
			rates = {1.67, 50}
		}
	},

	-- ------------------------------
	-- Dragon 3
	-- ------------------------------
	["great_wyrm"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {25}
		}
	},
	["mighty_wyrm"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {25}
		}
	},
	["old_dragon"] = {
		loot = {
			items = {"tarnished_amber"},
			amounts = {1},
			rates = {25}
		}
	},
	["dragon_defender"] = {
		loot = {
			items = {"dark_amber", "white_amber"},
			amounts = {1, 1},
			rates = {15, 5}
		},
		rareLoot = {
			items = {"ee_san_spike", "dragons_liver"},
			rates = {0.0167, 1}
		}
	},
	["spirit_dragon"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {12000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"chung_ryong_key"},
			rates = {50}
		}
	},
	["dragon_avenger"] = {
		loot = {
			items = {3, "amber", "dark_amber", "white_amber"},
			amounts = {12000, 5, 3, 1},
			rates = {100, 100, 67, 34}
		},
		rareLoot = {
			items = {"ee_san_spike", "dragons_liver"},
			rates = {0.834, 50}
		}
	},

	-- ------------------------------
	-- Vale
	-- ------------------------------

	-- ------------------------------
	-- Black Skeletons
	-- ------------------------------
	["black_skeleton"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["skeleton_je"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["skeleton_ja"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["skeleton_ji"] = {
		loot = {
			items = {"dark_amber"},
			amounts = {1},
			rates = {5}
		}
	},
	["skeleton_sa"] = {
		rareLoot = {
			items = {"scorched_bone"},
			rates = {34}
		}
	},

	-- ------------------------------
	-- Polar Bear Cave
	-- ------------------------------
	["polar_bear"] = {
		loot = {
			items = {"bears_liver"},
			amounts = {1},
			rates = {6}
		}
	},
	["death_wish"] = {
		loot = {
			items = {"dark_amber", "white_amber"},
			amounts = {1, 1},
			rates = {34, 17}
		},
		rareLoot = {
			items = {"ice_sabre"},
			rates = {34}
		}
	},

	-- ------------------------------
	-- Call of the Wild mobs
	-- ------------------------------
	["cotw_panda_bear"] = {
		loot = {
			items = {"bears_liver"},
			amounts = {1},
			rates = {20}
		}
	},

	-- ------------------------------
	-- Nagnag Armory (mercenaries)
	-- ------------------------------
	["nagnag_armory_0"] = {
		rareLoot = {
			items = {"ambrosia", "lucky_coin", "scribes_pen", "fragile_rose"},
			rates = {1, 1, 1, 1}
		}
	},
	["nagnag_armory_1"] = {
		rareLoot = {
			items = {"titanium_glove", "whisper_bracelet", "holy_ring", "sen_glove"},
			rates = {1, 1, 1, 1}
		}
	},
	["nagnag_armory_2"] = {
		rareLoot = {
			items = {"electra", "steelthorn", "star_staff", "titanium_lance"},
			rates = {1, 1, 1, 1}
		}
	},
	["nagnag_armory_3"] = {
		rareLoot = {
			items = {"spike", "blood", "surge", "charm"},
			rates = {1, 1, 1, 1}
		}
	},
	["nagnag_armory_4"] = {
		rareLoot = {
			items = {"spike", "blood", "surge", "charm"},
			rates = {2, 2, 2, 2}
		}
	}
}

-- ------------------------------
-- Common drops
-- ------------------------------
local _handleLoot = function(mob, loot)
	if (loot == nil) then
		return
	end

	local items = loot.items
	local amounts = loot.amounts
	local rates = loot.rates

	for i = 1, #items do
		local roll = math.random(1, 100000)

		if (amounts[i] > 0 and roll <= rates[i] * 1000) then
			if (type(items[i]) == 'number') then
				-- Gold
				if (amounts[i] == 1) then
					mob:dropItem(0, amounts[i], 0, 0)
				elseif (amounts[i] >= 2 and amounts[i] <= 99) then
					mob:dropItem(1, amounts[i], 0, 0)
				elseif (amounts[i] >= 100 and amounts[i] <= 999) then
					mob:dropItem(2, amounts[i], 0, 0)
				elseif (amounts[i] >= 1000) then
					mob:dropItem(3, amounts[i], 0, 0)
				end
			else
				mob:dropItem(items[i], math.random(1, amounts[i]), 0, 0)
			end

			characterLog.dropLog(mob, items, amounts)
		end
	end
end

-- ------------------------------
-- Rare drops
-- ------------------------------
local _handleRareLoot = function(mob, rareLoot)
	if (rareLoot == nil) then
		return
	end

	local items = rareLoot.items
	local rates = rareLoot.rates
	local droppedItems = {}

	for i = 1, #items do
		local roll = math.random(1, 100000)

		broadcast(4, "Mob: " .. mob.yname .. "; Roll: " .. roll)

		if (roll <= rates[i] * 1000) then
			table.insert(droppedItems, items[i])
		end
	end

	if (#droppedItems > 0) then
		local droppedItem = droppedItems[1]
		mob:dropItem(droppedItem, 1, 0, 0)
		characterLog.dropLog(mob, {droppedItem}, {1})
	end
end

-- ------------------------------
-- Nagnag Armory (mercenaries)
-- ------------------------------
local _nagnagMercenaries = {
	"nagnag_mercenary_1",
	"nagnag_mercenary_2",
	"nagnag_mercenary_3",
	"armory_mercenary_1a",
	"armory_mercenary_1b",
	"armory_mercenary_1c",
	"armory_mercenary_2a",
	"armory_mercenary_2b",
	"armory_mercenary_2c",
	"armory_mercenary_3a",
	"armory_mercenary_3b",
	"armory_mercenary_3c"
}

local _getNanagMercenaryLoot = function(mob)
	if (not Tools.tableContainsValue(_nagnagMercenaries, mob.yname)) then
		return nil
	end

	local lootLevel = nil

	if (mob.m >= 5800 and mob.m <= 5839) then
		lootLevel = 0
	end

	-- level 1  lvl: 11-69
	if (mob.m >= 5840 and mob.m <= 5879) then
		lootLevel = 1
	end

	-- level 2  lvl: 70-99
	if (mob.m >= 5880 and mob.m <= 5919) then
		lootLevel = 2
	end

	-- level 3  lvl: 99-il san
	if (mob.m >= 5920 and mob.m <= 5959) then
		lootLevel = 3
	end

	-- level 4  lvl: ee san
	if mob.m >= 5960 and mob.m <= 5996 then
		lootLevel = 4
	end

	-- level 5  lvl: sam san +

	if (lootLevel == nil) then
		return nil
	end

	return _mobDropsTable["nagnag_armory_" .. lootLevel].loot
end

-- ------------------------------
-- Map fragments
-- ------------------------------
local _handleMapFragmentLoot = function(mob)
	if (mob.level >= 99) then
		if (math.random(100) == 1) then
			mob:dropItem("map_fragment", 1)
		end
	end
end

-- --------------------------------------------
-- Dragon essence quest to unlock Mount Baekdu
-- --------------------------------------------
local _dragonEssenceMaps = {
	250,
	251,
	252,
	253,
	254,
	255,
	256,
	257,
	258,
	3250,
	3251,
	3252,
	3253,
	3254,
	3255,
	3256,
	3257,
	3258,
	4250,
	4251,
	4252,
	4253,
	4254,
	4255,
	4256,
	4257,
	4258
}

local _handleDragonEssenceLoot = function(player)
	if (not Tools.tableContainsValue(_dragonEssenceMaps, player.m)) then
		return
	end

	for i = 1, #player.group do
		local pc = Player(player.group[i])

		if (pc == nil or pc.quest["instance"] ~= 5) then
			return
		end

		local rand = math.random(1, 100)

		if (rand <= 10) then
			if (pc:hasSpace("dragon_essence", 1)) then
				pc:addItem("dragon_essence", 1)
				pc:sendAnimation(151)
			elseif (pc:hasItem("dragon_essence", 5) == true) then
				pc:sendMinitext("You cannot gather any more of the dragon's energy.")
			else
				pc:sendMinitext("You attempted to gather the dragon's energy, but your bags are full.")
			end
		end
	end
end

-- ------------------------------
-- Mob drops handler
-- ------------------------------
HandleMobDrops = function(player, mob)
	if player.blType ~= BL_PC then
		return
	end

	local mobName = mob.yname

	if (Tools.tableContainsKey(_mobDropsTable, mobName)) then
		local loot = _mobDropsTable[mobName].loot
		_handleLoot(mob, loot)

		local rareLoot = _mobDropsTable[mobName].rareLoot
		_handleRareLoot(mob, rareLoot)
	else
		local nagnangMercenaryLoot = _getNanagMercenaryLoot(mob)

		if (nagnangMercenaryLoot ~= nil) then
			_handleLoot(mob, nagnangMercenaryLoot)
		end
	end

	_handleMapFragmentLoot(mob)
	_handleDragonEssenceLoot(player)
end
