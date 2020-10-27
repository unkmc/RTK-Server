PoemNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {}

		table.insert(opts, "Vote on a poem")

		if player.gmLevel > 0 then
			table.insert(opts, "Clear votes")
			table.insert(opts, "Close voting session")
		end

		local poems = getPoems()
		local poemTopics = {}
		local poemIDs = {}
		local poemAuthors = {}

		local x = 1

		for i = 1, #poems do
			table.insert(poemIDs, poems[x])
			table.insert(poemAuthors, poems[x + 1])
			table.insert(poemTopics, poems[x + 2])
			x = x + 3
		end

		for i = 1, #poemTopics do
			poemTopics[i] = i .. ". " .. poemTopics[i]
		end

		poemTopics = sort_relativeDesc(poemIDs, poemTopics)
		poemAuthors = sort_relativeDesc(poemIDs, poemAuthors)
		poemIDs = sort_relativeDesc(poemIDs, poemIDs)

		for i = 1, #poemIDs do
			-- stores the poem IDs & author in npc registry
			npc.registry["poem" .. i] = poemIDs[i]
			npc.registry["poem" .. i .. "Author"] = poemAuthors[i]
		end

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)

		if choice == "Vote on a poem" then
			local choice2 = player:menuSeq(
				"Which poem would you like to vote for?",
				poemTopics,
				{}
			)
			local choice3 = player:menuSeq(
				"Are you sure you want to cast this vote?",
				{"Yes, cast my vote.", "No, I'm not ready."},
				{}
			)

			if choice3 == 2 then
				return
			end

			local poemID = npc.registry["poem" .. choice2]
			local poemTopic = ""

			for i = 1, #poemIDs do
				if poemIDs[i] == poemID then
					poemTopic = poemTopics[i]
				end
			end

			npc.registry["poem" .. choice2 .. "Votes"] = npc.registry[
				"poem" .. choice2 .. "Votes"
			] + 1

			player:msg(0, "You have voted for: " .. poemTopic, player.ID)
			player:msg(0, "Thanks for voting!", player.ID)
			PoemNpc.removePlayerSelectionList(player)
			player:returnFunc()
		end

		if choice == "Close voting session" then
			PoemNpc.closeVotingSession()
		end

		if choice == "Clear votes" then
			PoemNpc.clearVotes()
		end
	end),

	determineWinningPoem = function()
		local npc = NPC("Poem")

		local origpoems = getPoems()
		local origpoemTopics = {}
		local origpoemIDs = {}
		local origpoemAuthors = {}

		local x = 1

		for i = 1, #origpoems do
			table.insert(origpoemIDs, origpoems[x])
			table.insert(origpoemAuthors, origpoems[x + 1])
			table.insert(origpoemTopics, origpoems[x + 2])
			x = x + 3
		end

		local poemIDs = {}
		local poemVotes = {}
		local poemTopics = {}
		local poemAuthors = {}

		local count = 0

		for i = 1, 255 do
			if npc.registry["poem" .. i] ~= 0 then
				table.insert(poemIDs, npc.registry["poem" .. i])
				table.insert(poemVotes, npc.registry["poem" .. i .. "Votes"])
				table.insert(poemAuthors, npc.registry["poem" .. i .. "Author"])
				table.insert(poemTopics, origpoemTopics[i])
				count = count + 1
			end
		end

		local winningPoemIDs = {}
		local winningPoemTopics = {}
		local winningPoemAuthors = {}
		local winningPoemVotes = {}

		if count > 1 then
			winningPoemIDs = sort_relativeDesc(poemVotes, poemIDs)
			winningPoemTopics = sort_relativeDesc(poemVotes, poemTopics)
			winningPoemAuthors = sort_relativeDesc(poemVotes, poemAuthors)
			winningPoemVotes = sort_relativeDesc(poemVotes, poemVotes)
		else
			winningPoemIDs = poemIDs
			winningPoemTopics = poemTopics
			winningPoemAuthors = poemAuthors
			winningPoemVotes = poemVotes
		end

		if winningPoemVotes[1] == winningPoemVotes[2] then
			npc.registry["maxVotes"] = npc.registry["maxVotes"] + 1

			-- tie between top poems
			return
		end

		local author = getOfflineID(winningPoemAuthors[1])
		local title = winningPoemTopics[1]
		local votes = winningPoemVotes[1]
		local id = winningPoemIDs[1]

		local worked = copyPoemToPoetry(id, author)

		if worked == true then
			clearPoems()

			broadcast(
				-1,
				"[POEMS]: Winning submission: " .. title .. " by " .. author .. " with " .. votes .. " votes"
			)

			npc:sendParcel(
				winningPoemAuthors[1],
				npc.id,
				Item("poetry_revel_1st_place").id,
				1,
				winningPoemAuthors[1],
				"",
				1
			)

			if Player(winningPoemAuthors[1]) ~= nil then
				Player(winningPoemAuthors[1]):msg(
					0,
					"Congratulations, your poem has won. Please visit Parcel to collect your prize.",
					Player(winningPoemAuthors[1]).ID
				)
				Player(winningPoemAuthors[1]):sendStatus()
			end
		end
	end,

	checkPlayerSelectionList = function(player)
		local npc = NPC("Poem")
		local found = false

		for i = 1, 255 do
			if npc.registry["voter" .. i] == player.ID then
				found = true
				break
			end
		end

		return found
	end,

	closeVotingSession = function()
		local npc = NPC("Poem")
		local pcs = npc:getObjectsInSameMap(BL_PC)

		if pcs ~= nil then
			for i = 1, #pcs do
				pcs[i]:warp(330, math.random(72, 75), math.random(22, 26))
			end
		end

		PoemNpc.determineWinningPoem()
		PoemNpc.clearPlayerSelectionList()
		PoemNpc.clearVotes()
		npc.registry["maxVotes"] = 0
	end,

	clearPlayerSelectionList = function()
		local npc = NPC("Poem")

		for i = 1, 255 do
			npc.registry["voter" .. i] = 0
		end
	end,

	removePlayerSelectionList = function(player)
		local npc = NPC("Poem")

		for i = 1, 255 do
			if npc.registry["voter" .. i] == player.ID then
				npc.registry["voter" .. i] = 0
			end
		end
	end,

	clearVotes = function()
		local npc = NPC("Poem")

		for j = 1, 255 do
			npc.registry["poem" .. j] = 0
			npc.registry["poem" .. j .. "Votes"] = 0
			npc.registry["poem" .. j .. "Author"] = 0
		end
	end,

	populatePlayerSelectionList = function()
		local npc = NPC("Poem")
		local poems = getPoems()
		local poemTopics = {}
		local poemIDs = {}
		local poemAuthors = {}
		local onlinePlayers = npc:getUsers()
		local shuffleOnlinePlayers = randomShuffle(onlinePlayers)

		local x = 1

		for i = 1, #poems do
			table.insert(poemIDs, poems[x])
			table.insert(poemAuthors, poems[x + 1])
			table.insert(poemTopics, poems[x + 2])
			x = x + 3
		end

		if #poemIDs == 0 then
			return
		end

		npc.registry["maxVotes"] = math.ceil(#poemIDs * 5 + 1)

		local totalVotes = 0

		for j = 1, 255 do
			totalVotes = totalVotes + npc.registry["poem" .. j .. "Votes"]
		end

		local totalVotesLeft = npc.registry["maxVotes"] - totalVotes

		for i = 1, #shuffleOnlinePlayers do
			if i >= totalVotesLeft then
				return
			end

			shuffleOnlinePlayers[i]:msg(
				0,
				"You have been randomly selected to vote on the submitted poems for the week.",
				shuffleOnlinePlayers[i].ID
			)
			shuffleOnlinePlayers[i]:msg(
				0,
				"If you would like to vote, you can access the warp function in your F1 menu.",
				shuffleOnlinePlayers[i].ID
			)
			npc.registry["voter" .. i] = shuffleOnlinePlayers[i].ID
		end
	end
}
