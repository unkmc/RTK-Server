CartographerNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}

		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Crafting Skills", "Cartography", "Shadow Stats"}

		local menu = player:menuString(
			"Hello! What would you like to do today?",
			opts
		)

		if menu == "Crafting Skills" then
			generalNPC.crafting_skills(player, npc)
		elseif menu == "Cartography" then
			CartographerNpc.cartographyQuest(player, npc)
		elseif menu == "Shadow Stats" then
			ExpSellerNpc.showShadowMainMenu(player, npc)
		end
	end),

	cartographyQuest = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		-- We shouldn't need this since we have it checking for the combined map
		--if crafting.checkSkillLegend(player,"cartography") then
		--	player:dialogSeq({t,"You have already learned the secrets of cartography."},0)
		--return
		--end

		if player:hasItem("combined_map", 1) == true then
			player:removeItem("combined_map", 1)
			player:addLegend(
				"Found the path to Mount Baekdu (" .. curT() .. ")",
				"mount_baekdu",
				3,
				128
			)
			crafting.skillChanceIncrease(
				player,
				npc,
				"cartography"
			)
		end

		player:dialogSeq(
			{
				t,
				"Welcome to holy Baekdu Mountain, I have been exploring this area for many years.",
				"This mountain has magical energy which will let you explore various locations around the lands.",
				"When you bring me 10 map fragments, I will help you combine them to find new locations.",
				"These magical locations will only be available to you and your group for a short amount of time.",
				"Some locations may seem familiar, but some may be new and challenging.",
				"You will be pushed to your limits, should you choose to venture, but the rewards may be great.",
				"As you level your cartography skill you will be able to unlock harder and deeper locations.",
				"These locations will be matched to your mark level, and can only be entered with a similar mark.",
				"You may see creatures from your past, but be cautious because they will be much more difficult.",
				"When you create a map, place it in the holy rock, and your group members will follow you inside from the mountain.",
				"(( Wisdom Star does not affect skill gains for this skill ))",
				"It is strongly recommended to venture with a group!"
			},
			0
		)

		--[[
	if player.quest["cartographyQuest"] == 0 then

		player.quest["cartographyQuest"] = 1

		player:dialogSeq({t,"Welcome to holy Mountain Baekdu. I see that you brought a map with you.",
			"This mountain has magical energy which will let you explore various locations around the lands.",
			"Bring me 10 map fragments and I will teach you how to find these locations.",
			"These magical locations will only be available to you and your group for a short amount of time.",
			"Some locations may seem familiar, but some may be new and challenging.",
			"You will be pushed to your limits, should you choose to venture, but the rewards may be great."},0)

		return
	elseif player.quest["cartographyQuest"] == 1 then

		if player:hasItem("combined_map",1) ~= true then
			player:dialogSeq({t,"I am missing the combined map"},0)
		return
		end

		player:removeItem("combined_map",1)
		crafting.addSkill(player,npc,"cartography")
	end
]]
		--
	end,

	cartographyDevotion = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if (player.level < 25) then
			player:dialogSeq(
				{
					t,
					"You are not ready to devote to a craft yet, come back later."
				},
				0
			)
			return
		end

		if crafting.checkSkillLegend(player, "cartography") then
			player:dialogSeq(
				{
					t,
					"You have already devoted yourself to the study of Cartography."
				},
				0
			)
			return
		end

		player:dialogSeq(
			{
				t,
				"Cartographers can craft maps with common, rare, legendary, and unique modifiers. Do you wish to become a cartographer?"
			},
			1
		)

		crafting.addSkill(player, npc, "cartography")
	end,

	onSayClick = async(function(player, npc, speech)
		local speech = string.lower(player.speech)
		if speech == "draw" or speech == "draw map" or speech == "combine" then
			crafting.craftingDialog(player, npc, speech)
		end
	end),

	buyItems = function()
		local buyItems = {}
		return buyItems
	end,

	sellItems = function()
		local sellItems = CartographerNpc.buyItems()
		return sellItems
	end
}
