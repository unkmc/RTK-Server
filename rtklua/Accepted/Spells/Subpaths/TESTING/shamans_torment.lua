shamans_torment = {
	cast = function(player, target)
		local magic = 30 + player.maxMagic *.01
		player:sendAction(6, 35)

		if (not player:canCast(0, 1, 0)) then
			return
		end

		if (player.magic < player.maxMagic *.025) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		player.magic = player.magic - magic

		if (target.blType == BL_MOB) then
			if (not target:hasDurationID("shamans_torment", player.ID)) then
				player.registry["totalsiphon"] = player.registry["totalsiphon"] + 1
			end
			if (player.registry["totalsiphon"] < 0) then
				player.registry["totalsiphon"] = 0
			end
		end
		player:sendMinitext("total siphon: " .. player.registry["totalsiphon"])
		if (target.blType == BL_PC) then
			player:sendMinitext("This target's soul is too pure for this magic.")
		else
			target:setDuration(
				"shamans_torment",
				math.random(5, 20) * 1000,
				player.ID,
				1
			)
			target:selfAnimation(player.ID, 84, 1)
		end
		player:sendStatus()
	end,
	while_cast_1500 = function(target, player)
		if (target.m ~= player.m) then
			target:setDuration("shamans_torment", 0, player.ID, 1)
		end
		target:selfAnimation(player.ID, 84, 1)
		target.attacker = player.ID

		local block = {}
		local total = 0
		block = target:getObjectsInSameMap(BL_MOB)
		if (#block > 0) then
			for i = 1, #block do
				if (block[i]:hasDurationID("shamans_torment", player.ID)) then
					total = total + 1
				end
			end
		end
		player.registry["totalsiphon"] = total

		amount = player.registry["totalsiphon"]
		if (amount > 20) then
			amount = 20
		end
		if (amount < 1) then
			amount = 1
		end
		local damage = player.maxMagic *.1
		local factor = (2 / (1 + math.pow(2.71828, (-1 * (.95 * (amount - 1))))))
		damage = (damage * factor) / amount
		damage = math.ceil(damage)
		damage = damage + 1000
		target.attacker = player.ID
		player:addThreat(target.ID, damage)
		damage = calculateDamage(target, damage)
		if (damage < 1000) then
			damage = 1000
		end
		target:removeHealth(damage)
	end,
	before_death_while_cast = function(target, player)
	end,
	recast = function(target)
	end,
	uncast = function(target, player)
	end
}
