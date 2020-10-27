shot_gun = {
	onEquip = function(player)
		player.registry["damage_shotgun"] = 1
	end,

	onUnequip = function(player)
		player.registry["damage_shotgun"] = 0
	end,

	while_equipped = function(player)
		player.attackSpeed = 5
		player:sendStatus()
	end,

	on_swing = function(player)
		player.registry["damage_shotgun"] = player.registry["damage_shotgun"] + 1
		shot_gun.cast(player)
	end,

	cast = function(player)
		local m = player.m
		local x = player.x
		local y = player.y
		local s = player.side
		local dam = 1
		local mob
		local pc
		local threat
		local weap = player:getEquippedItem(EQ_WEAP)
		local d = player.registry["damage_shotgun"]

		if not player:canAction(1, 1, 0) then
			return
		end
		if not player:canCast(1, 1, 0) then
			return
		end

		player:playSound(59)
		player:playSound(371)
		player:playSound(351)

		for i = 1, 7 do
			mob = getTargetFacing(player, BL_MOB, 0, i)
			pc = getTargetFacing(player, BL_PC, 0, i)

			if mob ~= nil then
				mob:sendAnimation(423)
				mob:sendAnimation(332)
				mob.attacker = player.ID
				mob.target = player.ID
				threat = mob:removeHealthExtend(d, 1, 1, 1, 1, 0)
				player:addThreat(mob.ID, threat)
				mob:removeHealthExtend(d, 1, 1, 1, 1, 2)
			elseif pc ~= nil then
				pc:sendAnimation(423)
				pc:sendAnimation(248)
				pc:sendAnimation(332)
				pc.attacker = player.ID
				if player:canPK(pc) then
					pc:removeHealthExtend(d, 1, 1, 1, 1, 0)
				end
				return
			end

			if s == 0 then
				if getPass(m, x, y - i) > 0 then
					player:sendAnimationXY(424, x, y - i)
					player:playSound(347)
					player:playSound(348)
					return
				end
			elseif s == 1 then
				if getPass(m, x + i, y) > 0 then
					player:sendAnimationXY(424, x + i, y)
					player:playSound(347)
					player:playSound(348)
					return
				end
			elseif s == 2 then
				if getPass(m, x, y + i) > 0 then
					player:sendAnimationXY(424, x, y + i)
					player:playSound(347)
					player:playSound(348)
					return
				end
			elseif s == 3 then
				if getPass(m, x - i, y) > 0 then
					player:sendAnimationXY(424, x - i, y)
					player:playSound(347)
					player:playSound(348)
					return
				end
			end
		end
	end
}
