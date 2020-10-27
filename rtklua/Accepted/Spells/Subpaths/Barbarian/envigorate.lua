envigorate = {
	cast = function(player)
		local magicCost = 1000
		local healAmount = 5000
		local aethers = 500000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:setAether("envigorate", aethers)
		player.magic = player.magic - magicCost
		player:sendStatus()

		player:sendAction(6, 35)
		player:sendAnimation(11, 25)
		player.attacker = player.ID
		player:addHealthExtend(healAmount, 0, 0, 0, 0, 0)
		player:sendMinitext("You cast Envigorate.")
	end,

	requirements = function(player)
		local level = 9
		local items = {Item("aged_wine").id, 0}
		local itemAmounts = {1, 100}
		local description = "a healing spell that allows you to heal others for 200 Vita"
		return level, items, itemAmounts, description
	end
}
