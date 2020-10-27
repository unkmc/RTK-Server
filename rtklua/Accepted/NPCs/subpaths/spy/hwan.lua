-- script for npc in buya
spy_hwan = {
	on_spawn = function(mob)
		mob.side = 2
		mob:sendSide()
	end,

	on_healed = function(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		if attacker.gmLevel == 99 then
			mob_ai_basic.on_attacked(mob, attacker)
		end
	end,

	move = function(mob, target)
	end,

	attack = function(mob, target)
	end,

	after_death = function(mob, block)
	end
}

-- script for interrogation
hwan = {
	interrogate = async(function(player)
		local talking = true
		local counter = 0
		local gfx = {graphic = convertGraphic(63, "monster"), color = 30}
		local mistress = {graphic = convertGraphic(5296, "item"), color = 30}
		while talking do
			player:dialogSeq(
				{
					gfx,
					"** You tie Hwan securely to the tree and stand behind the tree so that he cannot see you. **"
				},
				1
			)
			local choices = {
				"Pour water on head to wake up",
				"Slap the back of his head",
				"Tickle him awake..."
			}
			local choice = player:menuSeq(
				"What do you want to do?",
				choices,
				{}
			)
			if choice == 1 or choice == 2 or choice == 3 then
				player:dialogSeq(
					{gfx, "What the HELL is this?! Do you know who I am?!"},
					1
				)
				local choices = {
					"Some imperial lackey who wants to die.",
					"It doesn't matter who you are.",
					"Father of a lovely little girl who would",
					"miss her daddy greatly if he went missing."
				}
				local choice = player:menuSeq(
					"How do you want to irritate him?",
					choices,
					{}
				)
				if choice == 1 then
					player:dialogSeq(
						{
							gfx,
							"I'm not telling you a damn thing! Don't you know who I am?!"
						},
						1
					)
				elseif choice == 2 then
					player:dialogSeq(
						{
							gfx,
							"I'm not telling you a damn thing! Don't you know who I am?!"
						},
						1
					)
				elseif choice == 3 or choice == 4 then
					player:dialogSeq(
						{gfx, "You leave Mari out of this! What do you want?"},
						1
					)
					local choices = {
						"I need to know the transport route for the Jewels",
						"I want you to go home safely to Mari",
						"I need to know who has the Imperial jewels!"
					}
					local choice = player:menuSeq(
						"What do you want to do know that you have Hwan's attention?",
						choices,
						{}
					)
					if choice == 1 then
						player:dialogSeq(
							{
								gfx,
								"Haha you are going to have to try harder than that."
							},
							1
						)
					elseif choice == 2 then
						player:dialogSeq(
							{
								gfx,
								"I said leave her out of this! They'll come for me you know! You're about to have the Imperial Scouts knocking down these doors!."
							},
							1
						)
						local choices = {
							"*Dig your dagger into one of his hands*",
							"Ha! They'll never find you.",
							"Maybe we should ask Mari to come find you."
						}
						local choice = player:menuSeq(
							"What do you do now with the unhelpful Hwan?",
							choices,
							{}
						)
						if choice == 1 then
							player:dialogSeq(
								{
									gfx,
									"** Hwans screams ** Okay, okay! OKAY! What do you want to know, I'll tell you..."
								},
								1
							)
							local choices = {
								"I need to know where the Jewels are.",
								"I need to know where the Jewels are going.",
								"I need you to describe the Jewels."
							}
							local choice = player:menuSeq(
								"What do you do now with the helpful Hwan?",
								choices,
								{}
							)
							if choice == 1 then
								player:dialogSeq(
									{
										gfx,
										"They're guarded by the highest security in the palace. ** That wasn't the answer you wanted **"
									},
									1
								)
							elseif choice == 2 then
								player.quest["spy_trials"] = 13
								player.registry["spy_information"] = player.registry[
									"spy_information"
								] + 1
								player:removeLegendbyName("spy_information")
								player:addLegend(
									"Acquired hidden information " .. player.registry[
										"spy_information"
									] .. " times",
									"spy_information",
									22,
									128
								)
								player:dialogSeq(
									{
										gfx,
										"They're going through the Vale, through a small passage in the southeast",
										"Are you going to let me go now?"
									},
									1
								)
								player:dialogSeq(
									{
										mistress,
										"** A woman appears from behind the tree and offers a silent greeting **",
										"We will indeed release you and spare your life so that you can remember who really controls these lands.",
										"Say anything of this and you'll never be heard from again.",
										"** The guild mistress knocks out Hwan and calls for the Gravekeeper **",
										"See to it our special guest rests comfortably somewhere away from here.",
										"Go quickly take care of that envoy before they reach Nagnang. Leave no trace of them - use our Guild's special explosives from Pyung's shop in Buya.",
										"Maybe you will get there before that other affiliate we sent... I'll wait here at this tree a little longer for whichever one of you gets the task done first."
									},
									1
								)
								return
							elseif choice == 3 then
								player:dialogSeq(
									{
										gfx,
										"These are some of the most precious jewels ever found. ** Clearly not what you needed to know **"
									},
									1
								)
							end
						elseif choice == 2 then
							player:dialogSeq(
								{gfx, "They will definitely find me."},
								1
							)
						elseif choice == 3 then
							player:dialogSeq(
								{
									gfx,
									"If you're going to kill me, get it over with."
								},
								1
							)
						end
					elseif choice == 3 then
						player:dialogSeq(
							{
								gfx,
								"Haha you are going to have to try harder than that."
							},
							1
						)
					end
				end
			end
			if counter == 10 then
				talking = false
				break
			end
		end
	end)
}
