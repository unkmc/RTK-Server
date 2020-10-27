BladestormTrapNpc = {
	action = function(npc)
		local player = Player(npc.owner)
		if player ~= nil then
			if player.magic < 5000 then
				player.magic = 0
			else
				player.magic = player.magic - 5000
			end
		end
		player:sendStatus()
	end,
	click = function(block, npc)
		local damage = 0
		if (block.blType == BL_PC) then
			-- Carnage etc.
			if block.state == 1 then
				return
			end
			if not block:canPK(block) then
				return
			end
			damage = math.floor(block.health *.5)
			damage = damage + calculateDamage(block, 35000)
		else
			if block.m < 60000 then
				damage = math.floor(block.health *.75)
			else
				damage = math.floor(block.health *.05)
			end
		end

		local s = block.side
		local x = {}
		local y = {}

		if (s == 0) then
			x = {0, -1, 0, 1}
			y = {-1, -2, -2, -2}
		elseif (s == 1) then
			x = {1, 2, 2, 2}
			y = {0, -1, 0, 1}
		elseif (s == 2) then
			x = {0, -1, 0, 1}
			y = {1, 2, 2, 2}
		elseif (s == 3) then
			x = {-1, -2, -2, -2}
			y = {0, 1, 0, -1}
		else
			return
		end

		if (block.blType == BL_MOB) then
			if (block.health < damage and block.health > 1) then
				damage = block.health - 1
			elseif (block.health == 1) then
				damage = 0
			end
		end

		if (block.blType == BL_PC) then
			if damage >= block.health then
				damage = block.health
				broadcast(block.m, "" .. block.name .. " has fallen in battle.")
			end
		end

		for i = 1, 4 do
			local target = block:getAliveObjectsInCell(
				block.m,
				block.x + x[i],
				block.y + y[i],
				BL_MOB
			)
			local targetpc = block:getAliveObjectsInCell(
				block.m,
				block.x + x[i],
				block.y + y[i],
				BL_PC
			)

			if #target > 0 then
				target[1]:sendAnimation(7)
				target[1].attacker = block.ID
				target[1]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
			elseif #targetpc > 0 then
				if block.pvp > 0 then
					targetpc[1]:sendAnimation(7)
					targetpc[1].attacker = block.ID
					targetpc[1]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
				end
			end
		end
		block:sendAction(1, 35)
		block:talk(2, "AIEE~!")
		block:playSound(88)
		block:sendAnimation(7)
		block:sendAnimation(49)
		block.attacker = 0
		block.health = block.health - damage
		block:removeHealth(0)
		block:sendStatus()
		removeTrapItem(npc)
		npc:delete()
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end
}
