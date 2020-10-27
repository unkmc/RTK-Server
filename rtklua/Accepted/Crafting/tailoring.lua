tailoring = {
	craft = function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if speech == "tailor" then
			local tcloth = {graphic = convertGraphic(1632, "item"), color = 0}
			player.npcGraphic = tcloth.graphic
			player.npcColor = tcloth.color
			local matsAmts = 0
			local matsReq = "cloth"
			local tailorskill = crafting.getSkillLevel(player, "tailoring")

			-- moved this requirement up higher in order to populate the list below
			local tailorval = 0
			local opts = {}
			local itemRange = 0
			local starChance = 0
			local starFail = 0
			local regFail = 0

			if tailorskill == "novice" then
				tailorval = 0
				itemRange = math.random(1, 2)
				regFail = 35
			end

			if tailorskill == "apprentice" then
				tailorval = 0
				itemRange = math.random(1, 3)
				regFail = 37.5
			end

			if tailorskill == "accomplished" then
				tailorval = 0
				itemRange = math.random(2, 4)
				regFail = 40
			end

			if tailorskill == "adept" then
				tailorval = 0
				itemRange = math.random(2, 5)
				regFail = 42.5
			end

			if tailorskill == "talented" then
				tailorval = 0
				itemRange = math.random(3, 5)
				regFail = 45
			end

			if tailorskill == "skilled" then
				tailorval = 0
				itemRange = math.random(3, 7)
				regFail = 50
			end

			if tailorskill == "expert" then
				tailorval = 0
				itemRange = math.random(3, 7)
				regFail = 60
			end

			if tailorskill == "master" then
				tailorval = 1
				itemRange = math.random(4, 7)
				regFail = 35
				starChance = math.random(1, 100)
				starFail = 70
			end
			if tailorskill == "grandmaster" then
				tailorval = 1
				itemRange = math.random(4, 7)
				regFail = 32
				starChance = math.random(1, 80)
				starFail = 70
			end
			if tailorskill == "champion" then
				tailorval = 1
				itemRange = math.random(5, 7)
				regFail = 29
				starChance = math.random(1, 70)
				starFail = 60
			end
			if tailorskill == "legendary" then
				tailorval = 1
				itemRange = math.random(5, 7)
				regFail = 25
				starChance = math.random(1, 50)
				starFail = 50
			end

			if tailorval ~= 1 then
				opts = {
					"Waistcoat",
					"Blouse",
					"Garb",
					"Clothes",
					"Dress",
					"Skirt",
					"Robes",
					"Mantle",
					"Gown",
					"Drapery"
				}
			end
			if tailorval == 1 then
				opts = {
					"Waistcoat",
					"Blouse",
					"Garb",
					"Clothes",
					"Dress",
					"Skirt",
					"Robes",
					"Mantle",
					"Gown",
					"Drapery",
					"Bandanna"
				}
			end

			local quality = {}
			local choice = player:menuSeq(
				"What type of clothing are you trying to tailor?",
				opts,
				{}
			)

			if choice == 1 then
				matsAmts = 2
				quality = {
					"novice",
					"farmer",
					"royal",
					"sky",
					"ancient",
					"blood",
					"earth"
				}
			elseif choice == 2 then
				matsAmts = 2
				quality = {
					"spring",
					"summer",
					"autumn",
					"winter",
					"leather",
					"ancient",
					"earth"
				}
			elseif choice == 3 then
				matsAmts = 3
				quality = {
					"spring",
					"summer",
					"royal",
					"sky",
					"leather",
					"blood",
					"earth"
				}
			elseif choice == 4 then
				matsAmts = 3
				quality = {
					"peasant",
					"farmer",
					"royal",
					"sky",
					"ancient",
					"family",
					"earth"
				}
			elseif choice == 5 then
				matsAmts = 2
				quality = {
					"spring",
					"summer",
					"autumn",
					"winter",
					"ancient",
					"leather",
					"earth"
				}
			elseif choice == 6 then
				matsAmts = 3
				quality = {
					"spring",
					"summer",
					"autumn",
					"winter",
					"leather",
					"heart",
					"earth"
				}
			elseif choice == 7 then
				matsAmts = 2
				quality = {
					"spring",
					"summer",
					"autumn",
					"winter",
					"ancient",
					"blood",
					"earth"
				}
			elseif choice == 8 then
				matsAmts = 3
				quality = {
					"spring",
					"summer",
					"autumn",
					"winter",
					"ancient",
					"blood",
					"earth"
				}
			elseif choice == 9 then
				matsAmts = 2
				quality = {
					"spring",
					"summer",
					"autumn",
					"winter",
					"leather",
					"ancient",
					"earth"
				}
			elseif choice == 10 then
				matsAmts = 3
				quality = {
					"spring",
					"summer",
					"autumn",
					"winter",
					"leather",
					"ancient",
					"earth"
				}

				-- bandanna choice addition
			elseif choice == 11 then
				matsAmts = 3
				quality = {
					"black",
					"purple",
					"white",
					"brown",
					"green",
					"pink",
					"teal",
					"navy",
					"darkpurple",
					"orange",
					"babyblue",
					"lava",
					"star"
				}
			end

			if player:hasItem("cloth", matsAmts) ~= true and player:hasItem("fine_cloth", matsAmts) ~= true then
				player:dialogSeq(
					{
						tcloth,
						"You need " .. matsAmts .. " bolts of cloth to tailor."
					},
					0
				)
				return
			end
			local clothtaken = "cloth"
			if player:hasItem("cloth", matsAmts) == true then
				player:removeItem("cloth", matsAmts, 9)
			elseif player:hasItem("fine_cloth", matsAmts) == true then
				clothtaken = "fine_cloth"
				player:removeItem("fine_cloth", matsAmts, 9)
			end

			for z = 1, matsAmts do
				crafting.skillChanceIncrease(player, NPC("Lin"), "tailoring")
			end

			local chosenItem = string.lower(opts[choice])

			local itemstable = {}

			for i = 1, #quality do
				table.insert(itemstable, quality[i] .. "_" .. chosenItem)
			end

			local rand = itemRange
			if choice == 11 then
				rand = math.random(1, 13)
			end
			local star = starChance
			if clothtaken == "fine_cloth" then
				if star == 1 then
					player:addItem("star_" .. chosenItem)
				else
					player:addItem(itemstable[rand], 1)
				end
				player:dialogSeq(
					{
						{
							graphic = Item(itemstable[rand]).icon,
							color = Item(itemstable[rand]).iconC
						},
						"You were successful."
					},
					0
				)
			else
				local fail = starChance
				if (fail >= starFail) then
					if star == 1 then
						player:addItem("star_" .. chosenItem)
					else
						player:addItem(itemstable[rand], 1)
					end
					player:dialogSeq(
						{
							{
								graphic = Item(itemstable[rand]).icon,
								color = Item(itemstable[rand]).iconC
							},
							"You were successful."
						},
						0
					)
				else
					player:dialogSeq(
						{
							{
								graphic = Item(clothtaken).icon,
								color = Item(clothtaken).iconC
							},
							"You failed your attempt."
						},
						0
					)
				end
			end
		else
			local rand = math.random(1, 2)
			if clothtaken == "fine_cloth" then
				player:addItem(itemstable[rand], 1)
				player:dialogSeq(
					{
						{
							graphic = Item(itemstable[rand]).icon,
							color = Item(itemstable[rand]).iconC
						},
						"You were successful."
					},
					0
				)
			else
				local fail = math.random(1, 100)
				if (fail >= regFail) then
					player:addItem(itemstable[rand], 1)
					player:dialogSeq(
						{
							{
								graphic = Item(itemstable[rand]).icon,
								color = Item(itemstable[rand]).iconC
							},
							"You were successful."
						},
						0
					)
				else
					player:dialogSeq(
						{
							{
								graphic = Item(clothtaken).icon,
								color = Item(clothtaken).iconC
							},
							"You failed your attempt."
						},
						0
					)
				end
			end
		end

		-- end SPEECH if
	end
}
