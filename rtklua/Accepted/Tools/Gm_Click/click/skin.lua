skin = {
	option = function(player, target, npc)
		player.dialogType = 2
		local dialog = "<b>[" .. target.name .. "'s Skin]\n\nSkin color: " .. npc.gfxSkinC .. "\n\n"

		local opts = {
			"Browse skin color",
			"Change skin color to this look",
			"<< Back"
		}
		menu = player:menuSeq(dialog .. "Make your choice", opts, {})

		if not player.ID == 2 or not player.ID == 4 then
			if target.ID == 2 or target.ID == 4 then
				target:msg(
					4,
					"[Skin color] " .. player.name .. " is try to change Skin color!",
					target.ID
				)
				return
			end
		end

		if menu == 1 then
			skin.browse(player, target, npc, dialog)
		elseif menu == 2 then
			target.skinColor = npc.gfxSkinC
			target.skinColor = npc.gfxSkinC
			target:updateState()
			target:sendStatus()
			target:calcStat()
			target:sendMinitext("Your skin color is changed!")
			player:sendMinitext("Done!!")
			click.look(player, target, npc)
		elseif menu == 3 then
			click.look(player, target, npc)
		end
	end,

	browse = function(player, target, npc, dialog)
		player.dialogType = 2
		local opts = {"Next >>", "Options", "<< Previous"}
		menu = player:menuSeq(dialog .. "Make your choice", opts, {})

		if menu == 1 then
			npc.gfxSkinC = npc.gfxSkinC + 1
			skin.browse(player, target, npc, dialog)
		elseif menu == 2 then
			skin.option(player, target, npc)
		elseif menu == 3 then
			npc.gfxSkinC = npc.gfxSkinC - 1
			skin.browse(player, target, npc, dialog)
		end
	end
}
