pilgrimage = {
	cast = async(function(player)
		-- no fucking idea what this spell does... I do suspect it is an RP mark of some kind but still getting info.
	end),

	requirements = function(player)
		local level = 60
		local items = {"bosatsu_bead"}
		local itemAmounts = {4}
		local description = "Blessing others"
		return level, items, itemAmounts, description
	end
}
