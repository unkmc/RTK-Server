blend = {
	--VERIFIED WITH NTK. 100% match.
	cast = function(player)
		local magic = 4000
		local duration = 120000

		-- 120s
		local aethers = 30000

		if (not player:canCast(1, 1, 1)) then
			-- dead, invis/transformed, mounted
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - magic
		player.state = 2
		player.invis = 9
		player:setDuration("blend", duration)
		player:setAether("blend", aethers)
		player:sendStatus()
		player:sendAction(6, 35)
		player:sendAnimation(16, 30)
		player:sendMinitext("You cast Blend.")
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
			player:sendMinitext("You are no longer invisible.")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {"fox_tail", "topaz"}
		local itemAmounts = {1, 1}
		local description = "Increases your weapon damage 9 times. Caster becomes invisible to everyone except group members. Spell uncast by hitting something or picking up items."
		return level, items, itemAmounts, description
	end
}
