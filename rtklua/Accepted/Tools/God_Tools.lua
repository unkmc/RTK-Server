god_tools = {
	f1click = function(player, npc)
		--	clone.gfx(player, npc)
		--	player:refresh()

		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local a = {}

		table.insert(a, "Kill")
		table.insert(a, "Spawn tool")
		table.insert(a, "Place Spawn Scrolls")
		table.insert(a, "Give Legend")
		table.insert(a, "Map Editor")
		table.insert(a, "Power Board")
		table.insert(a, "Icon Thrower")
		table.insert(a, "Freeze / Unfreeze")
		table.insert(a, "Obtain char ID")
		table.insert(a, "Get GM Spells")
		table.insert(a, "Database Items")
		table.insert(a, "Bot Check")
		table.insert(a, "Approach")
		table.insert(a, "Change a character's Username&Pass")
		table.insert(a, "Approve Clan Creation on Player")

		if player.ID == 2 or player.ID == 4 or player.ID == 7 then
			table.insert(a, "Extended Tools")
		end

		--	table.insert(a, "Warp tool")

		menu = player:menuString(
			"<b>[" .. player.name .. "]:\n\n" .. os.date() .. "\nLocation: " .. player.mapTitle .. "\n(ID: " .. player.m .. " , X: " .. player.x .. " , Y: " .. player.y .. ")",
			a
		)

		if menu == "Approach" then
			target = player:input("Enter Target Name: ")
			if Player(target) ~= nil then
				player:warp(
					Player(target).m,
					Player(target).x,
					Player(target).y
				)
			else
				player:popUp("User not found")
			end
		elseif menu == "Map Editor" then
			map_editor.click(player, npc)
		elseif menu == "Database Items" then
			morna_database_items.click(player, npc)
		elseif menu == "Get GM Spells" then
			player:addGMSpells()
		elseif menu == "Power Board" then
			player:powerBoard()
		elseif menu == "Extended Tools" then
			extendedTools.menu(player, npc)
		elseif menu == "Change a character's Username&Pass" then
			local changed = 0;

			player:popUp("You must tell the character to log out before changing the username and password.")
			old_name = player:input("Who's character name would you like to change (case sensitive) ?")

			name = player:input("Enter a new character name.")
			password = player:input("Enter a password for the character")

			if name == nil then
				return
			end

			if password == nil then
				password = "newpassword1"
			end

			confirm = player:menu(
				"Please confirm user name and password change.",
				{"Yes", "No"}
			)

			if confirm == 1 then
				if Player(old_name) ~= nil then
					Player(old_name).name = name
				end

				error = changeUsernameAndPass(old_name, name, password)
			end
		elseif menu == "Approve Clan Creation on Player" then
			player:dialogSeq(
				{
					t,
					"This tool sets the proper registry values for a given player so that they may begin the Clan Trials process with their respective group.\n\nInform player that they will need to be the group leader in every trial and will become the defacto Primogen."
				},
				1
			)

			local inputPlayer = player:input("Please enter a player.")

			if Player(inputPlayer) == nil then
				player:dialogSeq(
					{t, "Invalid player or player is not online."},
					1
				)
				return
			end

			if Player(inputPlayer).clan ~= 0 then
				player:dialogSeq({t, "Player is already part of a clan."}, 1)
				return
			end

			local sacrifice = player:menuString(
				"Should perspective clan endure the Sacrifice Trial?",
				{"Yes", "No"}
			)
			local goodvsevil = player:menuString(
				"Should perspective clan endure the Good vs. Evil Trial?",
				{"Yes", "No"}
			)
			local storytelling = player:menuString(
				"Should perspective clan endure the Storytelling Trial?",
				{"Yes", "No"}
			)
			local wealth = player:menuString(
				"Should perspective clan endure the Wealth Trial?",
				{"Yes", "No"}
			)
			local endurance = player:menuString(
				"Should perspective clan endure the Endurance Trial?",
				{"Yes", "No"}
			)

			local confirm = player:menuString(
				"Are these options correct?\n\nSacrifice: " .. sacrifice .. "\nGood vs. Evil: " .. goodvsevil .. "\nStorytelling: " .. storytelling .. "\nWealth: " .. wealth .. "\nEndurance: " .. endurance,
				{"Yes", "No"}
			)

			if confirm == "No" or confirm == nil then
				return
			end

			------- Convert string option to necessary registry values -----

			if sacrifice == "Yes" then
				Player(inputPlayer).registry["clan_trial_sacrifice"] = 1
			else
				Player(inputPlayer).registry["clan_trial_sacrifice"] = 0
			end

			if goodvsevil == "Yes" then
				Player(inputPlayer).registry["clan_trial_goodvsevil"] = 1
			else
				Player(inputPlayer).registry["clan_trial_goodvsevil"] = 0
			end

			if storytelling == "Yes" then
				Player(inputPlayer).registry["clan_trial_storytelling"] = 1
			else
				Player(inputPlayer).registry["clan_trial_storytelling"] = 0
			end

			if wealth == "Yes" then
				Player(inputPlayer).registry["clan_trial_wealth"] = 1
			else
				Player(inputPlayer).registry["clan_trial_wealth"] = 0
			end

			if endurance == "Yes" then
				Player(inputPlayer).registry["clan_trial_endurance"] = 1
			else
				Player(inputPlayer).registry["clan_trial_sacrifice"] = 0
			end

			Player(inputPlayer):dialogSeq({
				t,
				"Your clan request has been approved. Please visit the Clan NPC in Hon for more information."
			})
		elseif menu == "Walk Through (Status: OFF)" and player.registry[
			"walk_through"
		] > 0 then
			player.optFlags = 128
			player.registry["walk_through"] = 0
			player:sendMinitext("Walk Through: ON")
			player:calcStat()
		elseif menu == "Freeze / Unfreeze" then
			move = player:menuString("What to do?", {
				"All mobs in map",
				"All players in map",
				"Target (player only)"
			})

			if move == "All mobs in map" then
				mob = player:getObjectsInMap(player.m, BL_MOB)
				if #mob > 0 then
					for i = 1, #mob do
						if mob[i].paralyzed == false then
							mob[i]:sendAnimation(1)
							mob[i].paralyzed = true
						else
							mob[i]:sendAnimation(10)
							mob[i].paralyzed = false
						end
					end
				end
				player:sendMinitext("Done!")
			elseif move == "All players in map" then
				pc = player:getObjectsInMap(player.m, BL_PC)
				if #pc > 0 then
					for i = 1, #pc do
						if pc[i].ID == player.ID then
							return
						else
							if pc[i].paralyzed == false then
								pc[i]:sendAnimation(1)
								pc[i].paralyzed = true
							else
								pc[i]:sendAnimation(10)
								pc[i].paralyzed = false
							end
						end
					end
				end
				player:sendAnimation("Done!")
			elseif move == "Target (player only)" then
				pc = player:input("Enter target's name :")
				if Player(pc) ~= nil then
					if Player(pc).paralyzed == false then
						if Player(pc).ID ~= player.ID then
							Player(pc):sendAnimation(1)
							Player(pc).paralyzed = true
						end
					else
						Player(pc):sendAnimation(10)
						Player(pc).paralyzed = false
					end
					player:sendMinitext("Done!")
				else
					anim(player)
					player:sendMinitext("User not found!")
				end
			end
		elseif menu == "Script test" then
			script_test.click(player, npc)
		elseif menu == "Spawn tool" then
			spawn_tool.click(player, npc)
		elseif menu == "Place Spawn Scrolls" then
			random_spawn_scrolls.click(player, npc)
		elseif menu == "Warp tool" then
			god_tools.click(player, npc)
		elseif menu == "Obtain char ID" then
			user_pages.click(player, npc)
		elseif menu == "Icon Thrower" then
			icon = player.registry["throw_icon"]

			if icon >= 0 then
				a = {graphic = convertGraphic(icon, "item"), color = 0}
				player.npcGraphic = a.graphic
				player.npcColor = a.color
				player.dialogType = 0

				opts = {}

				if player.registry["throw_icon"] > 0 then
					table.insert(opts, "Disable")
				elseif player.registry["throw_icon"] == 0 then
					table.insert(opts, "Enable")
				end
				table.insert(opts, "Exit")

				menu = player:menuString(
					"<b>[Icon Thrower]:\n\nIcon: " .. player.registry[
						"throw_icon"
					],
					opts
				)

				if menu == "Change" or menu == "Set Icon" or menu == "Enable" then
					input = player:input("Icon Number:\n0 for disable")

					if tonumber(input) > 0 then
						player.registry["throw_icon"] = tonumber(input)
						a = {
							graphic = convertGraphic(tonumber(input), "item"),
							color = 0
						}
						player:dialogSeq({a, "Icon : " .. tonumber(input)}, 1)
						player:sendMinitext("Throw Icon : " .. tonumber(input))
					elseif tonumber(input) == 0 then
						player.registry["throw_icon"] = 0
						player:popUp("Throw icon disabled.")
					end
				elseif menu == "Disable" then
					player.registry["throw_icon"] = 0
					player:popUp("Throw icon disabled")
				end
			else
				input = player:input("Icon Number:\n0 for disable")

				if tonumber(input) > 0 then
					player.registry["throw_icon"] = tonumber(input)
					a = {
						graphic = convertGraphic(tonumber(input), "item"),
						color = 0
					}
					player:dialogSeq({a, "Icon : " .. tonumber(input)}, 1)
					player:sendMinitext("Throw Icon : " .. tonumber(input))
				elseif tonumber(input) == 0 then
					player.registry["throw_icon"] = 0
					player:popUp("Throw icon disabled.")
				end
			end
		elseif menu == "Alter Stats" then
			--	npc_alter_stats_input.click(player, npc)
			npc_alter_stats_menu.f1click(player, npc)
		elseif menu == "Take" then
			target = player:input("Enter Target name: ")
			if Player(target) ~= nil then
				menu = player:menuString("Take What?", {"Spell", "Item"})

				if menu == "Spell" then
					spel = player:input("What Spell?")
					if string.lower(spel) ~= nil then
						if Player(target):hasSpell(string.lower(spel)) then
							ok = player:menuString(
								"Delete " .. string.lower(spel) .. " from " .. Player(target).name .. "?",
								{"Yes", "No"}
							)
							if ok == "Yes" then
								Player(target):removeSpell(string.lower(spel))
								Player(target):sendMinitext(string.lower(spel) .. " has removed!")
								player:sendMinitext("Removed!")
							end
						else
							player:popUp("Target do not have that spell")
						end
					end
				elseif menu == "Item" then
				end
			else
				player:popUp("User not found!")
			end
		elseif menu == "Spawn" then
			spawn = player:input("Spawn(mobID) : ")
			if tonumber(spawn) > 0 then
				if Mob(tonumber(spawn)) ~= nil then
					amount = player:input("How many " .. Mob(tonumber(spawn)).name .. " ?")
					if tonumber(amount) > 0 and tonumber(amount) <= 20 then
						player:spawn(
							tonumber(spawn),
							player.x,
							player.y,
							tonumber(amount)
						)
					else
						player:popUp("Max: 20")
					end
				else
					player:popUp("Mob ID not found!")
				end
			else
				player:popUp("Numberic only")
			end
		elseif menu == "Player's Info" then
			player_info.click(player, npc)
		elseif menu == "Heal" then
			heal = player:menuString(
				"How do you Healing?",
				{"All players on Map", "Target"}
			)

			if heal == "All players on Map" then
				pc = player:getObjectsInMap(player.m, BL_PC)
				if #pc >= 0 then
					for i = 1, #pc do
						pc[i]:sendAnimation(427)
						pc[i]:playSound(112)
						pc[i]:addHealth(pc[i].maxHealth)
						pc[i]:sendMinitext("Heal by God")
					end
				end
			elseif heal == "Target" then
				target = player:input("Enter Target Name:")
				if Player(target) ~= nil then
					Player(target):sendAnimation(427)
					Player(target):playSound(112)
					Player(target):addHealth(Player(target).maxHealth)
					Player(target):sendMinitext("Heal by God")
				else
					player:popUp("User not found")
				end
			end
		elseif menu == "Summon" then
			sum = player:menuString(
				"What do you want to summon?",
				{"Player", "Npc"}
			)
			if sum == "Player" then
				target = player:input("Enter Target Name: ")
				if Player(target) ~= nil then
					Player(target):warp(player.m, player.x, player.y)
					Player(target):sendAnimation(16)
					Player(target):sendMinitext("You've summoned by " .. player.name)
				else
					player:popUp("User not found")
				end
			elseif sum == "Npc" then
				npc = player:input("Enter Npc ID: ")
				if tonumber(npc) > 0 then
					if Npc(tonumber(npc)) ~= nil then
						Npc(tonumber(npc)):warp(player.m, player.x, player.y)
						Npc(tonumber(npc)):talk(2, "Watzuppp boss?")
						player:sendAnimation(16)
						player:playSound(29)
					else
						player:sendAnimation(246)
						player:sendMinitext("ID not found in database")
					end
				else
					player:popUp("Numberic only sir!")
				end
			end

			--[[
	elseif menu == "Give" then
		give = player:menuString("What do you want to give?",{"Item", "Spell", "Gold","Legend"})
		if give == "Item" then
			item = player:input("What item? (item.yname)\n\nEX: return_scroll")
			if item ~= nil then
				amount = player:input("How many "..Item(item).name.." ?")
				if tonumber(amount) > 0 then
					target = player:input("Enter the name of player who you want to give "..Item(item).name.." :")
					if Player(target) ~= nil then
						if (Player(target):hasSpace(item, tonumber(amount), 0, 0) == true) then
							z = player:menuString("How you want to give "..tonumber(amount).." "..Item(item).name.." to "..Player(target).name.."?", {"With Msg to target","Without Msg","Cancel"})
							if z == "With Msg to target" then
								msg = player:input("Msg : ")
								if msg ~= nil then
									Player(target):addItem(item, tonumber(amount))
									Player(target):popUp("GM("..player.name.."): "..msg.."")
									Player(target):msg(4, "== [GM]: Added "..tonumber(amount).." "..Item(item).name.." into inventory", Player(target).ID)
									player:popUp(tonumber(amount).." "..Item(item).name.." gived to "..Player(target).name.." !!")
								end
							elseif z == "Without Msg" then
								Player(target):addItem(item, tonumber(amount))
								player:popUp(tonumber(amount).." "..Item(item).name.." gived to "..Player(target).name.." !!")
							end
						else
							player:popUp(Player(target).name.. " do not have enough space for this / Item not found")
						end
					else
						player:popUp("User not found")
					end
				else
					player:popUp("Numberic only!")
				end
			end

		elseif give == "Spell" then
			spell = player:input("What Spell? (spell.yname) \nEX: lethal_strike")
			if spell ~= nil then
				target = player:input("Enter The name of player you want to give "..spell..":")
				if Player(target) ~= nil then
					if not Player(target):hasSpell(spell) then
						a = player:menuString("Give "..spell.." to "..Player(target).name.."?",{"With Msg", "Without Msg", "Cancel"})
						if a == "With Msg" then
							msg = player:input("Msg : ")
							if msg ~= nil then
								Player(target):addSpell(spell)
								Player(target):popUp(msg)
								player:popUp(spell.." spell added to "..Player(target).name.."!")
							end
						elseif a == "Without Msg" then
							Player(target):addSpell(spell)
							player:popUp(spell.." spell added to "..Player(target).name.."!")
						end
					else
						player:popUp(Player(target).name.. " already has this spell / Spell not found in database")
					end
				else
					player:popUp("User not found!")
				end
			end

		elseif give == "Legend" then
			target = player:input("Give a legend to whom?")
			if Player(target) ~= nil then
				leg = player:input("Enter the Legend text")
				if leg ~= nil then
					name = player:input("Enter the Legend identifier")
					if name ~= nil then
						icon = player:input("Enter the Legend icon number")
						if tonumber(icon) > 0 then
							color = player:input("Enter the Legend color number")
							if tonumber(color) > 0 then
								Player(target):addLegend(leg, name, tonumber(icon), tonumber(color))
								Player(target):popUp("New Legend Added by " ..player.name)
							end
						end
					end
				end
			else
				player:popUp("User not found!")
			end

		elseif give == "Gold" then
			amount = player:input("How much: ")
			if tonumber(amount) > 0 then
				target = player:input("Enter the name you want to give this "..tonumber(amount).." coins")
				if Player(target) ~= nil then
					ok = player:menuString("How you want to give to target?",{"With Msg", "Without Msg", "Cancel"})
					if ok == "With Msg" then
						msg = player:input("Msg : ")
						if msg ~= nil then
							Player(target):addGold(tonumber(amount))
							Player(target):popUp(msg)
							player:popUp("Gived "..tonumber(amount).." coins to "..Player(target).name)
						end
					elseif ok == "Without Msg" then
						Player(target):addGold(tonumber(amount))
						player:popUp("Gived "..tonumber(amount).." coins to "..Player(target).name)
					end
				else
					player:popUp("User not found!")
				end
			else
				player:popUp("Numberic only!")
			end
		end
]]
			--
		elseif menu == "Give Legend" then
			target = player:input("Give a legend to whom?")
			if Player(target) ~= nil then
				leg = player:input("Enter the Legend text")
				if leg ~= nil then
					name = player:input("Enter the Legend identifier")
					if name ~= nil then
						icon = player:input("Enter the Legend icon number")
						if tonumber(icon) > 0 then
							color = player:input("Enter the Legend color number")
							if tonumber(color) > 0 then
								Player(target):addLegend(
									leg,
									name,
									tonumber(icon),
									tonumber(color)
								)
								Player(target):popUp("New Legend Added by " .. player.name)
							end
						end
					end
				end
			else
				player:popUp("User not found!")
			end
		elseif menu == "Common Tools" then
			common_tools.click(player, npc)
		elseif menu == "Ressurection" then
			v = player:menuString(
				"How do you want to Ressurect?",
				{"All players in this map", "Player"}
			)
			if v == "All players in this map" then
				pc = player:getObjectsInMap(player.m, BL_PC)
				if #pc > 0 then
					for i = 1, #pc do
						player:sendAction(6, 20)
						player:playSound(112)
						pc[i]:sendAnimation(427)
						pc[i]:playSound(112)
						pc[i].state = 0
						pc[i].health = 1
						pc[i]:sendStatus()
						pc[i].updateState()
						pc[i]:sendMinitext("Ressurect by God")
						player:refresh()
					end
				end
			elseif v == "Player" then
				input = player:input("Enter Player Name:")
				if Player(input) ~= nil then
					player:sendAction(6, 20)
					Player(input):sendAnimation(427)
					Player(input):playSound(112)
					Player(input).state = 0
					Player(input).health = 1
					Player(input):sendStatus()
					Player(input):updateState()
					Player(input):sendMinitext("Ressurect by God")
					player:refresh()
				else
					player:popUp("User not found")
				end
			end
		elseif menu == "Kill" then
			what = player:menuString("What do you want to kill?", {
				"All Mobs in this Map",
				"All Players in this Map",
				"Target(player)"
			})
			if what == "All Mobs in this Map" then
				mob = player:getObjectsInMap(player.m, BL_MOB)
				if #mob > 0 then
					for i = 1, #mob do
						if mob[i].mark == 0 then
							player:sendAction(6, 20)
							mob[i].attacker = 0
							mob[i]:removeHealth(mob[i].health)
						end
					end
				end
			elseif what == "All Players in this Map" then
				pc = player:getObjectsInMap(player.m, BL_PC)
				if #pc > 0 then
					for i = 1, #pc do
						if pc[i].ID ~= player.ID then
							player:sendAction(6, 20)
							pc[i]:sendAnimation(420)
							pc[i]:sendAnimation(143)
							pc[i]:playSound(59)
							pc[i].attacker = 0
							pc[i]:removeHealth(pc[i].health)
							pc[i]:sendStatus()
							pc[i]:sendMinitext("Killed by God")
						end
					end
				end
			else
				a = player:input("Enter Target Name:")
				if Player(a) ~= nil then
					Player(a):sendAnimation(420)
					Player(a):sendAnimation(143)
					Player(a):playSound(59)
					Player(a).attacker = player.ID
					Player(a):removeHealth(Player(a).health)
					Player(a):sendStatus()
					Player(a):sendMinitext("killed by God")
				else
					player:popUp("User not found!")
				end
			end
		elseif menu == "Bot Check" then
			choice = player:input("Who do you think is botting?")
			if choice ~= nil then
				bot.check(Player(choice))
			end
		end
	end,

	click = function(player, npc)
		local t = {graphic = convertGraphic(783, "monster"), color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local opts = {}
		if not player:hasSpell("add_warps") then
			table.insert(opts, "Get spell")
		else
			table.insert(opts, "Delete spell")
			table.insert(opts, "File to use : ")
		end
	end
}
