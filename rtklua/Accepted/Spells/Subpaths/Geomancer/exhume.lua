exhume = {
	cast = function(player)
		--14
		local duration = 100000
		local aethers = 1250000
		local manaCost = 200

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if player.magic < manaCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:setAether("exhume", aethers)
		player:setDuration("exhume", duration)
	end,

	while_cast = function(player)
		local manaCost = 200
		if player.magic < manaCost then
			player:sendMinitext("Your will is too weak.")
			player:setDuration("exhume", 0)
			return
		end

		player.magic = player.magic - 200
		player:sendStatus()
	end,

	uncast = function(player)
		player.fakeDrop = 0
	end,

	on_drop_while_cast = function(player)
		local item = player:getInventoryItem(player.invSlot)
		local meats = {
			"fox_fur",
			"red_fox_fur",
			"light_fox_fur",
			"bears_liver",
			"rat_meat",
			"antler",
			"beef",
			"rare_pork",
			"rabbit_meat",
			"wool",
			"horse_meat",
			"bone",
			"dragons_tooth",
			"tigers_heart",
			"snake_meat",
			"acorn"
		}
		local mobs = {
			"dummy_fox",
			"dummy_blood_fox",
			"dummy_sun_fox",
			"dummy_bear",
			"dummy_rat",
			"dummy_deer",
			"dummy_bull",
			"dummy_pig",
			"dummy_rabbit",
			"dummy_sheep",
			"dummy_horse",
			"dummy_skeleton",
			"dummy_dragon",
			"dummy_tiger",
			"dummy_snake",
			"dummy_squirrel"
		}

		local meat = ""
		local mob = ""

		for i = 1, #meats do
			if item.yname == meats[i] then
				meat = meats[i]
				mob = mobs[i]
				break
			end
		end

		if meat ~= "" and mob ~= "" then
			-- found mob and item name matches
			player:removeItem(item.yname, 1, 1)
			player.fakeDrop = 1
			player:sendAnimation(14, 1)
			player:spawn(mob, player.x, player.y, 1, player.m)
		else
			player.fakeDrop = 0
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("surge").id, Item("ju_jak_key").id, 0}
		local itemAmounts = {1, 1, 50000}
		local description = "Empower your mind."
		return level, items, itemAmounts, description
	end
}
