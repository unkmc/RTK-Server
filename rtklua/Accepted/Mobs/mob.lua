--Mob damage formulas
function Mob.addHealthExtend(mob, amount, sleep, deduction, ac, ds, print)
	local healer
	local ded = 0

	if (mob.state == 1) then
		return
	end

	if (mob.attacker >= 1073741823) then
		healer = Mob(mob.attacker)
	elseif (mob.attacker > 0) then
		healer = Player(mob.attacker)
	end

	ded = mob.armor / (mob.armor + 400 + 95 * (healer.level + healer.tier ^ 2 + healer.mark ^ 3))

	if (healer:hasDuration("blossom")) then
		amount = amount * 2
	end

	if (sleep > 0 and print == 2) then
		amount = amount * mob.sleep
	elseif (sleep == 1) then
		amount = amount * mob.sleep
		mob.sleep = 1
	elseif (sleep == 2) then
		amount = amount * mob.sleep
	end

	if (deduction == 1) then
		if (mob.deduction < 0) then
			amount = 0
		elseif (mob.deduction > 0) then
			amount = amount * mob.deduction
		end
	end

	if (ac == 1) then
		if (ded <.85) then
			amount = amount * (1 - ded)
		else
			amount = amount *.15
		end
	end

	if (ds > 0 and print == 2) then
		amount = amount - mob.dmgShield
	elseif (ds == 1) then
		if (mob.dmgShield > 0) then
			if (mob.dmgShield > amount) then
				mob.dmgShield = mob.dmgShield - amount
				amount = 0
			else
				amount = amount - mob.dmgShield
				mob.dmgShield = 0
			end
		else
			amount = amount - mob.dmgShield
			mob.dmgShield = 0
		end
	elseif (ds == 2) then
		mob.dmgShield = mob.dmgShield - amount
	end

	amount = -amount

	if (healer ~= nil) then
		healer.damage = amount
		healer.critChance = 0
	else
		mob.damage = amount
		mob.critChance = 0
	end

	if (print == 1) then
		if (mob.health - amount > mob.maxHealth) then
			mob.health = mob.maxHealth
		else
			mob.health = mob.health - amount
		end
	elseif (print == 2) then
		return amount
	else
		if (mob.aiType == 0) then
			mob_ai_basic.on_healed(mob, healer)
		elseif (mob.aiType == 1) then
			mob_ai_normal.on_healed(mob, healer)
		elseif (mob.aiType == 2) then
			mob_ai_hard.on_healed(mob, healer)
		elseif (mob.aiType == 3) then
			mob_ai_boss.on_healed(mob, healer)
		elseif (mob.aiType == 4) then
			mob:callBase("on_healed")
		elseif (mob.aiType == 5) then
			mob_ai_ghost.on_healed(mob, healer)
		elseif (mob.aiType == 200) then
			mob:callBase("on_healed")
		end
	end
end

function Mob.removeHealthExtend(mob, amount, sleep, deduction, ac, damageShield, print)
	local netAmount = mob:calculateNetDamage(amount, sleep, deduction, ac, damageShield, print, 0)
	local attacker

	if (mob.attacker >= 1073741823) then
		attacker = Mob(mob.attacker)
	elseif (mob.attacker > 0) then
		attacker = Player(mob.attacker)
	end

	if (attacker ~= nil) then
		attacker.damage = netAmount
		attacker.critChance = 0
	else
		mob.damage = netAmount
		mob.critChance = 0
	end

	if (print == 1) then
		if (mob.health - netAmount <= 0) then
			mob.health = 0
			mob.state = MOB_DEAD
		else
			mob.health = mob.health - netAmount
		end
	elseif (print == 2) then
		return netAmount
	else
		if (mob.aiType == 0) then
			mob_ai_basic.on_attacked(mob, attacker)
		elseif (mob.aiType == 1) then
			mob_ai_normal.on_attacked(mob, attacker)
		elseif (mob.aiType == 2) then
			mob_ai_hard.on_attacked(mob, attacker)
		elseif (mob.aiType == 3) then
			mob_ai_boss.on_attacked(mob, attacker)
		elseif (mob.aiType == 4) then
			mob:callBase("on_attacked")
		elseif (mob.aiType == 5) then
			mob_ai_ghost.on_attacked(mob, attacker)
		elseif (mob.aiType == 200) then
			mob:callBase("on_attacked")
		end
	end
end

function Mob.calculateNetDamage(mob, amount, sleep, deduction, ac, damageShield, print, resetChanges)
	local originalDmgShield = mob.dmgShield
	local originalSleep = mob.sleep
	
	if (sleep > 0 and print == 2) then
		amount = amount * mob.sleep
	elseif (sleep == 1) then
		amount = amount * mob.sleep
		mob.sleep = 1
	elseif (sleep == 2) then
		amount = amount * mob.sleep
	end

	if (deduction == 1) then
		if (mob.deduction < 0) then
			amount = 0
		elseif (mob.deduction > 0) then
			amount = amount * mob.deduction
		end
	end

	if (ac == 1) then
		if mob.armor ~= 0 then
			amount = amount * (1 + (mob.armor / 100))
		else
			amount = amount
		end
	end

	if (damageShield > 0 and print == 2) then
		amount = amount - mob.dmgShield
	elseif (damageShield == 1) then
		if (mob.dmgShield > 0) then
			if (mob.dmgShield > amount) then
				mob.dmgShield = mob.dmgShield - amount
				amount = 0
			else
				amount = amount - mob.dmgShield
				mob.dmgShield = 0
			end
		else
			amount = amount - mob.dmgShield
			mob.dmgShield = 0
		end
	elseif (damageShield == 2) then
		mob.dmgShield = mob.dmgShield - amount
	end

	if (resetChanges ~= 0) then
		mob.dmgShield = originalDmgShield
		mob.sleep = originalSleep
	end

	return math.ceil(amount)
end

function Mob.removeHealthWithoutDamageNumbers(mob, amount, type)
	local temp_health = 0

	temp_health = mob.health - amount

	if temp_health <= 0 then
		temp_health = 0
	end

	mob.health = temp_health

	--[[
	if (mob.attacker >= 1073741823) then
		Mob(mob.attacker).damage = amount
		Mob(mob.attacker).critChance = type
	else]]
	--
	if (mob.attacker > 0) then
		-- players
		Player(mob.attacker).damage = amount
		Player(mob.attacker).critChance = type
	else
		mob.damage = amount
		mob.critChance = type
	end

	if (mob.health <= 0) then
		mob.state = MOB_DEAD
	else
		mob:sendStatus()
	end
end

--Mob adjustments
function Mob.changeMove(mob, amount)
	if (mob.newMove + amount < 1) then
		return false
	else
		mob.newMove = mob.newMove + amount
		return true
	end
end

function Mob.changeAttack(mob, amount)
	if (mob.newAttack + amount < 1) then
		return false
	else
		mob.newAttack = mob.newAttack + amount
		return true
	end
end

function CalculateIncrease(mob, player, hit)
	local news = math.abs(mob.side - player.side)
	local total = 1.5
	if (mob.side == player.side) then
		total = 3;
	elseif (news == 2) then
		total = 1;
	end

	if (hit == 2) then
		total = total * 3
	end
	return total
end

function Mob.adjustSide(mob, player)
	local dx = mob.x - player.x
	local dy = mob.y - player.y

	if (dx == -1) then
		if (mob.side ~= 1) then
			mob.side = 1
			mob:sendSide()
		end
	elseif (dx == 1) then
		if (mob.side ~= 3) then
			mob.side = 3
			mob:sendSide()
		end
	elseif (dy == -1) then
		if (mob.side ~= 2) then
			mob.side = 2
			mob:sendSide()
		end
	elseif (dy == 1) then
		if (mob.side ~= 0) then
			mob.side = 0
			mob:sendSide()
		end
	end
end

function FindCoords(mob, player)
	if (player:getDuration("cloak") > 0) then
		mob.attacker = nil
	end
	local i
	local found = false
	local oldside = mob.side
	local canmove = false
	local checkmove = math.random(0, 2)

	if (mob:moveIntent(player.ID) == 0) then
		if (checkmove >= 1) then
			if (mob.y < player.y) then
				mob.side = 2
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.y > player.y and not canmove) then
				mob.side = 0
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.x < player.x and not canmove) then
				mob.side = 1
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.x > player.x and not canmove) then
				mob.side = 3
				mob:sendSide()
				canmove = mob:move()
			end
		else
			if (mob.x < player.x) then
				mob.side = 1
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.x > player.x and not canmove) then
				mob.side = 3
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.y < player.y and not canmove) then
				mob.side = 2
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.y > player.y and not canmove) then
				mob.side = 0
				mob:sendSide()
				canmove = mob:move()
			end
		end

		--Ok, so it's next to one of em, I THINK..let's check
		--if(dx==1 and dy==0) then return true end
		--if(dx==0 and dy==1) then return true end
	end

	if (mob:moveIntent(player.ID) == 1) then
		return true
	elseif (not canmove) then
		local tList = mob:getObjectsInArea(BL_PC)
		local new_T
		local loopControl = 0

		repeat
			new_T = math.random(#tList)
			loopControl = loopControl + 1
		until (tList[new_T].gmLevel == 0 or loopControl == 20)

		mob.target = tList[new_T].ID
		mob.side = oldside
		mob:sendSide()

		for i = 0, 10 do
			if (not found) then
				mob.side = math.random(0, 3)
				mob:sendSide()
				found = mob:move()
			end
		end
	end

	--mob.target=tList[new_T].ID
	--mob:talk(0,"New Target is " .. tList[new_T].ID)
	--[[elseif(num==0) then
		local tList=mob:getObjectsInArea(BL_PC);

		local new_T=math.random(1,#tList);
		mob.target=tList[new_T].ID
		--mob:talk(0,"New Target is " .. tList[new_T].ID)
		for i=0,10 do
			if(found~=true) then
				mob.side=math.random(0,3)
				mob:sendSide()
				if(mob.side == oldside) then
					found=mob:move()
				end
			end
		end]]
	--
	return false
end

Mob.removeDuras = function(mob, type)
	local spells = type

	for i = 1, #spells do
		if mob:hasDuration(spells[i]) then
			mob:setDuration(spells[i], 0)
		end
	end
end

function Mob.checkIfCast(mob, spells)
	local cast = false

	for i = 1, #spells do
		if mob:hasDuration(spells[i]) then
			cast = true
		end
	end

	return cast
end

function RunAway(mob, player)
	local i
	local found = false
	local oldside = mob.side
	local canmove = false
	local checkmove = math.random(0, 2)

	if (mob:moveIntent(player.ID) == 1) then
		if (mob.side <= 1) then
			mob.side = mob.side + 2
			mob:sendSide()
			canmove = mob:move()
		elseif (mob.side >= 2) then
			mob.side = mob.side - 2
			mob:sendSide()
			canmove = mob:move()
		end
	else
		if (checkmove >= 1) then
			if (mob.y < player.y) then
				mob.side = 0
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.y > player.y and not canmove) then
				mob.side = 2
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.x < player.x and not canmove) then
				mob.side = 3
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.x > player.x and not canmove) then
				mob.side = 1
				mob:sendSide()
				canmove = mob:move()
			end
		else
			if (mob.x < player.x) then
				mob.side = 3
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.x > player.x and not canmove) then
				mob.side = 1
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.y < player.y and not canmove) then
				mob.side = 0
				mob:sendSide()
				canmove = mob:move()
			end
			if (mob.y > player.y and not canmove) then
				mob.side = 2
				mob:sendSide()
				canmove = mob:move()
			end
		end
	end

	if (not canmove) then
		local tList = mob:getObjectsInArea(BL_PC)
		local new_T
		local loopControl = 0

		repeat
			new_T = math.random(#tList)
			loopControl = loopControl + 1
		until (tList[new_T].gmLevel == 0 or loopControl == 20)

		mob.target = tList[new_T].ID
		mob.side = oldside
		mob:sendSide()

		for i = 1, 10 do
			if (not found) then
				mob.side = math.random(0, 3)
				mob:sendSide()
				found = mob:move()
			end
		end

		return found
	else
		return canmove
	end
end

function FindCoordsGhost(mob, player)
	local i
	local found = false
	local oldside = mob.side
	local canmove = false
	local checkmove = math.random(0, 2)

	if (mob:moveIntent(player.ID) == 0) then
		if (checkmove >= 1) then
			if (mob.y < player.y) then
				mob.side = 2
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.y > player.y and canmove == 0) then
				mob.side = 0
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.x < player.x and canmove == 0) then
				mob.side = 1
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.x > player.x and canmove == 0) then
				mob.side = 3
				mob:sendSide()
				canmove = mob:moveGhost()
			end
		else
			if (mob.x < player.x) then
				mob.side = 1
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.x > player.x and canmove == 0) then
				mob.side = 3
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.y < player.y and canmove == 0) then
				mob.side = 2
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.y > player.y and canmove == 0) then
				mob.side = 0
				mob:sendSide()
				canmove = mob:moveGhost()
			end
		end
	end

	if (mob:moveIntent(player.ID) == 1) then
		return true
	elseif (not canmove) then
		local tList = mob:getObjectsInArea(BL_PC)
		local new_T = math.random(1, #tList)

		if (mob.owner > 1073741823) then
			mob.target = tList[new_T].ID
		end

		mob.side = oldside
		mob:sendSide()

		for i = 0, 10 do
			if (not found) then
				mob.side = math.random(0, 3)
				mob:sendSide()
				found = mob:moveGhost()
			end
		end
	end

	return false
end

function RunAwayGhost(mob, player)
	local i
	local found = false
	local oldside = mob.side
	local canmove = false
	local checkmove = math.random(0, 2)

	if (mob:moveIntent(player.ID) == 1) then
		if (mob.side <= 1) then
			mob.side = mob.side + 2
			mob:sendSide()
			mob:moveGhost()
		elseif (mob.side >= 2) then
			mob.side = mob.side - 2
			mob:sendSide()
			mob:moveGhost()
		end
	else
		if (checkmove >= 1) then
			if (mob.y < player.y) then
				mob.side = 0
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.y > player.y and canmove == 0) then
				mob.side = 2
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.x < player.x and canmove == 0) then
				mob.side = 3
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.x > player.x and canmove == 0) then
				mob.side = 1
				mob:sendSide()
				canmove = mob:moveGhost()
			end
		else
			if (mob.x < player.x) then
				mob.side = 3
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.x > player.x and canmove == 0) then
				mob.side = 1
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.y < player.y and canmove == 0) then
				mob.side = 0
				mob:sendSide()
				canmove = mob:moveGhost()
			end
			if (mob.y > player.y and canmove == 0) then
				mob.side = 2
				mob:sendSide()
				canmove = mob:moveGhost()
			end
		end
	end

	if (not canmove) then
		local tList = mob:getObjectsInArea(BL_PC)
		local new_T = math.random(1, #tList)

		mob.target = tList[new_T].ID
		mob.side = oldside
		mob:sendSide()

		for i = 0, 10 do
			if (not found) then
				mob.side = math.random(0, 3)
				mob:sendSide()
				found = mob:moveGhost()
			end
		end
	end
end

function Mob.flank(mob)
	local pcBlocks = getTargetsAround(mob, BL_PC)
	local mobBlocks = getTargetsAround(mob, BL_MOB)
	local targets = {}
	local swing = true

	if (#pcBlocks > 0) then
		for i = 1, #pcBlocks do
			if ((mob.side == 0 or mob.side == 2) and pcBlocks[i].y == mob.y) then
				table.insert(targets, pcBlocks[i])
			elseif ((mob.side == 1 or mob.side == 3) and pcBlocks[i].x == mob.x) then
				table.insert(targets, pcBlocks[i])
			end
		end
	end

	if (#mobBlocks > 0) then
		for i = 1, #mobBlocks do
			if ((mob.side == 0 or mob.side == 2) and mobBlocks[i].y == mob.y) then
				table.insert(targets, mobBlocks[i])
			elseif ((mob.side == 1 or mob.side == 3) and mobBlocks[i].x == mob.x) then
				table.insert(targets, mobBlocks[i])
			end
		end
	end

	if (#targets > 0) then
		for i = 1, #targets do
			swing = true

			if (targets[i].blType == BL_MOB and (targets[i].owner == 0 or targets[i].owner >= 1073741823)) then
				swing = false
			end

			if (swing) then
				hitCritChance(mob, targets[i])

				if (mob.critChance > 0) then
					swingDamage(mob, targets[i])
					mob.damage = mob.damage *.75

					if (targets[i].blType == BL_PC) then
						player_combat.on_attacked(targets[i], mob)
					elseif (targets[i].blType == BL_MOB) then
						if (targets[i].aiType == 0) then
							mob_ai_basic.on_attacked(targets[i], mob)
						elseif (targets[i].aiType == 1) then
							mob_ai_normal.on_attacked(targets[i], mob)
						elseif (targets[i].aiType == 2) then
							mob_ai_hard.on_attacked(targets[i], mob)
						elseif (targets[i].aiType == 3) then
							mob_ai_boss.on_attacked(targets[i], mob)
						elseif (targets[i].aiType == 4) then
							targets[i]:callBase("on_attacked")
						elseif (targets[i].aiType == 5) then
							mob_ai_ghost.on_attacked(targets[i], mob)
						elseif (targets[i].aiType == 200) then
							targets[i]:callBase("on_attacked")
						end
					end
				end
			end
		end
	end
end

function Mob.flankWithAlly(mob)
	local pcBlocks = getTargetsAround(mob, BL_PC)
	local mobBlocks = getTargetsAround(mob, BL_MOB)
	local targets = {}

	if (#pcBlocks > 0) then
		for i = 1, #pcBlocks do
			if ((mob.side == 0 or mob.side == 2) and pcBlocks[i].y == mob.y) then
				table.insert(targets, pcBlocks[i])
			elseif ((mob.side == 1 or mob.side == 3) and pcBlocks[i].x == mob.x) then
				table.insert(targets, pcBlocks[i])
			end
		end
	end

	if (#mobBlocks > 0) then
		for i = 1, #mobBlocks do
			if ((mob.side == 0 or mob.side == 2) and mobBlocks[i].y == mob.y) then
				table.insert(targets, mobBlocks[i])
			elseif ((mob.side == 1 or mob.side == 3) and mobBlocks[i].x == mob.x) then
				table.insert(targets, mobBlocks[i])
			end
		end
	end

	if (#targets > 0) then
		for i = 1, #targets do
			hitCritChance(mob, targets[i])

			if (mob.critChance > 0) then
				swingDamage(mob, targets[i])
				mob.damage = mob.damage *.75

				if (targets[i].blType == BL_PC) then
					player_combat.on_attacked(targets[i], mob)
				elseif (targets[i].blType == BL_MOB) then
					if (targets[i].aiType == 0) then
						mob_ai_basic.on_attacked(targets[i], mob)
					elseif (targets[i].aiType == 1) then
						mob_ai_normal.on_attacked(targets[i], mob)
					elseif (targets[i].aiType == 2) then
						mob_ai_hard.on_attacked(targets[i], mob)
					elseif (targets[i].aiType == 3) then
						mob_ai_boss.on_attacked(targets[i], mob)
					elseif (targets[i].aiType == 4) then
						targets[i]:callBase("on_attacked")
					elseif (targets[i].aiType == 5) then
						mob_ai_ghost.on_attacked(targets[i], mob)
					elseif (targets[i].aiType == 200) then
						targets[i]:callBase("on_attacked")
					end
				end
			end
		end
	end
end

function Mob.backstab(mob)
	local pcBlocks = getTargetsAround(mob, BL_PC)
	local mobBlocks = getTargetsAround(mob, BL_MOB)
	local targets = {}
	local swing = true

	if (#pcBlocks > 0) then
		for i = 1, #pcBlocks do
			if (mob.side == 0 and pcBlocks[i].y > mob.y) then
				table.insert(targets, pcBlocks[i])
			elseif (mob.side == 1 and pcBlocks[i].x < mob.x) then
				table.insert(targets, pcBlocks[i])
			elseif (mob.side == 2 and pcBlocks[i].y < mob.y) then
				table.insert(targets, pcBlocks[i])
			elseif (mob.side == 3 and pcBlocks[i].x > mob.x) then
				table.insert(targets, pcBlocks[i])
			end
		end
	end

	if (#mobBlocks > 0) then
		for i = 1, #mobBlocks do
			if (mob.side == 0 and mobBlocks[i].y > mob.y) then
				table.insert(targets, mobBlocks[i])
			elseif (mob.side == 1 and mobBlocks[i].x < mob.x) then
				table.insert(targets, mobBlocks[i])
			elseif (mob.side == 2 and mobBlocks[i].y < mob.y) then
				table.insert(targets, mobBlocks[i])
			elseif (mob.side == 3 and mobBlocks[i].x > mob.x) then
				table.insert(targets, mobBlocks[i])
			end
		end
	end

	if (#targets > 0) then
		for i = 1, #targets do
			swing = true

			if (targets[i].blType == BL_MOB and (targets[i].owner == 0 or targets[i].owner >= 1073741823)) then
				swing = false
			end

			if (swing) then
				hitCritChance(mob, targets[i])

				if (mob.crit > 0) then
					swingDamage(mob, targets[i])
					mob.damage = mob.damage *.5

					if (targets[i].blType == BL_PC) then
						player_combat.on_attacked(targets[i], mob)
					elseif (targets[i].blType == BL_MOB) then
						if (targets[i].aiType == 0) then
							mob_ai_basic.on_attacked(targets[i], mob)
						elseif (targets[i].aiType == 1) then
							mob_ai_normal.on_attacked(targets[i], mob)
						elseif (targets[i].aiType == 2) then
							mob_ai_hard.on_attacked(targets[i], mob)
						elseif (targets[i].aiType == 3) then
							mob_ai_boss.on_attacked(targets[i], mob)
						elseif (targets[i].aiType == 4) then
							targets[i]:callBase("on_attacked")
						elseif (targets[i].aiType == 5) then
							mob_ai_ghost.on_attacked(targets[i], mob)
						elseif (targets[i].aiType == 200) then
							targets[i]:callBase("on_attacked")
						end
					end
				end
			end
		end
	end
end

function Mob.backstabWithAlly(mob)
	local pcBlocks = getTargetsAround(mob, BL_PC)
	local mobBlocks = getTargetsAround(mob, BL_MOB)
	local targets = {}

	if (#pcBlocks > 0) then
		for i = 1, #pcBlocks do
			if (mob.side == 0 and pcBlocks[i].y > mob.y) then
				table.insert(targets, pcBlocks[i])
			elseif (mob.side == 1 and pcBlocks[i].x < mob.x) then
				table.insert(targets, pcBlocks[i])
			elseif (mob.side == 2 and pcBlocks[i].y < mob.y) then
				table.insert(targets, pcBlocks[i])
			elseif (mob.side == 3 and pcBlocks[i].x > mob.x) then
				table.insert(targets, pcBlocks[i])
			end
		end
	end

	if (#mobBlocks > 0) then
		for i = 1, #mobBlocks do
			if (mob.side == 0 and mobBlocks[i].y > mob.y) then
				table.insert(targets, mobBlocks[i])
			elseif (mob.side == 1 and mobBlocks[i].x < mob.x) then
				table.insert(targets, mobBlocks[i])
			elseif (mob.side == 2 and mobBlocks[i].y < mob.y) then
				table.insert(targets, mobBlocks[i])
			elseif (mob.side == 3 and mobBlocks[i].x > mob.x) then
				table.insert(targets, mobBlocks[i])
			end
		end
	end

	if (#targets > 0) then
		for i = 1, #targets do
			hitCritChance(mob, targets[i])

			if (mob.crit > 0) then
				swingDamage(mob, targets[i])
				mob.damage = mob.damage *.5

				if (targets[i].blType == BL_PC) then
					player_combat.on_attacked(targets[i], mob)
				elseif (targets[i].blType == BL_MOB) then
					if (targets[i].aiType == 0) then
						mob_ai_basic.on_attacked(targets[i], mob)
					elseif (targets[i].aiType == 1) then
						mob_ai_normal.on_attacked(targets[i], mob)
					elseif (targets[i].aiType == 2) then
						mob_ai_hard.on_attacked(targets[i], mob)
					elseif (targets[i].aiType == 3) then
						mob_ai_boss.on_attacked(targets[i], mob)
					elseif (targets[i].aiType == 4) then
						targets[i]:callBase("on_attacked")
					elseif (targets[i].aiType == 5) then
						mob_ai_ghost.on_attacked(targets[i], mob)
					elseif (targets[i].aiType == 200) then
						targets[i]:callBase("on_attacked")
					end
				end
			end
		end
	end
end

function Mob.checkToObject(mob, object)
	local canmove = false
	local found = false
	local checkmove = math.random(0, 2)

	if (checkmove >= 1) then
		if (mob.y < object.y) then
			mob.side = 2
			mob:sendSide()
			canmove = mob:checkMove()
		end
		if (mob.y > object.y and canmove == false) then
			mob.side = 0
			mob:sendSide()
			canmove = mob:checkMove()
		end
		if (mob.x < object.x and canmove == false) then
			mob.side = 1
			mob:sendSide()
			canmove = mob:checkMove()
		end
		if (mob.x > object.x and canmove == false) then
			mob.side = 3
			mob:sendSide()
			canmove = mob:checkMove()
		end
	else
		if (mob.x < object.x) then
			mob.side = 1
			mob:sendSide()
			canmove = mob:checkMove()
		end
		if (mob.x > object.x and canmove == false) then
			mob.side = 3
			mob:sendSide()
			canmove = mob:checkMove()
		end
		if (mob.y < object.y and canmove == false) then
			mob.side = 2
			mob:sendSide()
			canmove = mob:checkMove()
		end
		if (mob.y > object.y and canmove == false) then
			mob.side = 0
			mob:sendSide()
			canmove = mob:checkMove()
		end
	end

	if (canmove == false) then
		for i = 0, 10 do
			if (found == false) then
				mob.side = math.random(0, 3)
				mob:sendSide()
				found = mob:checkMove()
			end
		end

		return found
	else
		return canmove
	end
end

function Mob.canPK(player, target)
	return true
end
