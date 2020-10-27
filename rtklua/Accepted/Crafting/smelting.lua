smelting = {
	craft = function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if speech == "smelt" then
			local ore = {graphic = convertGraphic(721, "item"), color = 0}
			local metal = {graphic = convertGraphic(291, "item"), color = 0}
			player.npcGraphic = ore.graphic
			player.npcColor = ore.color

			if player:hasItem("smelting_agreement", 1) ~= true then
				local smeltingagreement = {
					graphic = convertGraphic(282, "item"),
					color = 25
				}
				player:dialogSeq(
					{
						smeltingagreement,
						"Not so fast, my friend! Smelting's pretty dangerous you know, I'll let you use my equipment butt first you'll need a smelting agreement to show you understand the dangers."
					},
					0
				)
				return
			end

			local opts = {
				"Ore [poor]",
				"Ore [med]",
				"Ore [high]",
				"Ore [very high]",
				"Spent metal"
			}

			--ore poor choice. 1 ore poor, 1 slag. You have failed in your attempt.
			-- Your efforts are successful. choice 1 yielded 1 metal.
			-- if no mats: You have nothing to craft.

			-- ore med choice. 1 ore med, 1 slag. You have failed in your attempt.

			local matsReq = {
				"ore_poor",
				"ore_med",
				"ore_high",
				"ore_very_high",
				"spent_metal"
			}
			local matsAmts = {1, 1, 1, 1, 4, 1, 1}

			--player:talk(0,""..crafting.getSkillValue(player, "smelting"))

			if crafting.checkSkillLevel(player, "smelting", "adept") then
				table.insert(opts, "Silver ore")
				table.insert(matsReq, "silver_ore")
			end

			if crafting.checkSkillLevel(player, "smelting", "skilled") then
				table.insert(opts, "Gold ore")
				table.insert(matsReq, "gold_ore")
			end

			local choice = player:menuString("What are you smelting?", opts)

			local rand = math.random(1, 100)
			local metal_type = math.random(1, 5)

			if (choice == "Ore [poor]") then
				if player:hasItem("ore_poor", 1) ~= true then
					player:dialogSeq({ore, "You have nothing to craft."}, 0)
					return
				end
				crafting.skillChanceIncrease(player, NPC("Gruff"), "smelting")

				player:removeItem("ore_poor", 1)
				if (rand < 10 + (crafting.getSkillValue(player, "smelting") * 2)) then
					if (metal_type == 1) then
						player:addItem("fine_metal", 1)
						player:dialogSeq(
							{metal, "You succeeded masterfully!"},
							0
						)
					else
						player:addItem("metal", 1)
						player:dialogSeq(
							{metal, "Your efforts were successful!"},
							0
						)
					end
				else
					player:addItem("slag", 1)
					player:dialogSeq(
						{ore, "You have failed in your attempt."},
						0
					)
				end
			elseif (choice == "Ore [med]") then
				if player:hasItem("ore_med", 1) ~= true then
					player:dialogSeq({ore, "You have nothing to craft."}, 0)
					return
				end
				crafting.skillChanceIncrease(player, NPC("Gruff"), "smelting")

				player:removeItem("ore_med", 1)
				if (rand < 35 + (crafting.getSkillValue(player, "smelting") * 2)) then
					if (metal_type == 1) then
						player:addItem("fine_metal", 1)
						player:dialogSeq(
							{metal, "You succeeded masterfully!"},
							0
						)
					else
						player:addItem("metal", 1)
						player:dialogSeq(
							{metal, "Your efforts were successful!"},
							0
						)
					end
				else
					player:addItem("slag", 1)
					player:dialogSeq(
						{ore, "You have failed in your attempt."},
						0
					)
				end
			elseif (choice == "Ore [high]") then
				if player:hasItem("ore_high", 1) ~= true then
					player:dialogSeq({ore, "You have nothing to craft."}, 0)
					return
				end
				crafting.skillChanceIncrease(player, NPC("Gruff"), "smelting")

				player:removeItem("ore_high", 1)

				if (rand < 60 + (crafting.getSkillValue(player, "smelting") * 2)) then
					if (metal_type == 1) then
						player:addItem("fine_metal", 1)
						player:dialogSeq(
							{metal, "You succeeded masterfully!"},
							0
						)
					else
						player:addItem("metal", 1)
						player:dialogSeq(
							{metal, "Your efforts were successful!"},
							0
						)
					end
				else
					player:addItem("slag", 1)
					player:dialogSeq(
						{ore, "You have failed in your attempt."},
						0
					)
				end
			elseif (choice == "Ore [very high]") then
				if player:hasItem("ore_very_high", 1) ~= true then
					player:dialogSeq({ore, "You have nothing to craft."}, 0)
					return
				end
				crafting.skillChanceIncrease(player, NPC("Gruff"), "smelting")

				player:removeItem("ore_very_high", 1)

				if (metal_type == 1) then
					player:addItem("fine_metal", 1)
					player:dialogSeq({metal, "You succeeded masterfully!"}, 0)
				else
					player:addItem("metal", 1)
					player:dialogSeq(
						{metal, "Your efforts were successful!"},
						0
					)
				end
			elseif choice == "Spent metal" then
				if player:hasItem("spent_metal", 4) ~= true then
					player:dialogSeq({ore, "You have nothing to craft."}, 0)
					return
				end
				crafting.skillChanceIncrease(player, NPC("Gruff"), "smelting")

				player:removeItem("spent_metal", 4)

				if (rand < 60 + (crafting.getSkillValue(player, "smelting") * 2)) then
					if math.random(1, 5) == 1 then
						-- proc 2
						player:addItem("metal", 2)
						player:dialogSeq(
							{metal, "You succeeded masterfully!"},
							0
						)
					else
						player:addItem("metal", 1)
						player:dialogSeq(
							{metal, "Your efforts were successful!"},
							0
						)
					end
				else
					player:dialogSeq(
						{
							ore,
							"Your feeble efforts have destroyed that which you meant to enhance."
						},
						0
					)
				end
			elseif choice == "Silver ore" then
				-- no skill increases when you smelt silver or gold ore
				if player:hasItem("silver_ore", 1) ~= true then
					player:dialogSeq(
						{ore, "You need (1) silver ore to smelt."},
						0
					)
					return
				end

				player:removeItem("silver_ore", 1)

				-- When you smelt 1 silver ore, you can receive 10 gold, 50 gold as more common options. Approximately 10% of the time you will get 200 gold.
				-- There is also no success/fail with these options.

				local roll = math.random(1, 10)

				if roll <= 6 then
					-- 60% chance for 10 gold
					player:addGold(10)
					player:sendMinitext("You have salvaged 10 gold.")
				elseif roll > 6 and roll <= 9 then
					-- 30% chance for 50 gold
					player:addGold(50)
					player:sendMinitext("You have salvaged 50 gold.")
				elseif roll == 10 then
					-- 10% chance to receive 200 gold
					player:addGold(200)
					player:sendMinitext("You have gained 200 gold!")
				end
			elseif choice == "Gold ore" then
				-- no skill increases when you smelt silver or gold ore
				if player:hasItem("gold_ore", 1) ~= true then
					player:dialogSeq(
						{ore, "You need (1) gold ore to smelt."},
						0
					)
					return
				end

				player:removeItem("gold_ore", 1)

				-- When you smelt 1 gold ore, you can receive 200 gold as the common option. Approximately 10% of the time you will get 5000 gold.
				-- There is also no success/fail with these options.

				local roll = math.random(1, 10)

				if roll <= 9 then
					-- 90% chance for 10 gold
					player:addGold(200)
					player:sendMinitext("You have salvaged 200 gold.")
				elseif roll == 10 then
					-- 10% chance to receive 200 gold
					player:addGold(5000)
					player:sendMinitext("You have gained 5000 gold!")
				end
			else
				player:dialogSeq({t, "Disabled."}, 0)
			end

			--[[
		local matsReq = {"ore_poor","ore_med","ore_high","ore_very_high","spent_metal"}
		local matsAmts = {1,1,1,1,4}

		if player:hasItem(matsReq[choice],matsAmts[choice]) ~= true then
			player:dialogSeq({ore,"You have nothing to craft."},0)
		return
		end

		local rewards = {"metal"}
		local testsmelt = crafting.getSkillValue(player,"smelting")
		if (choice ~= 4) then
			for i=1, math.ceil(3 / choice) do
				table.insert(rewards,"slag")
			end
		end
		table.insert(rewards, "fine_metal")

		local reward = crafting.retrieveCraftingLoot(player,"smelting",rewards)
		local dialog = crafting.retrieveCraftingDialog(reward.yname,"smelting")
		local smeltamt = math.random(1,math.ceil((choice + 1 )/ 2))

		player:removeItem(matsReq[choice],matsAmts[choice],9)
		player:addItem(reward.yname,smeltamt)
		crafting.skillChanceIncrease(player,npc,"smelting")
		player:dialogSeq({reward,dialog},0)
		]]
			--
		end
	end
}
