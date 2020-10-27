wisdom_star = {
	broadcast = function()
		local timeRemaining = core.gameRegistry["wisdom_star_timer"] - os.time()

		local mult = getWisdomStarMultiplier()

		if mult == 0 or core.gameRegistry["wisdom_star"] == 0 then
			return
		end

		mult = string.format("%.2f", mult)

		if realMinute() == 15 or (timeRemaining >= 3540 and timeRemaining <= 3600) or (timeRemaining >= 1740 and timeRemaining <= 1800) or (timeRemaining >= 540 and timeRemaining <= 600) then
			broadcast(
				-1,
				"[WISDOM STAR]: " .. mult .. "x EXP | Time remaining: " .. getTimerValues("wisdom_star_timer")
			)
		end

		--60 min, 30 min, 10 min
	end,

	auto = function()
		local pc = core:getUsers()

		local mult = getWisdomStarMultiplier()

		if mult <= 0 then
			mult = 1
		end

		mult = string.format("%.2f", mult)

		if pc ~= nil then
			if #pc > 0 then
				for i = 1, #pc do
					if core.gameRegistry["wisdom_star"] == 1 then
						if not pc[i]:hasDuration("wisdom_star") then
							if pc[i].state ~= 1 then
								pc[i]:sendAnimation(348)
								pc[i]:playSound(106)
								pc[i]:sendMinitext("You are filled with Divine Wisdom ((" .. mult .. "x EXP))          " .. getTimerValues("wisdom_star_timer") .. " remaining")
								pc[i]:setDuration("wisdom_star", 100000000)
							end
						end
					elseif core.gameRegistry["wisdom_star"] == 0 then
						if pc[i]:hasDuration("wisdom_star") then
							pc[i]:setDuration("wisdom_star", 0)
						end
					end
				end
			end
		end
	end,

	cast = function(player)
		-- need to edit into something useful, currently just ends all light

		core.gameRegistry["wisdom_star"] = 0
		core.gameRegistry["wisdom_star_timer"] = 0
		setWisdomStarMultiplier(1)
	end,

	uncast = function(player)
		player:sendMinitext("Wisdom Star has faded.")
	end,

	cronTimer1 = function()
		--wisdom_star.checkIfOn()

		if core.gameRegistry["wisdom_star"] == 1 then
			if core.gameRegistry["wisdom_star_timer"] < os.time() then
				core.gameRegistry["wisdom_star"] = 0
				core.gameRegistry["wisdom_star_timer"] = 0
				setWisdomStarMultiplier(1)
				setKanDonationPoints(0)
			end
		end
	end,

	checkIfOn = function()
		if getKanDonationPoints() > 0 then
			if core.gameRegistry["wisdom_star"] == 0 then
				core.gameRegistry["wisdom_star"] = 1
			end
		end
	end,

	setPurchase = function(player, amount)
		local oldWSMult = getWisdomStarMultiplier()

		-- remove premium currency
		player:sendMinitext("You spent " .. amount .. " Kan on Wisdom Star")
		gmbroadcast(
			-1,
			"" .. player.name .. " has contributed " .. Tools.formatNumber(amount) .. " Kan toward Wisdom Star!"
		)

		addKanDonationPoints(amount)
		characterLog.wisdomStar(player, amount)

		wisdom_star.checkIfOn()
		wisdom_star.setMultiplier(oldWSMult)

		local mult = 900

		--100 premium currency / $1 == 15 minutes =  900s

		local wsmult = getWisdomStarMultiplier()

		--if wsmult >= 1.5 and wsmult < 2.0 then mult = 600 end -- i want it to cost at least $1.50 to entend WS for 15 mins between 1.5x and 2.0x
		--if wsmult >= 2.0 then mult = 450 end -- i want it to cost at least $2 to extend WS for 15 mins at 2.0x +

		local seconds = math.floor(mult * (amount / 100))

		if core.gameRegistry["wisdom_star_timer"] == 0 then
			core.gameRegistry["wisdom_star_timer"] = os.time() + seconds
		elseif core.gameRegistry["wisdom_star_timer"] > 0 then
			core.gameRegistry["wisdom_star_timer"] = core.gameRegistry[
				"wisdom_star_timer"
			] + seconds

			hours = math.floor(seconds / 3600)
			mins = math.floor((seconds / 60) - (hours * 60))
			secs = math.floor(seconds - hours * 3600 - mins * 60)

			if hours >= 1 then
				gmbroadcast(
					-1,
					"Wisdom Star timer extended by: " .. hours .. " hours " .. mins .. " minutes " .. secs .. " seconds"
				)
			elseif mins >= 1 then
				gmbroadcast(
					-1,
					"Wisdom Star timer extended by: " .. mins .. " minutes " .. secs .. " seconds"
				)
			else
				gmbroadcast(
					-1,
					"Wisdom Star timer extended by: " .. secs .. " seconds"
				)
			end
		end
	end,

	getRemainingTime = function()
		gmbroadcast(
			-1,
			"WS Time remaining: " .. getTimerValues("wisdom_star_timer")
		)
	end,

	setMultiplier = function(oldWSMult)
		local donationAmount = getKanDonationPoints()

		local multipliers = {1.00, 1.10, 1.25, 1.50, 1.75, 2.0}
		local pointThresholds = {0, 100, 1000, 3000, 5000, 8000}

		local multiplier = 1

		for i = 1, #multipliers do
			if donationAmount >= pointThresholds[i] then
				multiplier = multipliers[i]
			end
		end

		if multiplier > oldWSMult then
			setWisdomStarMultiplier(multiplier)
			gmbroadcast(
				-1,
				"Wisdom Star multiplier increased to " .. string.format(
					"%.2f",
					getWisdomStarMultiplier()
				) .. "x!"
			)
		end
	end
}
