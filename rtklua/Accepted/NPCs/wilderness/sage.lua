SageNpc = {
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

		if player.level < 50 then
			player:dialogSeq(
				{t, "Come back when you have reached the 50th insight."},
				0
			)
			return
		end

		local sages = {
			"share_wisdom",
			"mentors_wisdom",
			"apprentices_wisdom",
			"adepts_wisdom",
			"sages_wisdom"
		}
		local sageCosts = {25000, 100000, 100000, 100000, 100000}
		local levelReqs = {50, 90, 90, 90, 90}
		local learnSageTimers = {
			604800 * 2,
			604800 * 4,
			604800 * 6,
			604800 * 8,
			0
		}

		-- 2 weeks, 4 weeks, 6 weeks, 8 weeks, reset back to 0

		if os.time() < player.registry["learnSageSpellTimer"] then
			player:dialogSeq(
				{
					t,
					"You have your spell for now, and I will not let you upgrade again for " .. playerTimerValues(
						player,
						"learnSageSpellTimer"
					)
				},
				0
			)
			return
		end

		--[[player:dialogSeq({t,"Read the following rules very carefully, for if you should break one then you will lose this spell for a long time!",
		"Share wisdom is for you to share your wisdom with the community.",
		"Use of the spell in any way to offend anybody in the game can result in its loss.",
		"Sharing of wisdom not needed to the world of RetroTK can result in loss of this spell.",
		"Repeated spamming of your wisdom to the world can result in the loss of this spell.",
		"Jailing for ANY crime will result in loss of this spell.",
		"Breaking any other law in RetroTK using this spell will result in loss of the spell."},1)]]
		--

		player:dialogSeq(
			{
				t,
				"Read the following rules very carefully, for if you should break one then you will lose this spell for a long time!",
				"Share wisdom is for you to share your wisdom with the community.",
				"Use of the spell in any way to offend or harass anyone in the game will result in its loss.",
				"Repeated spamming of your wisdom to the world can result in the loss of this spell.",
				"Keep personal grievances out of sage.",
				"Jailing for ANY crime will result in loss of this spell.",
				"Breaking any other law in RetroTK using this spell will result in loss of the spell."
			},
			1
		)

		if player:hasSpell("sages_wisdom") then
			player:dialogSeq(
				{t, "I have already taught you the highest level of wisdom"},
				0
			)
			return
		end

		local choice = player:menuSeq(
			"Do you understand these rules completely?",
			{
				"Yes, I understand and accept the rules.",
				"No, please repeat them to me."
			},
			{}
		)

		local sage = ""
		local sageCost = 0
		local levelReq = 0
		local learnSageTimer = 0

		if choice == 1 then
			-- accept

			for i = 1, #sages do
				if player:hasSpell(sages[i]) then
					sage = sages[i + 1]
					sageCost = sageCosts[i + 1]
					levelReq = levelReqs[i + 1]
					learnSageTimer = learnSageTimers[i + 1]
					break
				end
			end

			if sage == "" then
				-- no spell found
				sage = sages[1]
				sageCost = sageCosts[1]
				levelReq = levelReqs[1]
				learnSageTimer = learnSageTimers[1]
			end

			if sageCost == 0 then
				return
			end

			local choice2 = player:menuSeq(
				"This spell will cost " .. Tools.formatNumber(sageCost) .. " gold to learn.",
				{"Yes, I have the money.", "No, I will not pay."},
				{}
			)

			if choice2 == 1 then
				-- have money
				if player.money < sageCost then
					player:dialogSeq(
						{
							t,
							"The spell I will teach you cost " .. Tools.formatNumber(sageCost) .. " gold. Return to me when you have that."
						},
						0
					)
					return
				end

				player:removeGold(sageCost)
				player:addSpell(sage)

				player.registry["learnSageSpellTimer"] = os.time() + learnSageTimer

				player:dialogSeq(
					{
						t,
						"Use your spell well, abuse will result in its loss, and you will end up having to learn the spells again from the start."
					},
					0
				)
			elseif choice2 == 2 then
				-- no
				return
			end
		elseif choice == 2 then
			-- repeat
			player:freeAsync()
			SageNpc.click(player, npc)
		end
	end)
}
