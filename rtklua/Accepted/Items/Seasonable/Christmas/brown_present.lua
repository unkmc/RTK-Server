brown_present = {
	use = function(player)
		local item = player:getInventoryItem(player.invSlot)

		local itemIds = {}
		local itemAmounts = {}
		local itemEngraves = {}

		if item.custom == 0 then
			player:popUp("error")
			return
		end

		local giftTable = player:retrieveGift(item.custom)

		if giftTable == nil then
			return
		end

		for i = 1, #giftTable, 3 do
			table.insert(itemIds, giftTable[i])
			table.insert(itemAmounts, giftTable[i + 1])
			table.insert(itemEngraves, giftTable[i + 2])
		end

		for i = 1, #itemIds do
			if itemIds[i] ~= 0 then
				--player:talk(0,""..Item(itemIds[i]).name.." amount: "..itemAmounts[i])
				player:addItem(
					itemIds[i],
					itemAmounts[i],
					0,
					0,
					0,
					itemEngraves[i]
				)
			end
		end

		player:sendMinitext("You opened a present.")
		player:removeItemSlot(player.invSlot, 1, 6)
	end
}
