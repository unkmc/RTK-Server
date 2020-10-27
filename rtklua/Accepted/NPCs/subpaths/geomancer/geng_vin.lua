NpcSubpathGeomancerGengVinNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Buy", "Sell", "Geng Vin's Welcome"}

		local buysellopts = {
			"rabbit_meat",
			"meat_scrap",
			"horse_meat",
			"antler",
			"bears_liver",
			"tigers_heart"
		}

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				buysellopts
			)
		elseif menu == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				buysellopts
			)
		elseif menu == "Geng Vin's Welcome" then
			player:dialogSeq(
				{
					t,
					"Hello and welcome to the House of Chi. The Geomancers have allowed me to reside here in this Hallowed Pass and rest from my journeys in the West. In return I help protect their home.",
					"Feel free to step inside and have a look around, perhaps even grab a Shu Jing. I would give you one myself, but the Earths Dragon and I don't always see eye to eye. I'm quick, but he's quicker...",
					"If you're hungry I am always willing to share the spoils of my hunts. Being a predator at the top...*glances inside the House of Chi* ..near the top has its advantages."
				},
				0
			)
			return
		end
	end),

	action = function(npc)
		local random = math.random(1, 15)

		if random == 1 then
			npc:talk(0, npc.name .. ": Welcome to the House of Chi")
		end
	end,

	move = function(npc)
		npc.side = math.random(0, 3)
		npc:sendSide()
	end,

	buyItems = function()
		local buyItems = {
			"rabbit_meat",
			"meat_scrap",
			"horse_meat",
			"antler",
			"bears_liver",
			"tigers_heart"
		}
		return buyItems
	end,

	sellItems = function()
		return NpcSubpathGeomancerGengVinNpc.buyItems()
	end
}
