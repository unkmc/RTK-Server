verbalScriptGeneral = function(player, npc, speech)
	Tools.configureDialog(player, npc)

	if string.match(speech, "what's your name") or string.match(
		speech,
		"what is your name"
	) then
		npc:talk(0, "Hello, my name is " .. npc.name .. ".")
	end
end
