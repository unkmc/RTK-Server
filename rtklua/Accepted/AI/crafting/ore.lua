ore = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)

			if weapon ~= nil then
				if weapon.yname == "mining_pick" then
					mob.attacker = attacker.ID

					if attacker:checkIfCast(flanks) then
						attacker:removeDuras(flanks)
					end
					if attacker:checkIfCast(backstabs) then
						attacker:removeDuras(backstabs)
					end
					if attacker:checkIfCast(furies) then
						attacker:removeDuras(furies)
					end

					mob.registry["attackerTime"] = os.time() + 120

					-- 2 mins

					if mob.registry["attacker"] == 0 then
						mob.registry["attacker"] = attacker.ID
					end

					-- tags the mob

					if mob.registry["attacker"] ~= 0 and mob.registry["attacker"] == attacker.ID then
						-- only allows damage if you have tagged the mob

						local skill = crafting.getSkillLevel(attacker, "mining")
						local damage = 65

						if skill == "novice" then
							damage = 70
						end
						if skill == "apprentice" then
							damage = 80
						end
						if skill == "accomplished" then
							damage = 90
						end
						if skill == "adept" then
							damage = 100
						end
						if skill == "talented" then
							damage = 125
						end
						if skill == "skilled" then
							damage = 150
						end
						if skill == "expert" then
							damage = 175
						end
						if skill == "master" then
							damage = 200
						end
						if skill == "grandmaster" then
							damage = 225
						end
						if skill == "champion" then
							damage = 230
						end
						if skill == "legendary" then
							damage = 235
						end

						if math.random(1, 33) == 1 then
							damage = damage * 5
							attacker:sendMinitext("You wind up and take a large chunk!  *CRACK*")
						end

						mob:removeHealth(damage)
						attacker.damage = 0
					end
				end
			else
				attacker:sendMinitext("You cannot mine with an empty hand.")
			end
		end
	end,
	after_death = function(mob, attacker)
		local skill = crafting.getSkillLevel(attacker, "mining")
		attacker:addItem(ore.getOre(skill), 1)
		crafting.skillChanceIncrease(attacker, NPC("Thane"), "mining")

		for z = 1, 8 do
			local rand = math.random(1, 2)
			if (rand == 1) then
				attacker:addItem(ore.getOre(skill), 1)
				crafting.skillChanceIncrease(attacker, NPC("Thane"), "mining")
			end
		end
		attacker:sendMinitext("You have gathered some Ore.")
	end,
	getOre = function(skill)
		if skill == "novice" then
			local rand = math.random(1, 100)
			if rand <= 35 then
				return "ore_med"
			else
				return "ore_poor"
			end
		elseif skill == "apprentice" then
			local rand = math.random(1, 100)
			if rand <= 7 then
				return "ore_high"
			elseif rand <= 40 then
				return "ore_med"
			else
				return "ore_poor"
			end
		elseif skill == "accomplished" then
			local rand = math.random(1, 100)
			if rand <= 8 then
				return "ore_high"
			elseif rand <= 45 then
				return "ore_med"
			else
				return "ore_poor"
			end
		elseif skill == "adept" then
			local rand = math.random(1, 100)
			if rand == 1 then
				return "ore_very_high"
			elseif rand <= 10 then
				return "ore_high"
			elseif rand <= 50 then
				return "ore_med"
			else
				return "ore_poor"
			end
		elseif skill == "talented" then
			local rand = math.random(1, 100)
			if rand == 1 then
				return "ore_very_high"
			elseif rand == 2 then
				return "quartz"
			elseif rand <= 12 then
				return "ore_high"
			elseif rand <= 55 then
				return "ore_med"
			else
				return "ore_poor"
			end
		elseif skill == "skilled" then
			local rand = math.random(1, 100)
			if rand == 1 then
				return "ore_very_high"
			elseif rand == 2 then
				return "quartz"
			elseif rand == 3 then
				return "silver_ore"
			elseif rand <= 14 then
				return "ore_high"
			elseif rand <= 60 then
				return "ore_med"
			else
				return "ore_poor"
			end
		elseif skill == "expert" then
			local rand = math.random(1, 100)
			if rand == 1 then
				return "ore_very_high"
			elseif rand == 2 then
				return "quartz"
			elseif rand == 3 then
				return "silver_ore"
			elseif rand == 4 then
				return "gold_ore"
			elseif rand <= 16 then
				return "ore_high"
			elseif rand <= 65 then
				return "ore_med"
			else
				return "ore_poor"
			end
		elseif skill == "master" then
			local rand = math.random(1, 100)
			if rand == 1 then
				return "ore_very_high"
			elseif rand == 2 then
				return "quartz"
			elseif rand == 3 then
				return "silver_ore"
			elseif rand == 4 then
				return "gold_ore"
			elseif rand <= 17 then
				return "ore_high"
			elseif rand <= 70 then
				return "ore_med"
			else
				return "ore_poor"
			end
		else
			local rand = math.random(1, 100)
			if rand <= 5 then
				return "ore_med"
			else
				return "ore_poor"
			end
		end
	end,
	move = function(mob)
		-- runs off of mob move timer (1s)

		if os.time() > mob.registry["attackerTime"] and mob.registry["attackerTime"] ~= 0 then
			-- resets if time is 2 mins past the last attack time
			mob.registry["attackerTime"] = 0
			mob.registry["attacker"] = 0
			mob.health = mob.maxHealth
			mob.attacker = 0
		end
	end,

	attack = function(mob, attacker)
		if (os.time() > mob.registry["attackerTime"] and mob.registry["attackerTime"] ~= 0) or not distanceSquare(
			mob,
			attacker,
			5
		) then
			-- resets if time is 2 mins past the last attack time or attacker leaves map
			mob.registry["attackerTime"] = 0
			mob.registry["attacker"] = 0
			mob.health = mob.maxHealth
			mob.attacker = 0
			mob.state = MOB_ALIVE
		end
	end,
}

ore_poor = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)
			if weapon.yname ~= "mining_pick" then
				return
			end
			mob.attacker = attacker.ID
			mob:sendHealth(attacker.damage, attacker.critChance)
			attacker.damage = 0
		end
	end,

	after_death = function(mob, attacker)
		if (attacker.blType ~= BL_PC) then
			return
		end
		local weapon = attacker:getEquippedItem(EQ_WEAP)
		if weapon.yname == "mining_pick" then
			crafting.skillChanceIncrease(attacker, NPC("Gruff"), "mining")
		end
	end
}

ore_med = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)
			if weapon.yname ~= "mining_pick" then
				return
			end
			mob.attacker = attacker.ID
			mob:sendHealth(attacker.damage, attacker.critChance)
			attacker.damage = 0
		end
	end,

	after_death = function(mob, attacker)
		if (attacker.blType ~= BL_PC) then
			return
		end
		local weapon = attacker:getEquippedItem(EQ_WEAP)
		if weapon.yname == "mining_pick" then
			crafting.skillChanceIncrease(attacker, NPC("Gruff"), "mining")
		end
	end
}

ore_high = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)
			if weapon.yname ~= "mining_pick" then
				return
			end
			mob.attacker = attacker.ID
			mob:sendHealth(attacker.damage, attacker.critChance)
			attacker.damage = 0
		end
	end,

	after_death = function(mob, attacker)
		if (attacker.blType ~= BL_PC) then
			return
		end
		local weapon = attacker:getEquippedItem(EQ_WEAP)
		if weapon.yname == "mining_pick" then
			crafting.skillChanceIncrease(attacker, NPC("Gruff"), "mining")
		end
	end
}

ore_very_high = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)
			if weapon.yname ~= "mining_pick" then
				return
			end
			mob.attacker = attacker.ID
			mob:sendHealth(attacker.damage, attacker.critChance)
			attacker.damage = 0
		end
	end,

	after_death = function(mob, attacker)
		if (attacker.blType ~= BL_PC) then
			return
		end
		local weapon = attacker:getEquippedItem(EQ_WEAP)
		if weapon.yname == "mining_pick" then
			crafting.skillChanceIncrease(attacker, NPC("Gruff"), "mining")
		end
	end
}

gold_ore = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)
			if weapon.yname ~= "mining_pick" then
				return
			end
			mob.attacker = attacker.ID
			mob:sendHealth(attacker.damage, attacker.critChance)
			attacker.damage = 0
		end
	end,

	after_death = function(mob, attacker)
		if (attacker.blType ~= BL_PC) then
			return
		end
		local weapon = attacker:getEquippedItem(EQ_WEAP)
		if weapon.yname == "mining_pick" then
			crafting.skillChanceIncrease(attacker, NPC("Gruff"), "mining")
		end
	end
}

silver_ore = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)
			if weapon.yname ~= "mining_pick" then
				return
			end
			mob.attacker = attacker.ID
			mob:sendHealth(attacker.damage, attacker.critChance)
			attacker.damage = 0
		end
	end,

	after_death = function(mob, attacker)
		if (attacker.blType ~= BL_PC) then
			return
		end
		local weapon = attacker:getEquippedItem(EQ_WEAP)
		if weapon.yname == "mining_pick" then
			crafting.skillChanceIncrease(attacker, NPC("Gruff"), "mining")
		end
	end
}
