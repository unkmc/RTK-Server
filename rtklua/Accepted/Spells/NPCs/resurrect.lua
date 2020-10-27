resurrect = {
	cast = function(target)
		if target == nil then
			return
		end

		if target.state == 1 then
			target.state = 0
			target.health = target.maxHealth
			target.magic = target.maxMagic
			target:sendAnimation(427)
			target:playSound(112)
			target:updateState()
			target:sendStatus()
		end
	end
}
