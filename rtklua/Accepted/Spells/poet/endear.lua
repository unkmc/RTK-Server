endear_poet = {
	cast = function(player)
		local magicCost = 300
		local duration = 15000
		local aether = 6000
		local spellName = "endear_poet"

		if player.gmLevel > 0 then
			magicCost = 0
			aether = 0
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		local mob = getTargetFacing(player, BL_MOB)

		if mob ~= nil then
			if mob.isBoss == 1 then
				player:sendMinitext("Your will is too weak.")
				return
			end
			if mob.owner ~= 0 then
				return
			end

			if mob:checkIfCast(endears) then
				player:sendMinitext("A spell of this type is already cast.")
				return
			end

			mob:setDuration(spellName, duration)
			mob:sendAnimation(39, 5)

			mob.owner = player.ID
			mob.state = MOB_ALIVE

			player:sendAction(6, 35)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:sendMinitext("You cast Endear.")
			player:playSound(34)
			player:setAether(spellName, aether)
		end
	end,

	uncast = function(mob)
		mob.owner = 0
		mob.target = 0
	end,

	requirements = function(player)
		local level = 33
		local items = {"light_fox_fur", "red_fox_fur", "topaz"}
		local itemAmounts = {10, 10, 1}
		local description = "Mind controls an enemy."
		return level, items, itemAmounts, description
	end
}

possess_soul_poet = {
	cast = function(player)
		local magicCost = 300
		local duration = 15000
		local aether = 6000
		local spellName = "possess_soul_poet"

		if player.gmLevel > 0 then
			magicCost = 0
			aether = 0
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		local mob = getTargetFacing(player, BL_MOB)

		if mob ~= nil then
			if mob.isBoss == 1 then
				player:sendMinitext("Your will is too weak.")
				return
			end
			if mob.owner ~= 0 then
				return
			end

			if mob:checkIfCast(endears) then
				player:sendMinitext("A spell of this type is already cast.")
				return
			end

			mob:setDuration(spellName, duration)
			mob:sendAnimation(39, 5)

			mob.owner = player.ID
			mob.state = MOB_ALIVE

			player:sendAction(6, 35)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:sendMinitext("You cast Possess soul.")
			player:playSound(34)
			player:setAether(spellName, aether)
		end
	end,

	uncast = function(mob)
		mob.owner = 0
		mob.target = 0
	end,

	requirements = function(player)
		local level = 33
		local items = {"light_fox_fur", "red_fox_fur", "topaz"}
		local itemAmounts = {10, 10, 1}
		local description = "Mind controls an enemy."
		return level, items, itemAmounts, description
	end
}

charm_life_poet = {
	cast = function(player)
		local magicCost = 300
		local duration = 15000
		local aether = 6000
		local spellName = "charm_life_poet"

		if player.gmLevel > 0 then
			magicCost = 0
			aether = 0
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		local mob = getTargetFacing(player, BL_MOB)

		if mob ~= nil then
			if mob.isBoss == 1 then
				player:sendMinitext("Your will is too weak.")
				return
			end
			if mob.owner ~= 0 then
				return
			end

			if mob:checkIfCast(endears) then
				player:sendMinitext("A spell of this type is already cast.")
				return
			end

			mob:setDuration(spellName, duration)
			mob:sendAnimation(39, 5)

			mob.owner = player.ID
			mob.state = MOB_ALIVE

			player:sendAction(6, 35)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:sendMinitext("You cast Charm life.")
			player:playSound(34)
			player:setAether(spellName, aether)
		end
	end,

	uncast = function(mob)
		mob.owner = 0
		mob.target = 0
	end,

	requirements = function(player)
		local level = 33
		local items = {"light_fox_fur", "red_fox_fur", "topaz"}
		local itemAmounts = {10, 10, 1}
		local description = "Mind controls an enemy."
		return level, items, itemAmounts, description
	end
}

align_follower_poet = {
	cast = function(player)
		local magicCost = 300
		local duration = 15000
		local aether = 6000
		local spellName = "align_follower_poet"

		if player.gmLevel > 0 then
			magicCost = 0
			aether = 0
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		local mob = getTargetFacing(player, BL_MOB)

		if mob ~= nil then
			if mob.isBoss == 1 then
				player:sendMinitext("Your will is too weak.")
				return
			end
			if mob.owner ~= 0 then
				return
			end

			if mob:checkIfCast(endears) then
				player:sendMinitext("A spell of this type is already cast.")
				return
			end

			mob:setDuration(spellName, duration)
			mob:sendAnimation(39, 5)

			mob.owner = player.ID
			mob.state = MOB_ALIVE

			player:sendAction(6, 35)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:sendMinitext("You cast Align follower.")
			player:playSound(34)
			player:setAether(spellName, aether)
		end
	end,

	uncast = function(mob)
		mob.owner = 0
		mob.target = 0
	end,

	requirements = function(player)
		local level = 33
		local items = {"light_fox_fur", "red_fox_fur", "topaz"}
		local itemAmounts = {10, 10, 1}
		local description = "Mind controls an enemy."
		return level, items, itemAmounts, description
	end
}
