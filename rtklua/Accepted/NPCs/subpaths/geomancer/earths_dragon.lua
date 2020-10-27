NpcSubpathGeomancerEarthsDragonNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local options = {
			"Buy",
			"Sell",
			"Fix Item",
			"Fix All Items",
			"Keeper of Red Soil",
			"Reincarnate",
			"Observe"
		}
		local buysellopts = {"shu_jing"}

		local choice = player:menuString(
			"Hello! How can I help you today?",
			options
		)

		if choice == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				buysellopts
			)
		elseif choice == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				buysellopts
			)
		elseif choice == "Fix Item" then
			player:repairExtend()
		elseif choice == "Fix All Items" then
			player:repairAll(npc)
		elseif choice == "Keeper of the Red Soil" then
			player:dialogSeq(
				{
					t,
					"I seek only those who are keepers of the balance and followers of the great mother Tap."
				},
				0
			)
			return
		elseif choice == "Reincarnate" then
			general_npc_funcs.reincarnate(player, npc)
		elseif choice == "Observe" then
			general_npc_funcs.observe(player, npc)
		end
	end),

	move = function(npc)
		npc.side = math.random(0, 3)
		npc:sendSide()
	end,

	buyItems = function()
		local buyItems = {"shu_jing"}

		return buyItems
	end,

	sellItems = function()
		return NpcSubpathGeomancerEarthsDragonNpc.buyItems()
	end
}
