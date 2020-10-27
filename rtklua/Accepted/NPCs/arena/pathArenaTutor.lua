PathArenaTutorNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {}

		if player.tutor == 0 then
			opts = {"Buy", "Sell", "Observe", "Reincarnate", "War Paint"}
		end

		if player.tutor == 1 or player.gmLevel > 0 then
			opts = {
				"Buy",
				"Sell",
				"Begin Tutelage",
				"Complete Tutelage",
				"Illusion",
				"Tutor Nuisance",
				"Announce Tutorial",
				"War Paint",
				"All Observe",
				"Tutor Clear Traps",
				"Boss Summon",
				"Kill Boss Summons",
				"Tutor Legend Mark",
				"Novice Listener",
				"Adjust Map Attributes"
			}
		end

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)

		local buyItems, buyPrices = PathArenaTutorNpc.buyItems(npc)
		local sellItems, sellPrices = PathArenaTutorNpc.sellItems(npc)

		if choice == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				buyItems,
				buyPrices
			)
		elseif choice == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				sellItems,
				sellPrices
			)
		elseif choice == "Reincarnate" then
			general_npc_funcs.reincarnate(player, npc)
		elseif choice == "Observe" then
			general_npc_funcs.observe(player, npc)
		elseif choice == "War Paint" then
			general_npc_funcs.warPaint(player, npc)
		elseif choice == "Tutor Nuisance" then
			PathArenaTutorNpc.tutorNuisance(player, npc)
		elseif choice == "Boss Summon" then
			PathArenaTutorNpc.bossSummon(player, npc)
		elseif choice == "Kill Boss Summons" then
			PathArenaTutorNpc.killBossSummons(player, npc)
		elseif choice == "Announce Tutorial" then
			PathArenaTutorNpc.announceTutorial(player, npc)
		elseif choice == "Tutor Legend Mark" then
			PathArenaTutorNpc.tutorLegendMark(player, npc)
		elseif choice == "All Observe" then
			PathArenaTutorNpc.allObserve(player, npc)
		elseif choice == "Novice Listener" then
			PathArenaTutorNpc.noviceListener(player, npc)
		elseif choice == "Tutor Clear Traps" then
			PathArenaTutorNpc.tutorClearTraps(player, npc)
		elseif choice == "Adjust Map Attributes" then
			PathArenaTutorNpc.adjustMapAttributes(player, npc)
		end
	end),

	adjustMapAttributes = function(player, npc)
		local s = "buffer"
		while s ~= "nothing" do
			local attrib = {"Spells", "Eating", "Using", "Smoking", "Lighting"}
			local currentStatus = {
				player.spell,
				player.canEat,
				player.canUse,
				player.canSmoke,
				player.light
			}
			local attribS = {}

			for i = 1, #attrib do
				status = ""
				if currentStatus[i] == 0 then
					status = "Off"
				elseif currentStatus[i] == 1 then
					status = "On"
				end

				table.insert(attribS, attrib[i] .. ": " .. status)
			end

			local choice = player:menuSeq(
				"Please select a toggle to turn it on and off.",
				attribS,
				{}
			)

			if choice == 1 then
				if currentStatus[choice] == 0 then
					player.spell = 1
					player:sendMinitext("Map Spells: ON")
				end
				if currentStatus[choice] == 1 then
					player.spells = 0
					player:sendMinitext("Map Spells: OFF")
				end
			elseif choice == 2 then
				if currentStatus[choice] == 0 then
					player.canEat = 1
					player:sendMinitext("Eating: ON")
				end
				if currentStatus[choice] == 1 then
					player.canEat = 0
					player:sendMinitext("Eating: OFF")
				end
			elseif choice == 3 then
				if currentStatus[choice] == 0 then
					player.canUse = 1
					player:sendMinitext("Using: ON")
				end
				if currentStatus[choice] == 1 then
					player.canUse = 0
					player:sendMinitext("Using: OFF")
				end
			elseif choice == 4 then
				if currentStatus[choice] == 0 then
					player.canSmoke = 1
					player:sendMinitext("Smoking: ON")
				end
				if currentStatus[choice] == 1 then
					player.canSmoke = 0
					player:sendMinitext("Smoking: OFF")
				end
			elseif choice == 5 then
				local choice = player:menuSeq(
					"What would you like to do?",
					{"Disable lightning setting.", "Enter a number"},
					{}
				)

				if choice == 1 then
					player.light = 0
					player:refresh()
				elseif choice == 2 then
					local light = player:inputNumberCheck(player:input("Enter a number 0 - 55, 0 for disabled. 1 = pitch black, 40 = full brightness."))

					player.light = light
					player:refresh()
				end
			end
		end
	end,

	tutorClearTraps = function(player, npc)
		local npcBlocks = player:getObjectsInArea(BL_NPC)
		local npcsToRemove = {}

		if npcBlocks ~= nil then
			for i = 1, #npcBlocks do
				if (npcBlocks[i].yname == "DartTrapNpc" or
					npcBlocks[i].yname == "FlashTrapNpc" or
					npcBlocks[i].yname == "RepeatingDartTrapNpc" or
					npcBlocks[i].yname == "SnareTrapNpc" or
					npcBlocks[i].yname == "SpearTrapNpc" or
					npcBlocks[i].yname == "poison_trap" or -- @TODO: Not sure this NPC actually exists
					npcBlocks[i].yname == "DeathTrapNpc" or
					npcBlocks[i].yname == "SleepTrapNpc") then

					table.insert(npcsToRemove, npcBlocks[i])
				end
			end
		end

		if #npcsToRemove > 0 then
			for i = 1, #npcsToRemove do
				local items = player:getObjectsInCellWithTraps(
					npcsToRemove[i].m,
					npcsToRemove[i].x,
					npcsToRemove[i].y,
					BL_ITEM
				)

				if #items > 0 then
					for j = 1, #items do
						if items[j].id == 99 then
							items[j]:delete()
						end
					end
				end

				npcsToRemove[i]:delete()
			end
		end

		player:sendMinitext("Traps removed.")
	end,

	allObserve = function(player, npc)
		local pcs = npc:getObjectsInSameMap(BL_PC)

		if pcs ~= nil then
			for i = 1, #pcs do
				pcs[i].state = 1
				pcs[i]:flushDuration(1)
				pcs[i]:updateState()
			end
		end
	end,

	noviceListener = function(player, npc)
		if player.noviceChat == 0 then
			player.noviceChat = 1
			player:sendMinitext("Novice Chat: ON")
			return
		end
		if player.noviceChat == 1 then
			player.noviceChat = 0
			player:sendMinitext("Novice Chat: OFF")
			return
		end
	end,

	tutorNuisance = function(player, npc)
		local name = string.lower(player:inputLetterCheck(player:input("Who needs removed?")))

		local pcs = npc:getObjectsInSameMap(BL_PC)

		for i = 1, #pcs do
			if string.lower(pcs[i].name) == name then
				if pcs[i].tutor == 1 or pcs[i].gmLevel > 0 then
					player:dialogSeq({"You cannot remove that person."})
					return
				end
				pcs[i]:returnToInn()
				break
			end
		end
	end,

	tutorLegendMark = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local name = player:inputLetterCheck(player:input("Whom would you like to update their attended classes legend mark?"))
		local target = Player(name)

		if target == nil then
			player:dialogSeq({t, "Player not online."}, 0)
			return
		end
		target.registry["tutor_classes_attended"] = target.registry[
			"tutor_classes_attended"
		] + 1

		target:removeLegendbyName("attended_tutor_classes")
		target:addLegend(
			"Attended " .. target.registry["tutor_classes_attended"] .. " tutor classes, last witnessed by $player",
			"attended_tutor_classes",
			3,
			128,
			player.ID
		)

		player:dialogSeq(
			{t, target.name .. "'s legend mark has been updated."},
			0
		)
	end,

	announceTutorial = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if (not player:canCast(1, 1, 0)) then
			player:sendMinitext("That doesn't work here.")
			return
		end

		local message = ""
		local message2 = ""

		message = player:inputSeq(
			"Please type what you would like to say to the world. ((If your meessage is longer than 42 characters, you can type an additional 38 characters after you click \"OK\"))",
			"",
			"",
			{},
			{}
		)

		if string.len(message) == 0 then
			player:dialogSeq({t, "You have not entered anything."}, 0)
			return
		end

		if string.len(message) >= 42 then
			message2 = player:inputSeq(
				"You can continue with your message here up to 38 characters.",
				"",
				"",
				{},
				{}
			)
		end

		if string.len(message2) > 38 then
			player:dialogSeq(
				{t, "Your second part of your message is too long."},
				0
			)
			return
		end

		local broadcastName = ""

		if player:hasLegend("head_tutor") then
			broadcastName = "Head Tutor"
		else
			broadcastName = "Tutor"
		end

		broadcast(
			-1,
			"[" .. broadcastName .. " " .. player.name .. "]: " .. message
		)
		if message2 ~= "" then
			broadcast(
				-1,
				"[" .. broadcastName .. " " .. player.name .. "]: " .. message2
			)
		end
	end,

	bossSummon = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local mobs = {}
		local caves = {
			"Rat",
			"Dragon",
			"Rabbit",
			"Dog",
			"Snake",
			"Tiger",
			"Pig",
			"Ox",
			"Sheep",
			"Rooster",
			"Horse",
			"Monkey"
		}

		local dragon = {
			"Mythic dragon",
			"Dragon mage",
			"Divine dragon",
			"Dragon slayer",
			"Spirit dragon",
			"Dragon avenger"
		}
		local dog = {
			"Mythic dog",
			"Dog assassin",
			"Divine dog",
			"Dog cutthroat",
			"Spirit dog",
			"Dog Avenger"
		}
		local horse = {
			"Mythic horse",
			"Horse do",
			"Divine horse",
			"Horse chongun",
			"Spirit Horse",
			"Horse avenger"
		}
		local monkey = {
			"Mythic monkey",
			"Monkey mauler",
			"Divine monkey",
			"Monkey basher",
			"Spirit monkey",
			"Monkey avenger"
		}
		local ox = {
			"Mythic ox",
			"Ox gorer",
			"Divine ox",
			"Ox charger",
			"Spirit ox",
			"Ox avenger"
		}
		local pig = {
			"Mythic boar",
			"Boar champion",
			"Divine pig",
			"Pig champion",
			"Spirit pig",
			"Pig avenger"
		}
		local rabbit = {
			"Mythic hare",
			"Hare witch",
			"Divine rabbit",
			"Rabbit witch",
			"Spirit rabbit",
			"Rabbit avenger"
		}
		local rat = {
			"Mythic rat",
			"Mighty mouse",
			"Divine rat",
			"Rat lord",
			"Spirit rat",
			"Rat avenger"
		}
		local rooster = {
			"Mythic rooster",
			"Rooster swordsman",
			"Divine rooster",
			"Rooster barbarian",
			"Spirit rooster",
			"Rooster avenger"
		}
		local sheep = {
			"Mythic sheep",
			"Sheep veteran",
			"Divine sheep",
			"Sheep shepherd",
			"Spirit sheep",
			"Sheep avenger"
		}
		local snake = {
			"Mythic snake",
			"Snake shaman",
			"Divine snake",
			"Snake mage",
			"Spirit snake",
			"Snake avenger"
		}
		local tiger = {
			"Mythic tiger",
			"Tiger warrior",
			"Divine tiger",
			"Tiger slasher",
			"Spirit tiger",
			"Tiger avenger"
		}

		local choice = player:menuString(
			"From which mythic cave do you want to spawn?",
			caves
		)

		if choice == "Rat" then
			mobs = rat
		elseif choice == "Dragon" then
			mobs = dragon
		elseif choice == "Rabbit" then
			mobs = rabbit
		elseif choice == "Dog" then
			mobs = dog
		elseif choice == "Snake" then
			mobs = snake
		elseif choice == "Tiger" then
			mobs = tiger
		elseif choice == "Pig" then
			mobs = pig
		elseif choice == "Ox" then
			mobs = ox
		elseif choice == "Sheep" then
			mobs = sheep
		elseif choice == "Rooster" then
			mobs = rooster
		elseif choice == "Horse" then
			mobs = horse
		elseif choice == "Monkey" then
			mobs = monkey
		end

		if mobs == nil then
			return
		end

		local mobChoice = player:menuString("Choose a mob to spawn", mobs)

		mobChoice = string.gsub(mobChoice, " ", "_")
		mobChoice = string.lower(mobChoice)

		npc:spawn(
			"dummy_" .. mobChoice,
			math.floor(getMapXMax(npc.m) / 2),
			math.floor(getMapYMax(npc.m) / 2),
			1,
			npc.m
		)
	end,

	killBossSummons = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local mobs = npc:getObjectsInSameMap(BL_MOB)

		if mobs == nil or #mobs == 0 then
			player:dialogSeq({t, "There are no mobs to kill."}, 0)
			return
		end

		for i = 1, #mobs do
			mobs[i]:talk(0, "***POOOF***")
			mobs[i]:delete()
		end
	end,

	buyItems = function(npc)
		local buyItems = {"bears_liver", "antler", "herb_pipe"}
		local prices = {24, 12, 480}

		return buyItems, prices
	end,

	sellItems = function(npc)
		local sellItems = {"bears_liver", "antler", "herb_pipe"}
		local prices = {12, 6, 240}

		return sellItems, prices
	end
}
