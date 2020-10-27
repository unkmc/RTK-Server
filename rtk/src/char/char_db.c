#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mmo.h"
#include "rndm.h"
#include "version.h"
#include "malloc.h"
#include "char.h"
#include "char_db.h"
#include "zlib.h"
#include "md5calc.h"
#include "strlib.h"
#include "timer.h"

#ifdef USE_MYSQL
#include "db_mysql.h"

void char_db_init() {
	sql_handle = Sql_Malloc();
	if (sql_handle == NULL) {
		Sql_ShowDebug(sql_handle);
		exit(EXIT_FAILURE);
	}
	if (SQL_ERROR == Sql_Connect(sql_handle, sql_id, sql_pw, sql_ip, (uint16)sql_port, sql_db))
	{
		Sql_ShowDebug(sql_handle);
		Sql_Free(sql_handle);
		exit(EXIT_FAILURE);
	}
}

void char_db_term() {
	Sql_Free(sql_handle);
	//sql_close();
}
char* lcase(char* input) {
	int i = 0;
	char* ret;

	CALLOC(ret, char, strlen(input));
	memset(ret, 0, strlen(input));
	if (ret == NULL) {
		printf("wtf!");
		return input;
	}

	for (i = 0; i < strlen(input); i++) {
		ret[i] = tolower(input[i]);
	}

	//if(strlen(ret)!=strlen(input)) {
	ret[strlen(input)] = '\0';
	//}

	return ret;
}

///Determines if the Password given matches the one in DB
int ispass(char* name, char* pass, char* md5) {
	char md52[255] = "";
	char md53[255] = "";
	char buf[255] = "";
	char buf2[255] = "";

	char name2[32] = "";
	char pass2[32] = "";

	strcpy(name2, name);

	strcpy(pass2, pass);

	sprintf(buf, "%s %s", strlwr(name2), pass2);
	sprintf(buf2, "%s", pass2);

	MD5_String(buf, md52);
	MD5_String(buf2, md53);

	//printf("old: %s md5: %s\n",buf,md52);
	//printf("new: %s md5: %s\n",buf2,md53);

	if (!strcmp(md5, md52) || !strcmp(md5, md53)) { // Added to give backwards compatibility with passwords
		return 1;
	}
	else {
		return 0;
	}
}

///Determines if the Password given matches the Master in DB
int ismastpass(char* pass3, char* mastmd5, int expire) {
	char mastmd52[32] = "";

	time_t nowtime = time(NULL);
	time_t current = nowtime;

	MD5_String(pass3, mastmd52);
	printf("-----------\nTime: %d\nExpiration: %d\n", current, expire);

	//if there is a problem with the password, or the password has expired, then error out!
	if (!strcmp(mastmd5, mastmd52) && current <= expire) {
		return 1;
	}
	else {
		return 0;
	}
	//	printf("Entering master password check - mastmd5: %s - expire: %s- pass3: %s\n",mastmd5,expire,pass3);
}

///Attempt to find an existing ID that is available.
int find_new_id() {
	int x, newid = 0;

	SqlStmt* stmt;

	stmt = SqlStmt_Malloc(sql_handle);
	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT l.ChaId + 1 AS START FROM `Character` AS l LEFT OUTER JOIN `Character` AS r ON l.ChaId + 1 = r.ChaId WHERE r.ChaId IS NULL LIMIT 1")
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &newid, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}
	x = newid;
	SqlStmt_Free(stmt);

	//to Ensure no data exists when making.
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Banks` WHERE `BnkChaId` = '%u'", x)) Sql_ShowDebug(sql_handle);
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Aethers` WHERE `AthChaId` = '%u'", x)) Sql_ShowDebug(sql_handle);
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Equipment` WHERE `EqpChaId` = '%u'", x)) Sql_ShowDebug(sql_handle);
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Inventory` WHERE `InvChaId` = '%u'", x)) Sql_ShowDebug(sql_handle);
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Kills` WHERE `KilChaId` = '%u'", x)) Sql_ShowDebug(sql_handle);
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Legends` WHERE `LegChaId` = '%u'", x)) Sql_ShowDebug(sql_handle);
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `SpellBook` WHERE `SbkChaId` = '%u'", x)) Sql_ShowDebug(sql_handle);
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Registry` WHERE `RegChaId` = '%u'", x)) Sql_ShowDebug(sql_handle);
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `RegistryString` WHERE `RegChaId` = '%u'", x)) Sql_ShowDebug(sql_handle);
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `NPCRegistry` WHERE `NrgChaId` = '%u'", x)) Sql_ShowDebug(sql_handle);
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `QuestRegistry` WHERE `QrgChaId` = '%u'", x)) Sql_ShowDebug(sql_handle);
	if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Parcels` WHERE `ParSender` = '%u' AND `ParNpc` = '0'", x)) Sql_ShowDebug(sql_handle);

	return x;
}

/// Create New Character with given arguments.
int char_db_newchar(const char* name, const char* pass, int totem, int sex, int country, int face, int hair, int face_color, int hair_color) {
	int result;
	int newid = 0;

	result = char_db_isnameused(name);
	if (result)
		return result;

	newid = find_new_id();
	if (!newid) return 2;

	if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `Character` (`ChaId`,`ChaName`, `ChaPassword`, `ChaTotem`, `ChaSex`, `ChaNation`, `ChaFace`, `ChaMapID`, `ChaX`, `ChaY`, "
		"`ChaHair`, `ChaHairColor`, `ChaFaceColor`) VALUES ('%d', '%s', MD5('%s'), '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d')",
		newid, name, pass, totem, sex, country, face, start_pos.m, start_pos.x, start_pos.y, hair, hair_color, face_color)) {
		Sql_ShowDebug(sql_handle);
		return 2; //db error
	}

	return 0; //new character is ready!
}

/// Check to See if Character Name is used.
int char_db_isnameused(const char* name) {
	int newid = 0;
	SqlStmt* stmt;

	stmt = SqlStmt_Malloc(sql_handle);
	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaId` FROM `Character` WHERE `ChaName` = '%s'", name)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &newid, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		//SqlStmt_Free(stmt);
		return 2;
	}

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt)) {
		//SqlStmt_ShowDebug(stmt);
		//SqlStmt_Free(stmt);
		//return 0;
	}

	if (SqlStmt_NumRows(stmt) == 1) return 1; // name exists
	if (SqlStmt_NumRows(stmt) == 0) return 0; // name is free

	SqlStmt_Free(stmt);
}

/// Retrieve ID from Character Name
unsigned int char_db_idfromname(const char* name) {
	unsigned int result;
	unsigned int t_Result;
	SqlStmt* stmt;

	stmt = SqlStmt_Malloc(sql_handle);

	if (!stmt)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaId` FROM `Character` WHERE `ChaName` = '%s'", name)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_UINT, &t_Result, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0; //db error
	}

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt))
	{
		SqlStmt_Free(stmt);
		return 0;  //unknow charname
	}

	result = t_Result;
	SqlStmt_Free(stmt);
	return result; //here char id
}

/// Change Character Password
int char_db_setpass(const char* name, const char* pass, const char* newpass) {
	SqlStmt* stmt;
	char pass2[64] = "";

	stmt = SqlStmt_Malloc(sql_handle);
	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return -1;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaPassword` FROM `Character` WHERE `ChaName` = '%s'", name)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &pass2, sizeof(pass2), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return -1; //db_error
	}
	if (SQL_SUCCESS != SqlStmt_NextRow(stmt)) {
		SqlStmt_Free(stmt);
		return -2; //name doesn't exist
	}

	if (!ispass(name, pass, pass2)) {
		SqlStmt_Free(stmt);
		return -3; //wrong password, try again!
	}

	SqlStmt_Free(stmt);

	if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Character` SET `ChaPassword` = MD5('%s') WHERE `ChaName` = '%s'", newpass, name))
		return -1; //db_error

	return 0; //ok
}

int checkAccountBan(unsigned int id) {
	int accountid = 0;

	SqlStmt* stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `AccountId` FROM `Accounts` WHERE `AccountBanned` = '1' AND (`AccountCharId1` = '%u' OR `AccountCharId2` = '%u' OR `AccountCharId3` = '%u' OR `AccountCharId4` = '%u' OR `AccountCharId5` = '%u' OR `AccountCharId6` = '%u')", id, id, id, id, id, id)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_UINT, &accountid, 0, NULL, NULL))
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt))
	{
	}

	return accountid;
}

/// Getting Char From Login and Access Map Pointings
int char_db_mapfifofromlogin(const char* name, const char* pass, unsigned int* id) {
	int result;
	char md5[64] = "";
	char mastmd5[64] = "";
	char pass2[64] = "";
	int expiration = 0;
	int ban = 0;
	int map = 0;
	int nID = 0;
	SqlStmt* stmt;

	stmt = SqlStmt_Malloc(sql_handle);
	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return -1;
	}

	// pull character password md5 hash OR error our;
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaPassword` FROM `Character` WHERE `ChaName` = '%s'", name)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &md5, sizeof(md5), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return -1; //db_error
	}

	// pull master password md5 hash OR error our;

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt))
	{
		SqlStmt_Free(stmt);
		return -2; //name doesn't exist
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `AdmPassword`,`AdmTimer` FROM `AdminPassword` WHERE `AdmId` = '1'")
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &mastmd5, sizeof(mastmd5), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_INT, &expiration, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return -1; //db_error
	}

	SqlStmt_NextRow(stmt);

	//SqlStmt_Free(stmt);

	//Check whether for wrong user password or master password
	if (!ispass(name, pass, md5) && !ismastpass(pass, mastmd5, expiration))
	{
		SqlStmt_Free(stmt);
		return -3; //wrong password, try again!
	}

	//SqlStmt_FreeResult(stmt);
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaId`, `ChaPassword`, `ChaBanned`, `ChaMapId` FROM `Character` WHERE `ChaName` = '%s'", name)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_UINT, &nID, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_STRING, &pass2, sizeof(pass2), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_UCHAR, &ban, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_USHORT, &map, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return -1; //db_error
	}

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt))
	{
		SqlStmt_Free(stmt);
		return -2; //name doesn't exist
	}

	unsigned int accountBan = checkAccountBan(nID);

	if (ban || accountBan)
		return -4; //you are banned, go away

	result = mapfifo_from_mapid(map); //set mapfifo
	if (result == -1)
		return 0; //chaos is rising

	//printf("nID: %d\n",nID);
	*id = nID;
	SqlStmt_Free(stmt);
	return result; //all ok, return id number
}

///Retrieve Character from Database.
int mmo_char_fromdb(unsigned int id, struct mmo_charstatus* p, char* login_name) {
	SqlStmt* stmt;
	int i = 0;
	unsigned int pos = 0;
	unsigned short magic_id = 0;
	struct mmo_charstatus a;
	struct item item;
	struct skill_info skill;
	struct global_reg reg;
	struct global_regstring regstr;
	struct legend legend;
	struct kill_reg killreg;
	struct bank_data bank;
	char escape1[16];

	nullpo_chk(p);

	memset(&a, 0, sizeof(a));
	memset(&item, 0, sizeof(item));
	memset(&skill, 0, sizeof(skill));
	memset(&reg, 0, sizeof(reg));
	memset(&regstr, 0, sizeof(regstr));
	memset(&legend, 0, sizeof(legend));
	memset(&killreg, 0, sizeof(killreg));
	memset(&bank, 0, sizeof(bank));

	stmt = SqlStmt_Malloc(sql_handle);
	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return -1;
	}

	//Update character name from login name
	Sql_EscapeString(sql_handle, escape1, login_name);
	Sql_Query(sql_handle, "UPDATE `Character` SET `ChaName` = '%s' WHERE `ChaId` = '%u'", escape1, id);

	//Char status read
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaName`, `ChaClnId`, `ChaClanTitle`, `ChaTitle`, `ChaF1Name`, `ChaLevel`, `ChaPthId`, `ChaMark`, " //0-7
		"`ChaTotem`, `ChaKarma`, `ChaCurrentVita`, `ChaBaseVita`, `ChaCurrentMana`, `ChaBaseMana`, `ChaExperience`, `ChaGold`, `ChaSex`, "//8-16
		"`ChaNation`, `ChaFace`, `ChaHairColor`, `ChaArmorColor`, `ChaMapId`, `ChaX`, `ChaY`, `ChaSide`, `ChaState`, `ChaHair`, `ChaFaceColor`, " //17-27
		"`ChaSkinColor`, `ChaPartner`,`ChaClanChat`,`ChaPathChat`, `ChaNoviceChat`, `ChaSettings`,`ChaGMLevel`,`ChaDisguise`,`ChaDisguiseColor`, `ChaMaximumBankSlots`, " //28-36
		"`ChaBankGold`, `ChaMaximumInventory`, `ChaPK`, `ChaKilledBy`, `ChaKillsPK`, `ChaPKDuration`, `ChaMuted`, `ChaHeroes`, `ChaTier`, " //37-46
		"`ChaExperienceSoldMagic`, `ChaExperienceSoldHealth`, `ChaExperienceSoldStats`, `ChaBaseMight`, `ChaBaseWill`, `ChaBaseGrace`, "
		"`ChaBaseArmor`, `ChaMiniMapToggle`, `ChaLastIP`, `ChaAFKMessage`, `ChaTutor`, `ChaAlignment`, `ChaProfileVitaStats`,`ChaProfileEquipList`, "
		"`ChaProfileLegends`, `ChaProfileSpells`, `ChaProfileInventory`, `ChaProfileBankItems`, `ChaPthRank`, `ChaClnRank` FROM `Character` WHERE `ChaId` = '%u' LIMIT 1", id) //47

		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &a.name, sizeof(a.name), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_UINT, &a.clan, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_STRING, &a.clan_title, sizeof(a.clan_title), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_STRING, &a.title, sizeof(a.title), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 4, SQLDT_STRING, &a.f1name, sizeof(a.f1name), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 5, SQLDT_UCHAR, &a.level, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 6, SQLDT_UCHAR, &a.class, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 7, SQLDT_UCHAR, &a.mark, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 8, SQLDT_UCHAR, &a.totem, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 9, SQLDT_FLOAT, &a.karma, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 10, SQLDT_UINT, &a.hp, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 11, SQLDT_UINT, &a.basehp, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 12, SQLDT_UINT, &a.mp, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 13, SQLDT_UINT, &a.basemp, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 14, SQLDT_UINT, &a.exp, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 15, SQLDT_UINT, &a.money, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 16, SQLDT_UCHAR, &a.sex, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 17, SQLDT_UCHAR, &a.country, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 18, SQLDT_USHORT, &a.face, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 19, SQLDT_USHORT, &a.hair_color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 20, SQLDT_USHORT, &a.armor_color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 21, SQLDT_USHORT, &a.last_pos.m, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 22, SQLDT_USHORT, &a.last_pos.x, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 23, SQLDT_USHORT, &a.last_pos.y, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 24, SQLDT_CHAR, &a.side, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 25, SQLDT_CHAR, &a.state, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 26, SQLDT_USHORT, &a.hair, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 27, SQLDT_USHORT, &a.face_color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 28, SQLDT_USHORT, &a.skin_color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 29, SQLDT_UINT, &a.partner, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 30, SQLDT_CHAR, &a.clan_chat, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 31, SQLDT_CHAR, &a.subpath_chat, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 32, SQLDT_CHAR, &a.novice_chat, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 33, SQLDT_USHORT, &a.settingFlags, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 34, SQLDT_CHAR, &a.gm_level, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 35, SQLDT_USHORT, &a.disguise, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 36, SQLDT_USHORT, &a.disguisecolor, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 37, SQLDT_UINT, &a.maxslots, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 38, SQLDT_UINT, &a.bankmoney, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 39, SQLDT_UCHAR, &a.maxinv, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 40, SQLDT_UCHAR, &a.pk, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 41, SQLDT_UINT, &a.killedby, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 42, SQLDT_UINT, &a.killspk, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 43, SQLDT_UINT, &a.pkduration, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 44, SQLDT_UCHAR, &a.mute, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 45, SQLDT_UINT, &a.heroes, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 46, SQLDT_UCHAR, &a.tier, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 47, SQLDT_ULONGLONG, &a.expsoldmagic, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 48, SQLDT_ULONGLONG, &a.expsoldhealth, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 49, SQLDT_ULONGLONG, &a.expsoldstats, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 50, SQLDT_UINT, &a.basemight, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 51, SQLDT_UINT, &a.basewill, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 52, SQLDT_UINT, &a.basegrace, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 53, SQLDT_INT, &a.basearmor, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 54, SQLDT_UINT, &a.miniMapToggle, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 55, SQLDT_STRING, &a.ipaddress, sizeof(a.ipaddress), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 56, SQLDT_STRING, &a.afkmessage, sizeof(a.afkmessage), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 57, SQLDT_UCHAR, &a.tutor, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 58, SQLDT_CHAR, &a.alignment, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 59, SQLDT_UCHAR, &a.profile_vitastats, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 60, SQLDT_UCHAR, &a.profile_equiplist, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 61, SQLDT_UCHAR, &a.profile_legends, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 62, SQLDT_UCHAR, &a.profile_spells, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 63, SQLDT_UCHAR, &a.profile_inventory, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 64, SQLDT_UCHAR, &a.profile_bankitems, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 65, SQLDT_UCHAR, &a.classRank, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 66, SQLDT_UCHAR, &a.clanRank, 0, NULL, NULL))

	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt))
	{
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}
	memcpy(p, &a, sizeof(a));

	p->id = id;
	if (strcmpi(a.name, login_name)) {
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}
	memcpy(p->name, login_name, 16);

	//Read Bank
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `BnkEngrave`, `BnkItmId`,`BnkAmount`,`BnkChaIdOwner`, `BnkPosition`, `BnkCustomLook`, `BnkCustomLookColor`, `BnkCustomIcon`, `BnkCustomIconColor`, `BnkProtected`, `BnkNote` FROM `Banks` WHERE `BnkChaId` = '%u' LIMIT %d", id, MAX_BANK_SLOTS)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &bank.real_name, sizeof(bank.real_name), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_UINT, &bank.item_id, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_UINT, &bank.amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_UINT, &bank.owner, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 4, SQLDT_UCHAR, &pos, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 5, SQLDT_UINT, &bank.customLook, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 6, SQLDT_UINT, &bank.customLookColor, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 7, SQLDT_UINT, &bank.customIcon, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 8, SQLDT_UINT, &bank.customIconColor, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 9, SQLDT_UINT, &bank.protected, 0, NULL, NULL)

		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 10, SQLDT_STRING, &bank.note, sizeof(bank.note), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	memset(&p->banks, 0, sizeof(bank) * MAX_BANK_SLOTS);

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->banks[pos], &bank, sizeof(bank));
	}

	//Read Inventory
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `InvEngrave`, `InvItmId`, `InvAmount`, `InvDurability`, `InvChaIdOwner`, `InvTimer`, `InvPosition`, `InvCustom`, `InvCustomLook`, `InvCustomLookColor`, `InvCustomIcon`, `InvCustomIconColor`, `InvProtected`, `InvNote` FROM `Inventory` WHERE `InvChaId` = '%u' LIMIT %d", id, MAX_INVENTORY)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &item.real_name, sizeof(item.real_name), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_UINT, &item.id, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_UINT, &item.amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_UINT, &item.dura, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 4, SQLDT_UINT, &item.owner, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 5, SQLDT_UINT, &item.time, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 6, SQLDT_UCHAR, &pos, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 7, SQLDT_UINT, &item.custom, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 8, SQLDT_UINT, &item.customLook, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 9, SQLDT_UINT, &item.customLookColor, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 10, SQLDT_UINT, &item.customIcon, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 11, SQLDT_UINT, &item.customIconColor, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 12, SQLDT_UINT, &item.protected, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 13, SQLDT_STRING, &item.note, sizeof(item.note), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	memset(&p->inventory, 0, sizeof(item) * MAX_INVENTORY);

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->inventory[pos], &item, sizeof(item));
	}

	//Equip Read
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `EqpEngrave`, `EqpItmId`, '1', `EqpDurability`, `EqpChaIdOwner`, `EqpTimer`, `EqpSlot`, `EqpCustom`, `EqpCustomLook`, `EqpCustomLookColor`, `EqpCustomIcon`, `EqpCustomIconColor`, `EqpProtected`, `EqpNote` FROM `Equipment` WHERE `EqpChaId` = '%u' LIMIT %d", id, MAX_EQUIP)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &item.real_name, sizeof(item.real_name), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_UINT, &item.id, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_UINT, &item.amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_UINT, &item.dura, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 4, SQLDT_UINT, &item.owner, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 5, SQLDT_UINT, &item.time, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 6, SQLDT_UCHAR, &pos, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 7, SQLDT_UINT, &item.custom, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 8, SQLDT_UINT, &item.customLook, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 9, SQLDT_UINT, &item.customLookColor, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 10, SQLDT_UINT, &item.customIcon, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 11, SQLDT_UINT, &item.customIconColor, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 12, SQLDT_UINT, &item.protected, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 13, SQLDT_STRING, &item.note, sizeof(item.note), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;

		return -1;
	}

	//Equip Read
	memset(&p->equip, 0, sizeof(item) * MAX_EQUIP);

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->equip[pos], &item, sizeof(item));
	}

	//Skill Read
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `SbkSplId`, `SbkPosition` FROM `SpellBook` WHERE `SbkChaId` = '%u'", id)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_USHORT, &magic_id, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_USHORT, &pos, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	memset(&p->skill, 0, sizeof(unsigned short) * MAX_SPELLS);

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->skill[pos], &magic_id, sizeof(unsigned short));
	}

	//Duration & Aether Information
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `AthAether`, `AthSplId`, `AthDuration`, `AthPosition` FROM `Aethers` WHERE `AthChaId` = '%u' LIMIT %d", id, MAX_MAGIC_TIMERS)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &skill.aether, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_USHORT, &skill.id, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_INT, &skill.duration, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_UCHAR, &pos, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	memset(&p->dura_aether, 0, sizeof(skill) * MAX_MAGIC_TIMERS);

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->dura_aether[pos], &skill, sizeof(skill));
	}

	//Reg Read
	p->global_reg_num = 0;
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `RegIdentifier`, `RegValue` FROM `Registry` WHERE `RegChaId` = '%u' LIMIT %d", id, MAX_GLOBALPLAYERREG)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &reg.str, sizeof(reg.str), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_UINT, &reg.val, sizeof(reg.val), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	p->global_reg_num = 0;

	for (i = 0; i < MAX_GLOBALPLAYERREG && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->global_reg[i], &reg, sizeof(reg));
		p->global_reg_num++;
	}

	//Reg Read
	p->global_regstring_num = 0;
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `RegIdentifier`, `RegValue` FROM `RegistryString` WHERE `RegChaId` = '%u' LIMIT %d", id, MAX_GLOBALPLAYERREG)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &regstr.str, sizeof(regstr.str), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_STRING, &regstr.val, sizeof(regstr.val), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	p->global_regstring_num = 0;

	for (i = 0; i < MAX_GLOBALPLAYERREG && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->global_regstring[i], &regstr, sizeof(regstr));
		p->global_regstring_num++;
	}

	//NPC Interaction Registry read
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `NrgIdentifier`, `NrgValue` FROM `NPCRegistry` WHERE `NrgChaId` = '%u' LIMIT %d", id, MAX_GLOBALNPCREG)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &reg.str, sizeof(reg.str), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_UINT, &reg.val, sizeof(reg.val), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	for (i = 0; i < MAX_GLOBALNPCREG && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->npcintreg[i], &reg, sizeof(reg));
	}

	//Quest Registry read
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `QrgIdentifier`, `QrgValue` FROM `QuestRegistry` WHERE `QrgChaId` = '%u' LIMIT %d", id, MAX_GLOBALQUESTREG)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &reg.str, sizeof(reg.str), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_UINT, &reg.val, sizeof(reg.val), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	for (i = 0; i < MAX_GLOBALQUESTREG && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->questreg[i], &reg, sizeof(reg));
	}

	/*//Acctreg read
	if(SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ArgIdentifier`, `ArgValue` FROM `AccountRegistry` WHERE `ArgActId` = '%u' LIMIT %d", actid, MAX_GLOBALREG)
	|| SQL_ERROR == SqlStmt_Execute(stmt)
	|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &reg.str,sizeof(reg.str),NULL,NULL)
	|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_UINT, &reg.val, sizeof(reg.val), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	for(i = 0; i < MAX_GLOBALREG && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->acctreg[i], &reg, sizeof(reg));
	}*/

	//Legend read
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `LegPosition`,`LegIcon`,`LegColor`,`LegDescription`,`LegIdentifier`, `LegTChaId` FROM `Legends` WHERE `LegChaId`= '%u' LIMIT %d", id, MAX_LEGENDS)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_USHORT, &pos, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_USHORT, &legend.icon, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_USHORT, &legend.color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_STRING, &legend.text, sizeof(legend.text), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 4, SQLDT_STRING, &legend.name, sizeof(legend.name), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 5, SQLDT_UINT, &legend.tchaid, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	memset(&p->legends, 0, sizeof(legend) * MAX_LEGENDS);

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->legends[pos], &legend, sizeof(legend));
	}

	//Kill Count Read
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `KilPosition`,`KilMobId`,`KilAmount` FROM `Kills` WHERE `KilChaId`= '%u' LIMIT %d", id, MAX_KILLREG)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_UINT, &pos, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_UINT, &killreg.mob_id, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_UINT, &killreg.amount, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		p->id = 0;
		return -1;
	}

	memset(&p->killreg, 0, sizeof(killreg) * MAX_KILLREG);

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		memcpy(&p->killreg[pos], &killreg, sizeof(killreg));
	}

	//Guide Read
	//sql_request("SELECT `pos`,`guide_id` FROM `guide` WHERE `char_id`='%u'",p->id);
	//item_num=sql_num_row();
	//for(i=0;i<item_num;i++) {
	//	if(sql_get_row())
	//		break;

	//	p->guide[sql_get_int(0)]=sql_get_int(1);
	//}
	//sql_free_row();

	SqlStmt_Free(stmt);
	//generate_key(login_name,&(p->EncKey),16);
	//printf("Key: %s (%s)\n",login_name,p->EncKey);
	return 0;
}

//Save bank data to DB
int membankdata_todb(struct bank_data bank[], int max, int id) {
	SqlStmt* stmt;
	int save_id[max];
	int item_id = -1;
	int i;
	char escape[64];
	char escape2[300];

	memset(save_id, 0, max * sizeof(int));
	stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `BnkPosition` FROM `Banks` WHERE `BnkChaId` = '%u' LIMIT %d", id, MAX_BANK_SLOTS)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &item_id, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	for (i = 0; i < max; i++)
		save_id[i] = -1;

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++)
		save_id[item_id] = item_id;

	SqlStmt_Free(stmt);

	for (i = 0; i < max; i++) {
		Sql_EscapeString(sql_handle, escape, bank[i].real_name);
		Sql_EscapeString(sql_handle, escape2, bank[i].note);

		if (save_id[i] == i) {
			if (bank[i].item_id == 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Banks` WHERE `BnkChaId` = '%u' AND `BnkPosition` = '%d'", id, i)) {
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
			else {
				if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Banks` SET `BnkItmId` = '%u', `BnkAmount` = '%u', `BnkChaIdOwner` = '%u', `BnkTimer` = '%u', `BnkEngrave` = '%s', `BnkCustomLook` = '%u', `BnkCustomLookColor` = '%u', `BnkCustomIcon` = '%u', `BnkCustomIconColor` = '%u', `BnkProtected` = '%d', `BnkNote` = '%s' WHERE `BnkChaId` = '%u' AND `BnkPosition` = '%d'",
					bank[i].item_id, bank[i].amount, bank[i].owner, bank[i].time, escape, bank[i].customLook, bank[i].customLookColor, bank[i].customIcon, bank[i].customIconColor, bank[i].protected, escape2, id, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
		else {
			if (bank[i].item_id > 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `Banks` (`BnkChaId`, `BnkItmId`, `BnkAmount`, `BnkChaIdOwner`, `BnkTimer`, `BnkEngrave`, `BnkCustomLook`, `BnkCustomLookColor`, `BnkCustomIcon`, `BnkCustomIconColor`, `BnkProtected`, `BnkNote`, `BnkPosition`) VALUES ('%u', '%u', '%u', '%u', '%u', '%s', '%u', '%u', '%u', '%u', '%d', '%s', '%d')",
					id, bank[i].item_id, bank[i].amount, bank[i].owner, bank[i].time, escape, bank[i].customLook, bank[i].customLookColor, bank[i].customIcon, bank[i].customIconColor, bank[i].protected, escape2, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
	}

	return 1;
}

//Save item data to DB
int meminvdata_todb(struct item items[], int max, int id) {
	SqlStmt* stmt;
	struct item item;
	StringBuf buf;
	int save_id[max];
	int item_id = -1;
	int i;
	char escape[255];

	memset(save_id, 0, max * sizeof(int));
	stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `InvPosition` FROM `Inventory` WHERE `InvChaId` = '%u' LIMIT %d", id, MAX_INVENTORY)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &item_id, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	for (i = 0; i < max; i++)
		save_id[i] = -1;

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++)
		save_id[item_id] = item_id;

	SqlStmt_Free(stmt);

	for (i = 0; i < max; i++) {
		Sql_EscapeString(sql_handle, escape, items[i].real_name);

		if (save_id[i] == i) {
			if (items[i].id == 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Inventory` WHERE `InvChaId` = '%u' AND `InvPosition` = '%d'", id, i)) {
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
			else {
				if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Inventory` SET `InvItmId` = '%u', `InvAmount` = '%u', `InvDurability` = '%u', `InvChaIdOwner` = '%u', `InvCustom` = '%u', `InvTimer` = '%u', `InvEngrave` = '%s', `InvCustomLook` = '%u', `InvCustomLookColor` = '%u', `InvCustomIcon` = '%u', `InvCustomIconColor` = '%u', `InvProtected` = '%d', `InvNote` = '%s' WHERE `InvChaId` = '%u' AND `InvPosition` = '%d'",
					items[i].id, items[i].amount, items[i].dura, items[i].owner, items[i].custom, items[i].time, escape, items[i].customLook, items[i].customLookColor, items[i].customIcon, items[i].customIconColor, items[i].protected, items[i].note, id, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
		else
		{
			if (items[i].id > 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `Inventory` (`InvChaId`, `InvItmId`, `InvAmount`, `InvDurability`, `InvChaIdOwner`, `InvCustom`, `InvTimer`, `InvEngrave`, `InvCustomLook`, `InvCustomLookColor`, `InvCustomIcon`, `InvCustomIconColor`, `InvProtected`, `InvNote`, `InvPosition`) VALUES ('%u', '%u', '%u', '%u', '%u', '%u', '%u', '%s', '%u', '%u', '%u', '%u', '%d', '%s', '%u')",
					id, items[i].id, items[i].amount, items[i].dura, items[i].owner, items[i].custom, items[i].time, escape, items[i].customLook, items[i].customLookColor, items[i].customIcon, items[i].customIconColor, items[i].protected, items[i].note, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
	}

	return 1;
}

//Save item data to DB
int memeqpdata_todb(struct item items[], int max, int id) {
	SqlStmt* stmt;
	struct item item;
	StringBuf buf;
	int save_id[max];
	int item_id = -1;
	int i;
	char escape[255];

	memset(save_id, 0, max * sizeof(int));
	stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `EqpSlot` FROM `Equipment` WHERE `EqpChaId` = '%u' LIMIT %d", id, MAX_EQUIP)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &item_id, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	for (i = 0; i < max; i++)
		save_id[i] = -1;

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++)
		save_id[item_id] = item_id;

	SqlStmt_Free(stmt);

	for (i = 0; i < max; i++) {
		Sql_EscapeString(sql_handle, escape, items[i].real_name);

		if (save_id[i] == i) {
			if (items[i].id == 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Equipment` WHERE `EqpChaId` = '%u' AND `EqpSlot` = '%d'", id, i)) {
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
			else {
				if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Equipment` SET `EqpItmId` = '%u', `EqpDurability` = '%u', `EqpChaIdOwner` = '%u', `EqpTimer` = '%u', `EqpEngrave` = '%s', `EqpCustomLook` = '%u', `EqpCustomLookColor` = '%u', `EqpCustomIcon` = '%u', `EqpCustomIconColor` = '%u', `EqpProtected` = '%d', `EqpNote` = '%s' WHERE `EqpChaId` = '%u' AND `EqpSlot` = '%d'",
					items[i].id, items[i].dura, items[i].owner, items[i].time, escape, items[i].customLook, items[i].customLookColor, items[i].customIcon, items[i].customIconColor, items[i].protected, items[i].note, id, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
		else
		{
			if (items[i].id > 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `Equipment` (`EqpChaId`, `EqpItmId`, `EqpDurability`, `EqpChaIdOwner`, `EqpTimer`, `EqpEngrave`, `EqpCustomLook`, `EqpCustomLookColor`, `EqpCustomIcon`, `EqpCustomIconColor`, `EqpProtected`, `EqpNote`, `EqpSlot`) VALUES ('%u', '%u', '%u', '%u', '%u', '%s', '%u', '%u', '%u', '%u', '%d', '%s', '%u')",
					id, items[i].id, items[i].dura, items[i].owner, items[i].time, escape, items[i].customLook, items[i].customLookColor, items[i].customIcon, items[i].customIconColor, items[i].protected, items[i].note, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
	}

	return 1;
}
//Registry to Database
int memreg_todb(struct global_reg regs[], int max, int id) {
	SqlStmt* stmt;
	int save_id[max];
	int regid = -1;
	int i;

	memset(save_id, 0, max * sizeof(int));
	stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `RegPosition` FROM `Registry` WHERE `RegChaId` = '%u' LIMIT %d", id, MAX_GLOBALPLAYERREG)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &regid, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	for (i = 0; i < max; i++)
		save_id[i] = -1;

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++)
		save_id[regid] = regid;

	SqlStmt_Free(stmt);

	for (i = 0; i < max; i++) {
		if (save_id[i] == i) {
			if (regs[i].val == 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Registry` WHERE `RegChaId` = '%u' AND `RegPosition` = '%d'", id, i)) {
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
			else {
				if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Registry` SET `RegIdentifier` = '%s', `RegValue` = '%u' WHERE `RegChaId` = '%u' AND `RegPosition` = '%d'",
					regs[i].str, regs[i].val, id, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
		else
		{
			if (regs[i].val > 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `Registry` (`RegChaId`, `RegIdentifier`, `RegValue`, `RegPosition`) VALUES ('%u', '%s', '%u', '%d')",
					id, regs[i].str, regs[i].val, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
	}

	return 1;
}

//Registry to Database
int memregstring_todb(struct global_regstring regs[], int max, int id) {
	SqlStmt* stmt;
	int save_id[max];
	int regid = -1;
	int i;

	memset(save_id, 0, max * sizeof(int));
	stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `RegPosition` FROM `RegistryString` WHERE `RegChaId` = '%u' LIMIT %d", id, MAX_GLOBALPLAYERREG)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &regid, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	for (i = 0; i < max; i++)
		save_id[i] = -1;

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++)
		save_id[regid] = regid;

	SqlStmt_Free(stmt);

	for (i = 0; i < max; i++) {
		if (save_id[i] == i) {
			if (strcmp(regs[i].val, "") == 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `RegistryString` WHERE `RegChaId` = '%u' AND `RegPosition` = '%d'", id, i)) {
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
			else {
				if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `RegistryString` SET `RegIdentifier` = '%s', `RegValue` = '%s' WHERE `RegChaId` = '%u' AND `RegPosition` = '%d'",
					regs[i].str, regs[i].val, id, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
		else
		{
			if (strcmp(regs[i].val, "") != 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `RegistryString` (`RegChaId`, `RegIdentifier`, `RegValue`, `RegPosition`) VALUES ('%u', '%s', '%s', '%d')",
					id, regs[i].str, regs[i].val, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
	}

	return 1;
}

//Registry to Database
int memnpcreg_todb(struct global_reg regs[], int max, int id) {
	SqlStmt* stmt;
	int save_id[max];
	int regid = -1;
	int i;

	memset(save_id, 0, max * sizeof(int));
	stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `NrgPosition` FROM `NPCRegistry` WHERE `NrgChaId` = '%u' LIMIT %d", id, MAX_GLOBALNPCREG)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &regid, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	for (i = 0; i < max; i++)
		save_id[i] = -1;

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++)
		save_id[regid] = regid;

	SqlStmt_Free(stmt);

	for (i = 0; i < max; i++) {
		if (save_id[i] == i) {
			if (regs[i].val == 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `NPCRegistry` WHERE `NrgChaId` = '%u' AND `NrgPosition` = '%d'", id, i)) {
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
			else {
				if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `NPCRegistry` SET `NrgIdentifier` = '%s', `NrgValue` = '%u' WHERE `NrgChaId` = '%u' AND `NrgPosition` = '%d'",
					regs[i].str, regs[i].val, id, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
		else
		{
			if (regs[i].val > 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `NPCRegistry` (`NrgChaId`, `NrgIdentifier`, `NrgValue`, `NrgPosition`) VALUES ('%u', '%s', '%u', '%d')",
					id, regs[i].str, regs[i].val, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
	}

	return 1;
}
//Registry to Database
int memquestreg_todb(struct global_reg regs[], int max, int id) {
	SqlStmt* stmt;
	int save_id[max];
	int regid = -1;
	int i;

	memset(save_id, 0, max * sizeof(int));
	stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `QrgPosition` FROM `QuestRegistry` WHERE `QrgChaId` = '%u' LIMIT %d", id, MAX_GLOBALQUESTREG)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &regid, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	for (i = 0; i < max; i++)
		save_id[i] = -1;

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++)
		save_id[regid] = regid;

	SqlStmt_Free(stmt);

	for (i = 0; i < max; i++) {
		if (save_id[i] == i) {
			if (regs[i].val == 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `QuestRegistry` WHERE `QrgChaId` = '%u' AND `QrgPosition` = '%d'", id, i)) {
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
			else {
				if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `QuestRegistry` SET `QrgIdentifier` = '%s', `QrgValue` = '%u' WHERE `QrgChaId` = '%u' AND `QrgPosition` = '%d'",
					regs[i].str, regs[i].val, id, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
		else
		{
			if (regs[i].val > 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `QuestRegistry` (`QrgChaId`, `QrgIdentifier`, `QrgValue`, `QrgPosition`) VALUES ('%u', '%s', '%u', '%d')",
					id, regs[i].str, regs[i].val, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
	}

	return 1;
}
//save skills to db
int memspells_todb(unsigned short skill[], int max, int id) {
	SqlStmt* stmt;
	int save_id[max];
	int magic_id = -1;
	int i;

	memset(save_id, 0, max * sizeof(int));
	stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `SbkPosition` FROM `SpellBook` WHERE `SbkChaId` = '%u' LIMIT %d", id, MAX_SPELLS)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &magic_id, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	for (i = 0; i < max; i++)
		save_id[i] = -1;

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++)
		save_id[magic_id] = magic_id;

	SqlStmt_Free(stmt);

	for (i = 0; i < max; i++) {
		if (save_id[i] == i) {
			if (skill[i] == 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `SpellBook` WHERE `SbkChaId` = '%u' AND `SbkPosition` = '%d'", id, i)) {
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
			else {
				if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `SpellBook` SET `SbkSplId` = '%u' WHERE `SbkChaId` = '%u' AND `SbkPosition` = '%d'",
					skill[i], id, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
		else {
			if (skill[i] > 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `SpellBook` (`SbkChaId`, `SbkSplId`, `SbkPosition`) VALUES ('%u', '%u', '%d')",
					id, skill[i], i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
	}

	return 1;
}
//save aethers to db
int memaethers_todb(struct skill_info dura_aether[], int max, int id) {
	SqlStmt* stmt;
	int save_id[max];
	int magic_id = -1;
	int i;

	memset(save_id, 0, max * sizeof(int));
	stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `AthPosition` FROM `Aethers` WHERE `AthChaId` = '%u' LIMIT %d", id, MAX_MAGIC_TIMERS)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &magic_id, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	for (i = 0; i < max; i++)
		save_id[i] = -1;

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++)
		save_id[magic_id] = magic_id;

	SqlStmt_Free(stmt);

	for (i = 0; i < max; i++) {
		if (save_id[i] == i) {
			if (dura_aether[i].id == 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Aethers` WHERE `AthChaId` = '%u' AND `AthPosition` = '%d'", id, i)) {
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
			else {
				if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Aethers` SET `AthSplId` = '%u', `AthDuration` = '%u', `AthAether` = '%d' WHERE `AthChaId` = '%u' AND `AthPosition` = '%u'",
					dura_aether[i].id, dura_aether[i].duration, dura_aether[i].aether, id, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
		else {
			if (dura_aether[i].id > 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `Aethers` (`AthChaId`, `AthSplId`, `AthDuration`, `AthAether`, `AthPosition`) VALUES ('%u', '%u', '%u', '%u', '%u')",
					id, dura_aether[i].id, dura_aether[i].duration, dura_aether[i].aether, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
	}

	return 1;
}
//save killcount to db
int memkillcount_todb(struct kill_reg killreg[], int max, int id) {
	SqlStmt* stmt;
	int save_id[max];
	int kill_id = -1;
	int i;

	memset(save_id, 0, max * sizeof(int));
	stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	//if(SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `KilPosition` FROM `Kills` WHERE `KilChaId` = '%u' ORDER BY `KilPosition` ASC LIMIT %d", id, MAX_GLOBALREG)
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `KilPosition` FROM `Kills` WHERE `KilChaId` = '%u' LIMIT %d", id, MAX_KILLREG)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &kill_id, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	for (i = 0; i < max; i++)
		save_id[i] = -1;

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++)
		save_id[kill_id] = kill_id;

	SqlStmt_Free(stmt);

	for (i = 0; i < max; i++) {
		if (save_id[i] == i) {
			if (killreg[i].mob_id == 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Kills` WHERE `KilChaId` = '%u' AND `KilPosition` = '%d'", id, i)) {
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
			else {
				if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Kills` SET `KilAmount` = '%u', `KilMobId` = '%u' WHERE `KilChaId` = '%u' AND `KilPosition` = '%u'",
					killreg[i].amount, killreg[i].mob_id, id, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
		else {
			if (killreg[i].mob_id > 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `Kills` (`KilChaId`, `KilMobId`, `KilAmount`, `KilPosition`) VALUES ('%u', '%u', '%d', '%d')",
					id, killreg[i].mob_id, killreg[i].amount, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
	}

	return 1;
}
//save legend to db
int memlegend_todb(struct legend legends[], int max, int id) {
	SqlStmt* stmt;
	int save_id[max];
	int legendid = -1;
	int i;
	char escape[255];

	memset(save_id, 0, max * sizeof(int));
	stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `LegPosition` FROM `Legends` WHERE `LegChaId` = '%u' LIMIT %d", id, MAX_LEGENDS)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &legendid, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	for (i = 0; i < max; i++)
		save_id[i] = -1;

	for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++)
		save_id[legendid] = legendid;

	SqlStmt_Free(stmt);

	for (i = 0; i < max; i++) {
		Sql_EscapeString(sql_handle, escape, legends[i].text);

		if (save_id[i] == i) {
			if (strcmpi(legends[i].name, "") == 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "DELETE FROM `Legends` WHERE `LegChaId` = '%u' AND `LegPosition` = '%d'", id, i)) {
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
			else {
				if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Legends` SET `LegIcon` = '%u', `LegColor` = '%u', `LegDescription` = '%s', `LegIdentifier` = '%s', `LegTChaId` = '%u' WHERE `LegChaId` = '%u' AND `LegPosition` = '%d'",
					legends[i].icon, legends[i].color, escape, legends[i].name, legends[i].tchaid, id, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
		else {
			if (strcmpi(legends[i].name, "") != 0) {
				if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `Legends` (`LegChaId`, `LegIcon`, `LegColor`, `LegDescription`, `LegIdentifier`, `LegTChaId`, `LegPosition`) VALUES ('%u', '%u', '%u', '%s', '%s', '%u', '%d')",
					id, legends[i].icon, legends[i].color, escape, legends[i].name, legends[i].tchaid, i))
				{
					Sql_ShowDebug(sql_handle);
					return 0;
				}
			}
		}
	}

	return 1;
}
///Save Character TO database
int mmo_char_todb(struct mmo_charstatus* p) {
	char escape1[16];
	char escape2[255];
	char escape3[255];
	char escape4[16];

	char escape6[80];
	int i;
	//char status save

	printf("Saving %s\n", p->name);

	Sql_EscapeString(sql_handle, escape1, p->name);
	Sql_EscapeString(sql_handle, escape2, p->title);
	Sql_EscapeString(sql_handle, escape3, p->clan_title);
	Sql_EscapeString(sql_handle, escape4, p->f1name);

	Sql_EscapeString(sql_handle, escape6, p->afkmessage);

	if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Character` SET `ChaName` = '%s', `ChaClnId` = '%u', `ChaClanTitle` = '%s', `ChaTitle` = '%s', `ChaLevel` = '%u', `ChaPthId` = '%u', `ChaMark` = '%u', "
		"`ChaTotem` = '%u', `ChaKarma` = '%f', `ChaCurrentVita` = '%u', `ChaBaseVita` = '%u', `ChaCurrentMana` = '%u', `ChaBaseMana` = '%u', `ChaExperience` = '%u', `ChaGold` = '%u', "
		"`ChaSex` = '%d', `ChaNation` = '%d', `ChaFace` = '%u', `ChaHairColor` = '%u', `ChaArmorColor` = '%u', `ChaMapId` = '%u', `ChaX` = '%u', `ChaY` = '%u', `ChaSide` = '%d', `ChaState` = '%d', "
		"`ChaHair` = '%u', `ChaFaceColor` = '%u', `ChaSkinColor` = '%u', `ChaPartner` = '%u', `ChaClanChat` = '%d', `ChaPathChat` = '%d', `ChaNoviceChat` = '%d', `ChaSettings` = '%u', `ChaGMLevel` = '%d', "
		"`ChaDisguise` = '%u', `ChaDisguiseColor` = '%u', `ChaMaximumBankSlots` = '%u', `ChaBankGold` = '%u', `ChaF1Name` = '%s', `ChaMaximumInventory` = '%u', `ChaPK` = '%u', `ChaKilledBy` = '%u', "
		"`ChaKillsPK` = '%u', `ChaPKDuration` = '%u', `ChaMuted` = '%u', `ChaHeroes` = '%u', `ChaTier` = '%u', `ChaExperienceSoldMagic` = '%llu', `ChaExperienceSoldHealth` = '%llu', `ChaExperienceSoldStats` = '%llu', `ChaBaseMight` = '%u', `ChaBaseGrace` = '%u', "
		"`ChaBaseWill` = '%u', `ChaBaseArmor` = '%i', `ChaMiniMapToggle` = '%u', `ChaHunter` = 0, `ChaAFKMessage` = '%s', `ChaTutor` = '%d', `ChaAlignment` = '%d', `ChaProfileVitaStats` = '%d', `ChaProfileEquipList` = '%d', "
		"`ChaProfileLegends` = '%d', `ChaProfileSpells` = '%d', `ChaProfileInventory` = '%d', `ChaProfileBankItems` = '%d', `ChaPthRank` = '%u', `ChaClnRank` = '%u' WHERE `ChaId` = '%u'",
		escape1, p->clan, escape3, escape2, p->level, p->class, p->mark,
		p->totem, p->karma, p->hp, p->basehp, p->mp, p->basemp, p->exp, p->money,
		p->sex, p->country, p->face, p->hair_color, p->armor_color, p->last_pos.m, p->last_pos.x, p->last_pos.y, p->side, p->state,
		p->hair, p->face_color, p->skin_color, p->partner, p->clan_chat, p->subpath_chat, p->novice_chat, p->settingFlags, p->gm_level,
		p->disguise, p->disguisecolor, p->maxslots, p->bankmoney, escape4, p->maxinv, p->pk, p->killedby,
		p->killspk, p->pkduration, p->mute, p->heroes, p->tier, p->expsoldmagic, p->expsoldhealth, p->expsoldstats, p->basemight, p->basegrace, p->basewill, p->basearmor,
		p->miniMapToggle, escape6, p->tutor, p->alignment, p->profile_vitastats, p->profile_equiplist, p->profile_legends, p->profile_spells, p->profile_inventory, p->profile_bankitems,
		p->classRank, p->clanRank, p->id))
	{
		Sql_ShowDebug(sql_handle);
		Sql_FreeResult(sql_handle);
		return 0;
	}

	//inventory save
	meminvdata_todb(p->inventory, MAX_INVENTORY, p->id);

	//equip save
	memeqpdata_todb(p->equip, MAX_EQUIP, p->id);

	//skill save
	memspells_todb(p->skill, MAX_SPELLS, p->id);

	//aether save
	memaethers_todb(p->dura_aether, 200, p->id);

	//Reg Save
	memreg_todb(p->global_reg, MAX_GLOBALPLAYERREG, p->id);

	//RegString Save
	memregstring_todb(p->global_regstring, MAX_GLOBALPLAYERREG, p->id);

	//NPC Interaction Save
	memnpcreg_todb(p->npcintreg, MAX_GLOBALNPCREG, p->id);

	//Quest Save
	memquestreg_todb(p->questreg, MAX_GLOBALQUESTREG, p->id);

	//Kill count save
	memkillcount_todb(p->killreg, MAX_KILLREG, p->id);

	//legend save
	memlegend_todb(p->legends, MAX_LEGENDS, p->id);

	//bank save
	membankdata_todb(p->banks, MAX_BANK_SLOTS, p->id);

	return 1;
}

///Function to set a specific Characters to a Online status of VAL

void mmo_setonline(unsigned int id, int val) {
	if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Character` SET `ChaOnline`='%u' WHERE `ChaId`='%u'", val, id))
		Sql_ShowDebug(sql_handle);
}

///Function to set ALL characters to a specific VAL(online/offline)
void mmo_setallonline(int val) {
	if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Character` SET `ChaOnline`='%u'", val)) Sql_ShowDebug(sql_handle);
}

///Function -> Add Login Data
int logindata_add(unsigned int id, int mapserver, char* name) {
	SqlStmt* stmt;
	int onl;
	int onl2;

	stmt = SqlStmt_Malloc(sql_handle);
	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return -1;
	}

	//printf("mapserver: %i\n",mapserver);

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaOnline` FROM `Character` WHERE `ChaName`='%s'", name)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &onl, 0, NULL, NULL)
		)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return -1;
	}

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt))
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return -1;
	}
	onl2 = onl;

	//if(SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Character` SET `ChaServer` = '%i' WHERE `ChaName`='%s'",mapserver, name))
	  //            Sql_ShowDebug(sql_handle);
		//          Sql_Free(sql_handle);

	SqlStmt_Free(stmt);

	return onl2;
}

///Function -> Remove Login Data
int logindata_del(unsigned int id) {
	if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Character` SET `ChaOnline`=0 WHERE `ChaId`='%u'", id))
		Sql_ShowDebug(sql_handle);

	return 0;
}
#endif
