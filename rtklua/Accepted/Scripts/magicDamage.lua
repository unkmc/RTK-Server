magicDamage = function(block, target, func)
	local baseDamage = 1 + (block.will * 4) + (block.grace * 3)
	local finalDamage

	if (printf ~= 1) then
		printf = 0
	end

	if (block.blType == BL_PC) then
		local weaponDamage = math.floor(mathRandom(block.minDam / 3, block.maxDam / 3, 1000) + mathRandom(
			block.minDam / 3,
			block.maxDam / 3,
			1000
		) + mathRandom(block.minDam / 3, block.maxDam / 3, 1000))

		baseDamage = baseDamage * block.fury
		weaponDamage = weaponDamage * block.enchant
		finalDamage = (baseDamage + weaponDamage) * block.rage * block.invis
	elseif (block.blType == BL_MOB) then
		local weaponDamage = math.floor(mathRandom(block.minDam / 3, block.maxDam / 3, 1000) + mathRandom(
			block.minDam / 3,
			block.maxDam / 3,
			1000
		) + mathRandom(block.minDam / 3, block.maxDam / 3, 1000))

		finalDamage = (baseDamage + weaponDamage) * block.invis
	end

	--ADD FOR WISDOM?

	if (finalDamage < 1) then
		finalDamage = 1
	end

	if (target ~= nil and block.critChance > 0) then
		local deduction = 0

		if target:checkIfCast(hardBodies) then
			block.critChance = 0
			block.damage = 0
			return
		end

		local deduction = 0

		local armor = target.armor
		local lowarmor = 0

		if target.blType == BL_MOB then
			lowarmor = -95
		elseif target.blType == BL_PC then
			lowarmor = -80
		end

		if armor < lowarmor then
			armor = lowarmor
		end

		if armor ~= 0 then
			deduction = 1 + (armor / 100)
		end
		if armor == 0 then
			deduction = 1
		end

		local targetsAround = getTargetsAround(block, BL_MOB)

		block.target = target.ID

		if (block.blType == BL_MOB) then
			targetsAround = getTargetsAround(block, BL_PC)
		end

		if (target.blType == BL_MOB) then
			target:sendAction(25, 20)
		elseif (target.blType == BL_PC) then
			target:deductArmor(block.critChance)
		end

		finalDamage = math.floor(finalDamage * deduction)

		if (finalDamage < 1) then
			finalDamage = 1
		end

		if (target.target == 0) then
			target.target = block.ID
			target.state = MOB_HIT
		end

		if (block.critChance == 2) then
			finalDamage = finalDamage
		end

		finalDamage = finalDamage * target.sleep
		target.sleep = 1

		if (target.confused) then
			target.confused = false
			target.confuseTarget = 0
		end

		if (target.deduction > 0) then
			finalDamage = finalDamage * target.deduction
		end

		if (target.dmgShield > 0) then
			if (target.dmgShield > finalDamage) then
				target.dmgShield = target.dmgShield - finalDamage
				finalDamage = 0
			else
				finalDamage = finalDamage - target.dmgShield
				target.dmgShield = 0
			end
		else
			finalDamage = finalDamage - target.dmgShield
			target.dmgShield = 0
		end

		if (finalDamage < 1) then
			if (target.dmgShield > 0) then
				finalDamage = 0
			else
				finalDamage = 1
			end
		end

		if ((block.blType ~= BL_MOB or (block.owner > 0 and block.owner < 1073741823)) and target.blType == BL_MOB) then
			if (block.blType == BL_PC and #block.group > 1) then
				target:setGrpDmg(block.ID, finalDamage)
			elseif (block.blType == BL_PC) then
				target:setIndDmg(block.ID, finalDamage)
			elseif (block.blType == BL_MOB and #Player(block.owner).group > 1) then
				target:setGrpDmg(block.owner, finalDamage)
			elseif (block.blType == BL_MOB) then
				target:setIndDmg(block.owner, finalDamage)
			end
		end

		if (target.blType == BL_MOB or (block.blType == BL_MOB and (block.owner == 0 or block.owner >= 1073741823)) or (block.blType == BL_PC and block:canPK(target) == true) or (block.blType == BL_MOB and block.owner > 0 and block.owner < 1073741823 and Player(block.owner):canPK(target) == true)) then
			target.attacker = block.ID
			target:deductArmor(block.critChance)

			if (func ~= nil) then
				return func(block, target, finalDamage)
			else
				return finalDamage
			end
		end
	else
		if (func ~= nil) then
			return func(block, target, finalDamage)
		else
			return finalDamage
		end
	end
end
