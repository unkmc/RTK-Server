hyun_moo_revival = {
	cast = function(player)
		local magicCost = 10000

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if (not player:canCast(0, 1, 0)) then
			return
		end

		player.state = 0
		player.health = player.maxHealth
		player.magic = player.maxMagic - 10000
		player:updateState()
		player:sendStatus()

		player:sendAnimation(38, 3)
		player:sendMinitext("You cast Hyun moo revival.")
		player:setAether("hyun_moo_revival", 1500000)

		player:sendAction(6, 20)
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("hyun_moo_key").id, Item("purified_water").id, 0}
		local itemAmounts = {1, 1, 50000}
		local description = "Fully heal and even revive yourself."

		if (Config.freeNpcSubpathsEnabled) then
			items = {}
			itemAmounts = {}
		end

		return level, items, itemAmounts, description
	end
}
