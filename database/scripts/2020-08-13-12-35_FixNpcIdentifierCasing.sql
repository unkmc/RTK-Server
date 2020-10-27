USE RTK;

SET @script = '2020-08-13-12-35_FixNpcIdentifierCasing.sql';

DELIMITER $$

DROP PROCEDURE IF EXISTS sp $$

CREATE PROCEDURE sp(
	IN scriptName VARCHAR(255)
)

BEGIN
	IF NOT EXISTS (SELECT * FROM MigrationHistory WHERE Script = scriptName) THEN
		-- ---------------------------------------------------------------------------
		-- Convert casing for all NPC identifiers from underscore case to Pascal case
		-- since each essentially functions as a global variable in the Lua.
		-- ---------------------------------------------------------------------------
		UPDATE `NPCs0` SET `NpcIdentifier` = 'AbyssalChestNpc' WHERE `NpcIdentifier` = 'abyssal_chest';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'AlignmentNpc' WHERE `NpcIdentifier` = 'alignment';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'AncientLeviathanNpc' WHERE `NpcIdentifier` = 'ancient_leviathan';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ArenaExitTeleporterNpc' WHERE `NpcIdentifier` = 'arena_exit_teleporter';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ArenaMasterNpc' WHERE `NpcIdentifier` = 'arena_master';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ArenaShopNpc' WHERE `NpcIdentifier` = 'arena_shop';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'AssistantYanNpc' WHERE `NpcIdentifier` = 'assistant_yan';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'AuctioneerNpc' WHERE `NpcIdentifier` = 'auctioneer';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'BaekNpc' WHERE `NpcIdentifier` = 'baek';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'BaekduChestNpc' WHERE `NpcIdentifier` = 'baekdu_chest';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'BaekhoNpc' WHERE `NpcIdentifier` = 'baekho_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'BeachWarNpc' WHERE `NpcIdentifier` = 'beach_war';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'BenitnathNpc' WHERE `NpcIdentifier` = 'benitnath';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'BlackbirdNpc' WHERE `NpcIdentifier` = 'blackbird';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'BladestormTrapNpc' WHERE `NpcIdentifier` = 'bladestorm_trap';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'BloodNpc' WHERE `NpcIdentifier` = 'blood_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'BomberWarNpc' WHERE `NpcIdentifier` = 'bomber_war';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'BonHwaNpc' WHERE `NpcIdentifier` = 'bon_hwa';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'BorderPatrolNpc' WHERE `NpcIdentifier` = 'border_patrol';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ButcherNpc' WHERE `NpcIdentifier` = 'butcher';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'CarnageGameNpc' WHERE `NpcIdentifier` = 'carnageGameNPC';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'CarnageHallShopNpc' WHERE `NpcIdentifier` = 'carnageHallShop';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'CartographerNpc' WHERE `NpcIdentifier` = 'cartographer';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ChapelNpc' WHERE `NpcIdentifier` = 'chapel_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ChongunTaishiNpc' WHERE `NpcIdentifier` = 'chongun_taishi';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ChongunTaishiVillageNpc' WHERE `NpcIdentifier` = 'chongun_taishi_village';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ChuRuaNpc' WHERE `NpcIdentifier` = 'chu_rua';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ChuRuaRabbitNpc' WHERE `NpcIdentifier` = 'chu_rua_rabbit';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ChuRuaRockNpc' WHERE `NpcIdentifier` = 'chu_rua_rock';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ChuRuaTigerNpc' WHERE `NpcIdentifier` = 'chu_rua_tiger';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ChungRyongNpc' WHERE `NpcIdentifier` = 'chungryong_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ClanAdminNpc' WHERE `NpcIdentifier` = 'clan_admin_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ClanNpc' WHERE `NpcIdentifier` = 'clan_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ClawNpc' WHERE `NpcIdentifier` = 'claw';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DakHoNpc' WHERE `NpcIdentifier` = 'dakho';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DartTrapNpc' WHERE `NpcIdentifier` = 'dart_trap';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DeadBodyNpc5' WHERE `NpcIdentifier` = 'dead_body_five';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DeadBodyNpc4' WHERE `NpcIdentifier` = 'dead_body_four';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DeadBodyNpc1' WHERE `NpcIdentifier` = 'dead_body_one';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DeadBodyNpc3' WHERE `NpcIdentifier` = 'dead_body_three';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DeadBodyNpc2' WHERE `NpcIdentifier` = 'dead_body_two';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DeathTrapNpc' WHERE `NpcIdentifier` = 'death_trap';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DobosNpc' WHERE `NpcIdentifier` = 'dobos';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DogCrystalNpc' WHERE `NpcIdentifier` = 'dog_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DogLinguistNpc' WHERE `NpcIdentifier` = 'dog_linguist';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DragonCrystalNpc' WHERE `NpcIdentifier` = 'dragon_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DruidQuestFireNpc' WHERE `NpcIdentifier` = 'druid_quest_fire';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'DuelNpc' WHERE `NpcIdentifier` = 'duel';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ElixirGameNpc' WHERE `NpcIdentifier` = 'elixirGameNPC';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ElixirPrizeNpc' WHERE `NpcIdentifier` = 'elixirPrizeNPC';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ElixirShopNpc' WHERE `NpcIdentifier` = 'elixirShopNPC';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'EnigmaNpc' WHERE `NpcIdentifier` = 'enigma';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'EventManagerNpc' WHERE `NpcIdentifier` = 'event_manager';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ExorcistLaylaNpc' WHERE `NpcIdentifier` = 'exorcist_layla';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'F1Npc' WHERE `NpcIdentifier` = 'f1npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'FishNpc' WHERE `NpcIdentifier` = 'fishnpc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'FlashTrapNpc' WHERE `NpcIdentifier` = 'flash_trap';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'FoxSpiritNpc' WHERE `NpcIdentifier` = 'fox_spirit';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'GanNpc' WHERE `NpcIdentifier` = 'gan';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'GhengisKhanNpc' WHERE `NpcIdentifier` = 'ghengis_khan';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'GlothNpc' WHERE `NpcIdentifier` = 'gloth';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'GoodEarthAsvTrapNpc' WHERE `NpcIdentifier` = 'goodEarthASVTrap';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'HaguruNpc' WHERE `NpcIdentifier` = 'haguru';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'HareietteNpc' WHERE `NpcIdentifier` = 'hareiette';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'HaussonMayorNpc' WHERE `NpcIdentifier` = 'hausson_mayor';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'HealerOfDoomNpc' WHERE `NpcIdentifier` = 'healer_of_doom';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'HermitNpc' WHERE `NpcIdentifier` = 'hermit';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'HorseCrystalNpc' WHERE `NpcIdentifier` = 'horse_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'HyunMooNpc' WHERE `NpcIdentifier` = 'hyunmoo_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'InnNpc' WHERE `NpcIdentifier` = 'inn_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'InnNpc2' WHERE `NpcIdentifier` = 'inn_npc2';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'InstanceTestNpc' WHERE `NpcIdentifier` = 'instance_test';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'IronLabMerchantNpc' WHERE `NpcIdentifier` = 'iron_lab_merchant';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'IronLabTreasureChestNpc' WHERE `NpcIdentifier` = 'iron_lab_treasure_chest';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'JiongNpc' WHERE `NpcIdentifier` = 'jiong';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'JuJakNpc' WHERE `NpcIdentifier` = 'jujak_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'JukeboxNpc' WHERE `NpcIdentifier` = 'jukebox';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'KanNpc' WHERE `NpcIdentifier` = 'kan';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'KukSaNpc' WHERE `NpcIdentifier` = 'kuk_sa';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'LibrarianNpc' WHERE `NpcIdentifier` = 'librarian';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'LibrarianReevesNpc' WHERE `NpcIdentifier` = 'librarian_reeves';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'LonwikNpc' WHERE `NpcIdentifier` = 'lonwik';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'LostLegendChestNpc' WHERE `NpcIdentifier` = 'lost_legend_chest';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MageStoneProphetsNpc' WHERE `NpcIdentifier` = 'mage_stone_prophets';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MageTrainerNpc' WHERE `NpcIdentifier` = 'mage_trainer';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MagistrateNpc' WHERE `NpcIdentifier` = 'magistrate';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MainTutorialNpc' WHERE `NpcIdentifier` = 'main_tutorial_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MarketManagerNpc' WHERE `NpcIdentifier` = 'market_manager';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MerchantNpc' WHERE `NpcIdentifier` = 'merchant_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MessengerNpc' WHERE `NpcIdentifier` = 'messenger';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MignokNpc' WHERE `NpcIdentifier` = 'mignok';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MinNpc' WHERE `NpcIdentifier` = 'min';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MiningSpawnHandlerNpc' WHERE `NpcIdentifier` = 'miningSpawnHandler';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MiscGameShopNpc' WHERE `NpcIdentifier` = 'miscGameShopNPC';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MnemosyneNpc' WHERE `NpcIdentifier` = 'mnemosyne';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MobSpawnHandlerNpc' WHERE `NpcIdentifier` = 'mobSpawnHandler';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MobSpawnNpc' WHERE `NpcIdentifier` = 'mob_spawn';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MonkeyCrystalNpc' WHERE `NpcIdentifier` = 'monkey_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MontyPvpPrizesNpc' WHERE `NpcIdentifier` = 'monty_pvp_prizes';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MuseumCaretakerNpc' WHERE `NpcIdentifier` = 'museum_caretaker';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MuseumGreeterNpc' WHERE `NpcIdentifier` = 'museum_greeter';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'MythicAllianceNpc' WHERE `NpcIdentifier` = 'mythic_alliance_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'NamelessHermitNpc' WHERE `NpcIdentifier` = 'nameless_hermit';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'NewYearsNpc' WHERE `NpcIdentifier` = 'new_years_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'NoghNpc' WHERE `NpcIdentifier` = 'nogh';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'NpcSpawnHandlerNpc' WHERE `NpcIdentifier` = 'npcSpawnHandler';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'NpcSubpathGeomancerEarthsDragonNpc' WHERE `NpcIdentifier` = 'npc_subpath_geomancer_earths_dragon';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'NpcSubpathGeomancerEarthsTreasureNpc' WHERE `NpcIdentifier` = 'npc_subpath_geomancer_earths_treasure';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'NpcSubpathGeomancerGengVinNpc' WHERE `NpcIdentifier` = 'npc_subpath_geomancer_geng_vin';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'NpcSubpathGeomancerLoShuNpc' WHERE `NpcIdentifier` = 'npc_subpath_geomancer_lo_shu';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SummitNpc' WHERE `NpcIdentifier` = 'npc_summit';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'OldDogNpc' WHERE `NpcIdentifier` = 'old_dog';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'OldManNpc' WHERE `NpcIdentifier` = 'old_man';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'OxCrystalNpc' WHERE `NpcIdentifier` = 'ox_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ParkNpc' WHERE `NpcIdentifier` = 'park';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'PathArenaTutorNpc' WHERE `NpcIdentifier` = 'pathArenaTutor';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'PigCrystalNpc' WHERE `NpcIdentifier` = 'pig_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'PoemNpc' WHERE `NpcIdentifier` = 'poem';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'PoetTrainerNpc' WHERE `NpcIdentifier` = 'poet_trainer';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'PoisonDartTrapNpc' WHERE `NpcIdentifier` = 'poison_dart_trap';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'PotionShopNpc' WHERE `NpcIdentifier` = 'potion_shop';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'PyungPetNpc' WHERE `NpcIdentifier` = 'pyung_pet';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RabbitCrystalNpc' WHERE `NpcIdentifier` = 'rabbit_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RabbitInvasionNpc' WHERE `NpcIdentifier` = 'rabbit_invasion';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RabbitSpawnNpc' WHERE `NpcIdentifier` = 'rabbit_spawn';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RandomMerchantNpc' WHERE `NpcIdentifier` = 'random_merchant';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RatCrystalNpc' WHERE `NpcIdentifier` = 'rat_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RepeatingDartTrapNpc' WHERE `NpcIdentifier` = 'repeating_dart_trap';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RingShopNpc' WHERE `NpcIdentifier` = 'ring_shop';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RockNpc' WHERE `NpcIdentifier` = 'rock';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RogueGuildShamanNpc' WHERE `NpcIdentifier` = 'rogue_guild_shaman';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RogueTrainerNpc' WHERE `NpcIdentifier` = 'rogue_trainer';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RoosterCrystalNpc' WHERE `NpcIdentifier` = 'rooster_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RoshanNpc' WHERE `NpcIdentifier` = 'roshan';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'RotahNpc' WHERE `NpcIdentifier` = 'rotah';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SaerounNpc' WHERE `NpcIdentifier` = 'saeroun';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SageNpc' WHERE `NpcIdentifier` = 'sage';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SalonNpc' WHERE `NpcIdentifier` = 'salon';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SanhaeMayorNpc' WHERE `NpcIdentifier` = 'sanhae_mayor';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SeamstressNpc' WHERE `NpcIdentifier` = 'seamstress';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SelNpc' WHERE `NpcIdentifier` = 'sel';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ShamanNpc' WHERE `NpcIdentifier` = 'shaman';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SheepCrystalNpc' WHERE `NpcIdentifier` = 'sheep_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ShengNpc' WHERE `NpcIdentifier` = 'sheng';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ShyunNpc' WHERE `NpcIdentifier` = 'shyun';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SleepTrapNpc' WHERE `NpcIdentifier` = 'sleep_trap';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SmithNpc' WHERE `NpcIdentifier` = 'smith';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SnakeCrystalNpc' WHERE `NpcIdentifier` = 'snake_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SnareTrapNpc' WHERE `NpcIdentifier` = 'snare_trap';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SonhiGuardNpc' WHERE `NpcIdentifier` = 'sonhi_guard';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SpearTrapNpc' WHERE `NpcIdentifier` = 'spear_trap';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SpectyNpc' WHERE `NpcIdentifier` = 'specty';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SplinterNpc' WHERE `NpcIdentifier` = 'splinter';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SsalNpc' WHERE `NpcIdentifier` = 'ssal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SumoWarNpc' WHERE `NpcIdentifier` = 'sumo_war';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'SyaNpc' WHERE `NpcIdentifier` = 'sya';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TailorNpc' WHERE `NpcIdentifier` = 'tailor';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TalonNpc' WHERE `NpcIdentifier` = 'talon';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TigerWarpNpc' WHERE `NpcIdentifier` = 'tigerWarp';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TigerCrystalNpc' WHERE `NpcIdentifier` = 'tiger_crystal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TigerSpawnNpc' WHERE `NpcIdentifier` = 'tiger_spawn';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TigerTrapNpc' WHERE `NpcIdentifier` = 'tiger_trap';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TominaruNpc' WHERE `NpcIdentifier` = 'tominaru';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TotemNpc' WHERE `NpcIdentifier` = 'totem_npc';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TownCrierNpc' WHERE `NpcIdentifier` = 'town_crier';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TreasurePortalNpc' WHERE `NpcIdentifier` = 'treasure_portal';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TutorialNpc1' WHERE `NpcIdentifier` = 'tutorial_npc_1';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'TutorialNpc2' WHERE `NpcIdentifier` = 'tutorial_npc_2';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'UnlockedSpiritNpc' WHERE `NpcIdentifier` = 'unlocked_spirit';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ValleyFarmGhostNpc' WHERE `NpcIdentifier` = 'valley_farm_ghost';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WarpTrapDarkPenNpc' WHERE `NpcIdentifier` = 'warp_trap_dark_pen';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WarpTrapDarkStripesNpc' WHERE `NpcIdentifier` = 'warp_trap_dark_stripes';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WarpTrapDeclawedNpc' WHERE `NpcIdentifier` = 'warp_trap_declawed';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WarpTrapJungleProwlNpc' WHERE `NpcIdentifier` = 'warp_trap_jungle_prowl';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WarpTrapPounceNpc' WHERE `NpcIdentifier` = 'warp_trap_pounce';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WarpTrapRestlessCageNpc' WHERE `NpcIdentifier` = 'warp_trap_restless_cage';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WarpTrapShiverNpc' WHERE `NpcIdentifier` = 'warp_trap_shiver';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WarpTrapTigerPeltNpc' WHERE `NpcIdentifier` = 'warp_trap_tiger_pelt';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WarpTrapTigerStretchNpc' WHERE `NpcIdentifier` = 'warp_trap_tiger_stretch';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WarpTrapUndergrowthNpc' WHERE `NpcIdentifier` = 'warp_trap_undergrowth';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WarriorTrainerNpc' WHERE `NpcIdentifier` = 'warrior_trainer';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WoodcuttingSpawnHandlerNpc' WHERE `NpcIdentifier` = 'woodcuttingSpawnHandler';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WoodlandAngelNpc' WHERE `NpcIdentifier` = 'woodland_angel';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'WoodlandGuardNpc' WHERE `NpcIdentifier` = 'woodland_guard';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ExpSellerNpc' WHERE `NpcIdentifier` = 'xp_seller';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'YarlofNpc' WHERE `NpcIdentifier` = 'yarlof';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'YonNpc' WHERE `NpcIdentifier` = 'yon';
		UPDATE `NPCs0` SET `NpcIdentifier` = 'ZephyrNpc' WHERE `NpcIdentifier` = 'zephyr';

		INSERT INTO `MigrationHistory` (Script,Timestamp) VALUES (scriptName,NOW());
	ELSE
		SELECT CONCAT(scriptName, ' was skipped because it is already present in the migration history.') AS '';
	END IF;
END $$

CALL sp(@script) $$

DROP PROCEDURE IF EXISTS sp $$
 
DELIMITER ;
