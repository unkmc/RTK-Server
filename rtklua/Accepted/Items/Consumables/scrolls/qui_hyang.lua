qui_hyang = {
	use = async(function(player)
		local t = {graphic = convertGraphic(309, "item"), color = 0}

		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		if player.warpOut == 0 then
			player:sendMinitext("Unable to warp out.")
			return
		end

		if player.state == 1 then
			player:sendMinitext("You need a physical body in order to use this yellow scroll.")
			return
		end

		local opts = {"Home"}

		if player.clan ~= 0 then
			table.insert(opts, "Clan hall")
		end

		if player.class >= 10 then
			table.insert(opts, "Subpath Circle")
		end

		table.insert(opts, "Main Inn")

		local choice = player:menuString("Where do you wish to go?", opts)

		if choice == "Home" then
			player:returnFunc()
			return
		elseif choice == "Subpath Circle" then
			player:returnToSubpath()
			return
		elseif choice == "Clan hall" then
			player:returnToClan()
			return
		elseif choice == "Main Inn" then
			player:returnToInn()
		else
			return
		end
	end)
}
