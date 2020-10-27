recover_mage = {
	cast = function(player, target)
		local spellName = "Recover"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 200, 100, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 32
		local items = {
			Item("gold_acorn").id,
			Item("antler").id,
			Item("ginseng").id,
			0
		}
		local itemAmounts = {1, 20, 1, 200}
		local description = "a healing spell that allows you to heal others for 200 Vita"
		return level, items, itemAmounts, description
	end
}

spirits_embrace_mage = {
	cast = function(player, target)
		local spellName = "Spirit's Embrace"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 200, 100, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 32
		local items = {
			Item("gold_acorn").id,
			Item("antler").id,
			Item("ginseng").id,
			0
		}
		local itemAmounts = {1, 20, 1, 200}
		local description = "a healing spell that allows you to heal others for 200 Vita"
		return level, items, itemAmounts, description
	end
}

infuse_energy_mage = {
	cast = function(player, target)
		local spellName = "Infuse Energy"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 200, 100, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 32
		local items = {
			Item("gold_acorn").id,
			Item("antler").id,
			Item("ginseng").id,
			0
		}
		local itemAmounts = {1, 20, 1, 200}
		local description = "a healing spell that allows you to heal others for 200 Vita"
		return level, items, itemAmounts, description
	end
}

lifes_river_mage = {
	cast = function(player, target)
		local spellName = "Life's River"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 200, 100, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 32
		local items = {
			Item("gold_acorn").id,
			Item("antler").id,
			Item("ginseng").id,
			0
		}
		local itemAmounts = {1, 20, 1, 200}
		local description = "a healing spell that allows you to heal others for 200 Vita"
		return level, items, itemAmounts, description
	end
}
