TominaruNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {
			"Lesson 1 'Karma'",
			"Lesson 2 'Grouping'",
			"Lesson 3 'Legend'",
			"Lesson 4 'Emotions'",
			"Lesson 5 'Knowing yourself'"
		}

		local choice = player:menuSeq(
			"Hello! How can I help you today?",
			opts,
			{}
		)

		if choice == 1 then
			player:dialogSeq(
				{
					t,
					"Welcome. I am glad to see your young soul grow. There are many here who can teach you the ordinary ways of life. I can teach you the ways of conscience or your Karma.",
					"All that you think and do can affect your Karma. You can choose to be kind or choose to do evil. Both affect your conscience.",
					"There are many ways you can add or subtract from your Karma. Whether you choose to crawl like the cursed of the Earth or become one with the Gods, there are many ways to find your current Karma level.",
					"Monks, Geomancers and Diviners can access your soul. They can tell you if you have Snake or Shunnyo ((angel)) Karma. Not even the mercahnts will speak with one having Snake Karma",
					"If you struggle mightily and with great courage your Karma will soar. If you flee from challenges or commit illegal acts your Karma will plummet.",
					"It is even possible for you to allow others to gain Karma. Many in the lands will seek to help young ones like",
					"Your fellow citizens who have greater experience can Mentor you by increasing your skill levels and knowledge.",
					"Those who strive for true Karma do not perform these acts for money but from a desire to help. The vice Greed is an example of a mindset that prevents gains of Karma.",
					"Protect your soul by not allowing gold or items to be paid for or by Mentors. Greed has nothing to do with true enlightment of the soul.",
					"As you progress in wisdom and knowledge your karma can be at many levels. Allying with one of the Mythic creatures is one way that can bring you much Karma.",
					"Abusing laws is commonly understood to lower Karma but many do not know that breaking a vow, such as joining a subpath and then leaving the circle, can also affect your Karma.",
					"Learn from others; both citizens, MEntors and Tutors and choose the wise path. A good soul can take you a long way towards your path in life.",
					"May the Gods bless your life."
				},
				1
			)
			if (player.registry["tominaru1exp"] == 0) then
				player:giveXP(10)
				player.registry["tominaru1exp"] = 1
			end
		elseif choice == 2 then
			player:dialogSeq(
				{
					t,
					"Life is a great adventure! You don't have to face it alone! You may be alright soloing at first but as time passes on you will find that life just gets too boring or the enemies too tough to defeat by yourself.",
					"You are asking now what is the solution? Well that is easy. You can find yourself other people to group with. ((Hit shift and the letter g to turn your group on.))",
					"How do you group? Well that is the easy part. One way and the most common way is to tap on the shoulder of the person you wish to group with. ((Left click on the person you wish to group with and click on the box that looks like 2 P's facing each other.",
					"If this box is not highlighted then they do not have their group turned on. You will need to ask them to turn it on in order to group.",
					"You may group up to nine other players! So a total of ten players may form a group, you being the tenth.",
					"((The other choice to group a player is to hit g on your keyboard and type the name of the person you wish to group with, again if they do not have their group on you will need to ask them to do this.))",
					"When players are grouped each player gets a small portion of the experience from slaying a monster. Although the experience is split, being in a group will allow you to slay monsters faster and can help gain experience even faster.",
					"Oh! I almost forgot to tell you! Obviously it will be easier making a group if you have friends to group with. Keep track of your friends with your list. ((Press F3 on your keyboard or click menu and friends to bring up the list.))",
					"Your friends name will appear in blue on the heroes list ((Press ctrl w or click menu userlist to see the people online.))",
					"Happy grouping and good luck!"
				},
				1
			)
			if (player.registry["tominaru2exp"] == 0) then
				player:giveXP(10)
				player.registry["tominaru2exp"] = 1
			end
		elseif choice == 3 then
			player:dialogSeq(
				{
					t,
					"You're so young that you have barely a legend to your name! What is a legend you ask yourself? Well, it is a reflection of your time here in the Kingdoms. It keeps track of all the things you have accomplished both good and bad.",
					"((To see your legend, click on the estatus tab or press s on your keyboard to see the status menu. Then click the right-facing arrow in the bottom corner twice.))",
					"((To see the legend of others click on a player and then click on the right-facing arrow three times.))",
					"You can gather marks on your legend many ways. Completing quests, being recognized by members of your community, witnessing a great event or taking positions of responsibility such as judge, game host, or guide of a subpath. All these things will earn a new notch on your legend.",
					"But beware! There are also red legend marks which tell the community of your foul deeds. These are collected by being jailed, but can also be given out by subpaths for something disrespectfully done to their group.",
					"The more red marks you collect, the less privileges you will find you have in the Kingdoms, and too many could lead to your eventual banishment!",
					"Many clans and subpaths will not allow players to join their group if a red marks scar is on their legend.",
					"Remember to stay on the right side of the law in order to keep your legend neat and clean. I would hate to see someone with as much potential as yourself lose it to any wrong doing."
				},
				1
			)
			if (player.registry["tominaru3exp"] == 0) then
				player:giveXP(20)
				player.registry["tominaru3exp"] = 1
			end
		elseif choice == 4 then
			player:dialogSeq(
				{
					t,
					"Why are you staring at me with that blank look on your face? I guess you have even forgotten how to express yourself.",
					"When you interact with those around you not only can you communicate through words but also through facial expressions. A great way to show your feelings!",
					"((To make an emotion press : or shift ; then choose a letter a through p. There is a different emotion for each letter.",
					"((Here is a list of each letter and what emotion it will make your character do.",
					"a - Happy",
					"b - Sad",
					"c - Embarrased",
					"d - Wink",
					"e - Bored",
					"f - Tired",
					"g - Surprised",
					"h - Angry",
					"i - Sarcastic",
					"j - Shrug",
					"k - Annoyed",
					"l - Dance",
					"m - Bow",
					"n - Victory",
					"o - Bizarre",
					"p - Kiss"
				},
				1
			)
			if (player.registry["tominaru4exp"] == 0) then
				player:giveXP(25)
				player.registry["tominaru4exp"] = 1
			end
		elseif choice == 5 then
			player:dialogSeq(
				{
					t,
					"It is important to always remain aware of your current physical state in order to maintain your health and more efficiently fight the foes you may come across.",
					"((To see your status, click on the 'Status' tab, or press 's' on your keyboard.))",
					"Your vitality is how much energy you have. THe more vitality you have, the longer it will take for you to be killed should you be attacked.",
					"Your mana is the amount of intellect you have acquired. The more mana you have, the more magic and special abilities you will be able to perform.",
					"Some items you were will give you a greater chance to hit your foe and others will increase the amount of damage you deal with a melee weapon.",
					"These are two things that Rogues and Warriors more than any other should pay special attention to.",
					"In addition to your probability to  land a blow and the amount of damage dealt, might and grace are two more things that melee classes shoould keep in mind.",
					"The more might you have will allow you to carry stronger weapons and increase the amount of damage you deal to foes as well.",
					"The more grace you have the more nimble you are on your feet. This will allow you to dodge melee attacks against you more easily.",
					"Strength of will is necesesary for spell casters such as Mages and Poets.",
					"The stronger your will, the less likely it is that your spells and enchantments will fail against the opponent you are facing.",
					"All of the armor and equipment you wear may affect how hard you take blows of any kind. This is called your armor class.",
					"The lower your armor's class is the less severe any damage you take will be. ((This is commonly referred to as your AC.))"
				},
				1
			)
			if (player.registry["tominaru5exp"] == 0) then
				player:giveXP(25)
				player.registry["tominaru5exp"] = 1
			end
		end
	end)
}
