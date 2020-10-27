#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "clan_db.h"
#include "map.h"
#include "db.h"
#include "malloc.h"
#include "core.h"
#include "script.h"
#include "db_mysql.h"
#include "strlib.h"

DBMap* clan_db;

int clandb_add(USER* sd, char* name) {
	struct clan_data* db = NULL;
	unsigned int newid = 0;
	char* data;
	char escape[64];

	if (SQL_ERROR == Sql_Query(sql_handle, "SELECT l.ClnId + 1 as start from `Clans` as l left outer join `Clans` as r on l.ClnId + 1 = r.ClnId where r.ClnId is null LIMIT 1"))
		Sql_ShowDebug(sql_handle);

	if (SQL_SUCCESS != Sql_NextRow(sql_handle))
		Sql_ShowDebug(sql_handle);

	Sql_GetData(sql_handle, 0, &data, NULL); newid = (unsigned int)strtoul(data, NULL, 10);
	Sql_FreeResult(sql_handle);
	Sql_EscapeString(sql_handle, escape, name);

	if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `Clans` (`ClnName`, `ClnId`) VALUES('%s', '%u')", escape, newid))
		Sql_ShowDebug(sql_handle);

	db = clandb_search(newid);
	strcpy(db->name, name);
	sd->status.clan = newid;

	return newid;
}

int clandb_searchname_sub(void* key, void* data, va_list ap) {
	struct clan_data* clan = (struct clan_data*)data, ** dst;
	char* str;
	str = va_arg(ap, char*);
	dst = va_arg(ap, struct clan_data**);
	if (strcmpi(clan->name, str) == 0) {
		*dst = clan;
	}
	return 0;
}

struct clan_data* clandb_searchname(const char* str) {
	struct clan_data* clan = NULL;
	clan_db->foreach(clan_db, clandb_searchname_sub, str, &clan);
	return clan;
}

struct clan_data* clandb_search(int id) {
	static struct clan_data* db = NULL;
	if (db && db->id == id)
		return db;

	db = uidb_get(clan_db, id);
	if (db)
		return db;

	CALLOC(db, struct clan_data, 1);
	uidb_put(clan_db, id, db);
	db->id = id;
	strcpy(db->name, "??");
	//strcpy(db->rank_name[0], "??");

	return db;
}

struct clan_data* clandb_searchexist(int id) {
	struct clan_data* db = NULL;
	db = uidb_get(clan_db, id);
	return db;
}

char* clandb_name(int id) {
	struct clan_data* db = NULL;
	db = uidb_get(clan_db, id);

	if (!db)
		return "??";

	return db->name;
}

int clandb_maxslots(int id) {
	struct clan_data* db = NULL;
	db = uidb_get(clan_db, id);
	return db->maxslots;
}

int clandb_level(int id) {
	struct clan_data* db = NULL;
	db = uidb_get(clan_db, id);
	return db->level;
}

int clandb_maxperslot(int id) {
	struct clan_data* db = NULL;
	db = uidb_get(clan_db, id);
	return db->maxperslot;
}

int clandb_read() {
	struct clan_data* db;
	struct clan_data* clan;
	int i;
	int x;
	int count = 0;

	if (SQL_ERROR == Sql_Query(sql_handle, "SELECT `ClnId`, `ClnName` FROM `Clans`"))
	{
		Sql_ShowDebug(sql_handle);
		return 0;
	}
	for (i = 0; i < SQL_SUCCESS == Sql_NextRow(sql_handle); i++) {
		char* data;
		size_t len;
		Sql_GetData(sql_handle, 0, &data, NULL); db = clandb_search((unsigned int)strtoul(data, NULL, 10));
		Sql_GetData(sql_handle, 1, &data, &len); memcpy(db->name, data, len);
	}

	for (i = 1; i <= Sql_NumRows(sql_handle); i++) {
		clan = clandb_search(i);
		CALLOC(clan->clanbanks, struct clan_bank, Sql_NumRows(sql_handle) * 255);
		map_loadclanbank(i);
		count++;
	}

	Sql_FreeResult(sql_handle);

	printf("Clan db read done. %i clans loaded!\n", count);
	return 0;
}

static int clandb_final(void* key, void* data, va_list ap) {
	struct clan_data* db;
	nullpo_ret(0, db = data);

	FREE(db);

	return 0;
}

int clandb_term() {
	if (clan_db) {
		//numdb_final(clan_db,clandb_final);
		db_destroy(clan_db);
	}

	return 0;
}

int clandb_init() {
	clan_db = uidb_alloc(DB_OPT_BASE);
	clandb_read();
	return 0;
}
