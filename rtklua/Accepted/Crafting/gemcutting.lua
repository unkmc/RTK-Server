gemcutting = {
	craft = function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if speech == "gem" then
			-- 100 ambers used. 37 tarnished, 14 crafted, 6 well crafted

			local ambertypes = {
				"amber",
				"dark_amber",
				"white_amber",
				"yellow_amber"
			}
			local skill = crafting.getSkillLevel(player, "gemcutting")
			local opts = {}
			table.insert(opts, "Amber")
			if (skill == "adept" or skill == "talented" or skill == "skilled" or skill == "expert" or skill == "master" or skill == "grandmaster" or skill == "champion" or skill == "legendary") then
				table.insert(opts, "Dark Amber")
			end
			if (skill == "adept" or skill == "talented" or skill == "skilled" or skill == "expert" or skill == "master" or skill == "grandmaster" or skill == "champion" or skill == "legendary") then
				table.insert(opts, "White Amber")
			end
			if (skill == "skilled" or skill == "expert" or skill == "master" or skill == "grandmaster" or skill == "champion" or skill == "legendary") then
				table.insert(opts, "Yellow Amber")
			end

			local choice = 1
			if #opts > 1 then
				choice = player:menuSeq(
					"Which gem would you like to attempt?",
					opts,
					{}
				)
			end

			local amber = ambertypes[choice]
			local ta = {graphic = Item(amber).icon, color = Item(amber).iconC}
			if player:hasItem(amber, 1) ~= true then
				player:dialogSeq({ta, "You have nothing to craft."}, 0)
				return
			end

			player:removeItem(amber, 1, 9)
			crafting.skillChanceIncrease(player, NPC("Sel"), "gemcutting")

			if (amber == "amber") then
				gemcutting.amber(player)
			elseif (amber == "dark_amber") then
				gemcutting.darkamber(player)
			elseif (amber == "white_amber") then
				gemcutting.whiteamber(player)
			elseif (amber == "yellow_amber") then
				gemcutting.yellowamber(player)
			end
			return
		end
	end,
	amber = function(player)
		local skill = crafting.getSkillLevel(player, "gemcutting")
		if skill == "novice" then
			local rand = math.random(1, 100)
			if (rand <= 5) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 5 and rand < 15) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 15 and rand < 90) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "apprentice" then
			local rand = math.random(1, 100)
			if (rand <= 5) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 5 and rand < 20) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 20 and rand < 90) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "accomplished" then
			local rand = math.random(1, 100)
			if (rand <= 5) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 5 and rand < 25) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 25 and rand < 90) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "adept" then
			local rand = math.random(1, 100)
			if (rand <= 5) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 5 and rand < 30) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 30) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "talented" then
			local rand = math.random(1, 100)
			if (rand <= 5) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 5 and rand < 35) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 35) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "skilled" then
			local rand = math.random(1, 100)
			if (rand <= 10) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 40) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 40) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "expert" then
			local rand = math.random(1, 100)
			if (rand <= 10) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 45) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 45) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "master" then
			local rand = math.random(1, 100)
			if (rand <= 10) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 50) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 50) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "grandmaster" then
			local rand = math.random(1, 100)
			if (rand <= 13) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 60) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 60) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "champion" then
			local rand = math.random(1, 100)
			if (rand <= 16) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 65) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 65) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "legendary" then
			local rand = math.random(1, 100)
			if (rand <= 20) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 70) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 70) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		else
			local rand = math.random(1, 100)
			if (rand == 1) then
				player:addItem("well_crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_amber").icon,
							color = Item("well_crafted_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 1 and rand < 20) then
				player:addItem("crafted_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_amber").icon,
							color = Item("crafted_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 20 and rand < 90) then
				player:addItem("tarnished_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_amber").icon,
							color = Item("tarnished_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		end
	end,

	darkamber = function(player)
		local skill = crafting.getSkillLevel(player, "gemcutting")
		if skill == "adept" then
			local rand = math.random(1, 100)
			if (rand <= 5) then
				player:addItem("well_crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_dark_amber").icon,
							color = Item("well_crafted_dark_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 5 and rand < 15) then
				player:addItem("crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_dark_amber").icon,
							color = Item("crafted_dark_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 15 and rand < 90) then
				player:addItem("tarnished_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_dark_amber").icon,
							color = Item("tarnished_dark_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "talented" then
			local rand = math.random(1, 100)
			if (rand <= 5) then
				player:addItem("well_crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_dark_amber").icon,
							color = Item("well_crafted_dark_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 5 and rand < 20) then
				player:addItem("crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_dark_amber").icon,
							color = Item("crafted_dark_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 20) then
				player:addItem("tarnished_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_dark_amber").icon,
							color = Item("tarnished_dark_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "skilled" then
			local rand = math.random(1, 100)
			if (rand <= 10) then
				player:addItem("well_crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_dark_amber").icon,
							color = Item("well_crafted_dark_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 25) then
				player:addItem("crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_dark_amber").icon,
							color = Item("crafted_dark_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 25) then
				player:addItem("tarnished_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_dark_amber").icon,
							color = Item("tarnished_dark_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "expert" then
			local rand = math.random(1, 100)
			if (rand <= 10) then
				player:addItem("well_crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_dark_amber").icon,
							color = Item("well_crafted_dark_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 30) then
				player:addItem("crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_dark_amber").icon,
							color = Item("crafted_dark_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 30) then
				player:addItem("tarnished_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_dark_amber").icon,
							color = Item("tarnished_dark_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "master" then
			local rand = math.random(1, 100)
			if (rand <= 10) then
				player:addItem("well_crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_dark_amber").icon,
							color = Item("well_crafted_dark_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 35) then
				player:addItem("crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_dark_amber").icon,
							color = Item("crafted_dark_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 35) then
				player:addItem("tarnished_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_dark_amber").icon,
							color = Item("tarnished_dark_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "grandmaster" then
			local rand = math.random(1, 100)
			if (rand <= 12) then
				player:addItem("well_crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_dark_amber").icon,
							color = Item("well_crafted_dark_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 40) then
				player:addItem("crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_dark_amber").icon,
							color = Item("crafted_dark_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 40) then
				player:addItem("tarnished_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_dark_amber").icon,
							color = Item("tarnished_dark_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "champion" then
			local rand = math.random(1, 100)
			if (rand <= 14) then
				player:addItem("well_crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_dark_amber").icon,
							color = Item("well_crafted_dark_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 45) then
				player:addItem("crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_dark_amber").icon,
							color = Item("crafted_dark_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 45) then
				player:addItem("tarnished_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_dark_amber").icon,
							color = Item("tarnished_dark_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "legendary" then
			local rand = math.random(1, 100)
			if (rand <= 16) then
				player:addItem("well_crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_dark_amber").icon,
							color = Item("well_crafted_dark_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 50) then
				player:addItem("crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_dark_amber").icon,
							color = Item("crafted_dark_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 50) then
				player:addItem("tarnished_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_dark_amber").icon,
							color = Item("tarnished_dark_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		else
			local rand = math.random(1, 100)
			if (rand == 1) then
				player:addItem("well_crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_dark_amber").icon,
							color = Item("well_crafted_dark_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 1 and rand < 20) then
				player:addItem("crafted_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_dark_amber").icon,
							color = Item("crafted_dark_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 20 and rand < 90) then
				player:addItem("tarnished_dark_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_dark_amber").icon,
							color = Item("tarnished_dark_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		end
	end,

	whiteamber = function(player)
		local skill = crafting.getSkillLevel(player, "gemcutting")
		if skill == "adept" then
			local rand = math.random(1, 100)
			if (rand <= 1) then
				player:addItem("well_crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_white_amber").icon,
							color = Item("well_crafted_white_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 1 and rand < 15) then
				player:addItem("crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_white_amber").icon,
							color = Item("crafted_white_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 15 and rand < 90) then
				player:addItem("tarnished_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_white_amber").icon,
							color = Item("tarnished_white_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "talented" then
			local rand = math.random(1, 100)
			if (rand <= 2) then
				player:addItem("well_crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_white_amber").icon,
							color = Item("well_crafted_white_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 2 and rand < 20) then
				player:addItem("crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_white_amber").icon,
							color = Item("crafted_white_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 20 and rand < 90) then
				player:addItem("tarnished_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_white_amber").icon,
							color = Item("tarnished_white_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "skilled" then
			local rand = math.random(1, 100)
			if (rand <= 3) then
				player:addItem("well_crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_white_amber").icon,
							color = Item("well_crafted_white_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 3 and rand < 25) then
				player:addItem("crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_white_amber").icon,
							color = Item("crafted_white_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 25 and rand < 90) then
				player:addItem("tarnished_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_white_amber").icon,
							color = Item("tarnished_white_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "expert" then
			local rand = math.random(1, 100)
			if (rand <= 4) then
				player:addItem("well_crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_white_amber").icon,
							color = Item("well_crafted_white_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 4 and rand < 30) then
				player:addItem("crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_white_amber").icon,
							color = Item("crafted_white_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 30) then
				player:addItem("tarnished_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_white_amber").icon,
							color = Item("tarnished_white_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "master" then
			local rand = math.random(1, 100)
			if (rand <= 5) then
				player:addItem("well_crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_white_amber").icon,
							color = Item("well_crafted_white_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 5 and rand < 35) then
				player:addItem("crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_white_amber").icon,
							color = Item("crafted_white_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 35) then
				player:addItem("tarnished_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_white_amber").icon,
							color = Item("tarnished_white_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "grandmaster" then
			local rand = math.random(1, 100)
			if (rand <= 6) then
				player:addItem("well_crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_white_amber").icon,
							color = Item("well_crafted_white_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 6 and rand < 38) then
				player:addItem("crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_white_amber").icon,
							color = Item("crafted_white_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 38) then
				player:addItem("tarnished_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_white_amber").icon,
							color = Item("tarnished_white_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "champion" then
			local rand = math.random(1, 100)
			if (rand <= 7) then
				player:addItem("well_crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_white_amber").icon,
							color = Item("well_crafted_white_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 7 and rand < 41) then
				player:addItem("crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_white_amber").icon,
							color = Item("crafted_white_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 41) then
				player:addItem("tarnished_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_white_amber").icon,
							color = Item("tarnished_white_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "legendary" then
			local rand = math.random(1, 100)
			if (rand <= 8) then
				player:addItem("well_crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_white_amber").icon,
							color = Item("well_crafted_white_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 8 and rand < 45) then
				player:addItem("crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_white_amber").icon,
							color = Item("crafted_white_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 45) then
				player:addItem("tarnished_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_white_amber").icon,
							color = Item("tarnished_white_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		else
			local rand = math.random(1, 100)
			if (rand == 1) then
				player:addItem("well_crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_white_amber").icon,
							color = Item("well_crafted_white_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 1 and rand < 20) then
				player:addItem("crafted_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_white_amber").icon,
							color = Item("crafted_white_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 20 and rand < 90) then
				player:addItem("tarnished_white_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_white_amber").icon,
							color = Item("tarnished_white_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		end
	end,

	yellowamber = function(player)
		local skill = crafting.getSkillLevel(player, "gemcutting")
		if skill == "skilled" then
			local rand = math.random(1, 100)
			if (rand <= 10) then
				player:addItem("well_crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_yellow_amber").icon,
							color = Item("well_crafted_yellow_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 30) then
				player:addItem("crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_yellow_amber").icon,
							color = Item("crafted_yellow_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 30) then
				player:addItem("tarnished_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_yellow_amber").icon,
							color = Item("tarnished_yellow_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "expert" then
			local rand = math.random(1, 100)
			if (rand <= 10) then
				player:addItem("well_crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_yellow_amber").icon,
							color = Item("well_crafted_yellow_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 40) then
				player:addItem("crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_yellow_amber").icon,
							color = Item("crafted_yellow_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 40) then
				player:addItem("tarnished_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_yellow_amber").icon,
							color = Item("tarnished_yellow_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "master" then
			local rand = math.random(1, 100)
			if (rand <= 10) then
				player:addItem("well_crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_yellow_amber").icon,
							color = Item("well_crafted_yellow_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 50) then
				player:addItem("crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_yellow_amber").icon,
							color = Item("crafted_yellow_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 50) then
				player:addItem("tarnished_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_yellow_amber").icon,
							color = Item("tarnished_yellow_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "grandmaster" then
			local rand = math.random(1, 100)
			if (rand <= 12) then
				player:addItem("well_crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_yellow_amber").icon,
							color = Item("well_crafted_yellow_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 12 and rand < 55) then
				player:addItem("crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_yellow_amber").icon,
							color = Item("crafted_yellow_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 55) then
				player:addItem("tarnished_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_yellow_amber").icon,
							color = Item("tarnished_yellow_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "champion" then
			local rand = math.random(1, 100)
			if (rand <= 14) then
				player:addItem("well_crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_yellow_amber").icon,
							color = Item("well_crafted_yellow_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 14 and rand < 60) then
				player:addItem("crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_yellow_amber").icon,
							color = Item("crafted_yellow_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 60) then
				player:addItem("tarnished_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_yellow_amber").icon,
							color = Item("tarnished_yellow_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		elseif skill == "legendary" then
			local rand = math.random(1, 100)
			if (rand <= 16) then
				player:addItem("well_crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_yellow_amber").icon,
							color = Item("well_crafted_yellow_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 16 and rand < 65) then
				player:addItem("crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_yellow_amber").icon,
							color = Item("crafted_yellow_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 65) then
				player:addItem("tarnished_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_yellow_amber").icon,
							color = Item("tarnished_yellow_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		else
			local rand = math.random(1, 100)
			if (rand == 10) then
				player:addItem("well_crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("well_crafted_yellow_amber").icon,
							color = Item("well_crafted_yellow_amber").iconC
						},
						"You have succeeded masterfully!"
					},
					0
				)
			elseif (rand > 10 and rand < 30) then
				player:addItem("crafted_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("crafted_yellow_amber").icon,
							color = Item("crafted_yellow_amber").iconC
						},
						"Your efforts are successful!"
					},
					0
				)
			elseif (rand >= 30) then
				player:addItem("tarnished_yellow_amber", 1)
				player:dialogSeq(
					{
						{
							graphic = Item("tarnished_yellow_amber").icon,
							color = Item("tarnished_yellow_amber").iconC
						},
						"You have failed in your attempt."
					},
					0
				)
			else
				player:dialogSeq(
					{
						{
							graphic = Item("amber").icon,
							color = Item("amber").iconC
						},
						"Your feeble efforts have destroyed that which you meant to enhance."
					},
					0
				)
			end
		end
	end,
}
