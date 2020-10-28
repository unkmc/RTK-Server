local _maxDamage = 2000

venom_mage = {
	cast = function(player, target)
		local magicCost = 60

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.blType == BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(venoms) then
			player:sendMinitext("Another spell of this type is already cast.")
			return
		end

		player:sendAction(6, 35)
		player:playSound(24)
		player.magic = player.magic - magicCost
		player:sendMinitext("You cast Venom.")
		player:sendStatus()

		if (target.blType == BL_MOB) then
			target:setDuration("venom_mage", 1 + math.random(3000, 30000))
			target:sendAnimation(1)
			target.attacker = player.ID
		end
	end,

	while_cast_1500 = function(target)
		local damage = target.baseHealth *.01

		if (damage > _maxDamage) then
			damage = _maxDamage
		end

		if (damage < 1) then
			damage = 1
		end

		if (target.blType == BL_PC) then
			local player = Player(target.attacker)
			if (player:canPK(target)) then
				target:sendAnimation(1)
				target.attacker = player.ID
				if (target.health > damage) then
					target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
				else
					target.health = 1
				end
			end
		else
			target:sendAnimation(1)

			if (target.health > damage) then
				target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
			else
				target.health = 1
			end
		end
	end,
	recast = function(target)
	end,
	uncast = function(player, target)
	end,

	requirements = function(player)
		local level = 59
		local items = {
			Item("snake_meat").id,
			Item("fine_snake_meat").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {10, 3, 1, 500}
		local description = "Poisons target for random amount of time. Does 1000 damage a second."
		return level, items, itemAmounts, description
	end
}

spirits_leech_mage = {
	cast = function(player, target)
		local magicCost = 60

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end
		if (target.blType == BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(venoms) then
			player:sendMinitext("Another spell of this type is already cast.")
			return
		end

		player:sendAction(6, 35)
		player:playSound(24)
		player.magic = player.magic - magicCost
		player:sendMinitext("Spirit's leech.")
		player:sendStatus()
		if (target.blType == BL_MOB) then
			target:setDuration(
				"spirits_leech_mage",
				1 + math.random(1500, 30000)
			)
			target:sendAnimation(84)
			target.attacker = player.ID
		end
	end,
	while_cast_1500 = function(target)
		local damage = target.baseHealth *.01
		if (damage > 1000) then
			damage = 1000
		end
		if (damage < 1) then
			damage = 1
		end
		if (target.blType == BL_PC) then
			local player = Player(target.attacker)
			if (player:canPK(target)) then
				target:sendAnimation(84)
				target.attacker = player.ID
				if (target.health > damage) then
					target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
				else
					target.health = 1
				end
			end
		else
			target:sendAnimation(84)

			if (target.health > damage) then
				target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
			else
				target.health = 1
			end
		end
	end,
	recast = function(target)
	end,
	uncast = function(player, target)
	end,

	requirements = function(player)
		local level = 59
		local items = {
			Item("snake_meat").id,
			Item("fine_snake_meat").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {10, 3, 1, 500}
		local description = "Poisons target for random amount of time. Does 1000 damage a second."
		return level, items, itemAmounts, description
	end
}

snake_bite_mage = {
	cast = function(player, target)
		local magicCost = 60
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end
		if (target.blType == BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(venoms) then
			player:sendMinitext("Another spell of this type is already cast.")
			return
		end

		player:sendAction(6, 35)
		player:playSound(24)
		player.magic = player.magic - magicCost
		player:sendMinitext("You cast Snake bite.")
		player:sendStatus()
		if (target.blType == BL_MOB) then
			target:setDuration("snake_bite_mage", 1 + math.random(1500, 30000))
			target:sendAnimation(84)
			target.attacker = player.ID
		end
	end,
	while_cast_1500 = function(target)
		local damage = target.baseHealth *.01
		if (damage > 1000) then
			damage = 1000
		end
		if (damage < 1) then
			damage = 1
		end
		if (target.blType == BL_PC) then
			local player = Player(target.attacker)
			if (player:canPK(target)) then
				target:sendAnimation(84)
				target.attacker = player.ID
				if (target.health > damage) then
					target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
				else
					target.health = 1
				end
			end
		else
			target:sendAnimation(84)

			if (target.health > damage) then
				target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
			else
				target.health = 1
			end
		end
	end,
	recast = function(target)
	end,
	uncast = function(player, target)
	end,

	requirements = function(player)
		local level = 59
		local items = {
			Item("snake_meat").id,
			Item("fine_snake_meat").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {10, 3, 1, 500}
		local description = "Poisons target for random amount of time. Does 1000 damage a second."
		return level, items, itemAmounts, description
	end
}

corruption_mage = {
	cast = function(player, target)
		local magicCost = 60
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end
		if (target.blType == BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(venoms) then
			player:sendMinitext("Another spell of this type is already cast.")
			return
		end

		player:sendAction(6, 35)
		player:playSound(24)
		player.magic = player.magic - magicCost
		player:sendMinitext("You cast Corruption.")
		player:sendStatus()
		if (target.blType == BL_MOB) then
			target:setDuration("corruption_mage", 1 + math.random(1500, 30000))
			target:sendAnimation(84)
			target.attacker = player.ID
		end
	end,
	while_cast_1500 = function(target)
		local damage = target.baseHealth *.01
		if (damage > 1000) then
			damage = 1000
		end
		if (damage < 1) then
			damage = 1
		end
		if (target.blType == BL_PC) then
			local player = Player(target.attacker)
			if (player:canPK(target)) then
				target:sendAnimation(84)
				target.attacker = player.ID
				if (target.health > damage) then
					target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
				else
					target.health = 1
				end
			end
		else
			target:sendAnimation(84)

			if (target.health > damage) then
				target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
			else
				target.health = 1
			end
		end
	end,
	recast = function(target)
	end,
	uncast = function(player, target)
	end,

	requirements = function(player)
		local level = 59
		local items = {
			Item("snake_meat").id,
			Item("fine_snake_meat").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {10, 3, 1, 500}
		local description = "Poisons target for random amount of time. Does 1000 damage a second."
		return level, items, itemAmounts, description
	end
}
