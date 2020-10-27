dagger_uniform = {
	cast = function(player)
		local magic = 25
		local duration = 162000

		if player:hasDuration("dagger_uniform") then
			player:removeDuras(morphs)
			return
		end

		if player.state ~= 0 then
			player:sendMinitext("You cannot cast Invisible while dead or transformed.")
			return
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		if (player:hasDuration("invisible_rogue")) then
			player:sendMinitext("You cannot cast Invisible while dead or transformed.")
			return
		end
		player:sendAnimation(3, 3)
		player.magic = player.magic - magic
		player.state = 4
		player.disguise = 102
		player:setDuration("dagger_uniform", duration)
		player:sendStatus()
		player:sendAction(6, 35)
		player:updateState()
	end,

	uncast = function(player)
		if player.state ~= 1 then
			-- dead
			player.state = 0
		end
		player:updateState()
	end,
	requirements = function(player)
		local level = 1
		local items = {}
		local itemAmounts = {}
		local description = "Disguise you as Dagger."
		return level, items, itemAmounts, description
	end
}
