dispell_poet = {
	cast = function(player, target)
		local magic = 200

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local armor = 0

		if target.armor < -60 then
			armor = -60
		elseif target.armor > 70 then
			armor = 70
		else
			armor = target.armor
		end

		local prot = target.protection + math.floor((target.will - player.will) / 10)
		armor = armor - prot
		local successRate = math.ceil((120 + armor) / 2)
		if successRate < 10 then
			successRate = 10
		end

		local random = math.random(1, 100)

		if target.blType == BL_NPC or target.blType == BL_MOB then
			player:sendMinitext("It doesn't work.")
			return
		end
		if random > successRate then
			player:sendMinitext("Something went wrong.")
			return
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendStatus()

		target:flushDuration()
		target:sendStatus()
		target:sendAnimation(10)

		player:playSound(34)

		--13
		if (player.ID ~= target.ID) then
			target:sendMinitext(player.name .. " casts Dispell on you.")
		end
		player:sendMinitext("You cast Dispell.")
	end,

	requirements = function(player)
		local level = 88
		local items = {Item("acorn").id, Item("poet_whip").id, 0}
		local itemAmounts = {80, 1, 100}
		local description = "Removes all spells from the target, with few exceptions."
		return level, items, itemAmounts, description
	end
}

remove_magic_poet = {
	cast = function(player, target)
		local magic = 200

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local armor = 0

		if target.armor < -60 then
			armor = -60
		elseif target.armor > 70 then
			armor = 70
		else
			armor = target.armor
		end

		local prot = target.protection + math.floor((target.will - player.will) / 10)
		armor = armor - prot
		local successRate = math.ceil((120 + armor) / 2)
		if successRate < 10 then
			successRate = 10
		end

		local random = math.random(1, 100)

		if target.blType == BL_NPC or target.blType == BL_MOB then
			player:sendMinitext("It doesn't work.")
			return
		end
		if random > successRate then
			player:sendMinitext("Something went wrong.")
			return
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendStatus()

		target:flushDuration()
		target:sendStatus()
		target:sendAnimation(77)

		player:playSound(37)

		--13
		if (player.ID ~= target.ID) then
			target:sendMinitext(player.name .. " casts Remove magic on you.")
		end
		player:sendMinitext("You cast Remove magic.")
	end,

	requirements = function(player)
		local level = 88
		local items = {Item("acorn").id, Item("poet_whip").id, 0}
		local itemAmounts = {80, 1, 100}
		local description = "Removes all spells from the target, with few exceptions."
		return level, items, itemAmounts, description
	end
}

return_natural_poet = {
	cast = function(player, target)
		local magic = 200

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local armor = 0

		if target.armor < -60 then
			armor = -60
		elseif target.armor > 70 then
			armor = 70
		else
			armor = target.armor
		end

		local prot = target.protection + math.floor((target.will - player.will) / 10)
		armor = armor - prot
		local successRate = math.ceil((120 + armor) / 2)
		if successRate < 10 then
			successRate = 10
		end

		local random = math.random(1, 100)

		if target.blType == BL_NPC or target.blType == BL_MOB then
			player:sendMinitext("It doesn't work.")
			return
		end
		if random > successRate then
			player:sendMinitext("Something went wrong.")
			return
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendStatus()

		target:flushDuration()
		target:sendStatus()
		target:sendAnimation(107)

		player:playSound(34)

		--13
		if (player.ID ~= target.ID) then
			target:sendMinitext(player.name .. " casts Return natural on you.")
		end
		player:sendMinitext("You cast Return natural.")
	end,

	requirements = function(player)
		local level = 88
		local items = {Item("acorn").id, Item("poet_whip").id, 0}
		local itemAmounts = {80, 1, 100}
		local description = "Removes all spells from the target, with few exceptions."
		return level, items, itemAmounts, description
	end
}

restore_balance_poet = {
	cast = function(player, target)
		local magic = 200

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local armor = 0

		if target.armor < -60 then
			armor = -60
		elseif target.armor > 70 then
			armor = 70
		else
			armor = target.armor
		end

		local prot = target.protection + math.floor((target.will - player.will) / 10)
		armor = armor - prot
		local successRate = math.ceil((120 + armor) / 2)
		if successRate < 10 then
			successRate = 10
		end

		local random = math.random(1, 100)

		if target.blType == BL_NPC or target.blType == BL_MOB then
			player:sendMinitext("It doesn't work.")
			return
		end
		if random > successRate then
			player:sendMinitext("Something went wrong.")
			return
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendStatus()

		target:flushDuration()
		target:sendStatus()
		target:sendAnimation(108)

		player:playSound(95)

		--13
		if (player.ID ~= target.ID) then
			target:sendMinitext(player.name .. " casts Restore balance on you.")
		end
		player:sendMinitext("You cast Restore balance.")
	end,

	requirements = function(player)
		local level = 88
		local items = {Item("acorn").id, Item("poet_whip").id, 0}
		local itemAmounts = {80, 1, 100}
		local description = "Removes all spells from the target, with few exceptions."
		return level, items, itemAmounts, description
	end
}
