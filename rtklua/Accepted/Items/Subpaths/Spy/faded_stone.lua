faded_stone = {
	use = function(player)
		if not player:canCast(1, 1, 1) then
			return
		end

		if player.state == 2 or player:checkIfCast(invis) then
			-- invis state or has invis spell running
			player:sendMinitext("A spell of this type is already in effect.")
			return
		end

		faded.cast(player)

		player:removeItem("faded_stone", 1)
	end
}

faded = {
	cast = function(player)
		local magic = 0
		local duration = 285000

		-- 285s

		if (not player:canCast(1, 1, 1)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - magic
		player.state = 2
		player.invis = 9
		player:setDuration("faded", duration)
		player:sendStatus()
		player:sendAction(6, 35)
		player:updateState()
	end,

	while_cast = function(player)
		player.state = 2
		player.invis = 9
	end,

	uncast = function(player)
		if player.state ~= 1 then
			player.state = 0
			player.invis = 1
			player:updateState()
		end
	end
}
