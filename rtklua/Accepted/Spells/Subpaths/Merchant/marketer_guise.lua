marketer_guise = {
	cast = function(player)
		local duration = 60000
		local magicCost = 125

		if player:checkIfCast(morphs) then
			player:removeDuras(morphs)
			return
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:setDuration("marketer_guise", duration)
		player.state = 4
		player.disguise = 52
		player.disguiseColor = player.armorColor
		player:playSound(708)
		player:sendAnimation(3)
		player:updateState()
	end,

	uncast = function(player)
		player:playSound(410)
		player.disguise = 0
		player.disguiseColor = 0
		player.state = 0
		player:updateState()
	end,

	requirements = function(player)
		local level = 33
		local items = {"rat_meat", "rabbit_meat"}
		local itemAmounts = {30, 20}
		local description = "Transform into a rabbit or rat."
		return level, items, itemAmounts, description
	end
}
