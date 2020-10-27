blade_crawl = {
	cast = function(player)
		local healthCost, magicCost, minAmount = player.health *.5, player.magic *.5, 5000

		if not player:canCast(1, 1, 0) then
			return
		else
			if player.health < minAmount then
				notEnoughHP(player)
				return
			else
				if player.magic < minAmount then
					notEnoughMP(player)
					return
				else
					if player:hasDuration("blade_crawl") then
						anim(player)
						return
					else
						player.health = player.health - healthCost
						player.magic = player.magic - magicCost
						player:sendStatus()
						player:sendAction(1, 20)
						player:playSound(84)
						player:playSound(88)
						player:playSound(508)
						player:sendAnimationXY(304, player.x, player.y)
						player:addNPC(
							"blade_crawl",
							player.m,
							player.x,
							player.y,
							2,
							90,
							2000,
							player.ID
						)
						side = player:getObjectsInCell(
							player.m,
							player.x,
							player.y,
							BL_NPC
						)
						if #side > 0 then
							for i = 1, #side do
								if side[i].yname == "blade_crawl" then
									side[i].side = player.side
									side[i].registry["step"] = 1
									break
								end
							end
						end
					end
				end
			end
		end
	end,

	while_cast = function(player)
		player:sendAnimation(364)
		player.paralyzed = true
	end,

	action = function(block, owner)
		local damage = owner.health *.5 + owner.magic *.5
		local m, x, y, side = block.m, block.x, block.y, block.side
		local step = block.registry["step"]
		local threat

		if step == 0 then
			block.registry["step"] = 1
		else
			if step < 7 then
				block.registry["step"] = step + 1
			else
				endAction(block)
			end
		end
		pc, mob = getTargetFacing(block, BL_PC, 0, step), getTargetFacing(
			block,
			BL_MOB,
			0,
			step
		)
		if pc ~= nil then
			if owner:canPK(pc) and pc.ID ~= 1 then
				pc.attacker = owner.ID
				pc:removeHealthExtend(damage, 1, 1, 1, 1, 0)
				pc:sendAnimation(307)
				pc:playSound(354)
				pc:sendMinitext(owner.name .. " attack you with Blade Crawl!")
			end
		end
		if mob ~= nil then
			mob.attacker = owner.ID
			threat = mob:removeHealthExtend(damage, 1, 1, 1, 1, 2)
			owner:addThreat(mob.ID, threat)
			mob:removeHealthExtend(damage, 1, 1, 1, 1, 0)
			mob:playSound(354)
			mob:sendAnimation(307)
		end
		if side == 0 then
			y = y - step
		end
		if side == 1 then
			x = x + step
		end
		if side == 2 then
			y = y + step
		end
		if side == 3 then
			x = x - step
		end
		block:sendAnimationXY(411, x, y)
		owner:playSound(357)
	end,

	endAction = function(block)
		block:delete()
	end,

	uncast = function(player)
		player.paralyzed = false
		player:calcStat()
	end
}
