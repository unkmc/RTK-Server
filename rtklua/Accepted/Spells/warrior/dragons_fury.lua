dragons_fury_warrior = {
	cast = function(player)
		local magic = 150
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
		player:sendMinitext("You cast Dragon's Fury.")
		player:setDuration("dragons_fury_warrior", 625000)
		player:sendAnimation(11)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 4
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 45
		local items = {
			Item("fine_snake_meat").id,
			Item("fox_tail").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {5, 1, 20, 750}
		local description = "An awesome attack."
		return level, items, itemAmounts, description
	end
}

strength_of_ancestors_warrior = {
	cast = function(player)
		local magic = 150
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
		player:sendMinitext("You cast Strength of Ancestors.")
		player:setDuration("strength_of_ancestors_warrior", 625000)
		player:sendAnimation(103)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 4
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 45
		local items = {
			Item("fine_snake_meat").id,
			Item("fox_tail").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {5, 1, 20, 750}
		local description = "An awesome attack."
		return level, items, itemAmounts, description
	end
}

spirit_of_the_dragon_warrior = {
	cast = function(player)
		local magic = 150
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
		player:sendMinitext("You cast Spirit of the Dragon.")
		player:setDuration("spirit_of_the_dragon_warrior", 625000)
		player:sendAnimation(106)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 4
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 45
		local items = {
			Item("fine_snake_meat").id,
			Item("fox_tail").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {5, 1, 20, 750}
		local description = "An awesome attack."
		return level, items, itemAmounts, description
	end
}

ohaengs_anger_warrior = {
	cast = function(player)
		local magic = 150
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
		player:sendMinitext("You cast Ohaeng's Anger.")
		player:setDuration("ohaengs_anger_warrior", 625000)
		player:sendAnimation(70)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 4
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 45
		local items = {
			Item("fine_snake_meat").id,
			Item("fox_tail").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {5, 1, 20, 750}
		local description = "An awesome attack."
		return level, items, itemAmounts, description
	end
}
