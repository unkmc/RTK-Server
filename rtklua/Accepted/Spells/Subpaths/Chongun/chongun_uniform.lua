chongun_uniform = {
	cast = function(player)
		local magic = 25
		local duration = 162000

		if player:hasDuration("chongun_uniform") then
			player:setDuration("chongun_uniform", 0)
			return
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player:checkIfCast(invis) or player.state == 2 then
			player:sendMinitext("You cannot cast Chongun Uniform while invisible.")
			return
		end

		player:sendAnimation(3, 3)
		player.magic = player.magic - magic
		player.state = 4
		player.disguise = 37
		player.disguiseColor = player.armorColor
		player:setDuration("chongun_uniform", duration)
		player:sendStatus()
		player:sendAction(6, 35)
		player:updateState()
	end,

	uncast = function(player)
		if player.state ~= 1 then
			-- dead
			player.state = 0
		end
		player:updateState()
	end,
	requirements = function(player)
		local level = 99
		local items = {"spring_robes", "light_fox_fur"}
		local itemAmounts = {1, 20}
		local description = "Wear the Chongun's uniform."
		return level, items, itemAmounts, description
	end
}
