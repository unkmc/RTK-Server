local _invalidShadowCountDialog = "It is impossible to exceed one's own potential."

local _bonHwaLimits = {
	{ -- Enchanted
		-- {Might, Grace, Will}
		{135, 130, 130}, -- Warrior
		{130, 135, 130}, -- Rogue
		{130, 130, 135}, -- Mage
		{130, 130, 135}  -- Poet
	},
	{ -- Il san
		{140, 135, 130},
		{135, 140, 130},
		{130, 135, 140},
		{135, 130, 140}
	},
	{ -- Ee san
		{150, 140, 130},
		{140, 150, 130},
		{130, 140, 150},
		{136, 130, 150}
	},
	{ -- Sam san
		{150, 145, 130},
		{145, 150, 130},
		{130, 145, 150},
		{139, 130, 150}
	},
	{ -- Sa san
		{150, 150, 130},
		{150, 150, 130},
		{130, 150, 150},
		{142, 130, 150}
	},
}

local _showInsufficientExp = function(player, cost)
	player:dialogSeq({"You do not understand enough of your true nature to unleash your potential any further. Please return when you possess at least " .. Tools.formatNumber(cost) .. " experience."}, 1)
end

local _promptShadowCount = function(player, statLabel, baseStatValue, maxShadowsPossible)
	local shadowCount = player:inputNumberCheck(
		player:input("Your natural " .. statLabel .. " is " .. Tools.formatNumber(baseStatValue) .. ".\n\nYou can unleash your shadow potential up to " .. Tools.formatNumber(maxShadowsPossible) .. " times.\n\nHow many times do you choose?")
	)

	return shadowCount
end

local _confirmShadowCount = function(player, statLabel, newStatValue, expCost)
	local confirmation = player:menuString(
		"Your " .. statLabel .. " will permanently increase to " .. Tools.formatNumber(newStatValue) .. ".\n\n" .. Tools.formatNumber(expCost) .. " experience will be irrevocably sacrificed.\n\nAre you sure?",
		{"Yes", "No"},
		{}
	)

	return confirmation
end

local _calculateBaseStats = function(player)
	player:calcStat()
	player:sendStatus()
end

local _finalizeExpSale = function(player)
	player:sendAnimation(18)
	player:playSound(708)
	_calculateBaseStats(player)
end

local _awardBonuses = function(player, nextCost, iterations)
	local smallExpBonus = math.ceil(nextCost / 20)
	local bigExpBonus = math.ceil(nextCost / 10)

	local bonusExp = 0
	local bonusKarma = 0

	for _ = 1, iterations do
		local rand = math.random(100)

		if (rand == 1) then
			bonusExp = bonusExp + bigExpBonus
			bonusKarma = bonusKarma + 0.01
		elseif (rand > 95) then
			bonusExp = bonusExp + smallExpBonus
		end
	end

	if (bonusExp > 0) then
		player.exp = player.exp + bonusExp
		player:addKarma(bonusKarma)
		player:sendStatus()
		player:dialogSeq({"Your training was very efficient. It cost you " .. Tools.formatNumber(bonusExp) .. " experience less than expected."})
	end
end

local _shadowStat = function(player, statIndex, statMaxValue, statCost)
	local smallReactions = {"Your muscles feel a surge.", "You feel more fluid.", "Your mind expands."}
	local bigReactions = {"Your muscles scream.", "Your nerves scream.", "Your mind screams."}
	local statLabels = {"Might", "Grace", "Will"}

	local statLabel = statLabels[statIndex]
	local baseStatValues = {player.baseMight, player.baseGrace, player.baseWill}
	local baseStatValue = baseStatValues[statIndex]

	player.registry["base" .. statLabel] = baseStatValue
	_calculateBaseStats(player)

	local maxShadowsPossible = math.floor(player.exp / statCost)
	local maxShadowsAllowed = statMaxValue - baseStatValue
	local maxShadows = math.min(maxShadowsPossible, maxShadowsAllowed)

	local shadowCount = _promptShadowCount(player, statLabel, baseStatValue, maxShadows)

	if (shadowCount > maxShadows) then
		player:dialogSeq({_invalidShadowCountDialog})
		return
	end

	local newStatValue = baseStatValue + shadowCount
	local expCost = shadowCount * statCost

	local confirmation = _confirmShadowCount(player, statLabel, newStatValue, expCost)

	if (confirmation ~= "Yes") then
		return
	end

	player.exp = player.exp - expCost
	player.expSoldStats = player.expSoldStats + expCost
	player.registry["base" .. statLabel] = newStatValue -- These registry assignments look pointless, but I think they are required for player:calcStat() to work properly.

	if (statIndex == 1) then
		player.baseMight = newStatValue
	elseif (statIndex == 2) then
		player.baseGrace = newStatValue
	else
		player.baseWill = newStatValue
	end

	local reaction = smallReactions[statIndex]

	if (shadowCount > 9) then
		reaction = bigReactions[statIndex]
	end

	player:sendMinitext(reaction)
	characterLog.xpSellWrite(player, statLabel:lower(), shadowCount, expCost)

	_finalizeExpSale(player)
	_awardBonuses(player, statCost, shadowCount)
end

local _getVitaOrManaCost = function(currentValue, statIndex)
	local minimumCost = 20000000
	local calculatedCost = math.floor((currentValue * statIndex - 80000 * Config.expSellFactor1) / 20000) * 2000000 * Config.expSellFactor2 + 20000000
	local cost = math.max(minimumCost, calculatedCost)

	return cost
end

local _shadowVitaOrMana = function(player, statIndex)
	local reactions = {"Your body strengthens.", "Your mind strengthens."}

	local isMinor = player.level < 99
	local statValueCap = 0

	if (isMinor) then
		statValueCap = 10000 / statIndex
	end

	local shadowsPossible = 0
	local exp = player.exp
	local statInterval = 100 / statIndex
	local currentValue = player.baseHealth
	local statLabel = "Vitality"

	if (statIndex == 2) then
		currentValue = player.baseMagic
		statLabel = "Mana"
	end

	player.registry["base" .. statLabel] = currentValue
	_calculateBaseStats(player)

	local tempValue = currentValue
	local tempCost

	while (exp > 0) do
		local nextValue = tempValue + statInterval

		if (isMinor and nextValue > statValueCap) then
			break
		end

		tempCost = _getVitaOrManaCost(tempValue, statIndex)

		if (exp >= tempCost) then
			shadowsPossible = shadowsPossible + 1
		end

		exp = exp - tempCost
		tempValue = nextValue
	end

	if (shadowsPossible < 1) then
		if (isMinor and statValueCap - currentValue < statInterval) then
			player:dialogSeq({"You have reached your limit for now, young one. Return to me when you have achieved the final insight."})
		end

		_showInsufficientExp(player, tempCost)
	end

	local shadowCount = _promptShadowCount(player, statLabel, currentValue, shadowsPossible)

	if (shadowCount > shadowsPossible) then
		player:dialogSeq({_invalidShadowCountDialog})
		return
	end

	local expCost = 0
	local newValue = currentValue

	for _ = 1, shadowCount do
		expCost = expCost + _getVitaOrManaCost(newValue, statIndex)
		newValue = newValue + statInterval
	end

	local confirmed = _confirmShadowCount(player, statLabel, newValue, expCost)

	if (confirmed ~= "Yes") then
		return
	end

	player.exp = player.exp - expCost
	player.registry["base" .. statLabel] = newValue

	if (statIndex == 1) then
		player.expSoldHealth = player.expSoldHealth + expCost
		player.baseHealth = newValue
	else
		player.expSoldMagic = player.expSoldMagic + expCost
		player.baseMagic = newValue
	end

	player:sendMinitext(reactions[statIndex])
	characterLog.xpSellWrite(player, statLabel:lower(), statInterval, expCost)

	_finalizeExpSale(player)

	local nextCost = _getVitaOrManaCost(newValue, statIndex)
	_awardBonuses(player, nextCost, shadowCount)
end

ExpSellerNpc = {
	click = async(function(player, npc)
		ExpSellerNpc.showShadowMainMenu(player, npc)
	end),

	getManaCost = function(currentValue)
		return _getVitaOrManaCost(currentValue, 2)
	end,

	getVitaCost = function(currentValue)
		return _getVitaOrManaCost(currentValue, 1)
	end,

	showShadowMainMenu = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}

		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if (player.m ~= npc.m) then
			return
		end

		if player.level < 90 then
			player:dialogSeq(
				{t, "There is nothing I can do for you, young one. Come back when you have achieved the 90th insight."},
				0
			)
			return
		end

		local opts = {"Shadow Stats", "Shadow Vitality", "Shadow Mana"}

		local choice = player:menuSeq(
			"Welcome, great one. How may I be of service?",
			opts,
			{}
		)

		if (choice == 1) then
			ExpSellerNpc.showShadowStatsMenu(player, npc)
		elseif (choice == 2) then
			_shadowVitaOrMana(player, 1)
		elseif (choice == 3) then
			_shadowVitaOrMana(player, 2)
		end
	end,

	showShadowStatsMenu = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}

		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local statMaxValues = {130, 130, 130}
		local statCost = 10000000
		local npcIsBonHwa = npc.name == "Bon-Hwa"

		if (npcIsBonHwa and (player.baseHealth >= 80000 or player.baseMagic >= 40000)) then
			local markLimits = _bonHwaLimits[player.mark + 1]
			statMaxValues = markLimits[player.baseClass]
			statCost = statCost * 10
		end

		if (player.exp < statCost) then
			_showInsufficientExp(player, statCost)
			return
		end

		local opts = {}

		if (player.baseMight < statMaxValues[1]) then
			table.insert(opts, "Might")
		end

		if (player.baseGrace < statMaxValues[2]) then
			table.insert(opts, "Grace")
		end

		if (player.baseWill < statMaxValues[3]) then
			table.insert(opts, "Will")
		end

		if (#opts < 1) then
			local dialog = "There is nothing more I can do for you. Perhaps you can find another who can guide you further."

			if (npcIsBonHwa) then
				dialog = "You have already realized your full potential."
			end

			player:dialogSeq({t, dialog}, 0)
			return
		end

		local choice = player:menuString(
			"Which aspect of your potential do you seek to unleash?",
			opts,
			{}
		)

		local statIndex

		if (choice == "Might") then
			statIndex = 1
		elseif (choice == "Grace") then
			statIndex = 2
		elseif (choice == "Will") then
			statIndex = 3
		end

		if (statIndex ~= nil) then
			_shadowStat(player, statIndex, statMaxValues[statIndex], statCost)
		end
	end,

	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)

		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}

		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if speech == "kawlana" then
			Tools.checkKarma(player)

			if player.quest["wind_armor"] == 0 or player.quest["min_kawlana"] == 0 or not player:karmaCheck("spirit") then
				player:dialogSeq(
					{t, "I really have no idea what you are talking about."},
					0
				)
				return
			end

			if player.quest["kawlana_quest"] == 0 then
				player:dialogSeq(
					{
						t,
						"You seek Kawlana? Now there is a word I have not heard in so long.",
						"The race of people who used that term are long gone now, faded into time, never to be seen again.",
						"Kawlana is your own spirit, your being, your life force.",
						"To get what you seek you will need to lose some of your life force, and bottle it.",
						"This ritual is highly sacred, and before you undertake such a task you should be able to show an understanding of your belief in all that is holy.",
						"If you still wish to do this you will need to bring me a few things."
					},
					1
				)
				player.quest["kawlana_quest"] = 1

				player:dialogSeq(
					{
						t,
						"You will need a bottle to hold it in, something that holds power to heal the body from evil.",
						"You will need a fine steel dagger, to cut into your chest, so you may bleed your life essence into the vial.",
						"To maintain accuracy, and keep from excessive damage, you will need a bracelet of grace.",
						"Much power is needed to bury the dagger deep enough to get to the heart. You will need an item of strength for this...",
						"Finally, a healing cloth will be required to tend the wounds you suffer, or your soul shall bleed until it fades away.",
						"Bring all this, and prepare yourself, as this will weaken you in ways you do not know."
					},
					0
				)
				return
			end

			if player.quest["kawlana_quest"] == 1 then
				if player:hasItem("holy_ring", 1) ~= true or player:hasItem("indigo_potion", 1) ~= true or player:hasItem(
					"fine_steel_dagger",
					1
				) ~= true or player:hasItem("whisper_bracelet", 1) ~= true or player:hasItem(
					"titanium_glove",
					1
				) ~= true or player:hasItem("sen_glove", 1) ~= true then
					player:dialogSeq(
						{t, "You do not have all the required items."},
						0
					)
					return
				end

				player:dialogSeq(
					{
						t,
						"Ahh, you have all you need but are you ready to begin?"
					},
					1
				)

				local choice = player:menuSeq(
					"Do you wish to collect your Kawlana now?",
					{"Yes, I do.", "No, I do not."},
					{}
				)

				if choice == 1 then
					--accept

					if os.time() < player.quest["kawlana_timer"] then
						player:dialogSeq(
							{
								t,
								"Your soul is not strong enough for what you ask. You will need to heal and grow stronger before you attempt to collect your Kawlana.",
								"You have " .. playerQuestTimerValues(
									player,
									"kawlana_timer"
								) .. " remaining until you can get another Kawlana."
							},
							1
						)
						return
					end

					if player.baseHealth < 100 then
						player:dialogSeq(
							{
								t,
								"You do not have enough vita to continue the ritual."
							},
							0
						)
						return
					end

					player:dialogSeq({t, "Then the ceremony shall begin..."}, 1)

					player:dialogSeq(
						{
							t,
							"With this holy item respect is shown for the ceremony."
						},
						1
					)
					player:removeItem("holy_ring", 1)

					player:dialogSeq(
						{t, "With this dagger you shall bleed your soul."},
						1
					)
					player:removeItem("fine_steel_dagger", 1)

					player:dialogSeq(
						{
							t,
							"With these gloves do you find the power to cut deep within your soul."
						},
						1
					)
					player:removeItem("titanium_glove", 1)

					player:dialogSeq(
						{
							t,
							"With this bracelet you find the skill to guide the blade."
						},
						1
					)
					player:removeItem("whisper_bracelet", 1)

					player:dialogSeq(
						{
							t,
							"In this vial you shall collect the power you need to protect and heal."
						},
						1
					)
					player:removeItem("indigo_potion", 1)

					player:dialogSeq(
						{
							t,
							"With this cloth glove you tend your wounds. Now hold still, as the power is contained."
						},
						1
					)
					player:removeItem("sen_glove", 1)

					player.baseHealth = player.baseHealth - 100
					player:calcStat()
					player.quest["kawlana_timer"] = os.time() + 10800

					-- 3 real hrs

					player:addItem("kawlana", 1)
					player:dialogSeq(
						{
							t,
							"Behold! You have collected your own Kawlana. Go now, and heal. Your body has weaked from this ordeal."
						},
						0
					)
				elseif choice == 2 then
					-- no
					player:dialogSeq(
						{t, "Very well. Return when you are ready."},
						0
					)
					return
				end
			end
		end
	end)
}
