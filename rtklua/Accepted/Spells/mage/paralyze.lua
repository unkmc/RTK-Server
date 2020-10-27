paralyze_mage = {
	cast = function(player, target)
		local duration = 20000
		local magicCost = 100
		local chance = 70 + (player.will *.2307)
		local rand = math.random(100)

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType == BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if (target.paralyzed == true) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		if (rand > chance) then
			player:sendMinitext("Something went wrong.")
			return
		end

		if (target.blType == BL_MOB) then
			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(70)
			player:sendMinitext("You cast Paralyze.")
			target:setDuration("paralyze_mage", duration)
			target:sendAnimation(1, 0)
			target.paralyzed = true
		end
	end,

	uncast = function(target)
		target.paralyzed = false
	end,

	requirements = function(player)
		local level = 62
		local items = {Item("battle_helm").id, Item("antler").id, 0}
		local itemAmounts = {1, 20, 500}
		local description = "Disables a target from moving."
		return level, items, itemAmounts, description
	end
}

spirit_leash_mage = {
	cast = function(player, target)
		local duration = 20000
		local magicCost = 100
		local chance = 70 + (player.will *.2307)
		local rand = math.random(100)

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType == BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if (target.paralyzed == true) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		if (rand > chance) then
			player:sendMinitext("Something went wrong.")
			return
		end

		if (target.blType == BL_MOB) then
			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(86)
			player:sendMinitext("You cast Spirit Leash.")
			target:setDuration("spirit_leash_mage", duration)
			target:sendAnimation(88, 0)
			target.paralyzed = true
		end
	end,

	uncast = function(target)
		target.paralyzed = false
	end,

	requirements = function(player)
		local level = 62
		local items = {Item("battle_helm").id, Item("antler").id, 0}
		local itemAmounts = {1, 20, 500}
		local description = "Disables a target from moving."
		return level, items, itemAmounts, description
	end
}

cold_binds_mage = {
	cast = function(player, target)
		local duration = 20000
		local magicCost = 100
		local chance = 70 + (player.will *.2307)
		local rand = math.random(100)

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType == BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if (target.paralyzed == true) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		if (rand > chance) then
			player:sendMinitext("Something went wrong.")
			return
		end

		if (target.blType == BL_MOB) then
			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(48)
			player:sendMinitext("You cast Cold Binds.")
			target:setDuration("cold_binds_mage", duration)
			target:sendAnimation(99, 0)
			target.paralyzed = true
		end
	end,

	uncast = function(target)
		target.paralyzed = false
	end,

	requirements = function(player)
		local level = 62
		local items = {Item("battle_helm").id, Item("antler").id, 0}
		local itemAmounts = {1, 20, 500}
		local description = "Disables a target from moving."
		return level, items, itemAmounts, description
	end
}

lockup_mage = {
	cast = function(player, target)
		local duration = 20000
		local magicCost = 100
		local chance = 70 + (player.will *.2307)
		local rand = math.random(100)

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType == BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if (target.paralyzed == true) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		if (rand > chance) then
			player:sendMinitext("Something went wrong.")
			return
		end

		if (target.blType == BL_MOB) then
			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(20)
			player:sendMinitext("You cast Lockup.")
			target:setDuration("lockup_mage", duration)
			target:sendAnimation(120, 0)
			target.paralyzed = true
		end
	end,

	uncast = function(target)
		target.paralyzed = false
	end,

	requirements = function(player)
		local level = 62
		local items = {Item("battle_helm").id, Item("antler").id, 0}
		local itemAmounts = {1, 20, 500}
		local description = "Disables a target from moving."
		return level, items, itemAmounts, description
	end
}
