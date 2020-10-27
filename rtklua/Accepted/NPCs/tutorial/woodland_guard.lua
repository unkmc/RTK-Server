local _declineDialog = "You may not enter the kingdom until you agree to abide by its laws."

WoodlandGuardNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		player:dialogSeq(
			{
				"The citizens of this community are expected to abide its laws. If you choose to persue an illegal alley, do not act mazed when you are jailed or banned.",
				"Be conscientious. Do not harass or steal from other players. Report bugs, and do not exploit them. Do not share your password with anyone, including RTK staff."
			}, 1)

		local menu = player:menuString(
			"The stability of this community is your responsibility. Will you swear to obey our laws, including those not explicitly stated here?",
			{"Yes", "No"}
		)

		if (menu == "No") then
			player:dialogSeq({_declineDialog}, 1)
			return
		end

		player:dialogSeq(
			{
				"You have done well. I can now permit you to enter the city. Go on your way, and keep on the right side of the law.",
				"To help you defend against the lawless and some of those tougher critters, here's a sword that will hit a little harder than that stick you're carrying."
			},
			1
		)

		player:addItem("novice_sword", 1)
		player:warp(4718, 10, 16)
	end)
}
