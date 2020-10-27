ParkNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.baseClass ~= 2 then
			player:dialogSeq({t, "Sorry I cannot help your kind."}, 0)
			return
		end

		if not player:hasLegend("dagger_guild_member") then
			player:dialogSeq(
				{t, "You must finish your path's Nagnang quest."},
				0
			)
			return
		end

		player:dialogSeq(
			{
				t,
				"Thank the totems you're here! I hope you will drive out the evil army from here. Nagnag's evil henchmen captured me from my home, and forced me to work for them here.",
				"I have been enslaved by an evil spell which keeps me bound here. I can never escape. They have been forcing me to create special armor and weapons for them to use in a mission they are on,",
				"I want you to get revenge for me from Nagnag for what he has done to me, the only thing I can do to help is create the items for you that I made for his rogues."
			},
			1
		)

		local items = {}

		if player.level >= 11 then
			table.insert(items, "Battle amulet")
		end
		if player.level >= 39 then
			table.insert(items, "Battle rune")
		end
		if player.level >= 69 then
			table.insert(items, "Light buckler")
		end
		if player.level >= 97 then
			table.insert(items, "Basic buckler")
		end
		if player.level >= 99 and player.mark >= 1 then
			table.insert(items, "Heavy buckler")
		end
		if player.level >= 99 and player.mark >= 2 then
			table.insert(items, "Amber buckler")
		end
		if player.level >= 99 and player.mark >= 3 then
			table.insert(items, "Enchanted buckler")
		end
		if player.level >= 99 and player.mark >= 4 then
			table.insert(items, "Mystic buckler")
		end

		local choice = player:menuString(
			"What would you like me to help you make?",
			items
		)

		if choice == "Battle amulet" then
			player:dialogSeq(
				{
					t,
					"The Battle amulet is an amazing amulet, it's powerful.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Earth armor, 10 bear's livers, a herb pipe, and 1,000 gold."
				},
				1
			)

			if player:hasItem("earth_armor", 1) ~= true or player:hasItem("bears_liver", 10) ~= true or player:hasItem(
				"herb_pipe",
				1
			) ~= true or player.money < 1000 then
				player:dialogSeq(
					{t, "Please return to me when you have the required items."},
					0
				)
				return
			end

			local choice2 = player:menuSeq(
				"I see you have everything already, do you wish to make one now?",
				{"Yes", "No"},
				{}
			)

			if choice2 == 1 then
				-- yes

				if player:hasItem("earth_armor", 1) ~= true or player:hasItem("bears_liver", 10) ~= true or player:hasItem(
					"herb_pipe",
					1
				) ~= true or player.money < 1000 then
					player:dialogSeq(
						{
							t,
							"Please return to me when you have the required items."
						},
						0
					)
					return
				end

				player:removeItem("earth_armor", 1, 9)
				player:removeItem("bears_liver", 10, 9)
				player:removeItem("herb_pipe", 1, 9)
				player:removeGold(1000)

				player:addItem("battle_amulet", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Battle amulet. I hope it brings you luck in battle against Nagnag, and all evil!"
					},
					0
				)
			elseif choice2 == 2 then
				-- no
				player:dialogSeq(
					{t, "Please return to me if you change your mind."},
					0
				)
			end
		elseif choice == "Battle rune" then
			player:dialogSeq(
				{
					t,
					"The Battle rune is an amazing rune, it's powerful.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Moonblade, a Fine metal, and 4,000 gold."
				},
				1
			)

			if player:hasItem("moonblade", 1) ~= true or player:hasItem("fine_metal", 1) ~= true or player.money < 4000 then
				player:dialogSeq(
					{t, "Please return to me when you have the required items."},
					0
				)
				return
			end

			local choice2 = player:menuSeq(
				"I see you have everything already, do you wish to make one now?",
				{"Yes", "No"},
				{}
			)

			if choice2 == 1 then
				-- yes

				if player:hasItem("moonblade", 1) ~= true or player:hasItem("fine_metal", 1) ~= true or player.money < 4000 then
					player:dialogSeq(
						{
							t,
							"Please return to me when you have the required items."
						},
						0
					)
					return
				end

				player:removeItem("moonblade", 1, 9)
				player:removeItem("fine_metal", 1, 9)
				player:removeGold(4000)

				player:addItem("battle_rune", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Battle rune. I hope it brings you luck in battle against Nagnag, and all evil!"
					},
					0
				)
			elseif choice2 == 2 then
				-- no
				player:dialogSeq(
					{t, "Please return to me if you change your mind."},
					0
				)
			end
		elseif choice == "Light buckler" then
			player:dialogSeq(
				{
					t,
					"The Light buckler is an amazing buckler, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Whisper bracelet, a Scroll of defense, and 12,000 gold."
				},
				1
			)

			if player:hasItem("whisper_bracelet", 1) ~= true or player:hasItem(
				"scroll_of_defense",
				1
			) ~= true or player.money < 12000 then
				player:dialogSeq(
					{t, "Please return to me when you have the required items."},
					0
				)
				return
			end

			local choice2 = player:menuSeq(
				"I see you have everything already, do you wish to make one now?",
				{"Yes", "No"},
				{}
			)

			if choice2 == 1 then
				-- yes

				if player:hasItem("whisper_bracelet", 1) ~= true or player:hasItem(
					"scroll_of_defense",
					1
				) ~= true or player.money < 12000 then
					player:dialogSeq(
						{
							t,
							"Please return to me when you have the required items."
						},
						0
					)
					return
				end

				player:removeItem("whisper_bracelet", 1, 9)
				player:removeItem("scroll_of_defense", 1, 9)
				player:removeGold(12000)

				player:addItem("light_buckler", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Light buckler. I hope it brings you luck in battle against Nagnag, and all evil!"
					},
					0
				)
			elseif choice2 == 2 then
				-- no
				player:dialogSeq(
					{t, "Please return to me if you change your mind."},
					0
				)
			end
		elseif choice == "Basic buckler" then
			player:dialogSeq(
				{
					t,
					"The Basic buckler is an amazing buckler, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Scroll of Defense for a mold, a Blood to hold the power forged into it, and 24,000 gold."
				},
				1
			)

			if player:hasItem("blood", 1) ~= true or player:hasItem("scroll_of_defense", 1) ~= true or player.money < 24000 then
				player:dialogSeq(
					{t, "Please return when you have all the required items."},
					0
				)
				return
			end

			local choice2 = player:menuSeq(
				"I see you have everything already, do you wish to make one now?",
				{"Yes", "No"},
				{}
			)

			if choice2 == 1 then
				-- yes

				if player:hasItem("blood", 1) ~= true or player:hasItem("scroll_of_defense", 1) ~= true or player.money < 24000 then
					player:dialogSeq(
						{
							t,
							"Please return when you have all the required items."
						},
						0
					)
					return
				end

				player:removeItem("blood", 1, 9)
				player:removeItem("scroll_of_defense", 1, 9)
				player:removeGold(24000)

				player:addItem("basic_buckler", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Basic buckler. I hope it brings you luck in battle against Nagnag, and all evil!"
					},
					0
				)
			elseif choice2 == 2 then
				-- no
				player:dialogSeq(
					{t, "Please return to me if you change your mind."},
					0
				)
			end
		elseif choice == "Heavy buckler" then
			player:dialogSeq(
				{
					t,
					"The Heavy buckler is an amazing buckler, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Scroll of defense for a mold, a Il san Blood to hold the power forged into it, and 48,000 gold."
				},
				1
			)

			if player:hasItem("il_san_blood", 1) ~= true or player:hasItem(
				"scroll_of_defense",
				1
			) ~= true or player.money < 48000 then
				player:dialogSeq(
					{t, "Please return when you have all the required items."},
					0
				)
				return
			end

			local choice2 = player:menuSeq(
				"I see you have everything already, do you wish to make one now?",
				{"Yes", "No"},
				{}
			)

			if choice2 == 1 then
				-- yes

				if player:hasItem("il_san_blood", 1) ~= true or player:hasItem(
					"scroll_of_defense",
					1
				) ~= true or player.money < 48000 then
					player:dialogSeq(
						{
							t,
							"Please return when you have all the required items."
						},
						0
					)
					return
				end

				player:removeItem("il_san_blood", 1, 9)
				player:removeItem("scroll_of_defense", 1, 9)
				player:removeGold(48000)

				player:addItem("heavy_buckler", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Heavy buckler. I hope it brings you luck in battle against Nagnag, and all evil!"
					},
					0
				)
			elseif choice2 == 2 then
				-- no
				player:dialogSeq(
					{t, "Please return to me if you change your mind."},
					0
				)
			end
		elseif choice == "Amber buckler" then
			player:dialogSeq(
				{
					t,
					"The Amber buckler is an amazing buckler, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Scroll of defense for a mold, a EE san Blood to hold the power forged into it, and 96,000 gold."
				},
				1
			)

			if player:hasItem("ee_san_blood", 1) ~= true or player:hasItem(
				"scroll_of_defense",
				1
			) ~= true or player.money < 96000 then
				player:dialogSeq(
					{t, "Please return when you have all the required items."},
					0
				)
				return
			end

			local choice2 = player:menuSeq(
				"I see you have everything already, do you wish to make one now?",
				{"Yes", "No"},
				{}
			)

			if choice2 == 1 then
				-- yes

				if player:hasItem("ee_san_blood", 1) ~= true or player:hasItem(
					"scroll_of_defense",
					1
				) ~= true or player.money < 96000 then
					player:dialogSeq(
						{
							t,
							"Please return when you have all the required items."
						},
						0
					)
					return
				end

				player:removeItem("ee_san_blood", 1, 9)
				player:removeItem("scroll_of_defense", 1, 9)
				player:removeGold(96000)

				player:addItem("amber_buckler", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Amber buckler. I hope it brings you luck in battle against Nagnag, and all evil!"
					},
					0
				)
			elseif choice2 == 2 then
				-- no
				player:dialogSeq(
					{t, "Please return to me if you change your mind."},
					0
				)
			end
		elseif choice == "Enchanted buckler" then
			player:dialogSeq(
				{
					t,
					"The Enchanted buckler is an amazing buckler, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Scroll of defense for a mold, a Sam san Blood to hold the power forged into it, and 192,000 gold."
				},
				1
			)

			if player:hasItem("sam_san_blood", 1) ~= true or player:hasItem(
				"scroll_of_defense",
				1
			) ~= true or player.money < 192000 then
				player:dialogSeq(
					{t, "Please return when you have all the required items."},
					0
				)
				return
			end

			local choice2 = player:menuSeq(
				"I see you have everything already, do you wish to make one now?",
				{"Yes", "No"},
				{}
			)

			if choice2 == 1 then
				-- yes

				if player:hasItem("sam_san_blood", 1) ~= true or player:hasItem(
					"scroll_of_defense",
					1
				) ~= true or player.money < 192000 then
					player:dialogSeq(
						{
							t,
							"Please return when you have all the required items."
						},
						0
					)
					return
				end

				player:removeItem("sam_san_blood", 1, 9)
				player:removeItem("scroll_of_defense", 1, 9)
				player:removeGold(192000)

				player:addItem("enchanted_buckler", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Enchanted buckler. I hope it brings you luck in battle against Nagnag, and all evil!"
					},
					0
				)
			elseif choice2 == 2 then
				-- no
				player:dialogSeq(
					{t, "Please return to me if you change your mind."},
					0
				)
			end
		elseif choice == "Mystic buckler" then
			player:dialogSeq(
				{
					t,
					"The Mystic buckler is an amazing buckler, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Scroll of defense for a mold, a Sa san Blood to hold the power forged into it, 500 Ri shards, 250 Xi shards, 100 Zen shards, and 384,000 gold."
				},
				1
			)

			if player:hasItem("sa_san_blood", 1) ~= true or player:hasItem(
				"scroll_of_defense",
				1
			) ~= true or player:hasItem("ri_shard", 500) ~= true or player:hasItem(
				"xi_shard",
				250
			) ~= true or player:hasItem("zen_shard", 100) ~= true or player.money < 384000 then
				player:dialogSeq(
					{t, "Please return when you have all the required items."},
					0
				)
				return
			end

			local choice2 = player:menuSeq(
				"I see you have everything already, do you wish to make one now?",
				{"Yes", "No"},
				{}
			)

			if choice2 == 1 then
				-- yes

				if player:hasItem("sa_san_blood", 1) ~= true or player:hasItem(
					"scroll_of_defense",
					1
				) ~= true or player:hasItem("ri_shard", 500) ~= true or player:hasItem(
					"xi_shard",
					250
				) ~= true or player:hasItem("zen_shard", 100) ~= true or player.money < 384000 then
					player:dialogSeq(
						{
							t,
							"Please return when you have all the required items."
						},
						0
					)
					return
				end

				player:removeItem("sa_san_blood", 1, 9)
				player:removeItem("scroll_of_defense", 1, 9)
				player:removeItem("ri_shard", 500, 9)
				player:removeItem("xi_shard", 250, 9)
				player:removeItem("zen_shard", 100, 9)
				player:removeGold(384000)

				player:addItem("mystic_buckler", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Mystic buckler. I hope it brings you luck in battle against Nagnag, and all evil!"
					},
					0
				)
			elseif choice2 == 2 then
				-- no
				player:dialogSeq(
					{t, "Please return to me if you change your mind."},
					0
				)
			end
		end
	end)
}
