verbalScriptCheckShop = function(player, npc, speech)
	Tools.configureDialog(player, npc)

	local buyItems = {}
	local maxAmounts = {}
	local words = {}
	local itemName = ""

	for word in speech:gmatch("[%w\'%-%[%]]+") do
		table.insert(words, word)
	end

	if (words[1] == "i" and words[2] == "buy") then
		Tools.checkKarma(player)

		local foundNumber = false
		local j = 0
		local amount = 0
		local func = assert(loadstring("return " .. npc.yname .. ".buyItems"))(player)
		local prices = {}

		if (func ~= nil) then
			buyItems, prices, maxAmounts = func(npc)
		else
			buyItems = {}
		end

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
			player:buyNoConfirm(npc, itemName, 1, buyItems, prices, maxAmounts)
		end

		if j > 0 then
			if (words[j + 1] == "") then
				amount = 1
			end

			if (tonumber(words[j + 1]) == nil) then
				amount = 1
			else
				amount = tonumber(words[j + 1])
			end

			player:buyNoConfirm(
				npc,
				itemName,
				amount,
				buyItems,
				prices,
				maxAmounts
			)
		end
	end

	if (words[1] == "buy" and words[2] == "my" and words[3] ~= "all") then
		Tools.checkKarma(player)

		local foundNumber = false
		local j = 0
		local amount = 0
		local func = assert(loadstring("return " .. npc.yname .. ".sellItems"))(player)
		local prices = {}

		if (func ~= nil) then
			sellItems, prices = func(npc)
		else
			sellItems = {}
		end

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
			player:sellNoConfirm(npc, itemName, 1, sellItems, prices)
		end

		if j > 0 then
			if (words[j + 1] == "") then
				amount = 1
			end

			if (tonumber(words[j + 1]) == nil) then
				amount = 1
			else
				amount = tonumber(words[j + 1])
			end

			player:sellNoConfirm(npc, itemName, amount, sellItems, prices)
		end
	end

	if (words[1] == "buy" and words[2] == "my" and words[3] == "all") then
		Tools.checkKarma(player)

		local amount = 0
		local func = assert(loadstring("return " .. npc.yname .. ".sellItems"))(player)
		local prices = {}

		if (func ~= nil) then
			sellItems, prices = func(npc)
		else
			sellItems = {}
		end

		for i = 4, #words do
			if i == #words then
				itemName = itemName .. "" .. words[i]
			else
				--itemName = itemName..""..words[i].."_"
				itemName = itemName .. "" .. words[i] .. " "
			end
		end

		for i = 0, 52 do
			local item = player:getInventoryItem(i)

			if item ~= nil then
				if string.lower(item.name) == string.lower(itemName) then
					amount = amount + item.amount
				end
			end
		end

		if amount == 0 then
			return
		end

		player:sellNoConfirm(npc, itemName, amount, sellItems, prices)
	end

	if (words[1] == "what" and words[2] == "do" and words[3] == "you" and words[4] == "buy") then
		Tools.checkKarma(player)

		local func = assert(loadstring("return " .. npc.yname .. ".sellItems"))()

		if (func ~= nil) then
			sellItems = func(npc)
		else
			sellItems = {}
		end

		local sellString = "I buy"

		for i = 1, #sellItems do
			if i ~= #sellItems or #sellItems == 1 then
				sellString = sellString .. " " .. Item(sellItems[i]).name .. ","
			else
				sellString = sellString .. " and " .. Item(sellItems[i]).name .. "."
			end

			--if #sellString > 90 then
			npc:talk(0, "" .. sellString)
			sellString = ""

			--end
		end
	end

	if (words[1] == "what" and words[2] == "do" and words[3] == "you" and words[4] == "sell") then
		local func = assert(loadstring("return " .. npc.yname .. ".buyItems"))()

		if (func ~= nil) then
			buyItems = func(npc)
		else
			buyItems = {}
		end

		local buyString = "I sell"

		for i = 1, #buyItems do
			if i ~= #buyItems or #buyItems == 1 then
				buyString = buyString .. " " .. Item(buyItems[i]).name .. ","
			else
				buyString = buyString .. " and " .. Item(buyItems[i]).name .. "."
			end

			--if #buyString > 90 then
			npc:talk(0, "" .. buyString)
			buyString = ""

			--end
		end
	end
end
