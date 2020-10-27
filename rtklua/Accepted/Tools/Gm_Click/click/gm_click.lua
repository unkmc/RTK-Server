gm_click = {
	menu = async(function(player, target, npc)
		local gm = ""
		if target.gmLevel > 0 then
			gm = "GM - "
		end

		--player.dialogType = 0

		local t = {graphic = convertGraphic(0, "monster"), color = 0}
		player.npcGraphic = 0
		player.npcColor = 0
		player.dialogType = 0
		player.lastClick = 0

		if target.PK == 1 then
			PK = "ON"
		else
			PK = "OFF"
		end
		local name = "<b>[" .. gm .. "" .. target.name .. "] (Id: " .. target.ID .. ")\n" .. target.classNameMark .. " (" .. target.className .. " mark: " .. target.mark .. ")\n(Lvl: " .. target.level .. ") | IP Address: " .. target.ipaddress .. "\n<b>------------------------"
		local location = "Location: " .. target.mapTitle .. "\n(ID: " .. target.m .. ", X:" .. target.x .. ", Y:" .. target.y .. ")"
		local info = "State : " .. target.state .. "   |   PK : " .. PK
		local dialog = name .. "\n" .. location .. "\n" .. info

		local opts = {}
		table.insert(opts, "Character's Status")

		-- 1
		table.insert(opts, "Path and Specialization")

		-- 2
		table.insert(opts, "Character's Look")

		-- 3
		table.insert(opts, "Equipments")

		-- 4
		table.insert(opts, "Inventory")

		-- 5
		table.insert(opts, "Bank")

		-- 6
		table.insert(opts, "Spell Book")

		-- 7
		table.insert(opts, "Send a message")

		-- 8
		table.insert(opts, "Recognition / Rewards")

		-- 9
		table.insert(opts, "Justice")

		-- 10

		menu = player:menuString(dialog, opts)

		if menu ~= nil then
			if menu == "Character's Status" then
				gm_click.status(player, target, npc, dialog)
				return
			end
			if menu == "Path and Specialization" then
				gm_click.totem_subpath_grade(player, target, npc)
				return
			end
			if menu == "Character's Look" then
				gm_click.look(player, target, npc)
				return
			end
			if menu == "Equipments" then
				equipment.items(player, target, npc)
				return
			end
			if menu == "Inventory" then
				gm_click.inventory(player, target, npc)
				return
			end
			if menu == "Spell Book" then
				spell_book.menu(player, target, npc)
				return
			end
			if menu == "Bank" then
				bank.gm_click(player, target, npc)
				return
			end
			if menu == "Send a message" then
				gm_click.message(player, target)
				return
			end
			if menu == "Justice" then
				gm_click.justice(player, target, npc)
				return
			end
			if menu == "Recognition / Rewards" then
				gm_click.rewards(player, target, npc)
				return
			end
		end
	end),

	totem_subpath_grade = function(player, target, npc)
		local change, choice = 0, 0
		local opts = {}
		local name, text = "<b>[" .. target.name .. "'s Path/Subpath]\n", ""
		player.dialogType = 0

		text = text .. "Base path : " .. target.baseClassName .. " (Id: " .. target.baseClass .. ")\n"
		text = text .. "Sub path  : " .. target.classNameMark .. " (Id: " .. target.class .. ")\n"
		text = text .. "Mark:     : " .. target.mark .. "\n"
		text = text .. "Totem     : " .. target:getTotemName(player.totem) .. " (Id: " .. target.totem .. ")\n"

		table.insert(
			opts,
			"Base path   : " .. target.baseClassName .. " (Id: " .. target.baseClass .. ")"
		)
		table.insert(
			opts,
			"Sub path : " .. target.className .. " (Id: " .. target.class .. ")"
		)
		table.insert(opts, "Mark : " .. target.mark)
		table.insert(
			opts,
			"Totem   : " .. target:getTotemName(target.totem) .. " (Id: " .. target.totem .. ")"
		)

		menu = player:menuSeq(
			name .. "" .. text .. "\nWhat do you wish to change?",
			opts,
			{}
		)

		if menu == 1 then
			path = {"Peasant", "Warrior", "Rogue", "Mage", "Poet"}
			pathchoice = player:menuSeq(
				"<b>[" .. target.name .. "'s Path]\n\nChange Path to what?",
				path,
				{}
			)

			target:updatePath(pathchoice - 1)
			target:status()
			target:sendMinitext("Path changed to " .. target.classNameMark .. "")
			player:sendMinitext("Done!!")
		elseif menu == 2 then
			-- Specialization
			if target.baseClass == 1 then
				spec = {"None", "Chung ryong", "Barbarian", "Chongun", "Do"}
			end
			if target.baseClass == 2 then
				spec = {"None", "Baekho", "Merchant", "Ranger", "Spy"}
			end
			if target.baseClass == 3 then
				spec = {"None", "Ju jak", "Diviner", "Geomancer", "Shaman"}
			end
			if target.baseClass == 4 then
				spec = {"None", "Hyun moo", "Druid", "Monk", "Muse"}
			end
			specchoice = player:menuSeq(
				"<b>[" .. target.name .. "'s Specialization]\nChange Sub path to what?",
				spec,
				{}
			)
			if specchoice == 1 then
				--target.class = target.baseClass
				target:updatePath(target.baseClass, target.mark)
				target:status()
				target:sendMinitext("Path changed to " .. target.classNameMark .. "")
				player:sendMinitext("Done!!")
			elseif specchoice == 2 then
				target:updatePath(target.baseClass + 5, target.mark)
				target:status()
				target:sendMinitext("Path changed to " .. target.classNameMark .. "")
				player:sendMinitext("Done!!")
			elseif specchoice == 3 then
				target:updatePath(target.baseClass + 9, target.mark)
				target:status()
				target:sendMinitext("Path changed to " .. target.classNameMark .. "")
				player:sendMinitext("Done!!")
			elseif specchoice == 4 then
				target:updatePath(target.baseClass + 13, target.mark)
				target:status()
				target:sendMinitext("Path changed to " .. target.classNameMark .. "")
				player:sendMinitext("Done!!")
			elseif specchoice == 5 then
				target:updatePath(target.baseClass + 17, target.mark)
				target:status()
				target:sendMinitext("Path changed to " .. target.classNameMark .. "")
				player:sendMinitext("Done!!")
			end
		elseif menu == 3 then
			-- Mark
			markChoice = {"base", "Il san", "Ee san", "Sam san", "Sa san"}
			markMenu = player:menuSeq(
				"<b>[" .. target.name .. "'s Mark]\n\nChange mark to?",
				markChoice,
				{}
			)
			if markMenu > 0 then
				target:updatePath(target.class, markMenu - 1)
				target:sendStatus()
				target:sendMinitext("Mark changed to " .. markChoice[markMenu] .. "!")
				player:sendMinitext("Done!!")
			end
		elseif menu == 4 then
			-- Totem
			totemChoice = {"Jujak", "Baekho", "Hyunmoo", "Chungryong"}
			totemMenu = player:menuSeq(
				"<b>[" .. target.name .. "'s Totem]\n\nChange totem to?",
				totemChoice,
				{}
			)
			if totemMenu > 0 then
				target.totem = totemMenu - 1
				target:sendStatus()
				target:sendMinitext("Totem changed to " .. target:totemName(target.totem) .. "!")
				player:sendMinitext("Done!!")
				click.totem_subpath_grade(player, target, npc)
			end
		end
	end,

	message = function(player, target)
		local types = ""
		local name = "<b>[Send Message]\n\n"
		player.dialogType = 0

		local opts = {
			"Minitext",
			"PopUp",
			"Blue (Whisper)",
			"Yellow (System)",
			"Orange (Advice)",
			"Grey (Sage)"
		}
		menu = player:menuSeq(
			name .. "What type of message would you send to target?",
			opts,
			{}
		)
		player.registry["message_type"] = menu
		if player.registry["message_type"] == 1 then
			types = "Minitext"
		end
		if player.registry["message_type"] == 2 then
			types = "PopUP"
		end
		if player.registry["message_type"] == 3 then
			types = "Whisper"
		end
		if player.registry["message_type"] == 4 then
			types = "System"
		end
		if player.registry["message_type"] == 5 then
			types = "Advice"
		end
		if player.registry["message_type"] == 6 then
			types = "Sage"
		end

		local text = player:input(name .. "Type : " .. types .. "\n\nText :")
		if player.registry["message_type"] == 1 then
			target:sendMinitext("" .. text .. "")
		elseif player.registry["message_type"] == 2 then
			target:popUp("" .. text .. "")
		elseif player.registry["message_type"] == 3 then
			target:msg(0, "" .. text .. "", target.ID)
		elseif player.registry["message_type"] == 4 then
			target:msg(4, "" .. text .. "", target.ID)
		elseif player.registry["message_type"] == 5 then
			target:msg(12, "" .. text .. "", target.ID)
		elseif player.registry["message_type"] == 6 then
			target:msg(11, "" .. text .. "", target.ID)
		end
		player:sendMinitext("Done!!")
		click.message(player, target)
	end,

	-- JUSTICE ------------------------------------------------------------------------------------------------------------------------------

	justice = function(player, target, npc)
		local user = player:getUsers()
		local name = "<b>[Justice]\n\n"
		player.dialogType = 0
		local opts = {}
		table.insert(opts, "Bot Check")
		if target.mute == false then
			table.insert(opts, "Silence")
		else
			table.insert(opts, "Unmute/unsilence")
		end
		table.insert(opts, "Jail")
		table.insert(opts, "Kick/disconnect")
		if target.registry["lock"] == 1 then
			table.insert(opts, "Unlock")
		else
			table.insert(opts, "Lock")
		end
		table.insert(opts, "Ban")
		table.insert(opts, "Minigame Ban")

		menu = player:menuString(
			name .. "What punishment would you give to target?",
			opts
		)

		if menu ~= nil then
			if menu == "Bot Check" then
				botcheck.init(target)
			elseif menu == "Silence" and target.mute == false then
				target.mute = true
				target:sendMinitext("You has been silenced!")
				broadcast(
					-1,
					"[Judgements] " .. target.name .. " has been silenced!"
				)
				player:sendMinitext("Done!!")
			elseif menu == "Unmute/unsilence" and target.mute == true then
				target.mute = false
				player:sendMinitext("Done!!")
			elseif menu == "Jail" then
				local cell = math.random(1, 4)

				if cell == 1 then
					target:warp(666, math.random(1, 5), math.random(3, 5))
				elseif cell == 2 then
					target:warp(666, math.random(1, 5), math.random(10, 13))
				elseif cell == 3 then
					target:warp(666, math.random(11, 15), math.random(4, 6))
				elseif cell == 4 then
					target:warp(666, math.random(11, 15), math.random(10, 12))
				end

				gmbroadcast(
					-1,
					"*** " .. target.name .. " has been jailed! ***"
				)
				player:sendMinitext("Done!!")
			elseif menu == "Kick/disconnect" then
				player:speak("/kill " .. target.name, 0)
				player:popUp("" .. target.name .. " has been disconnected.")
			elseif menu == "Unlock" then
				target.registry["lock"] = 0
				target:unlock()
				target:msg(4, "[Judgements] Character unlocked!!", target.ID)
				player:sendMinitext("Done!!")
			elseif menu == "Lock" then
				target.registry["lock"] = 1
				target:lock()
				target:msg(
					4,
					"[Judgements] Your character has locked by GM - " .. player.name .. "!!",
					target.ID
				)
				player:sendMinitext("Done!!")
			elseif menu == "Ban" then
				local confirm = player:menuString(
					"Which type of ban?",
					{"Char ban", "Account ban"}
				)

				if confirm == "Char ban" then
					player:speak("/ban " .. target.name, 0)
					player:popUp("You have banned " .. target.name .. " from the game.")
				elseif confirm == "Account ban" then
					target:setAccountBan(1)

					-- disconnects character along with all account chars (if applicable). sets to banned all chars
					player:popUp("You have banned " .. target.name .. " and their account from the game.")
				end
			elseif menu == "Minigame Ban" then
				local confirm = player:menuString(
					"How long for the minigame ban?",
					{"1 week", "2 weeks"},
					{}
				)
				if confirm == 1 then
					-- 1 week
					target.registry["minigameBan"] = os.time() + 604800
					target:popUp("You have been banned from minigames for 1 week.")
				elseif confirm == 2 then
					-- 2 weeks
					target.registry["minigameBan"] = os.time() + 1209600
					target:popUp("You have been banned from minigames for 2 weeks.")
				end

				if confirm ~= 0 then
					player:sendMinitext("Done!!")
				end
			end
		end
	end,

	--REWARDS------------------------------------------------------------------------------------------------------------------

	rewards = function(player, target, npc)
		local user = player:getUsers()
		local name = "<b>[Rewards]\n\n"
		player.dialogType = 0
		local opts = {}

		table.insert(opts, "Bug Finder Legend")
		table.insert(opts, "GM Assist Legend")

		menu = player:menuString(
			name .. "What reward would you give to target?",
			opts
		)

		if menu == "Bug Finder Legend" then
			gm_click.bug_legend(target, player)
		elseif menu == "GM Assist Legend" then
			gm_click.gmassist_legend(target, player)
		end
	end,

	bug_legend = function(player, gm)
		local reg = player.registry["bugs_found"]

		finishedQuest(player)
		if player:hasLegend("bugfinder") then
			player:removeLegendbyName("bugfinder")
		end

		if reg > 0 then
			player.registry["bugs_found"] = player.registry["bugs_found"] + 1
			player:addLegend(
				"Recognized for finding " .. player.registry["bugs_found"] .. " bugs in RetroTK",
				"bugfinder",
				213,
				244
			)
		else
			player.registry["bugs_found"] = 1
			player:addLegend(
				"Recognized for finding 1 bug in RetroTK",
				"bugfinder",
				213,
				244
			)
		end

		player:msg(
			0,
			"<GM> " .. gm.name .. " has rewarded you with a bugfinder legend mark!",
			player.ID
		)
	end,

	gmassist_legend = function(player, gm)
		local reg = player.registry["gm_assist"]

		finishedQuest(player)
		if player:hasLegend("gmassist") then
			player:removeLegendbyName("gmassist")
		end

		if reg > 0 then
			player.registry["gm_assist"] = player.registry["gm_assist"] + 1
			player:addLegend(
				"Assisted the RetroTK GMs " .. player.registry["gm_assist"] .. " times",
				"gmassist",
				145,
				226
			)
		else
			player.registry["gm_assist"] = 1
			player:addLegend(
				"Assisted the RetroTK GMs 1 time",
				"gmassist",
				145,
				226
			)
		end

		player:msg(
			0,
			"<GM> " .. gm.name .. " has rewarded you with a GM assist legend mark!",
			player.ID
		)
	end,

	--------------------------------------------------------------------------------------------------------------------------------

	inventory = function(player, target, npc)
		local name = "<b>[" .. target.name .. "'s Inventory]\n\n"
		local t = {graphic = convertGraphic(809, "monster"), color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local items, amount, itemName, itemEngrave, itemDura, itemOwner, itemTime = {}, {}, {}, {}, {}, {}, {}
		local id, info, found

		info = "   Gold  : " .. Tools.formatNumber(target.money) .. "\n   Bank  : " .. Tools.formatNumber(target.bankMoney) .. "\n\n<b>-> Total : " .. Tools.formatNumber(target.money + target.bankMoney) .. " coins\n"

		for i = 0, target.maxInv do
			id = target:getInventoryItem(i)
			if id ~= nil then
				table.insert(items, id.id)
				table.insert(amount, id.amount)
				table.insert(itemName, id.name)
				table.insert(itemEngrave, id.realName)
				table.insert(itemDura, id.dura)
				table.insert(itemOwner, id.owner)
				table.insert(itemTime, id.time)
			end
		end

		if #items == 0 then
			player:dialogSeq(
				{name .. "Target's inventory is currently empty!"},
				1
			)
			player:freeAsync()
			gm_click.menu(player, target, npc)
			return
		else
			menu = player:buy(
				name .. "" .. info,
				items,
				amount,
				itemName,
				{},
				{},
				{},
				{}
			)
			if menu ~= nil then
				for i = 1, #items do
					if itemName[i] == menu then
						found = i
						break
					end
				end

				local icon = {
					graphic = Item(items[found]).icon,
					color = Item(items[found]).iconC
				}
				player.npcGraphic = icon.graphic
				player.npcColor = icon.color
				player.dialogType = 0

				info = "Item name: " .. Item(items[found]).name .. "\n"
				info = info .. "Amount   : " .. amount[found] .. "\n"

				--info =       "Type     : "..Item(items[found]).type.."("..getItemType(items[found])..")\n"

				test = {"Take item", "Delete item", "<< Back"}
				choice = player:menuSeq(name .. "" .. info, test, {})

				if choice == 1 then
					if target:hasItem(items[found], amount[found]) then
						if amount[found] > 1 then
							num = math.abs(tonumber(math.floor(player:input(name .. "How many " .. Item(items[found]).name .. " (" .. amount[found] .. ")?"))))
							if num > 0 then
								if num >= amount[found] then
									num = amount[found]
								end
								if target:hasItem(items[found], num) == true then
									target:removeItem(items[found], num)
									player:addItem(items[found], num)
								else
									player:dialogSeq(
										{
											icon,
											name .. "Item has been removed from target!"
										},
										1
									)
									click.inventory(player, target, npc)
								end
							end
						else
							target:removeItem(items[found], amount[found])
							player:addItem(
								items[found],
								amount[found],
								itemDura[found],
								itemOwner[found],
								itemTime[found],
								itemEngrave[found]
							)
						end
						player:sendMinitext("Done!!")
						gm_click.inventory(player, target, npc)
					else
						player:dialogSeq(
							{icon, name .. "Item has been removed from target!"},
							1
						)
						gm_click.inventory(player, target, npc)
					end
				elseif choice == 2 then
					if target:hasItem(items[found], amount[found]) then
						target:removeItem(items[found], amount[found])
						player:addItem(items[found], amount[found])
						player:sendMinitext("Done!!")
						gm_click.inventory(player, target, npc)
					else
						player:dialogSeq(
							{icon, name .. "Item has been removed from target!"},
							1
						)
						gm_click.inventory(player, target, npc)
					end
				elseif choice == 3 then
					gm_click.inventory(player, target, npc)
				end
			end
		end
	end,

	--------------------------------------------------------------------------------------------------------------------------------

	status = function(player, target, npc, dialog)
		local titlestats, stats, info = "", "", ""
		if target.registry["show_title"] == 0 then
			titlestats = "Hide"
		else
			titlestats = "Show"
		end
		player.dialogType = 0
		if target.PK == 1 then
			stats = "ON"
		else
			stats = "OFF"
		end
		local fury = target.fury
		local enchant = target.enchant
		local rage = target.rage
		local add = 1
		local stat = {}
		local armorBonus = 0
		local mightBonus = 0
		local graceBonus = 0
		local willBonus = 0
		local vitaBonus = 0
		local manaBonus = 0

		local minWeaponDam = 0
		local maxWeaponDam = 0
		local avgWeaponDamage = 0

		local might = target.might
		local grace = target.grace
		local will = target.will

		local weap = target:getEquippedItem(0)
		local armor = target:getEquippedItem(1)
		local shield = target:getEquippedItem(2)
		local helm = target:getEquippedItem(3)
		local left = target:getEquippedItem(4)
		local right = target:getEquippedItem(5)
		local script1 = target:getEquippedItem(6)
		local script2 = target:getEquippedItem(7)
		local facea = target:getEquippedItem(8)
		local crown = target:getEquippedItem(9)
		local mantle = target:getEquippedItem(10)
		local necklace = target:getEquippedItem(11)
		local boots = target:getEquippedItem(12)
		local coat = target:getEquippedItem(13)

		if weap ~= nil then
			weaponName = weap.name
			maxWeaponDam = weap.maxSDmg
			minWeaponDam = weap.minSDmg

			armorBonus = armorBonus + weap.ac
			mightBonus = mightBonus + weap.might
			graceBonus = graceBonus + weap.grace
			willBonus = willBonus + weap.will
			vitaBonus = vitaBonus + weap.vita
			manaBonus = manaBonus + weap.mana
			avgWeaponDamage = (minWeaponDam + maxWeaponDam) / 2
		else
			weaponName = "Unarmed"
			maxWeaponDam = 1
			minWeaponDam = 1
			avgWeaponDamage = (minWeaponDam + maxWeaponDam) / 2
		end

		if armor ~= nil then
			armorName = armor.name
			armorBonus = armorBonus + armor.ac
			mightBonus = mightBonus + armor.might
			graceBonus = graceBonus + armor.grace
			willBonus = willBonus + armor.will
			vitaBonus = vitaBonus + armor.vita
			manaBonus = manaBonus + armor.mana
		else
			armorName = "None"
		end

		if shield ~= nil then
			shieldName = shield.name
			armorBonus = armorBonus + shield.ac
			mightBonus = mightBonus + shield.might
			graceBonus = graceBonus + shield.grace
			willBonus = willBonus + shield.will
			vitaBonus = vitaBonus + shield.vita
			manaBonus = manaBonus + shield.mana
		else
			shieldName = "None"
		end

		if helm ~= nil then
			helmName = helm.name
			armorBonus = armorBonus + helm.ac
			mightBonus = mightBonus + helm.might
			graceBonus = graceBonus + helm.grace
			willBonus = willBonus + helm.will
			vitaBonus = vitaBonus + helm.vita
			manaBonus = manaBonus + helm.mana
		else
			helmName = "None"
		end

		if left ~= nil then
			leftName = left.name
			armorBonus = armorBonus + left.ac
			mightBonus = mightBonus + left.might
			graceBonus = graceBonus + left.grace
			willBonus = willBonus + left.will
			vitaBonus = vitaBonus + left.vita
			manaBonus = manaBonus + left.mana
		else
			leftName = "None"
		end

		if right ~= nil then
			rightName = right.name
			armorBonus = armorBonus + right.ac
			mightBonus = mightBonus + right.might
			graceBonus = graceBonus + right.grace
			willBonus = willBonus + right.will
			vitaBonus = vitaBonus + right.vita
			manaBonus = manaBonus + right.mana
		else
			rightName = "None"
		end

		if script1 ~= nil then
			script1Name = script1.name
			armorBonus = armorBonus + script1.ac
			mightBonus = mightBonus + script1.might
			graceBonus = graceBonus + script1.grace
			willBonus = willBonus + script1.will
			vitaBonus = vitaBonus + script1.vita
			manaBonus = manaBonus + script1.mana
		else
			script1Name = "None"
		end

		if script2 ~= nil then
			script2Name = script2.name
			armorBonus = armorBonus + script2.ac
			mightBonus = mightBonus + script2.might
			graceBonus = graceBonus + script2.grace
			willBonus = willBonus + script2.will
			vitaBonus = vitaBonus + script2.vita
			manaBonus = manaBonus + script2.mana
		else
			script2Name = "None"
		end

		if mantle ~= nil then
			mantleName = mantle.name
			armorBonus = armorBonus + mantle.ac
			mightBonus = mightBonus + mantle.might
			graceBonus = graceBonus + mantle.grace
			willBonus = willBonus + mantle.will
			vitaBonus = vitaBonus + mantle.vita
			manaBonus = manaBonus + mantle.mana
		else
			mantleName = "None"
		end

		if necklace ~= nil then
			necklaceName = necklace.name
			armorBonus = armorBonus + necklace.ac
			mightBonus = mightBonus + necklace.might
			graceBonus = graceBonus + necklace.grace
			willBonus = willBonus + necklace.will
			vitaBonus = vitaBonus + necklace.vita
			manaBonus = manaBonus + necklace.mana
		else
			necklaceName = "None"
		end

		if boots ~= nil then
			bootsName = boots.name
			armorBonus = armorBonus + boots.ac
			mightBonus = mightBonus + boots.might
			graceBonus = graceBonus + boots.grace
			willBonus = willBonus + boots.will
			vitaBonus = vitaBonus + boots.vita
			manaBonus = manaBonus + boots.mana
		else
			bootsName = "None"
		end
		if crown ~= nil then
			crownName = crown.name
			armorBonus = armorBonus + crown.ac
			mightBonus = mightBonus + crown.might
			graceBonus = graceBonus + crown.grace
			willBonus = willBonus + crown.will
			vitaBonus = vitaBonus + crown.vita
			manaBonus = manaBonus + crown.mana
		else
			crownName = "None"
		end
		if facea ~= nil then
			faceaName = facea.name
			armorBonus = armorBonus + facea.ac
			mightBonus = mightBonus + facea.might
			graceBonus = graceBonus + facea.grace
			willBonus = willBonus + facea.will
			vitaBonus = vitaBonus + facea.vita
			manaBonus = manaBonus + facea.mana
		else
			faceaName = "None"
		end
		if mantle ~= nil then
			mantleName = mantle.name
			armorBonus = armorBonus + mantle.ac
			mightBonus = mightBonus + mantle.might
			graceBonus = graceBonus + mantle.grace
			willBonus = willBonus + mantle.will
			vitaBonus = vitaBonus + mantle.vita
			manaBonus = manaBonus + mantle.mana
		else
			mantleName = "None"
		end

		--------------------------------------
		--// End Equip Stat Bonus Total Calc--
		--------------------------------------

		local physicalDamageReductionPct = ((target.armor / (target.armor + 500)) * 100)
		local bareHandDamage = 0

		if weap == nil then
			-- You do not have a Weapon equiped, damage is bare handed.
			finalDamage = bareHandDamage
		end

		-- You DO have a weapon equiped.

		finalWeaponDamage = 0
		finalDamage = bareHandDamage + finalWeaponDamage

		if target.heroShow == 1 then
			a = "On"
		elseif target.heroShow == 0 then
			a = "Off"
		end

		local currentMagic = target.magic
		local maxMagic = target.maxMagic
		local nakedMagic = target.baseMagic

		local currentLife = target.health
		local maxLife = target.maxHealth
		local nakedLife = target.baseHealth

		currentLifePct = currentLife / maxLife * 100

		-- decimal form of life Pct remaining
		currentManaPct = currentMagic / maxMagic * 100

		-- decimal form of mana Pct remaining

		------------------------------------------------------------
		--Draw Table------------------------------------------------
		------------------------------------------------------------
		table.insert(stat, "+====================================+")
		table.insert(stat, "            Name: " .. target.name)
		table.insert(stat, "           Class: " .. getPathName(target))
		table.insert(
			stat,
			"           Title: " .. target.title .. " (" .. titlestats .. ")"
		)
		table.insert(stat, "           Level: " .. target.level)
		table.insert(stat, "          Status: " .. target.state)
		table.insert(stat, "         PK Flag: " .. stats)
		table.insert(stat, "           Speed: " .. target.speed)

		if target.gmLevel > 0 then
			table.insert(stat, "           GM LVL: " .. target.gmLevel)
		end

		table.insert(stat, "+====================================+")
		table.insert(
			stat,
			"          Nation: " .. target:countryName(target.country)
		)
		table.insert(stat, "            Clan: " .. target.clanName)
		table.insert(stat, "      Clan Title: " .. target.title)
		table.insert(
			stat,
			"           Totem: " .. target:getTotemName(target.totem)
		)
		table.insert(
			stat,
			"           Karma: " .. target:karmaLevel(target.karma)
		)
		table.insert(stat, "       Alignment:")
		table.insert(stat, "+====================================+")
		table.insert(stat, "")

		--[[
	-- increments every 5%,  XP vs. TNL
	if target.tnl ==  0 then
	table.insert(stat, "      |--------------------|")
	end
	if target.tnl >= 1 and target.tnl < 6 then
	table.insert(stat, "      |*-------------------|")
	end
	if target.tnl >= 6 and target.tnl < 11 then
	table.insert(stat, "      |**------------------|")
	end
	if target.tnl >= 11 and target.tnl < 16 then
	table.insert(stat, "      |***-----------------|")
	end
	if target.tnl >= 16 and target.tnl < 21 then
	table.insert(stat, "      |****----------------|")
	end
	if target.tnl >= 21 and target.tnl < 26 then
	table.insert(stat, "      |*****---------------|")
	end
	if target.tnl >= 26 and target.tnl < 31 then
	table.insert(stat, "      |******--------------|")
	end
	if target.tnl >= 31 and target.tnl < 36 then
	table.insert(stat, "      |*******-------------|")
	end
	if target.tnl >= 36 and target.tnl < 41 then
	table.insert(stat, "      |********------------|")
	end
	if target.tnl >= 41 and target.tnl < 46 then
	table.insert(stat, "      |*********-----------|")
	end
	if target.tnl >= 46 and target.tnl < 51 then
	table.insert(stat, "      |**********----------|")
	end
	if target.tnl >= 51 and target.tnl < 56 then
	table.insert(stat, "      |***********---------|")
	end
	if target.tnl >= 56 and target.tnl < 61 then
	table.insert(stat, "      |************--------|")
	end
	if target.tnl >= 61 and target.tnl < 66 then
	table.insert(stat, "      |*************-------|")
	end
	if target.tnl >= 66 and target.tnl < 71 then
	table.insert(stat, "      |**************------|")
	end
	if target.tnl >= 71 and target.tnl < 76 then
	table.insert(stat, "      |***************-----|")
	end
	if target.tnl >= 76 and target.tnl < 81 then
	table.insert(stat, "      |****************----|")
	end
	if target.tnl >= 81 and target.tnl < 86 then
	table.insert(stat, "      |*****************---|")
	end
	if target.tnl >= 86 and target.tnl < 91 then
	table.insert(stat, "      |******************--|")
	end
	if target.tnl >= 91 and target.tnl < 96 then
	table.insert(stat, "      |*******************-|")
	end
	if target.tnl >= 96 then
	table.insert(stat, "      |********************|")
	end
	]]
		--
		table.insert(stat, "")
		displayEXP = target.exp
		displayTNL = target.realtnl

		--table.insert(stat, "             Exp: "..displayEXP)
		--table.insert(stat, "             TNL: "..displayTNL.." ("..target.tnl.."%)")
		table.insert(stat, "+====================================+")
		table.insert(stat, "           Coins: " .. target.money)
		table.insert(stat, "           Kan: " .. target.registry["kan"])
		table.insert(stat, "+====================================+")
		table.insert(stat, "          | Base Stats |")
		table.insert(stat, "          +------------+")
		table.insert(stat, "")

		-- A life bar, increments every 10%,  need curret vita / max vita
		if currentLifePct < 0 then
			table.insert(stat, " |----------|")
		end
		if currentLifePct > 0 and currentLifePct < 11 then
			table.insert(stat, " |*---------|")
		end
		if currentLifePct > 10 and currentLifePct < 21 then
			table.insert(stat, " |**--------|")
		end
		if currentLifePct > 20 and currentLifePct < 31 then
			table.insert(stat, " |***-------|")
		end
		if currentLifePct > 30 and currentLifePct < 41 then
			table.insert(stat, " |****------|")
		end
		if currentLifePct > 40 and currentLifePct < 51 then
			table.insert(stat, " |*****-----|")
		end
		if currentLifePct > 50 and currentLifePct < 61 then
			table.insert(stat, " |******----|")
		end
		if currentLifePct > 60 and currentLifePct < 71 then
			table.insert(stat, " |*******---|")
		end
		if currentLifePct > 70 and currentLifePct < 81 then
			table.insert(stat, " |********--|")
		end
		if currentLifePct > 80 and currentLifePct < 91 then
			table.insert(stat, " |*********-|")
		end
		if currentLifePct > 90 and currentLifePct < 101 then
			table.insert(stat, " |**********|")
		end

		lifePct = currentLifePct

		table.insert(
			stat,
			"    Current Vita: " .. currentLife .. " (" .. lifePct .. "%)"
		)
		table.insert(stat, "       Base Vita: " .. nakedLife)
		table.insert(stat, "  +  Equip Bonus: " .. vitaBonus)
		table.insert(stat, "  ================================")
		table.insert(stat, "  =     Max Vita: " .. maxLife)
		table.insert(stat, "")
		table.insert(stat, "  VitaRegen Rate: N/A")
		table.insert(stat, "+====================================+")
		table.insert(stat, "")

		-- A mana bar, increments every 10%,  need curret mana / max mana

		if currentManaPct < 0 then
			table.insert(stat, " |          |")
		end
		if currentManaPct > 0 and currentManaPct < 11 then
			table.insert(stat, " |#         |")
		end
		if currentManaPct > 10 and currentManaPct < 21 then
			table.insert(stat, " |##        |")
		end
		if currentManaPct > 20 and currentManaPct < 31 then
			table.insert(stat, " |###       |")
		end
		if currentManaPct > 30 and currentManaPct < 41 then
			table.insert(stat, " |####      |")
		end
		if currentManaPct > 40 and currentManaPct < 51 then
			table.insert(stat, " |#####     |")
		end
		if currentManaPct > 50 and currentManaPct < 61 then
			table.insert(stat, " |######    |")
		end
		if currentManaPct > 60 and currentManaPct < 71 then
			table.insert(stat, " |#######   |")
		end
		if currentManaPct > 70 and currentManaPct < 81 then
			table.insert(stat, " |########  |")
		end
		if currentManaPct > 80 and currentManaPct < 91 then
			table.insert(stat, " |######### |")
		end
		if currentManaPct > 90 and currentManaPct < 101 then
			table.insert(stat, " |##########|")
		end

		manaPct = currentManaPct

		displayManaPct = round(manaPct)

		table.insert(
			stat,
			"    Current Mana: " .. currentMagic .. " (" .. displayManaPct .. "%)"
		)
		table.insert(stat, "       Base Mana: " .. nakedMagic)
		table.insert(stat, "  +  Equip Bonus: " .. manaBonus)
		table.insert(stat, "  =================================")
		table.insert(stat, "        Max Mana: " .. maxMagic)
		table.insert(stat, "")
		table.insert(stat, "  ManaRegen Rate: N/A")
		table.insert(stat, "+====================================+")
		table.insert(stat, "     Total Might: " .. target.might)
		table.insert(stat, "      Base Might: " .. target.baseMight)
		table.insert(stat, "   + Equip Bonus: " .. mightBonus)
		table.insert(stat, "")
		table.insert(stat, "+====================================+")
		table.insert(stat, "      Total Will: " .. target.will)
		table.insert(stat, "       Base Will: " .. target.baseWill)
		table.insert(stat, "   + Equip Bonus: " .. willBonus)
		table.insert(stat, "")
		table.insert(stat, "+====================================+")
		table.insert(stat, "     Total Grace: " .. target.grace)
		table.insert(stat, "      Base Grace: " .. target.baseGrace)
		table.insert(stat, "   + Equip Bonus: " .. graceBonus)
		table.insert(stat, "")
		table.insert(stat, "+====================================+")
		table.insert(stat, "    Total  Armor: " .. target.armor)
		table.insert(stat, "   + Equip Bonus: " .. armorBonus)
		table.insert(stat, "      Base Armor: " .. target.baseArmor)
		table.insert(stat, "")
		table.insert(stat, "+====================================+")
		table.insert(stat, "         |  Criticals |")
		table.insert(stat, "         +------------+")
		table.insert(stat, "")
		table.insert(stat, "+====================================+")
		table.insert(stat, "         |Damage Output|")
		table.insert(stat, "         +-------------+")
		table.insert(stat, "")
		table.insert(stat, " Bare Handed Dam: " .. math.floor(bareHandDamage))
		table.insert(stat, "    Equipped Dam: " .. math.floor(finalDamage))
		table.insert(stat, "")
		table.insert(stat, "")
		table.insert(stat, "     Fury Multiplier: x" .. target.fury)
		table.insert(stat, "  Enchant Multiplier: x" .. target.enchant)
		table.insert(stat, "  	 Rage Multiplier: x" .. target.rage)
		table.insert(stat, "+====================================+")
		table.insert(stat, "           |  Equipment |")
		table.insert(stat, "           +------------+")
		table.insert(stat, "      Weapon: " .. weaponName)
		table.insert(stat, "      Helmet: " .. helmName)
		table.insert(stat, "    Necklace: " .. necklaceName)
		table.insert(stat, "      Shield: " .. shieldName)
		table.insert(stat, "  Body Armor: " .. armorName)
		table.insert(stat, "   Left Hand: " .. leftName)
		table.insert(stat, "  Right Hand: " .. rightName)
		table.insert(stat, "       Boots: " .. bootsName)
		table.insert(stat, "    Left Sub: " .. script1Name)
		table.insert(stat, "   Right Sub: " .. script2Name)
		table.insert(stat, "      Mantle: " .. mantleName)
		table.insert(stat, "       Crown: " .. crownName)
		table.insert(stat, "    Face Acc: " .. faceaName)
		table.insert(stat, "      Mantle: " .. mantleName)
		table.insert(stat, "+====================================+")
		table.insert(
			stat,
			"  Exp sold for Vita  : " .. Tools.formatNumber(target.expSoldHealth)
		)
		table.insert(
			stat,
			"  Exp sold for Mana  : " .. Tools.formatNumber(target.expSoldMagic)
		)
		table.insert(
			stat,
			"  Exp sold for Stats : " .. Tools.formatNumber(target.expSoldStats)
		)
		table.insert(
			stat,
			"  Total Exp Sold: " .. Tools.formatNumber(target.expSoldHealth + target.expSoldMagic + target.expSoldStats)
		)
		table.insert(stat, "")
		table.insert(stat, "  Heroes Display: " .. a)
		table.insert(stat, "")
		table.insert(stat, "             +--------+")
		table.insert(stat, "             |<< Back |")
		table.insert(stat, "             +--------+")
		table.insert(stat, "+====================================+")

		menu = player:menuString(dialog, stat)

		if menu ~= nil then
			-----------------------------------
			-- The Back Button
			-----------------------------------

			-----------------------------------
			-- Change "State"
			-----------------------------------
			if menu == "           Class: " .. target.className then
				--change.status(player, target, npc, "class")
			elseif menu == "           Title: " .. target.title .. " (" .. titlestats .. ")" then
				--change.status(player, target, npc, "title")
			elseif menu == "           Level: " .. target.level then
				--change.choice(player, target, npc, "level")
			elseif menu == "          Status: " .. target.state then
				text = "<b>[" .. target.name .. "'s State]\n\n"
				text = text .. "State 0 = Alive\n"
				text = text .. "State 1 = Death\n"
				text = text .. "State 2 = Invisible\n"
				text = text .. "State 3 = Mounted\n"
				text = text .. "State 4 = Disguised"
				state = player:input(text)
				if tonumber(state) < 0 or tonumber(state) > 5 then
					anim(player)
					player:sendMinitext("Invalid state number!")
					gm_click.status(player, target, npc, dialog)
					return
				elseif tonumber(state) >= 0 and tonumber(state) < 5 then
					target.state = tonumber(state)
					target:updateState()
					target:sendMinitext("State : " .. target.state)
					player:sendMinitext("Done!!")
					gm_click.status(player, target, npc, dialog)
				end
			elseif menu == "         PK Flag: " .. stats then
				PKstatus = {}
				if target.PK == 0 then
					table.insert(PKstatus, "ON")
				else
					table.insert(PKstatus, "OFF")
				end
				table.insert(PKstatus, "<< Back")
				switch = player:menuString(
					"<b>[" .. target.name .. "'s PK Status]\n\n",
					PKstatus
				)
				if switch == "<< Back" then
					player:freeAsync()
					gm_click.status(player, target, npc, dialog)
					return
				else
					if switch == "ON" then
						target.PK = 1
					elseif switch == "OFF" then
						target.PK = 0
					end
					target:refresh()
					target:sendMinitext("PK Status : " .. stats)
					player:sendMinitext("Done!!")
					player:freeAsync()
					gm_click.status(player, target, npc, dialog)
				end
			elseif menu == "           Speed: " .. target.speed then
				change.choice(player, target, npc, "speed")

				--elseif menu == " GM LVL: "..target.gmLevel and player.ID == 2 or player.ID == 4 then
				--change.choice(player, target, npc, "gmLevel")

				--elseif menu == "Nation   : "..target:countryName(target.country) then
				--change.status(player, target, npc, "country")
			elseif menu == "            Clan: " then
				--clan.getInfo(player, target, npc, "clan")

				--elseif menu == "Clan Title : "..target.clan then
				--clan.changeTitle(player, target, npc, "clanTitle")
			elseif menu == "           Totem: " .. target:getTotemName(target.totem) then
				--change.status(player, target, npc, "totem")

				--elseif menu == "      Karma: " then

				--elseif menu == "      Alignment: " then
			elseif menu == "             Exp: " .. displayEXP then
				change.choice(player, target, npc, "exp")
			elseif menu == "           Coins: " .. target.money then
				change.choice(player, target, npc, "gold")
			elseif menu == "           Kan: " .. target.registry["kan"] then
				--change.choice(player, target, npc, "lapis")
			elseif menu == "       Base Vita: " .. target.baseHealth then
				--change.choice(player, target, npc, "vita")
			elseif menu == "       Base Mana: " .. target.baseMagic then
				--change.choice(player, target, npc, "mana")
			elseif menu == "      Base Might: " .. target.baseMight then
				--change.choice(player, target, npc, "might")
			elseif menu == "       Base Will: " .. target.baseWill then
				--change.choice(player, target, npc, "will")
			elseif menu == "      Base Grace: " .. target.baseGrace then
				--change.choice(player, target, npc, "grace")
			elseif menu == "      Base Armor: " .. target.baseArmor then
				--change.choice(player, target, npc, "armor")
			elseif menu == "  Fury Multiplier: x" .. target.fury then
				--change.choice(player, target, npc, "fury")
			elseif menu == "  Heroes Display: " .. a then
				if target.heroShow == 1 then
					target:setHeroShow(0)
					player:sendMinitext("" .. target.name .. " is now hidden on the Heroes List")
				elseif target.heroShow == 0 then
					target:setHeroShow(1)
					player:sendMinitext("" .. target.name .. " is now visible on the Heroes List")
				end
			else
				player:freeAsync()
				gm_click.status(player, target, npc, dialog)
			end
		end
	end,

	look = function(player, target, npc)
		local gfx = ""
		if target.gfxClone == 0 then
			gfx = "Off"
		else
			gfx = "On"
		end
		local dialog = "State      : " .. target.state .. "\nGfx Toogle : " .. gfx .. "\n\nWhat type of look?"
		menu = player:menuString(
			"<b>[" .. target.name .. "'s look]\n\n" .. dialog,
			{
				"Character's look",
				"Disguised look",
				"Mounted look",
				"Gfx toggle (On/Off)",
				"<< Back"
			}
		)

		if menu == "Character's look" then
			charl = player:menuString(
				"<b>[" .. target.name .. "'s look]\n\n" .. dialog,
				{"Hair style", "Face surgery", "Skin color", "<< Back"}
			)
			if charl == "Hair style" then
				npc.gfxHair = target.hair
				npc.gfxHairC = target.hairColor
				hair.option(player, target, npc)
			elseif charl == "Face surgery" then
				npc.gfxFace = target.face
				npc.gfxFaceC = target.faceColor
				face.option(player, target, npc)
			elseif charl == "Skin color" then
				npc.gfxSkin = target.skinColor
				skin.option(player, target, npc)
			elseif charl == "<< Back" then
				gm_click.look(player, target, npc)
			end
		elseif menu == "Disguised look" then
			player.registry["gfx_dis"] = target.disguise
			player.registry["gfx_disC"] = target.disguiseC
			disguisee.option(player, target)
		elseif menu == "Mounted look" then
			player:dialogSeq({"Not implemented yet"}, 1)
			gm_click.look(player, target, npc)
		elseif menu == "Gfx toogle (On/Off)" then
			gfx.option(player, target, npc)
		elseif menu == "<< Back" then
			player:freeAsync()
			gm_click.menu(player, target, npc)
		end
	end,

	f1click = async(function(player, npc, target)
		player.dialogType = 0
		local opts = {"Vending menu", "GM click menu", "Exit"}
		menu = player:menuString(
			"<b>[GM Menu]\n\nWhich menu do you needed from target?",
			opts
		)
		if menu == "Vending menu" then
			if target.registry["v_open"] > 0 and target:hasDuration("vending_menu") then
				if totalSaleItem(target) > 0 then
					player:freeAsync()
					vending_menu.showShop(player, target, npc)
				end
			end
		elseif menu == "GM click menu" then
			player:freeAsync()
			gm_click.menu(player, target, npc)
		end
	end)
}

getItemType = function(x)
	local i = Item(x)

	if i.type == 0 then
		return "Eat"
	end
	if i.type == 1 then
		return "Use"
	end
	if i.type == 2 then
		return "Smoke"
	end
	if i.type == 3 then
		return "Weapon"
	end
	if i.type == 4 then
		return "Armor"
	end
	if i.type == 5 then
		return "Shield"
	end
	if i.type == 6 then
		return "Helm"
	end
	if i.type == 7 then
		return "Left hand"
	end
	if i.type == 8 then
		return "Right hand"
	end
	if i.type == 9 then
		return "Left script"
	end
	if i.type == 10 then
		return "Right script"
	end
	if i.type == 11 then
		return "Face Acc"
	end
	if i.type == 12 then
		return "Crown"
	end
	if i.type == 13 then
		return "Mantle"
	end
	if i.type == 14 then
		return "Necklace"
	end
	if i.type == 15 then
		return "Boots"
	end
	if i.type == 16 then
		return "Coat"
	end
	if i.type == 18 then
		return "Mic"
	end
end
