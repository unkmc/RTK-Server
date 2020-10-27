cotw_fluffy_dog_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 563

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Not enough mana.")
			return
		end

		if cotw_spawnCheck(player, mobID) == false then
			return
		end

		player.magic = player.magic - magicCost
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendStatus()

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 72
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

kwisin_assistant_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 581

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Not enough mana.")
			return
		end

		if cotw_spawnCheck(player, mobID) == false then
			return
		end

		player.magic = player.magic - magicCost
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendStatus()

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 72
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

mingken_assistant_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 582

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Not enough mana.")
			return
		end

		if cotw_spawnCheck(player, mobID) == false then
			return
		end

		player.magic = player.magic - magicCost
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendStatus()

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 72
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

ohaeng_assistant_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 583

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Not enough mana.")
			return
		end

		if cotw_spawnCheck(player, mobID) == false then
			return
		end

		player.magic = player.magic - magicCost
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendStatus()

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 72
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}
