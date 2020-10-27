RatCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:addItem("crystal_shard", 1, 0, player.ID)
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it..."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}

TigerCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
			player:addItem("crystal_shard", 1, 0, player.ID)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}

DogCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
			player:addItem("crystal_shard", 1, 0, player.ID)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}
DragonCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
			player:addItem("crystal_shard", 1, 0, player.ID)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}
SnakeCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
			player:addItem("crystal_shard", 1, 0, player.ID)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}
RoosterCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
			player:addItem("crystal_shard", 1, 0, player.ID)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}
SheepCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
			player:addItem("crystal_shard", 1, 0, player.ID)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}
MonkeyCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
			player:addItem("crystal_shard", 1, 0, player.ID)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}
OxCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
			player:addItem("crystal_shard", 1, 0, player.ID)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}
HorseCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
			player:addItem("crystal_shard", 1, 0, player.ID)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}
PigCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
			player:addItem("crystal_shard", 1, 0, player.ID)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}
RabbitCrystalNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 5 then
			player.quest["reeves_quest"] = 6
			player:dialogSeq(
				{
					t,
					"The crystal surges with power as you place your hand on it!",
					"As you recoil in pain you see a small crystal shard stuck to your palm."
				},
				0
			)
			player:addItem("crystal_shard", 1, 0, player.ID)
		end
		player:dialogSeq({t, "The crystal seems dormant."}, 0)
	end),
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		if player.quest["reeves_quest"] >= 4 then
			if speech == "calamity" then
				if player.quest["reeves_quest"] == 4 then
					player.quest["reeves_quest"] = 5
				end
				player:dialogSeq(
					{
						t,
						"The crystal emits a faint glow. You almost want to touch it."
					},
					0
				)
			end
		end
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
	end),
}
