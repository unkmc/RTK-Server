mass_res = {
	cast = function(player)
		check = player:getObjectsInArea(BL_PC)
		if (#check > 0) then
			for i = 1, #check do
				if (check[i].state == 1) then
					check[i].state = 0
					check[i].health = check[i].maxHealth
					check[i].magic = check[i].maxMagic
					check[i]:sendStatus()
					check[i]:updateState()
				end
			end
		end
	end
}
