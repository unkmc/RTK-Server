onGetExp = function(player, mob)
	local start = os.time() * 1000 + timeMS()
	local xp = mob.experience

	--local expTable = {xp, xp.66339, xp.54339, xp.46339, xp.42339, xp.40339, xp.38339, xp.37339, xp.35339, xp.34339, xp.33339, xp.32339, xp.31339, xp.30339, xp.29339}
	--local expTable = {xp, xp*.75, xp*.70, xp*.65, xp*.60, xp*.55, xp*.525, xp*.5, xp*.475, xp*.45, xp*.425, xp*.4, xp*.375, xp*.35, xp*.325}
	local expTable = {
		xp,
		xp *.70339,
		xp *.67339,
		xp *.64339,
		xp *.61339,
		xp *.58339,
		xp *.55339,
		xp *.53339,
		xp *.51339,
		xp *.49339,
		xp *.47339,
		xp *.45339,
		xp *.44339,
		xp *.43339,
		xp *.42339
	}

	local wisdomStarMultiplier = 1

	if player:hasDuration("wisdom_star") then
		wisdomStarMultiplier = getWisdomStarMultiplier()
	end

	if wisdomStarMultiplier < 1 then
		wisdomStarMultiplier = 1
	end

	-----------------------------------------------------------------------------------------------------
	local groupMembersInRangeAndAlive = {}

	for z = 1, #player.group do
		if (distanceSquare(Player(player.group[z]), mob, 12)) then
			if (Player(player.group[z]).state ~= 1) then
				if (Player(player.group[z]).m == mob.m) then
					table.insert(groupMembersInRangeAndAlive, {
						id = player.group[z],
						level = (Player(player.group[z]).level + (Player(player.group[z]).mark * 10))
					})
				end
			end
		end
	end

	table.sort(groupMembersInRangeAndAlive, function(a, b)
		return tonumber(a.level) > tonumber(b.level)
	end)

	local amount = math.ceil(expTable[#groupMembersInRangeAndAlive])

	for i = 1, #groupMembersInRangeAndAlive do
		local finalxp = amount
		local level = Player(groupMembersInRangeAndAlive[i].id).level
		local marklevel = Player(groupMembersInRangeAndAlive[i].id).mark * 10
		local highlevel = groupMembersInRangeAndAlive[1].level
		finalxp = finalxp * (level + marklevel) / highlevel
		if Player(groupMembersInRangeAndAlive[i].id):hasDuration("favor_of_the_gods") == true then
			finalxp = finalxp * 1.5
		end
		finalxp = Player(groupMembersInRangeAndAlive[i].id):checkTotemTimeXP(finalxp)
		if Player(groupMembersInRangeAndAlive[i].id):hasDuration("experience_shrine_spell") == true then
			finalxp = finalxp * 1.25
		end
		finalxp = math.ceil(finalxp)
		if (#player.group > 12) then
			Player(groupMembersInRangeAndAlive[i].id):sendMinitext("You can not gain experience in a group of this size.")
		else
			if Player(groupMembersInRangeAndAlive[i].id).level < 99 then
				local exp = getXPforLevel(
					Player(groupMembersInRangeAndAlive[i].id).baseClass,
					Player(groupMembersInRangeAndAlive[i].id).level
				)
				local exp2 = getXPforLevel(
					Player(groupMembersInRangeAndAlive[i].id).baseClass,
					Player(groupMembersInRangeAndAlive[i].id).level - 1
				)
				local diff = exp - exp2
				local modified = diff *.1
				if (finalxp < modified) then
					Player(groupMembersInRangeAndAlive[i].id):giveXP(
						finalxp,
						finalxp
					)
					characterLog.xpWrite(
						Player(groupMembersInRangeAndAlive[i].id),
						finalxp,
						mob
					)
				else
					if (finalxp < 1000) then
						Player(groupMembersInRangeAndAlive[i].id):giveXP(
							finalxp,
							finalxp
						)
						characterLog.xpWrite(
							Player(groupMembersInRangeAndAlive[i].id),
							finalxp,
							mob
						)
					else
						Player(groupMembersInRangeAndAlive[i].id):giveXP(
							modified,
							modified
						)
						characterLog.xpWrite(
							Player(groupMembersInRangeAndAlive[i].id),
							modified,
							mob
						)
					end
				end
			else
				Player(groupMembersInRangeAndAlive[i].id):giveXP(
					finalxp,
					finalxp
				)
				characterLog.xpWrite(
					Player(groupMembersInRangeAndAlive[i].id),
					finalxp,
					mob
				)
			end
		end
		if mob.isBoss == 1 then
			-- bosses
			Player(groupMembersInRangeAndAlive[i].id):sendMinitext("You have killed " .. (Player(groupMembersInRangeAndAlive[i].id):killCount(mob.mobID)) .. " " .. mob.name)
		end
	end

	if mob.isBoss == 1 then
		characterLog.bossKillLog(mob, groupMembersInRangeAndAlive)
	end

	broadcast(4, "exp: " .. (os.time() * 1000 + timeMS()) - start)

	-----------------------------------------------------------------------------------------------------
	--[[
	if player.state ~= 1 then
		if player.groupID == 0 then
			xp = xp * wisdomStarMultiplier

			if mob.isBoss == 1 then -- bosses
				player:sendMinitext("You have killed "..(player:killCount(mob.mobID)).." "..mob.name)
				characterLog.bossKillLog(mob,player)
			end

			player:giveXP(xp)
			player.registry["expCounter"] = player.registry["expCounter"] + 1

		return else
			if #pc > 0 then
				for i = 1, #pc do
					if pc[i].state ~= 1 then
						if pc[i].groupID == player.groupID then table.insert(party, pc[i].ID) end
					end
				end
		    end
			if #party > 0 then
				if #party <= 12 then
				   groupExp = expTable[#party]
					for i = 1, #party do
						mem = Player(party[i])
						if ((mem.level > highest) and (mem.m == mob.m)) then
							highestPlayer = mem.ID
							if(Player(highestPlayer).m == mem.m) then
								highest = mem.level
							end
						end
					end

					for i = 1, #party do
      						mem = Player(party[i])
						if mem.m == player.m and mem.state ~= 1 then
							diff = Player(highestPlayer).level + (Player(highestPlayer).mark * 10) - mem.level
                           				percentage = (mem.level/(highest+(Player(highestPlayer).mark * 10)))
							local partyCount = 0
							if(#party == 1) then
								partyCount = 0
							else
								partyCount = #party
								xp = xp * .95
							end

							finalExp = xp*((1-(partyCount * .05678))*percentage)

							if mem:hasDuration("wisdom_star") then
								finalExp = finalExp * wisdomStarMultiplier
							end

							if mob.isBoss == 1 then -- bosses
								mem:sendMinitext("You have killed "..(mem:killCount(mob.mobID)).." "..mob.name)
							end

							mem:giveXP(math.ceil(finalExp))
							mem.registry["expCounter"] = mem.registry["expCounter"] + 1
							characterLog.xpWrite(mem,math.ceil(finalExp),mob.name)
						end
					end
				else
					player:sendMinitext("You can't gain experience with a group this large!")
					return
				end
			end
		end
	end

	]]
	--
end
