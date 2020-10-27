druids_rodent = {
	cast = function(player)
		local duration = 155000
		local magicCost = 30

		if player:checkIfCast(morphs) then
			player:removeDuras(morphs)
			return
		end

		local q = string.lower(player.question)

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if (q == "rabbit") then
			player.disguise = 21
		elseif (q == "rat") then
			player.disguise = 91
		else
			return
		end

		player:setDuration("druids_rodent", duration)
		player.state = 4
		player.disguiseColor = player.armorColor
		player:playSound(703)
		player:sendAnimation(3)
		player:updateState()
	end,

	uncast = function(player)
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
