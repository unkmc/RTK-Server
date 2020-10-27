mathRandom = function(start, stop, precision)
	return math.random(start * precision, stop * precision) / precision
end

checkProtection = function(block, target, successRate)
	--1 protection = 3% deflect chance, with max of 72%

	--Player(25):talk(0,"wtf")
	local blockWill = (block.will)
	local blockLevel = block.level
	local targetWill = 1
	local targetLevel = 1
	local targetProtection = 1
	local minhit =.1
	local maxhit =.95

	if (target ~= nil) then
		targetWill = (target.will)
		targetLevel = target.level
		targetProtection = (target.protection)
	end

	if (block.blType == BL_PC or block.blType == 1) then
		--PLAYER hitchance
		local hitchance =.1 + (blockLevel / 1000) + (blockWill / 100)

		if (target ~= nil) then
			hitchance = hitchance - (targetWill / 100) + (targetProtection / 100) + (targetLevel / 1000)

			--target:talk(0,""..hitchance*10000)
		end

		if (hitchance < minhit) then
			hitchance = minhit
		elseif (hitchance > maxhit) then
			hitchance = maxhit
		end

		if (math.random(successRate) > math.random(hitchance * 10000)) then
			return true
		else
			return false
		end
	elseif (block.blType == BL_MOB) or (block.blType == 2) then
		--MOBs hitchance
		local hitchance =.1 + (blockLevel / 1000) + (blockWill / 100)

		if (target ~= nil) then
			hitchance = hitchance - (targetWill / 100) + (targetProtection / 100) + (targetLevel / 1000)
		end

		if (hitchance < minhit) then
			hitchance = minhit
		elseif (hitchance > maxhit) then
			hitchance = maxhit
		end

		if (math.random(successRate) > math.random(hitchance * 10000)) then
			return true
		else
			return false
		end
	end
end
