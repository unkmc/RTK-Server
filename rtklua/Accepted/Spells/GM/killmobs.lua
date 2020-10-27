killmobs = {
	cast = function(player)
		local aethers = 1

		local mobs = player:getObjectsInMap(player.m, BL_MOB)

		for i = 1, #mobs do
			mobs[i]:sendAnimation(153)
			mobs[i].attacker = player.ID
			mobs[i]:removeHealthExtend(999999999, 0, 0, 0, 0, 0)
		end

		if player.gmLevel == 0 then
			player:setAether("killmobs", aethers)
			return
		end
		player:refresh()
	end
}
