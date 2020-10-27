magic_shrine_spell = {
	cast = function(player)
		if player:hasDuration("magic_shrine_spell") == true then
			return
		end
		player:sendAnimation(3)
		player.maxMagic = math.floor(player.maxMagic * 1.5)
		player:setDuration("magic_shrine_spell", 300000)
		player:sendStatus()
	end,
	recast = function(player)
		player.maxMagic = math.floor(player.maxMagic * 1.5)
		player:setDuration("magic_shrine_spell", 300000)
		player:sendStatus()
	end,
	uncast = function(player)
		player:calcStat()
	end
}
