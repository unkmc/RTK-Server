DakHoNpc = {
	click = async(function(player, npc)
		local name = "<b>[" .. npc.name .. "]\n\n"
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {
			"Chu Rua Quest",
			"Where am I!?",
			"Yellow scroll",
			"Raise and Lower your voice!"
		}
		local txt = ""

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Chu Rua Quest" then
			if (player:hasLegend("aided_chu_rua")) then
				player:dialogSeq({t, "Thank you for helping Chu Rua!"}, 0)
			end
		elseif menu == "Where am I!?" then
			player:dialogSeq(
				{
					t,
					"You are at Tangun.\n\nTangun is a town for the young ones. There are caves and quests suited for the inexperienced players, and you can learn about things, such as subpath, crafting, food preparation.",
					"Bored with IronHeart or JadeSpear?\n\nYou can obtain more things and knowledge here in Tangun. But, don't forget to go back to see your tutor later on."
				},
				0
			)
		elseif menu == "Yellow scroll" then
			player:dialogSeq(
				{
					t,
					"Using a yellow scroll will take you to the inn of the nation that you belong to.\n\nYou may purchase these at the inn at a very reasonable price.",
					"Here are a few yellow scrolls you can try."
				},
				1
			)
			player:addItem("yellow_scroll", 5)
		elseif menu == "Raise and Lower your voice!" then
			player:dialogSeq(
				{
					t,
					"Hey you! Oh my don't jump like that! I am only shouting at you. You see here in thee Kingdom of the Winds you can raise or lower the tone of your voice.",
					"You don't remember how? Oh let me help you with that. You already know how to speak in normal tones so that is a good start.",
					"Now lets practice a shout shall we. ((Press ! or shift 1 and then type what you want to say.)) If you shout something out players will be able to hear you from further away.",
					"On the opposite end you can whisper something on the Winds of the Kingdoms! These magical winds will carry your voice to a specific person or specific group of people. Only they will be able to hear what you say.",
					"((Press shift ' (aphostrophe) then type in the person's name you want to speak to and press enter. Now you can just type your message.))",
					"If you want to talk with only the members of a group you have formed this is easy to do too! ((Type !! then enter, now type the message you wish the group to hear.))",
					"Once you are in a Clan or Subpath you will also be able to talk to your fellow friends. You can learn about this from Sshijok right inside the Clan hall. *Points to door*",
					"Now if only I can remember what I wanted to call you over here for in the first place... hmmm... *he forgets you are standing there as he wanders through his thoughts*."
				},
				0
			)
		end
	end)
}
