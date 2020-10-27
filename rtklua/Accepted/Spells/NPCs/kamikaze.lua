kamikaze = {
	cast = function(player, target)
		local spellName = "Kamikaze"
		local m = player.m
		local x = 0
		local y = 0
		local s = player.side
		local magic = 120

		if (not player:canCast(0, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local damage = math.ceil(player.health * 1.75)
		player.magic = player.magic - magic

		player:sendAction(1, 30)

		player:talk(2, "Kamikaze~!")

		global_zap.cast(player, target, damage, 0, 0)
		if target.blType == BL_PC then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end

		player.health = 10
		player:sendStatus()
		player:sendMinitext("You cast " .. spellName .. ".")
	end
}
