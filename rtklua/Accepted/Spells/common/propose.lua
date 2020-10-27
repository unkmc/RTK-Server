propose = {
	cast = async(function(player)
		if player:hasLegend("engaged") or player:hasLegend("married") then
			player:removeSpell("propose")
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		player:setDuration("propose", 1200000)
		player.setAether("propose", 1200000)

		local pcs = player:getObjectsInArea(BL_PC)

		local item = Item("engagement_ring")
		player.npcGraphic = item.icon
		player.npcColor = 0

		if player:hasLegend("engaged") or player:hasLegend("married") or player:hasLegend("forged_blood_oath") or player:hasLegend("sealed_blood_oath") or player.partner ~= 0 then
			player:dialog("You are already committed to someone else!", {})
			return
		end

		local choice = player:inputSeq(
			"What is the name of your beloved?",
			"The Wonderful",
			"has captured my heart",
			{},
			{}
		)

		if choice == "" then
			return
		end
		if choice == player.name then
			player:dialog("You can't marry yourself.", {})
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
			player:popUp("Your beloved must be near you when you make this commitment.")
			return
		end

		if target:hasLegend("engaged") or target:hasLegend("married") or target:hasLegend("forged_blood_oath") or target:hasLegend("sealed_blood_oath") or target.partner ~= 0 then
			player:dialog(
				target.name .. " is already committed to someone else!",
				{}
			)
			return
		end

		if target:hasItem("engagement_ring", 1) ~= true and not target:hasEquipped("engagement_ring") then
			player:dialog("You have not given them an engagement ring yet.", {})
			return
		end

		target:freeAsync()
		target.registry["proposer"] = player.ID
		propose.prompt(target)
	end),

	prompt = async(function(target)
		local proposer = Player(target.registry["proposer"])
		local accept = target:menuSeq(
			proposer.name .. " proposes marriage. Do you accept?",
			{"Yes! I am madly in love.", "I must decline."},
			{"close"}
		)

		if accept == 1 then
			target:addLegend(
				"Engaged to $player (" .. curT() .. ")",
				"engaged",
				6,
				1,
				proposer.ID
			)
			proposer:addLegend(
				"Engaged to $player (" .. curT() .. ")",
				"engaged",
				6,
				1,
				target.ID
			)
			proposer:removeSpell("propose")
			target:removeItem("engagement_ring", 1)

			target.registry["partner1"] = proposer.ID
			target.registry["partner2"] = target.ID

			proposer.registry["partner1"] = proposer.ID
			proposer.registry["partner2"] = target.ID

			target.registry["marriage_timer"] = os.time() + 259200

			-- 3 days
			proposer.registry["marriage_timer"] = os.time() + 259200

			-- 3 days

			proposer:removeSpell("propose")
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
