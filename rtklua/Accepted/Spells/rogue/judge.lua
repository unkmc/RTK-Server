judge_rogue = {
	cast = function(player, target)
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if target.level >= player.level then
			player:sendMinitext("Target player must be lower level than you for you to use this spell")
			return
		end

		local popupText = ""

		if (target.class < 5) then
			popupText = popupText .. target.className .. " " .. target.name
		elseif (target.class > 5) then
			popupText = popupText .. target.classNameMark .. " " .. target.name
		else
			return
		end

		popupText = popupText .. "     Level " .. target.level .. "\n"

		if (player.title ~= "") then
			popupText = popupText .. target.title .. "\n"
		else
			popupText = popupText .. "\n"
		end

		popupText = popupText .. "Might: " .. target.might .. " Will: " .. target.will .. " Grace: " .. target.grace .. "\n"
		player:sendAnimation(12)
		player:popUp(popupText)
	end,

	requirements = function(player)
		local level = 17
		local items = {Item("acorn").id, Item("snake_meat").id, 0}
		local itemAmounts = {70, 30, 150}
		local description = "Shows a target person's strength, will, and grace as well as their level and title. Only works on players lower than your level, or on anyone if you are level 99."
		return level, items, itemAmounts, description
	end
}

spiritual_advisor_rogue = {
	cast = function(player, target)
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if target.level >= player.level then
			player:sendMinitext("Target player must be lower level than you for you to use this spell")
			return
		end

		local popupText = ""

		if (target.class < 5) then
			popupText = popupText .. target.className .. " " .. target.name
		elseif (target.class > 5) then
			popupText = popupText .. target.classNameMark .. " " .. target.name
		else
			return
		end

		popupText = popupText .. "     Level " .. target.level .. "\n"

		if (player.title ~= "") then
			popupText = popupText .. target.title .. "\n"
		else
			popupText = popupText .. "\n"
		end

		popupText = popupText .. "Might: " .. target.might .. " Will: " .. target.will .. " Grace: " .. target.grace .. "\n"
		player:sendAnimation(12)
		player:popUp(popupText)
	end,

	requirements = function(player)
		local level = 17
		local items = {Item("acorn").id, Item("snake_meat").id, 0}
		local itemAmounts = {70, 30, 150}
		local description = "Shows a target person's strength, will, and grace as well as their level and title. Only works on players lower than your level, or on anyone if you are level 99."
		return level, items, itemAmounts, description
	end
}

natural_talent_rogue = {
	cast = function(player, target)
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if target.level >= player.level then
			player:sendMinitext("Target player must be lower level than you for you to use this spell")
			return
		end

		local popupText = ""

		if (target.class < 5) then
			popupText = popupText .. target.className .. " " .. target.name
		elseif (target.class > 5) then
			popupText = popupText .. target.classNameMark .. " " .. target.name
		else
			return
		end

		popupText = popupText .. "     Level " .. target.level .. "\n"

		if (player.title ~= "") then
			popupText = popupText .. target.title .. "\n"
		else
			popupText = popupText .. "\n"
		end

		popupText = popupText .. "Might: " .. target.might .. " Will: " .. target.will .. " Grace: " .. target.grace .. "\n"
		player:sendAnimation(12)
		player:popUp(popupText)
	end,

	requirements = function(player)
		local level = 17
		local items = {Item("acorn").id, Item("snake_meat").id, 0}
		local itemAmounts = {70, 30, 150}
		local description = "Shows a target person's strength, will, and grace as well as their level and title. Only works on players lower than your level, or on anyone if you are level 99."
		return level, items, itemAmounts, description
	end
}

appraise_rogue = {
	cast = function(player, target)
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if target.level >= player.level then
			player:sendMinitext("Target player must be lower level than you for you to use this spell")
			return
		end

		local popupText = ""

		if (target.class < 5) then
			popupText = popupText .. target.className .. " " .. target.name
		elseif (target.class > 5) then
			popupText = popupText .. target.classNameMark .. " " .. target.name
		else
			return
		end

		popupText = popupText .. "     Level " .. target.level .. "\n"

		if (player.title ~= "") then
			popupText = popupText .. target.title .. "\n"
		else
			popupText = popupText .. "\n"
		end

		popupText = popupText .. "Might: " .. target.might .. " Will: " .. target.will .. " Grace: " .. target.grace .. "\n"
		player:sendAnimation(12)
		player:popUp(popupText)
	end,

	requirements = function(player)
		local level = 17
		local items = {Item("acorn").id, Item("snake_meat").id, 0}
		local itemAmounts = {70, 30, 150}
		local description = "Shows a target person's strength, will, and grace as well as their level and title. Only works on players lower than your level, or on anyone if you are level 99."
		return level, items, itemAmounts, description
	end
}
