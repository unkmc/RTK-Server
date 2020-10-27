crafting_stone = {
	use = function(player)
		if player:hasDuration("crafting_bonus") then
			player:sendMinitext("Crafting bonus already in effect.")
			return
		end

		player:setDuration("crafting_bonus", 7200000)

		-- 2 hours

		player:removeItem("crafting_stone", 1)
	end
}
