experience_shrine_spell = {
	cast = function(player)
		if player:hasDuration("experience_shrine_spell") == true then
			return
		end
		player:sendAnimation(3)
		player:setDuration("experience_shrine_spell", 600000)
		player:sendStatus()
	end,
	recast = function(player)
		player:setDuration("experience_shrine_spell", 600000)
		player:sendStatus()
	end,
	uncast = function(player)
		player:calcStat()
	end
}
