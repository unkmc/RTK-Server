love = {
	use = function(player)
		if player:hasDuration("love_ring_delay") == true then
			return
		end
		love_ring_delay.cast(player)

		local msg = "Your companion is with you in spirit, but not in body."
		local msg2 = "That doesn't work here."

		local target = Player(player.partner)
		local failcheck = 0

		if not player:hasLegend("married") then
			player:sendMinitext("You are not married.")
			return
		end

		if player:hasLegend("forged_blood_oath") or player:hasLegend("sealed_blood_oath") then
			player:removeItem("love", 1)
			return
		end

		if target == nil then
			player:sendMinitext("Your companion is with you in spirit, but not in body.")
			return
		end

		if target.partner ~= player.ID then
			player:sendMinitext("You are no longer married to that person.")
			return
		end

		if player.m == 666 or target.m == 666 then
			return
		end
		if target.m == 4259 then
			return
		end
		if player.m >= 59000 or target.m >= 59000 then
			return
		end
		if player:canPK(target) then
			player:sendMinitext(msg)
			return
		end
		if player:canPK(player) then
			player:sendMinitext(msg)
			return
		end

		if (player.m == 3010 or player.m == 3011 or player.m == 33 or player.m == 3017) then
			player:sendMinitext(msg2)
			return
		end

		if (target.m == 3010 or target.m == 3011 or target.m == 33 or player.m == 3017) then
			player:sendMinitext(msg2)
			return
		end
		if (player.m == 3042 or target.m == 3042) then
			player:sendMinitext(msg2)
			return
		end
		if (player.m >= 3034 and player.m <= 3039) or (target.m >= 3034 and target.m <= 3039) then
			player:sendMinitext(msg2)
			return
		end

		local m, x, y = target:getOpenCellApproach()

		if player.m == target.m then
			player:warp(m, x, y)
			return
		end

		if (target.canSummon == 0) then
			player:sendMinitext(msg)
			return
		end
		if player.state == 1 then
			player:sendMinitext(msg)
			return
		end

		if (player.region ~= target.region and not Config.interRegionLoveEnabled) then
			player:sendMinitext(msg)
			return
		end

		if (player.level < target.reqLvl) then
			player:sendMinitext(msg)
			return
		end
		if (player.level > target.maxLvl) then
			player:sendMinitext(msg)
			return
		end
		if (player.baseHealth < target.reqVita and player.baseMagic < target.reqMana) then
			player:sendMinitext(msg)
			return
		end
		if (player.baseHealth > target.maxVita or player.baseMagic > target.maxMana) then
			player:sendMinitext(msg)
			return
		end

		player.registry["love_delay"] = os.time() + 1
		player:warp(m, x, y)
	end
}
