onScriptedTilesMythicFallRooms = function(player)
	if player.state == 1 then
		return
	end

	local m = player.m
	local x = player.x
	local y = player.y

	local fallrate = 500
	local rand = math.random(1, fallrate)

	-------- Mythic Fall Rooms
	---Monkey 1
	if (m == 167 or m == 168) then
		if (rand == fallrate) then
			player:warp(169, 23, 3)
			player:refresh()
		end
	end

	---Monkey 2
	if (m == 3167 or m == 3168) then
		if (rand == fallrate) then
			player:warp(3169, 23, 3)
			player:refresh()
		end
	end

	---Monkey 3
	if (m == 4167 or m == 4168) then
		if (rand == fallrate) then
			player:warp(4169, 23, 3)
			player:refresh()
		end
	end

	---Rooster 1
	if (m == 212 or m == 216 or m == 218) then
		if (rand == fallrate) then
			player:warp(217, 10, 17)
			player:refresh()
		end
	end

	---Rooster 2
	if (m == 3212 or m == 3216 or m == 3218) then
		if (rand == fallrate) then
			player:warp(3217, 10, 17)
			player:refresh()
		end
	end

	---Rooster 3
	if (m == 4212 or m == 4216 or m == 4218) then
		if (rand == fallrate) then
			player:warp(4217, 10, 17)
			player:refresh()
		end
	end

	---Rabbit 1
	if (m == 203 or m == 205 or m == 208) then
		if (rand == fallrate) then
			player:warp(208, 15, 18)
			player:refresh()
		end
	end

	---Rabbit 2
	if (m == 3203 or m == 3205 or m == 3208) then
		if (rand == fallrate) then
			player:warp(3208, 15, 18)
			player:refresh()
		end
	end

	---Rabbit 3
	if (m == 4203 or m == 4205 or m == 4208) then
		if (rand == fallrate) then
			player:warp(4208, 15, 18)
			player:refresh()
		end
	end

	---Sheep 1
	if (m == 482 or m == 484) then
		if (rand == fallrate) then
			player:warp(479, 23, 3)
			player:refresh()
		end
	end

	---Sheep 2
	if (m == 3482 or m == 3484) then
		if (rand == fallrate) then
			player:warp(3479, 23, 3)
			player:refresh()
		end
	end

	---Sheep 3
	if (m == 4482 or m == 4484) then
		if (rand == fallrate) then
			player:warp(4479, 23, 3)
			player:refresh()
		end
	end

	---Ox 1
	if (m == 178 or m == 177) then
		if (rand == fallrate) then
			player:warp(180, 22, 7)
			player:refresh()
		end
	end

	---Ox 2
	if (m == 3178 or m == 3177) then
		if (rand == fallrate) then
			player:warp(3180, 22, 7)
			player:refresh()
		end
	end

	---Ox 3
	if (m == 4178 or m == 4177) then
		if (rand == fallrate) then
			player:warp(4180, 22, 7)
			player:refresh()
		end
	end

	---Pig 1
	if (m == 186 or m == 187 or m == 190) then
		if (rand == fallrate) then
			player:warp(183, 2, 9)
			player:refresh()
		end
	end

	---Pig 2
	if (m == 3186 or m == 3187 or m == 3190) then
		if (rand == fallrate) then
			player:warp(3183, 2, 9)
			player:refresh()
		end
	end

	---Pig 3
	if (m == 4186 or m == 4187 or m == 4190) then
		if (rand == fallrate) then
			player:warp(4183, 2, 9)
			player:refresh()
		end
	end

	---Horse 1
	if (m == 245 or m == 243 or m == 247) then
		if (rand == fallrate) then
			player:warp(244, 15, 25)
			player:refresh()
		end
	end

	---Horse 2
	if (m == 3245 or m == 3243 or m == 3247) then
		if (rand == fallrate) then
			player:warp(3244, 15, 25)
			player:refresh()
		end
	end

	---Horse 3
	if (m == 4245 or m == 4243 or m == 4247) then
		if (rand == fallrate) then
			player:warp(4244, 15, 25)
			player:refresh()
		end
	end

	---Dog 1
	if (m == 192 or m == 194 or m == 199) then
		if (rand == fallrate) then
			player:warp(196, 11, 38)
			player:refresh()
		end
	end

	---Dog 2
	if (m == 3192 or m == 3194 or m == 3199) then
		if (rand == fallrate) then
			player:warp(3196, 11, 38)
			player:refresh()
		end
	end

	---Dog 3
	if (m == 4192 or m == 4194 or m == 4199) then
		if (rand == fallrate) then
			player:warp(4196, 11, 38)
			player:refresh()
		end
	end

	---Dragon 1
	if (m == 253 or m == 254 or m == 258) then
		if (rand == fallrate) then
			player:warp(255, 12, 34)
			player:refresh()
		end
	end

	---Dragon 2
	if (m == 3253 or m == 3254 or m == 3258) then
		if (rand == fallrate) then
			player:warp(3255, 12, 34)
			player:refresh()
		end
	end

	---Dragon 3
	if (m == 4253 or m == 4254 or m == 4258) then
		if (rand == fallrate) then
			player:warp(4255, 12, 34)
			player:refresh()
		end
	end

	---Snake 1
	if (m == 237 or m == 236 or m == 233) then
		if (rand == fallrate) then
			player:warp(235, 1, 4)
			player:refresh()
		end
	end

	---Snake 2
	if (m == 3237 or m == 3236 or m == 3233) then
		if (rand == fallrate) then
			player:warp(3235, 1, 4)
			player:refresh()
		end
	end

	---Snake 3
	if (m == 4237 or m == 4236 or m == 4233) then
		if (rand == fallrate) then
			player:warp(4235, 1, 4)
			player:refresh()
		end
	end

	---Iron lab
	if (m == 1302 or m == 1303 or m == 1304 or m == 1305 or m == 1306) then
		if (rand == fallrate) then
			player:warp(1307, 4, 5)
			player:refresh()
		end
	end
end
