local _waypointId = "wilderness"

RotahNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		local opts = {
			"Become Neutral",
			"Forgotten past",
			"Rings and Tribes",
			"Wisdom clothes",
			"Shadow Stats",
			"Mass Exchange",
			"Broadcast Event",
			"Checks",
			"Banking",
			"Transport",
			"Date & Time"
		}

		if os.time() >= player.registry["gave_fragile_orb_of_world_shout_time"] then
			table.insert(opts, "Free World Shout")
		end

		if (not Waypoint.isEnabled(player, _waypointId)) then
			table.insert(opts, "Waypoint")
		end

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)

		if choice == "Become Neutral" then
			-- become neutral
			general_npc_funcs.moveToCountry(player, npc, 0)
		elseif choice == "Forgotten past" then
			-- forgotten past (quest line)
			RotahNpc.forgottenPast(player, npc)
		elseif choice == "Rings and Tribes" then
			RotahNpc.ringsAndTribes(player, npc)
		elseif choice == "Wisdom clothes" then
			general_npc_funcs.wisdomClothes(player, npc)
		elseif choice == "Shadow Stats" then
			ExpSellerNpc.showShadowMainMenu(player, npc)
		elseif choice == "Mass Exchange" then
			-- max exch
			general_npc_funcs.massExchange(player, npc)
		elseif choice == "Broadcast Event" then
			-- broadcast event
			general_npc_funcs.broadcastEvent(player, npc)
		elseif choice == "Checks" then
			-- checks
			general_npc_funcs.checks(player, npc)
		elseif choice == "Banking" then
			bank.show_main_menu(player, npc)
		elseif choice == "Transport" then
			Waypoint.click(player, npc)
		elseif choice == "Date & Time" then
			general_npc_funcs.time(player)
		elseif choice == "Free World Shout" then
			general_npc_funcs.freeWorldShout(player, npc)
		elseif choice == "Waypoint" then
			Waypoint.add(player, npc, _waypointId)
		end
	end),

	forgottenPast = function(player, npc)
		Tools.configureDialog(player, npc)

		if player:hasLegend("forged_orb") then
			player:dialogSeq({"You have already forged an orb."}, 0)
			return
		end

		player:dialogSeq(
			{
				"You wish to know about my past?\n\nWhy would you ask such a silly question?",
				"I am just an old man, nothing has ever really happened to me.\n\nI just sit here, listening to the whispers in the breeze..."
			},
			1
		)

		if player.quest["forgotten_path"] == 0 then
			player.quest["forgotten_path"] = 1
			return
		end
	end,

	becomeNeutral = function(player, npc)
		Tools.configureDialog(player, npc)

		player:dialogSeq({"Not yet implemented. Please check later."}, 0)

		if player.country == 1 or player.country == 2 then
			player:dialogSeq(
				{
					"Welcome there city dweller. Isn't it wonderful out here?",
					"Would you like to leave the city behind, and become a member of the wilderness?",
					"Doing so means you will leave all that you have behind, your clan, your loyalties, your home, and your companions."
				},
				1
			)

			local subchoice = player:menuSeq(
				"Are you still interested in becoming Neutral?",
				{"No, I'd prefer not to.", "Yes, please."},
				{}
			)

			if subchoice == 2 then
				player:updateCountry(0)
				player.clan = 0
				player:sendStatus()
				player:dialogSeq({"Welcome to the wilderness."}, 0)
				return
			end
		elseif player.country == 0 then
			--already neutral
			player:dialogSeq({"Ah, the free life. Isn't it great?"}, 0)
			return
		end
	end,

	ringsAndTribes = function(player, npc)
		Tools.configureDialog(player, npc)

		if player.clan ~= 0 then
			player:dialogSeq({"This is for ring and tribe members only, you are part of an official clan and cannot use these options."}, 0)
			return
		end

		player:dialogSeq(
			{
				"You may set up your own ring at any time, so long as you are not part of another ring, tribe, or clan, and have not been in trouble with the law.",
				"A ring is a small group of people, with a minimum of 10. If at any time your ring is less than 10 members, the ring will be closed.",
				"Once a ring grows to 50 members, you will be eligible to form a tribe. This has more power, and more options than the smaller rings.",
				"Finally, once you get over 100 members, you will be able to petition the clan tribunal of the nation you are in, unless it is a wilderness tribe, to become an official clan.",
				"To set up your ring, you will need to have 10 members, yourself and at least 9 others together at the same time, and 500,000 gold.",
				"Once you have the ability to become a tribe, you will need another 5,000,000 to upgrade. But make sure you are going to stay over 50 members.\nShould you drop down below 50 members you will return to a ring standing, and must pay to upgrade again.",
				"Each level, ring, tribe, and clan has it's own abilities and powers. The higher your group grows the more power you will be able to use.",
				"A ring will have the founder as the primogen, one level of council, and basic clan abilities.",
				"A tribe will be able to gain a bank to use, as well as a second level of council."
			},
			1
		)

		if player.country == 0 then
			-- neutral
			player:dialogSeq({"As you are from the neutral kingdom you will never be able to become an official clan, only rings and tribes from one of the main cities can become an official clan."}, 1)
		else
			player:dialogSeq({"If you're lucky enough to become an official clan through tribunal, you will gain a clan hall, as well as the ability to expand the hall and add new abilities."}, 1)
		end

		player:dialogSeq(
			{
				"When forging the ring, the name cannot be offensive, or be intended to imitate or offend anyone else.",
				"Your ring's name should be unique. It if is too similar to an existing ring or clan it may be disbanded, and you will not get a refund.",
				"If you forge a ring with a name that is not appropriate the ring will be disbanded, and you will not get a refund.",
				--"((If you are unsure whether your ring's name is appropriate, please send us a ticket at https://www.retrotk.com/helpdesk))"
			},
			0
		)
	end,

	onSayClick = async(function(player, npc)
		Tools.configureDialog(player, npc)
		local speech = string.lower(player.speech)
		local pathQuest

		if speech == "sweet summer blossoms" and player.quest["forgotten_path"] == 1 then
			player.quest["forgotten_path"] = 2
			player:dialogSeq(
				{
					"What did you say?\nHmm.. yes sometimes I can spell the summer blossoms on the breeze.",
					"Ohh--that smell reminds me of her. She always smelled of sweet flowers, but sadly she doesn't come around here anymore.",
					"The wilderness life was never one she could stand."
				},
				1
			)

			return
		end

		if speech == "wilderness life" and (player.quest["forgotten_path"] == 2 or player.quest["forgotten_path"] == 3) then
			player.quest["forgotten_path"] = 3
			player:dialogSeq(
				{
					"Ahh yess, the wilderness life...\nShe never had many people she could help out here.",
					"She moved to Buya, she kept telling me she only wanted to help others with her healing magic."
				},
				1
			)

			return
		end

		if speech == "strange metal" and player.quest["forgotten_path"] == 10 then
			player.quest["forgotten_path"] = 11
			player:dialogSeq(
				{
					"Umm.. what's this you have here?",
					"Wow.. this is some strange metal you have.\n\nYou say it will make a Metal orb?",
					"Wow, really? I must tell my brothers and sisters!"
				},
				1
			)
			return
		end

		if speech == "elemental orb" then
			if player:hasItem("shu_jing", 1) ~= true and player.quest["forgotten_path"] == 11 then
				player:dialogSeq(
					{
						"Hmm.. well seeing as you helped myself and the Geomancers to make the final orb, perhaps I can help you craft one.",
						"First you must show me how much you know of my teachings...\n\nOtherwise how else could I trust you?",
						"First bring me a Shu jing, and when you do I will ask you five questions, one for every element there is."
					},
					1
				)

				return
			end
			if player:hasItem("shu_jing", 1) == true and player.quest["forgotten_path"] == 11 then
				player:dialogSeq(
					{
						"Hmm.. well seeing as you helped myself and the Geomancers to make the final orb, perhaps I can help you craft one.",
						"First you must show me how much you know of my teachings...\n\nOtherwise how else could I trust you?",
						"First bring me a Shu jing, and when you do I will ask you five questions, one for every element there is."
					},
					1
				)

				local pathQuest = player:inputSeq(
					"Which element is the beginning of new life?",
					"The element",
					"is the beginning of new life.",
					{},
					{}
				)
				if string.lower(pathQuest) ~= "wood" then
					return
				end

				pathQuest = player:inputSeq(
					"Which element represents the Kun trigram?",
					"The element",
					"represents Kun.",
					{},
					{}
				)
				if string.lower(pathQuest) ~= "earth" then
					return
				end

				pathQuest = player:inputSeq(
					"Which element contains the most Yang?",
					"The element",
					"contains the most Yang.",
					{},
					{}
				)
				if string.lower(pathQuest) ~= "fire" then
					return
				end

				pathQuest = player:inputSeq(
					"Which element represents the Kan Trigram?",
					"The element",
					"represents Kan.",
					{},
					{}
				)
				if string.lower(pathQuest) ~= "water" then
					return
				end

				pathQuest = player:inputSeq(
					"Which element is the most commonly used remedy for the negative Earth energies?",
					"The element",
					"is most often used.",
					{},
					{}
				)
				if string.lower(pathQuest) ~= "metal" then
					return
				end

				player.quest["forgotten_path"] = 12
				player:dialogSeq({"Correct!"}, 0)
				return
			end

			if player.quest["forgotten_path"] == 12 then
				pathQuest = player:inputSeq(
					"Which type of orb would you like to make?",
					"An orb made of",
					"is the one for me.",
					{},
					{}
				)
				local answer = string.lower(pathQuest)
				local mats = {}
				local amts = {}
				if answer == "wood" then
					pathQuest = player:menuString(
						"To make a Wood orb I will need 25 wood scraps, a star drop, and 2 yellow ambers.\n\nAre you ready to trade?",
						{"Yes", "No"},
						{}
					)
					if string.lower(pathQuest) == "yes" then
						mats = {"wood_scraps", "stardrop", "yellow_amber"}
						amts = {25, 1, 2}
					end
				elseif answer == "earth" then
					pathQuest = player:menuString(
						"To make an Earth orb I will need 25 poor ore, a star drop, and 2 yellow ambers.\n\nAre you ready to trade?",
						{"Yes", "No"},
						{}
					)
					if string.lower(pathQuest) == "yes" then
						mats = {"ore_poor", "stardrop", "yellow_amber"}
						amts = {25, 1, 2}
					end
				elseif answer == "fire" then
					pathQuest = player:menuString(
						"To make a Fire orb I will need 10 hot coal, a star drop, and 2 yellow ambers.\n\nAre you ready to trade?",
						{"Yes", "No"},
						{}
					)
					if string.lower(pathQuest) == "yes" then
						mats = {"hot_coal", "stardrop", "yellow_amber"}
						amts = {10, 1, 2}
					end
				elseif answer == "water" then
					pathQuest = player:menuString(
						"To make a Water orb I will need 2 ice shards, 5 star drops, and 2 yellow ambers.\n\nAre you ready to trade?",
						{"Yes", "No"},
						{}
					)
					if string.lower(pathQuest) == "yes" then
						mats = {"ice_shard", "stardrop", "yellow_amber"}
						amts = {2, 5, 2}
					end
				elseif answer == "metal" then
					pathQuest = player:menuString(
						"To make a Metal orb I will need 10 metal, a star drop, and 2 yellow ambers.\n\nAre you ready to trade?",
						{"Yes", "No"},
						{}
					)
					if string.lower(pathQuest) == "yes" then
						mats = {"metal", "stardrop", "yellow_amber"}
						amts = {10, 1, 2}
					end
				end

				if string.lower(pathQuest) ~= "yes" then
					return
				end

				for i = 1, #mats do
					if player:hasItem(mats[i], amts[i]) ~= true then
						player:dialogSeq({"You do not have all the required items."}, 0)
						return
					end
				end

				for i = 1, #mats do
					player:removeItem(mats[i], amts[i], 9)
				end

				player:addItem(answer .. "_orb", 1, 0, player.ID)

				local questTag = answer:gsub("^%l", string.upper)
				player.quest["forgotten_path"] = 0
				player:addLegend(
					"Forged an orb of " .. questTag .. ", " .. curT(),
					"forged_orb",
					6,
					128
				)
			end
		end

		if (speech == "waypoint" and not Waypoint.isEnabled(player, _waypointId)) then
			Waypoint.add(player, npc, _waypointId)
			return
		end

		Waypoint.onSayClick(player, npc)
	end)
}
