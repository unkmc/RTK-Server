random_faerie_wings_box = {
	use = function(player)
		local faerie_wings = {
			"green_faerie_wings",
			"blue_faerie_wings",
			"golden_faerie_wings",
			"platinum_faerie_wings",
			"red_faerie_wings"
		}

		local randomFaerieWing = faerie_wings[math.random(1, #faerie_wings)]

		if not player:hasSpace(randomFaerieWing, 1) then
			player:sendMinitext("Your inventory is full.")
			return
		end
		if player:hasItem("random_faerie_wings_box", 1) ~= true then
			return
		end

		--broadcast(-1,player.name.." opened Random Faerie Wings Box and received "..Item(randomFaerieWing).name.."!")
		player:msg(
			0,
			"You've opened your box and received " .. Item(randomFaerieWing).name .. "!",
			player.ID
		)

		--player:sendMinitext("You've opened your box and received "..Item(randomFaerieWing).name.."!")

		player:addItem(randomFaerieWing, 1)
		player:removeItem("random_faerie_wings_box", 1)
	end
}
