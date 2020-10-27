buya_library_mob = {
	on_spawn = function(mob)
		setBuyaLibraryQuestMobDifficulty(mob)
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		local chance = math.random(1, 10)

		if chance == 7 then
			venom.cast(mob, target)
		end

		--mob:talk(0,""..chance)

		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}

setBuyaLibraryQuestMobDifficulty = function(mob)
	--levels
	-- 1-69, 70-99, 99-il san, ee san, sam san+

	local level = 1

	--mobs mercenary, nagnag_mercenary_1, nagnag_mercenary_2, nagnag_mercenary_3
	-- armory_mercenary_1a-3c

	if mob.m >= 6502 and mob.m <= 6519 then
		level = 1
	end
	if mob.m >= 6522 and mob.m <= 6539 then
		level = 2
	end
	if mob.m >= 6542 and mob.m <= 6559 then
		level = 3
	end
	if mob.m >= 6562 and mob.m <= 6579 then
		level = 4
	end
	if mob.m >= 6582 and mob.m <= 6599 then
		level = 5
	end

	if level == 1 then
		-- used large bull
		mob.maxHealth = 25000
		mob.level = 53
		mob.minDam = 225
		mob.maxDam = 350
		mob.grace = 53
		mob.will = 53
		mob.armor = -20
		mob.hit = 0
		mob.experience = 190000
	elseif level == 2 then
		-- used radiant snake
		mob.maxHealth = 61000
		mob.level = 81
		mob.minDam = 1200
		mob.maxDam = 1400
		mob.hit = 81
		mob.grace = 81
		mob.will = 81
		mob.armor = -45
		mob.experience = 600000
	elseif level == 3 then
		-- used glowing snake
		mob.maxHealth = 375000
		mob.level = 99
		mob.minDam = 4500
		mob.maxDam = 5250
		mob.grace = 99
		mob.will = 99
		mob.armor = -60
		mob.hit = 99
		mob.experience = 3250000
	elseif level == 4 then
		-- used fire rat
		mob.maxHealth = 545000
		mob.level = 99
		mob.minDam = 6000
		mob.maxDam = 10000
		mob.grace = 99
		mob.will = 99
		mob.armor = -80
		mob.hit = 99
		mob.experience = 4400000
	elseif level == 5 then
		-- used fire snorter
		mob.maxHealth = 810000
		mob.level = 99
		mob.minDam = 12000
		mob.maxDam = 15200
		mob.grace = 99
		mob.will = 99
		mob.armor = -70
		mob.hit = 99
		mob.experience = 6300000
	end

	on_spawn(mob)
end
