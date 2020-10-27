add_script = {
	cast = function(player, question)
		local q = string.lower(player.question)

		if q ~= nil then
			if q == "c" then
				item = player:getObjectsInMap(player.m, BL_ITEM)
				player:talk(0, "#item : " .. #item .. " found")
				player:sendMinitext("#item : " .. #item .. " found")
				return
			elseif q == "s" then
				player:freeAsync()
				add_script.click(player, npc)
				return
			elseif q == "r" or tonumber(q) == 1 then
				player:dropItem(Item("red_script").id, 1)
			elseif q == "b" or tonumber(q) == 2 then
				player:dropItem(Item("blue_script").id, 1)
			elseif q == "g" or tonumber(q) == 3 then
				player:dropItem(Item("green_script").id, 1)
			elseif q == "y" or tonumber(q) == 4 then
				player:dropItem(Item("yellow_script").id, 1)
			elseif q == "p" or tonumber(q) == 5 then
				player:dropItem(Item("pink_script").id, 1)
			else
				player:msg(
					4,
					"===================== COMMANDS =====================",
					player.ID
				)
				player:msg(4, "'R' : put 'Red script' on ground", player.ID)
				player:msg(4, "'B' : put 'Blue script' on ground", player.ID)
				player:msg(4, "'G' : put 'Green script' on ground", player.ID)
				player:msg(4, "'Y' : put 'Yellow script' on ground", player.ID)
				player:msg(4, "'P' : put 'Pink script' on ground", player.ID)
				player:msg(
					4,
					"'C' : to count total items in this map",
					player.ID
				)
				player:msg(
					4,
					"'S' : Settings for each color of scripts",
					player.ID
				)
				player:msg(
					4,
					"====================================================",
					player.ID
				)
			end
		end
	end,

	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		clone.equip(player, npc)
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 2

		local red = player.registry["red_script"]
		local blue = player.registry["blue_script"]
		local green = player.registry["green_script"]
		local yellow = player.registry["yellow_script"]
		local pink = player.registry["pink_script"]
		if red > 0 then
			red_mob = Mob(red).name
		else
			red_mob = "None"
		end
		if blue > 0 then
			blue_mob = Mob(blue).name
		else
			blue_mob = "None"
		end
		if green > 0 then
			green_mob = Mob(green).name
		else
			green_mob = "None"
		end
		if yellow > 0 then
			yellow_mob = Mob(yellow).name
		else
			yellow_mob = "None"
		end
		if pink > 0 then
			pink_mob = Mob(pink).name
		else
			pink_mob = "None"
		end
		local opts = {}
		table.insert(opts, "Red Script    : " .. red_mob .. "(" .. red .. ")")
		table.insert(opts, "Blue Script   : " .. blue_mob .. "(" .. blue .. ")")
		table.insert(
			opts,
			"Green Script  : " .. green_mob .. "(" .. green .. ")"
		)
		table.insert(
			opts,
			"Yellow Script : " .. yellow_mob .. "(" .. yellow .. ")"
		)
		table.insert(opts, "Pink Script   : " .. pink_mob .. "(" .. pink .. ")")

		menu = player:menuString(
			"\nEnter mob id / yname for each script to spawn on their coordinate later.",
			opts
		)

		if menu == "Red Script    : " .. red_mob .. "(" .. red .. ")" then
			add_script.inputMob(player, "red", npc)
		elseif menu == "Blue Script   : " .. blue_mob .. "(" .. blue .. ")" then
			add_script.inputMob(player, "blue", npc)
		elseif menu == "Green Script  : " .. green_mob .. "(" .. green .. ")" then
			add_script.inputMob(player, "green", npc)
		elseif menu == "Yellow Script : " .. yellow_mob .. "(" .. yellow .. ")" then
			add_script.inputMob(player, "yellow", npc)
		elseif menu == "Pink Script   : " .. pink_mob .. "(" .. pink .. ")" then
			add_script.inputMob(player, "pink", npc)
		end
	end),

	inputMob = function(player, color, npc)
		local mob
		input = player:input("Enter mob id  :")
		if input ~= nil and Mob(input) ~= nil then
			mob = Mob(input)
		else
			player:popUp("Mob not found in database!")
			return
		end
		local g = {graphic = convertGraphic(mob.look, "monster"), mob.lookColor}
		if color == "red" then
			script = "Red script"
		elseif color == "blue" then
			script = "Blue script"
		elseif color == "green" then
			script = "Green script"
		elseif color == "yellow" then
			script = "Yellow script"
		elseif color == "pink" then
			script = "Pink script"
		end
		txt = "<b>[" .. script .. "]\n\n"
		txt = txt .. "Name : " .. mob.name .. "\n"
		txt = txt .. "Vita : " .. mob.maxHealth .. "\n"
		txt = txt .. "Experience : \n\n"
		player:dialogSeq({g, txt .. "'Next' to continue, 'Close' to exit."}, 1)
		if color == "red" then
			player.registry["red_script"] = mob.mobID
		elseif color == "blue" then
			player.registry["blue_script"] = mob.mobID
		elseif color == "green" then
			player.registry["green_script"] = mob.mobID
		elseif color == "yellow" then
			player.registry["yellow_script"] = mob.mobID
		elseif color == "pink" then
			player.registry["pink_script"] = mob.mobID
		else
			return nil
		end
		player:sendMinitext("Done!")
		return add_script.click(player, npc)
	end,

	clone = function(player, npc)
		local weap = player:getEquippedItem(EQ_WEAP)
		local coat = player:getEquippedItem(EQ_COAT)
		local armor = player:getEquippedItem(EQ_ARMOR)
		local helm = player:getEquippedItem(EQ_HELM)
		local crown = player:getEquippedItem(EQ_CROWN)
		local mantle = player:getEquippedItem(EQ_MANTLE)
		local shield = player:getEquippedItem(EQ_SHIELD)
		local boots = player:getEquippedItem(EQ_BOOTS)
		local facea = player:getEquippedItem(EQ_FACEACC)
		local neck = player:getEquippedItem(EQ_NECKLACE)

		if player.title ~= nil then
			npc.gfxName = player.title .. " " .. player.name
		end
		if player.title == nil then
			npc.gfxName = player.name
		end
		npc.gfxFace = player.face
		npc.gfxFaceC = player.faceColor
		npc.gfxHair = player.hair
		npc.gfxHairC = player.hairColor
		npc.gfxSkin = player.skinColor
		npc.gfxFaceAT = 65535
		npc.gfxHelm = 255
		if weap ~= nil then
			npc.gfxWeap = weap.look
			npc.gfxWeapC = weap.lookC
		else
			npc.gfxWeap = 65535
		end
		if crown ~= nil then
			npc.gfxCrown = crown.look
			npc.gfxCrownC = crown.lookC
		else
			npc.gfxCrown = 65535
		end
		if mantle ~= nil then
			npc.gfxMantle = mantle.look
			npc.gfxMantleC = mantle.lookC
		else
			npc.gfxMantle = 65535
		end
		if shield ~= nil then
			npc.gfxShield = shield.look
			npc.gfxShieldC = shield.lookC
		else
			npc.gfxShield = 65535
		end
		if boots ~= nil then
			npc.gfxBoots = boots.look
			npc.gfxBootsC = boots.lookC
		else
			npc.gfxBoots = player.sex
		end
		if facea ~= nil then
			npc.gfxFaceA = facea.look
			npc.gfxFaceAC = facea.lookC
		else
			npc.gfxFaceA = 65535
		end
		if neck ~= nil then
			npc.gfxNeck = neck.look
			npc.gfxNeckC = neck.lookC
		else
			npc.gfxNeck = 65535
		end
		if coat ~= nil then
			npc.gfxArmor = coat.look
			npc.gfxArmorC = coat.lookC
		else
			if armor ~= nil then
				npc.gfxArmor = armor.look
				npc.gfxArmorC = armor.lookC
			else
				npc.gfxArmor = player.sex
			end
		end
		return npc
	end
}
