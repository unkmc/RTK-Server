Player.faerieLight = function(player)
	local t = {graphic = convertGraphic(627, "item"), color = 0}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0

	if not player:karmaCheck("angel") then
		player:dialogSeq({t, "You do not possess Angel karma."}, 0)
		return
	end

	local choice = player:menuSeq(
		"Thy karma fills thy soul. Shall it light the way for all?",
		{"Yes, exchange my karma for it.", "No, I will retain my karma."},
		{}
	)

	if choice == 1 then
		player:removeKarma(math.random(25, 30))
		player:addItem("faerie_light", 1, 0, player.ID)
		player:dialogSeq({t, "May the faerie light guide your soul."}, 0)
		return
	elseif choice == 2 then
		player:dialogSeq({t, "May another opportunity present itself."}, 0)
		return
	end
end
