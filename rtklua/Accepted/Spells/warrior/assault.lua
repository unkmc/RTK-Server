assault_warrior = {
	cast = function(player)
		local x = {}
		local y = {}
		local s = player.side
		local sound = 60
		local magic = 5000
		local spellName = "Assault"
		local damage = math.ceil(player.health / 2)

		if player:hasDuration("chin_baek_ho_ryung") then
			damage = math.ceil(damage * 1.5)
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		if (s == 0) then
			x = {0, -1, 0, 1}
			y = {-1, -2, -2, -2}
		elseif (s == 1) then
			x = {1, 2, 2, 2}
			y = {0, -1, 0, 1}
		elseif (s == 2) then
			x = {0, -1, 0, 1}
			y = {1, 2, 2, 2}
		elseif (s == 3) then
			x = {-1, -2, -2, -2}
			y = {0, 1, 0, -1}
		else
			return
		end
		local landed = 0
		player:sendAction(1, 30)
		player.magic = player.magic - magic

		player:setAether("assault_warrior", 80000)
		player:talk(2, "Assault~!")

		for i = 1, 4 do
			local target = player:getAliveObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_MOB
			)
			if #target > 0 then
				global_attack.cast(player, target[1], damage, 0, 0)
				landed = 1
			end

			target = player:getAliveObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_attack.cast(
					player,
					target[1],
					damage,
					0,
					0
				)
				if worked == 2 then
					target[1]:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
					landed = 1
				end
			end
		end

		if landed == 1 then
			player.health = damage
		end
		player:sendStatus()
		player:playSound(sound)
		player:sendMinitext("You cast " .. spellName .. ".")
	end,
	requirements = function(player)
		local l = 99
		local i = {0}
		local ia = {400000}
		local d = "A large attack that deals damage to an enemy."
		return l, i, ia, d
	end
}

deaths_challenge_warrior = {
	cast = function(player)
		local x = {}
		local y = {}
		local s = player.side
		local sound = 60
		local magic = 5000
		local spellName = "Death's Challenge"
		local damage = math.ceil(player.health / 2)

		if player:hasDuration("chin_baek_ho_ryung") then
			damage = math.ceil(damage * 1.5)
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		if (s == 0) then
			x = {0, -1, 0, 1}
			y = {-1, -2, -2, -2}
		elseif (s == 1) then
			x = {1, 2, 2, 2}
			y = {0, -1, 0, 1}
		elseif (s == 2) then
			x = {0, -1, 0, 1}
			y = {1, 2, 2, 2}
		elseif (s == 3) then
			x = {-1, -2, -2, -2}
			y = {0, 1, 0, -1}
		else
			return
		end
		local landed = 0
		player:sendAction(1, 30)
		player.magic = player.magic - magic

		player:setAether("deaths_challenge_warrior", 80000)
		player:talk(2, "Assault~!")

		for i = 1, 4 do
			local target = player:getAliveObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_MOB
			)
			if #target > 0 then
				global_attack.cast(player, target[1], damage, 0, 127)
				landed = 1
			end

			target = player:getAliveObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_attack.cast(
					player,
					target[1],
					damage,
					0,
					127
				)
				if worked == 2 then
					target[1]:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
					landed = 1
				end
			end
		end
		if landed == 1 then
			player.health = damage
		end
		player:sendStatus()
		player:playSound(sound)
		player:sendMinitext("You cast " .. spellName .. ".")
	end,
	requirements = function(player)
		local l = 99
		local i = {0}
		local ia = {400000}
		local d = "A large attack that deals damage to an enemy."
		return l, i, ia, d
	end
}

cold_snap_warrior = {
	cast = function(player)
		local x = {}
		local y = {}
		local s = player.side
		local sound = 60
		local magic = 5000
		local spellName = "Cold Snap"
		local damage = math.ceil(player.health / 2)

		if player:hasDuration("chin_baek_ho_ryung") then
			damage = math.ceil(damage * 1.5)
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		if (s == 0) then
			x = {0, -1, 0, 1}
			y = {-1, -2, -2, -2}
		elseif (s == 1) then
			x = {1, 2, 2, 2}
			y = {0, -1, 0, 1}
		elseif (s == 2) then
			x = {0, -1, 0, 1}
			y = {1, 2, 2, 2}
		elseif (s == 3) then
			x = {-1, -2, -2, -2}
			y = {0, 1, 0, -1}
		else
			return
		end
		local landed = 0
		player:sendAction(1, 30)
		player.magic = player.magic - magic

		player:setAether("cold_snap_warrior", 80000)
		player:talk(2, "Assault~!")

		for i = 1, 4 do
			local target = player:getAliveObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_MOB
			)
			if #target > 0 then
				global_attack.cast(player, target[1], damage, 0, 126)
				landed = 1
			end

			target = player:getAliveObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_attack.cast(
					player,
					target[1],
					damage,
					0,
					126
				)
				if worked == 2 then
					target[1]:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
					landed = 1
				end
			end
		end
		if landed == 1 then
			player.health = damage
		end
		player:sendStatus()
		player:playSound(sound)
		player:sendMinitext("You cast " .. spellName .. ".")
	end,
	requirements = function(player)
		local l = 99
		local i = {0}
		local ia = {400000}
		local d = "A large attack that deals damage to an enemy."
		return l, i, ia, d
	end
}

volley_warrior = {
	cast = function(player)
		local x = {}
		local y = {}
		local s = player.side
		local sound = 60
		local magic = 5000
		local spellName = "Volley"
		local damage = math.ceil(player.health / 2)

		if player:hasDuration("chin_baek_ho_ryung") then
			damage = math.ceil(damage * 1.5)
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		if (s == 0) then
			x = {0, -1, 0, 1}
			y = {-1, -2, -2, -2}
		elseif (s == 1) then
			x = {1, 2, 2, 2}
			y = {0, -1, 0, 1}
		elseif (s == 2) then
			x = {0, -1, 0, 1}
			y = {1, 2, 2, 2}
		elseif (s == 3) then
			x = {-1, -2, -2, -2}
			y = {0, 1, 0, -1}
		else
			return
		end
		local landed = 0
		player:sendAction(1, 30)
		player.magic = player.magic - magic
		player:setAether("volley_warrior", 80000)
		player:talk(2, "Assault~!")

		for i = 1, 4 do
			local target = player:getAliveObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_MOB
			)
			if #target > 0 then
				global_attack.cast(player, target[1], damage, 0, 3)
				landed = 1
			end

			target = player:getAliveObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_attack.cast(
					player,
					target[1],
					damage,
					0,
					3
				)
				if worked == 2 then
					target[1]:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
					landed = 1
				end
			end
		end
		if landed == 1 then
			player.health = damage
		end
		player:sendStatus()
		player:playSound(sound)
		player:sendMinitext("You cast " .. spellName .. ".")
	end,
	requirements = function(player)
		local l = 99
		local i = {0}
		local ia = {400000}
		local d = "A large attack that deals damage to an enemy."
		return l, i, ia, d
	end
}
