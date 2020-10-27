watchful_eye_warrior = {
	cast = function(player)
		local magic = 125
		local aethers = 25000

		if player.gmLevel > 0 then
			aethers = 0
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(0)
		player:setAether("watchful_eye_warrior", aethers)
		seeSpotTraps(player)
		player:sendStatus()
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 38
		local items = {Item("rat_meat").id, Item("amber").id, 0}
		local itemAmounts = {10, 1, 100}
		local description = "Spot hidden ambushes."
		return level, items, itemAmounts, description
	end
}

spirits_whisper_warrior = {
	cast = function(player)
		local magic = 125
		local aethers = 25000

		if player.gmLevel > 0 then
			aethers = 0
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(0)
		player:setAether("spirits_whisper_warrior", aethers)
		seeSpotTraps(player)
		player:sendStatus()
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 38
		local items = {Item("rat_meat").id, Item("amber").id, 0}
		local itemAmounts = {10, 1, 100}
		local description = "Spot hidden ambushes."
		return level, items, itemAmounts, description
	end
}

creatures_guidance_warrior = {
	cast = function(player)
		local magic = 125
		local aethers = 25000

		if player.gmLevel > 0 then
			aethers = 0
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(0)
		player:setAether("creatures_guidance_warrior", aethers)
		seeSpotTraps(player)
		player:sendStatus()
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 38
		local items = {Item("rat_meat").id, Item("amber").id, 0}
		local itemAmounts = {10, 1, 100}
		local description = "Spot hidden ambushes."
		return level, items, itemAmounts, description
	end
}

spot_unbalance_warrior = {
	cast = function(player)
		local magic = 125
		local aethers = 25000

		if player.gmLevel > 0 then
			aethers = 0
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(0)
		player:setAether("spot_unbalance_warrior", aethers)
		seeSpotTraps(player)
		player:sendStatus()
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 38
		local items = {Item("rat_meat").id, Item("amber").id, 0}
		local itemAmounts = {10, 1, 100}
		local description = "Spot hidden ambushes."
		return level, items, itemAmounts, description
	end
}
