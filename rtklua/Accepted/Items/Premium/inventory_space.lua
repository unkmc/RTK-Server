inventory_space = {
	use = async(function(player)
		local maxSlots = 52

		local item = player:getInventoryItem(player.invSlot)

		local t = {graphic = item.icon, color = item.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		if player.maxInv >= maxSlots then
			player:dialogSeq(
				{
					t,
					"You are already at the maximum number of slots, which is " .. maxSlots .. "."
				},
				0
			)
			return
		end

		local confirm = player:menuSeq(
			"Are you sure you want to add 5 additional slots to your inventory?",
			{"Yes, do it.", "Nevermind."},
			{}
		)

		if confirm == 1 then
			if player:hasItem("inventory_space", 1) ~= true then
				return
			end

			player.maxInv = player.maxInv + 5
			player:removeItem("inventory_space", 1, 9)
			player:updateInv()

			player:msg(
				0,
				"5 additional inventory slots has been added to your character.",
				player.ID
			)
			player:msg(
				0,
				"You now have a total of " .. player.maxInv .. " usable inventory slots.",
				player.ID
			)
		end
	end)
}
