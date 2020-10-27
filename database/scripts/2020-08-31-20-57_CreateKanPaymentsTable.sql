USE RTK;

SET @script = '2020-08-31-20-57_CreateKanPaymentsTable.sql';

DELIMITER $$

DROP PROCEDURE IF EXISTS sp $$

CREATE PROCEDURE sp(
	IN scriptName VARCHAR(255)
)

BEGIN
	IF NOT EXISTS (SELECT * FROM MigrationHistory WHERE Script = scriptName) THEN
		-- ----------------------------
		-- Create KanPayment table
		-- ----------------------------
		DROP TABLE IF EXISTS `KanPayments`;
		CREATE TABLE `KanPayments` (
		  `Id` varchar(50) NOT NULL,
		  `Status` varchar(20) NOT NULL,
		  `Total` decimal(12,2) unsigned NOT NULL,
		  `AdjustedTotal` decimal(12,2) unsigned NOT NULL,
		  `Currency` varchar(10) NOT NULL,
		  `CustomPaymentId` varchar(50) UNIQUE NOT NULL,
		  `CustomStoreReference` varchar(50) NULL,
		  `CallbackData` varchar(100) NULL,
		  `CustomerName` varchar(20) NOT NULL,
		  `CustomerEmail` varchar(100) NOT NULL,
		  `PaymentCurrency` varchar(10) NOT NULL,
		  `ReceivedAmount` decimal(12,2) NOT NULL,
		  `ReceivedDifference` decimal(12,2) NOT NULL,
		  `RedirectUrl` varchar(100) NOT NULL,
		  `SuccessUrl` varchar(100) NOT NULL,
		  `CancelUrl` varchar(100) NOT NULL,
		  `IpnUrl` varchar(100) NOT NULL,
		  `NotificationEmail` varchar(100) NULL,
		  `ConfirmationSpeed` varchar(10) NULL,
		  `ExpiresAt` datetime NOT NULL,
		  `CreatedAt` datetime NOT NULL,
		  `HasProcessed` tinyint(1) NOT NULL DEFAULT '0',
		  `LastModifiedAt` datetime NOT NULL,
		  PRIMARY KEY (`Id`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1;

		INSERT INTO `MigrationHistory` (Script,Timestamp) VALUES (scriptName,NOW());
	ELSE
		SELECT CONCAT(scriptName, ' was skipped because it is already present in the migration history.') AS '';
	END IF;
END $$

CALL sp(@script) $$

DROP PROCEDURE IF EXISTS sp $$
 
DELIMITER ;
