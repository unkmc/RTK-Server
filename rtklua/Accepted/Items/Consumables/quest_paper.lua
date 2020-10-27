quest_paper = {
	use = function(player)
		--local width = 20
		--local height = 15

		local width = 15
		local height = 20

		local item = player:getInventoryItem(player.invSlot)

		player:paperpopup(width, height, item.note)
	end
}
