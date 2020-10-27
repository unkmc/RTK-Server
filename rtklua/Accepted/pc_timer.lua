pc_timer = {
	tick = function(player)
		--player:talk(0,"interval "..player.timerInterval)

		if (player.timerTick % 1 == 0) then
			--0.5,1.5,2.5 seconds
			pc_timer.halfsecond(player)
		end

		if (player.timerTick % 2 == 0) then
			--1 second
			pc_timer.second(player)
		end

		if (player.timerTick % 10 == 0) then
			--5 seconds
			pc_timer.fivesecond(player)
		end

		if (player.timerTick % 120 == 0) then
			--60 seconds
			pc_timer.minute(player)
		end

		if (player.timerTick % 7200 == 0) then
			--1 hour
			pc_timer.hour(player)
		end
	end,

	advice = function(player)
		if (player.timerTick % 1800 == 0) then
			-- 15mins
			player:msg(99, "" .. advice[math.random(#advice)], player.ID)
		end
	end,

	halfsecond = function(player)
		if (player.registry["see_warps"] == 1) then
			warpGlow(player)
		end

		player:regen()
	end,

	second = function(player)
		local seconds = math.floor(player.timerTick / 2)
		questtracker.displayquest(player)

		player.registry["last_logout"] = os.time()
		player:expireItem()

		if player.mapTitle == "Windy Summit" then
			local random = math.random(1, 15)

			if random == 1 then
				player:sendMinitext("The winds blow fast and furious overhead.")
			end
		end

		BeachWarNpc.playerCore(player)
	end,

	fivesecond = function(player)
		player:afkCheckDoorBlock(player)

		player.registry["last_logout"] = os.time()

		-- this updates the registry  for player session time.

		--[[
	if player.level < 99 then
		player:setDuration("favor_of_the_gods", 99999999)
	else
		if player:hasDuration("favor_of_the_gods") then
			player:setDuration("favor_of_the_gods", 1)
		end
	end
	]]
		--
	end,

	minute = function(player)
		--local minutes = math.floor(player.timerTick/120)
	end,

	hour = function(player)
		--local hours = math.floor(player.timerTick/7200)
	end,

	display_timer = function(player)
		--Executes when a display timer finishes.
		--player:talk(2, "Beep beep, beep beep...")
	end
}
