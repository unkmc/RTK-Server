USE RTK;

SET @script = '2020-07-14-21-30_AddTigerSentries.sql';

DELIMITER $$

DROP PROCEDURE IF EXISTS sp $$

CREATE PROCEDURE sp(
	IN scriptName VARCHAR(255)
)

BEGIN
	IF NOT EXISTS (SELECT * FROM MigrationHistory WHERE Script = scriptName) THEN
		-- ----------------------------
		-- Add Tiger sentry/guardian/defender to the Mobs table
		-- ----------------------------
		INSERT INTO `Mobs` VALUES ('804','tiger_sentry','Tiger sentry','1','0','0','0','0','130','31','278500','0','1675000','94','0','94','0','2600','4050','1000','1000','30','0','99','94','0','0','5','-72','9','0','0','0','0','0','0','0','0');
		INSERT INTO `Mobs` VALUES ('805','tiger_guardian','Tiger guardian','1','0','0','0','0','130','32','1075000','0','7850000','99','0','99','0','13000','20250','1000','1000','30','0','99','99','0','0','5','-83','9','0','0','0','0','0','0','0','0');
		INSERT INTO `Mobs` VALUES ('806','tiger_defender','Tiger defender','1','0','0','0','0','130','33','5550000','0','10000000','99','0','99','0','72750','113750','1000','1000','30','0','130','173','0','0','5','-95','9','0','0','0','0','0','0','0','0');

		INSERT INTO `MigrationHistory` (Script,Timestamp) VALUES (scriptName,NOW());
	ELSE
		SELECT CONCAT(scriptName, ' was skipped because it is already present in the migration history.') AS '';
	END IF;
END $$

CALL sp(@script) $$

DROP PROCEDURE IF EXISTS sp $$
 
DELIMITER ;
