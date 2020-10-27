dragons_tooth = {
	use = function(player)
		if (not player:canCast(1, 1, 1)) then
			return
		end

		player:removeDuras(morphs)

		if not player:hasDuration("dragons_form") then
			player:removeItem("dragons_tooth", 1, 6)
			dragons_form.cast(player)
		end
	end
}
