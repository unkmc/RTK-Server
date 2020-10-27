JiongNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.baseClass ~= 4 then
			player:dialogSeq({t, "Sorry I cannot help your kind."}, 0)
			return
		end

		if not player:hasLegend("destroyed_nagnang_evil") then
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
				"I want you to get revenge for me from Nagnag for what he has done to me, the only thing I can do to help is create the items for you that I made for his poets."
			},
			1
		)

		local items = {}

		if player.level >= 11 then
			table.insert(items, "Love amulet")
		end
		if player.level >= 39 then
			table.insert(items, "Love rune")
		end
		if player.level >= 69 then
			table.insert(items, "Nature charm")
		end
		if player.level >= 97 then
			table.insert(items, "Soul charm")
		end
		if player.level >= 99 and player.mark >= 1 then
			table.insert(items, "Spirit charm")
		end
		if player.level >= 99 and player.mark >= 2 then
			table.insert(items, "Love charm")
		end
		if player.level >= 99 and player.mark >= 3 then
			table.insert(items, "Life charm")
		end
		if player.level >= 99 and player.mark >= 4 then
			table.insert(items, "Immortality charm")
		end

		local choice = player:menuString(
			"What would you like me to help you make?",
			items
		)

		if choice == "Love amulet" then
			player:dialogSeq(
				{
					t,
					"The Love amulet is an amazing amulet, it's powerful.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need Earth robes, 10 bear's livers, a herb pipe, and 1,000 gold."
				},
				1
			)

			if player:hasItem("earth_robes", 1) ~= true or player:hasItem("bears_liver", 10) ~= true or player:hasItem(
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

				if player:hasItem("earth_robes", 1) ~= true or player:hasItem("bears_liver", 10) ~= true or player:hasItem(
					"herb_pipe",
					1
				) ~= true or player.money < 1000 then
					return
				end

				player:removeItem("earth_robes", 1, 9)
				player:removeItem("bears_liver", 10, 9)
				player:removeItem("herb_pipe", 1, 9)
				player:removeGold(1000)

				player:addItem("love_amulet", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Love amulet. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Love rune" then
			player:dialogSeq(
				{
					t,
					"The Love rune is an amazing rune, it's powerful.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Death's head, a Fine metal, and 4,000 gold."
				},
				1
			)

			if player:hasItem("deaths_head", 1) ~= true or player:hasItem("fine_metal", 1) ~= true or player.money < 4000 then
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

				if player:hasItem("deaths_head", 1) ~= true or player:hasItem("fine_metal", 1) ~= true or player.money < 4000 then
					return
				end

				player:removeItem("deaths_head", 1, 9)
				player:removeItem("fine_metal", 1, 9)
				player:removeGold(4000)

				player:addItem("love_rune", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Love rune. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Nature charm" then
			player:dialogSeq(
				{
					t,
					"The Nature charm is an amazing ward, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Sen glove, a Lantern, and 12,000 gold."
				},
				1
			)

			if player:hasItem("sen_glove", 1) ~= true or player:hasItem("lantern", 1) ~= true or player.money < 12000 then
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

				if player:hasItem("sen_glove", 1) ~= true or player:hasItem("lantern", 1) ~= true or player.money < 12000 then
					return
				end

				player:removeItem("sen_glove", 1, 9)
				player:removeItem("lantern", 1, 9)
				player:removeGold(12000)

				player:addItem("nature_charm", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Nature charm. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Soul charm" then
			player:dialogSeq(
				{
					t,
					"The Soul charm is an amazing charm, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Lantern for a mold, a Charm to hold the power forged into it, and 24,000 gold."
				},
				1
			)

			if player:hasItem("lantern", 1) ~= true or player:hasItem("charm", 1) ~= true or player.money < 24000 then
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

				if player:hasItem("lantern", 1) ~= true or player:hasItem("charm", 1) ~= true or player.money < 24000 then
					return
				end

				player:removeItem("lantern", 1, 9)
				player:removeItem("charm", 1, 9)
				player:removeGold(24000)

				player:addItem("soul_charm", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Soul charm. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Spirit charm" then
			player:dialogSeq(
				{
					t,
					"The Spirit charm is an amazing charm, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Lantern for a mold, a Il san Charm to hold the power forged into it, and 48,000 gold."
				},
				1
			)

			if player:hasItem("lantern", 1) ~= true or player:hasItem("il_san_charm", 1) ~= true or player.money < 48000 then
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

				if player:hasItem("lantern", 1) ~= true or player:hasItem("il_san_charm", 1) ~= true or player.money < 48000 then
					return
				end

				player:removeItem("lantern", 1, 9)
				player:removeItem("il_san_charm", 1, 9)
				player:removeGold(48000)

				player:addItem("spirit_charm", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Spirit charm. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Love charm" then
			player:dialogSeq(
				{
					t,
					"The Love charm is an amazing charm, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Lantern for a mold, a Ee san Charm to hold the power forged into it, and 96,000 gold."
				},
				1
			)

			if player:hasItem("lantern", 1) ~= true or player:hasItem("ee_san_charm", 1) ~= true or player.money < 96000 then
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

				if player:hasItem("lantern", 1) ~= true or player:hasItem("ee_san_charm", 1) ~= true or player.money < 96000 then
					return
				end

				player:removeItem("lantern", 1, 9)
				player:removeItem("ee_san_charm", 1, 9)
				player:removeGold(96000)

				player:addItem("love_charm", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Love charm. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Life charm" then
			player:dialogSeq(
				{
					t,
					"The Life charm is an amazing charm, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Lantern for a mold, a Sam san Charm to hold the power forged into it, and 192,000 gold."
				},
				1
			)

			if player:hasItem("lantern", 1) ~= true or player:hasItem("sam_san_charm", 1) ~= true or player.money < 192000 then
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

				if player:hasItem("lantern", 1) ~= true or player:hasItem("sam_san_charm", 1) ~= true or player.money < 192000 then
					return
				end

				player:removeItem("lantern", 1, 9)
				player:removeItem("sam_san_charm", 1, 9)
				player:removeGold(192000)

				player:addItem("life_charm", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Life charm. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Immortality charm" then
			player:dialogSeq(
				{
					t,
					"The Immortality charm is an amazing charm, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Lantern for a mold, a Sa san Charm to hold the power forged into it, 500 Ri shards, 250 Xi shards, 100 Zen shards, and 384,000 gold."
				},
				1
			)

			if player:hasItem("lantern", 1) ~= true or player:hasItem("sa_san_charm", 1) ~= true or player:hasItem(
				"ri_shard",
				500
			) ~= true or player:hasItem("xi_shard", 250) ~= true or player:hasItem(
				"zen_shard",
				100
			) ~= true or player.money < 384000 then
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

				if player:hasItem("lantern", 1) ~= true or player:hasItem("sa_san_charm", 1) ~= true or player:hasItem(
					"ri_shard",
					500
				) ~= true or player:hasItem("xi_shard", 250) ~= true or player:hasItem(
					"zen_shard",
					100
				) ~= true or player.money < 384000 then
					return
				end

				player:removeItem("lantern", 1, 9)
				player:removeItem("sa_san_charm", 1, 9)
				player:removeItem("ri_shard", 500, 9)
				player:removeItem("xi_shard", 250, 9)
				player:removeItem("zen_shard", 100, 9)
				player:removeGold(384000)

				player:addItem("immortality_charm", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Immortality charm. I hope it brings you luck in battle against Nagnag, and all evil!"
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
