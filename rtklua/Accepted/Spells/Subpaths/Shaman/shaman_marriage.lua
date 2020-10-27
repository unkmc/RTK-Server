shaman_marriage = {
	requirements = function(player)
		local level = 99
		local items = {"rose", "shaman_talisman", 0}
		local itemAmounts = {50, 1, 10000}
		local description = "Marry two people anywhere in the Nexus."
		return level, items, itemAmounts, description
	end
}
