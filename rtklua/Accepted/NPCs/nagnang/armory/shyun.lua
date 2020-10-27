ShyunNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.baseClass ~= 3 then
			player:dialogSeq({t, "Sorry I cannot help your kind."}, 0)
			return
		end

		if not player:hasLegend("family_nangen_mages") then
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
				"I want you to get revenge for me from Nagnag for what he has done to me, the only thing I can do to help is create the items for you that I made for his magi."
			},
			1
		)

		local items = {}

		if player.level >= 11 then
			table.insert(items, "Magic amulet")
		end
		if player.level >= 39 then
			table.insert(items, "Magic rune")
		end
		if player.level >= 69 then
			table.insert(items, "Magic ward")
		end
		if player.level >= 97 then
			table.insert(items, "Mages ward")
		end
		if player.level >= 99 and player.mark >= 1 then
			table.insert(items, "Enchanted ward")
		end
		if player.level >= 99 and player.mark >= 2 then
			table.insert(items, "Conjurer's ward")
		end
		if player.level >= 99 and player.mark >= 3 then
			table.insert(items, "Mysticism ward")
		end
		if player.level >= 99 and player.mark >= 4 then
			table.insert(items, "Masters ward")
		end

		local choice = player:menuString(
			"What would you like me to help you make?",
			items
		)

		if choice == "Magic amulet" then
			player:dialogSeq(
				{
					t,
					"The Magic amulet is an amazing amulet, it's powerful.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need Earth clothes, 10 bear's livers, a herb pipe, and 1,000 gold."
				},
				1
			)

			if player:hasItem("earth_clothes", 1) ~= true or player:hasItem(
				"bears_liver",
				10
			) ~= true or player:hasItem("herb_pipe", 1) ~= true or player.money < 1000 then
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

				if player:hasItem("earth_clothes", 1) ~= true or player:hasItem(
					"bears_liver",
					10
				) ~= true or player:hasItem("herb_pipe", 1) ~= true or player.money < 1000 then
					player:dialogSeq(
						{
							t,
							"Please return to me when you have the required items."
						},
						0
					)
					return
				end

				player:removeItem("earth_clothes", 1, 9)
				player:removeItem("bears_liver", 10, 9)
				player:removeItem("herb_pipe", 1, 9)
				player:removeGold(1000)

				player:addItem("magic_amulet", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Magic amulet. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Magic rune" then
			player:dialogSeq(
				{
					t,
					"The Magic rune is an amazing rune, it's powerful.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Bekyun's spear, a Fine metal, and 4,000 gold."
				},
				1
			)

			if player:hasItem("bekyuns_spear", 1) ~= true or player:hasItem("fine_metal", 1) ~= true or player.money < 4000 then
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

				if player:hasItem("bekyuns_spear", 1) ~= true or player:hasItem("fine_metal", 1) ~= true or player.money < 4000 then
					player:dialogSeq(
						{
							t,
							"Please return to me when you have the required items."
						},
						0
					)
					return
				end

				player:removeItem("bekyuns_spear", 1, 9)
				player:removeItem("fine_metal", 1, 9)
				player:removeGold(4000)

				player:addItem("magic_rune", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Magic rune. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Magic ward" then
			player:dialogSeq(
				{
					t,
					"The Magic ward is an amazing ward, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Scroll of invocation, a Holy ring, and 12,000 gold."
				},
				1
			)

			if player:hasItem("scroll_of_invocation", 1) ~= true or player:hasItem(
				"holy_ring",
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

				if player:hasItem("scroll_of_invocation", 1) ~= true or player:hasItem(
					"holy_ring",
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

				player:removeItem("scroll_of_invocation", 1, 9)
				player:removeItem("holy_ring", 1, 9)
				player:removeGold(12000)

				player:addItem("magic_ward", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Magic ward. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Mages ward" then
			player:dialogSeq(
				{
					t,
					"The Mages ward is an amazing ward, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Scroll of invocation for a mold, a Surge to hold the power forged into it, and 24,000 gold."
				},
				1
			)

			if player:hasItem("scroll_of_invocation", 1) ~= true or player:hasItem(
				"surge",
				1
			) ~= true or player.money < 24000 then
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

				if player:hasItem("scroll_of_invocation", 1) ~= true or player:hasItem(
					"surge",
					1
				) ~= true or player.money < 24000 then
					player:dialogSeq(
						{
							t,
							"Please return when you have all the required items."
						},
						0
					)
					return
				end

				player:removeItem("scroll_of_invocation", 1, 9)
				player:removeItem("surge", 1, 9)
				player:removeGold(24000)

				player:addItem("mages_ward", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Mages ward. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Enchanted ward" then
			player:dialogSeq(
				{
					t,
					"The Enchanted ward is an amazing ward, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Scroll of invocation for a mold, a Il san Surge to hold the power forged into it, and 48,000 gold."
				},
				1
			)

			if player:hasItem("scroll_of_invocation", 1) ~= true or player:hasItem(
				"il_san_surge",
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

				if player:hasItem("scroll_of_invocation", 1) ~= true or player:hasItem(
					"il_san_surge",
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

				player:removeItem("il_san_surge", 1, 9)
				player:removeItem("scroll_of_invocation", 1, 9)
				player:removeGold(48000)

				player:addItem("enchanted_ward", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Enchanted ward. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Conjurer's ward" then
			player:dialogSeq(
				{
					t,
					"The Conjurer's ward is an amazing ward, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Scroll of invocation for a mold, a Ee san Surge to hold the power forged into it, and 96,000 gold."
				},
				1
			)

			if player:hasItem("ee_san_surge", 1) ~= true or player:hasItem(
				"scroll_of_invocation",
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

				if player:hasItem("ee_san_surge", 1) ~= true or player:hasItem(
					"scroll_of_invocation",
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

				player:removeItem("ee_san_surge", 1, 9)
				player:removeItem("scroll_of_invocation", 1, 9)
				player:removeGold(96000)

				player:addItem("conjurers_ward", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Conjurer's ward. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Mysticism ward" then
			player:dialogSeq(
				{
					t,
					"The Mysticism ward is an amazing ward, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Scroll of invocation for a mold, a Sam san Surge to hold the power forged into it, and 192,000 gold."
				},
				1
			)

			if player:hasItem("sam_san_surge", 1) ~= true or player:hasItem(
				"scroll_of_invocation",
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
				if player:hasItem("sam_san_surge", 1) ~= true or player:hasItem(
					"scroll_of_invocation",
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

				player:removeItem("sam_san_surge", 1, 9)
				player:removeItem("scroll_of_invocation", 1, 9)
				player:removeGold(192000)

				player:addItem("mysticism_ward", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Mysticism ward. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Masters ward" then
			player:dialogSeq(
				{
					t,
					"The Masters ward is an amazing ward, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Scroll of invocation for a mold, a Sa san Surge to hold the power forged into it, 500 Ri shards, 250 Xi shards, 100 Zen shards, and 384,000 gold."
				},
				1
			)

			if player:hasItem("sa_san_surge", 1) ~= true or player:hasItem(
				"scroll_of_invocation",
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

				if player:hasItem("sa_san_surge", 1) ~= true or player:hasItem(
					"scroll_of_invocation",
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

				player:removeItem("sa_san_surge", 1, 9)
				player:removeItem("scroll_of_invocation", 1, 9)
				player:removeItem("ri_shard", 500, 9)
				player:removeItem("xi_shard", 250, 9)
				player:removeItem("zen_shard", 100, 9)
				player:removeGold(384000)

				player:addItem("masters_ward", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Masters ward. I hope it brings you luck in battle against Nagnag, and all evil!"
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
