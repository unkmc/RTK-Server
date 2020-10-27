TutorialNpc1 = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		player:dialogSeq(
			{
				t,
				"'Tis a good thing that this area is relatively safe to explore. Within this kingdom roam many beasts that could kill you with nothing more than a glance.\n\nIn these fields, however, you will find little that could kill you quickly...but that is not to say they can't kill you.",
				"You should prepare yourself well for all adventures, with any of the many hundreds of armors, weapons, and items available to you on your way through life.\n\nLet me see what I have that I can spare for you right now.\n\nAh yes, take these items..."
			},
			1
		)

		if (player:hasItem("wooden_saber", 1) ~= true and not player:hasEquipped("wooden_saber")) then
			player:addItem("wooden_saber", 1)
		end

		if (player.sex == 0 and player:hasItem("peasant_garb", 1) ~= true and not player:hasEquipped("peasant_garb")) then
			-- male
			player:addItem("peasant_garb", 1)
		elseif (player.sex == 1 and player:hasItem("peasant_dress", 1) ~= true and not player:hasEquipped("peasant_dress")) then
			--female
			player:addItem("peasant_dress", 1)
		end

		if (Config.tutorialMountEnabled and player:hasItem("horse_mount", 1) ~= true) then
			player:addItem("horse_mount", 1)
		end

		player:dialogSeq(
			{
				t,
				"To see the items in your inventory press the 'i' key.\n\nTo use a weapon or item in your inventory double-click it with your mouse.\n\nOnce you are wearing your items use <space> to attack what is in front of you.",
				"Kill some of the rabbits around here, you can pick up the things they drop by standing on top of the item and pressing the ' , ' ((comma) key, or click on the item with your mouse.",
				"When you get to the town make sure to seek out a blacksmith to keep your weapons in top condition. As you use them they can grow dull and may eventually break if not repaired in time."
			},
			1
		)

		player:dialogSeq(
			{
				t,
				"To find your way out of here you need to find the exit, look at the bottom right of your screen. You can see your coordinates, as you move these numbers will change.\n\nKeep going until they reach 0021 0020, there you will find your way out of here."
			},
			0
		)
	end)
}

TutorialNpc2 = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if (not player:hasSpell("soothe")) then
			player:dialogSeq(
				{
					t,
					"Welcome, child. You seem to be learning much, and I can sense your mind expanding in leaps and bounds.",
					"In the hut beside me you will find Tominaru and my sister Mignok, the novice teachers.",
					"Tominaru will explain many wisdoms about the Kingdoms, and my sister will teach you a very valuable spell. She may ask for items in exchange for teaching you.\n\nReturn to me after they have taught you."
				},
				1
			)
		else
			player:dialogSeq(
				{
					t,
					"Ah, you look eager to use your new spell. To see the list of spells you have, press the '+' key on the keypad on the right of your keyboard. To cast a spell just double-click it. If the spell can be cast on others, a target box will appear that you can move with your arrow keys.",
					"You can also use \"Macros\" to speed up the spell casting process, so you only have to use a number between 0 and 9 without pressing Z or the spell's letter. You can set your own macros by pressing F11, just enter the spell letter next to the number you want to use, then you only need press that number to cast the spell.",
					"To use your spells without using a macro, press [shift] + [z] and then press the letter associated with the spell from your spell list. Try your new spell then head east."
				},
				1
			)
			if (player.registry["tutorialnpcexp"] == 0) then
				player:giveXP(75)
				player.registry["tutorialnpcexp"] = 1
			end
		end
	end)
}
