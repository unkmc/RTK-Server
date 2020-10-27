fascinate = {
	cast = function(player, target)
		local magicCost = 210
		local duration = 30000
		local aether = 3000

		local spellName = "fascinate"

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
			player:sendMinitext("You cast Fascinate.")
			player:playSound(34)
			player:setAether(spellName, aether)
		end
	end,

	uncast = function(mob)
		mob.owner = 0
		mob.target = 0
	end,

	requirements = function(player)
		local level = 80
		local items = {"titanium_lance", "sen_glove"}
		local itemAmounts = {1, 1}
		local description = "Mind controls an enemy."
		return level, items, itemAmounts, description
	end
}
