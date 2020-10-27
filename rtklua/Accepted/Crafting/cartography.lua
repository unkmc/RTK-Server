cartography = {
	craft = function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if speech == "combine" then
			if not crafting.checkSkillLegend(player, "cartography") then
				player:dialogSeq(
					{
						t,
						"You are not a cartographer, I can't let you work with my tools."
					},
					0
				)
				return
			end

			local amount = 0
			for i = 0, 52 do
				local item = player:getInventoryItem(i)
				if item ~= nil then
					if item.yname == "map_fragment" then
						amount = amount + item.amount

						if amount > 10 then
							break
						end
					end
				end
			end

			if amount < 10 then
				player:dialogSeq(
					{t, "You do not have enough map fragments."},
					0
				)
				return
			end

			local skill = crafting.getSkillLevel(player, "cartography")
			local mapToGive = mapTypes[math.random(1, #mapTypes)]

			local mapid = getFreeMapModifierId()

			-- get new unused unique map id
			if mapid == 0 then
				return
			end

			local modifiers, values, tier = maps.getBaseModifiers(
				mapToGive,
				skill,
				player
			)

			-- get initial modifiers for map based on type

			for i = 1, #modifiers do
				addMapModifier(mapid, modifiers[i], values[i])
			end

			--player:removeItem(fragment.yname,10)
			player:removeItem("map_fragment", 10)

			--player:addItem(mapToGive,1,tier,<ownerID>,<itemshopdurationMS>,<NAME, leave blank>,0,0,<icon>,0,0,0,mapid)
			player:addItem(
				mapToGive,
				1,
				tier,
				0,
				0,
				"",
				0,
				0,
				0,
				0,
				0,
				0,
				mapid
			)
			crafting.skillChanceIncrease(
				player,
				NPC("Cartographer Min"),
				"cartography"
			)

			player:dialogSeq({t, "You were successful"}, 0)
			return
		end
	end
}
