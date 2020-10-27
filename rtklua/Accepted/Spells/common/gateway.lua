gateway = {
	cast = function(player, question)
		local q = string.lower(player.question)
		local m = player.m
		local x
		local y

		local map = 0
		local city = ""
		local gate = ""

		if player.health <= 0 then
			player:sendMinitext("Spirits cannot use Gateway")
			return
		end
		if not player:canCast(1, 1, 0) then
			return
		end
		if player.warpOut == 0 then
			player:sendAnimation(246)
			player:sendMinitext("It doesn't work here")
			return
		end

		if player.region >= 6 then
			player:sendMinitext("Cannot find any gates!")
			return
		end

		if player.region == 0 then
			-- 0: Koguryo (Kugnae)   1: Buya   2: mythic 3: nagnang 4: vortex	5: instance
			map = 0
			city = "Kugnae"

			if string.sub(q, 1, 1) == "n" then
				x = math.random(104, 116)
				y = math.random(13, 17)
				player:sendAnimationXY(16, player.x, player.y)
				gate = "North"
			elseif string.sub(q, 1, 1) == "e" then
				x = math.random(201, 208)
				y = math.random(105, 111)
				gate = "East"
			elseif string.sub(q, 1, 1) == "w" then
				x = math.random(14, 19)
				y = math.random(104, 111)
				gate = "West"
			elseif string.sub(q, 1, 1) == "s" then
				x = math.random(104, 115)
				y = math.random(207, 211)
				gate = "South"
			end
		elseif player.region == 1 then
			-- 0: Koguryo (Kugnae)   1: Buya   2: mythic 3: nagnang 4: vortex		5: instance
			map = 330
			city = "Buya"

			if string.sub(q, 1, 1) == "n" then
				x = math.random(71, 75)
				y = math.random(22, 27)
				gate = "North"
			elseif string.sub(q, 1, 1) == "w" then
				x = math.random(8, 12)
				y = math.random(88, 92)
				gate = "West"
			elseif string.sub(q, 1, 1) == "e" then
				x = math.random(132, 136)
				y = math.random(86, 90)
				gate = "East"
			elseif string.sub(q, 1, 1) == "s" then
				x = math.random(74, 78)
				y = math.random(140, 145)
				gate = "South"
			end
		elseif player.region == 2 then
			-- 0: Koguryo (Kugnae)   1: Buya   2: mythic 3: nagnang 4: vortex		5: instance
			map = 41
			city = "Mythic"

			if string.sub(q, 1, 1) == "n" then
				x = math.random(27, 36)
				y = math.random(10, 15)
				gate = "North"
			elseif string.sub(q, 1, 1) == "w" then
				x = math.random(3, 5)
				y = math.random(28, 33)
				gate = "West"
			elseif string.sub(q, 1, 1) == "e" then
				x = math.random(54, 57)
				y = math.random(28, 33)
				gate = "East"
			elseif string.sub(q, 1, 1) == "s" then
				x = math.random(25, 33)
				y = math.random(48, 53)
				gate = "South"
			end
		elseif player.region == 3 then
			-- 0: Koguryo (Kugnae)   1: Buya   2: mythic 3: nagnang 4: vortex		5: instance
			map = 2500
			city = "Nagnang"

			if string.sub(q, 1, 1) == "n" then
				x = math.random(37, 39)
				y = math.random(23, 25)
				gate = "North"
			elseif string.sub(q, 1, 1) == "w" then
				x = math.random(4, 6)
				y = math.random(92, 94)
				gate = "West"
			elseif string.sub(q, 1, 1) == "e" then
				x = math.random(138, 140)
				y = math.random(86, 88)
				gate = "East"
			elseif string.sub(q, 1, 1) == "s" then
				x = math.random(75, 77)
				y = math.random(151, 153)
				gate = "South"
			end
		elseif player.region == 5 then
			map = 4259
			city = "Mount Baekdu"

			if string.sub(q, 1, 1) == "n" then
				x = 15
				y = 15
				gate = "Mountain top"
			elseif string.sub(q, 1, 1) == "w" then
				x = 15
				y = 15
				gate = "Mountain top"
			elseif string.sub(q, 1, 1) == "e" then
				x = 15
				y = 15
				gate = "Mountain top"
			elseif string.sub(q, 1, 1) == "s" then
				x = 15
				y = 15
				gate = "Mountain top"
			end
		end

		player:sendAnimationXY(16, player.x, player.y)
		player:warp(map, x, y)
		player:sendMinitext("You have arrived at " .. gate .. " Gate of " .. city)
		player:playSound(29)
		player:sendAnimation(16)
		player:sendAction(6, 20)
	end,

	requirements = function(player)
		local level = 5
		local item = {"acorn", "rabbit_meat"}
		local amounts = {10, 10}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "This spell is used to get around the Kingdoms."
		return level, item, amounts, desc
	end
}
