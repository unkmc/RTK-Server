chung_ryongs_rage = {
	cast = function(player)
		if (not player:canCast(1, 1, 0)) then
			return
		end

		local aethers = 120000
		local duration = 938000

		if player.gmLevel ~= 0 then
			aethers = 0
		end

		player:removeDuras(lesserFuries)

		if (player:hasDuration("chung_ryongs_rage") == true and player.rage == 8) then
			-- cast rage2
			if (player.magic < 7200) then
				player:sendMinitext("You do not have enough mana.")
				return
			end

			player.rage = 14
			player.magic = player.magic - 7200
			player:sendAnimation(36)
			player:playSound(705)
			player:sendMinitext("[Rage 2] Chung Ryong's power grows within you.")
			player:sendAction(6, 35)
			player.registry["chungryongragelevel"] = 2
			player:setAether("chung_ryongs_rage", aethers)

			player:calcStat()
		elseif (player:hasDuration("chung_ryongs_rage") == true and player.rage == 14) then
			-- cast rage3
			if (player.magic < 18050) then
				player:sendMinitext("You do not have enough mana.")
				return
			end

			player.rage = 20
			player.magic = player.magic - 18050
			player:sendAnimation(36)
			player:playSound(705)
			player:sendMinitext("[Rage 3] Great rage inspires you.")
			player.registry["chungryongragelevel"] = 3
			player:setAether("chung_ryongs_rage", aethers)

			player:sendAction(6, 35)

			--player.armor = player.armor + 5
			player:calcStat()
		elseif (player:hasDuration("chung_ryongs_rage") == true and player.rage == 20) then
			-- cast rage4
			if (player.magic < 33800) then
				player:sendMinitext("You do not have enough mana.")
				return
			end

			player.rage = 26
			player.magic = player.magic - 33800
			player:sendAnimation(36)
			player:playSound(705)
			player:sendMinitext("[Rage 4] Your body trembles with incredible strength.")
			player:sendAction(6, 35)
			player.registry["chungryongragelevel"] = 4
			player:setAether("chung_ryongs_rage", aethers)

			--player.armor = player.armor + 15
			player:calcStat()
		elseif (player:hasDuration("chung_ryongs_rage") == true and player.rage == 26) then
			-- cast rage5
			if (player.magic < 72200) then
				player:sendMinitext("You do not have enough mana.")
				return
			end

			player.rage = 36
			player.magic = player.magic - 72200
			player:sendAnimation(36)
			player:playSound(705)
			player:sendMinitext("[Rage 5] You enter a mindless frenzy.")
			player:sendAction(6, 35)
			player.registry["chungryongragelevel"] = 5
			player:setAether("chung_ryongs_rage", aethers)

			--player.armor = player.armor + 30
			player:calcStat()
		elseif (player:hasDuration("chung_ryongs_rage") == true and player.rage == 36) then
			-- cast rage6
			if (player.magic < 145800) then
				player:sendMinitext("You do not have enough mana.")
				return
			end

			player.rage = 81

			--player.magic = player.magic - 145800
			player.magic = 0
			player:sendAnimation(36)
			player:playSound(705)
			player:sendMinitext("[Rage 6] Your body is torn apart with Chung Ryong's power.")
			player:sendAction(6, 35)
			player.registry["chungryongragelevel"] = 6
			player:setAether("chung_ryongs_rage", aethers)

			--player.armor = player.armor + 50
			player:calcStat()
		elseif (player:hasDuration("chung_ryongs_rage") == false) then
			if (player.magic < 2000) then
				player:sendMinitext("You do not have enough mana.")
				return
			end

			player:removeDuras(furies)
			player.rage = 8
			player.magic = player.magic - 2000
			player:sendAnimation(36)
			player:playSound(705)
			player.registry["chungryongragelevel"] = 1

			-- setting this to calculate the end ac and vita
			player:setDuration("chung_ryongs_rage", duration)
			player:setAether("chung_ryongs_rage", aethers)
			player:sendMinitext("[Rage 1] You cast Chung Ryong's rage.")
			player:sendAction(6, 35)
			player:calcStat()
		end
	end,

	recast = function(player)
		-- added to handle if player dc and/or logs off and back on

		local rage = 1
		local armor = 0

		if (player.registry["chungryongragelevel"] == 1) then
			rage = 8
		end
		if (player.registry["chungryongragelevel"] == 2) then
			rage = 14
		end
		if (player.registry["chungryongragelevel"] == 3) then
			rage = 20
			armor = 5
		end
		if (player.registry["chungryongragelevel"] == 4) then
			rage = 26
			armor = 15
		end
		if (player.registry["chungryongragelevel"] == 5) then
			rage = 36
			armor = 30
		end
		if (player.registry["chungryongragelevel"] == 6) then
			rage = 81
			armor = 50
		end

		player.rage = rage
		player.armor = player.armor + armor
		player:sendStatus()
	end,

	uncast = function(player)
		player.rage = 1
		if (player.registry["chungryongragelevel"] == 1) then
			player.health = player.health *.8
		end
		if (player.registry["chungryongragelevel"] == 2) then
			player.health = player.health *.8
		end
		if (player.registry["chungryongragelevel"] == 3) then
			player.health = player.health *.8
			player.armor = player.armor - 5
		end
		if (player.registry["chungryongragelevel"] == 4) then
			player.health = player.health *.6
			player.armor = player.armor - 15
		end
		if (player.registry["chungryongragelevel"] == 5) then
			player.health = player.health *.4
			player.armor = player.armor - 30
		end
		if (player.registry["chungryongragelevel"] == 6) then
			player.health = player.health *.1
			player.armor = player.armor - 50
		end
		player.registry["chungryongragelevel"] = 0
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {
			Item("spike").id,
			Item("chung_ryong_key").id,
			Item("dragons_liver").id,
			0
		}
		local itemAmounts = {1, 1, 1, 50000}
		local description = "Fury with incremental power increase."

		if (Config.freeNpcSubpathsEnabled) then
			items = {}
			itemAmounts = {}
		end

		return level, items, itemAmounts, description
	end
}
