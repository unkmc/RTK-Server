stagger = {
	cast = function(player)
		local duration = 60000
		local magicCost = 1

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(43)
		player:calcStat()
		player:setDuration("stagger", duration)
		player:sendMinitext("You are wildly afraid.")
		player:sendMinitext("You cast Stagger.")
	end,

	while_cast = function(player)
		player.drunk = 1
		player:sendStatus()
	end,

	recast = function(player)
		player.drunk = 1
		player:sendStatus()
	end,

	uncast = function(player)
		player.drunk = 0
		player:sendStatus()
		player:sendMinitext("You relax, and return to your state.")
	end
}
