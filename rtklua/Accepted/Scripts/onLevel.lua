onLevel = function(player)
	local primary = 0
	local secondary = 0
	local tertiary = 0

	if player.baseClass ~= 0 then
		if ((player.level + 1) % 3 == 0 and (player.level + 1) % 2 == 0) then
			secondary = 1
			tertiary = 1
		elseif ((player.level + 1) % 2 == 0) then
			secondary = 1
			tertiary = 0
		elseif ((player.level + 1) % 3 == 0) then
			secondary = 0
			tertiary = 1
		end
	end

	if player.baseClass == 0 then
		-- peasants
		if ((player.level + 1) % 2 == 0) then
			primary = 1
			secondary = 0
			tertiary = 0
		elseif ((player.level + 1) % 3 == 0) then
			primary = 0
			secondary = 1
			tertiary = 1
		elseif ((player.level + 1) % 5 == 0) then
			primary = 0
			secondary = 1
			tertiary = 1
		end
	end

	if (player.level >= 99) then
		return
	end

	if (player.class == 0 and player.level >= 5) then
		player:sendMinitext("You cannot increase your level without choosing a path first.")
		return
	end

	if (player.baseClass == 1) then
		player.baseMight = player.baseMight + 1
		player.baseGrace = player.baseGrace + secondary
		player.baseWill = player.baseWill + tertiary
		player.baseHealth = player.baseHealth + math.random(72, 81)
		player.baseMagic = player.baseMagic + math.random(8, 9)
	elseif (player.baseClass == 2) then
		player.baseMight = player.baseMight + secondary
		player.baseGrace = player.baseGrace + 1
		player.baseWill = player.baseWill + tertiary
		player.baseHealth = player.baseHealth + math.random(56, 63)
		player.baseMagic = player.baseMagic + math.random(24, 27)
	elseif (player.baseClass == 3) then
		player.baseMight = player.baseMight + tertiary
		player.baseGrace = player.baseGrace + secondary
		player.baseWill = player.baseWill + 1
		player.baseHealth = player.baseHealth + math.random(40, 45)
		player.baseMagic = player.baseMagic + math.random(40, 45)
	elseif (player.baseClass == 4) then
		player.baseMight = player.baseMight + tertiary
		player.baseGrace = player.baseGrace + tertiary
		player.baseWill = player.baseWill + 1
		player.baseHealth = player.baseHealth + math.random(48, 54)
		player.baseMagic = player.baseMagic + math.random(32, 36)
	elseif (player.baseClass == 0) then
		player.baseMight = player.baseMight + primary
		player.baseGrace = player.baseGrace + secondary
		player.baseWill = player.baseWill + tertiary
		player.baseHealth = player.baseHealth + math.random(45, 55)
		player.baseMagic = player.baseMagic + math.random(32, 36)
	end

	player.level = player.level + 1
	player.baseArmor = player.baseArmor - 1

	if player.level >= 99 then
		player.baseArmor = 1
	end

	player:calcStat()
	player.health = player.maxHealth
	player.magic = player.maxMagic
	player:playSound(123)
	player:sendStatus()
	player:sendAnimation(2, 0)
	player:sendMinitext("You have gained new insight.")
	characterLog.levelUpWrite(player, player.level)
end
