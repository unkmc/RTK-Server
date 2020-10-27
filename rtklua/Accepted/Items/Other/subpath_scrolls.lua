subpath_scrolls = {
	use = function(player)
		local item = player:getInventoryItem(player.invSlot)

		player:showBoard(item.yname .. "_board")
		player:removeItem(item.yname, 1)
	end,
}

divine_chronicles = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
graced_by_the_muse = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
the_wandering_monk = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
tomes_of_the_earth = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
ranger_code = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
kwanhonsagje = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
barbarian_runes = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
ancient_parchment = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
knowledge_of_wealth = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
spys_journal = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
shu_jing = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
chieko = {
	use = function(player)
		subpath_scrolls.use(player)
	end
}
