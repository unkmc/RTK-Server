set_bladestorm_trap = {
	cast = function(player)
		local magic = 1520
		if player.gmLevel > 0 then
			aether = 0
		end
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end
		player.registry["bladestorm"] = 1
		player:addNPC(
			"BladestormTrapNpc",
			player.m,
			player.x,
			player.y,
			2,
			1000,
			21000,
			player.ID
		)
		player:setAether("set_bladestorm_trap", 125000)
		player.magic = player.magic - magic
		player:playSound(0)
		player:sendStatus()
		player:sendAction(6, 35)
		player:sendMinitext("You set a trap!")
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {200000}
		local description = "Sets a powerful trap."
		return level, items, itemAmounts, description
	end
}

set_swords_dance_trap = {
	cast = function(player)
		local magic = 1520
		if player.gmLevel > 0 then
			aether = 0
		end
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end
		player.registry["bladestorm"] = 1
		player:addNPC(
			"BladestormTrapNpc",
			player.m,
			player.x,
			player.y,
			2,
			1000,
			21000,
			player.ID
		)
		player:setAether("set_swords_dance_trap", 125000)
		player.magic = player.magic - magic
		player:playSound(0)
		player:sendStatus()
		player:sendAction(6, 35)
		player:sendMinitext("You set a trap!")
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {200000}
		local description = "Sets a powerful trap."
		return level, items, itemAmounts, description
	end
}

set_tigers_ambush_trap = {
	cast = function(player)
		local magic = 1520
		if player.gmLevel > 0 then
			aether = 0
		end
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end
		player.registry["bladestorm"] = 1
		player:addNPC(
			"BladestormTrapNpc",
			player.m,
			player.x,
			player.y,
			2,
			1000,
			21000,
			player.ID
		)
		player:setAether("set_tigers_ambush_trap", 125000)
		player.magic = player.magic - magic
		player:playSound(0)
		player:sendStatus()
		player:sendAction(6, 35)
		player:sendMinitext("You set a trap!")
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {200000}
		local description = "Sets a powerful trap."
		return level, items, itemAmounts, description
	end
}

set_cutting_edge_trap = {
	cast = function(player)
		local magic = 1520
		if player.gmLevel > 0 then
			aether = 0
		end
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end
		player.registry["bladestorm"] = 1
		player:addNPC(
			"BladestormTrapNpc",
			player.m,
			player.x,
			player.y,
			2,
			1000,
			21000,
			player.ID
		)
		player:setAether("set_cutting_edge_trap", 125000)
		player.magic = player.magic - magic
		player:playSound(0)
		player:sendStatus()
		player:sendAction(6, 35)
		player:sendMinitext("You set a trap!")
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {200000}
		local description = "Sets a powerful trap."
		return level, items, itemAmounts, description
	end
}
