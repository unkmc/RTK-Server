horse_spawn = {
	cast = async(function(player)
		local magic = 30
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:spawn(8, player.x, player.y, 1)
		player:setAether("horse_spawn", 30000)
	end),

	requirements = function(player)
		local level = 1
		local items = {}
		local itemAmounts = {}
		local desc = "This spell."
		return level, items, itemAmounts, desc
	end
}
