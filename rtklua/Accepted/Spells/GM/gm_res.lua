gm_res = {
	cast = function(player)
		pc = player:getObjectsInMap(player.m, BL_PC)
		if #pc > 0 then
			for i = 1, #pc do
				if pc[i].state == 1 then
					pc[i].state = 0
				end
				pc[i].health = pc[i].maxHealth
				pc[i].magic = pc[i].maxMagic
				pc[i]:sendAnimation(427)
				pc[i]:playSound(112)
				pc[i]:updateState()
				pc[i]:sendStatus()
			end
		end

		player:sendAction(6, 20)
	end
}
