dash_barbarian = {
	cast = function(player)
		local d = {}
		local m = player.m
		local x = player.x
		local y = player.y
		local distFinish = 0
		local sound = 60
		local counter = 0
		local magic = 250
		local aether = 150000

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

		repeat
			counter = counter + 1
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

			if (checkSpecificTile(player, x, y)) then
				distFinish = counter
			else
				counter = 4
			end
		until counter >= 3

		if (player.x - distFinish < 0 and player.side == 3) then
			distFinish = player.x
		end
		if (player.y - distFinish < 0 and player.side == 0) then
			distFinish = player.y
		end

		player:setAether("dash_barbarian", aether)
		if (player.side == 0) then
			player:warp(player.m, player.x, player.y - distFinish)
		end
		if (player.side == 1) then
			player:warp(player.m, player.x + distFinish, player.y)
		end
		if (player.side == 2) then
			player:warp(player.m, player.x, player.y + distFinish)
		end
		if (player.side == 3) then
			player:warp(player.m, player.x - distFinish, player.y)
		end
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 99
		local item = {"blood", "splendid_tiger_pelt", 0}
		local amounts = {1, 1, 25000}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Jumps 3 tiles in the direction faced."
		return level, item, amounts, desc
	end
}
