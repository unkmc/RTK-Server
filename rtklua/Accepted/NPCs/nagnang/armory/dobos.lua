DobosNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.baseClass ~= 1 then
			player:dialogSeq({t, "Sorry I cannot help your kind."}, 0)
			return
		end

		if not player:hasLegend("nagnang_warrior_trial") then
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
				"I want you to get revenge for me from Nagnag for what he has done to me, the only thing I can do to help is create the items for you that I made for his warriors."
			},
			1
		)

		local items = {}

		if player.level >= 11 then
			table.insert(items, "War amulet")
		end
		if player.level >= 39 then
			table.insert(items, "War rune")
		end
		if player.level >= 69 then
			table.insert(items, "Bamboo shield")
		end
		if player.level >= 97 then
			table.insert(items, "Stone shield")
		end
		if player.level >= 99 and player.mark >= 1 then
			table.insert(items, "Hide shield")
		end
		if player.level >= 99 and player.mark >= 2 then
			table.insert(items, "Brass shield")
		end
		if player.level >= 99 and player.mark >= 3 then
			table.insert(items, "Titanium shield")
		end
		if player.level >= 99 and player.mark >= 4 then
			table.insert(items, "Noble shield")
		end

		local choice = player:menuString(
			"What would you like me to help you make?",
			items
		)

		if choice == "War amulet" then
			player:dialogSeq(
				{
					t,
					"The War amulet is an amazing amulet, it's powerful.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Earth scalemail, 10 bear's livers, a herb pipe, and 1,000 gold."
				},
				1
			)

			if player:hasItem("earth_scale_mail", 1) ~= true or player:hasItem(
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

				if player:hasItem("earth_scale_mail", 1) ~= true or player:hasItem(
					"bears_liver",
					10
				) ~= true or player:hasItem("herb_pipe", 1) ~= true or player.money < 1000 then
					return
				end

				player:removeItem("earth_scale_mail", 1, 9)
				player:removeItem("bears_liver", 10, 9)
				player:removeItem("herb_pipe", 1, 9)
				player:removeGold(1000)

				player:addItem("war_amulet", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own War amulet. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "War rune" then
			player:dialogSeq(
				{
					t,
					"The War rune is an amazing rune, it's powerful.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Hunang's axe, a Fine metal, and 4,000 gold."
				},
				1
			)

			if player:hasItem("hunangs_axe", 1) ~= true or player:hasItem("fine_metal", 1) ~= true or player.money < 4000 then
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

				if player:hasItem("hunangs_axe", 1) ~= true or player:hasItem("fine_metal", 1) ~= true or player.money < 4000 then
					return
				end

				player:removeItem("hunangs_axe", 1, 9)
				player:removeItem("fine_metal", 1, 9)
				player:removeGold(4000)

				player:addItem("war_rune", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own War rune. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Bamboo shield" then
			player:dialogSeq(
				{
					t,
					"The Bamboo shield is an amazing shield, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Titanium glove, a Tall shield, and 12,000 gold."
				},
				1
			)

			if player:hasItem("titanium_glove", 1) ~= true or player:hasItem("tall_shield", 1) ~= true or player.money < 12000 then
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

				if player:hasItem("titanium_glove", 1) ~= true or player:hasItem(
					"tall_shield",
					1
				) ~= true or player.money < 12000 then
					return
				end

				player:removeItem("titanium_glove", 1, 9)
				player:removeItem("tall_shield", 1, 9)
				player:removeGold(12000)

				player:addItem("bamboo_shield", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own War rune. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Stone shield" then
			player:dialogSeq(
				{
					t,
					"The Stone shield is an amazing shield. It's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Tall shield for a mold, a Spike to hold the power forged into it, and 24,000 gold."
				},
				1
			)

			if player:hasItem("spike", 1) ~= true or player:hasItem("tall_shield", 1) ~= true or player.money < 24000 then
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

				if player:hasItem("spike", 1) ~= true or player:hasItem("tall_shield", 1) ~= true or player.money < 24000 then
					return
				end

				player:removeItem("spike", 1, 9)
				player:removeItem("tall_shield", 1, 9)
				player:removeGold(24000)

				player:addItem("stone_shield", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Stone shield. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Hide shield" then
			player:dialogSeq(
				{
					t,
					"The Hide shield is an amazing shield, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Tall shield for a mold, a Il san Spike to hold the power forged into it, and 48,000 gold."
				},
				1
			)

			if player:hasItem("il_san_spike", 1) ~= true or player:hasItem("tall_shield", 1) ~= true or player.money < 48000 then
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

				if player:hasItem("il_san_spike", 1) ~= true or player:hasItem("tall_shield", 1) ~= true or player.money < 48000 then
					return
				end

				player:removeItem("il_san_spike", 1, 9)
				player:removeItem("tall_shield", 1, 9)
				player:removeGold(48000)

				player:addItem("hide_shield", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Hide shield. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Brass shield" then
			player:dialogSeq(
				{
					t,
					"The Brass shield is an amazing shield, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Tall shield for a mold, a EE san Spike to hold the power forged into it, and 96,000 gold."
				},
				1
			)

			if player:hasItem("ee_san_spike", 1) ~= true or player:hasItem("tall_shield", 1) ~= true or player.money < 96000 then
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

				if player:hasItem("ee_san_spike", 1) ~= true or player:hasItem("tall_shield", 1) ~= true or player.money < 96000 then
					return
				end

				player:removeItem("ee_san_spike", 1, 9)
				player:removeItem("tall_shield", 1, 9)
				player:removeGold(96000)

				player:addItem("brass_shield", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Brass shield. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Titanium shield" then
			player:dialogSeq(
				{
					t,
					"The Titanium shield is an amazing shield, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Tall shield for a mold, a Sam san Spike to hold the power forged into it, and 192,000 gold."
				},
				1
			)

			if player:hasItem("sam_san_spike", 1) ~= true or player:hasItem(
				"tall_shield",
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

				if player:hasItem("sam_san_spike", 1) ~= true or player:hasItem(
					"tall_shield",
					1
				) ~= true or player.money < 192000 then
					return
				end

				player:removeItem("sam_san_spike", 1, 9)
				player:removeItem("tall_shield", 1, 9)
				player:removeGold(192000)

				player:addItem("titanium_shield", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Titanium shield. I hope it brings you luck in battle against Nagnag, and all evil!"
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
		elseif choice == "Noble shield" then
			player:dialogSeq(
				{
					t,
					"The Noble shield is an amazing shield, it's heavy but can take a lot of the beating away from you.",
					"Unfortunately when Nagnag and his army left here they took everything with them, all my supplies are gone. If you want one you will need to bring me the items to make one.",
					"To make one I will need a Tall shield for a mold, a Sa san Spike to hold the power forged into it, 500 Ri shards, 250 Xi shards, 100 Zen shards, and 384,000 gold."
				},
				1
			)

			if player:hasItem("sa_san_spike", 1) ~= true or player:hasItem("tall_shield", 1) ~= true or player:hasItem(
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

				if player:hasItem("sa_san_spike", 1) ~= true or player:hasItem("tall_shield", 1) ~= true or player:hasItem(
					"ri_shard",
					500
				) ~= true or player:hasItem("xi_shard", 250) ~= true or player:hasItem(
					"zen_shard",
					100
				) ~= true or player.money < 384000 then
					return
				end

				player:removeItem("sa_san_spike", 1, 9)
				player:removeItem("tall_shield", 1, 9)
				player:removeItem("ri_shard", 500, 9)
				player:removeItem("xi_shard", 250, 9)
				player:removeItem("zen_shard", 100, 9)
				player:removeGold(384000)

				player:addItem("noble_shield", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"Ah, there you go, your own Noble shield. I hope it brings you luck in battle against Nagnag, and all evil!"
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
