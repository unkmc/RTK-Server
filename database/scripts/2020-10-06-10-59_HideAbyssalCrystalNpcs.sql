USE RTK;

SET @script = '2020-10-06-10-59_HideAbyssalCrystalNpcs.sql';

DELIMITER $$

DROP PROCEDURE IF EXISTS sp $$

CREATE PROCEDURE sp(
	IN scriptName VARCHAR(255)
)

BEGIN
	IF NOT EXISTS (SELECT * FROM MigrationHistory WHERE Script = scriptName) THEN
		-- Move Abyssal crystals into an unused map to hide them without deleting
		UPDATE NPCs0
		SET NpcMapId = 1071, NpcX = 9, NpcY = 9
		WHERE NpcId BETWEEN 364 AND 379;
		
		INSERT INTO `MigrationHistory` (Script,Timestamp) VALUES (scriptName,NOW());
	ELSE
		SELECT CONCAT(scriptName, ' was skipped because it is already present in the migration history.') AS '';
	END IF;
END $$

CALL sp(@script) $$

DROP PROCEDURE IF EXISTS sp $$
 
DELIMITER ;
