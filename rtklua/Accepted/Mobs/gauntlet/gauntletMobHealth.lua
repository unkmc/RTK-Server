gauntletMobHealth = function(mob, color)
	local health = 0

	if color == "red" or color == "blue" then
		if mob.m >= 2545 and mob.m <= 2549 then
			-- gauntlet 1 lvl 10-24
			health = 500
			mob.hit = 3
		elseif mob.m >= 2550 and mob.m <= 2554 then
			-- gauntlet 2 lvl 25-39
			health = 1000
			mob.hit = 6
		elseif mob.m >= 2555 and mob.m <= 2559 then
			-- gauntlet 3 lvl 40-74
			health = 2000
			mob.hit = 9
		elseif mob.m >= 2560 and mob.m <= 2564 then
			-- gauntlet 4 lvl 75-98
			health = 4000
			mob.hit = 20
		elseif mob.m >= 2565 then
			-- gauntlet 5 lvl 99 +
			health = 10000
			mob.hit = 75
		end
	end

	if color == "green" or color == "orange" then
		if mob.m >= 2545 and mob.m <= 2549 then
			-- gauntlet 1 lvl 10-24
			health = 500
			mob.hit = 3
		elseif mob.m >= 2550 and mob.m <= 2554 then
			-- gauntlet 2 lvl 25-39
			health = 1000
			mob.hit = 6
		elseif mob.m >= 2555 and mob.m <= 2559 then
			-- gauntlet 3 lvl 40-74
			health = 2000
			mob.hit = 9
		elseif mob.m >= 2560 and mob.m <= 2564 then
			-- gauntlet 4 lvl 75-98
			health = 4000
			mob.hit = 20
		elseif mob.m >= 2565 then
			-- gauntlet 5 lvl 99 +
			health = 10000
			mob.hit = 75
		end
	end

	mob.maxHealth = health
	mob.health = health
	mob:sendStatus()
end
