invoke = {
	cast = function(player)
		local aether = 22000
		local healthCost = math.floor(player.maxMagic *.4)
		local minMagic = 30

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < minMagic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if (player.health - healthCost < 100) then
			player.health = 100
		else
			player.health = player.health - healthCost
		end

		player:sendAction(6, 20)
		player:setAether("invoke", aether)
		player:playSound(85)
		player:sendAnimation(11)
		player.magic = player.maxMagic
		player:sendStatus()
		player:sendMinitext("You cast Invoke.")
	end
}
