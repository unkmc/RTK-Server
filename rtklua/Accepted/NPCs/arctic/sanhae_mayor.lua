local _waypointId = "sanhae"

SanhaeMayorNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		local opts = {
			"Sanhae Mayor",
			"Live in Sanhae"
		}

		if (not Waypoint.isEnabled(player, _waypointId)) then
			table.insert(opts, "Waypoint")
		end

		local choice = player:menuString("Hello! How can I help you today?", opts, {})
		local choice2

		if choice == "Waypoint" then
			Waypoint.add(player, npc, _waypointId)
		elseif choice == "Sanhae Mayor" then
			player:dialogSeq({"Hello there. welcome to the town of Sanhae."}, 1)

			if player.quest["tutorial_quest"] == 11 then
				player:dialogSeq({"You look troubled... And so you should be. There are some dark forces at work here."}, 1)

				choice2 = player:menuString(
					"So, what can I help you with today?",
					{"Missing Brother", "Dark Forces?", "Du Mountain?"},
					{}
				)
			end
		elseif choice == "Live in Sanhae" then
			if player.country ~= 2 then
				player:dialogSeq({"Greetings, I would love to let you live here, but only people who are Buyan may live in this town."}, 1)
			else
				if player.registry["home"] == 10 then
					local confirm = player:menuSeq(
						"You already live in my towns tavern... do you wish to leave already?",
						{"Yes, I do.", "No, I wish to stay."},
						{}
					)

					if confirm == 1 then
						-- leave
						player.registry["home"] = 0
						player:dialogSeq({"Well, nothing lasts forever. Good luck in the future."}, 0)

						return
					elseif confirm == 2 then
						player:dialogSeq({"Ah, that is good to hear. I hope you like my service here."}, 0)
						return
					end
				else
					player:dialogSeq({"So you wish to live in my humble tavern, eh? Well, I can spare you some room. But remember, you will always return here, and not the taverns in the city if you do this."}, 1)

					local confirm = player:menuSeq(
						"Are you sure you want to do this?",
						{"Yes, I wish to.", "No, I do not."},
						{}
					)

					if confirm == 1 then
						player.registry["home"] = 10
						player:dialogSeq({"Welcome to my tavern, I hope you enjoy your time here."}, 0)
						return
					elseif confirm == 2 then
						player:dialogSeq({"That is your choice, plenty of room if you wish to come back later."}, 0)
						return
					end
				end
				return
			end
		end

		if choice2 == "Missing Brother" then
			player:dialogSeq(
				{
					"Poor, poor man. He went off with the others to hunt, and is lost with them.",
					"Darn these evil forces, if only somebody brave enough would lift the curse."
				},
				1
			)
		elseif choice2 == "Dark Forces?" then
			player:dialogSeq(
				{
					"Recently several of our men have gone missing from this town.",
					"They go off to hunt at Du Mountain, and never return.",
					"I fear it will be the end of our village if something is not done soon."
				},
				1
			)
		elseif choice2 == "Du Mountain?" then
			player:dialogSeq(
				{
					"Oh, you are new to these lands. Du Mountain is to the west of our town.",
					"If you go back the way you came, then head to the west side of the northern pass you will find it.",
					"But I beg you not to go there, only evil resides there now."
				},
				1
			)
		end
	end),

	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)

		if (speech == "waypoint" and not Waypoint.isEnabled(player, _waypointId)) then
			Waypoint.add(player, npc, _waypointId)
			return
		end
	end),
}
