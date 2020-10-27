relief_warrior = {
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
		local level = 31
		local items = {
			Item("acorn").id,
			Item("red_fox_fur").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {80, 10, 10, 200}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}

renew_essence_warrior = {
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
		local level = 31
		local items = {
			Item("acorn").id,
			Item("red_fox_fur").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {80, 10, 10, 200}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}

lifesong_warrior = {
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
		local level = 31
		local items = {
			Item("acorn").id,
			Item("red_fox_fur").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {80, 10, 10, 200}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}

sweet_waters_warrior = {
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
		local level = 31
		local items = {
			Item("acorn").id,
			Item("red_fox_fur").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {80, 10, 10, 200}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}
