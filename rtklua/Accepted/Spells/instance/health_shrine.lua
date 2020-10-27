health_shrine_spell = {
	cast = function(player)
		if player:hasDuration("health_shrine_spell") == true then
			return
		end
		player:sendAnimation(3)
		player.maxHealth = math.floor(player.maxHealth * 1.5)
		player:setDuration("health_shrine_spell", 300000)
		player:sendStatus()
	end,
	recast = function(player)
		player.maxHealth = math.floor(player.maxHealth * 1.5)
		player:setDuration("health_shrine_spell", 300000)
		player:sendStatus()
	end,
	uncast = function(player)
		player:calcStat()
	end
}
