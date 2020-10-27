wolfs_fury_warrior = {
	cast = function(player)
		local magic = 30
		if not player:canCast(1, 1, 0) then
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
		player:sendMinitext("You cast Wolf's Fury.")
		player:setDuration("wolfs_fury_warrior", 625000)
		player:sendAnimation(11)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 2
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 7
		local items = {Item("rabbit_meat").id, 0}
		local itemAmounts = {25, 100}
		local description = "A rage-filled assault."
		return level, items, itemAmounts, description
	end
}

souls_rage_warrior = {
	cast = function(player)
		local magic = 30
		if not player:canCast(1, 1, 0) then
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
		player:sendMinitext("You cast Soul's Rage.")
		player:setDuration("souls_rage_warrior", 625000)
		player:sendAnimation(103)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 2
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 7
		local items = {Item("rabbit_meat").id, 0}
		local itemAmounts = {25, 100}
		local description = "A rage-filled assault."
		return level, items, itemAmounts, description
	end
}

spirit_of_the_forest_warrior = {
	cast = function(player)
		local magic = 30
		if not player:canCast(1, 1, 0) then
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
		player:sendMinitext("You cast Spirit of the Forest.")
		player:setDuration("spirit_of_the_forest_warrior", 625000)
		player:sendAnimation(106)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 2
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 7
		local items = {Item("rabbit_meat").id, 0}
		local itemAmounts = {25, 100}
		local description = "A rage-filled assault."
		return level, items, itemAmounts, description
	end
}

augmentation_warrior = {
	cast = function(player)
		local magic = 30
		if not player:canCast(1, 1, 0) then
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
		player:sendMinitext("You cast Augmentation.")
		player:setDuration("augmentation_warrior", 625000)
		player:sendAnimation(59)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 2
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 7
		local items = {Item("rabbit_meat").id, 0}
		local itemAmounts = {25, 100}
		local description = "A rage-filled assault."
		return level, items, itemAmounts, description
	end
}
