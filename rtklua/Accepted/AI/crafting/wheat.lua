very_tall_wheat = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)

			if weapon ~= nil then
				if weapon.yname == "basic_sickle" then
					mob.attacker = attacker.ID

					if attacker:checkIfCast(flanks) then
						attacker:removeDuras(flanks)
					end
					if attacker:checkIfCast(backstabs) then
						attacker:removeDuras(backstabs)
					end

					mob.registry["attackerTime"] = os.time() + 120

					-- 2 mins

					if mob.registry["attacker"] == 0 then
						mob.registry["attacker"] = attacker.ID
					end

					-- tags the mob

					if mob.registry["attacker"] ~= 0 and mob.registry["attacker"] == attacker.ID then
						-- only allows damage if you have tagged the mob

						local grass = {
							"It's very tall wheat!",
							"The rains were heavy.",
							"Barely tall wheat...",
							"This grain is bent."
						}
						local message = grass[attacker.side + 1]

						if math.random(1, 15) == 1 then
							attacker:sendMinitext(message)
						end

						local skill = crafting.getSkillLevel(
							attacker,
							"farming"
						)
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

						mob:removeHealth(damage)
						attacker.damage = 0
					end
				end
			else
				attacker:sendMinitext("You cannot farm with an empty hand.")
			end
		end
	end,

	after_death = function(mob, attacker)
		local skill = crafting.getSkillLevel(attacker, "farming")
		attacker:addItem("wheat", 1)
		crafting.skillChanceIncrease(attacker, NPC("SsalNpc"), "farming")

		for z = 1, 2 do
			local rand = math.random(1, 2)
			if (rand == 1) then
				attacker:addItem("wheat", 1)
				crafting.skillChanceIncrease(attacker, NPC("SsalNpc"), "farming")
			end
		end

		local additional = math.random(1, 3)

		if additional == 1 then
			attacker:addItem("rice", 1)
		elseif additional == 2 then
			attacker:addItem("peas", 1)
		end

		attacker:sendMinitext("You have gathered some Wheat.")
	end,

	on_spawn = function(mob)
		mob.side = 0
		mob:sendSide()
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
	end
}

tall_wheat = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)

			if weapon ~= nil then
				if weapon.yname == "basic_sickle" then
					mob.attacker = attacker.ID

					if attacker:checkIfCast(flanks) then
						attacker:removeDuras(flanks)
					end
					if attacker:checkIfCast(backstabs) then
						attacker:removeDuras(backstabs)
					end

					mob.registry["attackerTime"] = os.time() + 120

					-- 2 mins

					if mob.registry["attacker"] == 0 then
						mob.registry["attacker"] = attacker.ID
					end

					-- tags the mob

					if mob.registry["attacker"] ~= 0 and mob.registry["attacker"] == attacker.ID then
						-- only allows damage if you have tagged the mob

						local grass = {
							"It's very tall wheat!",
							"The rains were heavy.",
							"Barely tall wheat...",
							"This grain is bent."
						}
						local message = grass[attacker.side + 1]

						if math.random(1, 15) == 1 then
							attacker:sendMinitext(message)
						end

						local skill = crafting.getSkillLevel(
							attacker,
							"farming"
						)
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

						mob:removeHealth(damage)
						attacker.damage = 0
					end
				end
			else
				attacker:sendMinitext("You cannot farm with an empty hand.")
			end
		end
	end,

	after_death = function(mob, attacker)
		local skill = crafting.getSkillLevel(attacker, "farming")
		attacker:addItem("wheat", 1)
		crafting.skillChanceIncrease(attacker, NPC("SsalNpc"), "farming")

		local additional = math.random(1, 6)

		if additional == 1 then
			attacker:addItem("rice", 1)
		elseif additional == 2 then
			attacker:addItem("peas", 1)
		end

		attacker:sendMinitext("You have gathered some Wheat.")
	end,

	on_spawn = function(mob)
		mob.side = 0
		mob:sendSide()
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
	end
}

damp_wheat = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)

			if weapon ~= nil then
				if weapon.yname == "basic_sickle" then
					mob.attacker = attacker.ID

					if attacker:checkIfCast(flanks) then
						attacker:removeDuras(flanks)
					end
					if attacker:checkIfCast(backstabs) then
						attacker:removeDuras(backstabs)
					end

					mob.registry["attackerTime"] = os.time() + 120

					-- 2 mins

					if mob.registry["attacker"] == 0 then
						mob.registry["attacker"] = attacker.ID
					end

					-- tags the mob

					if mob.registry["attacker"] ~= 0 and mob.registry["attacker"] == attacker.ID then
						-- only allows damage if you have tagged the mob

						local grass = {
							"It's very tall wheat!",
							"The rains were heavy.",
							"Barely tall wheat...",
							"This grain is bent."
						}
						local message = grass[attacker.side + 1]

						if math.random(1, 15) == 1 then
							attacker:sendMinitext(message)
						end

						local skill = crafting.getSkillLevel(
							attacker,
							"farming"
						)
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

						mob:removeHealth(damage)
						attacker.damage = 0
					end
				end
			else
				attacker:sendMinitext("You cannot farm with an empty hand.")
			end
		end
	end,

	after_death = function(mob, attacker)
		local skill = crafting.getSkillLevel(attacker, "farming")
		attacker:addItem("wheat", 1)
		crafting.skillChanceIncrease(attacker, NPC("SsalNpc"), "farming")

		local additional = math.random(1, 6)

		if additional == 1 then
			attacker:addItem("rice", 1)
		elseif additional == 2 then
			attacker:addItem("peas", 1)
		end

		attacker:sendMinitext("You have gathered some Wheat.")
	end,

	on_spawn = function(mob)
		mob.side = 0
		mob:sendSide()
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
	end
}

bent_grain = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)

			if weapon ~= nil then
				if weapon.yname == "basic_sickle" then
					mob.attacker = attacker.ID

					if attacker:checkIfCast(flanks) then
						attacker:removeDuras(flanks)
					end
					if attacker:checkIfCast(backstabs) then
						attacker:removeDuras(backstabs)
					end

					mob.registry["attackerTime"] = os.time() + 120

					-- 2 mins

					if mob.registry["attacker"] == 0 then
						mob.registry["attacker"] = attacker.ID
					end

					-- tags the mob

					if mob.registry["attacker"] ~= 0 and mob.registry["attacker"] == attacker.ID then
						-- only allows damage if you have tagged the mob

						local grass = {
							"It's very tall wheat!",
							"The rains were heavy.",
							"Barely tall wheat...",
							"This grain is bent."
						}
						local message = grass[attacker.side + 1]

						if math.random(1, 15) == 1 then
							attacker:sendMinitext(message)
						end

						local skill = crafting.getSkillLevel(
							attacker,
							"farming"
						)
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

						mob:removeHealth(damage)
						attacker.damage = 0
					end
				end
			else
				attacker:sendMinitext("You cannot farm with an empty hand.")
			end
		end
	end,

	after_death = function(mob, attacker)
		local skill = crafting.getSkillLevel(attacker, "farming")
		attacker:addItem("rice", 1)
		crafting.skillChanceIncrease(attacker, NPC("SsalNpc"), "farming")

		for z = 1, 2 do
			local rand = math.random(1, 2)
			if (rand == 1) then
				attacker:addItem("rice", 1)
				crafting.skillChanceIncrease(attacker, NPC("SsalNpc"), "farming")
			end
		end

		local additional = math.random(1, 3)

		if additional == 1 then
			attacker:addItem("wheat", 1)
		elseif additional == 2 then
			attacker:addItem("peas", 1)
		end

		attacker:sendMinitext("You have gathered some Rice.")
	end,

	on_spawn = function(mob)
		mob.side = 0
		mob:sendSide()
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
	end
}

--[[very_tall_wheat = {
    on_spawn = function(mob)
        mob.side = 0
        mob:sendSide()
    end,
    move = function(mob)
        local owner = mob:getBlock(mob.owner)
        if owner.afkTime >= 3 then mob.owner = 0 return end
        if owner.m ~= mob.m then mob.owner = 0 return end
        if not distanceSquare(owner,mob,2) then mob.owner = 0 return end
    end,
    on_attacked = function(mob, attacker)
        mob.side = 0
        if mob.owner ~= attacker.ID then very_tall_wheat.move(mob) return end

        if (attacker.blType == BL_PC) then
            local damage = math.floor(mob.maxHealth / 50)
            if attacker.side == mob.side then damage = math.floor(mob.maxHealth / 4) end
            local weapon = attacker:getEquippedItem(EQ_WEAP)

            if weapon.yname ~= "basic_sickle" then
                return
            end

            mob.attacker = attacker.ID
            mob:sendHealth(damage, attacker.critChance)
            attacker.damage = 0
        end
    end,
    after_death = function(mob, attacker)
        local farmitems = {"wheat","wheat","wheat","rice","peas"}
        local rItem = farmitems[math.random(1,#farmitems)]
        local amount = {1,2,1,1,2,1,3,1,1,2,1,2}
        local chance = 18 - crafting.getSkillValue(attacker,"farming")
        if attacker.side == mob.side then chance = chance - 4 end
        if math.random(1,chance) == 1 then
            attacker:addItem(rItem,amount[math.random(1,#amount)])
            attacker:sendMinitext("You manage to gather some "..rItem..".")
        end
    end
}

damp_wheat = {
    on_spawn = function(mob)
        mob.side = 0
        mob:sendSide()
    end,
    move = function(mob)
        local owner = mob:getBlock(mob.owner)
        if owner.afkTime >= 3 then mob.owner = 0 return end
        if owner.m ~= mob.m then mob.owner = 0 return end
        if not distanceSquare(owner,mob,2) then mob.owner = 0 return end
    end,
    on_attacked = function(mob, attacker)
        mob.side = 1
        if mob.owner ~= attacker.ID then damp_wheat.move(mob) return end

        if (attacker.blType == BL_PC) then
            local damage = math.floor(mob.maxHealth / 50)
            if attacker.side == mob.side then damage = math.floor(mob.maxHealth / 4) end
            local weapon = attacker:getEquippedItem(EQ_WEAP)

            if weapon.yname ~= "basic_sickle" then
                return
            end

            mob.attacker = attacker.ID
            mob:sendHealth(damage, attacker.critChance)
            attacker.damage = 0
        end
    end,
    after_death = function(mob, attacker)
        local farmitems = {"wheat","wheat","wheat","rice","peas"}
        local rItem = farmitems[math.random(1,#farmitems)]
        local amount = {1,2,1,1,2,1,3,1,1,2,1,2}
        local chance = 18 - crafting.getSkillValue(attacker,"farming")
        if attacker.side == mob.side then chance = chance - 4 end
        if math.random(1,chance) == 1 then
            attacker:addItem(rItem,amount[math.random(1,#amount)])
            attacker:sendMinitext("You manage to gather some "..rItem..".")
        end
    end
}

tall_wheat = {
    on_spawn = function(mob)
        mob.side = 0
        mob:sendSide()
    end,
    move = function(mob)
        local owner = mob:getBlock(mob.owner)
        if owner.afkTime >= 3 then mob.owner = 0 return end
        if owner.m ~= mob.m then mob.owner = 0 return end
        if not distanceSquare(owner,mob,2) then mob.owner = 0 return end
    end,
    on_attacked = function(mob, attacker)
        mob.side = 2
        if mob.owner ~= attacker.ID then tall_wheat.move(mob) return end

        if (attacker.blType == BL_PC) then
            local damage = math.floor(mob.maxHealth / 50)
            if attacker.side == mob.side then damage = math.floor(mob.maxHealth / 4) end
            local weapon = attacker:getEquippedItem(EQ_WEAP)

            if weapon.yname ~= "basic_sickle" then
                return
            end

            mob.attacker = attacker.ID
            mob:sendHealth(damage, attacker.critChance)
            attacker.damage = 0
        end
    end,
    after_death = function(mob, attacker)
        local farmitems = {"wheat","wheat","wheat","rice","peas"}
        local rItem = farmitems[math.random(1,#farmitems)]
        local amount = {1,2,1,1,2,1,3,1,1,2,1,2}
        local chance = 18 - crafting.getSkillValue(attacker,"farming")
        if attacker.side == mob.side then chance = chance - 4 end
        if math.random(1,chance) == 1 then
            attacker:addItem(rItem,amount[math.random(1,#amount)])
            attacker:sendMinitext("You manage to gather some "..rItem..".")
        end
    end
}

bent_grain = {
    on_spawn = function(mob)
        mob.side = 0
        mob:sendSide()
    end,
    move = function(mob)
        local owner = mob:getBlock(mob.owner)
        if owner.afkTime >= 3 then mob.owner = 0 return end
        if owner.m ~= mob.m then mob.owner = 0 return end
        if not distanceSquare(owner,mob,2) then mob.owner = 0 return end
    end,
    on_attacked = function(mob, attacker)
        mob.side = 3
        if mob.owner ~= attacker.ID then bent_grain.move(mob) return end

        if (attacker.blType == BL_PC) then
            local damage = math.floor(mob.maxHealth / 50)
            if attacker.side == mob.side then damage = math.floor(mob.maxHealth / 4) end
            local weapon = attacker:getEquippedItem(EQ_WEAP)

            if weapon.yname ~= "basic_sickle" then
                return
            end

            mob.attacker = attacker.ID
            mob:sendHealth(damage, attacker.critChance)
            attacker.damage = 0
        end
    end,
    after_death = function(mob, attacker)
        local farmitems = {"rice","rice","rice","wheat","peas"}
        local rItem = farmitems[math.random(1,#farmitems)]
        local amount = {1,2,1,1,2,1,3,1,1,2,1,2}

        local chance = 18 - crafting.getSkillValue(attacker,"farming")
        if attacker.side == mob.side then chance = chance - 4 end
        if math.random(1,chance) == 1 then
            attacker:addItem(rItem,amount[math.random(1,#amount)])
            attacker:sendMinitext("You manage to gather some "..rItem..".")
        end
    end
}]]
--
