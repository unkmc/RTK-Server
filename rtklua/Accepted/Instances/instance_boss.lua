instance_boss = {
	on_spawn = function(mob)
		mob:sendAnimation(137)
		mob:sendAnimation(294)
		mob:playSound(18)
		local statcheck = 0
		local targets = 0
		local modifiers = instance_boss.lookupModifiers(mob)
		local objCheck = getObject(targetM, targetX, targetY)
		local passCheck = getPass(targetM, targetX, targetY)
		local warpCheck = getWarp(targetM, targetX, targetY)
		local blockCheck = player:getObjectsInCell(
			targetM,
			targetX,
			targetY,
			BL_ALL
		)
		local maxX = getMapXMax(targetM)
		local maxY = getMapYMax(targetM)
		local targetM = target.m
		local targetX = 0
		local targetY = 0
		local players = 0
		local BaekduMult = 1
		local rockdamage = 0
		local rockdamagesplit = 0
		local rockdamageparty = 0
		local gustdamage = 0
		local finaldamage = 0
		local fuckthemup = 0
		local healcheck = 0
		local perhp = 0
		local healamount = 0

		for i = 1, #modifiers do
			if modifiers[i].modifier == "increased_mob_health" then
				mob.maxHealth = mob.maxHealth * (1 + (modifiers[i].value / 100))
				mob.health = mob.maxHealth
			end
			if modifiers[i].modifier == "increased_mob_damage" then
				mob.minDam = mob.minDam * (1 + (modifiers[i].value / 100))
				mob.maxDam = mob.maxDam * (1 + (modifiers[i].value / 100))
			end
			if modifiers[i].modifier == "increased_player_exp" then
				mob.experience = mob.experience * (1 + (modifiers[i].value / 100))
			end
		end
		mob:updateState()
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
		debuffMulti = math.random(1, 3)
		mob.registry["scourge"] = mob.registry["scourge"] + debuffMulti
		debuffMulti = math.random(1, 3)
		mob.registry["dispel"] = mob.registry["dispel"] + debuffMulti
		mob.registry["devattack"] = mob.registry["devattack"] + 1

		if mob.registry["scourge"] >= 35 then
			players = mob:getObjectsInArea(BL_PC)
			if #players > 0 then
				rand = math.random(1, #players)
				scourge.cast(mob, players[rand])
				players[rand]:playSound(43)
				players[rand]:sendMinitext(mob.name .. " casts Scourge on you!")
				mob.registry["scourge"] = 0
			end
		end

		if mob.registry["dispel"] >= 25 then
			mob.registry["dispel"] = 0
			players = mob:getObjectsInArea(BL_PC)
			if #players > 0 then
				players[rand]:sendAnimation(108)
				players[rand]:playSound(95)
				players[rand]:flushDuration()
				players[rand]:sendMinitext(mob.name .. " dispelled your buffs!")
			end
		end

		if mob.registry["devattack"] >= 50 then
			mob:sendAnimation(344)
			mob:playSound(509)
		end

		if mob.paralyzed == true then
			mob.paralyzed = false
			mob:sendAnimation(297)
			mob:playSound(112)
			mob:talk(1, "[Baekdu Guardian]: Fools! You cannot bind me!")
			players = mob:getObjectsInArea(BL_PC)
			if #players > 0 then
				rand = math.random(1, #players)
				mob:talk(
					1,
					"[Baekdu Guardian]: " .. players[rand].name .. " BEHOLD, MY TRUE POWER! FINAL FLASH!"
				)
				if players[rand].state == 0 then
					mob.registry["devattack"] = 0
					players[rand]:sendAnimation(436)
					players[rand]:sendAnimation(412)
					players[rand]:sendAnimation(222)
					players[rand]:sendAnimation(188)
					mob:playSound(510)
					players[rand].attacker = mob.ID
					players[rand]:removeHealthExtend(finaldamage, 1, 1, 1, 1, 0)
					players[rand]:sendMinitext(mob.name .. " casts Final Flash on you.")
				end
			end
		end

		if mob.blind == true then
			mob:flushDuration()
			mob:sendAnimation(297)
			mob:playSound(708)
			mob:talk(1, "[Baekdu Guardian]: Peek-a-boo... I see you...")
			players = mob:getObjectsInArea(BL_PC)
			if #players > 0 then
				rand = math.random(1, #players)
				mob:talk(
					1,
					"[Baekdu Guardian]: " .. players[rand].name .. " BEHOLD, MY TRUE POWER! FINAL FLASH!"
				)
				if players[rand].state == 0 then
					mob.registry["devattack"] = 0
					players[rand]:sendAnimation(436)
					players[rand]:sendAnimation(412)
					players[rand]:sendAnimation(222)
					players[rand]:sendAnimation(188)
					mob:playSound(510)
					players[rand].attacker = mob.ID
					players[rand]:removeHealthExtend(finaldamage, 1, 1, 1, 1, 0)
					players[rand]:sendMinitext(mob.name .. " casts Final Flash on you.")
				end
			end
		end

		if mob.mobID == 706 then
			-- 99
			BaekduMult = 1
			rockdamage = (10000 * BaekduMult)
			rockdamagesplit = (7500 * BaekduMult)
			rockdamageparty = (1000 * BaekduMult)
			gustdamage = (7500 * BaekduMult)
			finaldamage = (45000 * BaekduMult)
		end

		if mob.mobID == 705 then
			-- il san
			BaekduMult = 1.5
			rockdamage = (25000 * BaekduMult)
			rockdamagesplit = (20000 * BaekduMult)
			rockdamageparty = (25000 * BaekduMult)
			gustdamage = (22500 * BaekduMult)
			finaldamage = (85000 * BaekduMult)
		end

		if mob.mobID == 704 then
			-- ee san
			BaekduMult = 2
			rockdamage = (45000 * BaekduMult)
			rockdamagesplit = (40000 * BaekduMult)
			rockdamageparty = (45000 * BaekduMult)
			gustdamage = (42500 * BaekduMult)
			finaldamage = (125000 * BaekduMult)
		end

		--------------------------- ROCK SLIDE
		if math.random(1, 10) == 1 then
			if target.state == 1 then
				return
			end
			mob:sendAction(2, 20)
			mob:playSound(48)
			targets = getTargetsAround(target, BL_ALL)
			diag1targets = target:getAliveObjectsInCell(
				target.m,
				target.x + 1,
				target.y + 1,
				BL_PC
			)
			diag2targets = target:getAliveObjectsInCell(
				target.m,
				target.x - 1,
				target.y - 1,
				BL_PC
			)
			diag3targets = target:getAliveObjectsInCell(
				target.m,
				target.x + 1,
				target.y - 1,
				BL_PC
			)
			diag4targets = target:getAliveObjectsInCell(
				target.m,
				target.x - 1,
				target.y + 1,
				BL_PC
			)
			fronttarget = target:getAliveObjectsInCell(
				target.m,
				target.x + 1,
				target.y,
				BL_PC
			)

			if #fronttarget == 1 then
				if fronttarget[1].state == 0 then
					fronttarget[1]:sendAnimation(202)
					fronttarget[1]:playSound(48)
					fronttarget[1]:removeHealthExtend(
						rockdamagesplit,
						1,
						1,
						1,
						1,
						0
					)
					fronttarget[1]:sendMinitext(mob.name .. " casts Rockslide on you.")
				end
			end

			if #diag1targets == 1 then
				if diag1targets[1].state == 0 then
					diag1targets[1]:sendAnimation(202)
					diag1targets[1]:playSound(48)
					diag1targets[1]:removeHealthExtend(
						rockdamagesplit,
						1,
						1,
						1,
						1,
						0
					)
					diag1targets[1]:sendMinitext(mob.name .. " casts Rockslide on you.")
				end
			end

			if #diag2targets == 1 then
				if diag2targets[1].state == 0 then
					diag2targets[1]:sendAnimation(202)
					diag2targets[1]:playSound(48)
					diag2targets[1]:removeHealthExtend(
						rockdamagesplit,
						1,
						1,
						1,
						1,
						0
					)
					diag2targets[1]:sendMinitext(mob.name .. " casts Rockslide on you.")
				end
			end

			if #diag3targets == 1 then
				if diag3targets[1].state == 0 then
					diag3targets[1]:sendAnimation(202)
					diag3targets[1]:playSound(48)
					diag3targets[1]:removeHealthExtend(
						rockdamagesplit,
						1,
						1,
						1,
						1,
						0
					)
					diag3targets[1]:sendMinitext(mob.name .. " casts Rockslide on you.")
				end
			end

			if #diag4targets == 1 then
				if diag4targets[1].state == 0 then
					diag4targets[1]:sendAnimation(202)
					diag4targets[1]:playSound(48)
					diag4targets[1]:removeHealthExtend(
						rockdamagesplit,
						1,
						1,
						1,
						1,
						0
					)
					diag4targets[1]:sendMinitext(mob.name .. " casts Rockslide on you.")
				end
			end
			target:sendAnimation(202)
			target:playSound(48)
			target:removeHealthExtend(rockdamage, 1, 1, 1, 1, 0)
			target:sendMinitext(mob.name .. " casts Rockslide on you.")
			if #targets > 1 then
				for i = 1, #targets do
					if targets[i].blType == BL_PC then
						if targets[i].state == 0 then
							targets[i]:sendAnimation(202)
							targets[i]:playSound(48)
							targets[i].attacker = mob.ID
							targets[i]:removeHealthExtend(
								rockdamagesplit,
								1,
								1,
								1,
								1,
								0
							)
							targets[i]:sendMinitext(mob.name .. " casts Rockslide on you.")
						end
					end
				end
			end
		end

		----------------- ROCK SLIDE

		if target ~= nil then
			if math.random(1, 50) == 1 then
				mob:talk(
					1,
					"[Baekdu Guardian]: I will tear the flesh from your bones!"
				)
			end
		end

		if mob.paralyzed == true then
			mob.paralyzed = false
			mob:sendAnimation(297)
			mob:playSound(112)
			mob:talk(1, "[Baekdu Guardian]: Fools! You cannot bind me!")
			players = mob:getObjectsInArea(BL_PC)
			if #players > 0 then
				rand = math.random(1, #players)
				mob:talk(
					1,
					"[Baekdu Guardian]: " .. players[rand].name .. " BEHOLD, MY TRUE POWER! FINAL FLASH!"
				)
				if players[rand].state == 0 then
					mob.registry["devattack"] = 0
					players[rand]:sendAnimation(436)
					players[rand]:sendAnimation(412)
					players[rand]:sendAnimation(222)
					players[rand]:sendAnimation(188)
					mob:playSound(510)
					players[rand].attacker = mob.ID
					players[rand]:removeHealthExtend(finaldamage, 1, 1, 1, 1, 0)
					players[rand]:sendMinitext(mob.name .. " casts Final Flash on you.")
				end
			end
		end
	end,

	after_death = function(mob)
		mob:playSound(116)
		mob:talk(
			1,
			"[Baekdu Guardian]: This is not possible! Defeated by MORTALS?"
		)
		mob:addNPC(
			"BaekduChestNpc",
			mob.m,
			mob.x,
			mob.y,
			1,
			1,
			0,
			0,
			"Baekdu Chest"
		)
		players = mob:getObjectsInArea(BL_PC)

		for i = 1, #players do
			players[i].registry["baekdu_boss_kills"] = players[i].registry[
				"baekdu_boss_kills"
			] + 1
			players[i].quest["baekdu_boss_killed"] = 1
			players[i]:sendMinitext("You are eligible for loot!")
		end

		local index = instance_boss.getMobInstanceIndex(mob)
		if index ~= 0 then
			instances[index].kills = instances[index].kills + 1
		end
	end,

	attack = function(mob, target)
		debuffMulti = math.random(1, 3)
		mob.registry["scourge"] = mob.registry["scourge"] + debuffMulti
		debuffMulti = math.random(1, 3)
		mob.registry["dispel"] = mob.registry["dispel"] + debuffMulti
		mob.registry["devattack"] = mob.registry["devattack"] + 1
		mob_ai_basic.attack(mob, target)

		if math.random(1, 50) == 1 then
			-- rngs heal
			healamount = (mob.maxHealth / 10)
			mob:sendAnimation(334)
			mob:playSound(726)
			mob.attacker = mob.ID
			mob:addHealthExtend(healamount, 0, 0, 0, 0, 0)
		end

		if mob.registry["scourge"] >= 35 then
			players = mob:getObjectsInArea(BL_PC)
			if #players > 0 then
				rand = math.random(1, #players)
				players[rand]:playSound(43)
				scourge.cast(mob, players[rand])
				players[rand]:sendMinitext(mob.name .. " casts Scourge on you!")
				mob.registry["scourge"] = 0
			end
		end

		if mob.registry["dispel"] >= 25 then
			players = mob:getObjectsInArea(BL_PC)
			if #players > 0 then
				rand = math.random(1, #players)
				players[rand]:sendAnimation(108)
				players[rand]:playSound(95)
				players[rand]:flushDuration()
				players[rand]:sendMinitext(mob.name .. " dispelled your buffs!")
				mob.registry["dispel"] = 0
			end
		end

		if mob.registry["devattack"] >= 50 then
			if mob.registry["devattack"] == 50 then
				mob:talk(
					1,
					"[Baekdu Guardian]: Enough child's play! Time to unleash my TRUE power!"
				)
				mob:sendAnimation(344)
				mob:playSound(509)
			end
			mob:sendAnimation(344)
			mob:playSound(509)

			if mob.registry["devattack"] >= 75 then
				players = mob:getObjectsInArea(BL_PC)
				if #players > 0 then
					rand = math.random(1, #players)
					mob:talk(
						1,
						"[Baekdu Guardian]: " .. players[rand].name .. " BEHOLD, MY TRUE POWER! FINAL FLASH!"
					)
					if players[rand].state == 0 then
						mob.registry["devattack"] = 0
						players[rand]:sendAnimation(436)
						players[rand]:sendAnimation(412)
						players[rand]:sendAnimation(222)
						players[rand]:sendAnimation(188)
						mob:playSound(510)
						players[rand].attacker = mob.ID
						players[rand]:removeHealthExtend(
							finaldamage,
							1,
							1,
							1,
							1,
							0
						)
						players[rand]:sendMinitext(mob.name .. " casts Final Flash on you.")
					end
				end
			end
		end

		if mob.paralyzed == true then
			mob.paralyzed = false
			mob:sendAnimation(297)
			mob:playSound(112)
			mob:talk(1, "[Baekdu Guardian]: Fools! You cannot bind me!")
			players = mob:getObjectsInArea(BL_PC)
			if #players > 0 then
				rand = math.random(1, #players)
				mob:talk(
					1,
					"[Baekdu Guardian]: " .. players[rand].name .. " BEHOLD, MY TRUE POWER! FINAL FLASH!"
				)
				if players[rand].state == 0 then
					mob.registry["devattack"] = 0
					players[rand]:sendAnimation(436)
					players[rand]:sendAnimation(412)
					players[rand]:sendAnimation(222)
					players[rand]:sendAnimation(188)
					mob:playSound(510)
					players[rand].attacker = mob.ID
					players[rand]:removeHealthExtend(finaldamage, 1, 1, 1, 1, 0)
					players[rand]:sendMinitext(mob.name .. " casts Final Flash on you.")
				end
			end
		end

		if mob.blind == true then
			mob:flushDuration()
			mob:sendAnimation(297)
			mob:playSound(708)
			mob:talk(1, "[Baekdu Guardian]: Peek-a-boo... I see you...")
			players = mob:getObjectsInArea(BL_PC)
			if #players > 0 then
				rand = math.random(1, #players)
				mob:talk(
					1,
					"[Baekdu Guardian]: " .. players[rand].name .. " BEHOLD, MY TRUE POWER! FINAL FLASH!"
				)
				if players[rand].state == 0 then
					mob.registry["devattack"] = 0
					players[rand]:sendAnimation(436)
					players[rand]:sendAnimation(412)
					players[rand]:sendAnimation(222)
					players[rand]:sendAnimation(188)
					mob:playSound(510)
					players[rand].attacker = mob.ID
					players[rand]:removeHealthExtend(finaldamage, 1, 1, 1, 1, 0)
					players[rand]:sendMinitext(mob.name .. " casts Final Flash on you.")
				end
			end
		end

		--------------------------- KNOCKBACK

		if math.random(1, 5) == 1 then
			if target.state == 0 then
				target = getTargetFacing(mob, BL_PC)
			end
			if target.state == 1 then
				return
			end
			if target ~= nil then
				target:sendAnimation(255, 25)
				mob:sendAction(2, 20)
				mob:playSound(75)
				targetM = target.m
				targetX = 0
				targetY = 0
				randknock = math.random(2, 4)

				if mob.side == 0 then
					targetX = target.x
					targetY = target.y - randknock
				elseif mob.side == 1 then
					targetX = target.x + randknock
					targetY = target.y
				elseif mob.side == 2 then
					targetX = target.x
					targetY = target.y + randknock
				elseif mob.side == 3 then
					targetX = target.x - randknock
					targetY = target.y
				end

				objCheck = getObject(targetM, targetX, targetY)
				passCheck = getPass(targetM, targetX, targetY)
				warpCheck = getWarp(targetM, targetX, targetY)

				mobblockCheck = mob:getObjectsInCell(
					targetM,
					targetX,
					targetY,
					BL_MOB
				)
				pcblockCheck = mob:getObjectsInCell(
					targetM,
					targetX,
					targetY,
					BL_PC
				)

				maxX = getMapXMax(targetM)
				maxY = getMapYMax(targetM)

				if passCheck == 0 and not warpCheck and #mobblockCheck == 0 and #pcblockCheck == 0 and targetX >= 0 and targetX < maxX and targetY >= 0 and targetY < maxY then
					target:warp(targetM, targetX, targetY)
					target:warp(targetM, targetX, targetY)
					target:sendAnimation(255, 25)
					target:sendMinitext(mob.name .. " sent you flying!")
					target:removeHealthExtend(gustdamage, 1, 1, 1, 1, 0)
					if math.random(1, 50) == 1 then
						mob:talk(1, "[Baekdu Guardian]: Haha, pitiful fool!")
					end
					target:sendMinitext(mob.name .. " charges you with intent to kill!")
					return
				else
					if mob.side == 0 then
						targetY = targetY - randknock
					elseif mob.side == 1 then
						targetX = targetX + randknock
					elseif mob.side == 2 then
						targetY = targetY + randknock
					elseif mob.side == 3 then
						targetX = targetX - randknock
					end

					passCheck = getPass(targetM, targetX, targetY)
					warpCheck = getWarp(targetM, targetX, targetY)
					mobblockCheck = mob:getObjectsInCell(
						targetM,
						targetX,
						targetY,
						BL_MOB
					)
					pcblockCheck = mob:getObjectsInCell(
						targetM,
						targetX,
						targetY,
						BL_PC
					)

					if passCheck == 0 and not warpCheck and #mobblockCheck == 0 and #pcblockCheck == 0 and targetX >= 0 and targetX < maxX and targetY >= 0 and targetY < maxY then
						target:warp(targetM, targetX, targetY)
						target:sendAnimation(255, 25)
						target:sendMinitext(mob.name .. " sent you flying!")
						target:removeHealthExtend(gustdamage, 1, 1, 1, 1, 0)
						if math.random(1, 50) == 1 then
							mob:talk(
								1,
								"[Baekdu Guardian]: Haha, pitiful fool!"
							)
						end
						target:sendMinitext(mob.name .. " charges you with intent to kill!")
						return
					end
				end
			end
		end

		-- end math.random
		-------------- end KNOCKBACK

		--------------------------- ROCK SLIDE
		if math.random(1, 7) == 1 then
			players = mob:getObjectsInArea(BL_PC)
			if #players > 0 then
				for i = 1, #players do
					if players[i].state == 0 then
						players[i]:sendAnimation(202)
						players[i]:playSound(48)
						players[i]:removeHealthExtend(
							rockdamageparty,
							1,
							1,
							1,
							1,
							0
						)
						players[i]:sendMinitext(mob.name .. " casts Rockslide on you.")
					end
				end
			end
		end

		if math.random(1, 5) == 1 then
			mob:sendAction(2, 20)
			mob:playSound(48)
			targets = getTargetsAround(target, BL_ALL)
			diag1targets = target:getAliveObjectsInCell(
				target.m,
				target.x + 1,
				target.y + 1,
				BL_PC
			)
			diag2targets = target:getAliveObjectsInCell(
				target.m,
				target.x - 1,
				target.y - 1,
				BL_PC
			)
			diag3targets = target:getAliveObjectsInCell(
				target.m,
				target.x + 1,
				target.y - 1,
				BL_PC
			)
			diag4targets = target:getAliveObjectsInCell(
				target.m,
				target.x - 1,
				target.y + 1,
				BL_PC
			)
			fronttarget = target:getAliveObjectsInCell(
				target.m,
				target.x + 1,
				target.y,
				BL_PC
			)

			if #fronttarget == 1 then
				if fronttargets[1].state == 0 then
					fronttarget[1]:sendAnimation(202)
					fronttarget[1]:playSound(48)
					fronttarget[1]:removeHealthExtend(
						rockdamagesplit,
						1,
						1,
						1,
						1,
						0
					)
					fronttarget[1]:sendMinitext(mob.name .. " casts Rockslide on you.")
				end
			end

			if #diag1targets == 1 then
				if diag1targets[1].state == 0 then
					diag1targets[1]:sendAnimation(202)
					diag1targets[1]:playSound(48)
					diag1targets[1]:removeHealthExtend(
						rockdamagesplit,
						1,
						1,
						1,
						1,
						0
					)
					diag1targets[1]:sendMinitext(mob.name .. " casts Rockslide on you.")
				end
			end

			if #diag2targets == 1 then
				if diag2targets[1].state == 0 then
					diag2targets[1]:sendAnimation(202)
					diag2targets[1]:playSound(48)
					diag2targets[1]:removeHealthExtend(
						rockdamagesplit,
						1,
						1,
						1,
						1,
						0
					)
					diag2targets[1]:sendMinitext(mob.name .. " casts Rockslide on you.")
				end
			end

			if #diag3targets == 1 then
				if diag3targets[1].state == 0 then
					diag3targets[1]:sendAnimation(202)
					diag3targets[1]:playSound(48)
					diag3targets[1]:removeHealthExtend(
						rockdamagesplit,
						1,
						1,
						1,
						1,
						0
					)
					diag3targets[1]:sendMinitext(mob.name .. " casts Rockslide on you.")
				end
			end

			if #diag4targets == 1 then
				if diag4targets[1].state == 0 then
					diag4targets[1]:sendAnimation(202)
					diag4targets[1]:playSound(48)
					diag4targets[1]:removeHealthExtend(
						rockdamagesplit,
						1,
						1,
						1,
						1,
						0
					)
					diag4targets[1]:sendMinitext(mob.name .. " casts Rockslide on you.")
				end
			end
			target:sendAnimation(202)
			target:playSound(48)
			target:removeHealthExtend(rockdamage, 1, 1, 1, 1, 0)
			target:sendMinitext(mob.name .. " casts Rockslide on you.")
			if #targets > 1 then
				for i = 1, #targets do
					if targets[i].blType == BL_PC then
						if targets[i].state == 0 then
							targets[i]:sendAnimation(202)
							targets[i]:playSound(48)
							targets[i].attacker = mob.ID
							targets[i]:removeHealthExtend(
								rockdamagesplit,
								1,
								1,
								1,
								1,
								0
							)
							targets[i]:sendMinitext(mob.name .. " casts Rockslide on you.")
						end
					end
				end
			end
		end

		----------------- ROCK SLIDE
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)

		if math.random(1, 500) == 1 then
			mob:talk(
				1,
				"[Mount Baekdu]: You? Attacking me? I'll show you the way!"
			)
		end

		if mob.paralyzed == true then
			mob.paralyzed = false
			mob:sendAnimation(297)
			mob:playSound(112)
			mob:talk(1, "[Baekdu Guardian]: Fools! You cannot bind me!")
			players = mob:getObjectsInArea(BL_PC)
			if #players > 0 then
				rand = math.random(1, #players)
				mob:talk(
					1,
					"[Baekdu Guardian]: " .. players[rand].name .. " BEHOLD, MY TRUE POWER! FINAL FLASH!"
				)
				if players[rand].state == 0 then
					mob.registry["devattack"] = 0
					players[rand]:sendAnimation(436)
					players[rand]:sendAnimation(412)
					players[rand]:sendAnimation(222)
					players[rand]:sendAnimation(188)
					mob:playSound(510)
					players[rand].attacker = mob.ID
					players[rand]:removeHealthExtend(finaldamage, 1, 1, 1, 1, 0)
					players[rand]:sendMinitext(mob.name .. " casts Final Flash on you.")
				end
			end
		end
	end,

	lookupModifiers = function(mob)
		for i = 1, #instances do
			for k = 1, #instances[i].maps do
				if mob.m == instances[i].maps[k] then
					return instances[i].modifiers
				end
			end
		end
	end,

	getMobInstanceIndex = function(mob)
		for i = 1, #instances do
			for k = 1, #instances[i].maps do
				if mob.m == instances[i].maps[k] then
					return i
				end
			end
		end
		return 0
	end,
}
