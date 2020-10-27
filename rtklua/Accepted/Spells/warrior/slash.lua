slash_warrior = {
	cast = function(player, target)
		local d = {}
		local m = player.m
		local x = player.x
		local y = player.y
		local sound = 60

		local magic = 60
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local damage = math.ceil((player.health *.0245) + (player.might * 11.435))

		if player:hasDuration("chin_baek_ho_ryung") then
			damage = math.ceil(damage * 1.5)
		end

		local endvita = math.floor(player.health * 0.90)
		player.magic = player.magic - 180

		if (player.side == 0) then
			y = y - 1
		end
		if (player.side == 1) then
			x = x + 1
		end
		if (player.side == 2) then
			y = y + 1
		end
		if (player.side == 3) then
			x = x - 1
		end

		d = player:getObjectsInCell(m, x, y, BL_MOB)
		e = player:getAliveObjectsInCell(m, x, y, BL_PC)
		local alive = {}
		if (#e > 0) then
			for z = 1, #e do
				if (e[z].state ~= 1) then
					table.insert(alive, "" .. e[z].ID .. "")
				end
			end
		end
		if (#d > 0) then
			if (d[1].blType == BL_MOB) then
				d[1]:sendAnimation(31)
				d[1].attacker = player.ID
				d[1]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
				player:addThreat(d[1].ID, damage)
				player.health = endvita

				-- added 5/29 supposed to take vita in both situations if you hit target
				player:sendStatus()
			end
		end
		if (#e > 0 and #alive > 0) then
			if (player.pvp > 0) then
				for z = 1, #alive do
					Player(alive[z]):sendMinitext(player.name .. " casts Slash on you.")
					Player(alive[z]).attacker = player.ID
					if (player.group[1] == Player(alive[z]).group[1]) then
					else
						Player(alive[z]):sendAnimation(31)
						Player(alive[z]):removeHealthExtend(
							damage,
							1,
							1,
							1,
							1,
							0
						)
					end
				end
				player.health = endvita
				player:sendStatus()
			else
				e[1]:sendAnimation(31)
			end
		end

		player:sendStatus()
		player:sendAction(1, 30)
		player:playSound(sound)
		player:sendMinitext("You cast Slash.")
		player:setAether("slash_warrior", 1000)
	end,
	requirements = function(player)
		local l = 22
		local i = {
			Item("tigers_heart").id,
			Item("mountain_ginseng").id,
			Item("antler").id,
			0
		}
		local ia = {5, 1, 5, 1000}
		local d = "A quick attack that deals damage to your enemy."
		return l, i, ia, d
	end
}
