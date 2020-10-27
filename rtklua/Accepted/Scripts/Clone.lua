clone = {
	equip = function(player, npc)
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
		local faceat = player:getEquippedItem(EQ_FACEACCTWO)

		if helm ~= nil then
			if player.registry["show_helmet"] == 1 then
				npc.gfxHelm = helm.look
				npc.gfxHelmC = helm.lookC
			else
				npc.gfxHelm = 65535
			end
		else
			npc.gfxHelm = 65535
		end

		if crown ~= nil then
			npc.gfxCrown = crown.look
			npc.gfxCrownC = crown.lookC
		else
			npc.gfxCrown = 65535
		end

		if facea ~= nil then
			npc.gfxFaceA = facea.look
			npc.gfxFaceAC = facea.lookC
		else
			npc.gfxFaceA = 65535
		end

		if faceat ~= nil then
			npc.gfxFaceAT = faceat.look
			npc.gfxFaceATC = faceat.lookC
		else
			npc.gfxFaceAT = 65535
		end

		if weap ~= nil then
			npc.gfxWeap = weap.look
			npc.gfxWeapC = weap.lookC
		else
			npc.gfxWeap = 65535
		end

		if shield ~= nil then
			npc.gfxShield = shield.look
			npc.gfxShieldC = shield.lookC
		else
			npc.gfxShield = 65535
		end

		if mantle ~= nil then
			npc.gfxMantle = mantle.look
			npc.gfxMantleC = mantle.lookC
		else
			npc.gfxMantle = 65535
		end

		if neck ~= nil then
			npc.gfxNeck = neck.look
			npc.gfxNeckC = neck.lookC
		else
			npc.gfxNeck = 65535
		end

		if armor ~= nil then
			npc.gfxArmor = armor.look
			npc.gfxArmorC = armor.lookC
		else
			npc.gfxArmor = player.sex
		end

		if coat ~= nil then
			npc.gfxArmor = coat.look
			npc.gfxArmorC = coat.lookC
		end

		if player.armorColor > 0 then
			npc.gfxArmorC = player.armorColor
			npc.gfxDye = 0
		end

		--npc.gfxName = player.name
		npc.gfxFace = player.face
		npc.gfxFaceC = player.faceColor
		npc.gfxHair = player.hair
		npc.gfxHairC = player.hairColor
		npc.gfxSkinC = player.skinColor
		npc.gfxTitleColor = player.gfxTitleColor
		setTitleColor(npc)
	end,
	gfx = function(block1, block2)
		if block1.gfxClone == 1 then
			block2.gfxName = block1.gfxName
			block2.gfxFace = block1.gfxFace
			block2.gfxFaceC = block1.gfxFaceC
			block2.gfxFace = block1.gfxFace
			block2.gfxHair = block1.gfxHair
			block2.gfxHairC = block1.gfxHairC
			block2.gfxFaceC = block1.gfxFaceC
			block2.gfxSkinC = block1.gfxSkinC
			block2.gfxDye = block1.gfxDye
			block2.gfxWeap = block1.gfxWeap
			block2.gfxWeapC = block1.gfxWeapC
			block2.gfxArmor = block1.gfxArmor
			block2.gfxArmorC = block1.gfxArmorC
			block2.gfxShield = block1.gfxShield
			block2.gfxShieldC = block1.gfxShieldC
			block2.gfxHelm = block1.gfxHelm
			block2.gfxHelmC = block1.gfxHelmC
			block2.gfxMantle = block1.gfxMantle
			block2.gfxMantleC = block1.gfxMantleC
			block2.gfxCrown = block1.gfxCrown
			block2.gfxCrownC = block1.gfxCrownC
			block2.gfxFaceA = block1.gfxFaceA
			block2.gfxFaceAC = block1.gfxFaceAC
			block2.gfxFaceAT = block1.gfxFaceAT
			block2.gfxFaceATC = block1.gfxFaceATC
			block2.gfxBoots = block1.gfxBoots
			block2.gfxBootsC = block1.gfxBootsC
			block2.gfxNeck = block1.gfxNeck
			block2.gfxNeckC = block1.gfxNeckC
			block2.gfxTitleColor = block1.gfxTitleColor
			setTitleColor(block2)
		else
			clone.equip(block1, block2)
			block1.gfxClone = 1
			block1:updateState()
		end
	end,

	registry = function(block, cmd)
		if cmd == "load" then
			block.gfxFace = block.registry["gfxFace"]
			block.gfxFaceC = block.registry["gfxFaceC"]
			block.gfxFace = block.registry["gfxFace"]
			block.gfxHair = block.registry["gfxHair"]
			block.gfxHairC = block.registry["gfxHairC"]
			block.gfxFaceC = block.registry["gfxFaceC"]
			block.gfxSkinC = block.registry["gfxSkinC"]
			block.gfxDye = block.registry["gfxDye"]
			block.gfxWeap = block.registry["gfxWeap"]
			block.gfxWeapC = block.registry["gfxWeapC"]
			block.gfxArmor = block.registry["gfxArmor"]
			block.gfxArmorC = block.registry["gfxArmorC"]
			block.gfxShield = block.registry["gfxShield"]
			block.gfxShieldC = block.registry["gfxShieldC"]
			block.gfxHelm = block.registry["gfxHelm"]
			block.gfxHelmC = block.registry["gfxHelmC"]
			block.gfxMantle = block.registry["gfxMantle"]
			block.gfxMantleC = block.registry["gfxMantleC"]
			block.gfxCrown = block.registry["gfxCrown"]
			block.gfxCrownC = block.registry["gfxCrownC"]
			block.gfxFaceA = block.registry["gfxFaceA"]
			block.gfxFaceAC = block.registry["gfxFaceAC"]
			block.gfxFaceAT = block.registry["gfxFaceAT"]
			block.gfxFaceATC = block.registry["gfxFaceATC"]
			block.gfxBoots = block.registry["gfxBoots"]
			block.gfxBootsC = block.registry["gfxBootsC"]
			block.gfxNeck = block.registry["gfxNeck"]
			block.gfxNeckC = block.registry["gfxNeckC"]
		elseif cmd == "save" then
			block.registry["gfxFace"] = block.gfxFace
			block.registry["gfxFaceC"] = block.gfxFaceC
			block.registry["gfxFace"] = block.gfxFace
			block.registry["gfxHair"] = block.gfxHair
			block.registry["gfxHairC"] = block.gfxHairC
			block.registry["gfxFaceC"] = block.gfxFaceC
			block.registry["gfxSkinC"] = block.gfxSkinC
			lock.registry["gfxDye"] = block.gfxDye
			block.registry["gfxWeap"] = block.gfxWeap
			block.registry["gfxWeapC"] = block.gfxWeapC
			block.registry["gfxArmor"] = block.gfxArmor
			block.registry["gfxArmorC"] = block.gfxArmorC
			block.registry["gfxShield"] = block.gfxShield
			block.registry["gfxShieldC"] = block.gfxShieldC
			block.registry["gfxHelm"] = block.gfxHelm
			block.registry["gfxHelmC"] = block.gfxHelmC
			block.registry["gfxMantle"] = block.gfxMantle
			block.registry["gfxMantleC"] = block.gfxMantleC
			block.registry["gfxCrown"] = block.gfxCrown
			block.registry["gfxCrownC"] = block.gfxCrownC
			block.registry["gfxFaceA"] = block.gfxFaceA
			block.registry["gfxFaceAC"] = block.gfxFaceAC
			block.registry["gfxFaceAT"] = block.gfxFaceAT
			block.registry["gfxFaceATC"] = block.gfxFaceATC
			block.registry["gfxBoots"] = block.gfxBoots
			block.registry["gfxBootsC"] = block.gfxBootsC
			block.registry["gfxNeck"] = block.gfxNeck
			block.registry["gfxNeckC"] = block.gfxNeckC
		end
	end,

	playerToPlayer = function(player1, player2)
		local weap = player2:getEquippedItem(EQ_WEAP)
		local coat = player2:getEquippedItem(EQ_COAT)
		local armor = player2:getEquippedItem(EQ_ARMOR)
		local helm = player2:getEquippedItem(EQ_HELM)
		local crown = player2:getEquippedItem(EQ_CROWN)
		local mantle = player2:getEquippedItem(EQ_MANTLE)
		local shield = player2:getEquippedItem(EQ_SHIELD)
		local boots = player2:getEquippedItem(EQ_BOOTS)
		local facea = player2:getEquippedItem(EQ_FACEACC)
		local faceat = player2:getEquippedItem(EQ_FACEACCTWO)
		local neck = player2:getEquippedItem(EQ_NECKLACE)

		if helm ~= nil then
			if player2.registry["show_helmet"] == 1 then
				player1.gfxHelm = helm.look
				player1.gfxHelmC = helm.lookC
			else
				player1.gfxHelm = 65535
			end
		else
			player1.gfxHelm = 65535
		end

		if crown ~= nil then
			player1.gfxCrown = crown.look
			player1.gfxCrownC = crown.lookC
		else
			player1.gfxCrown = 65535
		end

		if facea ~= nil then
			player1.gfxFaceA = facea.look
			player1.gfxFaceAC = facea.lookC
		else
			player1.gfxFaceA = 65535
		end

		if faceat ~= nil then
			player1.gfxFaceAT = faceat.look
			player1.gfxFaceATC = faceat.lookC
		else
			player1.gfxFaceAT = 65535
		end

		if weap ~= nil then
			player1.gfxWeap = weap.look
			player1.gfxWeapC = weap.lookC
		else
			player1.gfxWeap = 65535
		end

		if shield ~= nil then
			player1.gfxShield = shield.look
			player1.gfxShieldC = shield.lookC
		else
			player1.gfxShield = 65535
		end

		if mantle ~= nil then
			player1.gfxMantle = mantle.look
			player1.gfxMantleC = mantle.lookC
		else
			player1.gfxMantle = 65535
		end

		if neck ~= nil then
			player1.gfxNeck = neck.look
			player1.gfxNeckC = neck.lookC
		else
			player1.gfxNeck = 65535
		end

		if armor ~= nil then
			player1.gfxArmor = armor.look
			player1.gfxArmorC = armor.lookC
		else
			player1.gfxArmor = player2.sex
		end

		if coat ~= nil then
			player1.gfxArmor = coat.look
			player1.gfxArmorC = coat.lookC
		end

		if player2.armorColor > 0 then
			player1.gfxArmorC = player2.armorColor
			player1.gfxDye = player2.armorColor
		end

		--player1.gfxName = player2.name
		player1.gfxFace = player2.face
		player1.gfxFaceC = player2.faceColor
		player1.gfxHair = player2.hair
		player1.gfxHairC = player2.hairColor
		player1.gfxSkinC = player2.skinColor
		player1.gfxTitleColor = player2.gfxTitleColor
		setTitleColor(player1)

		--player.gfxHelm = 65535

		player1.gfxClone = 1
		player1:updateState()
	end,

	playerSwap = function(player1, player2)
		clone.playerToPlayer(player1, player2)
		clone.playerToPlayer(player2, player1)
	end,

	wipe = function(player)
		player.gfxFace = 0
		player.gfxFaceC = 0
		player.gfxHair = 0
		player.gfxHairC = 0
		player.gfxSkinC = 0
		player.gfxDye = 0
		player.gfxWeap = 0
		player.gfxWeapC = 0
		player.gfxArmor = 0
		player.gfxArmorC = 0
		player.gfxShield = 0
		player.gfxShieldC = 0
		player.gfxHelm = 0
		player.gfxHelmC = 0
		player.gfxMantle = 0
		player.gfxMantleC = 0
		player.gfxCrown = 0
		player.gfxCrownC = 0
		player.gfxFaceA = 0
		player.gfxFaceAC = 0
		player.gfxFaceAT = 0
		player.gfxFaceATC = 0
		player.gfxBoots = 0
		player.gfxBootsC = 0
		player.gfxNeck = 0
		player.gfxNeckC = 0
		player.gfxTitleColor = 0
		player.gfxName = ""
		setTitleColor(player)

		player.gfxClone = 0
		player:updateState()
	end
}
