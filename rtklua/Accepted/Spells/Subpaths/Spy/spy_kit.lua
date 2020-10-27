spy_kit = {
	cast = async(function(player)
		local t = {}

		player.npcGraphic = 0
		player.npcColor = 0
		player.dialogType = 0
		player.lastClick = player.ID

		local aethers = 10000

		-- 10s
		local magic = 1

		-- yes 1 mana

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:sendMinitext("You cast Spy Kit.")
		player:setAether("spy_kit", aethers)

		local choice = player:menuString(
			"Which trap would you like to use?",
			{"Toxic spray", "Tripwire", "Smoke screen"},
			{}
		)

		if choice == "Toxic spray" then
			player:addNPC(
				"toxic_spray_trap",
				player.m,
				player.x,
				player.y,
				2,
				1000,
				20000,
				player.ID,
				"Toxic spray trap"
			)
			player:sendMinitext("You make a toxic spray.")
		elseif choice == "Tripwire" then
			player:addNPC(
				"tripwire_trap",
				player.m,
				player.x,
				player.y,
				2,
				1000,
				20000,
				player.ID,
				"Tripwire trap"
			)
			player:sendMinitext("The tripwire has been set.")
		elseif choice == "Smoke screen" then
			player:addNPC(
				"smoke_screen_trap",
				player.m,
				player.x,
				player.y,
				2,
				1000,
				20000,
				player.ID,
				"Smoke screen trap"
			)
			player:sendMinitext("The smoke screen is set.")
		end
	end)
}
