local _getRequiredLevel = function(baseLevelRequired)
	local requiredLevel = math.ceil(baseLevelRequired * Config.learnSpellsFactor)
	return math.min(requiredLevel, Config.learnSpellsMaxLevel)
end

function Player.learnSpell(player, npc, additionalSpells)
	local t = {
		graphic = convertGraphic(npc.look, "monster"),
		color = npc.lookColor
	}

	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0
	player.lastClick = npc.ID

	local spellYName = {}
	local spellName = {}
	local spellName2 = {}
	local spellYName2 = {}
	local unknownSpells = {}

	if (player.class >= 1 and player.class <= 4) or player.class >= 10 then
		-- regular path and pc subpaths (pc subpath spells will be available in pc subpath hall)
		unknownSpells = player:getUnknownSpells(player.baseClass)
	elseif player.class == 6 or player.class == 7 or player.class == 8 or player.class == 9 then
		-- NPC paths, returns baseclass + NPC subpath spells
		unknownSpells = player:getUnknownSpells(player.baseClass, player.class)
	end

	local spellLevelReq = {}
	local spellItemReq = {}
	local spellItemAmount = {}
	local spellDesc = {}
	local spellDisplay = {}

	for i = 1, #unknownSpells do
		if (i % 2 == 0) then
			table.insert(spellYName, unknownSpells[i])
		elseif (i % 2 == 1) then
			table.insert(spellName, unknownSpells[i])
		end
	end

	for i = 1, #spellYName do
		if spellYName[i] ~= "" then
			table.insert(spellYName2, spellYName[i])
			table.insert(spellName2, spellName[i])
		end
	end

	if additionalSpells ~= nil then
		for i = 1, #additionalSpells do
			table.insert(spellYName2, additionalSpells[i])
			local name = player:getSpellNameFromYName(additionalSpells[i])
			table.insert(spellName2, name)
		end
	end

	for i = 1, #spellYName2 do
		local level = 1
		local items = {}
		local amounts = {}
		local desc = {}
		local func = assert(loadstring("return " .. spellYName2[i] .. ".requirements"))(player)

		if (func ~= nil) then
			level, items, amounts, desc = func(player)
		end

		level = _getRequiredLevel(level)

		for j = 1, #items do
			if type(items[j]) == "string" then
				items[j] = Item(items[j]).id
			end
		end

		table.insert(spellLevelReq, level)
		table.insert(spellItemReq, items)
		table.insert(spellItemAmount, amounts)
		table.insert(spellDesc, desc)
		table.insert(
			spellDisplay,
			spellName2[i] .. " Lvl: " .. spellLevelReq[i]
		)
	end

	local sortedSpellName = sort_relative(spellLevelReq, spellName2)
	local sortedSpellYName = sort_relative(spellLevelReq, spellYName2)
	local sortedSpellItemReq = sort_relative(spellLevelReq, spellItemReq)
	local sortedSpellItemAmount = sort_relative(spellLevelReq, spellItemAmount)
	local sortedSpellDesc = sort_relative(spellLevelReq, spellDesc)
	local sortedSpellDisplay = sort_relative(spellLevelReq, spellDisplay)
	local sortedSpellLevelReq = sort_relative(spellLevelReq, spellLevelReq)

	--- Up to this point all spells ordered by level

	local i = 1

	while i <= #sortedSpellLevelReq do
		if (sortedSpellLevelReq[i] > player.level or player:hasSpell(sortedSpellYName[i])) then
			table.remove(sortedSpellItemReq, i)
			table.remove(sortedSpellItemAmount, i)
			table.remove(sortedSpellDesc, i)
			table.remove(sortedSpellName, i)
			table.remove(sortedSpellYName, i)
			table.remove(sortedSpellDisplay, i)
			table.remove(sortedSpellLevelReq, i)
			i = i - 1
		end
		
		i = i + 1
	end

	local choice = player:menuSeq(
		"You have unravelled your mind, and expanded your potential. Your destiny is waiting now, is it not? Which secret do you wish to learn?",
		sortedSpellName,
		{}
	)

	--player:talk(0,spellDesc[choice])
	local choice2 = player:menuSeq(
		"You are ready to learn " .. sortedSpellName[choice] .. ": " .. sortedSpellDesc[
			choice
		] .. " Do you swear you will use this secret only for good causes?",
		{"Yes", "No"},
		{}
	)

	-- TODO: Return here if choice2 == 2?

	local items = ""
	local itemName = ""
	local txt = ""

	if sortedSpellItemReq[choice] ~= nil and #sortedSpellItemReq[choice] ~= 0 then
		for i = 1, #sortedSpellItemReq[choice] do
			--player:talk(0,"id is: "..sortedSpellItemReq[choice][i])
			id = sortedSpellItemReq[choice][i]

			--player:talk(0,"amount is: "..sortedSpellItemAmount[choice][i])
			amount = sortedSpellItemAmount[choice][i]
			itemName = Item(id).name

			if (id == 0) then
				--Gold
				items = items .. amount .. " gold, "
			else
				items = items .. itemName .. " (" .. amount .. "), "
			end
		end
		txt = "The fee to learn " .. sortedSpellName[choice] .. " is:\n" .. items .. "All must be in good condition."
	elseif next(sortedSpellItemReq[choice]) == nil then
		txt = "The fee to learn " .. sortedSpellName[choice] .. " is: FREE\n"
	end

	local choice3 = player:menuString(txt, {"Yes", "No"}, {})

	if choice3 == "Yes" then
		if sortedSpellItemReq[choice] ~= nil and #sortedSpellItemReq[choice] ~= 0 then
			for i = 1, #sortedSpellItemReq[choice] do
				id = sortedSpellItemReq[choice][i]
				amount = sortedSpellItemAmount[choice][i]

				if (id > 0) then
					if player:hasItem(id, amount) ~= true then
						player:menuString(
							"Paying for what you want is a sign of devotion. Return when you have what is required for this.",
							{}
						)
						return
					end
				else
					if player.money < amount then
						player:menuString(
							"Paying for what you want is a sign of devotion. Return when you have what is required for this.",
							{}
						)
						return
					end
				end
			end
		end

		-- Successful check of items and gold at this point.. proceed to taking the items and gold

		if sortedSpellItemReq[choice] ~= nil and #sortedSpellItemReq[choice] ~= 0 then
			for i = 1, #sortedSpellItemReq[choice] do
				id = sortedSpellItemReq[choice][i]
				amount = sortedSpellItemAmount[choice][i]

				if (id > 0) then
					player:removeItem(id, amount, 9)
				else
					player:removeGold(amount)
				end
			end
		end

		player:addSpell(sortedSpellYName[choice])
		player:sendMinitext("Your mind expands as you learn " .. sortedSpellName[choice])
	elseif choice3 == "No" then
		player:dialogSeq(
			{
				t,
				"The potential for learning is endless, be always humble and ready to learn."
			},
			1
		)
		return
	end
end

function Player.learnSpecificSpells(player, npc, spells)
	-- will be used for mainly PC subpath spell system

	local t = {
		graphic = convertGraphic(npc.look, "monster"),
		color = npc.lookColor
	}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0
	player.lastClick = npc.ID

	if next(spells) == nil then
		return
	end

	local spellYName = {}
	local spellName = {}

	for i = 1, #spells do
		table.insert(spellYName, spells[i])
		table.insert(spellName, player:getSpellNameFromYName(spells[i]))
	end

	local spellLevelReq = {}
	local spellItemReq = {}
	local spellItemAmount = {}
	local spellDesc = {}
	local spellDisplay = {}

	for i = 1, #spellYName do
		local level = 1
		local items = {}
		local amounts = {}
		local desc = {}
		local func = assert(loadstring("return " .. spellYName[i] .. ".requirements"))(player)

		if (func ~= nil) then
			level, items, amounts, desc = func(player)
		end

		level = _getRequiredLevel(level)

		for j = 1, #items do
			if type(items[j]) == "string" then
				items[j] = Item(items[j]).id
			end
		end

		table.insert(spellLevelReq, level)
		table.insert(spellItemReq, items)
		table.insert(spellItemAmount, amounts)
		table.insert(spellDesc, desc)
		table.insert(spellDisplay, spellName[i] .. " Lvl: " .. spellLevelReq[i])
	end

	local sortedSpellName = sort_relative(spellLevelReq, spellName)
	local sortedSpellYName = sort_relative(spellLevelReq, spellYName)
	local sortedSpellItemReq = sort_relative(spellLevelReq, spellItemReq)
	local sortedSpellItemAmount = sort_relative(spellLevelReq, spellItemAmount)
	local sortedSpellDesc = sort_relative(spellLevelReq, spellDesc)
	local sortedSpellDisplay = sort_relative(spellLevelReq, spellDisplay)
	local sortedSpellLevelReq = sort_relative(spellLevelReq, spellLevelReq)

	--- Up to this point all spells ordered by level

	local j = 1
	while j <= #sortedSpellLevelReq do
		if (sortedSpellLevelReq[j] > player.level or player:hasSpell(sortedSpellYName[j])) then
			table.remove(sortedSpellItemReq, j)
			table.remove(sortedSpellItemAmount, j)
			table.remove(sortedSpellDesc, j)
			table.remove(sortedSpellName, j)
			table.remove(sortedSpellYName, j)
			table.remove(sortedSpellDisplay, j)
			table.remove(sortedSpellLevelReq, j)
			j = j - 1
		end
		j = j + 1
	end

	local choice = player:menuSeq(
		"You have unravelled your mind, and expanded your potential. Your destiny is waiting now, is it not? Which secret do you wish to learn?",
		sortedSpellName,
		{}
	)

	--player:talk(0,spellDesc[choice])
	local choice2 = player:menuSeq(
		"You are ready to learn " .. sortedSpellName[choice] .. ": " .. sortedSpellDesc[
			choice
		] .. " Do you swear you will use this secret only for good causes?",
		{"Yes", "No"},
		{}
	)

	local items = ""
	local itemName = ""
	local txt = ""

	if sortedSpellItemReq[choice] ~= nil and #sortedSpellItemReq[choice] ~= 0 then
		for i = 1, #sortedSpellItemReq[choice] do
			--player:talk(0,"id is: "..sortedSpellItemReq[choice][i])
			id = sortedSpellItemReq[choice][i]

			--player:talk(0,"amount is: "..sortedSpellItemAmount[choice][i])
			amount = sortedSpellItemAmount[choice][i]
			itemName = Item(id).name

			if (id == 0) then
				--Gold
				items = items .. amount .. " gold, "
			else
				items = items .. itemName .. " (" .. amount .. "), "
			end
		end
		txt = "The fee to learn " .. sortedSpellName[choice] .. " is:\n" .. items .. "All must be in good condition."
	elseif next(sortedSpellItemReq[choice]) == nil then
		txt = "The fee to learn " .. sortedSpellName[choice] .. " is: FREE\n"
	end

	local choice3 = player:menuString(txt, {"Yes", "No"}, {})

	if choice3 == "Yes" then
		if sortedSpellItemReq[choice] ~= nil and #sortedSpellItemReq[choice] ~= 0 then
			for i = 1, #sortedSpellItemReq[choice] do
				id = sortedSpellItemReq[choice][i]
				amount = sortedSpellItemAmount[choice][i]

				if (id > 0) then
					if player:hasItem(id, amount) ~= true then
						player:menuString(
							"Paying for what you want is a sign of devotion. Return when you have what is required for this.",
							{}
						)
						return
					end
				else
					if player.money < amount then
						player:menuString(
							"Paying for what you want is a sign of devotion. Return when you have what is required for this.",
							{}
						)
						return
					end
				end
			end
		end

		-- Successful check of items and gold at this point.. proceed to taking the items and gold

		if sortedSpellItemReq[choice] ~= nil and #sortedSpellItemReq[choice] ~= 0 then
			for i = 1, #sortedSpellItemReq[choice] do
				id = sortedSpellItemReq[choice][i]
				amount = sortedSpellItemAmount[choice][i]

				if (id > 0) then
					player:removeItem(id, amount, 9)
				else
					player:removeGold(amount)
				end
			end
		end

		player:addSpell(sortedSpellYName[choice])
		player:sendMinitext("Your mind expands as you learn " .. sortedSpellName[choice])
	elseif choice3 == "No" then
		player:dialogSeq(
			{
				t,
				"The potential for learning is endless, be always humble and ready to learn."
			},
			1
		)
		return
	end
end

function Player.learnWisdomSpells(player, npc, spells)
	local t = {
		graphic = convertGraphic(npc.look, "monster"),
		color = npc.lookColor
	}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0
	player.lastClick = npc.ID

	if next(spells) == nil then
		return
	end

	local spellYName = {}
	local spellName = {}
	local spellName2 = {}
	local spellYName2 = {}

	for i = 1, #spells do
		table.insert(spellYName, spells[i])
		table.insert(spellName, player:getSpellNameFromYName(spells[i]))
	end

	local spellLevelReq = {}
	local spellItemReq = {}
	local spellItemAmount = {}
	local spellDesc = {}
	local spellDisplay = {}

	for i = 1, #spellYName do
		local level = 1
		local items = {}
		local amounts = {}
		local desc = {}
		local func = assert(loadstring("return " .. spellYName[i] .. ".requirements"))(player)

		if (func ~= nil) then
			level, items, amounts, desc = func(player)
		end

		level = _getRequiredLevel(level)

		for j = 1, #items do
			if type(items[j]) == "string" then
				items[j] = Item(items[j]).id
			end
		end

		table.insert(spellLevelReq, level)
		table.insert(spellItemReq, items)
		table.insert(spellItemAmount, amounts)
		table.insert(spellDesc, desc)
		table.insert(spellDisplay, spellName[i] .. " Lvl: " .. spellLevelReq[i])
	end

	local sortedSpellName = sort_relative(spellLevelReq, spellName)
	local sortedSpellYName = sort_relative(spellLevelReq, spellYName)
	local sortedSpellItemReq = sort_relative(spellLevelReq, spellItemReq)
	local sortedSpellItemAmount = sort_relative(spellLevelReq, spellItemAmount)
	local sortedSpellDesc = sort_relative(spellLevelReq, spellDesc)
	local sortedSpellDisplay = sort_relative(spellLevelReq, spellDisplay)
	local sortedSpellLevelReq = sort_relative(spellLevelReq, spellLevelReq)

	--- Up to this point all spells ordered by level

	local j = 1
	while j <= #sortedSpellLevelReq do
		if (sortedSpellLevelReq[j] > player.level or player:hasSpell(sortedSpellYName[j])) then
			table.remove(sortedSpellItemReq, j)
			table.remove(sortedSpellItemAmount, j)
			table.remove(sortedSpellDesc, j)
			table.remove(sortedSpellName, j)
			table.remove(sortedSpellYName, j)
			table.remove(sortedSpellDisplay, j)
			table.remove(sortedSpellLevelReq, j)
			j = j - 1
		end
		j = j + 1
	end

	local choice = player:menuSeq(
		"You have unravelled your mind, and expanded your potential. Your destiny is waiting now, is it not? Which secret do you wish to learn?",
		sortedSpellName,
		{}
	)

	--player:talk(0,spellDesc[choice])
	local choice2 = player:menuSeq(
		"You are ready to learn " .. sortedSpellName[choice] .. ": " .. sortedSpellDesc[
			choice
		] .. " Do you swear you will use this secret only for good causes?",
		{"Yes", "No"},
		{}
	)

	local items = ""
	local itemName = ""
	local txt = ""

	if sortedSpellItemReq[choice] ~= nil and #sortedSpellItemReq[choice] ~= 0 then
		for i = 1, #sortedSpellItemReq[choice] do
			--player:talk(0,"id is: "..sortedSpellItemReq[choice][i])
			id = sortedSpellItemReq[choice][i]

			--player:talk(0,"amount is: "..sortedSpellItemAmount[choice][i])
			amount = sortedSpellItemAmount[choice][i]
			itemName = Item(id).name

			if (id == 0) then
				--Gold
				items = items .. amount .. " gold, "
			else
				items = items .. itemName .. " (" .. amount .. "), "
			end
		end
		txt = "The fee to learn " .. sortedSpellName[choice] .. " is:\n" .. items .. "All must be in good condition."
	elseif next(sortedSpellItemReq[choice]) == nil then
		txt = "The fee to learn " .. sortedSpellName[choice] .. " is: FREE\n"
	end

	local choice3 = player:menuString(txt, {"Yes", "No"}, {})

	if choice3 == "Yes" then
		if sortedSpellItemReq[choice] ~= nil and #sortedSpellItemReq[choice] ~= 0 then
			for i = 1, #sortedSpellItemReq[choice] do
				id = sortedSpellItemReq[choice][i]
				amount = sortedSpellItemAmount[choice][i]

				if (id > 0) then
					if player:hasItem(id, amount) ~= true then
						player:menuString(
							"Paying for what you want is a sign of devotion. Return when you have what is required for this.",
							{}
						)
						return
					end
				else
					if player.money < amount then
						player:menuString(
							"Paying for what you want is a sign of devotion. Return when you have what is required for this.",
							{}
						)
						return
					end
				end
			end
		end

		-- Successful check of items and gold at this point.. proceed to taking the items and gold

		if os.time() < player.registry["learnWisdomSpellTimer"] then
			player:dialogSeq(
				{
					t,
					"Not enough time has passed since you last learned a wisdom spell."
				},
				0
			)
			return
		end

		if sortedSpellItemReq[choice] ~= nil and #sortedSpellItemReq[choice] ~= 0 then
			for i = 1, #sortedSpellItemReq[choice] do
				id = sortedSpellItemReq[choice][i]
				amount = sortedSpellItemAmount[choice][i]

				if (id > 0) then
					player:removeItem(id, amount, 9)
				else
					player:removeGold(amount)
				end
			end
		end
		player.registry["learnWisdomSpellTimer"] = os.time() + 2592000

		-- 30 days
		player:addSpell(sortedSpellYName[choice])
		player:sendMinitext("Your mind expands as you learn " .. sortedSpellName[choice])
	elseif choice3 == "No" then
		player:dialogSeq(
			{
				t,
				"The potential for learning is endless, be always humble and ready to learn."
			},
			1
		)
		return
	end
end

function Player.forgetSpell(player, npc)
	local t = {
		graphic = convertGraphic(npc.look, "monster"),
		color = npc.lookColor
	}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0
	player.lastClick = npc.ID

	local spellNames = player:getSpellName()
	local spellYNames = player:getSpellYName()
	local selection

	selection = player:menuSeq(
		"Which secret do you wish to remove from your mind?",
		spellNames,
		{}
	)

	choice = player:menuString(
		"Are you sure you wish to forget " .. spellNames[selection] .. "?",
		{"Yes", "No"}
	)

	if (choice == "Yes") then
		player:removeSpell(spellYNames[selection])
		player:sendMinitext("You have forgotten the spell " .. spellNames[selection])
	end
end

function Player.currentFutureSpells(player, npc)
	local t = {
		graphic = convertGraphic(npc.look, "monster"),
		color = npc.lookColor
	}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0
	player.lastClick = npc.ID

	local spellYName = {}
	local spellName = {}
	local spellName2 = {}
	local spellYName2 = {}
	local unknownSpells = player:getUnknownSpells(
		player.baseClass,
		player.class
	)

	local spellLevelReq = {}
	local spellItemReq = {}
	local spellItemAmount = {}
	local spellDesc = {}
	local spellDisplay = {}

	for i = 1, #unknownSpells do
		if (i % 2 == 0) then
			table.insert(spellYName, unknownSpells[i])
		elseif (i % 2 == 1) then
			table.insert(spellName, unknownSpells[i])
		end
	end

	for i = 1, #spellYName do
		if spellYName[i] ~= "" then
			table.insert(spellYName2, spellYName[i])
			table.insert(spellName2, spellName[i])
		end
	end

	for i = 1, #spellYName2 do
		local level = 1
		local items = {}
		local amounts = {}
		local desc = {}
		local func = assert(loadstring("return " .. spellYName2[i] .. ".requirements"))(player)

		if (func ~= nil) then
			level, items, amounts, desc = func(player)
		end

		level = _getRequiredLevel(level)

		for j = 1, #items do
			if type(items[j]) == "string" then
				items[j] = Item(items[j]).id
			end
		end

		table.insert(spellLevelReq, level)
		table.insert(spellItemReq, items)
		table.insert(spellItemAmount, amounts)
		table.insert(spellDesc, desc)
		table.insert(
			spellDisplay,
			spellName2[i] .. " Lvl: " .. spellLevelReq[i]
		)
	end

	local sortedSpellName = sort_relative(spellLevelReq, spellName2)
	local sortedSpellYName = sort_relative(spellLevelReq, spellYName2)
	local sortedSpellItemReq = sort_relative(spellLevelReq, spellItemReq)
	local sortedSpellItemAmount = sort_relative(spellLevelReq, spellItemAmount)
	local sortedSpellDesc = sort_relative(spellLevelReq, spellDesc)
	local sortedSpellDisplay = sort_relative(spellLevelReq, spellDisplay)
	local sortedSpellLevelReq = sort_relative(spellLevelReq, spellLevelReq)

	--- Up to this point all spells ordered by level

	local j = 1
	while j <= #sortedSpellLevelReq do
		if (sortedSpellLevelReq[j] - player.level > 10 or player:hasSpell(sortedSpellYName[j])) then
			table.remove(sortedSpellItemReq, j)
			table.remove(sortedSpellItemAmount, j)
			table.remove(sortedSpellDesc, j)
			table.remove(sortedSpellName, j)
			table.remove(sortedSpellYName, j)
			table.remove(sortedSpellDisplay, j)
			table.remove(sortedSpellLevelReq, j)
			j = j - 1
		end
		j = j + 1
	end

	local choice = player:menuSeq(
		"Which spell would you like to learn more about?",
		sortedSpellName,
		{}
	)

	player:dialogSeq(
		{
			t,
			"<b>" .. sortedSpellName[choice] .. "\n\n" .. sortedSpellDesc[
				choice
			] .. " Can be learned at Level " .. sortedSpellLevelReq[choice]
		},
		1
	)

	local items = ""
	local itemName = ""
	local txt = ""

	if sortedSpellItemReq[choice] ~= nil and #sortedSpellItemReq[choice] ~= 0 then
		for i = 1, #sortedSpellItemReq[choice] do
			id = sortedSpellItemReq[choice][i]
			amount = sortedSpellItemAmount[choice][i]
			itemName = Item(id).name

			if (id == 0) then
				--Gold
				items = items .. amount .. " gold, "
			else
				items = items .. itemName .. " (" .. amount .. "), "
			end
		end
		txt = "The fee to learn " .. sortedSpellName[choice] .. " is:\n" .. items .. "All must be in good condition."
	elseif next(sortedSpellItemReq[choice]) == nil then
		txt = "The fee to learn " .. sortedSpellName[choice] .. " is: FREE\n"
	end

	player:dialogSeq({t, txt}, 0)
end

function Player.futureSpells(player, npc, additionalSpells)
	local t = {
		graphic = convertGraphic(npc.look, "monster"),
		color = npc.lookColor
	}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0
	player.lastClick = npc.ID

	local spellYName = {}
	local spellName = {}
	local spellName2 = {}
	local spellYName2 = {}
	local unknownSpells = player:getUnknownSpells(
		player.baseClass,
		player.class
	)

	local spellLevelReq = {}
	local spellItemReq = {}
	local spellItemAmount = {}
	local spellDesc = {}
	local spellDisplay = {}

	for i = 1, #unknownSpells do
		if (i % 2 == 0) then
			table.insert(spellYName, unknownSpells[i])
		elseif (i % 2 == 1) then
			table.insert(spellName, unknownSpells[i])
		end
	end

	for i = 1, #spellYName do
		if spellYName[i] ~= "" then
			table.insert(spellYName2, spellYName[i])
			table.insert(spellName2, spellName[i])
		end
	end

	if additionalSpells ~= nil then
		for i = 1, #additionalSpells do
			table.insert(spellYName2, additionalSpells[i])
			local name = player:getSpellNameFromYName(additionalSpells[i])
			table.insert(spellName2, name)
		end
	end

	for i = 1, #spellYName2 do
		local level = 1
		local items = {}
		local amounts = {}
		local desc = {}
		local func = assert(loadstring("return " .. spellYName2[i] .. ".requirements"))(player)

		if (func ~= nil) then
			level, items, amounts, desc = func(player)
		end

		level = _getRequiredLevel(level)

		for j = 1, #items do
			if type(items[j]) == "string" then
				items[j] = Item(items[j]).id
			end
		end

		table.insert(spellLevelReq, level)
		table.insert(spellItemReq, items)
		table.insert(spellItemAmount, amounts)
		table.insert(spellDesc, desc)
		table.insert(
			spellDisplay,
			spellName2[i] .. " Lvl: " .. spellLevelReq[i]
		)
	end

	local sortedSpellName = sort_relative(spellLevelReq, spellName2)
	local sortedSpellYName = sort_relative(spellLevelReq, spellYName2)
	local sortedSpellItemReq = sort_relative(spellLevelReq, spellItemReq)
	local sortedSpellItemAmount = sort_relative(spellLevelReq, spellItemAmount)
	local sortedSpellDesc = sort_relative(spellLevelReq, spellDesc)
	local sortedSpellDisplay = sort_relative(spellLevelReq, spellDisplay)
	local sortedSpellLevelReq = sort_relative(spellLevelReq, spellLevelReq)

	--- Up to this point all spells ordered by level

	local j = 1
	while j <= #sortedSpellLevelReq do
		if (sortedSpellLevelReq[j] <= player.level or sortedSpellLevelReq[j] - player.level > 10 or player:hasSpell(sortedSpellYName[j])) then
			table.remove(sortedSpellItemReq, j)
			table.remove(sortedSpellItemAmount, j)
			table.remove(sortedSpellDesc, j)
			table.remove(sortedSpellName, j)
			table.remove(sortedSpellYName, j)
			table.remove(sortedSpellDisplay, j)
			table.remove(sortedSpellLevelReq, j)
			j = j - 1
		end
		j = j + 1
	end

	local choice = player:menuSeq(
		"Which spell would you like to learn more about?",
		sortedSpellName,
		{}
	)

	player:dialogSeq(
		{
			t,
			"<b>" .. sortedSpellName[choice] .. "\n\n" .. sortedSpellDesc[
				choice
			] .. " Can be learned at Level " .. sortedSpellLevelReq[choice]
		},
		1
	)

	local items = ""
	local itemName = ""
	local txt = ""

	if sortedSpellItemReq[choice] ~= nil and #sortedSpellItemReq[choice] ~= 0 then
		for i = 1, #sortedSpellItemReq[choice] do
			id = sortedSpellItemReq[choice][i]
			amount = sortedSpellItemAmount[choice][i]
			itemName = Item(id).name

			if (id == 0) then
				--Gold
				items = items .. amount .. " gold, "
			else
				items = items .. itemName .. " (" .. amount .. "), "
			end
		end
		txt = "The fee to learn " .. sortedSpellName[choice] .. " is:\n" .. items .. "All must be in good condition."
	elseif next(sortedSpellItemReq[choice]) == nil then
		txt = "The fee to learn " .. sortedSpellName[choice] .. " is: FREE\n"
	end

	player:dialogSeq({t, txt}, 0)
end

function Player.checkItems(player, items, amounts)
	for x = 1, #items do
		if (items[x] == 0) then
			if (player.money < amounts[x]) then
				return false
			end
		else
			if (player:hasItem(items[x], amounts[x]) == true) then
			else
				return false
			end
		end
	end

	return true
end

function Player.removeItems(player, items, amounts)
	for x = 1, #items do
		if (items[x] == 0) then
			player.money = player.money - amounts[x]
			player:sendStatus()
		else
			player:removeItem(items[x], amounts[x])
		end
	end
end

function Player.canLearnSpell(player, str)
	if (type(str) ~= "string") then
		return false
	end
	local spells = player:getSpells()
	if (#spells < 52) then
		if (player:hasSpell("" .. str)) then
			return false
		end
		return true
	else
		return false
	end
end
