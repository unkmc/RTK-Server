blood_oath = {
	cast = async(function(player)
		if player:hasLegend("forged_blood_oath") or player:hasLegend("sealed_blood_oath") then
			player:removeSpell("blood_oath")
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		player:setDuration("blood_oath", 1200000)
		player.setAether("blood_oath", 1200000)

		local pcs = player:getObjectsInArea(BL_PC)

		if player:hasLegend("engaged") or player:hasLegend("married") or player:hasLegend("forged_blood_oath") or player:hasLegend("sealed_blood_oath") or player.partner ~= 0 then
			player:dialog("You are already committed to someone else!", {})
			return
		end

		local choice = player:inputSeq(
			"Who is the person you'd like to share your blood with?",
			"I'd like",
			"to become one with my blood.",
			{},
			{}
		)

		if choice == "" then
			return
		end
		if choice == player.name then
			player:dialog("You can't make such a commitment to yourself.", {})
			return
		end

		local target = Player(choice)

		if target == nil then
			player:dialog("Player is not valid or not online.", {})
			return
		end

		local found = false

		for i = 1, #pcs do
			if pcs[i].ID == target.ID then
				found = true
			end
		end

		if found == false then
			player:popUp("Your prospective blood brother/sister must be near you when you make this commitment.")
			return
		end

		if target:hasLegend("engaged") or target:hasLegend("married") or target:hasLegend("forged_blood_oath") or target:hasLegend("sealed_blood_oath") or target.partner ~= 0 then
			player:dialog(
				target.name .. " is already committed to someone else!",
				{}
			)
			return
		end

		target:freeAsync()
		target.registry["proposer"] = player.ID
		blood_oath.prompt(target)
	end),

	prompt = async(function(target)
		local proposer = Player(target.registry["proposer"])

		local accept = target:menuSeq(
			proposer.name .. " swears a blood oath to you. Do you accept?  If you do, you may feel a small prick while I withdraw some blood required for the ritual",
			{"Yes! I want this.", "No, I must decline."},
			{"close"}
		)

		if accept == 1 then
			if target.state == 1 or proposer.state == 1 then
				return
			end

			target.attacker = target.ID
			proposer.attacker = proposer.ID

			target:removeHealthExtend(
				math.ceil(target.health * 0.1),
				0,
				0,
				0,
				0,
				0
			)
			proposer:removeHealthExtend(
				math.ceil(proposer.health * 0.1),
				0,
				0,
				0,
				0,
				0
			)

			target:addLegend(
				"Forged blood oath with $player (" .. curT() .. ")",
				"forged_blood_oath",
				51,
				1,
				proposer.ID
			)
			proposer:addLegend(
				"Forged blood oath with $player (" .. curT() .. ")",
				"forged_blood_oath",
				51,
				1,
				target.ID
			)
			proposer:removeSpell("blood_oath")
			target.registry["proposer"] = 0

			target.registry["partner1"] = proposer.ID
			target.registry["partner2"] = target.ID

			proposer.registry["partner1"] = proposer.ID
			proposer.registry["partner2"] = target.ID

			target.registry["seal_blood_oath_timer"] = os.time() + 259200

			-- 3 days
			proposer.registry["seal_blood_oath_timer"] = os.time() + 259200

			-- 3 days

			proposer:removeSpell("blood_oath")
			proposer:dialog(target.name .. " accepts!", {})
		elseif accept == 2 then
			target.registry["proposer"] = 0
			proposer:dialog(target.name .. " regretably must decline.", {})

			return
		end
	end),

	requirements = function(player)
		local level = 5
		local items = {}
		local itemAmounts = {}
		local desc = "This spell can be used to propose to someone you love."
		return level, items, itemAmounts, desc
	end
}
