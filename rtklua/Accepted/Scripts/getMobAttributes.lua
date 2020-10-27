--[[bestiary = {

click = function(player, npc)

	local t = {graphic = convertGraphic(1439, "monster"), color = 0}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0

	local opts = {}

	table.insert(opts, "Past Beasts")
	table.insert(opts, "Current Beasts")
	table.insert(opts, "Future Beasts")

	menu = player:menuString("<b>[Bestiary]", opts)

	if menu == "Past Beasts" then
		bestiary.past(player)
	elseif menu == "Current Beasts" then
		bestiary.current(player)
	elseif menu == "Future Beasts" then
		bestiary.future(player)
	end
end,

current = function(player, npc)
	player.dialogType = 0
	local currentBeastName = {}
	local currentBeastID = {}

	local mobVita = 1
	local mobArmor = 2
	local mobExp = 3
	local mobMight = 4
	local mobWill = 5
	local mobGrace = 6
	local mobLook = 7
	local mobLookC = 8
	local mobLevel = 9
	local mobName = 10
	local mobYname = 11
	local mobCaveName = 12

	local mobInfo = {}

	local currentMob

	for i = 1000, 1439 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] >= -10 and player.level - mobInfo[mobLevel] <= 10 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	for i = 2001, 2084 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] >= -10 and player.level - mobInfo[mobLevel] <= 10 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	for i = 3001, 3096 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] >= -10 and player.level - mobInfo[mobLevel] <= 10 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	for i = 4001, 4052 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] >= -10 and player.level - mobInfo[mobLevel] <= 10 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	menu = player:menu("<b>[Current Beasts]", currentBeastName)

	if menu ~= 0 then
		currentMob = getMobAttributes(currentBeastID[menu])
		t = {graphic = convertGraphic(currentMob[mobLook], "monster"), color = currentMob[mobLookC]}
		player:dialogSeq({t, "<b>"..currentMob[mobName].."\n\nLevel: "..currentMob[mobLevel].."\nVita:  "..currentMob[mobVita].."\nExp:   "..currentMob[mobExp].."\nMight: "..currentMob[mobMight].."\nGrace: "..currentMob[mobGrace].."\nWill:  "..currentMob[mobWill].."\nArmor: "..currentMob[mobArmor].."\n\nLocated in "..currentMob[mobCaveName]}, 1)
	end
end,

-- Past Beasts -------------------------------------------------------------------------------------------------------------------------

past = function(player, npc)
	player.dialogType = 0
	local currentBeastName = {}
	local currentBeastID = {}

	local mobVita = 1
	local mobArmor = 2
	local mobExp = 3
	local mobMight = 4
	local mobWill = 5
	local mobGrace = 6
	local mobLook = 7
	local mobLookC = 8
	local mobLevel = 9
	local mobName = 10
	local mobYname = 11
	local mobCaveName = 12

	local mobInfo = {}

	local currentMob

	for i = 1000, 1439 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] >= 11 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	for i = 2001, 2084 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] >= 11 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	for i = 3001, 3096 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] >= 11 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	for i = 4001, 4052 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] >= 11 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	menu = player:menu("<b>[Past Beasts]", currentBeastName)

	if menu ~= 0 then
		currentMob = getMobAttributes(currentBeastID[menu])
		t = {graphic = convertGraphic(currentMob[mobLook], "monster"), color = currentMob[mobLookC]}
		player:dialogSeq({t, "<b>"..currentMob[mobName].."\n\nLevel: "..currentMob[mobLevel].."\nVita:  "..currentMob[mobVita].."\nExp:   "..currentMob[mobExp].."\nMight: "..currentMob[mobMight].."\nGrace: "..currentMob[mobGrace].."\nWill:  "..currentMob[mobWill].."\nArmor: "..currentMob[mobArmor].."\n\nLocated in "..currentMob[mobCaveName]}, 1)
	end

end,

-----Future Beasts------------------------------------------------------------------------------------------------------------

future = function(player, npc)

	player.dialogType = 0
	local currentBeastName = {}
	local currentBeastID = {}

	local mobVita = 1
	local mobArmor = 2
	local mobExp = 3
	local mobMight = 4
	local mobWill = 5
	local mobGrace = 6
	local mobLook = 7
	local mobLookC = 8
	local mobLevel = 9
	local mobName = 10
	local mobYname = 11
	local mobCaveName = 12

	local mobInfo = {}

	local currentMob

	for i = 1000, 1439 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] <= -11 and player.level - mobInfo[mobLevel] >= -25 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	for i = 2001, 2084 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] <= -11 and player.level - mobInfo[mobLevel] >= -25 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	for i = 3001, 3096 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] <= -11 and player.level - mobInfo[mobLevel] >= -25 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	for i = 4001, 4052 do
		mobInfo = getMobAttributes(i)
		if mobInfo[mobName] ~= "??" then
			if player.level - mobInfo[mobLevel] <= -11 and player.level - mobInfo[mobLevel] >= -25 then
				table.insert(currentBeastName, mobInfo[mobName])
				table.insert(currentBeastID, i)
			end
		end
	end

	menu = player:menu("<b>[Future Beasts]", currentBeastName)

	if menu ~= 0 then
		currentMob = getMobAttributes(currentBeastID[menu])
		t = {graphic = convertGraphic(currentMob[mobLook], "monster"), color = currentMob[mobLookC]}
		player:dialogSeq({t, "<b>"..currentMob[mobName].."\n\nLevel: "..currentMob[mobLevel].."\nVita:  "..currentMob[mobVita].."\nExp:   "..currentMob[mobExp].."\nMight: "..currentMob[mobMight].."\nGrace: "..currentMob[mobGrace].."\nWill:  "..currentMob[mobWill].."\nArmor: "..currentMob[mobArmor].."\n\nLocated in "..currentMob[mobCaveName]}, 1)
	end
end
}]]
--
