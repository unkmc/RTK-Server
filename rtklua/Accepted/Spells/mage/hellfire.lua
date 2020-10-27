hellfire_mage = {
	cast = function(player, target)
		local spellName = "Hellfire"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic * 2.15)

		-- I am increasing this to give mages some more potency in carnages Loki 6/10/19
		local manaTaken = math.floor(player.magic *.7)
		local worked = global_zap.cast(player, target, damage, 1000, 30)
		if worked ~= 0 then
			if player.magic - manaTaken < 0 then
				player.magic = 0
			else
				player.magic = player.magic - manaTaken
			end
			player:setAether("hellfire_mage", 19000)
			player:sendStatus()
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 72
		local items = {
			Item("stardrop").id,
			Item("dark_amber").id,
			Item("star_staff").id,
			0
		}
		local itemAmounts = {10, 10, 1, 9000}
		local description = "Unleash hell...fire."
		return level, items, itemAmounts, description
	end
}

consume_soul_mage = {
	cast = function(player, target)
		local spellName = "Consume Soul"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic * 2.15)

		-- I am increasing this to give mages some more potency in carnages Loki 6/10/19
		local manaTaken = math.floor(player.magic *.7)
		local worked = global_zap.cast(player, target, damage, 1000, 31)
		if worked ~= 0 then
			if player.magic - manaTaken < 0 then
				player.magic = 0
			else
				player.magic = player.magic - manaTaken
			end
			player:setAether("consume_soul_mage", 19000)
			player:sendStatus()
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 72
		local items = {
			Item("stardrop").id,
			Item("dark_amber").id,
			Item("star_staff").id,
			0
		}
		local itemAmounts = {10, 10, 1, 9000}
		local description = "Unleash hell...fire."
		return level, items, itemAmounts, description
	end
}

flesh_eaters_mage = {
	cast = function(player, target)
		local spellName = "Flesh Eaters"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic * 2.15)

		-- I am increasing this to give mages some more potency in carnages Loki 6/10/19
		local manaTaken = math.floor(player.magic *.7)
		local worked = global_zap.cast(player, target, damage, 1000, 32)
		if worked ~= 0 then
			if player.magic - manaTaken < 0 then
				player.magic = 0
			else
				player.magic = player.magic - manaTaken
			end
			player:setAether("flesh_eaters_mage", 19000)
			player:sendStatus()
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 72
		local items = {
			Item("stardrop").id,
			Item("dark_amber").id,
			Item("star_staff").id,
			0
		}
		local itemAmounts = {10, 10, 1, 9000}
		local description = "Unleash hell...fire."
		return level, items, itemAmounts, description
	end
}

hurricane_mage = {
	cast = function(player, target)
		local spellName = "Hurricane"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic * 2.15)

		-- I am increasing this to give mages some more potency in carnages Loki 6/10/19
		local manaTaken = math.floor(player.magic *.7)
		local worked = global_zap.cast(player, target, damage, 1000, 33)
		if worked ~= 0 then
			if player.magic - manaTaken < 0 then
				player.magic = 0
			else
				player.magic = player.magic - manaTaken
			end
			player:setAether("hurricane_mage", 19000)
			player:sendStatus()
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 72
		local items = {
			Item("stardrop").id,
			Item("dark_amber").id,
			Item("star_staff").id,
			0
		}
		local itemAmounts = {10, 10, 1, 9000}
		local description = "Unleash hell...fire."
		return level, items, itemAmounts, description
	end
}
