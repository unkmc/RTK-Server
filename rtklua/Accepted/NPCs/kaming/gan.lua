GanNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local options = {"Buy", "Sell"}

		local choice = player:menuString(
			"Hello! How can I help you today?",
			options
		)

		if choice == "Buy" then
			GanNpc.buy(player, npc)
		elseif choice == "Sell" then
			GanNpc.sell(player, npc)
		end
	end),

	buy = function(player, npc)
		local items = GanNpc.buyItems()
		player:buyExtend(
			"I think I can accomodate some of the things you need. What would you like?",
			items
		)
	end,

	sell = function(player, npc)
		local items = GanNpc.sellItems()
		player:sellExtend("What are you willing to sell today?", items)
	end,

	buyItems = function()
		local buyItems = {"short_bow", "long_spear"}
		return buyItems
	end,

	sellItems = function()
		local sellItems = {
			"short_bow",
			"long_spear",
			"iron_sword",
			"fox_blade",
			"viper_stick",
			"giasomo_stick",
		}

		if (Config.bossDropSalesEnabled) then
			table.insert(sellItems, "hoof_sabre")
			table.insert(sellItems, "might_spear")
			table.insert(sellItems, "military_fork")
			table.insert(sellItems, "jolt_trident")
			table.insert(sellItems, "maxcaliber")
			table.insert(sellItems, "moonblade")
			table.insert(sellItems, "deaths_head")
			table.insert(sellItems, "wicked_staff")
			table.insert(sellItems, "electra")
			table.insert(sellItems, "steelthorn")
			table.insert(sellItems, "titanium_lance")
			table.insert(sellItems, "star_staff")
			table.insert(sellItems, "bekyuns_spear")
			table.insert(sellItems, "hunangs_axe")
			table.insert(sellItems, "spike")
			table.insert(sellItems, "blood")
			table.insert(sellItems, "charm")
			table.insert(sellItems, "surge")
			table.insert(sellItems, "mythic_sabre")
			table.insert(sellItems, "light_sword")
			table.insert(sellItems, "dark_dagger")
		end

		return sellItems
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

		if speech == "pick up armor" then
			Tools.checkKarma(player)

			if player.quest["wind_armor"] == 0 or player.quest["frost_sabre_for_seal"] ~= 2 then
				player:dialogSeq(
					{
						t,
						"Uhh... I really have no idea what you are talking about."
					},
					0
				)
				return
			end

			if player.quest["gan_metal"] == 0 then
				player.quest["gan_metal"] = 1

				player:dialogSeq(
					{
						t,
						"You're here to pick up KaMing's armor? Why would he send - and please forgive the phrase - a townie to pick it up?",
						"Ahhh... wait... I think I know. You are the only way he could get it without raising suspicion!",
						"Am I right? Huh? I know it! I may not be the sharpest blade, but I know how to slice the enemy's wrists.",
						"Well, yeah, the armor is almost ready to be picked up, but I need a few more things.",
						"The first thing I need is 4 of the best metal in the land, go get that for me and come back quickly."
					},
					0
				)
				return
			elseif player.quest["gan_metal"] == 1 then
				if player:hasItem("fine_metal", 4) ~= true then
					player:dialogSeq(
						{
							t,
							"I am still waiting on those 4 fine metal to finish repairing KaMing's armor."
						},
						0
					)
					return
				end

				player:removeItem("fine_metal", 4, 9)
				player.quest["gan_metal"] = 2
				player:dialogSeq(
					{
						t,
						"Thanks for the metal. That will fix this section of the armor. But I will still need a few more things.",
						"The magic in this armor is getting worn out, and it's healing nature is not as strong as it should be.",
						"Bring me something to replenish the energy in it.",
						"Make sure it has healing powers!"
					},
					0
				)
				return
			elseif player.quest["gan_metal"] == 2 then
				if player:hasItem("titanium_lance", 1) ~= true then
					player:dialogSeq(
						{
							t,
							"I still need the titanium lance for KaMing's armor."
						},
						0
					)
					return
				end

				player:removeItem("titanium_lance", 1)
				player.quest["gan_metal"] = 3
				player:dialogSeq(
					{
						t,
						"Ahhh.... this Titanium lance looks good. Has some great healing properties, and not to powerful that I can't work it into the armor.",
						"This will take a while to work into the armor.",
						"While I am working on this you will need to go to the Sonhi hideout in Kugnae, and get some leather straps.",
						"Go quickly, and get them. That should be the last thing I need."
					},
					0
				)
				return
			elseif player.quest["gan_metal"] == 3 then
				player:dialogSeq(
					{
						t,
						"Why are you still here? Get going... you do know where the Sonhi hideout is... don't you?",
						"OH! I know... sorry... I told you I could figure these things out eventually.",
						"You wouldn't get in the hideout, not as a townie. Don't you have a pass from KaMing?",
						"I guess you wouldn't need one just to pick up the Armor, you should go back and get one from KaMing.",
						"Oh... but I am sure if KaMing sent for the armor he needs it right away... but without a pass you would never get in.",
						"Tell you what... and keep this a secret, OK?",
						"KaMing left a seal here last time he visited me. I suppose I could stamp a pass for you",
						"Fine... just don't tell anybody I did this, just get back quickly.",
						"And DO NOT disappear on me like the last guy did!"
					},
					1
				)

				player.quest["gan_metal"] = 4
				player:addItem("sonhi_pass", 1)
				player:dialogSeq({t, "Go now, and be quick about it."}, 0)
				return
			elseif player.quest["gan_metal"] == 4 then
				player:dialogSeq(
					{
						t,
						"I gave you the pass. Get going to KaMing's encampment, I need those leather scraps for KaMing's armor."
					},
					0
				)
				return
			end
		end

		if speech == "desert" then
			player:dialogSeq(
				{
					t,
					"Ahhh, at times I do miss the desert.",
					"Life was hard in the desert, many inexperienced people die within the first few minutes when it gets really hot.",
					"My back still aches thinking of all the water skins we had to carry."
				},
				0
			)
		end

		if speech == "water skin" then
			player:dialogSeq(
				{
					t,
					"Oh no, I don't have any left. Gosh that was a long time ago.",
					"You would have to find somebody use to dealing with skins and cloths to help you with that."
				},
				0
			)
		end
	end)
}
