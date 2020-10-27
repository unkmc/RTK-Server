lorekeeper = {
	requirements = function(player)
		local level = 99
		local items = {"shaman_talisman", "corrupted_staff", 0}
		local itemAmounts = {1, 1, 15000}
		local description = "Marks a lorekeeper."
		return level, items, itemAmounts, description
	end
}
