mob_ai_cotw = {
	on_healed = function(mob, healer)
		mob.attacker = healer.ID
		mob:sendHealth(healer.damage, healer.critChance)
		healer.damage = 0
	end,

	on_attacked = function(mob, attacker)
		if mob.target == mob.owner then
			mob.target = attacker.ID
		end

		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		local owner = Player(mob.owner)
		if owner == nil then
			mob:vanish()
			return
		end
		if (mob.registry["spawnTime"] > 0 and os.time() > mob.registry["spawnTime"]) or owner.m ~= mob.m then
			mob:vanish()
			return
		end

		local newTarget = 0
		local highThreat = 0
		local threat_chk = {}
		local testT = 0

		local mobs = mob:getObjectsInArea(BL_MOB)

		if #mobs > 0 then
			for i = 1, #mobs do
				if mobs[i].ID ~= mob.ID then
					if (mobs[i]:checkThreat(mob.owner) > 0) then
						table.insert(threat_chk, mobs[i])
					end
				end
			end

			for i = 1, #threat_chk do
				testT = threat_chk[i]:checkThreat(mob.owner)
				if testT > highThreat then
					highThreat = testT
					newTarget = threat_chk[i].ID
				end
			end

			if highThreat == 0 or newTarget == 0 then
				local attacker = mob:getBlock(owner.attacker)
				if attacker ~= nil then
					if attacker.blType == BL_PC then
						return
					end
					target = attacker
					mob_ai_basic.move(mob, target)
					mob.state = MOB_HIT
					return
				end

				if target.blType == BL_PC then
					return
				end

				target = mob:getBlock(mob.owner)
			else
				mob.target = newTarget
				target = mob:getBlock(mob.target)
			end
		else
			target = mob:getBlock(mob.owner)
		end

		if target.blType == BL_PC then
			return
		end

		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		local owner = Player(mob.owner)
		if owner == nil then
			mob:vanish()
			return
		end
		if (mob.registry["spawnTime"] > 0 and os.time() > mob.registry["spawnTime"]) or owner.m ~= mob.m then
			mob:vanish()
			return
		end

		local newTarget = 0
		local highThreat = 0
		local threat_chk = {}
		local testT = 0

		local mobs = mob:getObjectsInArea(BL_MOB)

		if #mobs > 0 then
			for i = 1, #mobs do
				if mobs[i].ID ~= mob.ID then
					if (mobs[i]:checkThreat(mob.owner) > 0) then
						table.insert(threat_chk, mobs[i])
					end
				end
			end

			for i = 1, #threat_chk do
				testT = threat_chk[i]:checkThreat(mob.owner)
				if testT > highThreat then
					highThreat = testT
					newTarget = threat_chk[i].ID
				end
			end

			if highThreat == 0 or newTarget == 0 then
				local attacker = mob:getBlock(owner.attacker)
				if attacker ~= nil then
					if attacker.blType == BL_PC then
						return
					end
					target = attacker
					mob:attack(target.ID)
					mob_ai_basic.attack(mob, target)
					return
				end

				if target.blType == BL_PC then
					return
				end

				target = mob:getBlock(mob.owner)
				mob_ai_basic.move(mob, target)
				return
			else
				mob.target = newTarget
			end
		else
			target = mob:getBlock(mob.owner)
			mob_ai_basic.move(mob, target)
			return
		end

		if target.blType == BL_PC then
			return
		end
		target = mob:getBlock(mob.target)

		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}
