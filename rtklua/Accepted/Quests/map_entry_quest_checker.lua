map_entry_quest_checker = async(function(player)
	player.dialogType = 0
	local mapName = player.mapTitle

	if mapName == "Welcome" then
		local t = {graphic = convertGraphic(87, "monster"), color = 7}
		player:dialogSeq(
			{
				t,
				"Hello and welcome to RetroTK. Please journey south to begin your tutorial quest and get a weapon, armor, and your first spell."
			},
			1
		)
		player:sendMinitext("This area has been designed to help you get started here and to give you the knowledge you need to begin your adventure!")
	elseif mapName == "Deep Forest" then
		local t = {graphic = convertGraphic(87, "monster"), color = 7}
		player:dialogSeq(
			{
				t,
				"You walk along the path and come across a merchant in a field.\n\nTo talk to merchants in RetroTK you must click on them with your mouse pointer.\n\nTalk to this merchant to continue your learning."
			},
			1
		)
	elseif mapName == "Country Farm" and not player:hasSpell("soothe") then
		if (player.x < 8 and player.y < 5) then
			local t = {graphic = convertGraphic(87, "monster"), color = 7}
			player:dialogSeq(
				{
					t,
					"Congratulations!\n\nYou have learned to find your way around. If you look at the bottom right of your screen, the numbers now read 003 002",
					"Using this system and the Mini Map (Press 'm'), you can find your way around the cities and towns of RetroTK. You can also find the important places by pressing the 'F1' key"
				},
				1
			)
		end
	elseif mapName == "Angel's Blessing" then
		local npc = NPC("Woodland Angel")
		WoodlandAngelNpc.click(player, npc)
	elseif player.mapTitle == "Kugnae" and player.quest["dagger_blue_rooster"] == 2 and player.quest["crow_took_silvery_acorn"] == 0 then
		if player:hasItem("silvery_acorn", 1) == true then
			player:removeItem("silvery_acorn", 1)
			player.quest["crow_took_silvery_acorn"] = 1
			local t = {graphic = convertGraphic(92, "monster"), color = 0}
			player:freeAsync()
			player:dialogSeq(
				{
					t,
					"As you step out into the sunlight, the glint of the acorn attracts a crow. He snatches it and flies east towards the northern beeches of Dae Shore."
				},
				0
			)
		end
	end
end)
