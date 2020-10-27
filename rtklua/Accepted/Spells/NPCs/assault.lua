assault = {
	cast = function(player)
		local x = {}
		local y = {}
		local s = player.side
		local sound = 60
		local magic = 5000
		local spellName = "Assault"
		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (s == 0) then
			x = {0, -1, 0, 1}
			y = {-1, -2, -2, -2}
		elseif (s == 1) then
			x = {1, 2, 2, 2}
			y = {0, -1, 0, 1}
		elseif (s == 2) then
			x = {0, -1, 0, 1}
			y = {1, 2, 2, 2}
		elseif (s == 3) then
			x = {-1, -2, -2, -2}
			y = {0, 1, 0, -1}
		else
			return
		end
		local landed = 0
		player:sendAction(1, 30)

		player:setAether("assault", 80000)
		player:talk(2, "Assault~!")

		for i = 1, 4 do
			local target = player:getAliveObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_MOB
			)
			if #target > 0 then
				global_attack.cast(
					player,
					target[1],
					math.ceil(player.health * 0.75),
					0,
					0
				)
				landed = 1
				player.health = math.ceil(player.health * 0.75)
			end

			target = player:getAliveObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_attack.cast(
					player,
					target[1],
					math.ceil(player.health * 0.50),
					0,
					0
				)
				if worked == 2 then
					target[1]:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
					landed = 1
					player.health = math.ceil(player.health * 0.50)
				end
			end
		end

		player:sendStatus()
		player:playSound(sound)
		player:removeHealth(35000, 1, 0, 0, 0, 0)
		player:sendMinitext("You cast " .. spellName .. ".")
	end
}
