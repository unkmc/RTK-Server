onScriptedTilesSubpath = function(player)
	-- wilderness
	if player.m == 1002 then
		-- ranger
		if (player.x == 52 or player.x == 53) and player.y == 32 and (os.time() > player.registry["rangerBan"] + (60 * 8)) then
			local x = math.random(25, 27)
			player:warp(3619, x, 28)
		end

		-- druid
		if (player.x == 172 or player.x == 173) and player.y == 212 and (os.time() > player.registry["druidBan"] + (60 * 8)) then
			local x = math.random(9, 10)
			player:warp(3632, x, 33)
		end
	end

	-- oh mudum crypt
	if player.m == 2205 then
		-- spy
		if (player.x == 10) and player.y == 17 and (os.time() > player.registry["spyBan"] + (60 * 8)) then
			local x = math.random(8, 9)
			player:warp(3519, x, 28)
		end
	end

	-- kugnae
	if player.m == 0 then
		-- diviner
		if (player.x == 126 or player.x == 127) and player.y == 168 and (os.time() > player.registry["divinerBan"] + (60 * 8)) then
			local x = math.random(15, 16)
			player:warp(3540, x, 28)
		end

		-- merchant
		if (player.x == 100) and player.y == 159 and (os.time() > player.registry["merchantBan"] + (60 * 8)) then
			local x = math.random(18, 20)
			player:warp(3524, x, 28)
		end
	end

	-- dae shore
	if player.m == 1004 then
		-- chongun
		if (player.x == 58 or player.x == 59) and player.y == 5 and (os.time() > player.registry["chongunBan"] + (60 * 8)) then
			local x = math.random(25, 26)
			player:warp(3614, x, 33)
		end

		-- monk
		if (player.x == 39 or player.y == 40) and player.y == 7 and (os.time() > player.registry["monkBan"] + (60 * 8)) then
			player:warp(3529, 6, 28)
		end
	end

	-- sanhae hall
	if player.m == 1127 then
		-- do
		if (player.x == 9 or player.x == 10) and player.y == 2 and (os.time() > player.registry["doBan"] + (60 * 8)) then
			player:warp(3609, 12, 28)
		end
	end

	-- islets
	if player.m == 1008 then
		-- muse
		if (player.x == 68 or player.x == 69) and player.y == 7 and (os.time() > player.registry["museBan"] + (60 * 8)) then
			player:warp(3629, 14, 28)
		end
	end

	-- oh mudum crypt for spy
	if player.m == 2205 then
		if player.quest["spy_trials"] == 7 then
			local rand = math.random(1, 100)
			if rand == 1 then
				gravekeeper(player)
			end
		end
	end

	-- vale for spy quest
	if player.m == 1005 then
		if player.quest["spy_trials"] == 13 then
			if (player.x == 245 or player.x == 246 or player.x == 247) and player.y == 179 then
				caravan(player)
			end
		end
	end

	-- stealth grotto spy
	if player.m == 3519 then
		if player.quest["spy_trials"] == 14 then
			if player.x == 12 and player.y == 13 then
				complete_spy(player)
			end
		end
		if player.quest["spy_trials"] == 12 then
			if player.x == 12 and player.y == 13 then
				hwan.interrogate(player)
			end
		end
	end

	-- nagnang
end

complete_spy = async(function(player)
	player.quest["spy_trials"] = 15
	local mistress = {graphic = convertGraphic(5296, "item"), color = 30}
	player:dialogSeq(
		{
			mistress,
			"We heard the explosion from here! It seems you have the skillset our organization needs. Will you pledge yourself to our Guild?"
		},
		1
	)
	local choices = {
		"Sign the contract with your name.",
		"Sign the contract with a false name.",
		"Draw a symbol.",
		"Do not sign the contract just yet."
	}
	local choice = player:menuSeq(
		"The Guild Mistress produces a small contract and holds out a pen: ",
		choices,
		{}
	)
	if choice == 1 then
		player:addLegend(
			"Associate of the KSG (" .. curT() .. ")",
			"spy_rank",
			22,
			1
		)
		player:dialogSeq(
			{
				mistress,
				"Excellent, let me show you into our Guild Hall and make sure you check the Guild board..."
			},
			1
		)
	elseif choice == 2 then
		player:dialogSeq(
			{
				mistress,
				"Interesting alias... let me show you into our Guild hall and make sure you check the Guild board..."
			},
			1
		)
	elseif choice == 3 then
		player:dialogSeq(
			{
				mistress,
				"Yup, I knew you were clever... let me show you into our Guild hall and make sure you check the Guild board..."
			},
			1
		)
	elseif choice == 4 then
		player.quest["spy_trials"] = 14
		player:dialogSeq(
			{mistress, "No problem. Come back here anytime you want to join."},
			1
		)
	end
end)

caravan = async(function(player)
	local envoy = {graphic = convertGraphic(7, "monster"), color = 30}
	local explosives = {graphic = convertGraphic(313, "item"), color = 0}
	local spy = {graphic = convertGraphic(102, "monster"), color = 5}
	local item1 = {graphic = convertGraphic(5271, "item"), color = 0}
	local item2 = {graphic = convertGraphic(3745, "item"), color = 0}
	player:dialogSeq(
		{envoy, "** You spot the Imperial Envoy coming down the passage! **"},
		1
	)
	player:dialogSeq(
		{
			explosives,
			"** Quickly, you camoflauge the eplxosives under a pile of rocks, extend the fuse, and hide a safe distance under the bridge. **"
		},
		1
	)
	player:dialogSeq(
		{
			spy,
			"** Just as the envoy reaches the passage, you notice a shadowed figure descend from a tree and sneak up on the envoy. **"
		},
		1
	)
	player:sendAnimationXY(19, 247, 179, 60)
	player:sendAnimationXY(19, 246, 179, 60)
	player:sendAnimationXY(19, 245, 179, 60)
	player:sendAnimationXY(19, 247, 178, 60)
	player:sendAnimationXY(19, 246, 178, 60)
	player:sendAnimationXY(19, 245, 178, 60)
	player:dialogSeq(
		{
			item1,
			"** The explosives detonate amind the envoy and the shadowed figure, toppling the wall so the passage is blocked. **"
		},
		1
	)
	player.quest["spy_trials"] = 14
	player.registry["spy_sabotage"] = player.registry["spy_sabotage"] + 1
	player:removeLegendbyName("spy_sabotage")
	player:addLegend(
		"Performed " .. player.registry["spy_sabotage"] .. " acts of sabotage",
		"spy_sabotage",
		22,
		128
	)
	player:dialogSeq(
		{
			item2,
			"** You emerge from your vantage point and notice there are no signs of the envoy or the shadowed figure. **",
			"** Only the shattered hilt of a dagger and burnt pieces of Imperial uniforms lay scattered behind. **"
		},
		1
	)
end)

gravekeeper = async(function(player)
	player:removeItem("handwritten_note", 1)
	local gravekeeper = {graphic = convertGraphic(3490, "item"), color = 0}
	player:dialogSeq(
		{
			gravekeeper,
			"** You spot a gravekeeper tending a fresh grave. **",
			" ** He hobbles over and looks you up and down."
		},
		0
	)
	if player.registry["carnageWin"] < 2 then
		player:dialogSeq(
			{
				gravekeeper,
				"You don't look the type that could send anyone to their grave.",
				"Come back when you have at least two riches wins."
			},
			0
		)
		return
	end
	local response = player:inputSeq(
		"Did you leave something at home for this weather?",
		"",
		"",
		{},
		{}
	)
	if string.lower(response) == "umbrella" then
		player.quest["spy_trials"] = 8
		player:dialogSeq(
			{
				gravekeeper,
				"** The gravekeeper ambles to the crypt's door, shuts it with a loud thud, and smooths his voice back to his natural tone. **",
				"Then I guess good work sealing those loose lips at the casino. The Guild said you might be an asset to have in our network...or was the other one who came through here today...",
				"No matter, there's something that needs to be taken care of.",
				"Someone knows something we need to know.",
				"You could say it's of kingdom-wide importance. Go speak with one of our intelligence specialists, Pond, at his library.",
				"Ask him to see the Special Collections, and he will give you details."
			},
			0
		)
	else
		player:dialogSeq(
			{gravekeeper, "Meh, I'll stay here until the weather changes then."},
			0
		)
	end
end)
