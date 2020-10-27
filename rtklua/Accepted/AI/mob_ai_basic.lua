mob_ai_basic = {
	on_healed = function(mob, healer)
		mob.attacker = healer.ID
		mob:sendHealth(healer.damage, healer.critChance)
		healer.damage = 0
	end,

	on_attacked = function(mob, attacker)
		mob.attacker = attacker.ID
		mob:sendHealth(attacker.damage, attacker.critChance)
		attacker.damage = 0
	end,

	move = function(mob, target)
		if (mob.paralyzed or mob.sleep ~= 1) then
			return
		end

		local found
		local moved = true
		local oldside = mob.side
		local checkmove = math.random(0, 10)

		if (mob.target ~= 0) then
			mob.returning = false
		elseif (mob.retDist <= distanceXY(mob, mob.startX, mob.startY) and mob.retDist > 1 and mob.returning == false) then
			mob.newMove = 250
			mob.deduction = mob.deduction - 1
			mob.returning = true
		elseif (mob.returning == true and mob.retDist > distanceXY(mob, mob.startX, mob.startY) and mob.retDist > 1) then
			mob.newMove = mob.baseMove
			mob.deduction = mob.deduction + 1
			mob.returning = false
		end

		if (mob.returning == true) then
			found = toStart(mob, mob.startX, mob.startY)
		else
			if (mob.owner == 0 or mob.owner > 1073741823) then
				threat.calcHighestThreat(mob)
				local block = mob:getBlock(mob.target)
				if (block ~= nil) then
					target = block
				end
			end

			if (mob.state ~= MOB_HIT and target == nil and mob.owner == 0) then
				if (checkmove >= 4) then
					mob.side = math.random(0, 3)
					mob:sendSide()
					if (mob.side == oldside and not mob.snare and not mob.blind) then
						moved = mob:move()
					end
				elseif (not mob.snare and not mob.blind) then
					moved = mob:move()
				end
			else
				local owner = mob:getBlock(mob.owner)

				if (target == nil and owner ~= nil) then
					target = mob:getBlock(owner.target)
					mob.target = owner.target
				end

				if (target ~= nil) then
					if mob.behavior == 0 then
						-- passive
						if target.m ~= mob.m then
							mob.target = 0
							mob.attacker = 0
							target:setThreat(mob.ID, 0)
							mob.state = MOB_ALIVE
						end
					end

					if mob:checkIfCast(amnesias) then
						if mob.amnesia == target.ID then
							if (checkmove >= 4) then
								mob.side = math.random(0, 3)
								mob:sendSide()

								if (mob.side == oldside and not mob.snare and not mob.blind) then
									moved = mob:move()
								end
							elseif (not mob.snare and not mob.blind) then
								moved = mob:move()
							end
							return
						end
					end

					if mob:checkIfCast(endears) then
						if target.ID == owner.ID then
							mob.target = 0
							mob.attacker = 0
							owner:setThreat(mob.ID, 0)
							mob.state = MOB_ALIVE
						end
					end

					if (not mob.snare and not mob.blind) then
						moved = FindCoords(mob, target)
					end

					if (mob.blind) then
						if distanceSquare(mob, target, 0) then
							moved = FindCoords(mob, target)
						else
							return
						end
					end

					if ((moved or mob:moveIntent(target.ID) == 1) and mob.target ~= mob.owner) then
						mob.state = MOB_HIT
					end
				end
			end
		end

		if (found == true) then
			mob.newMove = 0
			mob.deduction = mob.deduction + 1
			mob.returning = false
		end

		--broadcast(4,"Move: "..(os.time()*1000+timeMS())-start)
	end,

	attack = function(mob, target)
		if (mob.paralyzed or mob.sleep ~= 1) then
			return
		end

		local moved

		if (mob.target == 0) then
			mob.state = MOB_ALIVE
			mob_ai_basic.move(mob)
			return
		end

		if (target) then
			if mob.behavior == 0 then
				-- passive
				if target.m ~= mob.m then
					mob.target = 0
					mob.attacker = 0
					target:setThreat(mob.ID, 0)
					mob.state = MOB_ALIVE
				end
			end

			if mob:checkIfCast(endears) then
				local owner = mob:getBlock(mob.owner)
				if owner ~= nil then
					if target.ID == owner.ID then
						owner:setThreat(mob.ID, 0)
						return
					end
				end
			end

			threat.calcHighestThreat(mob)
			local block = mob:getBlock(mob.target)
			if (block ~= nil) then
				target = block
			end

			if (not mob.snare and not mob.blind) then
				moved = FindCoords(mob, target)
			end
			if (mob.blind) then
				if distanceSquare(mob, target, 0) then
					moved = FindCoords(mob, target)
				else
					return
				end
			end

			if (moved and mob.target ~= mob.owner) then
				--We are right next to them, so attack!

				mob:attack(target.ID)
			else
				mob.state = MOB_ALIVE
			end
		else
			mob.state = MOB_ALIVE
		end
	end,

	after_death = function(mob)
		mob.sleep = 1
		mob.paralyzed = false
		mob.state = 1
	end
}
