local _minorQuest = "minor_quest"
local _minorQuestInfo = "minor_quest_info"
local _minorQuestKillCount = "minor_quest_kill_count_"
local _minorQuestTier = "minor_quest_tier"
local _minorQuestTimer = "minor_quest_timer"
local _minorQuestsCompleted = "minor_quests_completed"
local _sayCompleteWhenDone = "Say 'complete' to me when you are done."
local _maxLevel = 100
local _maxStat = 1000000000
local _maxMark = 5

local _minorQuests = {
	-- (1+) Kingdom animals
	["squirrel"] = {
		displayName = "Squirrel",
		mobs = {"squirrel"},
		minLevel = 0,
		maxLevel = 10,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["rabbit"] = {
		displayName = "Rabbit",
		mobs = {"rabbit", "white_rabbit"},
		minLevel = 0,
		maxLevel = 15,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["deer"] = {
		displayName = "Deer",
		mobs = {"deer", "doe"},
		minLevel = 3,
		maxLevel = 15,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["horse"] = {
		displayName = "Horse",
		mobs = {"horse"},
		minLevel = 3,
		maxLevel = 15,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["fox"] = {
		displayName = "Fox",
		mobs = {"fox"},
		minLevel = 5,
		maxLevel = 15,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["wolf"] = {
		displayName = "Wolf",
		mobs = {"wolf"},
		minLevel = 5,
		maxLevel = 15,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["snake"] = {
		displayName = "Snake",
		mobs = {"snake"},
		minLevel = 20,
		maxLevel = 60,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["bear"] = {
		displayName = "Bear",
		mobs = {"bear"},
		minLevel = 20,
		maxLevel = 60,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["tiger"] = {
		displayName = "Tiger",
		mobs = {"tiger"},
		minLevel = 20,
		maxLevel = 60,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (4) Rat cave
	["mouse"] = {
		displayName = "Mouse",
		mobs = {"mouse"},
		minLevel = 4,
		maxLevel = 20,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["rat"] = {
		displayName = "Rat",
		mobs = {"rat"},
		minLevel = 5,
		maxLevel = 20,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["white_rat"] = {
		displayName = "White rat",
		mobs = {"white_rat"},
		minLevel = 5,
		maxLevel = 20,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (9) Green squirrel
	["green_squirrel"] = {
		displayName = "Green Squirrel",
		mobs = {"green_squirrel"},
		minLevel = 9,
		maxLevel = 25,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (14) Kugnae snake cave
	["mud_snake"] = {
		displayName = "Mud Snake",
		mobs = {"mud_snake"},
		minLevel = 14,
		maxLevel = 35,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (20) Fox cave
	["dark_fox"] = {
		displayName = "Dark fox",
		mobs = {"dark_fox"},
		minLevel = 20,
		maxLevel = 40,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["blood_fox"] = {
		displayName = "Blood fox",
		mobs = {"blood_fox"},
		minLevel = 20,
		maxLevel = 45,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["lava_fox"] = {
		displayName = "Lava fox",
		mobs = {"lava_fox"},
		minLevel = 20,
		maxLevel = 50,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["sun_fox"] = {
		displayName = "Sun fox",
		mobs = {"sun_fox"},
		minLevel = 25,
		maxLevel = 55,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (20+) Arctic ogres
	["slush_ogre"] = {
		displayName = "Slush ogre",
		mobs = {"slush_ogre"},
		minLevel = 25,
		maxLevel = 50,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["snow_ogre"] = {
		displayName = "Snow ogre",
		mobs = {"snow_ogre"},
		minLevel = 40,
		maxLevel = 75,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["sleet_ogre"] = {
		displayName = "Sleet ogre",
		mobs = {"sleet_ogre"},
		minLevel = 60,
		maxLevel = 95,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (20+) Arctic ogre bosses
	["slush_king"] = {
		displayName = "Slush king",
		mobs = {"slush_king"},
		minLevel = 25,
		maxLevel = 74,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["snow_king"] = {
		displayName = "Snow king",
		mobs = {"snow_king"},
		minLevel = 35,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = 14999,
		minMark = 0,
		maxMark = _maxMark
	},
	["sleet_king"] = {
		displayName = "Sleet king",
		mobs = {"sleet_king"},
		minLevel = 55,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = 59999,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (25+) Mythic caves
	["mythic_rabbit"] = {
		displayName = "Mythic rabbit",
		mobs = {
			"golden_hare",
			"mad_rabbit",
			"giant_hare",
			"golden_rabbit",
			"mad_hare",
			"giant_rabbit",
			"hop",
			"thump",
			"fluff"
		},
		minLevel = 25,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},
	["mythic_monkey"] = {
		displayName = "Mythic monkey",
		mobs = {
			"plain_monkey",
			"sly_monkey",
			"spry_monkey",
			"ugly_monkey",
			"simple_monkey",
			"quick_monkey",
			"agile_monkey",
			"monsterous_monkey",
			"bright_monkey",
			"fast_monkey",
			"spunky_monkey",
			"diamond_monkey"
		},
		minLevel = 32,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},
	["mythic_dog"] = {
		displayName = "Mythic dog",
		mobs = {
			"fierce_dog",
			"fighting_dog",
			"mad_dog",
			"pale_dog",
			"spotted_mutt",
			"frothing_mutt",
			"killer_mongrel",
			"wolf-kin",
			"dog_trooper",
			"crazed_mongrel",
			"spunky_dog",
			"death_mongrel"
		},
		minLevel = 39,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},
	["mythic_rooster"] = {
		displayName = "Mythic rooster",
		mobs = {
			"black_chick",
			"wild_chicken",
			"wild_rooster",
			"radiant_chick",
			"red_chick",
			"fiery_chick",
			"white_chicken",
			"white_rooster",
			"wild_chick",
			"black_chicken",
			"great_roost",
			"sunfeather"
		},
		minLevel = 46,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},

	-- (25+) Mythic bosses
	["rabbit_leader"] = {
		displayName = "Rabbit leader",
		mobs = {
			"mythic_hare",
			"hare_witch",
			"divine_rabbit",
			"rabbit_witch",
			"spirit_rabbit",
			"rabbit_avenger"
		},
		minLevel = 25,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["monkey_leader"] = {
		displayName = "Monkey leader",
		mobs = {
			"mythic_monkey",
			"monkey_mauler",
			"divine_monkey",
			"monkey_basher",
			"spirit_monkey",
			"monkey_avenger"
		},
		minLevel = 32,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["dog_leader"] = {
		displayName = "Dog leader",
		mobs = {
			"mythic_dog",
			"dog_assassin",
			"divine_dog",
			"dog_cutthroat",
			"spirit_dog",
			"dog_avenger"
		},
		minLevel = 36,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["rooster_leader"] = {
		displayName = "Rooster leader",
		mobs = {
			"mythic_rooster",
			"rooster_swordsman",
			"divine_rooster",
			"rooster_barbarian",
			"spirit_rooster",
			"rooster_avenger"
		},
		minLevel = 46,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (36) Haunted house
	["pale_zombie"] = {
		displayName = "Pale zombie",
		mobs = {"pale_zombie"},
		minLevel = 36,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = 14999,
		minMark = 0,
		maxMark = _maxMark
	},
	["lesser_ghost"] = {
		displayName = "Lesser ghost",
		mobs = {"lesser_ghost"},
		minLevel = 36,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = 14999,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (42) Kugnae spider/Buya scorpion
	["vile_scorpion"] = {
		displayName = "Vile scorpion",
		mobs = {"vile_scorpion"},
		minLevel = 50,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = 59999,
		minMark = 0,
		maxMark = _maxMark
	},
	["radiant_scorpion"] = {
		displayName = "Radiant scorpion",
		mobs = {"radiant_scorpion"},
		minLevel = 60,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["giant_scorpion"] = {
		displayName = "Giant scorpion",
		mobs = {"giant_scorpion"},
		minLevel = 50,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = 59999,
		minMark = 0,
		maxMark = _maxMark
	},
	["pale_scorpion"] = {
		displayName = "Pale scorpion",
		mobs = {"pale_scorpion"},
		minLevel = 60,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (49) Haunted house basement
	["lesser_skeleton"] = {
		displayName = "Lesser skeleton",
		mobs = {"lesser_skeleton"},
		minLevel = 50,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (50) Black skeleton
	["black_skeleton"] = {
		displayName = "Black skeleton",
		mobs = {"black_skeleton"},
		minLevel = 60,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},
	["skeleton_je"] = {
		displayName = "Skeleton Je",
		mobs = {"skeleton_je"},
		minLevel = 70,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 3
	},
	["skeleton_ja"] = {
		displayName = "Skeleton Ja",
		mobs = {"skeleton_ja"},
		minLevel = 80,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 4
	},
	["skeleton_ji"] = {
		displayName = "Skeleton Ji",
		mobs = {"skeleton_ji"},
		minLevel = 90,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (53+) Mythic caves
	["mythic_rat"] = {
		displayName = "Mythic rat",
		mobs = {
			"mythic_mouse",
			"vile_rat",
			"blood_rat",
			"killer_rat",
			"divine_mouse",
			"mud_rat",
			"hunter_rat",
			"lava_rat",
			"spirit_mouse",
			"earth_rat",
			"fire_rat",
			"beady_eyed_stalker"
		},
		minLevel = 53,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 3
	},
	["mythic_horse"] = {
		displayName = "Mythic horse",
		mobs = {
			"wild_horse",
			"skilled_horse",
			"elite_horse",
			"horse_guardsman",
			"spirited_horse",
			"horse_swordsman",
			"diamond_horse",
			"golden_horse",
			"wooden_horse",
			"lake_winny",
			"fire_snorter",
			"hooves"
		},
		minLevel = 60,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 3
	},
	["mythic_ox"] = {
		displayName = "Mythic ox",
		mobs = {
			"large_bull",
			"raging_bull",
			"charging_ox",
			"giant_bull",
			"rampaging_bull",
			"angry_ox",
			"great_horns",
			"pale_hunger",
			"tough_fight"
		},
		minLevel = 67,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 3
	},
	["mythic_pig"] = {
		displayName = "Mythic pig",
		mobs = {
			"stubborn_piglet",
			"stubborn_pig",
			"fat_pig",
			"stubborn_warthog",
			"stout_piglet",
			"stout_pig",
			"obese_pig",
			"stout_warthog",
			"bold_piglet",
			"bold_pig",
			"bold_hog",
			"bold_boar"
		},
		minLevel = 74,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 3
	},

	-- (63) Deep woods mantis
	["deep_woods_mantis"] = {
		displayName = "Deep woods mantis",
		mobs = {"deep_woods_mantis"},
		minLevel = 65,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 1
	},

	-- (63) Grim ogres
	["grim_ogre"] = {
		displayName = "Grim ogre",
		mobs = {"grim_ogre"},
		minLevel = 70,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 1
	},
	["southern_ogre"] = {
		displayName = "Southern ogre",
		mobs = {"southern_ogre"},
		minLevel = 90,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},

	-- (65+) Arctic ogres
	["hail_ogre"] = {
		displayName = "Hail ogre",
		mobs = {"hail_ogre"},
		minLevel = 80,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["flurry_ogre"] = {
		displayName = "Flurry ogre",
		mobs = {"flurry_ogre"},
		minLevel = 99,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["blizzard_ogre"] = {
		displayName = "Blizzard ogre",
		mobs = {"blizzard_ogre"},
		minLevel = 99,
		maxLevel = _maxLevel,
		minStat = 15000,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (81+) Mythic caves
	["mythic_snake"] = {
		displayName = "Mythic snake",
		mobs = {
			"plain_snake",
			"blood_snake",
			"radiant_snake",
			"fire_snake",
			"simple_snake",
			"lava_snake",
			"glowing_snake",
			"dark_snake",
			"meter_worm",
			"spasm",
			"slitherly",
			"storm_snake"
		},
		minLevel = 81,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["mythic_sheep"] = {
		displayName = "Mythic sheep",
		mobs = {
			"fierce_sheep",
			"ugly_sheep",
			"black_sheep",
			"red_sheep",
			"flaming_sheep",
			"dark_sheep"
		},
		minLevel = 88,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["mythic_tiger"] = {
		displayName = "Mythic tiger",
		mobs = {
			"restless_tiger",
			"golden_tiger",
			"dark_tiger",
			"giant_tiger",
			"raging_tiger",
			"black_tiger",
			"huge_tiger",
			"brazen",
			"knap",
			"crazy_claw"
		},
		minLevel = 95,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["mythic_dragon"] = {
		displayName = "Mythic dragon",
		mobs = {
			"drake",
			"dragon_hatchling",
			"young_dragon",
			"ancient_drake",
			"adolescent_dragon",
			"mature_dragon",
			"serpentine_dragon",
			"great_wyrm",
			"mighty_wyrm",
			"old_dragon"
		},
		minLevel = 99,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (84) Northern ogres
	["northern_ogre"] = {
		displayName = "Northern Ogre",
		mobs = {"northern_ogre"},
		minLevel = 85,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["frost_ogre"] = {
		displayName = "Frost Ogre",
		mobs = {"frost_ogre"},
		minLevel = 85,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (91) Dark/Ghost mantis
	["forest_mantis"] = {
		displayName = "Forest mantis",
		mobs = {"forest_mantis"},
		minLevel = 99,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["dark_mantis"] = {
		displayName = "Dark mantis",
		mobs = {"dark_mantis"},
		minLevel = 99,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["ghost_mantis"] = {
		displayName = "Ghost mantis",
		mobs = {"ghost_mantis"},
		minLevel = 99,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (91) Hill/Marsh ogre
	["hill_ogre"] = {
		displayName = "Hill ogre",
		mobs = {"hill_ogre"},
		minLevel = 99,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["marsh_ogre"] = {
		displayName = "Marsh ogre",
		mobs = {"marsh_ogre"},
		minLevel = 99,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	}
}

local _majorQuests = {
	-- (4) Rat cave
	["bat"] = {
		displayName = "Bat",
		mobs = {"bat", "big_bat"},
		minLevel = 1,
		maxLevel = 20,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (10) Kingdom animals
	["blood_wolf"] = {
		displayName = "Blood wolf",
		mobs = {"blood_wolf"},
		minLevel = 10,
		maxLevel = 41,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["black_buck"] = {
		displayName = "Black buck",
		mobs = {"black_buck"},
		minLevel = 10,
		maxLevel = 41,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (14) Kugnae snake cave
	["warthog"] = {
		displayName = "Warthog",
		mobs = {"warthog"},
		minLevel = 14,
		maxLevel = 35,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (20) Fox cave
	["albino_buck"] = {
		displayName = "Albino Buck",
		mobs = {"albino_buck"},
		minLevel = 20,
		maxLevel = 41,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["white_wolf"] = {
		displayName = "White wolf",
		mobs = {"white_wolf"},
		minLevel = 20,
		maxLevel = 41,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["lightning_wolf"] = {
		displayName = "Lightning wolf",
		mobs = {"lightning_wolf"},
		minLevel = 20,
		maxLevel = 41,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (36) Haunted house
	["wicked_ghost"] = {
		displayName = "Wicked ghost",
		mobs = {"wicked_ghost"},
		minLevel = 36,
		maxLevel = 62,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["witch_shaman"] = {
		displayName = "Witch shaman",
		mobs = {"witch_shaman"},
		minLevel = 36,
		maxLevel = 62,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (42) Kugnae spider/Buya scorpion
	["scorpion_lurker"] = {
		displayName = "Scorpion lurker",
		mobs = {"scorpion_lurker"},
		minLevel = 42,
		maxLevel = 83,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["trapdoor_spider"] = {
		displayName = "Trapdoor spider",
		mobs = {"trapdoor_spider"},
		minLevel = 42,
		maxLevel = 83,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["massive_scorpion"] = {
		displayName = "Massive scorpion",
		mobs = {"massive_scorpion"},
		minLevel = 42,
		maxLevel = 83,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (53+) Mythic bosses
	["rat_leader"] = {
		displayName = "Rat leader",
		mobs = {
			"mythic_rat",
			"mighty_mouse",
			"divine_rat",
			"rat_lord",
			"spirit_rat",
			"rat_avenger"
		},
		minLevel = 53,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["horse_leader"] = {
		displayName = "Horse leader",
		mobs = {
			"mythic_horse",
			"horse_do",
			"divine_horse",
			"horse_chongun",
			"spirit_horse",
			"horse_avenger"
		},
		minLevel = 60,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["ox_leader"] = {
		displayName = "Ox leader",
		mobs = {
			"mythic_ox",
			"ox_gorer",
			"divine_ox",
			"ox_charger",
			"spirit_ox",
			"ox_avenger"
		},
		minLevel = 67,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["pig_leader"] = {
		displayName = "Pig leader",
		mobs = {
			"mythic_boar",
			"boar_champion",
			"divine_pig",
			"pig_champion",
			"spirit_pig",
			"pig_avenger"
		},
		minLevel = 74,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (63) Deep wood mantis
	["shadow_mantis"] = {
		displayName = "Shadow mantis",
		mobs = {"shadow_mantis"},
		minLevel = 63,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},
	["dirt_mantis"] = {
		displayName = "Dirt mantis",
		mobs = {"dirt_mantis"},
		minLevel = 63,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},
	["sting"] = {
		displayName = "Sting",
		mobs = {"sting"},
		minLevel = 63,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxStat
	},

	-- (63) Grim ogres
	["slime_ogre"] = {
		displayName = "Slime ogre",
		mobs = {"slime_ogre"},
		minLevel = 63,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},
	["muck_ogre"] = {
		displayName = "Muck ogre",
		mobs = {"muck_ogre"},
		minLevel = 63,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},

	-- (65+) Arctic ogre bosses
	["hail_king"] = {
		displayName = "Hail king",
		mobs = {"hail_king"},
		minLevel = 65,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},
	["flurry_king"] = {
		displayName = "Flurry king",
		mobs = {"flurry_king"},
		minLevel = 80,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 3
	},
	["blizzard_king"] = {
		displayName = "Blizzard king",
		mobs = {"blizzard_king"},
		minLevel = 95,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (70) Lobster cave
	["golden_lobster"] = {
		displayName = "Golden lobster",
		mobs = {"golden_lobster"},
		minLevel = 70,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 2
	},

	-- (84) Northern ogres
	["ice_panther"] = {
		displayName = "Ice panther",
		mobs = {"ice_panther"},
		minLevel = 84,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxLevel
	},

	-- (91) Dark/Ghost mantis
	["chtan"] = {
		displayName = "Ch'tan",
		mobs = {"chtan"},
		minLevel = 91,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["sintu"] = {
		displayName = "Sin-tu",
		mobs = {"sintu"},
		minLevel = 91,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (91) Hill/Marsh ogres
	["zinte_ogre"] = {
		displayName = "Zin-te",
		mobs = {"zinte_ogre"},
		minLevel = 91,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["zangze_ogre"] = {
		displayName = "Zangze",
		mobs = {"zangze_ogre"},
		minLevel = 91,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- @TODO: (Il san+) Arctic ogres
	-- ["avalanche_ogre"] = {
	-- 	displayName = "Avalanche ogre",
	-- 	mobs = {"avalance_ogre"},
	-- 	minLevel = 0,
	-- 	maxLevel = _maxLevel,
	-- 	minStat = 0,
	-- 	maxStat = _maxStat,
	-- 	minMark = 1,
	-- 	maxMark = _maxMark
	-- },
	-- ["tempest_ogre"] = {
	-- 	displayName = "Tempest ogre",
	-- 	mobs = {"tempest_ogre"},
	-- 	minLevel = 0,
	-- 	maxLevel = _maxLevel,
	-- 	minStat = 0,
	-- 	maxStat = _maxStat,
	-- 	minMark = 3,
	-- 	maxMark = _maxMark
	-- },
	-- ["cyclone_ogre"] = {
	-- 	displayName = "Cyclone ogre",
	-- 	mobs = {"cyclone_ogre"},
	-- 	minLevel = 0,
	-- 	maxLevel = _maxLevel,
	-- 	minStat = 0,
	-- 	maxStat = _maxStat,
	-- 	minMark = 4,
	-- 	maxMark = _maxMark
	-- }
}

local _epicQuests = {
	-- (9) Rabbit cave
	["blood_mantis"] = {
		displayName = "Blood Mantis",
		mobs = {"blood_mantis"},
		minLevel = 9,
		maxLevel = 48,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 0
	},
	["giant_mantis"] = {
		displayName = "Giant Mantis",
		mobs = {"giant_mantis"},
		minLevel = 9,
		maxLevel = 48,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = 0
	},

	-- (20) Wilderness
	["golden_hare_wild"] = {
		displayName = "wild Golden hare",
		mobs = {"golden_hare_wild"},
		minLevel = 20,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (20) Fox cave
	["nine_tailed_fox"] = {
		displayName = "Nine-tailed fox",
		mobs = {"nine_tailed_fox"},
		minLevel = 20,
		maxLevel = 49,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (20) Iron lab
	["gimyi"] = {
		displayName = "Gim Yi",
		mobs = {"gimyi"},
		minLevel = 20,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (42) Spider/scorpion caves
	["crimson_scorpion"] = {
		displayName = "Crimson scorpion",
		mobs = {"crimson_scorpion"},
		minLevel = 42,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (49) Haunted House Basement
	["skeleton_mage"] = {
		displayName = "Skeleton mage",
		mobs = {"skeleton_mage"},
		minLevel = 49,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["skeleton_warrior"] = {
		displayName = "Skeleton warrior",
		mobs = {"skeleton_warrior"},
		minLevel = 49,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["skeleton_ju"] = {
		displayName = "Skeleton Ju",
		mobs = {"skeleton_ju"},
		minLevel = 49,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (50) Black Skeleton cave
	["skeleton_sa"] = {
		displayName = "Skeleton Sa",
		mobs = {"skeleton_sa"},
		minLevel = 50,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (63) Deep woods mantis
	["dark_mantis"] = {
		displayName = "Dark mantis",
		mobs = {"dark_mantis"},
		minLevel = 63,
		maxLevel = 90,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (63) Grim ogres
	["hill_ogre"] = {
		displayName = "Hill ogre",
		mobs = {"hill_ogre"},
		minLevel = 63,
		maxLevel = 90,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["log"] = {
		displayName = "Log",
		mobs = {"log"},
		minLevel = 63,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (80) Polar bear cave
	["deathwish"] = {
		displayName = "Deathwish",
		mobs = {"deathwish"},
		minLevel = 80,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (81) Mythic bosses
	["snake_leader"] = {
		displayName = "Snake leader",
		mobs = {
			"mythic_snake",
			"snake_shaman",
			"divine_snake",
			"snake_mage",
			"spirit_snake",
			"snake_avenger"
		},
		minLevel = 81,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["sheep_leader"] = {
		displayName = "Sheep leader",
		mobs = {
			"mythic_sheep",
			"sheep_veteran",
			"divine_sheep",
			"sheep_shepherd",
			"spirit_sheep",
			"sheep_avenger"
		},
		minLevel = 88,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["tiger_leader"] = {
		displayName = "Tiger leader",
		mobs = {
			"mythic_tiger",
			"tiger_warrior",
			"divine_tiger",
			"tiger_slasher",
			"spirit_tiger",
			"tiger_avenger"
		},
		minLevel = 95,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["dragon_leader"] = {
		displayName = "Dragon leader",
		mobs = {
			"mythic_dragon",
			"dragon_mage",
			"divine_dragon",
			"dragon_slayer",
			"spirit_dragon",
			"dragon_avenger"
		},
		minLevel = 99,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- (84) Northern ogres
	["maletic"] = {
		displayName = "Maletic",
		mobs = {"ogre_maletic"},
		minLevel = 84,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},
	["citelam"] = {
		displayName = "Citelam",
		mobs = {"ogre_citelam"},
		minLevel = 84,
		maxLevel = _maxLevel,
		minStat = 0,
		maxStat = _maxStat,
		minMark = 0,
		maxMark = _maxMark
	},

	-- @TODO: (Il san+) Arctic ogres
	-- ["avalanche_king"] = {
	-- 	displayName = "Avalanche King",
	-- 	mobs = {"avalanche_king"},
	-- 	minLevel = 0,
	-- 	maxLevel = _maxLevel,
	-- 	minStat = 0,
	-- 	maxStat = _maxStat,
	-- 	minMark = 1,
	--	maxMark = _maxMark
	-- },
	-- ["tempest_king"] = {
	-- 	displayName = "Tempest king",
	-- 	mobs = {"tempest_king"},
	-- 	minLevel = 0,
	-- 	maxLevel = _maxLevel,
	-- 	minStat = 0,
	-- 	maxStat = _maxStat,
	-- 	minMark = 3,
	--	maxMark = _maxMark
	-- },
	-- ["cyclone_king"] = {
	-- 	displayName = "Cyclone king",
	-- 	mobs = {"cyclone_king"},
	-- 	minLevel = 0,
	-- 	maxLevel = _maxLevel,
	-- 	minStat = 0,
	-- 	maxStat = _maxStat,
	-- 	minMark = 4,
	--	maxMark = _maxMark
	-- }
}

local _questTiers = {
	{label = "Minor", quests = _minorQuests, expFactor = 0.6, karmaChance = 1, abandonHours = 2},
	{label = "Major", quests = _majorQuests, expFactor = 0.8, karmaChance = 2, abandonHours = 10},
	{label = "Epic", quests = _epicQuests, expFactor = 1, karmaChance = 3, abandonHours = 21},
}

local _clearMinorQuest = function(player, activeQuest, activeTier, abandoned)
	local mobs = activeQuest.mobs

	for i = 1, #mobs do
		local mob = mobs[i]
		player.registry[_minorQuestKillCount .. mob] = 0
	end

	player.registryString[_minorQuest] = ""
	player.registry[_minorQuestTier] = 0
	player:removeLegendbyName(_minorQuestInfo)

	if (abandoned) then
		player.registry[_minorQuestTimer] = os.time() + _questTiers[activeTier].abandonHours * 3600
		player:dialogSeq({"So be it."}, 1)
		return
	end

	local completeCount = player.registry[_minorQuestsCompleted] + 1

	player.registry[_minorQuestsCompleted] = completeCount
	player:removeLegendbyName(_minorQuestsCompleted)
	player:addLegend("Completed " .. completeCount .. " minor quests", _minorQuestsCompleted, 5, 128)
	player:forceSave()
end

local _getActiveQuest = function(player, activeTier)
	local activeQuestKey = player.registryString[_minorQuest]
	local activeQuestTier = _questTiers[activeTier]
	return activeQuestTier.quests[activeQuestKey]
end

local _showAbandonMenu = function(player, activeTier)
	local activeQuest = _getActiveQuest(player, activeTier)
	local abandonHours = _questTiers[activeTier].abandonHours

	local choice = player:menuSeq(
		"You are already on a quest to slay one " .. activeQuest.displayName .. ". Abandoning your quest will prevent you from beginning a new quest for " .. abandonHours .. " hours.",
		{"Continue", "Abandon"},
		{}
	)

	if (choice == 1) then
		player:dialogSeq({_sayCompleteWhenDone}, 1)
		return
	end

	_clearMinorQuest(player, activeQuest, activeTier, true)
end

local _awardBonuses = function(player, activeTier)
	local questTier = _questTiers[activeTier]
	local expFactor = questTier.expFactor
	local karmaChance = questTier.karmaChance

	if (player.level < 99) then
		local totalExpForNextLevel = getXPforLevel(player.baseClass, player.level)
		local totalExpForCurrentLevel = getXPforLevel(player.baseClass, player.level - 1)
		local tnl = totalExpForNextLevel - totalExpForCurrentLevel

		local expBonus = math.ceil(tnl * 0.20 * expFactor)
		expBonus = math.max(expBonus, 300)

		player:giveXP(expBonus)
	else
		local expBonus = ExpSellerNpc.getVitaCost(player.baseHealth)
		expBonus = expBonus + ExpSellerNpc.getVitaCost(player.baseHealth + 100)
		expBonus = expBonus + ExpSellerNpc.getManaCost(player.baseMagic)
		expBonus = expBonus + ExpSellerNpc.getManaCost(player.baseMagic + 50)
		expBonus = math.ceil(expBonus * expFactor)
		expBonus = math.min(expBonus, 276000000)

		player:giveXP(expBonus)
	end

	local dialog = "Thank you for your efforts! You have served your path and kingdom well."
	local rand = math.random(15)

	if (rand <= karmaChance) then
		player:addKarma(0.1)
		dialog = dialog .. " For your continued good deeds, doubtless your karma has risen slightly."
	end

	player:dialogSeq({dialog}, 0)
end

MinorQuest = {
	quest = function(player, npc)
		Tools.configureDialog(player, npc)
		local minorQuestTimer = player.registry[_minorQuestTimer]

		if (os.time() < minorQuestTimer) then
			local hoursRemaining = math.ceil((minorQuestTimer - os.time()) / 3600)
			local dialog = "You must wait " .. hoursRemaining .. " hour"

			if (hoursRemaining > 1) then
				dialog = dialog .. "s"
			end

			player:dialogSeq({dialog .. " before beginning another quest."}, 0)
			return
		end

		if (player.registryString[_minorQuest] ~= "") then
			local activeTier = player.registry[_minorQuestTier]
			_showAbandonMenu(player, activeTier)
			return
		end

		local activeTier = 1

		if (player.level >= 10) then
			local questLabels = {
				_questTiers[1].label,
				_questTiers[2].label
			}

			if (player.level >= 15) then
				table.insert(questLabels, _questTiers[3].label)
			end

			activeTier = player:menuSeq("Which type of quest do you seek?", questLabels, {})
		end

		local availableQuests = _questTiers[activeTier].quests
		local currentLevel = player.level
		local currentStats = player.baseMagic * 2 + player.baseHealth
		local currentMark = player.mark
		local qualifyingQuests = {}

		for k, v in pairs(availableQuests) do
			local minLevel = v.minLevel
			local maxLevel = v.maxLevel
			local minStat = v.minStat
			local maxStat = v.maxStat
			local minMark = v.minMark
			local maxMark = v.maxMark

			if (Tools.isBetween(currentLevel, minLevel, maxLevel) and
				Tools.isBetween(currentStats, minStat, maxStat) and
				Tools.isBetween(currentMark, minMark, maxMark)) then

				table.insert(qualifyingQuests, {key = k, value = v})
			end
		end

		if (#qualifyingQuests < 1) then
			player:dialogSeq({"I have no such quest for you right now. Please choose another."}, 0)
			-- @TODO: Log this since it's not ever supposed to happen
			return
		end

		local activeQuest = qualifyingQuests[math.random(#qualifyingQuests)]
		local key = activeQuest.key
		local mobs = activeQuest.value.mobs
		local displayName = activeQuest.value.displayName

		for i = 1, #mobs do
			local mob = mobs[i]
			player.registry[_minorQuestKillCount .. mob] = player:killCount(mob)
		end

		player.registryString[_minorQuest] = key
		player.registry[_minorQuestTier] = activeTier

		if (player:hasLegend(_minorQuestInfo)) then
			player:removeLegendbyName(_minorQuestInfo)
		end

		player:addLegend("On a quest to slay the " .. displayName, _minorQuestInfo, 5, 128)
		player:forceSave()

		player:dialogSeq(
			{
				"Alas, it has come to my attention that a curse has been laid upon one of your fellow citizens.",
				"You must slay one " .. displayName .. " to release the curse. I will reward you if you can accomplish this task.",
				_sayCompleteWhenDone
			},
			0
		)
	end,

	complete = function(player, npc)
		Tools.configureDialog(player, npc)

		if (player.registryString[_minorQuest] == "") then
			player:dialogSeq({"You must begin a quest before you can complete it."}, 0)
			return
		end

		local activeTier = player.registry[_minorQuestTier]
		local activeQuest = _getActiveQuest(player, activeTier)
		local mobs = activeQuest.mobs
		local isKillRequirementMet = false

		for i = 1, #mobs do
			local mob = mobs[i]
			local startingKillCount = player.registry[_minorQuestKillCount .. mob]
			local currentKillCount = player:killCount(mob)

			if (currentKillCount > startingKillCount) then
				isKillRequirementMet = true
				break
			end
		end

		if (not isKillRequirementMet) then
			player:dialogSeq({"Please return when you have slain one " .. activeQuest.displayName .. "."}, 0)
			return
		end

		_clearMinorQuest(player, activeQuest, activeTier, false)
		_awardBonuses(player, activeTier)
	end
}
