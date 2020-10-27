battle_preparation = {
	cast = function(target)
		local duration = 60000
		target:setDuration("battle_preparation", duration)
		target:sendAnimation(11, 0)
		target:calcStat()
	end,
	recast = function(target)
		target.protection = target.protection + 226
		target:sendStatus()
	end,
	uncast = function(target)
		target.protection = target.protection - 226
		target:sendStatus()
	end
}
