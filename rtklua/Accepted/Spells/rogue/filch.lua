filch_rogue = {
	cast = function(player)
		local magic = 30
		local spaces = 1
		local looted = false
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:sendStatus()
		player:sendAction(6, 35)
		player:talk(2, "I'll take that")

		for i = 1, spaces do
			local pc = {}
			local item = {}

			if (player.side == 0) then
				pc = player:getObjectsInCell(
					player.m,
					player.x,
					player.y - i,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x,
						player.y - i,
						BL_ITEM
					)
				end
			elseif (player.side == 1) then
				pc = player:getObjectsInCell(
					player.m,
					player.x + i,
					player.y,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x + i,
						player.y,
						BL_ITEM
					)
				end
			elseif (player.side == 2) then
				pc = player:getObjectsInCell(
					player.m,
					player.x,
					player.y + i,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x,
						player.y + i,
						BL_ITEM
					)
				end
			elseif (player.side == 3) then
				pc = player:getObjectsInCell(
					player.m,
					player.x - i,
					player.y,
					BL_PC
				)

				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x - i,
						player.y,
						BL_ITEM
					)
				end
			end

			if item ~= nil then
				for j = 1, #item do
					if player:canLoot(item[j]) and #pc == 0 then
						if item[j].id <= 3 then
							-- coins
							player.money = player.money + item[j].amount
						else
							player:addItem(
								item[j].id,
								item[j].amount,
								item[j].dura,
								item[j].owner,
								item[j].time,
								item[j].realName,
								item[j].customLook,
								item[j].customLookColor,
								item[j].customIcon,
								item[j].customIconColor,
								item[j].protected
							)
						end
						item[j]:delete()
					else
						player:sendMinitext("But that would be stealing.")
					end
				end
			end
		end
	end,

	requirements = function(player)
		local level = 65
		local items = {"acorn", "steel_sword", 0}
		local itemAmounts = {130, 1, 2000}
		local description = "Allows you to grab items up to 4 tiles away in the direction you are facing. Will not pick up items that a player is standing on or an item belonging to someone's deathpile"
		return level, items, itemAmounts, description
	end
}

spirits_hand_rogue = {
	cast = function(player)
		local magic = 30
		local spaces = 1
		local looted = false
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:sendStatus()
		player:sendAction(6, 35)
		player:talk(2, "I'll take that")

		for i = 1, spaces do
			local pc = {}
			local item = {}

			if (player.side == 0) then
				pc = player:getObjectsInCell(
					player.m,
					player.x,
					player.y - i,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x,
						player.y - i,
						BL_ITEM
					)
				end
			elseif (player.side == 1) then
				pc = player:getObjectsInCell(
					player.m,
					player.x + i,
					player.y,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x + i,
						player.y,
						BL_ITEM
					)
				end
			elseif (player.side == 2) then
				pc = player:getObjectsInCell(
					player.m,
					player.x,
					player.y + i,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x,
						player.y + i,
						BL_ITEM
					)
				end
			elseif (player.side == 3) then
				pc = player:getObjectsInCell(
					player.m,
					player.x - i,
					player.y,
					BL_PC
				)

				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x - i,
						player.y,
						BL_ITEM
					)
				end
			end

			if item ~= nil then
				for j = 1, #item do
					if player:canLoot(item[j]) and #pc == 0 then
						if item[j].id <= 3 then
							-- coins
							player.money = player.money + item[j].amount
						else
							player:addItem(
								item[j].id,
								item[j].amount,
								item[j].dura,
								item[j].owner,
								item[j].time,
								item[j].realName,
								item[j].customLook,
								item[j].customLookColor,
								item[j].customIcon,
								item[j].customIconColor,
								item[j].protected
							)
						end
						item[j]:delete()
					else
						player:sendMinitext("But that would be stealing.")
					end
				end
			end
		end
	end,

	requirements = function(player)
		local level = 65
		local items = {"acorn", "steel_sword", 0}
		local itemAmounts = {130, 1, 2000}
		local description = "Allows you to grab items up to 4 tiles away in the direction you are facing. Will not pick up items that a player is standing on or an item belonging to someone's deathpile"
		return level, items, itemAmounts, description
	end
}

quick_fingers_rogue = {
	cast = function(player)
		local magic = 30
		local spaces = 1
		local looted = false
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:sendStatus()
		player:sendAction(6, 35)
		player:talk(2, "I'll take that")

		for i = 1, spaces do
			local pc = {}
			local item = {}

			if (player.side == 0) then
				pc = player:getObjectsInCell(
					player.m,
					player.x,
					player.y - i,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x,
						player.y - i,
						BL_ITEM
					)
				end
			elseif (player.side == 1) then
				pc = player:getObjectsInCell(
					player.m,
					player.x + i,
					player.y,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x + i,
						player.y,
						BL_ITEM
					)
				end
			elseif (player.side == 2) then
				pc = player:getObjectsInCell(
					player.m,
					player.x,
					player.y + i,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x,
						player.y + i,
						BL_ITEM
					)
				end
			elseif (player.side == 3) then
				pc = player:getObjectsInCell(
					player.m,
					player.x - i,
					player.y,
					BL_PC
				)

				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x - i,
						player.y,
						BL_ITEM
					)
				end
			end

			if item ~= nil then
				for j = 1, #item do
					if player:canLoot(item[j]) and #pc == 0 then
						if item[j].id <= 3 then
							-- coins
							player.money = player.money + item[j].amount
						else
							player:addItem(
								item[j].id,
								item[j].amount,
								item[j].dura,
								item[j].owner,
								item[j].time,
								item[j].realName,
								item[j].customLook,
								item[j].customLookColor,
								item[j].customIcon,
								item[j].customIconColor,
								item[j].protected
							)
						end
						item[j]:delete()
					else
						player:sendMinitext("But that would be stealing.")
					end
				end
			end
		end
	end,

	requirements = function(player)
		local level = 65
		local items = {"acorn", "steel_sword", 0}
		local itemAmounts = {130, 1, 2000}
		local description = "Allows you to grab items up to 4 tiles away in the direction you are facing. Will not pick up items that a player is standing on or an item belonging to someone's deathpile"
		return level, items, itemAmounts, description
	end
}

light_touch_rogue = {
	cast = function(player)
		local magic = 30
		local spaces = 1
		local looted = false
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:sendStatus()
		player:sendAction(6, 35)
		player:talk(2, "I'll take that")

		for i = 1, spaces do
			local pc = {}
			local item = {}

			if (player.side == 0) then
				pc = player:getObjectsInCell(
					player.m,
					player.x,
					player.y - i,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x,
						player.y - i,
						BL_ITEM
					)
				end
			elseif (player.side == 1) then
				pc = player:getObjectsInCell(
					player.m,
					player.x + i,
					player.y,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x + i,
						player.y,
						BL_ITEM
					)
				end
			elseif (player.side == 2) then
				pc = player:getObjectsInCell(
					player.m,
					player.x,
					player.y + i,
					BL_PC
				)
				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x,
						player.y + i,
						BL_ITEM
					)
				end
			elseif (player.side == 3) then
				pc = player:getObjectsInCell(
					player.m,
					player.x - i,
					player.y,
					BL_PC
				)

				if next(pc) == nil then
					item = player:getObjectsInCell(
						player.m,
						player.x - i,
						player.y,
						BL_ITEM
					)
				end
			end

			if item ~= nil then
				for j = 1, #item do
					if player:canLoot(item[j]) and #pc == 0 then
						if item[j].id <= 3 then
							-- coins
							player.money = player.money + item[j].amount
						else
							player:addItem(
								item[j].id,
								item[j].amount,
								item[j].dura,
								item[j].owner,
								item[j].time,
								item[j].realName,
								item[j].customLook,
								item[j].customLookColor,
								item[j].customIcon,
								item[j].customIconColor,
								item[j].protected
							)
						end
						item[j]:delete()
					else
						player:sendMinitext("But that would be stealing.")
					end
				end
			end
		end
	end,

	requirements = function(player)
		local level = 65
		local items = {"acorn", "steel_sword", 0}
		local itemAmounts = {130, 1, 2000}
		local description = "Allows you to grab items up to 4 tiles away in the direction you are facing. Will not pick up items that a player is standing on or an item belonging to someone's deathpile"
		return level, items, itemAmounts, description
	end
}
