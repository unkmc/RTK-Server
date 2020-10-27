cotw_controller_poet = {
	on_takedamage_while_cast = function(player, attacker)
		local threat = threat.getHighestThreat(attacker)
		player:setThreat(player.attacker, threat + attacker.damage)
	end,
	uncast = function(player)
		local mobs = mob:getObjectsInMap(player.m, BL_MOB)
		for i = 1, #mobs do
			if mobs[i].owner == player.ID then
				mobs[i]:removeHealth(mobs[i].maxHealth)
			end
		end
	end
}

cotw_spawnCheck = function(player, mobID)
	local amount = 4

	if player.level >= 99 then
		amount = 8
	elseif player.level >= 90 then
		amount = 6
	end

	local totalmobs = player:getObjectsInMap(player.m, BL_MOB)
	local playerMobs = 0

	for i = 1, #totalmobs do
		if totalmobs[i].owner == player.ID then
			playerMobs = playerMobs + 1
		end
	end

	if playerMobs >= amount then
		return false
	end

	return true
end

cotw_SpawnSetThreat = function(player, mobID, spawnDuration)
	local x = 0
	local y = 0
	local s = player.side
	local fail = 0
	if s == 0 then
		y = -1
	end
	if s == 1 then
		x = 1
	end
	if s == 2 then
		y = 1
	end
	if s == 3 then
		x = -1
	end
	if getPass(player.m, player.x + x, player.y + y) ~= 0 then
		fail = 1
	end
	if #player:getObjectsInCell(player.m, player.x + x, player.y + y, BL_MOB) > 0 then
		fail = 1
	end
	if #player:getObjectsInCell(player.m, player.x + x, player.y + y, BL_PC) > 0 then
		fail = 1
	end
	if fail == 1 then
		x = 0
		y = 0
	end
	player:spawn(mobID, player.x + x, player.y + y, 1, player.m, player.ID)

	local mob = player:getObjectsInCell(
		player.m,
		player.x + x,
		player.y + y,
		BL_MOB
	)
	mob[1].registry["spawnTime"] = os.time() + spawnDuration

	local attacker = mob[1]:getBlock(player.attacker)
	if attacker ~= nil then
		local threat = threat.getHighestThreat(attacker)
		player:setThreat(player.attacker, threat + attacker.damage)
	end

	player:sendMinitext("You summon a " .. mob[1].name)
end
