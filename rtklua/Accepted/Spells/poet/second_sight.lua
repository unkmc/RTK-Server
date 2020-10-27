second_sight_poet = {
	cast = function(player)
		local magicCost = 240
		local duration = 325000

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if player:hasDuration("second_sight_poet") then
			player:sendMinitext("Not enough time has elapsed. Please try to cast Second Sight again.")
			return
		end
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendMinitext("You cast Second Sight.")
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:setDuration("second_sight_poet", duration)
	end,

	while_cast = function(player)
		if player.timerTick % 15 == 0 then
			local pcs = player:getObjectsInSameMap(BL_PC)
			local dist = 9

			if next(pcs) ~= nil then
				for i = 1, #pcs do
					if pcs[i].state == 2 and distanceSquare(player, pcs[i], dist) then
						-- invisible
						player:sendMinitext(pcs[i].name .. " is hidden in the Area")
					end
				end
			end
		end
	end,

	requirements = function(player)
		local level = 53
		local items = {Item("acorn").id, Item("steel_saber").id, 0}
		local itemAmounts = {100, 1, 500}
		local description = "Reveals invisible people"
		return level, items, itemAmounts, description
	end
}
hear_spirits_poet = {
	cast = function(player)
		local magicCost = 240
		local duration = 325000

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if player:hasDuration("hear_spirits_poet") then
			player:sendMinitext("Not enough time has elapsed. Please try to cast Hear Spirits again.")
			return
		end
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendMinitext("You cast Hear Spirits.")
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:setDuration("hear_spirits_poet", duration)
	end,

	while_cast = function(player)
		if player.timerTick % 15 == 0 then
			local pcs = player:getObjectsInSameMap(BL_PC)
			local dist = 9

			if next(pcs) ~= nil then
				for i = 1, #pcs do
					if pcs[i].state == 2 and distanceSquare(player, pcs[i], dist) then
						-- invisible
						player:sendMinitext(pcs[i].name .. " is hidden in the Area")
					end
				end
			end
		end
	end,

	requirements = function(player)
		local level = 53
		local items = {Item("acorn").id, Item("steel_saber").id, 0}
		local itemAmounts = {100, 1, 500}
		local description = "Reveals invisible people"
		return level, items, itemAmounts, description
	end
}
improve_sight_poet = {
	cast = function(player)
		local magicCost = 240
		local duration = 325000

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if player:hasDuration("improve_sight_poet") then
			player:sendMinitext("Not enough time has elapsed. Please try to cast Improve Sight again.")
			return
		end
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendMinitext("You cast Improve Sight.")
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:setDuration("improve_sight_poet", duration)
	end,

	while_cast = function(player)
		if player.timerTick % 15 == 0 then
			local pcs = player:getObjectsInSameMap(BL_PC)
			local dist = 9

			if next(pcs) ~= nil then
				for i = 1, #pcs do
					if pcs[i].state == 2 and distanceSquare(player, pcs[i], dist) then
						-- invisible
						player:sendMinitext(pcs[i].name .. " is hidden in the Area")
					end
				end
			end
		end
	end,

	requirements = function(player)
		local level = 53
		local items = {Item("acorn").id, Item("steel_saber").id, 0}
		local itemAmounts = {100, 1, 500}
		local description = "Reveals invisible people"
		return level, items, itemAmounts, description
	end
}
show_hidden_poet = {
	cast = function(player)
		local magicCost = 240
		local duration = 325000

		if (not player:canCast(0, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if player:hasDuration("show_hidden_poet") then
			player:sendMinitext("Not enough time has elapsed. Please try to cast Show Hidden again.")
			return
		end
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendMinitext("You cast Show Hidden.")
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:setDuration("show_hidden_poet", duration)
	end,

	while_cast = function(player)
		if player.timerTick % 15 == 0 then
			local pcs = player:getObjectsInSameMap(BL_PC)
			local dist = 9

			if next(pcs) ~= nil then
				for i = 1, #pcs do
					if pcs[i].state == 2 and distanceSquare(player, pcs[i], dist) then
						-- invisible
						player:sendMinitext(pcs[i].name .. " is hidden in the Area")
					end
				end
			end
		end
	end,

	requirements = function(player)
		local level = 53
		local items = {Item("acorn").id, Item("steel_saber").id, 0}
		local itemAmounts = {100, 1, 500}
		local description = "Reveals invisible people"
		return level, items, itemAmounts, description
	end
}
