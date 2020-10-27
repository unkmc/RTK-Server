name_change_voucher = {
	use = async(function(player)
		local item = player:getInventoryItem(player.invSlot)
		local oldName = player.name

		local t = {graphic = item.icon, color = item.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		if not player:canCast(1, 1, 0) then
			player:sendMinitext("You can't use this.")
			return
		end

		local name = player:inputLetterCheck(player:input("What do you want your name to be called?"))

		if string.len(name) < 3 then
			player:dialogSeq(
				{t, "You cannot enter a name shorter than 3 characters."},
				0
			)
			return
		end
		if string.len(name) > 12 then
			player:dialogSeq(
				{t, "You cannot enter a name longer than 12 characters."},
				0
			)
			return
		end

		local nameCheck = getOfflineID(name)

		if nameCheck ~= false then
			player:dialogSeq(
				{t, "Name already exists. Please try a different name."},
				0
			)
			return
		end

		local confirm = player:menuSeq(
			"Are you sure you want " .. name .. " to be your new name?",
			{"Yes", "No"},
			{}
		)

		if confirm == 1 then
			if player:hasItem("name_change_voucher", 1) ~= true then
				player:dialogSeq({t, "You are missing the voucher."}, 0)
				return
			end

			player:removeItem("name_change_voucher", 1)
			player.name = name
			player:updateState()
			player:updateMail(oldName)
			characterLog.nameChangeWrite(player, oldName)

			player:dialogSeq({t, "Please relog to update your character."}, 0)
		end
	end)
}
