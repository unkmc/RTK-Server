onScriptedTilesPathHalls = function(player)
	local mapName = player.mapTitle
	local m = player.m
	local x = player.x
	local y = player.y
	local baseClass = player.baseClass
	local str = "You are not the right class to enter here."

	----- KUGNAE PATH HALLS-----

	if mapName == "Warrior Tebaek" then
		if ((x == 1 or x == 2) and y == 23) then
			if baseClass == 1 or player.tutor == 1 then
				player:warp(3701, x + 6, 3)
			else
				player:sendMinitext(str)
				player:warp(m, x, y - 2)
			end
		end
		if ((x == 8 or x == 9) and y == 1) then
			if player.alignment == 0 then
				player:warp(12, x - 3, 18)
			elseif player.alignment == 1 then
				player:warp(300, x - 3, 18)

				-- kwi-sin
			elseif player.alignment == 2 then
				player:warp(301, x - 3, 18)

				-- ming-ken
			elseif player.alignment == 3 then
				player:warp(302, x - 3, 18)

				-- ohaeng
			end
		end
	end

	if mapName == "Rogue Maro" then
		if ((x == 1 or x == 2) and y == 23) then
			if baseClass == 2 or player.tutor == 1 then
				player:warp(3702, x + 6, 3)
			else
				player:sendMinitext(str)
				player:warp(m, x, y - 2)
			end
		end
		if ((x == 8 or x == 9) and y == 1) then
			if player.alignment == 0 then
				player:warp(16, x - 3, 18)
			elseif player.alignment == 1 then
				player:warp(312, x - 3, 18)

				-- kwi
			elseif player.alignment == 2 then
				player:warp(313, x - 3, 18)

				-- ming-ken
			elseif player.alignment == 3 then
				player:warp(314, x - 3, 18)

				-- ohaeng
			end
		end
	end

	if mapName == "Mage Haedu" then
		if ((x == 1 or x == 2) and y == 23) then
			if baseClass == 3 or player.tutor == 1 then
				player:warp(3703, x + 6, 3)
			else
				player:sendMinitext(str)
				player:warp(m, x, y - 2)
			end
		end
		if ((x == 8 or x == 9) and y == 1) then
			if player.alignment == 0 then
				player:warp(14, x - 3, 18)
			elseif player.alignment == 1 then
				player:warp(306, x - 3, 18)

				-- kwi
			elseif player.alignment == 2 then
				player:warp(307, x - 3, 18)

				-- ming-ken
			elseif player.alignment == 3 then
				player:warp(308, x - 3, 18)

				-- ohaeng
			end
		end
	end

	if mapName == "Poet Jinsun" then
		if ((x == 1 or x == 2) and y == 23) then
			if baseClass == 4 or player.tutor == 1 then
				player:warp(3704, x + 6, 3)
			else
				player:sendMinitext(str)
				player:warp(m, x, y - 2)
			end
		end
		if ((x == 8 or x == 9) and y == 1) then
			if player.alignment == 0 then
				player:warp(18, x - 3, 18)
			elseif player.alignment == 1 then
				player:warp(318, x - 3, 18)

				-- kwi
			elseif player.alignment == 2 then
				player:warp(319, x - 3, 18)

				-- ming-ken
			elseif player.alignment == 3 then
				player:warp(320, x - 3, 18)

				-- ohaeng
			end
		end
	end

	----- BUYA PATH HALLS-------------

	if mapName == "Warrior Yebaek" then
		if ((x == 1 or x == 2) and y == 23) then
			if baseClass == 1 or player.tutor == 1 then
				player:warp(3705, x + 6, 3)
			else
				player:sendMinitext(str)
				player:warp(m, x, y - 2)
			end
		end
		if ((x == 8 or x == 9) and y == 1) then
			if player.alignment == 0 then
				player:warp(366, x - 3, 18)
			elseif player.alignment == 1 then
				player:warp(303, x - 3, 18)

				-- kwi
			elseif player.alignment == 2 then
				player:warp(304, x - 3, 18)

				-- ming
			elseif player.alignment == 3 then
				player:warp(305, x - 3, 18)

				-- ohaeng
			end
		end
	end

	if mapName == "Rogue Maso" then
		if ((x == 1 or x == 2) and y == 23) then
			if baseClass == 2 or player.tutor == 1 then
				player:warp(3706, x + 6, 3)
			else
				player:sendMinitext(str)
				player:warp(m, x, y - 2)
			end
		end
		if ((x == 8 or x == 9) and y == 1) then
			if player.alignment == 0 then
				player:warp(368, x - 3, 18)
			elseif player.alignment == 1 then
				player:warp(315, x - 3, 18)

				-- kwi
			elseif player.alignment == 2 then
				player:warp(316, x - 3, 18)

				-- ming
			elseif player.alignment == 3 then
				player:warp(317, x - 3, 18)

				-- ohaeng
			end
		end
	end

	if mapName == "Mage Eldritch" then
		if ((x == 1 or x == 2) and y == 23) then
			if baseClass == 3 or player.tutor == 1 then
				player:warp(3707, x + 6, 3)
			else
				player:sendMinitext(str)
				player:warp(m, x, y - 2)
			end
		end
		if ((x == 8 or x == 9) and y == 1) then
			if player.alignment == 0 then
				player:warp(367, x - 3, 18)
			elseif player.alignment == 1 then
				player:warp(309, x - 3, 18)

				-- kwi
			elseif player.alignment == 2 then
				player:warp(310, x - 3, 18)

				-- ming-ken
			elseif player.alignment == 3 then
				player:warp(311, x - 3, 18)

				-- ohaeng
			end
		end
	end

	if mapName == "Poet Song" then
		if ((x == 1 or x == 2) and y == 23) then
			if baseClass == 4 or player.tutor == 1 then
				player:warp(3708, x + 6, 3)
			else
				player:sendMinitext(str)
				player:warp(m, x, y - 2)
			end
		end
		if ((x == 8 or x == 9) and y == 1) then
			if player.alignment == 0 then
				player:warp(369, x - 3, 18)
			elseif player.alignment == 1 then
				player:warp(321, x - 3, 18)

				-- kwi
			elseif player.alignment == 2 then
				player:warp(322, x - 3, 18)

				-- ming-ken
			elseif player.alignment == 3 then
				player:warp(323, x - 3, 18)

				-- ohaeng
			end
		end
	end
end
