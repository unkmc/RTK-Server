tigers_fury_warrior = {
	cast = function(player)
		local magic = 90
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if player:checkIfCast(lesserFuries) or player.rage > 1 then
			player:sendMinitext("This spell is already active.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:sendMinitext("You cast Tiger's Fury.")
		player:setDuration("tigers_fury_warrior", 625000)
		player:sendAnimation(11)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 24
		local items = {Item("antler").id, Item("fox_fur").id, 0}
		local itemAmounts = {5, 15, 250}
		local description = "An attack with great rage."
		return level, items, itemAmounts, description
	end
}

filling_the_soul_warrior = {
	cast = function(player)
		local magic = 90
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if player:checkIfCast(lesserFuries) or player.rage > 1 then
			player:sendMinitext("This spell is already active.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:sendMinitext("You cast Filling the Soul.")
		player:setDuration("filling_the_soul_warrior", 625000)
		player:sendAnimation(103)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 24
		local items = {Item("antler").id, Item("fox_fur").id, 0}
		local itemAmounts = {5, 15, 250}
		local description = "An attack with great rage."
		return level, items, itemAmounts, description
	end
}

spirit_of_the_wild_warrior = {
	cast = function(player)
		local magic = 90
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if player:checkIfCast(lesserFuries) or player.rage > 1 then
			player:sendMinitext("This spell is already active.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:sendMinitext("You cast Spirit of the Wild.")
		player:setDuration("spirit_of_the_wild_warrior", 625000)
		player:sendAnimation(106)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 24
		local items = {Item("antler").id, Item("fox_fur").id, 0}
		local itemAmounts = {5, 15, 250}
		local description = "An attack with great rage."
		return level, items, itemAmounts, description
	end
}

ohaengs_grace_warrior = {
	cast = function(player)
		local magic = 90
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if player:checkIfCast(lesserFuries) or player.rage > 1 then
			player:sendMinitext("This spell is already active.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(70)
		player:sendMinitext("You cast Ohaeng's Grace.")
		player:setDuration("ohaengs_grace_warrior", 625000)
		player:sendAnimation(59)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 24
		local items = {Item("antler").id, Item("fox_fur").id, 0}
		local itemAmounts = {5, 15, 250}
		local description = "An attack with great rage."
		return level, items, itemAmounts, description
	end
}
