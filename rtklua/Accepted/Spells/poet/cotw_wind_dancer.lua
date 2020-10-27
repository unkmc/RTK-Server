cotw_wind_dancer_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 567

		local aether = 480000
		local duration = 54000

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

		player:setAether("cotw_wind_dancer_poet", aether)
		player.magic = player.magic - magicCost
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendStatus()

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 99
		local items = {
			Item("splendid_tiger_pelt").id,
			Item("well_crafted_white_amber").id,
			Item("yellow_amber").id,
			0
		}
		local itemAmounts = {10, 1, 10, 150000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

kwisin_champion_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 593

		local aether = 480000
		local duration = 54000

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

		player:setAether("kwisin_champion_poet", aether)
		player.magic = player.magic - magicCost
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendStatus()

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 99
		local items = {
			Item("splendid_tiger_pelt").id,
			Item("well_crafted_white_amber").id,
			Item("yellow_amber").id,
			0
		}
		local itemAmounts = {10, 1, 10, 150000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

mingken_champion_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 594

		local aether = 480000
		local duration = 54000

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

		player:setAether("mingken_champion_poet", aether)
		player.magic = player.magic - magicCost
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendStatus()

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 99
		local items = {
			Item("splendid_tiger_pelt").id,
			Item("well_crafted_white_amber").id,
			Item("yellow_amber").id,
			0
		}
		local itemAmounts = {10, 1, 10, 150000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}

ohaeng_champion_poet = {
	cast = function(player)
		local magicCost = 10
		local mobID = 595

		local aether = 480000
		local duration = 54000

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

		player:setAether("ohaeng_champion_poet", aether)
		player.magic = player.magic - magicCost
		player:sendAction(6, 20)
		player:playSound(22)
		player:sendStatus()

		cotw_SpawnSetThreat(player, mobID, 300)
	end,

	requirements = function(player)
		local level = 99
		local items = {
			Item("splendid_tiger_pelt").id,
			Item("well_crafted_white_amber").id,
			Item("yellow_amber").id,
			0
		}
		local itemAmounts = {10, 1, 10, 150000}
		local description = "Summon a creature to assist you."
		return level, items, itemAmounts, description
	end
}
