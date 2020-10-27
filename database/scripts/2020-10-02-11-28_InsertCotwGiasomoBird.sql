USE RTK;

SET @script = '2020-10-02-11-28_InsertCotwGiasomoBird.sql';

DELIMITER $$

DROP PROCEDURE IF EXISTS sp $$

CREATE PROCEDURE sp(
	IN scriptName VARCHAR(255)
)

BEGIN
	IF NOT EXISTS (SELECT * FROM MigrationHistory WHERE Script = scriptName) THEN
		CREATE TEMPORARY TABLE tmptable_1 SELECT * FROM Mobs WHERE MobId = 562;
		UPDATE tmptable_1 SET MobId = 807, MobIdentifier = 'cotw_giasomo_bird', MobDescription = 'Giasomo bird', MobLook = 58, MobLookColor = 0;
		INSERT INTO Mobs SELECT * FROM tmptable_1;
		DROP TEMPORARY TABLE IF EXISTS tmptable_1;

		INSERT INTO `MigrationHistory` (Script,Timestamp) VALUES (scriptName,NOW());
	ELSE
		SELECT CONCAT(scriptName, ' was skipped because it is already present in the migration history.') AS '';
	END IF;
END $$

CALL sp(@script) $$

DROP PROCEDURE IF EXISTS sp $$
 
DELIMITER ;
