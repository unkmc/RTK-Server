-- Chongun spell testing

protectors_bulwark = {
	cast = function(player)
		if player:hasDuration("protectors_bulwark") == true then
			player:setDuration("protectors_bulwark", 1)
		else
			local magic = player.baseMagic *.20

			if player.magic < magic then
				player:sendMinitext("Your will is too weak.")
				return
			end
			player.magic = player.magic - magic
			player:setDuration("protectors_bulwark", 625000)
			player:sendAnimation(18)
			player:sendStatus()
		end
	end,
	uncast = function(player)
		player:sendMinitext("Your return to a normal state.")
	end
}

protectors_bulwark_heal = {
	cast = function(player, damage)
		local ratio = 1
		local idsave = 0
		local absx = 0
		local absy = 0
		local dist = 0

		for k = 1, 1 do
			ratio = 1
			idsave = 0

			local ta = player:getObjectsInArea(BL_PC)
			if (#ta > 0) then
				for z = 1, #ta do
					absx = math.abs(player.x - ta[z].x)
					absy = math.abs(player.y - ta[z].y)
					dist = absx + absy

					if (dist <= 7) then
						if (ta[z].state ~= 1) then
							for g = 1, #player.group do
								if (ta[z].ID == player.group[g]) then
									if ((ta[z].health / ta[z].maxHealth) < ratio) then
										ratio = (ta[z].health / ta[z].maxHealth)
										idsave = ta[z].ID
									end
								end
							end
						end
					end
				end
			end

			if (idsave == 0) then
				idsave = player.ID
			end

			--Player(idsave).attacker = player.ID
			local target = Player(idsave)
			if target ~= nil then
				target:addHealth(damage)
				target:sendAnimation(5)
				target:sendStatus()
			end
		end
	end,
}
