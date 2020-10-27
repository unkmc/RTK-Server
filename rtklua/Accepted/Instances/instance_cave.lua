instance_cave = {
	on_spawn = function(mob)
		local modifiers = instance_cave.lookupModifiers(mob)
		mob.look = mob.mapRegistry["moblook"]
		mob.lookColor = mob.mapRegistry["moblookcolor"]
		for i = 1, #modifiers do
			if modifiers[i].modifier == "increased_mob_health" then
				mob.maxHealth = mob.maxHealth * (1 + (modifiers[i].value / 100))
				mob.health = mob.maxHealth
			end
			if modifiers[i].modifier == "increased_mob_damage" then
				mob.minDam = mob.minDam * (1 + (modifiers[i].value / 100))
				mob.maxDam = mob.maxDam * (1 + (modifiers[i].value / 100))
			end
			if modifiers[i].modifier == "increased_player_exp" then
				mob.experience = mob.experience * (1 + (modifiers[i].value / 100))
			end
		end
		mob:updateState()
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
		instance_cave.moveOrAttackMods(mob)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
		instance_cave.moveOrAttackMods(mob)
	end,

	after_death = function(mob, block)
		local modifiers = instance_cave.lookupModifiers(mob)
		local rand = math.random(1, 100)
		if rand <= 5 then
			mob:dropItem("map_fragment", 1)
		end
		for i = 1, #modifiers do
			if modifiers[i].modifier == "chance_drop_ambers" then
				if rand <= modifiers[i].value then
					mob:dropItem("amber", 1)
				end
			end
			if modifiers[i].modifier == "chance_drop_dark_ambers" then
				if rand <= modifiers[i].value then
					mob:dropItem("dark_amber", 1)
				end
			end
			if modifiers[i].modifier == "chance_drop_yellow_ambers" then
				if rand <= modifiers[i].value then
					mob:dropItem("yellow_amber", 1)
				end
			end
		end

		local index = instance_cave.getMobInstanceIndex(mob)
		if index ~= 0 then
			instances[index].kills = instances[index].kills + 1
		end
	end,

	lookupModifiers = function(mob)
		for i = 1, #instances do
			for k = 1, #instances[i].maps do
				if mob.m == instances[i].maps[k] then
					return instances[i].modifiers
				end
			end
		end
	end,

	moveOrAttackMods = function(mob)
		local modifiers = instance_cave.lookupModifiers(mob)
		for i = 1, #modifiers do
			if modifiers[i].modifier == "healing" then
				local rand = math.random(1, 7)
				if rand == 1 and mob.paralyzed == false then
					mob:sendAnimation(5)
					mob:addHealthExtend(mob.maxHealth *.1, 0, 0, 0, 0, 0)
				end
			end
			if modifiers[i].modifier == "raging" then
				if mob.health < mob.maxHealth *.25 then
					mob:sendAnimation(248)
					mob.minDam = math.floor((mob.minDam * (1 + (modifiers[i].value / 100))) * 1.25)
					mob.maxDam = math.floor((mob.maxDam * (1 + (modifiers[i].value / 100))) * 1.25)
					mob:updateState()
				end
			end
		end
	end,

	getMobInstanceIndex = function(mob)
		for i = 1, #instances do
			for k = 1, #instances[i].maps do
				if mob.m == instances[i].maps[k] then
					return i
				end
			end
		end
		return 0
	end,
}
