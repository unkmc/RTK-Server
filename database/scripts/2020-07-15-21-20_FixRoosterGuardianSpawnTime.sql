USE RTK;

SET @script = '2020-07-15-21-20_FixRoosterGuardianSpawnTime.sql';

DELIMITER $$

DROP PROCEDURE IF EXISTS sp $$

CREATE PROCEDURE sp(
	IN scriptName VARCHAR(255)
)

BEGIN
	IF NOT EXISTS (SELECT * FROM MigrationHistory WHERE Script = scriptName) THEN
		-- ----------------------------
		-- Fix Rooster guardian spawn time
		-- ----------------------------
		UPDATE Mobs SET MobSpawnTime = 30 WHERE MobIdentifier = 'rooster_guardian';

		INSERT INTO `MigrationHistory` (Script,Timestamp) VALUES (scriptName,NOW());
	ELSE
		SELECT CONCAT(scriptName, ' was skipped because it is already present in the migration history.') AS '';
	END IF;
END $$

CALL sp(@script) $$

DROP PROCEDURE IF EXISTS sp $$
 
DELIMITER ;
