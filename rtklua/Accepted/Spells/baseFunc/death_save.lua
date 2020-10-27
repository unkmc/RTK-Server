death_save = {
	cast = function(player)
	end,

	uncast = function(player)
		if player.health > 0 then
			return
		end

		local attacker = player:getBlock(player.attacker)
		local pc = core:getUsers()

		if player.gmLevel >= 50 then
			player.state = 0
			player.health = player.maxHealth
			player.magic = player.maxMagic
			player.speed = 90
			player:flushDuration(1)
			player:sendStatus()
			player:updateState()
			return
		end

		-- on NTK, aethers do NOT flush when you die. All spells but Rage/CUnning flush duration
		player.deathFlag = 1
		player.state = 1
		player.disguise = 0
		player.speed = 90
		player:flushDuration(1)

		-- all spells wipe when you die
		player:updateState()
		player:sendStatus()
		player:calcStat()

		--if player.region == 15 then return end -- used for minigame maps
		if player:canPK(player) then
			local text = player.classNameMark .. " " .. player.name .. " has fallen in battle to " .. attacker.classNameMark .. " " .. attacker.name
			broadcast(player.m, text)

			--increase attacker's kill count for carnages
			if ((attacker.m == 33 or attacker.m == 3011) and attacker.blType == BL_PC) then
				attacker.registry["carnageKillCount"] = attacker.registry[
					"carnageKillCount"
				] + 1
			end

			return
		end

		-- no loss of dura and shit for pvp

		if player.mapTitle ~= "Kugnae" and player.mapTitle ~= "Buya" and player.mapTitle ~= "Nagnang" and player.mapTitle ~= "Mythic Nexus" and player.mapTitle ~= "KaMing's Encampment" then
			if player.m < 59000 or player.m > 65000 then
				-- not include instances
				player:deathDropGold()
				player:deathExpLoss(0.5)
				player:deathDuraLoss()
				player:deathPileDrop()
			elseif player.m >= 59000 and player.m <= 65000 then
				-- instances
				player:deathExpLoss(0.1)
			end
		end

		local deathMinitext = {
			"Death is not the End:  Go",
			"to one of the shaman's",
			"huts, at the East or West gate."
		}
		for i = 1, #deathMinitext do
			player:sendMinitext(deathMinitext[i])
		end

		player:talkSelf(
			0,
			"" .. player.name .. ": I died at " .. player.mapTitle .. ", X: " .. player.x .. ", Y: " .. player.y
		)
		player:msg(
			0,
			"You have died. Please use the F1 menu and select Silver Thread. A Shaman at East or West gate will resurrect you.",
			player.ID
		)

		for i = 1, #pc do
			if pc[i].gmLevel > 0 then
				if attacker == nil then
					pc[i]:msg(
						4,
						"[DEATH]: " .. player.name .. " was killed at " .. player.mapTitle,
						pc[i].ID
					)
				else
					pc[i]:msg(
						4,
						"[DEATH]: " .. player.name .. " was killed by " .. attacker.name .. " at " .. player.mapTitle,
						pc[i].ID
					)
				end
			end
		end
	end
}
