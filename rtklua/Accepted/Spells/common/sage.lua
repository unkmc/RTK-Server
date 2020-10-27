share_wisdom = {
	on_learn = function(player)
		if player:hasSpell("share_wisdom") then
			player:removeSpell("share_wisdom")
		end
		if player:hasSpell("mentors_wisdom") then
			player:removeSpell("mentors_wisdom")
		end
		if player:hasSpell("apprentices_wisdom") then
			player:removeSpell("apprentices_wisdom")
		end
		if player:hasSpell("adepts_wisdom") then
			player:removeSpell("adepts_wisdom")
		end
		if player:hasSpell("sages_wisdom") then
			player:removeSpell("sages_wisdom")
		end
	end,

	cast = async(function(player)
		local magic = 10
		local aethers = 900000

		-- 15mins
		if (not player:canCast(0, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local text = player.question

		if (text ~= "" or text == nil) then
			broadcast(-1, "[" .. player.name .. "]: " .. text)
			player:setAether("share_wisdom", aethers)
			characterLog.sage(player, player.question)
		end

		player.magic = player.magic - magic
		player:sendStatus()
	end),

	requirements = function(player)
		local level = 50
		local item = {0}
		local amounts = {25000}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "This spell is the first of 5 attainable levels of Sage."
		return level, item, amounts, desc
	end
}

mentors_wisdom = {
	on_learn = function(player)
		if player:hasSpell("share_wisdom") then
			player:removeSpell("share_wisdom")
		end
		if player:hasSpell("mentors_wisdom") then
			player:removeSpell("mentors_wisdom")
		end
		if player:hasSpell("apprentices_wisdom") then
			player:removeSpell("apprentices_wisdom")
		end
		if player:hasSpell("adepts_wisdom") then
			player:removeSpell("adepts_wisdom")
		end
		if player:hasSpell("sages_wisdom") then
			player:removeSpell("sages_wisdom")
		end
	end,

	cast = async(function(player)
		local magic = 50
		local aethers = 600000

		-- 10mins
		if (not player:canCast(0, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local text = player.question

		if (text ~= "" or text == nil) then
			broadcast(-1, "[" .. player.name .. "]: " .. text)
			player:setAether("mentors_wisdom", aethers)
			characterLog.sage(player, player.question)
		end

		player.magic = player.magic - magic
		player:sendStatus()
	end),

	requirements = function(player)
		local level = 90
		local item = {0}
		local amounts = {100000}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "This spell is the second of 5 attainable levels of Sage."
		return level, item, amounts, desc
	end
}

apprentices_wisdom = {
	on_learn = function(player)
		if player:hasSpell("share_wisdom") then
			player:removeSpell("share_wisdom")
		end
		if player:hasSpell("mentors_wisdom") then
			player:removeSpell("mentors_wisdom")
		end
		if player:hasSpell("apprentices_wisdom") then
			player:removeSpell("apprentices_wisdom")
		end
		if player:hasSpell("adepts_wisdom") then
			player:removeSpell("adepts_wisdom")
		end
		if player:hasSpell("sages_wisdom") then
			player:removeSpell("sages_wisdom")
		end
	end,

	cast = async(function(player)
		local magic = 100
		local aethers = 300000

		-- 5mins
		if (not player:canCast(0, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local text = player.question

		if (text ~= "" or text == nil) then
			broadcast(-1, "[" .. player.name .. "]: " .. text)
			player:setAether("apprentices_wisdom", aethers)
			characterLog.sage(player, player.question)
		end

		player.magic = player.magic - magic
		player:sendStatus()
	end),

	requirements = function(player)
		local level = 90
		local item = {0}
		local amounts = {100000}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "This spell is the third of 5 attainable levels of Sage."
		return level, item, amounts, desc
	end
}

adepts_wisdom = {
	on_learn = function(player)
		if player:hasSpell("share_wisdom") then
			player:removeSpell("share_wisdom")
		end
		if player:hasSpell("mentors_wisdom") then
			player:removeSpell("mentors_wisdom")
		end
		if player:hasSpell("apprentices_wisdom") then
			player:removeSpell("apprentices_wisdom")
		end
		if player:hasSpell("adepts_wisdom") then
			player:removeSpell("adepts_wisdom")
		end
		if player:hasSpell("sages_wisdom") then
			player:removeSpell("sages_wisdom")
		end
	end,

	cast = async(function(player)
		local magic = 250
		local aethers = 150000

		-- 2.5mins
		if (not player:canCast(0, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local text = player.question

		if (text ~= "" or text == nil) then
			broadcast(-1, "[" .. player.name .. "]: " .. text)
			player:setAether("adepts_wisdom", aethers)
			characterLog.sage(player, player.question)
		end

		player.magic = player.magic - magic
		player:sendStatus()
	end),

	requirements = function(player)
		local level = 90
		local item = {0}
		local amounts = {100000}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "This spell is the 4th of 5 attainable levels of Sage."
		return level, item, amounts, desc
	end
}

sages_wisdom = {
	on_learn = function(player)
		if player:hasSpell("share_wisdom") then
			player:removeSpell("share_wisdom")
		end
		if player:hasSpell("mentors_wisdom") then
			player:removeSpell("mentors_wisdom")
		end
		if player:hasSpell("apprentices_wisdom") then
			player:removeSpell("apprentices_wisdom")
		end
		if player:hasSpell("adepts_wisdom") then
			player:removeSpell("adepts_wisdom")
		end
		if player:hasSpell("sages_wisdom") then
			player:removeSpell("sages_wisdom")
		end
	end,

	cast = async(function(player)
		local magic = 300
		local aethers = 60000

		-- 1mins
		if (not player:canCast(0, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local text = player.question

		if (text ~= "" or text == nil) then
			broadcast(-1, "[" .. player.name .. "]: " .. text)
			player:setAether("sages_wisdom", aethers)
			characterLog.sage(player, player.question)
		end

		player.magic = player.magic - magic
		player:sendStatus()
	end),

	requirements = function(player)
		local level = 90
		local item = {0}
		local amounts = {100000}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "This spell is the last of 5 attainable levels of Sage."
		return level, item, amounts, desc
	end
}
