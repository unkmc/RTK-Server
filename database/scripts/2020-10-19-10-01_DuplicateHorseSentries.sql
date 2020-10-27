USE RTK;

SET @script = '2020-10-19-10-01_DuplicateHorseSentries.sql';

DELIMITER $$

DROP PROCEDURE IF EXISTS sp $$

CREATE PROCEDURE sp(
	IN scriptName VARCHAR(255)
)

BEGIN
	IF NOT EXISTS (SELECT * FROM MigrationHistory WHERE Script = scriptName) THEN
		-- ----------------------------
		-- Since horse sentries are in both the guardroom and the main cave, we need a duplicate set
		-- to have reduced vita/exp in the main cave. Same idea for the golden hare in the wildnerss.
		-- ----------------------------
		INSERT INTO `Mobs` VALUES ('808', 'horse_guardsman_main', 'Horse guardsman', '1', '0', '0', '0', '0', '134', '11', '53750', '0', '340000', '60', '0', '60', '0', '550', '750', '2000', '1000', '300', '0', '60', '60', '0', '0', '2', '-20', '9', '0', '0', '0', '0', '0', '0', '0', '0');
		INSERT INTO `Mobs` VALUES ('809', 'horse_sentry_main', 'Horse sentry', '1', '0', '0', '0', '0', '134', '31', '68500', '0', '350000', '60', '0', '60', '0', '700', '1400', '2000', '1000', '300', '0', '60', '60', '0', '0', '5', '-50', '9', '0', '0', '0', '0', '0', '0', '0', '0');
		INSERT INTO `Mobs` VALUES ('810', 'horse_swordsman_main', 'Horse swordsman', '1', '0', '0', '0', '0', '134', '11', '71000', '0', '760000', '99', '0', '99', '0', '1240', '1640', '2000', '1000', '300', '0', '99', '99', '0', '0', '3', '-50', '9', '0', '0', '0', '0', '0', '0', '0', '0');
		INSERT INTO `Mobs` VALUES ('811', 'horse_guardian_main', 'Horse guardian', '1', '0', '0', '0', '0', '134', '16', '177000', '0', '1200000', '99', '0', '99', '0', '2220', '2740', '2000', '1000', '300', '0', '99', '99', '0', '0', '5', '-70', '9', '0', '0', '0', '0', '0', '0', '0', '0');
		INSERT INTO `Mobs` VALUES ('812', 'hooves_main', 'Hooves', '1', '0', '0', '0', '0', '134', '15', '1065000', '0', '6600000', '99', '0', '99', '0', '9920', '13120', '2000', '1000', '300', '0', '99', '99', '0', '0', '3', '-75', '9', '0', '0', '0', '0', '0', '0', '0', '0');
		INSERT INTO `Mobs` VALUES ('813', 'horse_defender_main', 'Horse defender', '1', '0', '0', '0', '0', '134', '0', '2175000', '0', '7400000', '99', '0', '99', '0', '17760', '21920', '2000', '1000', '300', '0', '99', '99', '0', '0', '5', '-95', '9', '0', '0', '0', '0', '0', '0', '0', '0');		
		INSERT INTO `Mobs` VALUES ('814', 'golden_hare_wild', 'Golden hare', '1', '0', '0', '0', '0', '125', '30', '2700', '0', '4500', '25', '0', '25', '0', '30', '50', '1000', '2000', '240', '0', '25', '25', '0', '0', '0', '95', '9', '0', '0', '0', '0', '0', '0', '0', '0');

		UPDATE
			`Mobs`
		SET
			`MobVita` = MobVita * 0.2,
			`MobExperience` = MobExperience * 0.3
		WHERE
			`MobId` BETWEEN 808 AND 814;

		INSERT INTO `MigrationHistory` (Script,Timestamp) VALUES (scriptName,NOW());
	ELSE
		SELECT CONCAT(scriptName, ' was skipped because it is already present in the migration history.') AS '';
	END IF;
END $$

CALL sp(@script) $$

DROP PROCEDURE IF EXISTS sp $$
 
DELIMITER ;
