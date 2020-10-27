furious_charge = {
	cast = function(player)
		local m = player.m
		local x = player.x
		local y = player.y
		local s = player.side
		local distance = 5
		local target
		local damage = ((player.might + player.grace) * player.enchant) * player.rage
		local magic = math.floor(player.baseMagic *.05)

		if (not player:canCast(0, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("No will, no way.")
			return
		end
		if (player.gmLevel == 0) then
			player.magic = player.magic - magic
			player:setAether("furious_charge", 24000)
			player:sendStatus()
		end

		local cx = -1
		local cy = 0

		if (s == 0) then
			cx = 0
			cy = -1
		elseif (s == 1) then
			cx = 1
			cy = 0
		elseif (s == 2) then
			cx = 0
			cy = 1
		end

		for i = 1, 6 do
			local cpp = getPass(m, x + (i * cx), y + (i * cy))
			local pcs = player:getObjectsInCell(
				m,
				x + (i * cx),
				y + (i * cy),
				BL_PC
			)
			local mns = player:getObjectsInCell(
				m,
				x + (i * cx),
				y + (i * cy),
				BL_MOB
			)
			distance = i - 1
			if (cpp ~= 0) then
				break
			elseif (#mns > 0) then
				target = player:getObjectsInCell(
					m,
					x + (i * cx),
					y + (i * cy),
					BL_MOB
				)
				break
			elseif (#pcs > 0) then
				target = player:getObjectsInCell(
					m,
					x + (i * cx),
					y + (i * cy),
					BL_PC
				)
				break
			end
		end

		if (distance > 0) then
			for f = 1, distance do
				player:warp(m, x + (f * cx), y + (f * cy))
			end
			for f = 1, distance do
				player:sendAnimationXY(172, x + (f * cx), y + (f * cy))
			end
			damage = damage * distance
		end

		if (#target > 0) then
			for i = 1, #target do
				if (target[i].blType == BL_MOB) then
					target[i].attacker = player.ID
					player:addThreat(target[i].ID, damage)
					player:talk(2, "Rraaa~~~!!!!!")
					player:playSound(247)
					player:sendAction(1, 20)
					target[i]:sendAnimation(396)
					player:sendMinitext("You charge into " .. target[i].name)
					target[i]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
				elseif (player:canPK(target[i])) then
					target[i].attacker = player.ID
					player:talk(2, "Rraaa~~~!!!!!")
					player:playSound(247)
					player:sendAction(1, 20)
					target[i]:sendAnimation(396)
					player:sendMinitext("You charge into " .. target[i].name)
					target[i]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
					target[i]:sendStatus()
				elseif (target[i].blType == BL_PC) then
					player:talk(2, "Rraaa~~~!!!!!")
					player:sendAction(1, 20)
					target[i]:sendAnimation(396)
					player:sendMinitext("You should watch where you're going.")
				end
			end
		end
	end,

	requirements = function(player)
		local l = 99
		local i = {}
		local ia = {}
		local d = "Brutally charge your opponent head on."
		return l, i, ia, d
	end
}
