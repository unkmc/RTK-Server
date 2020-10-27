hair = {
	option = function(player, target, npc)
		player.dialogType = 2
		local opts = {
			"Browse hair style",
			"Browse hair color",
			"Change hair and color to this look",
			"<< Back"
		}
		local dialog = "<b>[" .. target.name .. "'s hair style]\n\nHair  : " .. npc.gfxHair .. "\nColor : " .. npc.gfxHairC .. "\n\n"
		option = player:menuSeq(dialog .. "Make your choice", opts, {})

		if not player.ID == 2 or not player.ID == 4 then
			if target.ID == 2 or target.ID == 4 then
				target:msg(
					4,
					"[Hair style] " .. player.name .. " is try to change your hair style!",
					target.ID
				)
				return
			end
		end

		if option == 1 then
			player.registry["hair_style"] = 1
			player.registry["hair_color"] = 0
			hair.browse(player, target, npc, dialog)
		elseif option == 2 then
			player.registry["hair_style"] = 0
			player.registry["hair_color"] = 1
			hair.browse(player, target, npc, dialog)
		elseif option == 3 then
			if player.ID ~= 2 and target.ID == 2 then
				target:msg(
					4,
					"[INFO] " .. player.name .. " is trying to change your hair look",
					target.ID
				)
				return
			end
			target.hair = npc.gfxHair
			target.hairColor = npc.gfxHairC
			target:updateState()
			target:sendStatus()
			target:calcStat()
			target:sendMinitext("Your hair style is changed!")
			player:sendMinitext("Done!!")
			click.look(player, target, npc)
		elseif option == 4 then
			click.look(player, target, npc)
		end
	end,

	browse = function(player, target, npc, dialog)
		player.dialogType = 2
		local opts = {"Next >>", "Options", "<< Previous"}
		menu = player:menuSeq(dialog .. "Make your choice", opts, {})

		if menu == 1 then
			if player.registry["hair_style"] == 1 and player.registry["hair_color"] == 0 then
				if npc.gfxHair > 151 then
					npc.gfxHair = 0
				else
					npc.gfxHair = npc.gfxHair + 1
				end
			elseif player.registry["hair_style"] == 0 and player.registry[
				"hair_color"
			] == 1 then
				npc.gfxHairC = npc.gfxHairC + 1
			end
			hair.browse(player, target, npc, dialog)
		elseif menu == 2 then
			hair.option(player, target, npc)
		elseif menu == 3 then
			if player.registry["hair_style"] == 1 and player.registry["hair_color"] == 0 then
				if npc.gfxHair < 0 then
					npc.gfxHair = 151
				else
					npc.gfxHair = npc.gfxHair - 1
				end
			elseif player.registry["hair_style"] == 0 and player.registry[
				"hair_color"
			] == 1 then
				npc.gfxHairC = npc.gfxHairC - 1
			end
			hair.browse(player, target, npc, dialog)
		end
	end
}
