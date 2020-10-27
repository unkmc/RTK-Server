click = {
	menu = async(function(player, target)
		local name = "<b>[" .. target.name .. "]\n<b>" .. target.className .. " (Lv: " .. target.level .. ")\n<b>------------------------"

		local choice = player:menuString(name, {"Duel"}, {})

		if choice == "Duel" then
			duel_request.click(player, target)
		end
	end)
}
