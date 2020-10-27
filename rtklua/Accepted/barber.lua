barber = {
	click = async(function(player, npc)
		local npcer = math.random(51, 450)
		local bot = NPC(npcer)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 2

		clone.equip(player, bot)
		player.lastClick = bot.ID

		hair2.option(player, bot)
	end),

	browse = function(player, npc, type)
		local type = string.lower(type)
		local opts = {"Next", "OK", "Prev"}
		local text, x = "", ""
		local val, valC, look, color = 0, 0, 0, 0

		if type == "Hair Style" then
			x, val, valC, look, color = "Hair", npc.gfxHair, npc.gfxHairC, player.registry[
				"hair_look"
			], player.registry["hair_color"]
		elseif type == "Face Surgery" then
			x, val, valC, look, color = "Face", npc.gfxFace, npc.gfxFaceC, player.registry[
				"face_look"
			], player.registry["face_color"]
		end

		if player.registry["face_look"] == 0 then
			player.registry["face_look"] = player.face
		end
		if player.registry["face_color"] == 0 then
			player.registry["face_color"] = player.faceC
		end
		if player.registry["hair_look"] == 0 then
			player.registry["hair_look"] = player.hair
		end
		if player.registry["hair_color"] == 0 then
			player.registry["hair_color"] = player.hairC
		end

		text = x .. " Number: " .. val .. "\n"
		text = text .. "" .. x .. " Color : " .. valC .. "\n"

		menu = player:menuString("" .. text, opts)

		if menu ~= nil then
			if menu == "Next" then
				if type == "Hair Style" then
					if npc.gfxHair > 129 then
						npc.gfxHair = 1
					else
						npc.gfxHair = npc.gfxHair + 1
					end
					npc:updateState()
					npc:talk(
						1,
						"Hair: " .. npc.gfxHair .. "(" .. npc.gfxHairC .. ")"
					)
				elseif type == "Face Surgery" then
					if npc.gfxFace > 238 then
						npc.gfxFace = 200
					else
						npc.gfxFace = npc.gfxFace + 1
					end
					npc:updateState()
					npc:talk(
						1,
						"Face: " .. npc.gfxFace .. "(" .. npc.gfxFaceC .. ")"
					)
				end

				barber.browse(player, npc, type)
			elseif menu == "Prev" then
				if type == "Hair Style" then
					if player.registry["hair_look"] < 0 then
						player.registry["hair_look"] = 129
					else
						player.registry["hair_look"] = player.registry[
							"hair_look"
						] - 1
					end
					npc.gfxHairC = player.registry["hair_color"]
					npc:talk(
						1,
						"Hair: " .. npc.gfxHair .. "(" .. npc.gfxHairC .. ")"
					)
				elseif type == "Face Surgery" then
					if player.registry["face_look"] < 200 then
						player.registry["face_look"] = 238
					else
						player.registry["face_look"] = player.registry[
							"face_look"
						] - 1
					end
					npc.gfxFaceC = player.registry["face_color"]
					npc:talk(
						1,
						"Face: " .. npc.gfxFace .. "(" .. npc.gfxFaceC .. ")"
					)
				end
				barber.browse(player, npc, type)
			end
		end
	end
}

hair2 = {
	option = function(player, npc)
		player.dialogType = 2
		local opts = {"Hair style", "Hair color", "Finish"}
		local dialog = "Hair  : " .. npc.gfxHair .. "\nColor : " .. npc.gfxHairC .. "\n\n"
		option = player:menuSeq(dialog .. "How can I help you?", opts, {})

		if option == 1 then
			player.registry["hair_style"] = 1
			player.registry["hair_color"] = 0
			hair2.browse(player, npc)
		elseif option == 2 then
			player.registry["hair_style"] = 0
			player.registry["hair_color"] = 1
			hair2.browse(player, npc)
		elseif option == 3 then
			if (player:hasDuration("supporter_buff") == false) then
				player:sendMinitext("You must be a Runegard Supporter to use this.")
				return
			end
			player.hair = npc.gfxHair
			player.hairColor = npc.gfxHairC
			player:updateState()
			player:sendStatus()
			player:calcStat()
			player:sendMinitext("Your hair style is changed!")
			player:sendMinitext("Done!!")
		end
	end,

	browse = function(player, npc)
		player.dialogType = 2
		local opts = {"Next >>", "Options", "<< Previous"}
		menu = player:menuSeq("Make your choice", opts, {})

		if menu == 1 then
			if player.registry["hair_style"] == 1 and player.registry["hair_color"] == 0 then
				if npc.gfxHair > 129 then
					npc.gfxHair = 0
				else
					npc.gfxHair = npc.gfxHair + 1
				end
			elseif player.registry["hair_style"] == 0 and player.registry[
				"hair_color"
			] == 1 then
				npc.gfxHairC = npc.gfxHairC + 1
			end
			hair2.browse(player, npc)
		elseif menu == 2 then
			hair2.option(player, npc)
		elseif menu == 3 then
			if player.registry["hair_style"] == 1 and player.registry["hair_color"] == 0 then
				if npc.gfxHair < 0 then
					npc.gfxHair = 129
				else
					npc.gfxHair = npc.gfxHair - 1
				end
			elseif player.registry["hair_style"] == 0 and player.registry[
				"hair_color"
			] == 1 then
				npc.gfxHairC = npc.gfxHairC - 1
			end
			hair2.browse(player, npc)
		end
	end
}
