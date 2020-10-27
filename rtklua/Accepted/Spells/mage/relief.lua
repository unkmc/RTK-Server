relief_mage = {
	cast = function(player)
		local spellName = "Relief"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 200, 120, 0)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,
	requirements = function(player)
		local level = 28
		local items = {
			Item("gold_acorn").id,
			Item("snake_meat").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {1, 10, 1, 250}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}

renew_essence_mage = {
	cast = function(player)
		local spellName = "Renew Essence"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 200, 120, 1)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,
	requirements = function(player)
		local level = 28
		local items = {
			Item("gold_acorn").id,
			Item("snake_meat").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {1, 10, 1, 250}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}

lifesong_mage = {
	cast = function(player)
		local spellName = "Lifesong"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 200, 120, 2)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,
	requirements = function(player)
		local level = 28
		local items = {
			Item("gold_acorn").id,
			Item("snake_meat").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {1, 10, 1, 250}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}

sweet_waters_mage = {
	cast = function(player)
		local spellName = "Sweet Waters"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 200, 120, 3)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,
	requirements = function(player)
		local level = 28
		local items = {
			Item("gold_acorn").id,
			Item("snake_meat").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {1, 10, 1, 250}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}
