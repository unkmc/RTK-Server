SonhiGuardNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.quest["presented_sonhi_pass"] == 0 then
			if player:hasItem("sonhi_pass", 1) ~= true then
				player:dialogSeq(
					{
						t,
						"Who are you? What are you doing here?",
						"This is a diplomatic check point. What lies beyond here is Sonhi claimed land. You will not be permitted to enter without a pass from KaKhan or Kaming.",
						"If you have such  a pass, please present it. If not, you will need to go!"
					},
					0
				)
				return
			end

			if player:hasItem("sonhi_pass", 1) == true then
				--player:removeItem("sonhi_pass",1)
				player.quest["presented_sonhi_pass"] = 1

				--player:dialogSeq({t,"Ah, you do have the pass"},1)
				--player:dialogSeq({t,"This pass is very suspicious. I will keep it with me, but you may still pass."},0)
				player:dialogSeq(
					{
						t,
						"Let me see that pas...yes...yes... well, everything seems to be in order.",
						"Here you go, you my pass sir."
					},
					1
				)

				return
			end
		elseif player.quest["presented_sonhi_pass"] == 1 then
			--player:dialogSeq({t,"This pass is very suspicious. I will keep it with me, but you may still pass."},0)
			--player:dialogSeq({t,"You may pass sir."},0)
		end
	end)
}
