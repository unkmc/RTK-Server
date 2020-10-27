divine_time = {
	cast = function(player)
		local magic = 5

		if (not player:canCast(1, 1, 0)) then
			-- dead, invis/transformed, mounted
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end
		player.magic = player.magic - magic
		player:sendStatus()
		player:sendAction(6, 35)

		general_npc_funcs.time(player)
	end,

	requirements = function(player)
		local level = 99
		local items = {"fox_tail", "topaz"}
		local itemAmounts = {1, 1}
		local description = "Increases your weapon damage 9 times. Caster becomes invisible to everyone except group members. Spell uncast by hitting something or picking up items."
		return level, items, itemAmounts, description
	end
}
