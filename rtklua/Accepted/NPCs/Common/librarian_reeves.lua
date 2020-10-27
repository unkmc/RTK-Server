LibrarianReevesNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		player:dialogSeq({t, "Hello, how can I help you?."}, 1)
	end),
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
		if player.quest["reeves_quest"] >= 0 then
			if speech == "spoon" then
				if player.quest["reeves_quest"] == 0 then
					player.quest["reeves_quest"] = 1
				end
				player:dialogSeq(
					{
						t,
						"Ah yes, Spoon. What an interesting fellow. He was here earlier very eager to learn more about demons and statues and spicy chicken wings... I wonder what that was about."
					},
					0
				)
			end
		end

		if player.quest["reeves_quest"] >= 1 then
			if speech == "demons" then
				if player.quest["reeves_quest"] == 1 then
					player.quest["reeves_quest"] = 2
				end
				player:dialogSeq(
					{
						t,
						"Spoon was quite eager to acquire any and all material we had on demons.",
						"While we don't have much in the way of factual demons, he seemed interested in both the rumours and documented accounts of these foul beings.",
						"Let me see if I can remember the book he was hunched over for hours by candlelight."
					},
					0
				)
			end
			if speech == "demon" then
				if player.quest["reeves_quest"] == 1 then
					player.quest["reeves_quest"] = 2
				end
				player:dialogSeq(
					{
						t,
						"Spoon was quite eager to acquire any and all material we had on demons.",
						"While we don't have much in the way of factual demons, he seemed interested in both the rumours and documented accounts of these foul beings.",
						"Let me see if I can remember the book he was hunched over for hours by candlelight."
					},
					0
				)
			end
			if speech == "spicy chicken wings" then
				player:dialogSeq(
					{
						t,
						"I cannot believe it, he told me others would also be interested in his chicken wing recipe.",
						"He left the recipe with me, after talking for hours on end about the balance between the hot sauce and the garlic powder... I have honestly never been so bored. Anyways, here you go!",
						"Spoon's Spicy Chicken Wings",
						"Prep: 15-20 min | Cooking: 45m | Ready in ~ 2 hours",
						"3/4 cup all-purpose flour, 1/2 teaspoon cayenne pepper, 1/2 teaspoon garlic powder, 1/2 teaspoon salt, 1/2 cup melted butter and as much hotsauce as you can handle",
						"Line a baking sheet with aluminum foil, and lightly grease with cooking spray. Place the flour, cayenne pepper, garlic powder, and salt into a resealable plastic bag, and shake to mix. Add the chicken wings, seal, and toss until well coated with the flour mixture.",
						"Place the wings onto the prepared baking sheet, and place into the refrigerator. Refrigerate at least 1 hour.",
						"Preheat oven to 400 degrees F (200 degrees C).",
						"Whisk together the melted butter and hot sauce in a small bowl. Dip the wings into the butter mixture, and place back on the baking sheet.",
						"Bake in the preheated oven until the chicken is no longer pink in the center, and crispy on the outside, about 45 minutes. Turn the wings over halfway during cooking so they cook evenly.",
						"Partner with an IPA. Enjoy! ~GM Spoon"
					},
					0
				)
			end
		end

		if player.quest["reeves_quest"] >= 1 then
			if speech == "statues" then
				player:dialogSeq(
					{
						t,
						"Oh I could talk about statues for days! The kingdom used to be filled with statues of our heroes...",
						"But alas, our ruler decided that there should be no effigies placed inside the kingdom aside from the Totems.",
						"Oh well, here's hoping he changes his mind."
					},
					0
				)
			end
			if speech == "statue" then
				player:dialogSeq(
					{
						t,
						"Oh I could talk about statues for days! The kingdom used to be filled with statues of our heroes...",
						"But alas, our ruler decided that there should be no effigies placed inside the kingdom aside from the Totems.",
						"Oh well, here's hoping he changes his mind."
					},
					0
				)
			end
		end

		if player.quest["reeves_quest"] >= 2 then
			if speech == "book" then
				if player.quest["reeves_quest"] == 2 then
					player.quest["reeves_quest"] = 3
				end
				player:dialogSeq(
					{
						t,
						"We have quite a few books on ghouls and goblins, as well as demons.",
						"Spoon seemed rather concerned about a book referencing... oh what was it now... oh yes 'The Calamity'.",
						"If I am not mistaken it is over there on next to my assistant, Yan. Why don't you go ask him about it."
					},
					0
				)
			end
		end
	end)
}
