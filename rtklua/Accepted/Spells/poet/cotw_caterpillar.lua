-- @TODO: I know this doesn't belong here, but the COTW structure is so terrible already, I'll just fix it when I rewrite all of COTW.
cotw_giasomo_bird_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 807

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
	end
}

cotw_caterpillar_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 562

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
		local level = 68
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

kwisin_companion_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 578

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
		local level = 68
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

mingken_companion_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 579

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
		local level = 68
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

ohaeng_companion_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 580

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
		local level = 68
		local items = {Item("acorn").id, Item("pearl_charm").id, 0}
		local itemAmounts = {100, 1, 1000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}
