instance_shrines = {
	{name = "Health Shrine", yname = "health_shrine", color = 25},
	{name = "Magic Shrine", yname = "magic_shrine", color = 0},
	{name = "Experience Shrine", yname = "experience_shrine", color = 4},
	{name = "Explosion Shrine", yname = "explosion_shrine", color = 6}
}

shrine = {
	on_spawn = function(mob)
		local shrine = math.random(1, #instance_shrines)
		mob.look = 681
		mob.lookColor = instance_shrines[shrine].color
		mob.name = instance_shrines[shrine].name
		mob.yname = instance_shrines[shrine].yname
		mob:updateState()
	end,

	on_healed = function(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob:removeHealth(1)
	end,

	move = function(mob, target)
	end,

	attack = function(mob, target)
	end,

	after_death = function(mob, block)
		local players = mob:getObjectsInArea(BL_PC)

		if mob.lookColor == 25 then
			for i = 1, #players do
				health_shrine_spell.cast(players[i])
			end
		end

		if mob.lookColor == 0 then
			for i = 1, #players do
				magic_shrine_spell.cast(players[i])
			end
		end

		if mob.lookColor == 4 then
			for i = 1, #players do
				experience_shrine_spell.cast(players[i])
			end
		end

		if mob.lookColor == 6 then
			local mobs = mob:getObjectsInArea(BL_MOB)
			mob:sendAnimation(85)
			if #mobs > 0 then
				for i = 1, #mobs do
					mobs[i]:removeHealth(mobs[i].health / 2)
				end
			end
		end
	end
}
