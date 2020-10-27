USE RTK;

SET @script = '2020-10-24-07-41_InsertMagisBanePoet.sql';

DELIMITER $$

DROP PROCEDURE IF EXISTS sp $$

CREATE PROCEDURE sp(
	IN scriptName VARCHAR(255)
)

BEGIN
	IF NOT EXISTS (SELECT * FROM MigrationHistory WHERE Script = scriptName) THEN
		CREATE TEMPORARY TABLE tmptable_1 SELECT * FROM Spells WHERE SplId = 3167;
		UPDATE tmptable_1 SET SplId = 4729, SplIdentifier = 'magis_bane_poet', SplPthId = 4;
		INSERT INTO Spells SELECT * FROM tmptable_1;
		DROP TEMPORARY TABLE IF EXISTS tmptable_1;
		
		UPDATE Spells SET SplDescription = 'Magi\'s Bane' WHERE SplDescription = 'Magi\'s bane';

		INSERT INTO `MigrationHistory` (Script,Timestamp) VALUES (scriptName,NOW());
	ELSE
		SELECT CONCAT(scriptName, ' was skipped because it is already present in the migration history.') AS '';
	END IF;
END $$

CALL sp(@script) $$

DROP PROCEDURE IF EXISTS sp $$
 
DELIMITER ;
