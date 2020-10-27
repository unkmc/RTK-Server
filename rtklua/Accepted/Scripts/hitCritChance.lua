hitCritChance = function(block, target)
	local blockGrace = block.grace
	local blockLevel = block.level
	local blockHit = block.hit
	local blockMiss = block.miss
	local targetGrace = target.grace
	local targetLevel = target.level
	local targetSpeed = 1

	if target.blType == BL_PC then
		targetSpeed = (target.speed + 10) / 100
	end

	local minHit = 5
	local maxHit = 100

	local critChanceIncrease = 0

	if (math.random(10000) < blockMiss) then
		block.critChance = 0
		block.damage = 0

		return
	end

	if target:checkIfCast(hardBodies) then
		block.critChance = 0
		block.damage = 0
		block:sendAction(1, 1)
		return
	end

	if (block.blType == BL_PC) or (block.blType == 1) then
		--PLAYER hitchance
		local hitchance = (55 + ((blockGrace + blockLevel) * 0.75) + blockHit - ((targetGrace + targetLevel) * 0.5))

		hitchance = hitchance * targetSpeed

		if (hitchance < minHit) then
			hitchance = minHit
		elseif (hitchance > maxHit) then
			critChanceIncrease = (5 * ((hitchance - 95) / 193)) + 2.5
			hitchance = maxHit
		end

		--math.randomseed(math.random(os.clock()))
		local seed = math.random(100)

		if (seed < hitchance) then
			local mincrit = 1
			local maxcrit = 30

			--PLAYER critchance
			local critchance = 3

			if (critchance < mincrit) then
				critchance = mincrit
			elseif (critchance > maxcrit) then
				critchance = maxcrit
			end

			if (seed < critchance) then
				block.critChance = 2
			else
				block.critChance = 1
			end

			if (target.blType == BL_PC and not block:canPK(target)) then
				block.critChance = 0
			end
		else
			block.critChance = 0
		end
	elseif (block.blType == BL_MOB) or (block.blType == 2) then
		--MOBs hitchance
		local leveldiff = targetLevel - blockLevel
		local hitchance = 95 - ((targetGrace / 10) * 2) - leveldiff

		--block:talk(0,"old hit chance: "..hitchance)
		hitchance = hitchance * targetSpeed

		--block:talk(0,"new hit chance: "..hitchance)

		block:sendAction(1, 14)
		block:playSound(block.sound)

		if (hitchance < minHit) then
			hitchance = minHit
		elseif (hitchance > maxHit) then
			critChanceIncrease = (math.random(5)) + 2.5
			hitchance = maxHit
		end

		local seed = math.random(100)

		if (seed < hitchance) then
			--MOBs critchance
			local critchance = (block.hit / 5) + critChanceIncrease

			--local rcrit = math.random(90,100)
			--block.critMult = math.abs(block.critMult + ((math.abs(critchance) - rcrit) / rcrit))
			if (seed < critchance) then
				block.critChance = 2
				block:playSound(349)
				block:playSound(351)
			else
				block.critChance = 1
			end
		else
			block.critChance = 0
		end
	end
end
