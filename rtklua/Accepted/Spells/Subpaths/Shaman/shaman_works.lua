shaman_works = {
	requirements = function(player)
		local level = 99
		local items = {"shaman_talisman"}
		local itemAmounts = {1}
		local description = "Add and remove branding."
		return level, items, itemAmounts, description
	end
}
