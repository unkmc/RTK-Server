jewelrymaking = {
	craft = function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if speech == "jewel" then
			local choices = {"Ring", "Bracelet", "Headgear"}
			local jewelskill = crafting.getSkillValue(player, "jewelry making")
			if jewelskill < 9 then
				table.remove(choices)
			end
			if jewelskill < 6 then
				table.remove(choices)
			end
			local choice = player:menuSeq(
				"What would you like to craft?",
				choices,
				{}
			)

			if (choice == 1) then
				jewelrymaking.ring(player, jewelskill, t)
			end
			if (choice == 2) then
				jewelrymaking.bracelet(player, jewelskill, t)
			end

			--[[
		local itmQualChances = {1,1,1,1,2,2,3}
		local gemQuals = {"Amber","Dark amber","Yellow amber","White amber"}
		local jewelTypes = {"Ring","Bracelet", "Headgear"}
		local ringTypes = {"amber","dark","yellow","white"}
		local totemRingTypes = {"chung_ryong","baekho","ju_jak","hyun_moo"}
		local helmTypes = {"circlet","circlet","casque"}
		local ringSizes = {"small_","medium_","large_"}
		local braceSizes = {"plain_","luxury_"}
		local matsReq = {"crafted_amber","crafted_dark_amber","crafted_yellow_amber","crafted_white_amber"}
		local matsNReq = {"Crafted ambers","Crafted dark ambers","Crafted yellow ambers","Crafted white ambers"}
		local matsAmt = {2, 4, 8}
		local cmatsReq = "crafted_amber"
		local cmatsAmt = 2
		local cmatsCost = 2
		local matsCost = {100, 5000, 10000}
		local jewelskill = crafting.getSkillValue(player,"jewelry making")
		local choices = jewelTypes
		local choice = 15
		local craftingItem = "ring"
		if jewelskill < 9 then table.remove(choices) end
		if jewelskill < 6 then table.remove(choices) end
		if #choices ~= 1 then
			local craftType = player:menuString("What are you crafting today?",choices)
			craftingItem = string.lower(craftType)
			for i = 1, #choices do
				if craftingItem == string.lower(jewelTypes[i]) then
					cmatsAmt = matsAmt[i]
					cmatsCost = matsCost[i]
					break
				end
			end

			choices = gemQuals
		else
			choices = gemQuals
		end
		choice = player:menuSeq("What would you like to craft?",choices,{})
		cmatsReq = matsReq[choice]
		local item1 = cmatsReq
		local item2 = "well_"..cmatsReq
		local itm1 = 0
		local itm2 = 0
		local payment = "fail"

		if player.money < cmatsCost then
			player:dialogSeq({titem,"You need "..cmatsCost.." coins to craft a "..craftingItem.."."},0)
			return
		end
		for i=1,cmatsAmt do
			if player:hasItem(item1,i) == true then itm1 = itm1 + 1 end
		end
		if itm1 == cmatsAmt then
			payment = item1
		else
			for i=1,cmatsAmt do
				if player:hasItem(item2,i) == true then itm2 = itm2 + 1 end
			end
			if itm2 == cmatsAmt then
				payment = item2
			end
		end

		if payment == "fail" then
			if itm1+itm2 > cmatsAmt then
				if itm1 > itm2 then itm1 = cmatsAmt - itm2 else itm2 = cmatsAmt - itm1 end
			end
			if itm1+itm2 == cmatsAmt then
				player:removeItem(item1,itm1,9)
				player:removeItem(item2,itm2,9)
				payment = item1
			else
				player:dialogSeq({titem,"You need "..cmatsAmt.." units of "..matsNReq[choice].." to craft a "..craftingItem.."."},0)
				return
			end
		else
			player:removeItem(payment,cmatsAmt,9)
		end
		player:removeGold(cmatsCost)
		local returns = {}
		if craftingItem:match("ring") then
			for i = 1, #ringSizes do
				if math.random(1,50) == 1 and os.time() > player.registry["totem_crafted"] then
					table.insert(returns, ringSizes[i]..totemRingTypes[math.random(1,4)].."_"..craftingItem)
				else
					table.insert(returns, ringSizes[i]..ringTypes[choice].."_"..craftingItem)
				end
			end
			table.insert(returns, ringSizes[2]..ringTypes[choice].."_"..craftingItem)
		elseif craftingItem:match("bracelet") then
			for i = 1, #braceSizes do
				table.insert(returns, braceSizes[i]..ringTypes[choice].."_"..craftingItem)
			end
			table.insert(returns, braceSizes[1]..ringTypes[choice].."_"..craftingItem)
		elseif craftingItem:match("headgear") then
			for i = 1, #helmTypes do
				if math.random(1,50) == 1  and os.time() > player.registry["totem_crafted"] then
					table.insert(returns, totemRingTypes[math.random(1,4)].."_"..helmTypes[i])
				else
					table.insert(returns, ringTypes[choice].."_"..helmTypes[i])
				end
			end
			if math.random(1,111) == 1 and os.time() > player.registry["diadem_crafted"] then table.insert(returns, "diadem") end
		else
			return
		end
		local itemGive = crafting.retrieveCraftingLoot(player,"jewelry making",returns)
		for i = 1, #totemRingTypes do
			if itemGive.yname:match(totemRingTypes[i]) then
				player.registry["totem_crafted"] = os.time() + 259200
				if itemGive.yname:match("circlet") or itemGive.yname:match("casque") then
					player.registry["totem_helm_crafted"] = os.time() + 259200
				end
			end
		end
		if itemGive.yname == "diadem" then player.registry["diadem_crafted"] = os.time() + 259200 end

		local dialog = crafting.retrieveCraftingDialog(itemGive.yname,"jewelry making")

		if itemGive.yname == "failed" then
			itemGive.graphic = Item(payment).icon
			itemGive.color = Item(payment).iconC
		else
			crafting.skillChanceIncrease(player,npc,"jewelry making")
			player:addItem(itemGive.yname,1)
		end

		player:dialogSeq({itemGive,dialog},0)
		return
]]
			--
			--[[
		local roll = math.random(1,3)

		if roll == 1 then -- success
			local itemGive = ""

			local totemChance = math.random(1,15)

			if totemChance == 1 then
				itemGive = sizes[itemQualityChance].."_"..totemRingTypes[math.random(1,#totemRingTypes)]
			else
				itemGive = sizes[itemQualityChance].."_"..ringTypes[choice]
			end

			local titemGive = {graphic = Item(itemGive).icon, color = Item(itemGive).iconC}
			player:addItem(itemGive,1)
			crafting.skillChanceIncrease(player,npc,"jewelry making")

			if totemChance == 1 then
				player:dialogSeq({titemGive,"The totems have blessed your work!"},0)
			return
			end

			if itemQualityChance == 3 then
				player:dialogSeq({titemGive,"You have succeeded masterfully!"},0)
			else
				player:dialogSeq({titemGive,"You have managed to make a ring."},0)
			end

			return
		else
			player:dialogSeq({titem,"Your feeble efforts have destroyed that which you meant to enhance."},0) return
		end
		return]]
		end
	end,

	ring = function(player, skill)
		local choices = {}
		local item = ""

		if player:hasItem("crafted_amber", 2) == true or player:hasItem("well_crafted_amber", 2) == true then
			table.insert(choices, "Amber")
		end
		if player:hasItem("crafted_dark_amber", 2) == true or player:hasItem("well_crafted_dark_amber", 2) == true then
			table.insert(choices, "Dark amber")
		end
		if player:hasItem("crafted_white_amber", 2) == true or player:hasItem("well_crafted_white_amber", 2) == true then
			table.insert(choices, "White amber")
		end
		if player:hasItem("crafted_yellow_amber", 2) == true or player:hasItem("well_crafted_yellow_amber", 2) == true then
			table.insert(choices, "Yellow amber")
		end

		local choice = player:menuSeq(
			"What would you like to craft?",
			choices,
			{}
		)

		-- amber ring
		if choices[choice] == "Amber" then
			if player.money >= 100 then
				player.money = player.money - 100
				player:sendStatus()
			else
				player:dialogSeq(
					{
						{graphic = Item(3).icon, color = Item(item).iconC},
						"You do not have enough gold for this."
					},
					0
				)
				return
			end

			if player:hasItem("crafted_amber", 2) == true then
				player:removeItem("crafted_amber", 2)
				item = "crafted_amber"
			elseif player:hasItem("well_crafted_amber", 2) == true then
				player:removeItem("well_crafted_amber", 2)
				item = "well_crafted_amber"
			end

			local rand = math.random(1, 100)

			crafting.skillChanceIncrease(player, NPC("Sel"), "jewelry making")
			crafting.skillChanceIncrease(player, NPC("Sel"), "jewelry making")

			local totem = math.random(1, 100)
			if (totem == 1) then
				if (os.time() > player.registry["totemring"]) then
					player.registry["totemring"] = os.time() + 259200
					local picktotem = math.random(1, 4)
					local totems = {
						"hyun_moo",
						"ju_jak",
						"chung_ryong",
						"baekho"
					}
					if (rand <= 10) then
						player:addItem(
							"large_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("large_" .. totems[picktotem] .. "_ring").icon,
									color = Item("large_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					elseif (rand <= 25) then
						player:addItem(
							"medium_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("medium_" .. totems[picktotem] .. "_ring").icon,
									color = Item("medium_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					else
						player:addItem(
							"small_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("small_" .. totems[picktotem] .. "_ring").icon,
									color = Item("small_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					end
					return
				end
			end

			if item == "well_crafted_amber" then
				if (rand <= 2 * skill) then
					player:addItem("large_amber_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("large_amber_ring").icon,
								color = Item("large_amber_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 6 * skill) then
					player:addItem("medium_amber_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("medium_amber_ring").icon,
								color = Item("medium_amber_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 12 * skill) then
					player:addItem("small_amber_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("small_amber_ring").icon,
								color = Item("small_amber_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				else
					player:dialogSeq(
						{
							{
								graphic = Item(item).icon,
								color = Item(item).iconC
							},
							"Your feeble efforts have destroyed that which you meant to enhance."
						},
						0
					)
				end
			else
				if (rand <= 1 * skill) then
					player:addItem("large_amber_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("large_amber_ring").icon,
								color = Item("large_amber_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 3 * skill) then
					player:addItem("medium_amber_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("medium_amber_ring").icon,
								color = Item("medium_amber_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 6 * skill) then
					player:addItem("small_amber_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("small_amber_ring").icon,
								color = Item("small_amber_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				else
					player:dialogSeq(
						{
							{
								graphic = Item(item).icon,
								color = Item(item).iconC
							},
							"Your feeble efforts have destroyed that which you meant to enhance."
						},
						0
					)
				end
			end
		end

		-- dark amber ring
		if choices[choice] == "Dark amber" then
			if player.money >= 100 then
				player.money = player.money - 100
				player:sendStatus()
			else
				player:dialogSeq(
					{
						{graphic = Item(3).icon, color = Item(item).iconC},
						"You do not have enough gold for this."
					},
					0
				)
				return
			end

			if player:hasItem("crafted_dark_amber", 2) == true then
				player:removeItem("crafted_dark_amber", 2)
				item = "crafted_dark_amber"
			elseif player:hasItem("well_crafted_dark_amber", 2) == true then
				player:removeItem("well_crafted_dark_amber", 2)
				item = "well_crafted_dark_amber"
			end

			local rand = math.random(1, 100)

			crafting.skillChanceIncrease(player, NPC("Sel"), "jewelry making")
			crafting.skillChanceIncrease(player, NPC("Sel"), "jewelry making")

			local totem = math.random(1, 100)
			if (totem == 1) then
				if (os.time() > player.registry["totemring"]) then
					player.registry["totemring"] = os.time() + 259200
					local picktotem = math.random(1, 4)
					local totems = {
						"hyun_moo",
						"ju_jak",
						"chung_ryong",
						"baekho"
					}
					if (rand <= 10) then
						player:addItem(
							"large_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("large_" .. totems[picktotem] .. "_ring").icon,
									color = Item("large_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					elseif (rand <= 25) then
						player:addItem(
							"medium_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("medium_" .. totems[picktotem] .. "_ring").icon,
									color = Item("medium_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					else
						player:addItem(
							"small_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("small_" .. totems[picktotem] .. "_ring").icon,
									color = Item("small_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					end
					return
				end
			end

			if item == "well_crafted_dark_amber" then
				if (rand <= 2 * skill) then
					player:addItem("large_dark_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("large_dark_ring").icon,
								color = Item("large_dark_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 6 * skill) then
					player:addItem("medium_dark_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("medium_dark_ring").icon,
								color = Item("medium_dark_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 12 * skill) then
					player:addItem("small_dark_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("small_dark_ring").icon,
								color = Item("small_dark_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				else
					player:dialogSeq(
						{
							{
								graphic = Item(item).icon,
								color = Item(item).iconC
							},
							"Your feeble efforts have destroyed that which you meant to enhance."
						},
						0
					)
				end
			else
				if (rand <= 1 * skill) then
					player:addItem("large_dark_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("large_dark_ring").icon,
								color = Item("large_dark_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 3 * skill) then
					player:addItem("medium_dark_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("medium_dark_ring").icon,
								color = Item("medium_dark_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 6 * skill) then
					player:addItem("small_dark_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("small_dark_ring").icon,
								color = Item("small_dark_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				else
					player:dialogSeq(
						{
							{
								graphic = Item(item).icon,
								color = Item(item).iconC
							},
							"Your feeble efforts have destroyed that which you meant to enhance."
						},
						0
					)
				end
			end
		end

		-- white amber ring
		if choices[choice] == "White amber" then
			if player.money >= 100 then
				player.money = player.money - 100
				player:sendStatus()
			else
				player:dialogSeq(
					{
						{graphic = Item(3).icon, color = Item(item).iconC},
						"You do not have enough gold for this."
					},
					0
				)
				return
			end

			if player:hasItem("crafted_white_amber", 2) == true then
				player:removeItem("crafted_white_amber", 2)
				item = "crafted_white_amber"
			elseif player:hasItem("well_crafted_white_amber", 2) == true then
				player:removeItem("well_crafted_white_amber", 2)
				item = "well_crafted_white_amber"
			end

			local rand = math.random(1, 100)

			crafting.skillChanceIncrease(player, NPC("Sel"), "jewelry making")
			crafting.skillChanceIncrease(player, NPC("Sel"), "jewelry making")

			local totem = math.random(1, 100)
			if (totem == 1) then
				if (os.time() > player.registry["totemring"]) then
					player.registry["totemring"] = os.time() + 259200
					local picktotem = math.random(1, 4)
					local totems = {
						"hyun_moo",
						"ju_jak",
						"chung_ryong",
						"baekho"
					}
					if (rand <= 10) then
						player:addItem(
							"large_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("large_" .. totems[picktotem] .. "_ring").icon,
									color = Item("large_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					elseif (rand <= 25) then
						player:addItem(
							"medium_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("medium_" .. totems[picktotem] .. "_ring").icon,
									color = Item("medium_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					else
						player:addItem(
							"small_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("small_" .. totems[picktotem] .. "_ring").icon,
									color = Item("small_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					end
					return
				end
			end

			if item == "well_crafted_white_amber" then
				if (rand <= 2 * skill) then
					player:addItem("large_white_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("large_white_ring").icon,
								color = Item("large_white_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 6 * skill) then
					player:addItem("medium_white_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("medium_white_ring").icon,
								color = Item("medium_white_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 12 * skill) then
					player:addItem("small_white_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("small_white_ring").icon,
								color = Item("small_white_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				else
					player:dialogSeq(
						{
							{
								graphic = Item(item).icon,
								color = Item(item).iconC
							},
							"Your feeble efforts have destroyed that which you meant to enhance."
						},
						0
					)
				end
			else
				if (rand <= 1 * skill) then
					player:addItem("large_white_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("large_white_ring").icon,
								color = Item("large_white_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 3 * skill) then
					player:addItem("medium_white_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("medium_white_ring").icon,
								color = Item("medium_white_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 6 * skill) then
					player:addItem("small_white_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("small_white_ring").icon,
								color = Item("small_white_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				else
					player:dialogSeq(
						{
							{
								graphic = Item(item).icon,
								color = Item(item).iconC
							},
							"Your feeble efforts have destroyed that which you meant to enhance."
						},
						0
					)
				end
			end
		end

		-- yellow amber ring
		if choices[choice] == "Yellow amber" then
			if player.money >= 100 then
				player.money = player.money - 100
				player:sendStatus()
			else
				player:dialogSeq(
					{
						{graphic = Item(3).icon, color = Item(item).iconC},
						"You do not have enough gold for this."
					},
					0
				)
				return
			end

			if player:hasItem("crafted_yellow_amber", 2) == true then
				player:removeItem("crafted_yellow_amber", 2)
				item = "crafted_yellow_amber"
			elseif player:hasItem("well_crafted_yellow_amber", 2) == true then
				player:removeItem("well_crafted_yellow_amber", 2)
				item = "well_crafted_yellow_amber"
			end

			local rand = math.random(1, 100)

			crafting.skillChanceIncrease(player, NPC("Sel"), "jewelry making")
			crafting.skillChanceIncrease(player, NPC("Sel"), "jewelry making")

			local totem = math.random(1, 100)
			if (totem == 1) then
				if (os.time() > player.registry["totemring"]) then
					player.registry["totemring"] = os.time() + 259200
					local picktotem = math.random(1, 4)
					local totems = {
						"hyun_moo",
						"ju_jak",
						"chung_ryong",
						"baekho"
					}
					if (rand <= 10) then
						player:addItem(
							"large_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("large_" .. totems[picktotem] .. "_ring").icon,
									color = Item("large_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					elseif (rand <= 25) then
						player:addItem(
							"medium_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("medium_" .. totems[picktotem] .. "_ring").icon,
									color = Item("medium_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					else
						player:addItem(
							"small_" .. totems[picktotem] .. "_ring",
							1
						)
						player:dialogSeq(
							{
								{
									graphic = Item("small_" .. totems[picktotem] .. "_ring").icon,
									color = Item("small_" .. totems[picktotem] .. "_ring").iconC
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					end
					return
				end
			end

			if item == "well_crafted_yellow_amber" then
				if (rand <= 2 * skill) then
					player:addItem("large_yellow_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("large_yellow_ring").icon,
								color = Item("large_yellow_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 6 * skill) then
					player:addItem("medium_yellow_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("medium_yellow_ring").icon,
								color = Item("medium_yellow_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 12 * skill) then
					player:addItem("small_yellow_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("small_yellow_ring").icon,
								color = Item("small_yellow_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				else
					player:dialogSeq(
						{
							{
								graphic = Item(item).icon,
								color = Item(item).iconC
							},
							"Your feeble efforts have destroyed that which you meant to enhance."
						},
						0
					)
				end
			else
				if (rand <= 1 * skill) then
					player:addItem("large_yellow_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("large_yellow_ring").icon,
								color = Item("large_yellow_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 3 * skill) then
					player:addItem("medium_yellow_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("medium_yellow_ring").icon,
								color = Item("medium_yellow_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				elseif (rand <= 6 * skill) then
					player:addItem("small_yellow_ring", 1)
					player:dialogSeq(
						{
							{
								graphic = Item("small_yellow_ring").icon,
								color = Item("small_yellow_ring").iconC
							},
							"Your efforts were successful!"
						},
						0
					)
				else
					player:dialogSeq(
						{
							{
								graphic = Item(item).icon,
								color = Item(item).iconC
							},
							"Your feeble efforts have destroyed that which you meant to enhance."
						},
						0
					)
				end
			end
		end
	end
}
