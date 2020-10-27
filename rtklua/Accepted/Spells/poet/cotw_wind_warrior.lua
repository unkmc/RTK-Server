cotw_wind_warrior_poet = {
	cast = function(player)
		local mobID = 568

		local aethers = 480000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if cotw_spawnCheck(player, mobID) == false then
			return
		end

		player:setAether("cotw_wind_warrior_poet", aethers)
		player:sendAction(6, 20)
		player:playSound(22)

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {250000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

kwisin_avatar_poet = {
	cast = function(player)
		local mobID = 596

		local aethers = 480000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if cotw_spawnCheck(player, mobID) == false then
			return
		end

		player:setAether("kwisin_avatar_poet", aethers)
		player:sendAction(6, 20)
		player:playSound(22)

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {250000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

mingken_avatar_poet = {
	cast = function(player)
		local mobID = 597

		local aethers = 480000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if cotw_spawnCheck(player, mobID) == false then
			return
		end

		player:setAether("mingken_avatar_poet", aethers)
		player:sendAction(6, 20)
		player:playSound(22)

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {250000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

ohaeng_avatar_poet = {
	cast = function(player)
		local mobID = 598

		local aethers = 480000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if cotw_spawnCheck(player, mobID) == false then
			return
		end

		player:setAether("ohaeng_avatar_poet", aethers)
		player:sendAction(6, 20)
		player:playSound(22)

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {250000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}
