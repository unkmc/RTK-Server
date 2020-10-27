local _damageRates = {
	["novice"] = 70,
	["apprentice"] = 80,
	["accomplished"] = 90,
	["adept"] = 100,
	["talented"] = 125,
	["skilled"] = 150,
	["expert"] = 175,
	["master"] = 200,
	["grandmaster"] = 225,
	["champion"] = 230,
	["legendary"] = 235,
}

ginko_tree = {
	on_attacked = function(mob, attacker)
		if (attacker.blType == BL_PC) then
			local weapon = attacker:getEquippedItem(EQ_WEAP)

			if weapon ~= nil then
				if weapon.yname == "axe" or weapon.yname == "hunangs_axe" then
					if attacker:hasItem("ginko_wood", Item("ginko_wood").maxAmount) == true then
						attacker:sendMinitext("(Ginko wood) You can't have more than (" .. Item("ginko_wood").maxAmount .. ").")
						return
					end
					if not attacker:hasSpace("ginko_wood", 1) then
						attacker:sendMinitext("Your bags are full.")
						return
					end

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

						local skill = crafting.getSkillLevel(attacker, "woodcutting")
						local damage = 65
						local breakChance = 300

						if weapon.yname == "hunangs_axe" then
							breakChance = breakChance * 2
						end

						if (skill ~= nil) then
							damage = _damageRates[skill]
							breakChance = breakChance + damage
						end

						if math.random(1, 33) == 1 then
							damage = damage * 5
							attacker:sendMinitext("You wind up and give the tree a big whack!  *CRACK*")
						end

						if math.random(1, breakChance) == 2 then
							attacker:sendMinitext("Your " .. weapon.name .. " has broke!")
							attacker:stripEquip(EQ_WEAP, 1)
						end

						mob:removeHealth(damage)
						attacker.damage = 0
					end
				end
			else
				attacker:sendMinitext("You cannot chop with an empty hand.")
			end
		end
	end,
	after_death = function(mob, attacker)
		attacker:addItem("ginko_wood", 1)
		crafting.skillChanceIncrease(attacker, NPC("Splinter"), "woodcutting")

		for z = 1, 5 do
			local rand = math.random(1, 2)
			if (rand == 1) then
				attacker:addItem("ginko_wood", 1)
				crafting.skillChanceIncrease(
					attacker,
					NPC("Splinter"),
					"woodcutting"
				)
			end
		end

		if math.random(1, 250) == 1 then
			-- 1/250 chance to get silver tree branch
			attacker:addItem("silver_tree_branch", 1)
		end

		attacker:sendMinitext("You have gathered some Ginko wood.")
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
