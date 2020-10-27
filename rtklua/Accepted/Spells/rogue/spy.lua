spy_rogue = {
	cast = function(player, target)
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		if target.level > player.level then
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

		popupText = popupText .. "Items: "

		for i = 0, 52 do
			local item = target:getInventoryItem(i)

			if (item ~= nil and item.name ~= "??") then
				popupText = popupText .. item.name .. " "
			end
		end

		player:sendAnimation(12)
		player:popUp(popupText)
	end,

	requirements = function(player)
		local level = 28
		local items = {"acorn", "red_fox_fur", 0}
		local itemAmounts = {100, 15, 200}
		local description = "Shows a target person's strength, will, and grace as well as their level and title. Also shows their inventory. Only works on players lower than your level, or on anyone if you are level 99."
		return level, items, itemAmounts, description
	end
}

spiritual_guide_rogue = {
	cast = function(player, target)
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		if target.level > player.level then
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

		popupText = popupText .. "Items: "

		for i = 0, 52 do
			local item = target:getInventoryItem(i)

			if (item ~= nil and item.name ~= "??") then
				popupText = popupText .. item.name .. " "
			end
		end

		player:sendAnimation(12)
		player:popUp(popupText)
	end,

	requirements = function(player)
		local level = 28
		local items = {"acorn", "red_fox_fur", 0}
		local itemAmounts = {100, 15, 200}
		local description = "Shows a target person's strength, will, and grace as well as their level and title. Also shows their inventory. Only works on players lower than your level, or on anyone if you are level 99."
		return level, items, itemAmounts, description
	end
}

natures_handiwork_rogue = {
	cast = function(player, target)
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		if target.level > player.level then
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

		popupText = popupText .. "Items: "

		for i = 0, 52 do
			local item = target:getInventoryItem(i)

			if (item ~= nil and item.name ~= "??") then
				popupText = popupText .. item.name .. " "
			end
		end

		player:sendAnimation(12)
		player:popUp(popupText)
	end,

	requirements = function(player)
		local level = 28
		local items = {"acorn", "red_fox_fur", 0}
		local itemAmounts = {100, 15, 200}
		local description = "Shows a target person's strength, will, and grace as well as their level and title. Also shows their inventory. Only works on players lower than your level, or on anyone if you are level 99."
		return level, items, itemAmounts, description
	end
}

judgement_day_rogue = {
	cast = function(player, target)
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		if target.level > player.level then
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

		popupText = popupText .. "Items: "

		for i = 0, 52 do
			local item = target:getInventoryItem(i)

			if (item ~= nil and item.name ~= "??") then
				popupText = popupText .. item.name .. " "
			end
		end

		player:sendAnimation(12)
		player:popUp(popupText)
	end,

	requirements = function(player)
		local level = 28
		local items = {"acorn", "red_fox_fur", 0}
		local itemAmounts = {100, 15, 200}
		local description = "Shows a target person's strength, will, and grace as well as their level and title. Also shows their inventory. Only works on players lower than your level, or on anyone if you are level 99."
		return level, items, itemAmounts, description
	end
}
