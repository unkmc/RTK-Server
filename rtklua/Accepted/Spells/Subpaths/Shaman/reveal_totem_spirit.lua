reveal_totem_spirit = {
	requirements = function(player)
		local level = 99
		local items = {"shaman_talisman"}
		local itemAmounts = {1}
		local description = "Reveals someones totem spirit."
		return level, items, itemAmounts, description
	end
}
