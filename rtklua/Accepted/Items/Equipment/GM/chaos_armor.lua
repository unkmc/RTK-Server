chaos_armor = {
	pseudoloot = function(player, runcount)
		local roll = math.random(1, 100000)
		local dropItems = {"flameblade", "spike", "big_axe"}
		local dropChance = {0.025, 2.5, 1}
		local counts = {0, 0, 0}
		local failcounts = {0, 0, 0}
		if runcount == nil then
			runcount = 100000
		end
		for testruns = 1, runcount do
			for i = 1, #dropItems do
				local dimrets = failcounts[i]
				roll = math.random(1, (100000 - dimrets))
				if roll <= dropChance[i] * 1000 then
					counts[i] = counts[i] + 1
					failcounts[i] = 0
				else
					failcounts[i] = failcounts[i] + 1
				end
			end
		end
		player:talk(0, "In " .. runcount .. " runs, dropped:")
		player:talk(
			0,
			"1: " .. dropItems[1] .. " " .. counts[1] .. " base chance " .. dropChance[
				1
			] .. " % " .. (counts[1] / runcount)
		)
		player:talk(
			0,
			"2: " .. dropItems[2] .. " " .. counts[2] .. " base chance " .. dropChance[
				2
			] .. " % " .. (counts[2] / runcount)
		)
		player:talk(
			0,
			"2: " .. dropItems[3] .. " " .. counts[3] .. " base chance " .. dropChance[
				3
			] .. " % " .. (counts[3] / runcount)
		)
	end,
	judgment = function(player)
		local judged = player:getObjectsInMap(player.m, BL_PC)
		if #judged < 1 then
			return
		end
		for j = 1, #judged do
			if judged[j].gmLevel < 1 then
				judged[j]:returnFunc()
			end
		end
	end,
	onEquip = function(player)
		local whodunit = string.lower(player.name)
		if whodunit == "chaos" then
			player.armorColor = 240
		end
		if whodunit == "enigma" then
			player.armorColor = 249
		end
		if whodunit == "loki" then
			player.armorColor = 27
		end
	end,

	on_swing = function(player)
		calculating_blow_rogue.cast(player)
		chaos_armor.while_equipped(player)
	end,

	while_equipped = function(player)
		player.health = player.maxHealth
		player.magic = player.maxMagic
		player.speed = 10
		player.rage = 255
		player.enchant = 255
		player.invis = 255
		player.deduction = 0.1
		player.flank = 1
		player.backstab = 1
		player:flushAether()
		player:sendStatus()
	end
}
