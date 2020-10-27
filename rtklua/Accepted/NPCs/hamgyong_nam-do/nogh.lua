local _waypointId = "hamgyong_nam_do"

NoghNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		local opts = {
			"Buy",
			"Sell",
			"Talk to Nogh",
			"Mining the Substratum",
			--"Rings of Substratum"
		}

		if (not Waypoint.isEnabled(player, _waypointId)) then
			table.insert(opts, "Waypoint")
		end

		local buyopts = {"ogre_cider", "ogre_drought"}

		local sellopts = {
			"wool",
			"ogre_cider",
			"ogre_drought",
			"ginseng_piece",
			"ginseng",
			"mountain_ginseng"
		}

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				buyopts
			)
			return
		elseif menu == "Sell" then
			player:sellExtend("What are you willing to sell today?", sellopts)
			return
		elseif menu == "Talk to Nogh" then
			player:dialogSeq({"I sell plenty of fine cider. Why not buy some?"}, 0)
			return
		elseif menu == "Mining the Substratum" then
			player:dialogSeq(
				{
					"I have heard that the ogres of Hamgyong Nam-Do have been mining very deeply into the earth. They have even reached below the rocks and dirt in to the Substratum.",
					"I don't know what is down there, but legend has it that the area is home to the living earth itself. Those ogres may be getting themselves in troublle; I have seen many crates of supplies going into the mines.",
					"This could mean they are planning something massive or they are having some difficulty down there in the depths. If you find anything from the Substratum, bring it to me so I can look at it."
				},
				0
			)
			return
		elseif menu == "Rings of Substratum" then
			-- @TODO: Implement
			return
		elseif menu == "Waypoint" then
			Waypoint.add(player, npc, _waypointId)
		end
	end),

	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)

		if (speech == "waypoint" and not Waypoint.isEnabled(player, _waypointId)) then
			Waypoint.add(player, npc, _waypointId)
			return
		end
	end),

	buyItems = function(npc)
		local buyItems = {"ogre_cider", "ogre_drought"}
		return buyItems
	end,

	sellItems = function(npc)
		local sellItems = {
			"wool",
			"ogre_cider",
			"ogre_drought",
			"ginseng_piece",
			"ginseng",
			"mountain_ginseng"
		}
		return sellItems
	end
}
