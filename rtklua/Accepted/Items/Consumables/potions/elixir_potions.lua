ancient_potion = {
	use = function(player)
		player.armorColor = 9
		player:refresh()
		player:sendAnimation(103, 5)
		player:removeItem("ancient_potion", 1)
	end
}

autumn_potion = {
	use = function(player)
		player.armorColor = 7
		player:refresh()
		player:sendAnimation(103, 5)
		player:removeItem("autumn_potion", 1)
	end
}

blood_potion = {
	use = function(player)
		player.armorColor = 4
		player:refresh()
		player:sendAnimation(103, 5)
		player:removeItem("blood_potion", 1)
	end
}

earth_potion = {
	use = function(player)
		player.armorColor = 6
		player:refresh()
		player:sendAnimation(103, 5)
		player:removeItem("earth_potion", 1)
	end
}

ruby_potion = {
	use = function(player)
		player.armorColor = 118
		player:refresh()
		player:sendAnimation(103, 5)
		player:removeItem("ruby_potion", 1)
	end
}
sea_potion = {
	use = function(player)
		player.armorColor = 45
		player:refresh()
		player:sendAnimation(103, 5)
		player:removeItem("sea_potion", 1)
	end
}

summer_potion = {
	use = function(player)
		player.armorColor = 1
		player:refresh()
		player:sendAnimation(103, 5)
		player:removeItem("summer_potion", 1)
	end
}

winter_potion = {
	use = function(player)
		player.armorColor = 2
		player:refresh()
		player:sendAnimation(103, 5)
		player:removeItem("winter_potion", 1)
	end
}
