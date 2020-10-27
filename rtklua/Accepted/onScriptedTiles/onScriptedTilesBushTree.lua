onScriptedTilesBushTree = function(player)
	--apple tree 860-864

	local appleTreeFound = checkProximityObjects(
		player,
		{860, 861, 862, 863, 864},
		1
	)
	if appleTreeFound then
		if math.random(1, 50) == 1 then
			-- give apple
			player:addItem("apple", 1)
			player:sendMinitext("You found an apple.")
		end
	end

	local roseBushFound = checkProximityObjects(
		player,
		{876, 877, 878, 879, 880, 881, 882, 883, 884, 885, 886, 887, 888, 889},
		1
	)
	if roseBushFound then
		if math.random(1, 50) == 1 then
			-- give rose
			player:addItem("rose", 1)
			player:sendMinitext("You find a beautiful rose!")
		end
	end
end
