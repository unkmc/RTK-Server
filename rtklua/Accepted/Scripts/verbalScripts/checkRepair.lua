verbalScriptCheckRepair = function(player, npc, speech)
	Tools.configureDialog(player, npc)
	local words = {}
	local itemName = ""

	for word in speech:gmatch("[%w\'%-%[%]]+") do
		table.insert(words, word)
	end

	if (words[1] == "repair") then
		Tools.checkKarma(player)

		if words[2] == "all" then
			player:repairAllNoConfirm(npc)
		else
			for i = 2, #words do
				itemName = itemName .. "" .. words[i]
				if i ~= #words then
					itemName = itemName .. " "
				end
			end
			player:repairItemNoConfirm(npc, itemName)
		end
	end
end
