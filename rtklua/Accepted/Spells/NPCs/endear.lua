endear = {
	cast = function(player, mob)
		local magicCost = 300
		local duration = 15000
		local aether = 6000
		local spellName = "endear"

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

			--player:sendAction(6,35)

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
	end
}
