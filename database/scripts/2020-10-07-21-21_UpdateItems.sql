USE RTK;

SET @script = '2020-10-07-21-21_UpdateItems.sql';

DELIMITER $$

DROP PROCEDURE IF EXISTS sp $$

CREATE PROCEDURE sp(
	IN scriptName VARCHAR(255)
)

BEGIN
	IF NOT EXISTS (SELECT * FROM MigrationHistory WHERE Script = scriptName) THEN
		-- ----------------------------
		-- Increase stack amounts
		-- ----------------------------
		UPDATE `Items` SET ItmStackAmount = 100, ItmMaximumAmount = 100 WHERE ItmIdentifier IN (
			'paper',
			'white_paper',
			'ink',
			'wool',
			'spent_metal',
			'obsidian',
			'limestone',
			'quartz',
			'amethyst',
			'tarnished_amber',
			'cloth',
			'fine_cloth',
			'fine_metal',
			'metal',
			'ore_poor',
			'ore_med',
			'ore_high',
			'ore_very_high',
			'gold_ore',
			'silver_ore',
			'slag',
			'ginko_wood',
			'wood_scraps',
			'well_crafted_dark_amber',
			'well_crafted_amber',
			'crafted_dark_amber',
			'crafted_amber',
			'tarnished_dark_amber',
			'wheat',
			'rice',
			'wolf_meat',
			'ginseng',
			'fish',
			'banana',
			'watermelon',
			'chicken_meat',
			'pork',
			'rare_pork',
			'beef',
			'tiger_meat',
			'bird_meat',
			'egg',
			'meat',
			'chestnut',
			'minnow',
			'lean_beef',
			'ginseng_piece',
			'fine_snake_meat',
			'horse_meat',
			'small_fish',
			'scrawny_fish',
			'tiny_fish',
			'tasty_fish');
		
		UPDATE `Items` SET ItmStackAmount = 60, ItmMaximumAmount = 60 WHERE ItmIdentifier LIKE '%white_amber' OR ItmIdentifier LIKE '%yellow_amber';
		UPDATE `Items` SET ItmStackAmount = 40, ItmMaximumAmount = 40 WHERE ItmIdentifier IN ('ginseng', 'bear_fur', 'delicious_fish', 'large_fish');
		UPDATE `Items` SET ItmStackAmount = 20, ItmMaximumAmount = 20 WHERE ItmIdentifier LIKE '%weaving_tools';
			
		-- ----------------------------
		-- Adjust item prices
		-- ----------------------------
		UPDATE `Items` SET ItmBuyPrice = 50, ItmSellPrice = 25 WHERE ItmIdentifier = 'egg';
		UPDATE `Items` SET ItmBuyPrice = 2000, ItmSellPrice = 1000 WHERE ItmIdentifier = 'magical_fish';
		UPDATE `Items` SET ItmBuyPrice = 10, ItmSellPrice = 5 WHERE ItmIdentifier IN ('slag', 'wood_scraps', 'seaweed');
		UPDATE `Items` SET ItmBuyPrice = 2000, ItmSellPrice = 1000 WHERE ItmIdentifier LIKE 'key_to_%'; -- Mythic keys
		UPDATE `Items` SET ItmBuyPrice = 5000, ItmSellPrice = 2500 WHERE ItmIdentifier IN ("hyun_moo_key", "ju_jak_key", "baekho_key", "chung_ryong_key"); -- Totem keys

		-- ----------------------------
		-- Reskin items
		-- ----------------------------
		UPDATE `Items` SET ItmIcon = 2901, ItmIconColor = ItmId - 49103 WHERE ItmId BETWEEN 49103 AND 49108; -- Various tree branches that used the old Dark staff icon
		UPDATE `Items` SET ItmIcon = 318, ItmIconColor = 4 WHERE ItmIdentifier = 'white_amber'; -- Change from Stardrop icon to white-colored amber like in NTK
		UPDATE `Items` SET ItmIcon = 18 WHERE ItmIdentifier IN ('sacred_poem', 'war_poem'); -- Change from sword icon to scroll
		
		INSERT INTO `MigrationHistory` (Script,Timestamp) VALUES (scriptName,NOW());
	ELSE
		SELECT CONCAT(scriptName, ' was skipped because it is already present in the migration history.') AS '';
	END IF;
END $$

CALL sp(@script) $$

DROP PROCEDURE IF EXISTS sp $$
 
DELIMITER ;
