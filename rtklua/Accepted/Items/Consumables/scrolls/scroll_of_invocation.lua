scroll_of_invocation = {
	use = function(player)
		if (not player:canCast(0, 1, 0)) then
			player:sendMinitext("You cannot do that right now.")
			return
		end

		local healthCost = math.floor(player.maxMagic *.4)

		if (player.health - healthCost < 100) then
			player.health = 100
		else
			player.health = player.health - healthCost
		end

		player.magic = player.maxMagic
		player:sendAction(6, 20)
		player:playSound(85)
		player:sendAnimation(11)
		player:sendStatus()
		player:sendMinitext("You cast Invoke.")

		player:removeItem("scroll_of_invocation", 1, 6)
	end
}
