CREATE DATABASE IF NOT EXISTS `RTK`;

USE `RTK`;

SET @script = '2020-07-04-14-45_CreateRtkDatabaseAndUser.sql';

DELIMITER $$

DROP PROCEDURE IF EXISTS sp $$

CREATE PROCEDURE sp(
	IN scriptName VARCHAR(255)
)

BEGIN
	IF NOT EXISTS (SELECT * FROM mysql.`user` WHERE `User` = 'rtk' AND Host = '%') THEN
		CREATE USER 'rtk'@'%' IDENTIFIED BY '50LM8U8Poq5uX2AZJVKs'; -- Password should match the one used in docker-compose.yml
	END IF;
	
	GRANT ALL PRIVILEGES ON *.* TO 'rtk'@'%';
	FLUSH PRIVILEGES;
	
	IF NOT EXISTS (SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'RTK' AND TABLE_NAME = 'MigrationHistory') THEN
		/*!40101 SET NAMES utf8 */;
		/*!40103 SET TIME_ZONE='-05:00' */;
		
		DROP TABLE IF EXISTS `MigrationHistory`;
		
		CREATE TABLE `MigrationHistory` (
		  `Id` int(10) NOT NULL AUTO_INCREMENT,
		  `Script` varchar(255) NOT NULL,
		  `Timestamp` datetime NOT NULL,
		  PRIMARY KEY (`Id`)
		) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
		
		INSERT INTO `MigrationHistory` (Script,Timestamp) VALUES (scriptName,NOW());
	ELSE
		SELECT CONCAT(scriptName, ' was skipped because it is already present in the migration history.') AS '';
	END IF;
END $$

CALL sp(@script) $$

DROP PROCEDURE IF EXISTS sp $$
 
DELIMITER ;
