spell_book = {
	click = function(player, npc)
		-- This menu is from F1NPC -> God Tools -> Obtained a char Id

		player:freeAsync()
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local pc = Player(player.registry["on_page"])

		gfxClone(pc, npc)

		local get
		local magic = pc:getSpellName()
		local yname = player:getSpellYName()
		local id = player:getSpells()

		menu = player:menuString("<b>[" .. pc.name .. "'s Spell book]", magic)
		if menu ~= "" then
			for i = 1, #magic do
				if magic[i] == menu then
					get = i
					break
				end
			end
		end
		menu2 = player:menuString(
			"<b>[" .. pc.name .. "'s Spell book]\n\nDelete " .. pc.name .. "'s " .. magic[
				get
			] .. "?",
			{"Yes", "No"}
		)
		if menu2 == "Yes" then
			pc.registry["learned_" .. yname[get]] = 0
			pc:removeSpell(id[get])
		end
	end,

	menu = function(player, target, npc)
		-- This is from GM Click

		local name = "<b>[" .. target.name .. "'s Spell]\n\n"
		player.dialogType = 0
		local id, spell = target:getSpells(), target:getSpellName()
		local opts = {"Remove Spell", "Add Spell", "<< Back"}

		menu = player:menuString(
			name .. "Total spells: " .. #id .. "\n\nWhat to do?",
			opts
		)
		if menu == "<< Back" then
			gm_click.menu(player, target, npc)
			return
		else
			if menu == "Add Spell" then
				if #id >= 52 then
					player:dialogSeq(
						{name .. "Target's spellbook is full! (Max: 52)"},
						1
					)
					spell_book.menu(player, target, npc)
					return
				end
				spell_book.add(player, target)
			elseif menu == "Remove Spell" then
				spell_book.forget(player, target, npc)
			end
		end
	end,

	add = function(player, target, npc)
		local name = "<b>[Add Spell]\n\n"
		local id = target:getSpells()

		add = string.lower(player:input(name .. "Total spells: " .. #id .. "\nWhat spell would you give to target?(spell yname only)"))
		if target:hasSpell(add) then
			player:dialogSeq(
				{
					name .. "Target's already has this spell / spell not found in database!"
				},
				1
			)
			spell_book.add(player, target, npc)
			return
		else
			target:addSpell(add)
			target:sendMinitext("New spell added!")
			player:sendMinitext("Done!!")
			spell_book.add(player, target, npc)
		end
	end,

	forget = function(player, target, npc)
		local name = "<b>[" .. target.name .. "'s Spell]\n\n"
		local id, spell = target:getSpells(), target:getSpellName()
		player.dialogType = 0

		menu2 = player:menuSeq(
			name .. "Total spells: " .. #id .. "\n\nWhat spell would you remove from target?",
			spell,
			{}
		)

		repeat
			for i = 1, #spell do
				if menu2 == i then
					opts = {"Yes, remove it", "<< Back"}
					choice = player:menuSeq(
						name .. 'You are about to remove "' .. spell[i] .. '" spell from target.\nConfirm?',
						opts,
						{}
					)
					if choice == 1 then
						if player.ID ~= 2 and player.ID ~= 166 then
							-- other GMs can't make change at your character. You are the God!
							if target.ID == 2 or target.ID == 166 then
								target:msg(
									4,
									"[INFO] " .. player.name .. " is trying to remove " .. spell[
										i
									] .. " from your spellbook!",
									target.ID
								)
								return
							end
						end

						target:removeSpell(id[i])
						target:sendMinitext("Spell '" .. spell[i] .. "' removed!")
						player:sendMinitext("Done!!")
						spell_book.forget(player, target, npc)
					elseif choice == 2 then
						spell_book.click(player, target, npc)
						return
					end
				end
			end
		until (false)
	end
}
