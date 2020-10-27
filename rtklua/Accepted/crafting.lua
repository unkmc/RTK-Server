crafting = {
	skillChanceIncrease = function(player, npc, skill)
		-- gathering: woodcutting, mining, fishing
		-- refining: gemcutting, weaving, smelting
		-- manufacturing: woodworking, metalworking, jewelry making, tailoring
		-- cartography

		if skill == "weaving" or skill == "gemcutting" or skill == "smelting" then
			-- refining skills

			local hasSpecialization = crafting.checkSpecializationLegend(
				player,
				skill
			)
			local isAccomplished = crafting.checkSkillLevel(
				player,
				skill,
				"accomplished"
			)

			if not hasSpecialization and isAccomplished then
				-- if missing legend mark AND at the level of accomplished or better
				player:sendMinitext("To advance further, you must specialize in " .. skill)
				return
			end
		end

		if skill == "woodworking" or skill == "jewelry making" or skill == "metalworking" or skill == "tailoring" then
			local hasLegend = crafting.checkSkillLegend(player, skill)
			if not hasLegend then
				player:sendMinitext("You do not posses knowledge in " .. skill)
				return
			end
		end

		if ((skill == "scribing" or skill == "potion making") and player.baseClass ~= 3 and player.baseClass ~= 4) then
			-- this stops melee class from doing
			player:sendMinitext("Advancement in this craft requires that you are a Caster.")
			return
		end

		crafting.addPoints(player, npc, skill, 1)

		if skill ~= "cartography" then
			if player:hasDuration("crafting_bonus") then
				crafting.addPoints(player, npc, skill, 1)
			end

			if (player:isTotemTime() or Config.craftingBonusAlwaysEnabled) then
				if math.random(1, 25) == 1 then
					crafting.addPoints(player, npc, skill, 1)
				end
			end
		end
	end,

	getSkillValue = function(player, skill)
		local skillPointLevels = crafting.skillPointsPerLevel(skill)
		local earnedSkillPoints = player.registry[skill]
		local skillValue = 0

		for i = 1, #skillPointLevels do
			if earnedSkillPoints >= skillPointLevels[i] then
				skillValue = i
			end
		end

		return skillValue
	end,

	checkSkillLevel = function(player, skill, level)
		local level = string.lower(level)
		local skillPointLevels = crafting.skillPointsPerLevel(skill)
		local earnedSkillPoints = player.registry[skill]
		local NOVICE = skillPointLevels[1]
		local APPRENTICE = skillPointLevels[2]
		local ACCOMPLISHED = skillPointLevels[3]
		local ADEPT = skillPointLevels[4]
		local TALENTED = skillPointLevels[5]
		local SKILLED = skillPointLevels[6]
		local EXPERT = skillPointLevels[7]
		local MASTER = skillPointLevels[8]
		local GRANDMASTER = skillPointLevels[9]
		local CHAMPION = skillPointLevels[10]
		local LEGENDARY = skillPointLevels[11]

		if (level == "novice" and earnedSkillPoints >= NOVICE) then
			return true
		elseif (level == "apprentice" and earnedSkillPoints >= APPRENTICE) then
			return true
		elseif (level == "accomplished" and earnedSkillPoints >= ACCOMPLISHED) then
			return true
		elseif (level == "adept" and earnedSkillPoints >= ADEPT) then
			return true
		elseif (level == "talented" and earnedSkillPoints >= TALENTED) then
			return true
		elseif (level == "skilled" and earnedSkillPoints >= SKILLED) then
			return true
		elseif (level == "expert" and earnedSkillPoints >= EXPERT) then
			return true
		elseif (level == "master" and earnedSkillPoints >= MASTER) then
			return true
		elseif (level == "grandmaster" and earnedSkillPoints >= GRANDMASTER) then
			return true
		elseif (level == "champion" and earnedSkillPoints >= CHAMPION) then
			return true
		elseif (level == "legendary" and earnedSkillPoints >= LEGENDARY) then
			return true
		else
			return false
		end
	end,

	getSkillLevel = function(player, skill)
		local skillPointLevels = crafting.skillPointsPerLevel(skill)
		local earnedSkillPoints = player.registry[skill]

		local NOVICE = skillPointLevels[1]
		local APPRENTICE = skillPointLevels[2]
		local ACCOMPLISHED = skillPointLevels[3]
		local ADEPT = skillPointLevels[4]
		local TALENTED = skillPointLevels[5]
		local SKILLED = skillPointLevels[6]
		local EXPERT = skillPointLevels[7]
		local MASTER = skillPointLevels[8]
		local GRANDMASTER = skillPointLevels[9]
		local CHAMPION = skillPointLevels[10]
		local LEGENDARY = skillPointLevels[11]

		if (earnedSkillPoints >= NOVICE and earnedSkillPoints < APPRENTICE) then
			return "novice"
		elseif (earnedSkillPoints >= APPRENTICE and earnedSkillPoints < ACCOMPLISHED) then
			return "apprentice"
		elseif (earnedSkillPoints >= ACCOMPLISHED and earnedSkillPoints < ADEPT) then
			return "accomplished"
		elseif (earnedSkillPoints >= ADEPT and earnedSkillPoints < TALENTED) then
			return "adept"
		elseif (earnedSkillPoints >= TALENTED and earnedSkillPoints < SKILLED) then
			return "talented"
		elseif (earnedSkillPoints >= SKILLED and earnedSkillPoints < EXPERT) then
			return "skilled"
		elseif (earnedSkillPoints >= EXPERT and earnedSkillPoints < MASTER) then
			return "expert"
		elseif (earnedSkillPoints >= MASTER and earnedSkillPoints < GRANDMASTER) then
			return "master"
		elseif (earnedSkillPoints >= GRANDMASTER and earnedSkillPoints < CHAMPION) then
			return "grandmaster"
		elseif (earnedSkillPoints >= CHAMPION and earnedSkillPoints < LEGENDARY) then
			return "champion"
		elseif (earnedSkillPoints >= LEGENDARY) then
			return "legendary"
		else
			return
		end
	end,

	skillPointsPerLevel = function(skill)
		--NOVICE          0 (0)
		--APPRENTICE      5 (5)
		--ACCOMPLISHED   13 (8)
		--ADEPT          28 (15)
		--TALENTED       46 (18)
		--SKILLED        78 (32)
		--EXPERT        114 (42)
		--MASTER		186 (72)
		--GRANDMASTER   362 (176)
		--CHAMPION      562 (200)
		--LEGENDARY     862 (300)

		local skillPointLevels = {}

		if skill == "woodcutting" then
			skillPointLevels = {
				0,
				95,
				1040,
				2589,
				6292,
				15977,
				30197,
				47257,
				69724,
				97613,
				146419
			}
		elseif skill == "mining" then
			skillPointLevels = {
				0,
				95,
				1040,
				2589,
				6292,
				15977,
				30197,
				47257,
				69724,
				97613,
				146420
			}

			--skillPointLevels = {0,632,4700,11511,22836,48151,75466,110636,10000000,20000000,40000000} NTK numbers
		elseif skill == "woodworking" then
			-- carpentry
			skillPointLevels = {
				0,
				150,
				950,
				2250,
				4750,
				11450,
				24150,
				38150,
				56288,
				78802,
				118203
			}
		elseif skill == "weaving" then
			-- weaving
			skillPointLevels = {
				0,
				100,
				600,
				3100,
				7400,
				14040,
				26740,
				44500,
				65656,
				91919,
				137877
			}
		elseif skill == "tailoring" then
			-- tailoring
			skillPointLevels = {
				0,
				330,
				1730,
				3910,
				7960,
				17860,
				31860,
				48860,
				72089,
				100924,
				151386
			}
		elseif skill == "gemcutting" then
			-- gemcutting
			skillPointLevels = {
				0,
				16,
				76,
				386,
				1886,
				3720,
				8487,
				17269,
				25479,
				65671,
				153506
			}
		elseif skill == "fishing" then
			skillPointLevels = {
				0,
				150,
				1000,
				2120,
				5250,
				11220,
				19302,
				30200,
				44558,
				62381,
				93571
			}
		elseif skill == "farming" then
			-- farming
			skillPointLevels = {
				0,
				56,
				430,
				1291,
				3760,
				8620,
				14008,
				22654,
				33424,
				46794,
				70190
			}
		elseif skill == "chef" then
			-- chef
			skillPointLevels = {
				5,
				16,
				41,
				111,
				266,
				638,
				1526,
				3831,
				5652,
				7913,
				11870
			}
		elseif skill == "food preparation" then
			-- food prep
			skillPointLevels = {
				100,
				400,
				1100,
				2770,
				6682,
				14042,
				30682,
				76052,
				112209,
				157092,
				195637
			}
		elseif skill == "smelting" then
			-- smelting
			skillPointLevels = {
				0,
				90,
				731,
				3099,
				7433,
				17837,
				30490,
				50911,
				75115,
				105161,
				157741
			}
		elseif skill == "scribing" then
			-- scribing
			skillPointLevels = {
				0,
				65,
				615,
				1663,
				3877,
				9063,
				15226,
				22956,
				33870,
				47418,
				71126
			}
		elseif skill == "potion making" then
			-- alchemy
			skillPointLevels = {
				0,
				65,
				615,
				1663,
				3877,
				9063,
				15226,
				22956,
				33870,
				47418,
				71126
			}
		elseif skill == "metalworking" then
			-- smithing
			skillPointLevels = {
				0,
				100,
				320,
				2040,
				4800,
				10560,
				18440,
				30940,
				45650,
				63909,
				95863
			}
		elseif skill == "jewelry making" then
			-- jeweling
			skillPointLevels = {
				0,
				500,
				1500,
				4500,
				8000,
				18500,
				33000,
				47000,
				74000,
				102000,
				160000
			}
		elseif skill == "cartography" then
			skillPointLevels = {
				0,
				5,
				10,
				25,
				50,
				100,
				500,
				1000,
				1750,
				2750,
				4000
			}
		else
			skillPointLevels = {0, 5, 15, 31, 49, 86, 118, 192, 382, 591, 912}
		end

		return skillPointLevels
	end,

	addPoints = function(player, npc, skill, pts)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local oldSkillLevel = crafting.getSkillLevel(player, skill)

		player.registry[skill] = player.registry[skill] + pts

		local skillPointLevels = crafting.skillPointsPerLevel(skill)
		local earnedSkillPoints = player.registry[skill]

		if earnedSkillPoints == 1 then
			-- this shows up initially as soon as player acquires a point into it either from npc or actually performing (ie. fishing, gathering, other skills that you don't learn at npc)
			player:sendMinitext("You gained " .. skill .. " skill")
		end

		if math.random(1, 10) == 1 then
			player:sendMinitext("Your " .. skill .. " skill increases.")
		end

		crafting.updateSkill(player, skill)

		-- legend bump

		if oldSkillLevel ~= crafting.getSkillLevel(player, skill) then
			player:dialogSeq(
				{
					t,
					"Your " .. skill .. " skills are growing, you are now of " .. crafting.getSkillLevel(
						player,
						skill
					) .. " skill."
				},
				0
			)
		end
	end,

	addMentalSkill = function(player, npc, skill)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if (player.level < 50) then
			player:dialogSeq(
				{
					t,
					"You are not ready to devote to a craft yet, come back later."
				},
				0
			)
			return
		end

		local trade = ""

		if skill == "potion making" then
			trade = "alchemist"
		elseif skill == "scribing" then
			trade = "scribe"
		end

		local cost = 1000
		local icon

		player:dialogSeq(
			{
				t,
				"Know this: you can only know one mental craft at a time. If later you decide to abandon " .. skill .. " for another mental craft all of your " .. skill .. " ability will be lost, even if you return to " .. skill .. "."
			},
			1
		)

		local choice = player:menuSeq(
			"For " .. cost .. " gold, I will teach you the very basics of " .. skill .. ".",
			{"Teach me.", "I'm not sure I want to be a " .. trade .. "."},
			{}
		)

		if choice == 1 then
			if player.money < cost then
				player:dialogSeq(
					{t, "You need to get " .. cost .. " gold first."},
					0
				)
				return
			end

			player:removeGold(cost)

			crafting.addPoints(player, npc, skill, 1)
			crafting.updateSkill(player, skill)

			player:dialogSeq(
				{t, "It is done, welcome to the world of " .. skill .. "."},
				1
			)
		elseif choice == 2 then
			return
		end
	end,

	checkMentalSkill = function(player, npc, skill)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if crafting.checkSkillLegend(player, skill) == true then
			player:dialogSeq(
				{
					t,
					"You have already chosen a skill of this type, " .. skill .. ". If you abandon it, you will FOREVER lose ALL skill that craft. Even if you return to it at a later time."
				},
				1
			)

			local choice = player:menuSeq(
				"Are you absolutely certain you want to abandon your trade?",
				{"Yes, I'm entirely certain.", "I'm not sure."},
				{}
			)

			if choice == 1 then
				local confirm = player:menuSeq(
					"This is your last chance to turn back! Do you REALLY want to do this?",
					{"Yes.", "No."},
					{}
				)

				if confirm == 1 then
					crafting.removeSkill(player, skill)
					player:dialogSeq({t, "It is done."}, 0)
				elseif confirm == 2 then
					return
				end
			elseif choice == 2 then
				return
			end
			return
		end
	end,

	updateSkill = function(player, skill)
		-- used solely to add remove legend marks of skills while leveling them

		local icon
		local specicon
		local levels = {
			"novice",
			"apprentice",
			"accomplished",
			"adept",
			"talented",
			"skilled",
			"expert",
			"master",
			"grandmaster",
			"champion",
			"legendary"
		}
		local newLevel = crafting.getSkillLevel(player, skill)

		if newLevel == "" or newLevel == nil then
			return
		end

		local newLevelName = newLevel:gsub("^%l", string.upper)
		if newLevelName == "Grandmaster" then
			newLevelName = "Grand master"
		end

		if skill == "woodworking" then
			trade = "carpenter"
			icon = 66
		elseif skill == "metalworking" then
			trade = "smith"
			icon = 92
		elseif skill == "jewelry making" then
			trade = "jeweler"
			icon = 109
		elseif skill == "tailoring" then
			trade = "tailor"
			icon = 63
		elseif skill == "fishing" then
			trade = "fisherman"
			icon = 5
		elseif skill == "weaving" then
			trade = "weaver"
			icon = 64
		elseif skill == "smelting" then
			trade = "smelter"
			icon = 76
		elseif skill == "gemcutting" then
			trade = "gemcutter"
			icon = 36
		elseif skill == "woodcutting" then
			trade = "woodcutter"
			icon = 41
		elseif skill == "mining" then
			trade = "miner"
			icon = 93
		elseif skill == "farming" then
			trade = "farmer"
			icon = 31
		elseif skill == "food preparation" then
			trade = "food preparer"
			icon = 46
		elseif skill == "chef" then
			trade = "chef"
			icon = 97
		elseif skill == "potion making" then
			trade = "alchemist"
			icon = 82
		elseif skill == "scribing" then
			trade = "scribe"
			icon = 86
		elseif skill == "cartography" then
			trade = "cartographer"
			icon = 151
		end

		for i = 1, #levels do
			player:removeLegendbyName(levels[i] .. "_" .. trade)
		end

		if newLevelName == "Grand master" and player.registry["cft_gm_" .. trade] ~= 1 then
			player.registry["cft_gm_" .. trade] = 1
			broadcast(
				-1,
				"[CRAFTING]: Congratulations to our newest GRAND MASTER " .. trade .. " " .. player.name .. "!"
			)
		end
		if newLevelName == "Champion" and player.registry["cft_champion_" .. trade] ~= 1 then
			player.registry["cft_champion_" .. trade] = 1
			broadcast(
				-1,
				"[CRAFTING]: Congratulations to our newest CHAMPION " .. trade .. " " .. player.name .. "!"
			)
		end
		if newLevelName == "Legendary" and player.registry["cft_legendary_" .. trade] ~= 1 then
			player.registry["cft_legendary_" .. trade] = 1
			broadcast(
				-1,
				"[CRAFTING]: Congratulations to our newest LEGENDARY " .. trade .. " " .. player.name .. "!"
			)
		end
		player:removeLegendbyName("recently_specialized_" .. trade)
		player:addLegend(
			newLevelName .. " " .. trade,
			newLevel .. "_" .. trade,
			icon,
			128
		)
	end,

	checkSkillLegend = function(player, skill)
		local trade = ""
		if skill == "woodworking" then
			trade = "carpenter"
		elseif skill == "metalworking" then
			trade = "smith"
		elseif skill == "jewelry making" then
			trade = "jeweler"
		elseif skill == "tailoring" then
			trade = "tailor"
		elseif skill == "fishing" then
			trade = "fisherman"
		elseif skill == "weaving" then
			trade = "weaver"
		elseif skill == "smelting" then
			trade = "smelter"
		elseif skill == "gemcutting" then
			trade = "gemcutter"
		elseif skill == "woodcutting" then
			trade = "woodcutter"
		elseif skill == "mining" then
			trade = "miner"
		elseif skill == "farming" then
			trade = "farmer"
		elseif skill == "food preparation" then
			trade = "food preparer"
		elseif skill == "chef" then
			trade = "chef"
		elseif skill == "potion making" then
			trade = "alchemist"
		elseif skill == "scribing" then
			trade = "scribe"
		elseif skill == "cartography" then
			trade = "cartographer"
		end

		local hasLegend = false

		local levels = {
			"novice",
			"apprentice",
			"accomplished",
			"adept",
			"talented",
			"skilled",
			"expert",
			"master",
			"grandmaster",
			"champion",
			"legendary"
		}

		for i = 1, #levels do
			if player:hasLegend(levels[i] .. "_" .. trade) then
				hasLegend = true
			end
		end

		return hasLegend
	end,

	checkSkill = function(player, npc, skill)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if crafting.checkSkillLegend(player, skill) == true then
			player:dialogSeq(
				{
					t,
					"You have already chosen a skill. If you abandon it, you will FOREVER lose ALL skill that craft. Even if you return to it at a later time."
				},
				1
			)

			local choice = player:menuSeq(
				"Are you absolutely certain you want to abandon your " .. skill .. " trade?",
				{"Yes, I'm entirely certain.", "I'm not sure."},
				{}
			)

			if choice == 1 then
				player:dialogSeq(
					{
						t,
						"If you continue, you will loose your " .. skill .. " skill."
					},
					1
				)

				local confirm = player:menuSeq(
					"This is your last chance to turn back! Do you REALLY want to do this, and remove your " .. skill .. " skill?",
					{"Yes.", "No."},
					{}
				)

				if confirm == 1 then
					crafting.removeSkill(player, skill)
					player:dialogSeq(
						{t, "You no longer have the skill of " .. skill},
						0
					)
				elseif confirm == 2 then
					return
				end
			elseif choice == 2 then
				return
			end
			return
		end
	end,

	addSkill = function(player, npc, skill)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if (player.level < 50) then
			player:dialogSeq(
				{
					t,
					"You are not ready to devote to a craft yet, come back later."
				},
				0
			)
			return
		end

		local trade = ""

		if skill == "woodworking" then
			trade = "carpenter"
		elseif skill == "metalworking" then
			trade = "smith"
		elseif skill == "jewelry making" then
			trade = "jeweler"
		elseif skill == "tailoring" then
			trade = "tailor"
		elseif skill == "fishing" then
			trade = "fisherman"
		elseif skill == "weaving" then
			trade = "weaver"
		elseif skill == "smelting" then
			trade = "smelter"
		elseif skill == "gemcutting" then
			trade = "gemcutter"
		elseif skill == "woodcutting" then
			trade = "woodcutter"
		elseif skill == "mining" then
			trade = "miner"
		elseif skill == "farming" then
			trade = "farmer"
		elseif skill == "food preparation" then
			trade = "food preparer"
		elseif skill == "chef" then
			trade = "chef"
		elseif skill == "potion making" then
			trade = "alchemist"
		elseif skill == "scribing" then
			trade = "scribe"
		elseif skill == "cartography" then
			trade = "cartographer"
		end

		local cost = 1000
		local icon

		player:dialogSeq(
			{
				t,
				"Know this: you can only know one advanced craft at a time. If later you decide to abandon " .. skill .. " for another advanced craft all of your " .. skill .. " ability will be lost, even if you return to " .. skill .. "."
			},
			1
		)

		local choice = player:menuSeq(
			"For " .. cost .. " gold, I will teach you the very basics of " .. skill .. ".",
			{"Teach me.", "I'm not sure I want to be a " .. trade .. "."},
			{}
		)

		if choice == 1 then
			if player.money < cost then
				player:dialogSeq(
					{t, "You need to get " .. cost .. " gold first."},
					0
				)
				return
			end

			player:removeGold(cost)

			crafting.addPoints(player, npc, skill, 1)
			crafting.updateSkill(player, skill)

			player:dialogSeq(
				{t, "It is done, welcome to the world of " .. skill .. "."},
				1
			)
		elseif choice == 2 then
			return
		end
	end,

	removeSkill = function(player, skill)
		local levels = {
			"novice",
			"apprentice",
			"accomplished",
			"adept",
			"talented",
			"skilled",
			"expert",
			"master",
			"grandmaster",
			"champion",
			"legendary"
		}

		local trade = ""

		if skill == "woodworking" then
			trade = "carpenter"
		elseif skill == "metalworking" then
			trade = "smith"
		elseif skill == "jewelry making" then
			trade = "jeweler"
		elseif skill == "tailoring" then
			trade = "tailor"
		elseif skill == "fishing" then
			trade = "fisherman"
		elseif skill == "weaving" then
			trade = "weaver"
		elseif skill == "smelting" then
			trade = "smelter"
		elseif skill == "gemcutting" then
			trade = "gemcutter"
		elseif skill == "woodcutting" then
			trade = "woodcutter"
		elseif skill == "mining" then
			trade = "miner"
		elseif skill == "farming" then
			trade = "farmer"
		elseif skill == "food preparation" then
			trade = "food preparer"
		elseif skill == "chef" then
			trade = "chef"
		elseif skill == "potion making" then
			trade = "alchemist"
		elseif skill == "scribing" then
			trade = "scribe"
		elseif skill == "cartography" then
			trade = "cartographer"
		end

		for i = 1, #levels do
			player:removeLegendbyName(levels[i] .. "_" .. trade)
		end

		player.registry[skill] = 0
	end,

	checkSpecializationLegend = function(player, skill)
		local hasLegend = false

		if player:hasLegend("specialized_in_" .. skill) then
			hasLegend = true
		end

		return hasLegend
	end,

	removeSpecialization = function(player, skill)
		local trade = ""

		if skill == "weaving" then
			trade = "weaver"
		elseif skill == "smelting" then
			trade = "smelter"
		elseif skill == "gemcutting" then
			trade = "gemcutter"
		end

		player.registry[skill] = 0
		player:removeLegendbyName("specialized_in_" .. skill)
		player:removeLegendbyName("recently_specialized_" .. trade)
	end,

	checkSpecialization = function(player, npc, skill)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if crafting.checkSpecializationLegend(player, skill) == true then
			player:dialogSeq(
				{
					t,
					"You have already specialized in " .. skill .. ", another manufacturing skill. If you abandon it, you will lose ALL skill in that craft. Even if you return to it at a later time, you will have to begin anew."
				},
				1
			)

			local choice = player:menuSeq(
				"Are you absolutely certain you want to abandon your " .. skill .. " trade?",
				{"Yes, I'm entirely certain.", "I'm not sure."},
				{}
			)

			if choice == 1 then
				player:dialogSeq(
					{
						t,
						"If you continue, you will loose your " .. skill .. " skill."
					},
					1
				)

				local confirm = player:menuSeq(
					"This is your last chance to turn back! Do you REALLY want to do this?",
					{"Yes.", "No."},
					{}
				)

				if confirm == 1 then
					crafting.removeSpecialization(player, skill)
					player:dialogSeq({t, "It is done."}, 0)
				elseif confirm == 2 then
					return
				end
			elseif choice == 2 then
				return
			end
			return
		end
	end,

	addSpecialization = function(player, npc, skill)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if (player.level < 25) then
			player:dialogSeq(
				{
					t,
					"You are not ready to specialize in a craft yet, come back later."
				},
				0
			)
			return
		end

		local trade = ""
		local cost = 500
		local icon
		local specicon

		if skill == "weaving" then
			trade = "weaver"
			icon = 7
			specicon = 64
		elseif skill == "smelting" then
			trade = "smelter"
			icon = 7
			specicon = 76
		elseif skill == "gemcutting" then
			trade = "gemcutter"
			icon = 7
			specicon = 36
		end

		local skillName = skill:gsub("^%l", string.upper)

		player:dialogSeq(
			{
				t,
				"You can only specialize in one manufacturing craft at a time. If you change your mind later, you will lose all of the skill you worked for in that craft.",
				"For a mere " .. cost .. " gold, I will help you specialize in " .. skillName .. "."
			},
			1
		)

		local choice = player:menuSeq(
			"Are you willing to pay " .. cost .. " gold?",
			{"Yes, I wish to become a " .. trade .. ".", "No thanks."},
			{}
		)

		if choice == 1 then
			if player.money < cost then
				player:dialogSeq(
					{t, "You need to get " .. cost .. " gold first."},
					0
				)
				return
			end

			player:removeGold(cost)

			player:addLegend(
				"Specialized in " .. skillName,
				"specialized_in_" .. skill,
				icon,
				128
			)
			player:addLegend(
				"Recently specialized " .. trade,
				"recently_specialized_" .. trade,
				specicon,
				128
			)

			player:dialogSeq(
				{t, "It is done, welcome to the world of " .. skillName .. "."},
				1
			)
		elseif choice == 2 then
			return
		end
	end,

	craftingDialog = function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local skill = ""
		if speech == "wood" or speech == "scraps" then
			if not crafting.checkSkillLegend(player, "woodworking") then
				return
			end
			woodworking.craft(player, npc, speech)
		elseif speech == "weave" then
			if not crafting.checkSpecializationLegend(player, "weaving") then
				return
			end
			weaving.craft(player, npc, speech)
		elseif speech == "tailor" then
			if not crafting.checkSkillLegend(player, "tailoring") then
				return
			end
			tailoring.craft(player, npc, speech)
		elseif speech == "gem" then
			--if not crafting.checkSpecializationLegend(player,"gemcutting") then return end
			gemcutting.craft(player, npc, speech)
		elseif speech == "jewel" then
			if not crafting.checkSkillLegend(player, "jewelry making") then
				return
			end
			jewelrymaking.craft(player, npc, speech)
		elseif speech == "smelt" then
			--if not crafting.checkSpecializationLegend(player,"smelting") then return end
			smelting.craft(player, npc, speech)
		elseif speech == "metal" then
			if not crafting.checkSkillLegend(player, "metalworking") then
				return
			end
			metalworking.craft(player, npc, speech)
		elseif speech == "smith armor" then
			if not crafting.checkSkillLegend(player, "metalworking") then
				return
			end
			metalworking.craft(player, npc, speech)
		elseif speech == "prepare noodles" then
			chef.craft(player, npc, speech)
		elseif speech:match("prepare ") then
			foodpreparation.craft(player, npc, speech)
		elseif speech == "scribe" then
			scribing.craft(player, npc, speech)
		elseif speech == "alchemy" then
			potionmaking.craft(player, npc, speech)
		elseif speech == "draw" or speech == "draw map" or "combine" then
			cartography.craft(player, npc, speech)
		end
	end,

	giveCraftingLoot = function(player, npc, skill, itemSuccess, itemSuccessAmts, itemFail, itemFailAmts, customMsg)
		local msg = {
			"You have failed in your attempt.",
			"Your efforts are successful.",
			"You have succeeded masterfully!"
		}

		if itemSuccess == nil then
			return
		end

		local skillPointLevels = crafting.skillPointsPerLevel(skill)
		local earnedSkillPoints = player.registry[skill]
		local skillPts = 11
		for i = 1, #skillPointLevels do
			if earnedSkillPoints < skillPointLevels[i] then
				skillPts = i
				break
			end
		end

		local roll = math.random(1, 100)

		local chosenItem = itemSuccess[math.random(1, #itemSuccess)]
		local chosenItemAmt = itemSuccessAmts[math.random(1, #itemSuccessAmts)]

		if roll >= 40 then
			local tSuccess = {
				graphic = Item(chosenItem).icon,
				color = Item(chosenItem).iconC
			}
			player:addItem(chosenItem, chosenItemAmt)
			crafting.skillChanceIncrease(player, npc, skill)
			player:dialogSeq({tSuccess, msg[2]}, 0)
		else
			local tFail = {
				graphic = Item(itemFail).icon,
				color = Item(itemFail).iconC
			}

			player:addItem(itemFail, itemFailAmts)
			player:dialogSeq({tFail, msg[1]}, 0)
		end
	end,

	retrieveCraftingLoot = function(player, skill, items)
		local chosenOne = "failed"
		local itemReturn = {yname = chosenOne, graphic = 0, color = 0}
		if items == nil then
			return itemReturn
		elseif #items == 1 then
			if items[1] == "failed" then
				return itemReturn
			else
				itemReturn.yname = items[1].yname
				itemReturn.graphic = Item(items[1]).icon
				itemReturn.color = Item(items[1]).iconC
				return itemReturn
			end
		end
		local itemsRoll = (#items + 1) * 12

		local roll = math.random(1, itemsRoll)
		local middle = math.floor(#items / 2)
		if middle < 1 then
			middle = 1
		end

		local skillPts = crafting.getSkillValue(player, skill)
		local lowEnd = 1
		local highEnd = (13 - skillPts)

		if skillPts < 1 then
			skillPts = 1
		end

		for i = 1, #items do
			if i <= middle then
				if roll >= lowEnd and roll <= highEnd then
					chosenOne = items[i]
				end
				lowEnd = highEnd
				highEnd = highEnd + (13 - skillPts)
			else
				if roll >= (highEnd - skillPts) and roll <= highEnd then
					chosenOne = items[i]
				end
				lowEnd = highEnd
				highEnd = highEnd + skillPts + 2
			end
			if chosenOne ~= "failed" then
				break
			end
		end

		if skill == "smelting" and chosenOne == "failed" then
			chosenOne = "slag"
		end
		if skill == "weaving" and chosenOne == "failed" then
			chosenOne = "wool"
		end
		if skill == "gemcutting" and chosenOne == "failed" then
			if math.random(1, 3) == 1 then
				chosenOne = items[1]
			end
		end
		if skill == "gemcutting" and chosenOne == items[3] then
			chosenOne = items[math.random(1, 3)]
		end
		if skill == "woodworking" and chosenOne == "failed" then
			if math.random(1, 2) == 1 then
				chosenOne = "wood_scraps"
			end
		end
		if skill == "metalworking" and chosenOne == "failed" then
			if math.random(1, 2) == 1 then
				chosenOne = "spent_metal"
			end
		end
		if chosenOne ~= "failed" then
			itemReturn = {
				yname = chosenOne,
				graphic = Item(chosenOne).icon,
				color = Item(chosenOne).iconC
			}
		end

		return itemReturn
	end,

	retrieveCraftingDialog = function(item_yname, skill)
		if item_yname == nil then
			return "failed"
		end
		local yname = string.lower(item_yname)
		local itemDesc = string.match(yname, "[^_]+")
		local craftingMsgReturn = "..."

		if skill == "fishing" then
			return craftingMsgReturn
		elseif skill == "woodworking" then
			if yname == "failed" or yname == "wood_scraps" then
				craftingMsgReturn = "You have failed in your attempt."
			elseif yname:match("quiver") then
				craftingMsgReturn = "The arrows are of " .. itemDesc:gsub(
					"^%l",
					string.upper
				) .. " quality."
			elseif yname:match("supple") or yname:match("fine") then
				craftingMsgReturn = "You have succeeded masterfully!"
			else
				craftingMsgReturn = "Your efforts are successful."
			end
			return craftingMsgReturn
		elseif skill == "woodscraps" then
			if yname ~= "ginko_wood" then
				craftingMsgReturn = "No luck this time."
			end
			return craftingMsgReturn
		elseif skill == "gemcutting" then
			local ambers = {
				"amber",
				"dark_amber",
				"white_amber",
				"yellow_amber"
			}
			for i = 1, #ambers do
				if yname == "tarnished_" .. ambers[i] then
					craftingMsgReturn = "You have failed in your attempt."
				elseif yname == "crafted_" .. ambers[i] then
					craftingMsgReturn = "Your efforts are successful!"
				elseif yname == "well_crafted_" .. ambers[i] then
					craftingMsgReturn = "You have succeeded masterfully!"
				end
			end
			if craftingMsgReturn == "..." then
				craftingMsgReturn = "Your feeble efforts have destroyed that which you meant to enhance."
			end
			return craftingMsgReturn
		elseif skill == "jewelry making" then
			local rings = {
				"amber",
				"chung_ryong",
				"dark",
				"hyun_moo",
				"white",
				"baekho",
				"yellow",
				"ju_jak"
			}
			for i = 1, #rings do
				if yname == "small_" .. rings[i] .. "_ring" or yname == "medium_" .. rings[i] .. "_ring" then
					if i % 2 == 0 then
						craftingMsgReturn = "The totems have blessed your work!"
					else
						craftingMsgReturn = "You have managed to make a ring."
					end
				elseif yname == "large_" .. rings[i] .. "_ring" then
					if i % 2 == 0 then
						craftingMsgReturn = "The totems have blessed your work!"
					else
						craftingMsgReturn = "You have succeeded masterfully!"
					end
				elseif yname == "plain_" .. rings[i] .. "_bracelet" then
					craftingMsgReturn = "You managed to make a bracelet."
				elseif yname == "luxury_" .. rings[i] .. "_bracelet" then
					craftingMsgReturn = "You have succeeded masterfully!"
				elseif yname == rings[i] .. "_circlet" then
					if i % 2 == 0 then
						craftingMsgReturn = "The totems have blessed your work!"
					else
						craftingMsgReturn = "You have managed to make a circlet."
					end
				elseif yname == rings[i] .. "_casque" then
					if i % 2 == 0 then
						craftingMsgReturn = "The totems have blessed your work!"
					else
						craftingMsgReturn = "You have succeeded masterfully!"
					end
				elseif yname == "diadem" then
					craftingMsgReturn = "All of your efforts have paid off, you have crafted a Diadem!"
				end
			end
			if craftingMsgReturn == "..." then
				craftingMsgReturn = "Your feeble efforts have destroyed that which you meant to enhance."
			end
			return craftingMsgReturn
		elseif skill == "weaving" then
			if yname == "cloth" then
				craftingMsgReturn = "You have made some cloth!"
			elseif yname == "fine_cloth" then
				craftingMsgReturn = "You have succeeded masterfully!"
			else
				if math.random(1, 3) == 3 then
					craftingMsgReturn = "You completely mangled that bunch of wool."
				else
					craftingMsgReturn = "You will need some more wool to finish this cloth."
				end
			end
			return craftingMsgReturn
		elseif skill == "tailoring" then
			if yname == "failed" then
				craftingMsgReturn = "You were unsuccessful."
			else
				craftingMsgReturn = "The Garment is of " .. itemDesc:gsub(
					"^%l",
					string.upper
				) .. " quality."
			end
			return craftingMsgReturn
		elseif skill == "smelting" then
			if yname == "metal" then
				craftingMsgReturn = "Your efforts are successful!"
			elseif yname == "fine_metal" then
				craftingMsgReturn = "You have succeeded masterfully!"
			else
				craftingMsgReturn = "You have failed in your attempt."
			end
			return craftingMsgReturn
		elseif skill == "metalworking" then
			if yname == "failed" or yname == "spent_metal" then
				craftingMsgReturn = "Your feeble efforts have destroyed that which you meant to enhance."
			elseif yname:match("fine") then
				craftingMsgReturn = "You have succeeded masterfully!"
			elseif yname:match("steel") then
				craftingMsgReturn = "Your efforts are successful!"
			else
				craftingMsgReturn = "The darts are of " .. itemDesc:gsub(
					"^%l",
					string.upper
				) .. " quality."
			end
			return craftingMsgReturn
		elseif skill == "chef" then
			return craftingMsgReturn
		elseif skill == "food preparation" then
			return craftingMsgReturn
		elseif skill == "alchemy" then
			return craftingMsgReturn
		elseif skill == "inscription" then
			return craftingMsgReturn
		end

		return craftingMsgReturn
	end
}
