cotw_gorilla_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 566

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
		local level = 99
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

kwisin_warrior_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 590

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
		local level = 99
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

mingken_warrior_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 591

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
		local level = 99
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

ohaeng_warrior_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 592

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
		local level = 99
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}
