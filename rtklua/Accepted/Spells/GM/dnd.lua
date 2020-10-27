dnd = {
	cast = function(player)
		local armor = {
			318,
			320,
			329,
			332,
			338,
			342,
			10088,
			10163,
			10195,
			10196,
			10239,
			10240,
			10263,
			10277,
			10349,
			10347
		}

		if player:hasDuration("dnd") then
			player:setDuration("dnd", 0)
			player.gfxClone = 0
			player:updateState()
			return
		else
			if player.gfxClone == 0 then
				clone.equip(player, player)
			else
				clone.gfx(player, player)
			end
			player.gfxArmor = armor[math.random(#armor)]
			player:sendMinitext("Armor used: " .. armor[math.random(#armor)])
			player.gfxArmorC = 0
			player.gfxClone = 1
			player:updateState()
			for i = 1, 5 do
				player:sendAnimationXY(
					16,
					math.random(player.x - 2, player.x + 2),
					math.random(player.y - 2, player.y + 2)
				)
			end
			player:setDuration("dnd", 720000)
		end
	end,

	while_cast = function(player)
		if realSecond() % 5 == 0 then
			player:playSound(112)
		end

		--420
		player:sendAnimationXY(math.random(20, 21), player.x - 3, player.y - 1)
		player:sendAnimationXY(math.random(20, 21), player.x - 2, player.y - 2)
		player:sendAnimationXY(math.random(20, 21), player.x - 1, player.y - 3)
		player:sendAnimationXY(math.random(20, 21), player.x + 1, player.y - 3)
		player:sendAnimationXY(math.random(20, 21), player.x + 2, player.y - 2)
		player:sendAnimationXY(math.random(20, 21), player.x + 3, player.y - 1)
		player:sendAnimationXY(math.random(20, 21), player.x + 3, player.y + 1)
		player:sendAnimationXY(math.random(20, 21), player.x + 2, player.y + 2)
		player:sendAnimationXY(math.random(20, 21), player.x + 1, player.y + 3)
		player:sendAnimationXY(math.random(20, 21), player.x - 1, player.y + 3)
		player:sendAnimationXY(math.random(20, 21), player.x - 2, player.y + 2)
		player:sendAnimationXY(math.random(20, 21), player.x - 3, player.y + 1)
		player:sendAnimation(116)

		--player:sendAnimation(366)
		player:sendAnimation(376)

		player:sendAnimation(33)
	end,

	while_cast_250 = function(player)
		local mob = player:getObjectsInArea(BL_MOB)
		local pc = player:getObjectsInArea(BL_PC)
		player:sendAction(6, 250)
		if #mob > 0 then
			for i = 1, #mob do
				if mob[i].mark == 0 then
					if distanceSquare(player, mob[i], 3) then
						mob[i]:sendAnimation(143)
						pushBack(mob[i])
						player:sendAction(6, 20)
					end
				end
			end
		end
		if #pc > 0 then
			for i = 1, #pc do
				if distanceSquare(player, pc[i], 3) then
					if pc[i].ID ~= player.ID and pc[i].gmLevel == 0 then
						pc[i]:sendAnimation(143)
						pushBack(pc[i])
						pc[i]:sendMinitext("Sedang konsentrasi bertapa.")
						player:sendAction(6, 20)
					end
				end
			end
		end
	end,

	uncast = function(player)
		player.gfxClone = 0
		player:updateState()
		for i = 1, 5 do
			player:sendAnimationXY(
				16,
				math.random(player.x - 2, player.x + 2),
				math.random(player.y - 2, player.y + 2)
			)
		end
		player:calcStat()
	end
}
