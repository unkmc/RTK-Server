startup = function()
	local maps = {}

	-- restless cage warps 100
	maps[1] = {}
	maps[1][1] = "WarpTrapTigerPeltNpc"
	maps[1][2] = "WarpTrapTigerStretchNpc"
	maps[1][3] = "WarpTrapDarkStripesNpc"
	maps[1][4] = "WarpTrapDeclawedNpc"
	maps[1][5] = "WarpTrapJungleProwlNpc"
	maps[1][6] = "WarpTrapPounceNpc"
	maps[1][7] = "WarpTrapUndergrowthNpc"

	--tiger pelt 101
	maps[2] = {}
	maps[2][1] = "WarpTrapDarkPenNpc"
	maps[2][2] = "WarpTrapTigerStretchNpc"
	maps[2][3] = "WarpTrapDarkStripesNpc"
	maps[2][4] = "WarpTrapDeclawedNpc"
	maps[2][5] = "WarpTrapJungleProwlNpc"
	maps[2][6] = "WarpTrapPounceNpc"
	maps[2][7] = "WarpTrapUndergrowthNpc"
	maps[2][8] = "warp_trap_revenge"

	---undergrowth 102
	maps[3] = {}
	maps[3][1] = "WarpTrapTigerPeltNpc"
	maps[3][2] = "WarpTrapTigerStretchNpc"
	maps[3][3] = "WarpTrapDarkStripesNpc"
	maps[3][4] = "WarpTrapDeclawedNpc"
	maps[3][5] = "WarpTrapJungleProwlNpc"
	maps[3][6] = "WarpTrapPounceNpc"
	maps[3][7] = "WarpTrapDarkPenNpc"
	maps[3][8] = "warp_trap_revenge"

	---jungle prowl 103
	maps[4] = {}
	maps[4][1] = "WarpTrapTigerPeltNpc"
	maps[4][2] = "WarpTrapTigerStretchNpc"
	maps[4][3] = "WarpTrapDarkStripesNpc"
	maps[4][4] = "WarpTrapDeclawedNpc"
	maps[4][5] = "WarpTrapDarkPenNpc"
	maps[4][6] = "WarpTrapPounceNpc"
	maps[4][7] = "WarpTrapUndergrowthNpc"
	maps[4][8] = "warp_trap_revenge"

	---tiger stretch 104
	maps[5] = {}
	maps[5][1] = "WarpTrapTigerPeltNpc"
	maps[5][2] = "WarpTrapDarkPenNpc"
	maps[5][3] = "WarpTrapDarkStripesNpc"
	maps[5][4] = "WarpTrapDeclawedNpc"
	maps[5][5] = "WarpTrapJungleProwlNpc"
	maps[5][6] = "WarpTrapPounceNpc"
	maps[5][7] = "WarpTrapUndergrowthNpc"
	maps[5][8] = "warp_trap_revenge"

	---revenge 105
	maps[6] = {}
	maps[6][1] = "WarpTrapJungleProwlNpc"
	maps[6][2] = "WarpTrapDarkPenNpc"
	maps[6][3] = "WarpTrapDarkStripesNpc"
	maps[6][4] = "WarpTrapDeclawedNpc"
	maps[6][5] = "WarpTrapUndergrowthNpc"
	maps[6][6] = "WarpTrapPounceNpc"
	maps[6][7] = "WarpTrapTigerPeltNpc"

	---dark stripes 106
	maps[7] = {}
	maps[7][1] = "WarpTrapTigerPeltNpc"
	maps[7][2] = "WarpTrapTigerStretchNpc"
	maps[7][3] = "WarpTrapDarkPenNpc"
	maps[7][4] = "WarpTrapDeclawedNpc"
	maps[7][5] = "WarpTrapJungleProwlNpc"
	maps[7][6] = "WarpTrapPounceNpc"
	maps[7][7] = "WarpTrapUndergrowthNpc"
	maps[7][8] = "warp_trap_revenge"

	--- declawed 107
	maps[8] = {}
	maps[8][1] = "WarpTrapTigerPeltNpc"
	maps[8][2] = "WarpTrapTigerStretchNpc"
	maps[8][3] = "WarpTrapDarkStripesNpc"
	maps[8][4] = "WarpTrapDarkPenNpc"
	maps[8][5] = "WarpTrapJungleProwlNpc"
	maps[8][6] = "WarpTrapPounceNpc"
	maps[8][7] = "WarpTrapUndergrowthNpc"
	maps[8][8] = "warp_trap_revenge"

	---pounce 108
	maps[9] = {}
	maps[9][1] = "WarpTrapTigerPeltNpc"
	maps[9][2] = "WarpTrapTigerStretchNpc"
	maps[9][3] = "WarpTrapDarkStripesNpc"
	maps[9][4] = "WarpTrapDeclawedNpc"
	maps[9][5] = "WarpTrapJungleProwlNpc"
	maps[9][6] = "WarpTrapDarkPenNpc"
	maps[9][7] = "WarpTrapUndergrowthNpc"
	maps[9][8] = "warp_trap_revenge"

	---dark pen 109
	maps[10] = {}
	maps[10][1] = "warp_trap_guardroom"
	maps[10][2] = "WarpTrapPounceNpc"
	maps[10][3] = "WarpTrapDarkStripesNpc"
	maps[10][4] = "WarpTrapDeclawedNpc"
	maps[10][5] = "warp_trap_revenge"

	---guardroom 110
	maps[11] = {}
	maps[11][1] = "WarpTrapJungleProwlNpc"
	maps[11][2] = "warp_trap_revenge"
	maps[11][3] = "warp_trap_tiger_stripes"
	maps[11][4] = "WarpTrapDeclawedNpc"
	maps[11][5] = "WarpTrapUndergrowthNpc"
	maps[11][6] = "WarpTrapDarkStripesNpc"
	maps[11][7] = "WarpTrapTigerPeltNpc"

	for map = 100, (#maps + 99) do
		for i = 1, #maps[map - 99] do
			local spawnedAmount = 0
			local failCheck = 0
			local chosenMap = maps[map - 99][i]

			repeat
				local x = math.random(2, getMapXMax(map) - 1)
				local y = math.random(2, getMapYMax(map) - 1)
				local passCheck = getPass(map, x, y)
				local blockCheck = core:getObjectsInCell(map, x, y, BL_ALL)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(map, x, y)) then
					for z = 1, 10 do
						core:addNPC(chosenMap, map, x, y, 2)
						core:addNPC(chosenMap, (map + 3000), x, y, 2)
						core:addNPC(chosenMap, (map + 4000), x, y, 2)
						spawnedAmount = spawnedAmount + 1
						if (chosenMap == "warp_trap_guardroom") then
							spawnedAmount = 10
						end
					end
				end
				failCheck = failCheck + 1
			until spawnedAmount >= 10 or failCheck > 1000
		end
	end
end
