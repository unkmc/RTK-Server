local _classFactors = {0, 9, 7.5, 0, 0}

local _getMobSwingDamage = function(mob)
	local randomDamage1 = mathRandom(mob.minDam / 3, mob.maxDam / 3, 1000)
	local randomDamage2 = mathRandom(mob.minDam / 3, mob.maxDam / 3, 1000)
	local randomDamage3 = mathRandom(mob.minDam / 3, mob.maxDam / 3, 1000)
	local swingDamage = 1 + math.floor(randomDamage1 + randomDamage2 + randomDamage3)

	return swingDamage
end

local _getPlayerSwingDamage = function(player, target)
	local s = math.random(player.minSDam, player.maxSDam)

	-- Use L (large) damage if target is a boss mob
	if (target.blType == BL_MOB and
		target.IsBoss == 1 and
		player.minLDam > 0 and
		player.maxLDam > 0) then
			s = math.random(player.minLDam, player.maxLDam)
	end

	local enchant = math.max(player.enchant, 1)
	local damage = math.max(player.dam, 1)
	local might = math.max(player.might, 1)
	local class = _classFactors[player.baseClass + 1]
	local rage = math.max(player.rage, 1)
	local invisible = 1
	local critical = 1

	if (player.state == 2) then
		invisible = 9
	end

	if (player.critChance == 2) then
		critical = 3
	end

	local swingDamage = (s / 2 * enchant + damage * 2.5 + might / 8 + class) * rage * invisible * critical
	return swingDamage
end

--printf:
--0: regular, used for all swings, includes side mult
--1: returns regular damage, used for spells and abilities where facing matters
--2: returns damage without side mult, used for spells and abilities where facing shouldn't matter
swingDamage = function(block, target, printf)
	if (printf == nil) then
		printf = 0
	end

	local finalDamage = 0

	if (block.blType == BL_MOB) then
		finalDamage = _getMobSwingDamage(block)
	else
		if (target == nil) then
			return
		end

		finalDamage = _getPlayerSwingDamage(block, target)
	end

	finalDamage = math.max(finalDamage, 1)

	if (target == nil) then
		if (printf == 1) then
			return finalDamage
		else
			return
		end
	end

	local minimumArmor = -80

	if (target.blType == BL_MOB) then
		minimumArmor = -95
	end

	block.target = target.ID

	if (target.blType == BL_MOB) then
		target:sendAction(25, 20)
	end

	if (target.target == 0 and target.blType == BL_MOB) then
		target.target = block.ID
		target.state = MOB_HIT
	end

	if (printf ~= 2) then
		finalDamage = finalDamage * target.sleep
		target.sleep = 1
	end

	if (target.confused) then
		target.confused = false
		target.confuseTarget = 0
	end

	if (target.deduction > 0) then
		finalDamage = finalDamage * target.deduction
	end

	local armor = math.max(target.armor, minimumArmor)
	local deduction = 1 + armor / 100

	finalDamage = math.floor(finalDamage * deduction)

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

	if (target:hasDuration("sleep_trap")) then
		finalDamage = math.ceil(finalDamage * 1.3)
	end

	if (block.side == target.side) then
		if (block.side == 0) then
			if (block.y > target.y) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 1) then
			if (block.x < target.x) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 2) then
			if (block.y < target.y) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 3) then
			if (block.x > target.x) then
				finalDamage = finalDamage * 2
			end
		end
	end

	if (block.backstab == true) then
		if (block.side == 0 and target.side == 2) then
			if (block.y < target.y) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 1 and target.side == 3) then
			if (block.x > target.x) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 2 and target.side == 0) then
			if (block.y > target.y) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 3 and target.side == 1) then
			if (block.x < target.x) then
				finalDamage = finalDamage * 2
			end
		end
	end

	if (block.flank == true) then
		if (block.side == 0 and target.side == 1) then
			if (block.x < target.x) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 0 and target.side == 3) then
			if (block.x > target.x) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 1 and target.side == 0) then
			if (block.y > target.y) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 1 and target.side == 2) then
			if (block.y < target.y) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 2 and target.side == 1) then
			if (block.x < target.x) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 2 and target.side == 3) then
			if (block.x > target.x) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 3 and target.side == 0) then
			if (block.y > target.y) then
				finalDamage = finalDamage * 2
			end
		end
		if (block.side == 3 and target.side == 2) then
			if (block.y < target.y) then
				finalDamage = finalDamage * 2
			end
		end
	end

	if (finalDamage > 0) then
		block:removeDuras(invis)
	end

	if (printf > 0) then
		return finalDamage
	end

	block:playSound(349)

	if (block.blType == BL_PC) then
		local rage = math.max(block.rage, 1)
		block:deductWeapon(rage)
	end

	if (block:hasDuration("protectors_bulwark")) then
		finalDamage = finalDamage * 0.75
		local reduced = finalDamage * 0.25
		protectors_bulwark_heal.cast(block, math.ceil(reduced * 0.5))
	end

	if (target.blType == BL_MOB or
		(block.blType == BL_MOB and (block.owner == 0 or block.owner >= 1073741823)) or
		(block.blType == BL_PC and block:canPK(target)) or
		(block.blType == BL_MOB and block.owner > 0 and block.owner < 1073741823 and Player(block.owner):canPK(target))) then
			target.attacker = block.ID
			block.damage = finalDamage

			if (target.blType == BL_PC and (block.blType == BL_MOB or (block.blType == BL_PC and block:canPK(target)))) then
				target:deductArmor(block.critChance)
			end
	end
end
