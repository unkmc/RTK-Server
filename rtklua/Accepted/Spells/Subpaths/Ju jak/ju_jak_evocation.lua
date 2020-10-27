ju_jak_evocation = {
	cast = function(player)
		if player.magic > math.floor(player.magic / 3) then
			player.health = player.health + math.floor(player.health * (100 / player.magic))
		end
		player.magic = player.maxMagic
		player:sendAnimation(37, 3)
		player:sendMinitext("You cast Ju jak evocation.")
		player:setAether("ju_jak_evocation", 500000)
		player:playSound(705)
		player:updateState()
		player:sendStatus()
		player:sendAction(6, 20)
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("surge").id, Item("ju_jak_key").id, 0}
		local itemAmounts = {1, 1, 50000}
		local description = "Empower your mind."

		if (Config.freeNpcSubpathsEnabled) then
			items = {}
			itemAmounts = {}
		end

		return level, items, itemAmounts, description
	end
}
