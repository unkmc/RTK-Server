verbalScriptCheckBank = function(player, npc, speech)
	Tools.configureDialog(player, npc)

	-- I will deposit <item>, I will deposit <item> number <qty>, I will deposit <all> <item>, Give my <item> back, Give my <item> number <qty> back, Give my all <item> back
	-- You've got me confused with another shop.
	-- How many <item> have I deposited?   You've entrusted me with <number> <item>."

	local words = {}

	local itemName = ""

	for word in speech:gmatch("[%w\'%-%[%]]+") do
		table.insert(words, word)
	end

	if (words[1] == "i" and words[2] == "will" and words[3] == "deposit" and words[4] ~= "all") then
		-- I will deposit (item)

		Tools.checkKarma(player)

		if (words[4] ~= "lucky" and (words[5] == "coins" or words[5] == "coin")) then
			player:depositNoConfirm(
				npc,
				"coins",
				player:inputNumberCheck(words[4])
			)
			return
		end

		local foundNumber = false
		local j = 0
		local amount = 0

		for i = 4, #words do
			if (words[i] == "number") then
				foundNumber = true
			end
		end

		if foundNumber == true then
			for i = 4, #words do
				if words[i + 1] == "number" then
					itemName = itemName .. "" .. words[i]
					break
				end

				--itemName = itemName..""..words[i].."_"
				itemName = itemName .. "" .. words[i] .. " "
			end
		end

		if foundNumber == false then
			for i = 4, #words do
				if i == #words then
					itemName = itemName .. "" .. words[i]
				else
					--itemName = itemName..""..words[i].."_"
					itemName = itemName .. "" .. words[i] .. " "
				end
			end
		end

		for i = 1, #words do
			if words[i] == "number" then
				j = i
			end
		end

		if j == 0 then
			player:depositNoConfirm(npc, itemName, 1)
		end

		if j > 0 then
			if (words[j + 1] == "") then
				amount = 1
			end

			amount = player:inputNumberCheck(words[j + 1])

			player:depositNoConfirm(npc, itemName, amount)
		end
	end

	if (words[1] == "i" and words[2] == "will" and words[3] == "deposit" and words[4] == "all") then
		Tools.checkKarma(player)
		local amount = 0

		if words[5] == "coins" or words[5] == "coin" then
			player:depositNoConfirm(npc, words[5], player.money)
			return
		end

		for i = 5, #words do
			if i == #words then
				itemName = itemName .. "" .. words[i]
			else
				--itemName = itemName..""..words[i].."_"
				itemName = itemName .. "" .. words[i] .. " "
			end
		end

		local tempItem = Item(itemName)
		if tempItem == nil then
			return
		end

		for i = 0, 52 do
			local item = player:getInventoryItem(i)

			if item ~= nil then
				if item.name == tempItem.name then
					if item.dura == item.maxDura then
						amount = amount + item.amount
					else
						npc:talk(
							0,
							npc.name .. ": Your item has to be at full durability to deposit."
						)
					end
				end
			end
		end

		if amount == 0 then
			return
		end

		player:depositNoConfirm(npc, itemName, amount)
	end

	if (words[1] == "give" and words[2] == "my" and words[3] ~= "all") then
		-- Give my (item) back

		Tools.checkKarma(player)

		if ((words[3]) ~= "lucky" and (words[4] == "coins" or words[4] == "coin")) then
			player:withdrawNoConfirm(
				npc,
				"coins",
				player:inputNumberCheck(words[3])
			)
			return
		end

		if (words[3] == "coin" or words[3] == "coins") then
			return
		end

		local foundNumber = false
		local j = 0
		local amount = 0

		for i = 3, #words do
			if (words[i] == "number") then
				foundNumber = true
			end
		end

		if foundNumber == true then
			for i = 3, #words do
				if words[i + 1] == "number" then
					itemName = itemName .. "" .. words[i]
					break
				end

				--itemName = itemName..""..words[i].."_"
				itemName = itemName .. "" .. words[i] .. " "
			end
		end

		if foundNumber == false then
			for i = 3, #words do
				if words[i + 1] == "back" or words[i + 1] == "number" then
					itemName = itemName .. "" .. words[i]
					break
				else
					--itemName = itemName..""..words[i].."_"
					itemName = itemName .. "" .. words[i] .. " "
				end
			end
		end

		for i = 1, #words do
			if words[i] == "number" then
				j = i
			end
		end

		if j == 0 then
			player:withdrawNoConfirm(npc, itemName, 1)
		end

		if j > 0 then
			if (words[j + 1] == "") then
				amount = 1
			end

			amount = player:inputNumberCheck(words[j + 1])

			player:withdrawNoConfirm(npc, itemName, amount)
		end
	end

	if (words[1] == "give" and words[2] == "my" and words[3] == "all") then
		Tools.checkKarma(player)

		if (words[4] == "coins" or words[4] == "coin") then
			player:withdrawAllNoConfirm(npc, "coins")
			return
		end

		local j = 0

		for i = 4, #words do
			if words[i + 1] == "back" then
				itemName = itemName .. "" .. words[i]
				break
			else
				--itemName = itemName..""..words[i].."_"
				itemName = itemName .. "" .. words[i] .. " "
			end
		end

		player:withdrawAllNoConfirm(npc, itemName)
	end

	if (words[1] == "how" and words[2] == "many") then
		-- how many (item) have I deposited?

		Tools.checkKarma(player)

		if (words[3] == "coin" or words[3] == "coins") then
			player:hasBankItem(npc, "coins")
			return
		end

		local foundNumber = false
		local j = 0
		local amount = 0

		for i = 3, #words do
			if words[i + 1] == "have" then
				itemName = itemName .. "" .. words[i]
				break
			end

			--itemName = itemName..""..words[i].."_"
			itemName = itemName .. "" .. words[i] .. " "
		end

		player:hasBankItem(npc, itemName)
	end

	if (words[1] == "what" and words[2] == "have" and words[3] == "i" and words[4] == "deposited") then
		local bankItemTable, bankCountTable, bankOwnerTable, bankEngraveTable, bankTimerTable, bankItemTableNames = player:bankItemsList()

		if #bankItemTable == 0 then
			npc:talk(0, npc.name .. ": I am not keeping any of your things.")
		else
			npc:talk(
				0,
				npc.name .. ": I am keeping " .. #bankItemTable .. " of your things."
			)
		end

		--talk... I am keeping # of your things.
	end
end
