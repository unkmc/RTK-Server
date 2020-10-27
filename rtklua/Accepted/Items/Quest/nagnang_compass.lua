nagnang_compass = {
	use = function(player)
		local baseMap = getNagnangShieldQuestBaseMap(player)

		local t = {graphic = convertGraphic(715, "item"), color = 0}

		player:sendMinitext("You cast Find path.")

		if player.m == baseMap then
			player:dialogSeq({t, "The needle points to the east."}, 0)
		elseif player.m == baseMap + 1 then
			player.quest["used_compass"] = 1
			player:dialogSeq({t, "The needle points to the east."}, 0)
		elseif player.m == baseMap + 2 then
			player:dialogSeq({t, "The needle points to the west."}, 0)
		elseif player.m == baseMap + 3 then
			player:dialogSeq({t, "The needle points to the west."}, 0)
		elseif player.m == baseMap + 4 then
			player:dialogSeq({t, "The needle points to the south."}, 0)
		elseif player.m == baseMap + 5 then
			player:dialogSeq({t, "The needle points to the north."}, 0)
		else
			player:dialogSeq({t, "The needle points to Nagnang."}, 0)
		end
	end
}
