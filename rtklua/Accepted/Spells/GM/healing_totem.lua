summon_healing_totem = {
	cast = function(player)
		local anim = 519
		local magicCost = 500
		local aether = 120000

		local level = player.registry["healing_totem_level"]

		if level < 1 then
			level = 1
		elseif level > 6 then
			level = 6
		end

		if player.gmLevel > 0 then
			magicCost = 0
			aether = 0
		end

		local mobs = player:getObjectsInSameMap(BL_MOB)
		local count = 0

		for i = 1, #mobs do
			if mobs[i].yname == "healing_totem" and mobs[i].owner == player.ID then
				count = count + 1
			end
		end

		if player:hasAether("healing_totem") and count ~= 0 then
			player:msg(0, "You may only have one totem at a time.", player.ID)
			return
		else
			summon_healing_totem.spawn(player)
		end
	end,

	spawn = function(player)
		player:spawn(463, player.x, player.y, 1)

		-- spawn totem
		player:setAether("healing_totem", 120000)
	end,

	check = function(player)
		local mobs = player:getObjectsInSameMap(BL_MOB)

		for i = 1, #mobs do
			if mobs[i].yname == "healing_totem" then
				mobs[i]:talk(0, "owner: " .. mobs[i].owner)
			end
		end
	end,

	delete = function(player)
		local mobs = player:getObjectsInSameMap(BL_MOB)

		for i = 1, #mobs do
			if mobs[i].yname == "healing_totem" then
				mobs[i]:delete()
			end
		end
	end
}

healing_totem = {
	on_spawn = function(mob)
		local player = mob:getObjectsInCell(mob.m, mob.x, mob.y, BL_PC)

		if player ~= nil then
			mob.owner = player[1].ID
			mob.look = 1202
			mob.lookC = 0
			mob.side = player[1].side
			mob:sendSide()
			mob:updateState()
		end

		healing_totem_aura.cast(mob)
	end
}

healing_totem_aura = {
	cast = function(mob)
		local duration = 15000

		-- 30 seconds

		mob:sendAnimation(519)

		mob:setDuration("healing_totem_aura", duration)

		local level = Player(mob.owner).registry["healing_totem_level"]

		if level < 0 then
			level = 1
		elseif level > 6 then
			level = 6
		end
	end,

	while_cast = function(mob)
		local level = Player(mob.owner).registry["healing_totem_level"]

		--mob:sendAnimation(612)

		if level < 0 then
			level = 1
		elseif level > 6 then
			level = 6
		end

		level = 6

		local players = mob:getObjectsInArea(BL_PC)

		for i = 1, #players do
			if (distanceSquare(mob, players[i], 4) == true) then
				players[i]:sendAnimation(590)
				players[i]:addHealth(100)
			end
		end
	end,

	uncast = function(mob)
		mob:flushDuration()

		mob:delete()
	end
}
