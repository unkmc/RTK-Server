sonhi_rage = {
	cast = function(player)
		if (not player:canCast(1, 1, 0)) then
			return
		end
		local anim = 104
		local act = 18
		local aethers = 115000
		local duration = 938000

		if player.gmLevel ~= 0 then
			aethers = 0
		end

		player:removeDuras(lesserFuries)

		if (player:hasDuration("sonhi_rage") and player.rage == 6) then
			-- cast rage2
			if (player.magic < 10000) then
				player:sendMinitext("Your will is too weak.")
				return
			end

			player.rage = 9
			player.magic = player.magic - 10000
			player:sendAction(act, 35)
			player:sendAnimation(anim)
			player:playSound(705)
			player:sendMinitext("[Rage 2] Sonhi's rage grows within you.")

			player.registry["sonhiragelevel"] = 2
			player:setAether("sonhi_rage", aethers)

			player:calcStat()
		elseif (player:hasDuration("sonhi_rage") and player.rage == 9) then
			-- cast rage3
			if (player.magic < 22000) then
				player:sendMinitext("Your will is too weak.")
				return
			end

			player.rage = 12
			player.magic = player.magic - 22000
			player:sendAction(act, 35)
			player:sendAnimation(anim)
			player:playSound(705)
			player:sendMinitext("[Rage 3] Sonhi's rage inspires you.")
			player.registry["sonhiragelevel"] = 3
			player:setAether("sonhi_rage", aethers)
			player:calcStat()
		elseif (player:hasDuration("sonhi_rage") and player.rage == 12) then
			-- cast rage4
			if (player.magic < 38000) then
				player:sendMinitext("Your will is too weak.")
				return
			end

			player.rage = 18
			player.magic = player.magic - 38000
			player:sendAction(act, 35)
			player:sendAnimation(anim)
			player:playSound(705)
			player:sendMinitext("[Rage 4] Your body trembles with incredible strength.")
			player.registry["sonhiragelevel"] = 4
			player:setAether("sonhi_rage", aethers)
			player:calcStat()
		elseif (player:hasDuration("sonhi_rage") and player.rage == 18) then
			-- cast rage5
			if (player.magic < 78000) then
				player:sendMinitext("Your will is too weak.")
				return
			end

			player.rage = 27
			player.magic = player.magic - 78000
			player:sendAction(act, 35)
			player:sendAnimation(anim)
			player:playSound(705)
			player:sendMinitext("[Rage 5] You enter a mindless frenzy.")
			player.registry["sonhiragelevel"] = 5
			player:setAether("sonhi_rage", aethers)
			player:calcStat()
		elseif (player:hasDuration("sonhi_rage") and player.rage == 27) then
			-- cast rage6
			if (player.magic < 150000) then
				player:sendMinitext("Your will is too weak.")
				return
			end

			player.rage = 50
			player.magic = player.magic - 150000
			player:sendAction(act, 35)
			player:sendAnimation(anim)
			player:playSound(705)
			player:sendMinitext("[Rage 6] Your body is torn apart with Sonhi's rage.")
			player.registry["sonhiragelevel"] = 6
			player:setAether("sonhi_rage", aethers)
			player:calcStat()
		elseif (player:hasDuration("sonhi_rage") == false) then
			if (player.magic < 3000) then
				player:sendMinitext("Your will is too weak.")
				return
			end

			player:removeDuras(furies)
			player.rage = 6
			player.magic = player.magic - 3000
			player:sendAction(act, 35)
			player:sendAnimation(anim)
			player:playSound(705)
			player.registry["sonhiragelevel"] = 1

			-- setting this to calculate the end ac and vita
			player:setDuration("sonhi_rage", duration)
			player:setAether("sonhi_rage", aethers)
			player:sendMinitext("[Rage 1] You cast Chung Ryong's rage.")
			player:calcStat()
		end
	end,

	recast = function(player)
		-- added to handle if player dc and/or logs off and back on

		local rage = 1
		local armor = 0

		if (player.registry["sonhiragelevel"] == 1) then
			rage = 6
		end
		if (player.registry["sonhiragelevel"] == 2) then
			rage = 9
			armor = 5
		end
		if (player.registry["sonhiragelevel"] == 3) then
			rage = 12
			armor = 10
		end
		if (player.registry["sonhiragelevel"] == 4) then
			rage = 18
			armor = 15
		end
		if (player.registry["sonhiragelevel"] == 5) then
			rage = 27
			armor = 20
		end
		if (player.registry["sonhiragelevel"] == 6) then
			rage = 50
			armor = 25
		end

		player.rage = rage
		player.armor = player.armor + armor
		player:sendStatus()
	end,

	uncast = function(player)
		player.rage = 1
		if (player.registry["sonhiragelevel"] == 1) then
			player.health = player.health *.8
		end
		if (player.registry["sonhiragelevel"] == 2) then
			player.health = player.health *.8
			player.armor = player.armor - 5
		end
		if (player.registry["sonhiragelevel"] == 3) then
			player.health = player.health *.8
			player.armor = player.armor - 10
		end
		if (player.registry["sonhiragelevel"] == 4) then
			player.health = player.health *.6
			player.armor = player.armor - 15
		end
		if (player.registry["sonhiragelevel"] == 5) then
			player.health = player.health *.4
			player.armor = player.armor - 20
		end
		if (player.registry["sonhiragelevel"] == 6) then
			player.health = player.health *.1
			player.armor = player.armor - 25
		end
		player.registry["sonhiragelevel"] = 0
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
		local description = "A basic elemental attack."
		return level, items, itemAmounts, description
	end
}
