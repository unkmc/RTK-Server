soothe = {
	cast = function(player)
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < 3) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		player.attacker = player.ID
		player:addHealthExtend(50, 0, 0, 0, 0, 0)
		player.magic = player.magic - 3
		player:playSound(708)
		player:sendAnimation(5)
		player:sendMinitext("You cast Soothe.")
		player:sendStatus()
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 1
		local items = {"rabbit_meat", "acorn"}
		local itemAmounts = {5, 5}
		local description = "Healing spell for Peasants."
		return level, items, itemAmounts, description
	end
}
