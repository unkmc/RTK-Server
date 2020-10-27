onPickUp = function(player)
	---------single item pickup (comma)---------------------------------------------------------------

	if player.pickUpType == 0 then
		local goldFound = false
		local itemFound = 0

		groundItems = player:getObjectsInCell(
			player.m,
			player.x,
			player.y,
			BL_ITEM
		)

		if #groundItems > 0 then
			for i = 1, #groundItems do
				if groundItems[i].id <= 3 then
					goldFound = true
					break
				else
					itemFound = groundItems[i].id
					break
				end
			end

			if goldFound then
				for i = 1, #groundItems do
					if player:canLoot(groundItems[i]) and groundItems[i].id <= 3 then
						groundItems[i]:delete()
						player:addGold(groundItems[i].amount)
					end
				end
				return
			elseif itemFound > 0 then
				for i = 1, #groundItems do
					if player:canLoot(groundItems[i]) and groundItems[i].id == itemFound then
						characterLog.pickUpWrite(player, groundItems[i], 1)
						player:pickUp(groundItems[i].ID)
					end
				end
				return
			end
		end
	end

	---------multi item pickup (shift+comma)---------------------------------------------------------------

	if player.pickUpType == 1 then
		groundItems = player:getObjectsInCell(
			player.m,
			player.x,
			player.y,
			BL_ITEM
		)

		if #groundItems > 0 then
			for i = 1, #groundItems do
				if groundItems[i].id <= 3 then
					--If it is coins
					if player:canLoot(groundItems[i]) then
						groundItems[i]:delete()
						player:addGold(groundItems[i].amount)
					end
				elseif groundItems[i].id > 3 then
					--If it is not coins
					if player:canLoot(groundItems[i]) then
						characterLog.pickUpWrite(
							player,
							groundItems[i],
							groundItems[i].amount
						)
						player:pickUp(groundItems[i].ID)
					end
				end
			end
		end
	end

	---------area item pickup (control+comma)---------------------------------------------------------------

	if player.pickUpType == 3 then
		local groundItem1 = player:getObjectsInCell(
			player.m,
			player.x,
			player.y,
			BL_ITEM
		)
		local groundItem2 = player:getObjectsInCell(
			player.m,
			player.x - 1,
			player.y,
			BL_ITEM
		)
		local groundItem3 = player:getObjectsInCell(
			player.m,
			player.x + 1,
			player.y,
			BL_ITEM
		)
		local groundItem4 = player:getObjectsInCell(
			player.m,
			player.x,
			player.y - 1,
			BL_ITEM
		)
		local groundItem5 = player:getObjectsInCell(
			player.m,
			player.x,
			player.y + 1,
			BL_ITEM
		)
		local groundItem6 = player:getObjectsInCell(
			player.m,
			player.x - 1,
			player.y - 1,
			BL_ITEM
		)
		local groundItem7 = player:getObjectsInCell(
			player.m,
			player.x - 1,
			player.y + 1,
			BL_ITEM
		)
		local groundItem8 = player:getObjectsInCell(
			player.m,
			player.x + 1,
			player.y - 1,
			BL_ITEM
		)
		local groundItem9 = player:getObjectsInCell(
			player.m,
			player.x + 1,
			player.y + 1,
			BL_ITEM
		)

		local surroundingPC1 = player:getObjectsInCell(
			player.m,
			player.x,
			player.y,
			BL_PC
		)
		local surroundingPC2 = player:getObjectsInCell(
			player.m,
			player.x - 1,
			player.y,
			BL_PC
		)
		local surroundingPC3 = player:getObjectsInCell(
			player.m,
			player.x + 1,
			player.y,
			BL_PC
		)
		local surroundingPC4 = player:getObjectsInCell(
			player.m,
			player.x,
			player.y - 1,
			BL_PC
		)
		local surroundingPC5 = player:getObjectsInCell(
			player.m,
			player.x,
			player.y + 1,
			BL_PC
		)
		local surroundingPC6 = player:getObjectsInCell(
			player.m,
			player.x - 1,
			player.y - 1,
			BL_PC
		)
		local surroundingPC7 = player:getObjectsInCell(
			player.m,
			player.x - 1,
			player.y + 1,
			BL_PC
		)
		local surroundingPC8 = player:getObjectsInCell(
			player.m,
			player.x + 1,
			player.y - 1,
			BL_PC
		)
		local surroundingPC9 = player:getObjectsInCell(
			player.m,
			player.x + 1,
			player.y + 1,
			BL_PC
		)

		if #groundItem1 > 0 then
			for i = 1, #groundItem1 do
				if groundItem1[i].id <= 3 then
					--If it is coins
					if player:canLoot(groundItem1[i]) then
						--if it is not cursed
						groundItem1[i]:delete()
						player:addGold(groundItem1[i].amount)
					end
				elseif groundItem1[i].id > 3 then
					--If it is an item
					if player:canLoot(groundItem1[i]) then
						--if it is not cursed
						characterLog.pickUpWrite(
							player,
							groundItem1[i],
							groundItem1[i].amount
						)
						player:pickUp(groundItem1[i].ID)
					end
				end
			end
		end

		if #groundItem2 > 0 then
			for i = 1, #groundItem2 do
				if groundItem2[i].id <= 3 then
					--If it is coins
					if player:canLoot(groundItem2[i]) and #surroundingPC2 == 0 then
						--if it is not cursed
						groundItem2[i]:delete()
						player:addGold(groundItem2[i].amount)
					end
				elseif groundItem2[i].id > 3 then
					--If it is an item
					if player:canLoot(groundItem2[i]) and #surroundingPC2 == 0 then
						--if it is not cursed
						characterLog.pickUpWrite(
							player,
							groundItem2[i],
							groundItem2[i].amount
						)
						player:pickUp(groundItem2[i].ID)
					end
				end
			end
		end

		if #groundItem3 > 0 then
			for i = 1, #groundItem3 do
				if groundItem3[i].id <= 3 then
					--If it is coins
					if player:canLoot(groundItem3[i]) and #surroundingPC3 == 0 then
						--if it is not cursed
						groundItem3[i]:delete()
						player:addGold(groundItem3[i].amount)
					end
				elseif groundItem3[i].id > 3 then
					--If it is an item
					if player:canLoot(groundItem3[i]) and #surroundingPC3 == 0 then
						--if it is not cursed
						characterLog.pickUpWrite(
							player,
							groundItem3[i],
							groundItem3[i].amount
						)
						player:pickUp(groundItem3[i].ID)
					end
				end
			end
		end

		if #groundItem4 > 0 then
			for i = 1, #groundItem4 do
				if groundItem4[i].id <= 3 then
					--If it is coins
					if player:canLoot(groundItem4[i]) and #surroundingPC4 == 0 then
						--if it is not cursed
						groundItem4[i]:delete()
						player:addGold(groundItem4[i].amount)
					end
				elseif groundItem4[i].id > 3 then
					--If it is an item
					if player:canLoot(groundItem4[i]) and #surroundingPC4 == 0 then
						--if it is not cursed
						characterLog.pickUpWrite(
							player,
							groundItem4[i],
							groundItem4[i].amount
						)
						player:pickUp(groundItem4[i].ID)
					end
				end
			end
		end

		if #groundItem5 > 0 then
			for i = 1, #groundItem5 do
				if groundItem5[i].id <= 3 then
					--If it is coins
					if player:canLoot(groundItem5[i]) and #surroundingPC5 == 0 then
						--if it is not cursed
						groundItem5[i]:delete()
						player:addGold(groundItem5[i].amount)
					end
				elseif groundItem5[i].id > 3 then
					--If it is an item
					if player:canLoot(groundItem5[i]) and #surroundingPC5 == 0 then
						--if it is not cursed
						characterLog.pickUpWrite(
							player,
							groundItem5[i],
							groundItem5[i].amount
						)
						player:pickUp(groundItem5[i].ID)
					end
				end
			end
		end

		if #groundItem6 > 0 then
			for i = 1, #groundItem6 do
				if groundItem6[i].id <= 3 then
					--If it is coins
					if player:canLoot(groundItem6[i]) and #surroundingPC6 == 0 then
						--if it is not cursed
						groundItem6[i]:delete()
						player:addGold(groundItem6[i].amount)
					end
				elseif groundItem6[i].id > 3 then
					--If it is an item
					if player:canLoot(groundItem6[i]) and #surroundingPC6 == 0 then
						--if it is not cursed
						characterLog.pickUpWrite(
							player,
							groundItem6[i],
							groundItem6[i].amount
						)
						player:pickUp(groundItem6[i].ID)
					end
				end
			end
		end

		if #groundItem7 > 0 then
			for i = 1, #groundItem7 do
				if groundItem7[i].id <= 3 then
					--If it is coins
					if player:canLoot(groundItem7[i]) and #surroundingPC7 == 0 then
						--if it is not cursed
						groundItem7[i]:delete()
						player:addGold(groundItem7[i].amount)
					end
				elseif groundItem7[i].id > 3 then
					--If it is an item
					if player:canLoot(groundItem7[i]) and #surroundingPC7 == 0 then
						--if it is not cursed
						characterLog.pickUpWrite(
							player,
							groundItem7[i],
							groundItem7[i].amount
						)
						player:pickUp(groundItem7[i].ID)
					end
				end
			end
		end

		if #groundItem8 > 0 then
			for i = 1, #groundItem8 do
				if groundItem8[i].id <= 3 then
					--If it is coins
					if player:canLoot(groundItem8[i]) and #surroundingPC8 == 0 then
						--if it is not cursed
						groundItem8[i]:delete()
						player:addGold(groundItem8[i].amount)
					end
				elseif groundItem8[i].id > 3 then
					--If it is an item
					if player:canLoot(groundItem8[i]) and #surroundingPC8 == 0 then
						--if it is not cursed
						characterLog.pickUpWrite(
							player,
							groundItem8[i],
							groundItem8[i].amount
						)
						player:pickUp(groundItem8[i].ID)
					end
				end
			end
		end

		if #groundItem9 > 0 then
			for i = 1, #groundItem9 do
				if groundItem9[i].id <= 3 then
					--If it is coins
					if player:canLoot(groundItem9[i]) and #surroundingPC9 == 0 then
						--if it is not cursed
						groundItem9[i]:delete()
						player:addGold(groundItem9[i].amount)
					end
				elseif groundItem9[i].id > 3 then
					--If it is an item
					if player:canLoot(groundItem9[i]) and #surroundingPC9 == 0 then
						--if it is not cursed
						characterLog.pickUpWrite(
							player,
							groundItem9[i],
							groundItem9[i].amount
						)
						player:pickUp(groundItem9[i].ID)
					end
				end
			end
		end
	end
end
