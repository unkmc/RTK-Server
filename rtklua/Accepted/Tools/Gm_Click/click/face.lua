face = {
	option = function(player, target, npc)
		player.dialogType = 2
		local opts = {
			"Browse face look",
			"Browse eye color",
			"Change face and color to this look",
			"<< Back"
		}
		local dialog = "<b>[" .. target.name .. "'s face]\n\nFace  : " .. npc.gfxFace .. "\nColor : " .. npc.gfxFaceC .. "\n\n"
		option = player:menuSeq(dialog .. "Make your choice", opts, {})

		if not player.ID == 2 or not player.ID == 4 then
			if target.ID == 2 or target.ID == 4 then
				target:msg(
					4,
					"[Face Look] " .. player.name .. " is try to change your Face Look!",
					target.ID
				)
				return
			end
		end

		if option == 1 then
			player.registry["face_style"] = 1
			player.registry["face_color"] = 0
			face.browse(player, target, npc)
		elseif option == 2 then
			player.registry["face_style"] = 0
			player.registry["face_color"] = 1
			face.browse(player, target, npc)
		elseif option == 3 then
			face.confirmation(player, target, npc, dialog)
		elseif option == 4 then
			click.look(player, target, npc)
		end
	end,

	browse = function(player, target, npc)
		local dialog = "<b>[" .. target.name .. "'s face]\n\nFace  : " .. npc.gfxFace .. "\nColor : " .. npc.gfxFaceC .. "\n\n"
		player.dialogType = 2
		local opts = {"Next >>", "Option", "<< Previous"}
		menu = player:menuSeq(dialog .. "Make your choice", opts, {})

		if menu == 1 then
			if player.registry["face_style"] == 1 and player.registry["face_color"] == 0 then
				if npc.gfxFace > 238 then
					npc.gfxFace = 200
				else
					npc.gfxFace = npc.gfxFace + 1
				end
			elseif player.registry["face_style"] == 0 and player.registry[
				"face_color"
			] == 1 then
				if npc.gfxFaceC > 255 then
					npc.gfxFaceC = 0
				else
					npc.gfxFaceC = npc.gfxFaceC + 1
				end
			end
			face.browse(player, target, npc, dialog)
		elseif menu == 2 then
			face.option(player, target, npc)
		elseif menu == 3 then
			if player.registry["face_style"] == 1 and player.registry["face_color"] == 0 then
				if npc.gfxFace < 200 then
					npc.gfxFace = 238
				else
					npc.gfxFace = npc.gfxFace - 1
				end
			elseif player.registry["face_style"] == 0 and player.registry[
				"face_color"
			] == 1 then
				if npc.gfxFaceC < 0 then
					npc.gfxFaceC = 255
				else
					npc.gfxFaceC = npc.gfxFaceC - 1
				end
			end
			face.browse(player, target, npc, dialog)
		end
	end,

	confirmation = function(player, target, npc, dialog)
		player.dialogType = 2
		local opts = {
			"Yes, Change to this look",
			"Browse another look",
			"<< Back"
		}
		menu = player:menuSeq(
			dialog .. "Are you sure to change " .. target.name .. "'s face look and eye color to this?",
			opts,
			{}
		)

		if menu == 1 then
			if player.ID ~= 2 and target.ID == 2 then
				target:msg(
					4,
					"[INFO] " .. player.name .. " is trying to change your face look",
					target.ID
				)
				return
			end
			target.face = npc.gfxFace
			target.faceColor = npc.gfxFaceC
			target:updateState()
			target:sendStatus()
			target:calcStat()
			target:sendMinitext("Your face look is changed!")
			player:sendMinitext("Done!!")
			click.look(player, target, npc)
		elseif menu == 2 then
			face.browse(player, target, npc)
		elseif menu == 3 then
			face.option(player, target, npc)
		end
	end
}
