weaving = {
	craft = function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if speech == "weave" then
			if player:hasItem("weaving_tools", 1) ~= true and player:hasItem("fine_weaving_tools", 1) ~= true then
				player:dialogSeq(
					{t, "Without suitable tools, this is an impossible task."},
					0
				)
				return
			end

			if player:hasItem("wool", 1) ~= true then
				player:dialogSeq({t, "You have nothing to craft."}, 0)
				return
			end

			-- You completely mangled that bunch of wool. (failure msg)
			-- you will need some more wool to finish this cloth. (failure msg)
			-- You have succeeded masterfully (fine cloth)
			-- You have made some cloth! (regular cloth)
			-- 25 wool used. 6 cloth. 1 fine cloth.

			player:removeItem("wool", 1)
			crafting.skillChanceIncrease(player, NPC("Yon"), "weaving")
			local rand = math.random(1, 100)
			local weavelevel = crafting.getSkillLevel(player, "weaving")

			if weavelevel == "novice" then
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 3) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 3 and rand < 15) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You completely mangled that bunch of wool."
						},
						0
					)
				end

				if (rand >= 15 and rand < 80) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 80) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			elseif weavelevel == "apprentice" then
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 4) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 4 and rand < 15) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You completely mangled that bunch of wool."
						},
						0
					)
				end

				if (rand >= 15 and rand < 80) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 80) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			elseif weavelevel == "accomplished" then
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 3) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 3 and rand < 15) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You completely mangled that bunch of wool."
						},
						0
					)
				end

				if (rand >= 15 and rand < 75) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 75) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			elseif weavelevel == "adept" then
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 5) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 5 and rand < 15) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You completely mangled that bunch of wool."
						},
						0
					)
				end

				if (rand >= 15 and rand < 70) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 70) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			elseif weavelevel == "talented" then
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 5) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 5 and rand < 15) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You completely mangled that bunch of wool."
						},
						0
					)
				end

				if (rand >= 15 and rand < 65) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 65) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			elseif weavelevel == "skilled" then
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 5) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 5 and rand < 10) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You completely mangled that bunch of wool."
						},
						0
					)
				end

				if (rand >= 10 and rand < 60) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 60) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			elseif weavelevel == "expert" then
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 10) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 10 and rand < 15) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You completely mangled that bunch of wool."
						},
						0
					)
				end

				if (rand >= 15 and rand < 55) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 55) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			elseif weavelevel == "master" then
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 10) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 10 and rand < 50) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 50) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			elseif weavelevel == "grandmaster" then
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 8) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 10 and rand < 45) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 45) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			elseif weavelevel == "champion" then
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 6) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 10 and rand < 40) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 40) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			elseif weavelevel == "legendary" then
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 4) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 4 and rand < 35) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 35) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			else
				if (player:hasItem("fine_weaving_tools", 1) == true and rand < 10) then
					player:addItem("fine_cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("fine_cloth").icon,
								color = Item("fine_cloth").iconC
							},
							"You have succeeded masterfully!"
						},
						0
					)
				elseif (rand < 3) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end

				if (rand >= 3 and rand < 15) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You completely mangled that bunch of wool."
						},
						0
					)
				end

				if (rand >= 15 and rand < 80) then
					player:dialogSeq(
						{
							{
								graphic = Item("wool").icon,
								color = Item("wool").iconC
							},
							"You will need some more wool to finish this cloth."
						},
						0
					)
				end

				if (rand >= 80) then
					player:addItem("cloth", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("cloth").icon,
								color = Item("cloth").iconC
							},
							"You have made some cloth!"
						},
						0
					)
				end
			end

			--[[
		local items = { "cloth","cloth","fine_cloth" }
		if player:hasItem("fine_weaving_tools",1) == true then items[2] = "fine_cloth" end
		local reward = crafting.retrieveCraftingLoot(player,"weaving",items)
		local weaveskill = crafting.getSkillValue(player,"weaving")
		if math.random(1,(13 - weaveskill)) == 1 and reward.yname == "wool" then reward.yname = items[math.random(1,#items)] end
		local dialog = crafting.retrieveCraftingDialog(reward.yname,"weaving")
		if reward.yname ~= "wool" then player:addItem(reward.yname,1) end
		crafting.skillChanceIncrease(player,npc,"weaving")
		player:dialogSeq({reward,dialog},0)
		return
		]]
			--
		end
	end
}
