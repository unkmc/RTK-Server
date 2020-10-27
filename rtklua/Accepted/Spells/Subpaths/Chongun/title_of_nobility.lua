title_of_nobility = {
	cast = async(function(player)
		local magic = 25

		if os.time() < player.registry["title_of_nobility_timer"] then
			player:msg(
				0,
				"You must wait " .. playerTimerValues(
					player,
					"title_of_nobility_timer"
				) .. " before giving another title.",
				player.ID
			)

			--player:msg(0,"You must wait the full 4 hours before giving another title.",player.ID)
			return
		end

		local name = player:inputLetterCheck(player:input("Whom would you like to bestow a title?"))

		if Player(name) == nil then
			player:sendMinitext("That player is either not online or unable to be found.")
			return
		end

		--[[if Player(name).gmLevel ~= 0 then
			player:sendMinitext("That player is either not online or unable to be found.")
			return
		end]]
		--

		local title = player:inputLetterCheck(player:input("What would you choose the title to be?"))

		if string.len(title) > 16 then
			player:dialog(
				"Your entered title must be no greater than 16 characters.",
				{}
			)
			return
		end

		Player(name).title = title
		Player(name):sendStatus()
		Player(name):msg(
			0,
			"Chongun " .. player.name .. " has bestowed upon you a new title.",
			Player(name).ID
		)

		player.registry["title_of_nobility_timer"] = os.time() + (60 * 60 * 4)
		player:sendMinitext("It is done.")
	end),

	uncast = function(player)
	end,
	requirements = function(player)
		local level = 99
		local items = {"earth_scale_mail", "boiled_meat", 0}
		local itemAmounts = {1, 1, 10000}
		local description = "Bring a troop from the ranks."
		return level, items, itemAmounts, description
	end
}
