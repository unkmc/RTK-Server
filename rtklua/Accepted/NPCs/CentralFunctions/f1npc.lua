F1Npc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.lastClick = npc.ID
		player.dialogType = 0

		local opts = {}

		local string = "Hello " .. player.name .. "! How can I help you today?"

		if player.gmLevel >= 99 then
			table.insert(opts, "GM Menu")
			string = string .. "\n\nMap ID: " .. player.m .. " X: " .. player.x .. " Y: " .. player.y
		end

		table.insert(opts, "Silver Thread")

		--table.insert(opts,"Wisdom Star Status")
		table.insert(opts, "Minigame Stats")
		table.insert(opts, "Spells")
		table.insert(opts, "Toggles")
		table.insert(opts, "My character webpage")
		table.insert(opts, "Character Stats")
		table.insert(opts, "Faerie Light")
		table.insert(opts, "AFK Message")
		table.insert(opts, "Kan account information")

		if PoemNpc.checkPlayerSelectionList(player) == true then
			table.insert(opts, "Warp to Poem Selection Room")
		end

		if player:hasLegend("head_tutor") or player.gmLevel > 0 then
			table.insert(opts, "Tutor Management")
		end

		if player.tutor == 1 or player.gmLevel > 0 then
			table.insert(opts, "Go to Tutor Haven")
			table.insert(opts, "Novice Listener")
		end

		if player.class == 0 and player.level >= 5 then
			table.insert(opts, "Choose a path")
		end

		table.insert(opts, "Recover Death Pile")

		local choice = player:menuString(string, opts, {})

		if choice == "Silver Thread" then
			local warpChoice

			if player.m == 666 then
				return
			end

			if player.m >= 4711 and player.m <= 4718 then
				general_npc_funcs.reincarnate(player)
				return
			end

			if player.state ~= 1 then
				player:dialogSeq(
					{
						t,
						"This is for the dead of the land to find a path to the shaman. You are not dead, so you have no path with me."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Ah, another who walks amongst the ranks of the dead... but it is not your time yet... I will give you passage to a Shaman to give you life again."
				},
				1
			)

			if player.m >= 59000 and player.m <= 65000 then
				general_npc_funcs.reincarnate(player)
				player:warp(4259, 11, 14)
				return
			end

			if player.country == 0 then
				--wilderness
				warpChoice = player:menuString(
					"Which Shaman would you like to visit?",
					{
						"Hyun Moo Priest, to the North side of the Wilderness",
						"Ju Jak Priest, to the South side of the Wilderness",
						"Baekho Priest, to the West side of the Wilderness",
						"Chung ryong Priest, to the East side of the Wilderness"
					},
					{}
				)
			elseif player.country == 1 then
				--kugnae
				warpChoice = player:menuString(
					"Which Shaman would you like to visit?",
					{
						"Dusk, to the West of Kugnae.",
						"Dawn, to the East of Kugnae."
					},
					{}
				)
			elseif player.country == 2 then
				-- buya
				warpChoice = player:menuString(
					"Which Shaman would you like to visit?",
					{
						"Felis, to the West of Buya.",
						"Storm, to the East of Buya."
					},
					{}
				)
			end

			if warpChoice == "Hyun Moo Priest, to the North side of the Wilderness" then
				player:warp(1416, 11, 5)
			elseif warpChoice == "Ju Jak Priest, to the South side of the Wilderness" then
				player:warp(1411, 11, 5)
			elseif warpChoice == "Baekho Priest, to the West side of the Wilderness" then
				player:warp(1406, 11, 5)
			elseif warpChoice == "Chung ryong Priest, to the East side of the Wilderness" then
				player:warp(1401, 11, 5)
			elseif warpChoice == "Dusk, to the West of Kugnae." then
				player:warp(8, 6, 4)
			elseif warpChoice == "Dawn, to the East of Kugnae." then
				player:warp(9, 3, 5)
			elseif warpChoice == "Felis, to the West of Buya." then
				player:warp(338, 4, 4)
			elseif warpChoice == "Storm, to the East of Buya." then
				player:warp(339, 3, 5)
			end
		elseif choice == "GM Menu" then
			menu = player:menuString(
				"<b>[GM Menu]\n\nWhat would you like to do?",
				{
					"God Tools",
					"Private Tools",
					"Minigame Powers",
					"System Broadcast",
					"Wisdom Star Tools"
				}
			)
			if menu == "God Tools" then
				god_tools.f1click(player, npc)
			elseif menu == "Private Tools" then
				private_tools.click(player, npc)
			elseif menu == "Minigame Powers" then
				minigame_powers.f1click(player, npc)
			elseif menu == "System Broadcast" then
				local input = player:input("Enter what you want to broadcast")
				gmbroadcast(-1, "[SYSTEM]: " .. input)
			elseif menu == "Wisdom Star Tools" then
				local subChoices = {
					"Extend Wisdom Star",
					"Set Minutes Remaining",
					"Set Multiplier",
					"Set Total Points"
				}

				local subChoice = player:menuString("Select option", subChoices)
				if subChoice == "Extend Wisdom Star" then
					local minutes = player:inputNumberCheck(player:input("How many minutes would you like to extend by?"))

					local seconds = minutes * 60

					core.gameRegistry["wisdom_star_timer"] = core.gameRegistry[
						"wisdom_star_timer"
					] + seconds

					broadcast(
						-1,
						"Praise the Gods! GM " .. player.name .. " has manually extended Wisdom star by " .. minutes .. " minutes."
					)
				elseif subChoice == "Set Minutes Remaining" then
					local minutes = player:inputNumberCheck(player:input("How many minutes would you like to set?"))
					local seconds = minutes * 60

					core.gameRegistry["wisdom_star_timer"] = os.time() + seconds

					player:dialogSeq({t, "It is done."}, 0)
				elseif subChoice == "Set Multiplier" then
					local multiplier = player:input("What do you want to set the multiplier to (do not enter x)?")

					if tonumber(multiplier) < 1 then
						return
					end

					setWisdomStarMultiplier(multiplier)

					broadcast(
						-1,
						"Praise the Gods! GM " .. player.name .. " has set the Wisdom Star multiplier to " .. multiplier .. "x!"
					)
				elseif subChoice == "Set Total Points" then
					local points = player:input("What do you want to set the daily wisdom star points to?")

					if tonumber(points) < 0 then
						return
					end

					setKanDonationPoints(points)
				end
			end
		elseif choice == "Spells" then
			local menuChoice = player:menuString(
				"Please choose an option.",
				{"Learnable/Divine Secret"}
			)

			if menuChoice == "Learnable/Divine Secret" then
				player:currentFutureSpells(npc)
			end
		elseif choice == "Toggles" then
			local s = "buffer"
			while s ~= "nothing" do
				local menuChoice = player:menuString(
					"Choose a list of toggles you would like to change.",
					{"Chat Toggles", "Misc Toggles"},
					{}
				)

				if menuChoice == "Chat Toggles" then
					local chats = {"Clan Chat", "SubPath Chat"}
					local currentStatus = {player.clanChat, player.subpathChat}
					local chatsS = {}

					for i = 1, #chats do
						status = ""
						if currentStatus[i] == 0 then
							status = "Off"
						elseif currentStatus[i] == 1 then
							status = "On"
						end

						table.insert(chatsS, chats[i] .. ": " .. status)
					end

					local choice = player:menuSeq(
						"Please select a toggle to turn it on and off.",
						chatsS,
						{}
					)

					if choice == 1 then
						if currentStatus[choice] == 0 then
							player.clanChat = 1
							player:sendMinitext("Clan Chat: ON")
						end
						if currentStatus[choice] == 1 then
							player.clanChat = 0
							player:sendMinitext("Clan Chat: OFF")
						end
					elseif choice == 2 then
						if currentStatus[choice] == 0 then
							player.subpathChat = 1
							player:sendMinitext("Subpath Chat: ON")
						end
						if currentStatus[choice] == 1 then
							player.subpathChat = 0
							player:sendMinitext("Subpath Chat: OFF")
						end
					end
				elseif menuChoice == "Misc Toggles" then
					local toggles = {"See Warps", "Disable Experience Gain"}
					local currentStatus = {
						player.registry["see_warps"],
						player.registry["disableExperienceGain"]
					}
					local toggleS = {}
					local status

					for i = 1, #toggles do
						status = ""
						if currentStatus[i] == 0 then
							status = "Off"
						elseif currentStatus[i] == 1 then
							status = "On"
						end

						table.insert(toggleS, toggles[i] .. ": " .. status)
					end

					local toggleChoice = player:menuSeq(
						"Please select a toggle to turn it on and off.",
						toggleS,
						{}
					)

					if toggleChoice == 1 then
						if currentStatus[toggleChoice] == 0 then
							player.registry["see_warps"] = 1
							player:sendMinitext("See Warps: ON")
						end

						if currentStatus[toggleChoice] == 1 then
							player.registry["see_warps"] = 0
							player:sendMinitext("See Warps: OFF")
						end
					elseif toggleChoice == 2 then
						if currentStatus[toggleChoice] == 0 then
							player.registry["disableExperienceGain"] = 1
							player:sendMinitext("Disable Exp Gain: ON")
						end

						if currentStatus[toggleChoice] == 1 then
							player.registry["disableExperienceGain"] = 0
							player:sendMinitext("Disable Exp Gain: OFF")
						end
					end
				end
			end
		elseif choice == "Choose a path" then
			F1Npc.level5popupDialog(player)
		elseif choice == "Recover Death Pile" then
			local deathPileFound = 0
			local deathPile = player:getObjectsInArea(BL_ITEM)

			--added 4/2/17 for death pile recovery
			if #deathPile > 0 then
				for i = 1, #deathPile do
					if distanceSquare(player, deathPile[i], 3) then
						if player:isYours(deathPile[i]) then
							deathPileFound = 1
						end
					end
				end
			end

			if deathPileFound == 0 then
				player:dialogSeq(
					{
						t,
						"This ability allows you to recover your lost items when an unscrupulous player is standing over them. To use this ability you must first face the items you dropped upon death. You must be only one or two steps away from them.",
						"Then Press F1 and select \"Recover Death Pile\". Your items will be recovered even if a would-be thief is standing on them! To use this ability, you must be alive. If you do not have enough room in your inventory, you will be unable to recover all of your items."
					},
					0
				)
			elseif deathPileFound == 1 then
				if player.state == 1 then
					player:dialogSeq(
						{
							t,
							"You cannot recover your death pile while you are dead."
						},
						0
					)
					return
				end
				player:recoverDeathPile()
			end
		elseif choice == "Character Stats" then
			local string = "<b>" .. player.name .. "\n\n<b>[Base Stats]\nAC: " .. player.baseArmor .. "\nMight: " .. player.baseMight .. " | Will: " .. player.baseWill .. " | Grace: " .. player.baseGrace .. "\nVita: " .. Tools.formatNumber(player.baseHealth) .. " | Mana: " .. Tools.formatNumber(player.baseMagic) .. "\n"

			string = string .. "\n"
			string = string .. "<b>[Equipped Stats]\nAC: " .. player.armor .. "\nMight: " .. player.might .. " | Will: " .. player.will .. " | Grace: " .. player.grace .. "\nVita: " .. Tools.formatNumber(player.health) .. " | Mana: " .. Tools.formatNumber(player.magic) .. "\n"

			local alignment = "Natural"

			if player.alignment == 1 then
				alignment = "Kwi-Sin"
			elseif player.alignment == 2 then
				alignment = "Ming-Ken"
			elseif player.alignment == 3 then
				alignment = "Ohaeng"
			end

			string = string .. "\nAlignment: " .. alignment .. "\n"

			string = string .. "\nTotal Exp sold: " .. Tools.formatNumber(player.expSoldHealth + player.expSoldMagic + player.expSoldStats)

			player:popUp(string)
		elseif choice == "Faerie Light" then
			player:faerieLight()
		elseif choice == "My character webpage" then
			local choice = player:menuString(
				"What do you want to do with your RTK user webpage?",
				{"Change", "Remove", "Help"}
			)

			if choice == "Change" then
				local s = "buffer"

				while s == "buffer" do
					local opts = {
						"Show Vita Statistics",
						"Show Equipment List",
						"Show Legend",
						"Show Spells",
						"Show Inventory",
						"Show Banked Items"
					}
					local currentOptStatus = {
						player.profileVitaStats,
						player.profileEquipList,
						player.profileLegends,
						player.profileSpells,
						player.profileInventory,
						player.profileBankItems
					}

					local optsS = {}
					local status = ""

					for i = 1, #opts do
						if currentOptStatus[i] == 0 then
							status = "Disable"
						elseif currentOptStatus[i] ~= 0 then
							status = "Enable"
						end

						table.insert(optsS, opts[i] .. ": " .. status)
					end

					local optChoice = player:menuSeq(
						"Please select a feature of your profile you would like to enable/disable.",
						optsS,
						{}
					)

					if optChoice == 1 then
						if currentOptStatus[optChoice] == 0 then
							player.profileVitaStats = 1
							player:sendMinitext(opts[optChoice] .. ": ENABLE")
						else
							player.profileVitaStats = 0
							player:sendMinitext(opts[optChoice] .. ": DISABLE")
						end
					elseif optChoice == 2 then
						if currentOptStatus[optChoice] == 0 then
							player.profileEquipList = 1
							player:sendMinitext(opts[optChoice] .. ": ENABLE")
						else
							player.profileEquipList = 0
							player:sendMinitext(opts[optChoice] .. ": DISABLE")
						end
					elseif optChoice == 3 then
						if currentOptStatus[optChoice] == 0 then
							player.profileLegends = 1
							player:sendMinitext(opts[optChoice] .. ": ENABLE")
						else
							player.profileLegends = 0
							player:sendMinitext(opts[optChoice] .. ": DISABLE")
						end
					elseif optChoice == 4 then
						if currentOptStatus[optChoice] == 0 then
							player.profileSpells = 1
							player:sendMinitext(opts[optChoice] .. ": ENABLE")
						else
							player.profileSpells = 0
							player:sendMinitext(opts[optChoice] .. ": DISABLE")
						end
					elseif optChoice == 5 then
						if currentOptStatus[optChoice] == 0 then
							player.profileInventory = 1
							player:sendMinitext(opts[optChoice] .. ": ENABLE")
						else
							player.profileInventory = 0
							player:sendMinitext(opts[optChoice] .. ": DISABLE")
						end
					elseif optChoice == 6 then
						if currentOptStatus[optChoice] == 0 then
							player.profileBankItems = 1
							player:sendMinitext(opts[optChoice] .. ": ENABLE")
						else
							player.profileBankItems = 0
							player:sendMinitext(opts[optChoice] .. ": DISABLE")
						end
					end
				end
			elseif choice == "Remove" then
				local confirm = player:menuSeq(
					"Are you sure you want to disable your profile? (This sets all individual toggles to disabled.)",
					{"Disable my profile.", "Nevermind."},
					{}
				)

				if confirm == 1 then
					player.profileVitaStats = 0
					player.profileEquipList = 0
					player.profileLegends = 0
					player.profileSpells = 0
					player.profileInventory = 0
					player.profileBankItems = 0

					player:dialogSeq(
						{
							t,
							"Your profile has been effectively disabled. You are now only showing the basic information that everyone shows."
						},
						0
					)
					return
				end
			elseif choice == "Help" then
				player:dialogSeq(
					{
						t,
						"This feature will allow you to set up your own specific options for a RTK user page (https://users.RetroTK.com)",
						"You will be able to select what information you want to show on the site, and some options on your character image as well.",
						"These webpages will be updated dynamically with information pulled real time from the game.",
						"Remember to wear something nice, as that will be shown on the website."
					},
					0
				)
				return
			end
		elseif choice == "Wisdom Star Status" then
			---- WISDOM STAR STATUS-----

			local status
			local multiplier = 0
			local timeRemaining = (os.time() - core.gameRegistry["wisdom_star_timer"])
			local lapisAmount = 0

			local wisdomStarMultiplier = getWisdomStarMultiplier()

			if wisdomStarMultiplier < 1 then
				wisdomStarMultiplier = 1
			end

			wisdomStarMultiplier = string.format("%.2f", wisdomStarMultiplier)

			if core.gameRegistry["wisdom_star"] == 0 then
				status = "OFF"
				timeRemaining = 0
			else
				status = "ON"
			end

			string = "<b>[WISDOM STAR]\n\nStatus: " .. status .. " | " .. wisdomStarMultiplier .. "x EXP\n\nTime remaining: " .. getTimerValues("wisdom_star_timer") .. "\n\nCurrent Total: " .. Tools.formatNumber(getKanDonationPoints())

			local choice2 = player:menuString(string, {"Donate", "Exit"}, {})

			if choice2 == "Donate" then
				if player.actId == 0 then
					-- not registered
					player:dialogSeq(
						{
							t,
							"Your character must be registered (attached to account) to donate."
						},
						0
					)
					return
				end

				local amount = player:inputNumberCheck(player:input("How much would you like to donate?\n\nKan Balance: " .. Tools.formatNumber(player.registry["kan"])))

				if amount <= 0 then
					player:dialogSeq(
						{
							t,
							"You must enter a positive number that not greater than your Kan balance."
						},
						0
					)
					return
				end

				if amount > player.registry["kan"] then
					player:dialogSeq(
						{
							t,
							"You cannot enter more Kan than your current Kan balance."
						},
						0
					)
					return
				end

				local choice3 = player:menuSeq(
					"Are you sure you would like to donate " .. amount .. " Kan towards Wisdom Star?",
					{"Yes", "No"},
					{}
				)

				if choice3 == 1 then
					KanNpc.removeKan(player, amount)
					wisdom_star.setPurchase(player, amount)
					player:dialogSeq(
						{
							t,
							"Thank you so much for your donation of " .. Tools.formatNumber(amount) .. " Kan. It really means a lot to us and is greatly appreciated."
						},
						0
					)
				elseif choice3 == 2 then
					player:dialogSeq({t, "Ah, thanks anyways."}, 0)
					return
				end
			end

			------------------------------------
		elseif choice == "Minigame Stats" then
			local choices = {
				"Carnage",
				"Elixir",
				"Sumo war",
				"Beach war",
				"Bomber war"
			}

			local choice = player:menuString("Please select a game.", choices)

			if choice == "Carnage" then
				local totalGames = player.registry["carnagePart"]
				local victories = player.registry["carnageWin"]
				local losses = totalGames - victories
				local percentWin = (victories / totalGames) * 100

				local text = "<b>Carnage\n\nWon " .. string.format(
					"%.2f",
					percentWin
				) .. "% of total games played\n\nVictories: " .. victories .. "\nLosses: " .. losses .. "\nTotal games played: " .. totalGames
				player:dialogSeq({t, text}, 0)
			elseif choice == "Elixir" then
				local totalGames = player.registry[
					"participated_in_elixir_wars"
				]
				local victories = player.registry["elixir_war_victories"]
				local losses = totalGames - victories
				local percentWin = (victories / totalGames) * 100

				local text = "<b>Elixir\n\nWon " .. string.format(
					"%.2f",
					percentWin
				) .. "% of total games played\n\nVictories: " .. victories .. "\nLosses: " .. losses .. "\nTotal games played: " .. totalGames
				player:dialogSeq({t, text}, 0)
			elseif choice == "Sumo war" then
				local totalGames = player.registry["sumo_war_entries"]
				local victories = player.registry["sumo_war_wins"]
				local losses = totalGames - victories
				local percentWin = (victories / totalGames) * 100

				local text = "<b>Sumo war\n\nWon " .. string.format(
					"%.2f",
					percentWin
				) .. "% of total games played\n\nVictories: " .. victories .. "\nLosses: " .. losses .. "\nTotal games played: " .. totalGames
				player:dialogSeq({t, text}, 0)
			elseif choice == "Beach war" then
				local totalGames = player.registry["beach_war_entries"]
				local victories = player.registry["beach_war_wins"]
				local losses = totalGames - victories
				local percentWin = (victories / totalGames) * 100

				local text = "<b>Beach war\n\nWon " .. string.format(
					"%.2f",
					percentWin
				) .. "% of total games played\n\nVictories: " .. victories .. "\nLosses: " .. losses .. "\nTotal games played: " .. totalGames
				player:dialogSeq({t, text}, 0)
			elseif choice == "Bomber war" then
				local totalGames = player.registry["bomber_war_entries"]
				local victories = player.registry["bomber_war_wins"]
				local losses = totalGames - victories
				local percentWin = (victories / totalGames) * 100

				local text = "<b>Bomber war\n\nWon " .. string.format(
					"%.2f",
					percentWin
				) .. "% of total games played\n\nVictories: " .. victories .. "\nLosses: " .. losses .. "\nTotal games played: " .. totalGames
				player:dialogSeq({t, text}, 0)
			end
		elseif choice == "Warp to Poem Selection Room" then
			player:warp(4019, math.random(9, 12), math.random(15, 17))
		elseif choice == "AFK Message" then
			afkMessage = player:input("Current AFK Message: " .. player.afkMessage .. "\n\nPlease set your AFK Message below: ")
			player.afkMessage = afkMessage
			player:sendMinitext("AFK Message updated")
			player:updateState()
		elseif choice == "Kan account information" then
			KanNpc.getKanAccountInfo(player)
		elseif choice == "Go to Tutor Haven" then
			if (not player:canCast(0, 1, 0)) then
				return
			end

			if player.m == 1228 then
				player:sendMinitext("Fizzle.")
				return
			end
			if (player.canSummon == 0) then
				player:sendMinitext("Fizzle.")
				return
			end
			if player.mapTitle == "Buya Kan Shop" or player.mapTitle == "Kugnae Kan Shop" then
				player:sendMinitext("Fizzle.")
				return
			end
			if (player.state == 1) then
				player:sendMinitext("Fizzle.")
				return
			end
			if player.warpOut == 0 then
				player:sendMinitext("That does not work here.")
				return
			end
			if player.m == 3010 or player.m == 3011 or player.m == 33 or player.m == 3017 then
				player:sendMinitext("Fizzle.")
				return
			end

			local warpConfirm = player:menuSeq(
				"Warp to Tutor's Haven?",
				{"Yes", "No"},
				{}
			)

			if warpConfirm == 1 then
				player:playSound(4)
				player:sendAnimation(11)
				player:sendStatus()
				player:sendAction(6, 35)
				player:warp(3573, 10, 15)
			end
		elseif choice == "Novice Listener" then
			PathArenaTutorNpc.noviceListener(player, npc)
		elseif choice == "Tutor Management" then
			local choice = player:menuString(
				"What would you like to do?",
				{"Add tutor", "Remove tutor"}
			)

			if choice == "Add tutor" then
				local name = player:inputLetterCheck(player:input("Whom would you like to appoint as a tutor?"))
				local target = Player(name)

				if target == nil then
					player:dialogSeq({t, "Player not online."}, 0)
					return
				end

				if target:hasLegend("tutor") then
					player:dialogSeq({t, "Player is already a tutor."}, 0)
					return
				end

				local classes = {"Warrior", "Rogue", "Mage", "Poet"}

				local classChoice = player:menuString(
					"What kind of tutor?",
					classes
				)

				target.tutor = 1
				target:addLegend(
					classChoice .. " Tutor (" .. curT() .. ")",
					"tutor",
					3,
					128
				)

				broadcast(
					-1,
					"[TUTOR]: " .. target.name .. " has been appointed by " .. player.name .. " as a " .. classChoice .. " Tutor!"
				)

				player:dialogSeq(
					{
						t,
						target.name .. " has been added as a " .. classChoice .. " Tutor!"
					},
					0
				)
			elseif choice == "Remove tutor" then
				local name = player:inputLetterCheck(player:input("Whom would you like to remove as a tutor?"))
				local target = Player(name)

				if target == nil then
					player:dialogSeq({t, "Player not online."}, 0)
					return
				end

				if not target:hasLegend("tutor") then
					player:dialogSeq({t, "Player is not a tutor."}, 0)
					return
				end

				target.tutor = 0
				target:removeLegendbyName("tutor")

				player:dialogSeq(
					{t, target.name .. " has been removed as tutor!"},
					0
				)
			end
		end
	end),

	level5popupDialog = function(player)
		local t = {graphic = convertGraphic(3, "monster"), color = 3}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local m = 0
		local x = 8
		local y = 7

		if (player.state == 1) then
			player:dialogSeq(
				{
					t,
					"You cannot travel anywhere because you are not alive. Please visit a Shaman first."
				},
				1
			)
		end
		local guilds = {
			"Warrior's Guild",
			"Rogue's Guild",
			"Mage's Guild",
			"Poet's Guild"
		}

		player:dialogSeq(
			{
				t,
				"Congratulations! You are young but your insight grows every day. Now you must choose a path to continue on your journey."
			},
			1
		)

		local choice = player:menuSeq(
			"Please select a guild that you'd like to visit.",
			guilds,
			{}
		)

		if choice == 1 then
			-- warriors guild
			if player.country == 1 then
				-- Koguryo
				m = 11
			elseif player.country == 2 then
				-- Buya
				m = 341
			end
		elseif choice == 2 then
			-- rogues guild
			if player.country == 1 then
				m = 15
			elseif player.country == 2 then
				m = 343
			end
		elseif choice == 3 then
			-- mages guild
			if player.country == 1 then
				m = 13
			elseif player.country == 2 then
				m = 342
			end
		elseif choice == 4 then
			-- poet's guild
			if player.country == 1 then
				m = 17
			elseif player.country == 2 then
				m = 344
			end
		end

		if choice ~= nil then
			player:warp(m, x, y)
		end
	end
}
