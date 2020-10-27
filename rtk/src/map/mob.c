#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include "malloc.h"
#include "map.h"
#include "mob.h"
#include "db.h"
#include "clif.h"
#include "sl.h"
#include "pc.h"
#include "timer.h"
#include "db_mysql.h"
#include "strlib.h"
#include "rndm.h"

unsigned int mob_id = MOB_START_NUM;
unsigned int max_normal_id = MOB_START_NUM;
unsigned int cmob_id = 0;
unsigned int MOB_SPAWN_MAX = MOB_START_NUM;
unsigned int MOB_SPAWN_START = MOB_START_NUM;
unsigned int MOB_ONETIME_MAX = MOBOT_START_NUM;
unsigned int MOB_ONETIME_START = MOBOT_START_NUM;
unsigned int MIN_TIMER = 1000;
unsigned int mob_get_new_id();
unsigned char timercheck = 0;

DBMap* mobdb;
//struct dbt *onetimedb;

int mobAIeasy(MOB*, struct block_list*);
int mobAInormal(MOB*);
int mobAIhard(MOB*);
int mob_timerhandle(int, int);

unsigned int mob_get_new_id() {
	return mob_id++;
}
unsigned int mob_get_free_id() {
	unsigned int x;
	struct block_list* bl = NULL;

	for (x = MOB_ONETIME_START; x <= MOB_ONETIME_MAX; x++) {
		if (x == MOB_ONETIME_MAX)MOB_ONETIME_MAX++;
		bl = map_id2bl(x);
		if (!bl) {
			return x;
		}
	}
	MOB_ONETIME_MAX++;
	return MOB_ONETIME_MAX;
}

int mobdb_read() {
	//FILE *fp;
	struct mobdb_data* db;
	struct item item;
	int i, mstr = 0;
	int x, id;
	char pos;
	struct mobdb_data a;
	//StringBuf buf;
	SqlStmt* stmt = SqlStmt_Malloc(sql_handle);
	SqlStmt* eqstmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (eqstmt == NULL) {
		SqlStmt_ShowDebug(eqstmt);
		return 0;
	}

	memset(&a, 0, sizeof(a));
	memset(&item, 0, sizeof(item));

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `MobId`, `MobDescription`, `MobIdentifier`, `MobBehavior`, `MobAI`, `MobLook`, `MobLookColor`, `MobVita`, `MobMana`, `MobExperience`, `MobHit`, `MobLevel`, `MobMight`,"
		"`MobGrace`, `MobMoveTime`, `MobSpawnTime`, `MobArmor`, `MobSound`, `MobAttackTime`, `MobProtection`, `MobReturnDistance`, `MobSex`, `MobFace`, `MobFaceColor`,"
		"`MobHair`, `MobHairColor`, `MobSkinColor`, `MobState`, `MobIsChar`, `MobWill`, `MobMinimumDamage`, `MobMaximumDamage`,"
		"`MobMark`, `MobIsNpc`, `MobIsBoss` FROM `Mobs`")
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &a.id, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_STRING, &a.name, sizeof(a.name), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_STRING, &a.yname, sizeof(a.yname), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_INT, &a.type, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 4, SQLDT_INT, &a.subtype, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 5, SQLDT_INT, &a.look, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 6, SQLDT_INT, &a.look_color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 7, SQLDT_INT, &a.vita, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 8, SQLDT_INT, &a.mana, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 9, SQLDT_UINT, &a.exp, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 10, SQLDT_INT, &a.hit, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 11, SQLDT_INT, &a.level, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 12, SQLDT_INT, &a.might, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 13, SQLDT_INT, &a.grace, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 14, SQLDT_INT, &a.movetime, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 15, SQLDT_INT, &a.spawntime, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 16, SQLDT_INT, &a.baseac, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 17, SQLDT_INT, &a.sound, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 18, SQLDT_INT, &a.atktime, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 19, SQLDT_SHORT, &a.protection, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 20, SQLDT_UCHAR, &a.retdist, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 21, SQLDT_USHORT, &a.sex, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 22, SQLDT_USHORT, &a.face, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 23, SQLDT_USHORT, &a.face_color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 24, SQLDT_USHORT, &a.hair, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 25, SQLDT_USHORT, &a.hair_color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 26, SQLDT_USHORT, &a.skin_color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 27, SQLDT_CHAR, &a.state, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 28, SQLDT_UCHAR, &a.mobtype, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 29, SQLDT_INT, &a.will, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 30, SQLDT_UINT, &a.mindam, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 31, SQLDT_UINT, &a.maxdam, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 32, SQLDT_UCHAR, &a.mark, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 33, SQLDT_UCHAR, &a.isnpc, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 34, SQLDT_UCHAR, &a.isboss, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	/*for (i = 0; i < 8; i++) {
		if (SQL_ERROR == SqlStmt_BindColumn(stmt, i + 18, SQLDT_UINT, &a.drop[i], 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, i + 26, SQLDT_UINT, &a.drop_rate[i], 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, i + 34, SQLDT_UINT, &a.drop_count[i], 0, NULL, NULL)) {
			SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}
	}*/

	mstr = SqlStmt_NumRows(stmt);
	//type: 0=Normal, 1=Aggressive, 2=Stationary(such as trees)

	for (x = 0; x < mstr && SQL_SUCCESS == SqlStmt_NextRow(stmt); x++) {
		//sql_get_row();
		db = mobdb_search(a.id);
		memcpy(db, &a, sizeof(a));

		if (db->mobtype == 1) {
			if (SQL_ERROR == SqlStmt_Prepare(eqstmt, "SELECT `MeqLook`, 1, 0, 0, `MeqColor`, `MeqSlot` FROM `MobEquipment` WHERE `MeqMobId` = '%u' LIMIT 14", db->id)
				|| SQL_ERROR == SqlStmt_Execute(eqstmt)
				|| SQL_ERROR == SqlStmt_BindColumn(eqstmt, 0, SQLDT_UINT, &item.id, 0, NULL, NULL)
				|| SQL_ERROR == SqlStmt_BindColumn(eqstmt, 1, SQLDT_UINT, &item.amount, 0, NULL, NULL)
				|| SQL_ERROR == SqlStmt_BindColumn(eqstmt, 2, SQLDT_UINT, &item.dura, 0, NULL, NULL)
				|| SQL_ERROR == SqlStmt_BindColumn(eqstmt, 3, SQLDT_UINT, &item.owner, 0, NULL, NULL)
				|| SQL_ERROR == SqlStmt_BindColumn(eqstmt, 4, SQLDT_UINT, &item.custom, 0, NULL, NULL)
				|| SQL_ERROR == SqlStmt_BindColumn(eqstmt, 5, SQLDT_UCHAR, &pos, 0, NULL, NULL)) {
				SqlStmt_ShowDebug(eqstmt);
				SqlStmt_Free(eqstmt);
				return 0;
			}

			//Equip Read
			for (i = 0; i < 14 && SQL_SUCCESS == SqlStmt_NextRow(eqstmt); i++) {
				memcpy(&db->equip[pos], &item, sizeof(item));
			}
		}
	}

	SqlStmt_Free(stmt);
	SqlStmt_Free(eqstmt);

	//StringBuf_Destroy(&buf);
	printf("Monster db read done. %u monsters loaded!\n", mstr);
	return 0;
}

struct block_list* onetime_avail(unsigned int id) {
	struct block_list* bl = NULL;
	bl = map_id2bl(id);
	return bl;
}

struct mobdb_data* mobdb_search(unsigned int id) {
	static struct mobdb_data* db = NULL;
	if (db && db->id == id)
		return db;

	db = uidb_get(mobdb, id);
	if (db)
		return db;

	CALLOC(db, struct mobdb_data, 1);
	uidb_put(mobdb, id, db);
	db->id = id;
	strcpy(db->name, "??");

	return db;
}

int free_onetime(MOB* mob) {
	unsigned int x = 0;
	struct block_list* bl = NULL;

	if (!mob) return 0;

	//if(mob->bl.id==mob_id) mob_id--;
	//timer_remove(mob->timer);
	//onetime_deliddb(mob->bl.id);
	//mob->timer=0;
	mob->data = NULL;
	FREE(mob);

	//clear out previous entries
	for (x = MOB_ONETIME_START; x <= MOB_ONETIME_MAX; x++) {
		bl = map_id2bl(x);
		if (bl)
			return 0;

		if (!bl && x < MOB_ONETIME_MAX)
			return 0;

		if (!bl && x == MOB_ONETIME_MAX) {
			map_deliddb(bl);
			MOB_ONETIME_MAX--;
		}
	}
	return 0;
}

unsigned int* mobspawn_onetime(unsigned int id, int m, int x, int y, int times, int start, int end, unsigned int replace, unsigned int owner) {
	int z;
	MOB* db;
	int new_id = 0;
	int ntime = times;
	unsigned int* spawnedmobs;

	CALLOC(spawnedmobs, int, times);

	for (z = 0; z < ntime; z++) {
		CALLOC(db, MOB, 1);

		if (!db->exp) db->exp = mobdb_experience(db->mobid);

		db->startm = m;
		db->startx = x;
		db->starty = y;
		db->mobid = id;
		db->start = start;
		db->end = end;
		db->replace = replace;
		db->state = MOB_DEAD;
		db->bl.type = BL_MOB;
		db->bl.m = db->startm;
		db->bl.x = db->startx;
		db->bl.y = db->starty;
		db->owner = owner;

	idgetloop:
		db->bl.id = mob_get_free_id();
		if (map_id2bl(db->bl.id)) goto idgetloop;
		spawnedmobs[z] = db->bl.id;
		db->bl.prev = NULL;
		db->bl.next = NULL;
		if (times) db->onetime = 1;
		db->spawncheck = 0;
		map_addblock(&db->bl);

		map_addiddb(&db->bl);

		if (map[db->bl.m].user) {
			mob_respawn(db);
		}
		else {
			mob_respawn_nousers(db);
		}
	}

	return spawnedmobs;
}

int mobspawn_read() {
	MOB* db = NULL;
	int i, m, mstr = 0;
	unsigned int new_id, checkspawn;
	SqlStmt* stmt = SqlStmt_Malloc(sql_handle);;
	MOB mob;

	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	memset(&mob, 0, sizeof(mob));
	//map,startx,starty,id
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `SpnMapId`, `SpnX`, `SpnY`, `SpnMobId`, `SpnLastDeath`, `SpnId`, `SpnStartTime`, `SpnEndTime`, `SpnMobIdReplace` FROM `Spawns%d` ORDER BY `SpnId`", serverid)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_USHORT, &mob.startm, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_USHORT, &mob.startx, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_USHORT, &mob.starty, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_UINT, &mob.mobid, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 4, SQLDT_UINT, &mob.last_death, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 5, SQLDT_UINT, &mob.id, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 6, SQLDT_CHAR, &mob.start, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 7, SQLDT_CHAR, &mob.end, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 8, SQLDT_UINT, &mob.replace, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}
	mstr = SqlStmt_NumRows(stmt);

	for (i = 0; i < mstr && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
		unsigned int sptime = time(NULL);
		db = map_id2mob(mob.id);
		if (db == NULL) {
			CALLOC(db, MOB, 1);
			checkspawn = 1;
		}
		else {
			map_delblock(&db->bl);
			map_deliddb(&db->bl);
			checkspawn = 0;
		}

		if (!db->exp) db->exp = mobdb_experience(mob.mobid);

		db->id = mob.id;
		db->bl.type = BL_MOB;
		db->startm = mob.startm;
		db->startx = mob.startx;
		db->starty = mob.starty;
		db->mobid = mob.mobid;
		db->start = mob.start;
		db->end = mob.end;
		db->replace = mob.replace;
		db->last_death = mob.last_death;
		db->bl.prev = NULL;
		db->bl.next = NULL;
		db->onetime = 0;

		if (db->bl.id < MOB_START_NUM) {
			new_id = mob_get_new_id();
			max_normal_id = new_id;
			db->bl.m = mob.startm;
			db->bl.x = db->startx;
			db->bl.y = db->starty;
			db->bl.id = new_id;
			mob_respawn_getstats(db);
		}

		if (checkspawn) {
			db->state = MOB_DEAD;
		}

		if (db->bl.x >= map[db->bl.m].xs) db->bl.x = map[db->bl.m].xs - 1;
		if (db->bl.y >= map[db->bl.m].ys) db->bl.y = map[db->bl.m].ys - 1;

		map_addblock(&db->bl);
		map_addiddb(&db->bl);
	}

	SqlStmt_Free(stmt);
	MOB_SPAWN_MAX = mob_id;
	srand(gettick());
	printf("Monster spawn read done. %u monsters spawned on Server: %i!\n", mstr, serverid);

	return 0;
}

int mobspawn2_read(const char* mobspawn_file) {
	FILE* fp;
	char line[1024];
	int lines = 0;
	char* str[5], * p, * np;
	MOB* db;
	int i, mstr = 0;
	int new_id;
	int id;
	int m, times, max, x, y, a, z, b;

	return 0;
}
int mobspeech_read(char* mobspeech_file) {
	return 0;
}

int mobdb_id(char* str) {
	struct mobdb_data* db = NULL;
	db = mobdb_searchname(str);
	if (db)
		return db->id;

	if ((unsigned int)strtoul(str, NULL, 10) > 0) {
		db = mobdb_searchexist((unsigned int)strtoul(str, NULL, 10));
		if (db) {
			return db->id;
		}
	}
	return 0;
}

struct mobdb_data* mobdb_searchexist(unsigned int id) {
	struct mobdb_data* db = NULL;
	db = uidb_get(mobdb, id);
	return db;
}

int mobdb_init() {
	//char *MOBDB2_FILE="db/mob_db.txt";
	//char *MOBSPAWN_FILE="db/spawn_db.txt";
	mobdb = uidb_alloc(DB_OPT_BASE);
	//onetimedb=numdb_init();
	mobdb_read();
	mobspawn_read();
	//mobspawn2_read("db/mob_db2.txt");
	return 0;
}

struct mobdb_data* mobdb_searchname(const char* str) {
	struct mobdb_data* mob = NULL;
	mobdb->foreach(mobdb, mobdb_searchname_sub, str, &mob);
	return mob;
}

int mobdb_searchname_sub(void* key, void* data, va_list ap) {
	struct mobdb_data* mob = (struct mobdb_data*)data, ** dst;
	char* str;
	str = va_arg(ap, char*);
	dst = va_arg(ap, struct mobdb_data**);
	if (strcmpi(mob->yname, str) == 0)
		*dst = mob;
	return 0;
}

int mobdb_level(unsigned int id) {
	struct mobdb_data* mob;

	mob = mobdb_search(id);

	if (mob) {
		return mob->level;
	}
	else {
		return 0;
	}
}

unsigned int mobdb_experience(unsigned int id) {
	struct mobdb_data* mob;

	mob = mobdb_search(id);

	if (mob) {
		return mob->exp;
	}
	else {
		return 0;
	}
}

int mob_thing_yeah(struct block_list* bl, va_list ap) {
	int* def;

	def = va_arg(ap, int*);
	def[0] = 1;
	return 0;
}
int mob_duratimer(MOB* mob) {
	struct block_list* tbl = NULL;
	MOB* tmob = NULL;
	int x, id;
	long health;

	nullpo_ret(0, mob);

	for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
		id = mob->da[x].id;
		if (mob->da[x].id > 0) {
			if (mob->da[x].caster_id > 0) {
				tbl = map_id2bl(mob->da[x].caster_id);
			}

			if (mob->da[x].duration > 0) {
				mob->da[x].duration -= 1000;

				if (tbl != NULL) {
					if (tbl->type == BL_MOB) {
						tmob = (MOB*)tbl;
						health = tmob->current_vita;
					}

					if (health > 0 || tbl->type == BL_PC) {
						sl_doscript_blargs(magicdb_yname(id), "while_cast", 2, &mob->bl, tbl);
					}
				}
				else {
					sl_doscript_blargs(magicdb_yname(id), "while_cast", 1, &mob->bl);
				}

				if (mob->da[x].duration <= 0) {
					mob->da[x].duration = 0;
					mob->da[x].id = 0;
					mob->da[x].caster_id = 0;
					map_foreachinarea(clif_sendanimation, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC, mob->da[x].animation, &mob->bl, -1);
					mob->da[x].animation = 0;

					if (tbl != NULL) {
						sl_doscript_blargs(magicdb_yname(id), "uncast", 2, &mob->bl, tbl);
					}
					else {
						sl_doscript_blargs(magicdb_yname(id), "uncast", 1, &mob->bl);
					}
				}
			}
		}
	}

	return 0;
}
int mob_secondduratimer(MOB* mob) {
	struct block_list* tbl = NULL;
	MOB* tmob = NULL;
	int x, id;
	long health;

	nullpo_ret(0, mob);

	for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
		id = mob->da[x].id;
		if (mob->da[x].id > 0) {
			if (mob->da[x].caster_id > 0) {
				tbl = map_id2bl(mob->da[x].caster_id);
			}

			if (mob->da[x].duration > 0) {
				if (tbl != NULL) {
					if (tbl->type == BL_MOB) {
						tmob = (MOB*)tbl;
						health = tmob->current_vita;
					}

					if (health > 0 || tbl->type == BL_PC) {
						sl_doscript_blargs(magicdb_yname(id), "while_cast_250", 2, &mob->bl, tbl);
					}
				}
				else {
					sl_doscript_blargs(magicdb_yname(id), "while_cast_250", 1, &mob->bl);
				}
			}
		}
	}

	return 0;
}

int mob_thirdduratimer(MOB* mob) {
	struct block_list* tbl = NULL;
	MOB* tmob = NULL;
	int x, id;
	long health;

	nullpo_ret(0, mob);

	for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
		id = mob->da[x].id;
		if (mob->da[x].id > 0) {
			if (mob->da[x].caster_id > 0) {
				tbl = map_id2bl(mob->da[x].caster_id);
			}

			if (mob->da[x].duration > 0) {
				if (tbl != NULL) {
					if (tbl->type == BL_MOB) {
						tmob = (MOB*)tbl;
						health = tmob->current_vita;
					}

					if (health > 0 || tbl->type == BL_PC) {
						sl_doscript_blargs(magicdb_yname(id), "while_cast_500", 2, &mob->bl, tbl);
					}
				}
				else {
					sl_doscript_blargs(magicdb_yname(id), "while_cast_500", 1, &mob->bl);
				}
			}
		}
	}

	return 0;
}

int mob_fourthduratimer(MOB* mob) {
	struct block_list* tbl = NULL;
	MOB* tmob = NULL;
	int x, id;
	long health;

	nullpo_ret(0, mob);

	for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
		id = mob->da[x].id;
		if (mob->da[x].id > 0) {
			if (mob->da[x].caster_id > 0) {
				tbl = map_id2bl(mob->da[x].caster_id);
			}

			if (mob->da[x].duration > 0) {
				if (tbl != NULL) {
					if (tbl->type == BL_MOB) {
						tmob = (MOB*)tbl;
						health = tmob->current_vita;
					}

					if (health > 0 || tbl->type == BL_PC) {
						sl_doscript_blargs(magicdb_yname(id), "while_cast_1500", 2, &mob->bl, tbl);
					}
				}
				else {
					sl_doscript_blargs(magicdb_yname(id), "while_cast_1500", 1, &mob->bl);
				}
			}
		}
	}

	return 0;
}

int mob_timer_new(int id, int n) {
	unsigned int x;

	for (x = MOB_START_NUM; x < MOB_SPAWN_START; x++) { //only process up to that.
		mob_handle_sub(map_id2bl(x), NULL);
	}

	return 0;
}

int mob_timer_spawns(int id, int n) {
	MOB* mob = NULL;
	unsigned int x;

	timercheck++;

	if (MOB_SPAWN_START != MOB_SPAWN_MAX) {
		for (x = MOB_SPAWN_START; x < MOB_SPAWN_MAX; x++) { //only process up to that.
			mob = map_id2mob(x);

			if (mob) {
				if (timercheck % 5 == 0) {
					mob_secondduratimer(mob);
				}
				if (timercheck % 10 == 0) {
					mob_thirdduratimer(mob);
				}
				if (timercheck % 30 == 0) {
					mob_fourthduratimer(mob);
				}
				if (timercheck % 20 == 0) {
					mob_duratimer(mob);
				}

				mob_handle_sub(mob, NULL);
			}
		}
	}

	if (MOB_ONETIME_START != MOB_ONETIME_MAX) {
		for (x = MOB_ONETIME_START; x < MOB_ONETIME_MAX; x++) {
			mob = map_id2mob(x);

			if (mob) {
				if (timercheck % 5 == 0) {
					mob_secondduratimer(mob);
				}
				if (timercheck % 10 == 0) {
					mob_thirdduratimer(mob);
				}
				if (timercheck % 30 == 0) {
					mob_fourthduratimer(mob);
				}
				if (timercheck % 20 == 0) {
					mob_duratimer(mob);
				}

				mob_handle_sub(mob, NULL);
			}
		}
	}

	if (timercheck >= 30) {
		timercheck = 0;
	}

	return 0;
}
int mob_flushmagic(MOB* mob) {
	struct block_list* bl = NULL;
	int x, id;

	for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
		id = mob->da[x].id;
		if (id > 0) {
			mob->da[x].duration = 0;
			mob->da[x].id = 0;
			mob->da[x].caster_id = 0;
			map_foreachinarea(clif_sendanimation, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC, mob->da[x].animation, &mob->bl, -1);
			mob->da[x].animation = 0;

			if (mob->da[x].caster_id != mob->bl.id) {
				bl = map_id2bl(mob->da[x].caster_id);
			}

			if (bl != NULL) {
				sl_doscript_blargs(magicdb_yname(id), "uncast", 2, &mob->bl, bl);
			}
			else {
				sl_doscript_blargs(magicdb_yname(id), "uncast", 1, &mob->bl);
			}
		}
	}

	return 0;
}

int mobdb_drops(MOB* mob, USER* sd) {
	int rate;
	int z;
	int i;
	int amount;
	int a;

	sl_doscript_blargs("HandleMobDrops", NULL, 2, &sd->bl, &mob->bl);

	// INVENTORY DROP //
	for (int i = 0; i < MAX_INVENTORY; i++) {
		if (mob->inventory[i].id != 0 && mob->inventory[i].amount >= 1) {
			mobdb_dropitem(mob->bl.id, mob->inventory[i].id, mob->inventory[i].amount, mob->inventory[i].dura, mob->inventory[i].protected, mob->inventory[i].owner, mob->bl.m, mob->bl.x, mob->bl.y, sd);
			mob->inventory[i].id = 0;
			mob->inventory[i].amount = 0;
			mob->inventory[i].owner = 0;
			mob->inventory[i].dura = 0;
			mob->inventory[i].protected = 0;
		}
	}

	return 0;
}

int mob_addtocurrent(struct block_list* bl, va_list ap) {
	int* def;
	int id = 0;
	USER* sd;
	FLOORITEM* fl;
	FLOORITEM* fl2;
	int type = 0;

	nullpo_ret(0, fl = (FLOORITEM*)bl);

	def = va_arg(ap, int*);
	id = va_arg(ap, int);
	nullpo_ret(0, fl2 = va_arg(ap, FLOORITEM*));
	sd = va_arg(ap, USER*);

	if (def[0]) return 0;

	if (fl->data.id == fl2->data.id) {
		fl->data.amount += fl2->data.amount;
		def[0] = 1;
		return 0;
	}
	return 0;
}

int mobdb_dropitem(unsigned int blockid, unsigned int id, int amount, int dura, int protected, int owner, int m, int x, int y, USER* sd) {
	USER* tsd = NULL;
	MOB* mob = NULL;
	NPC* nd = NULL;
	FLOORITEM* fl;
	int def[1];
	int z;

	if (blockid < MOB_START_NUM) {
		tsd = map_id2sd((unsigned int)blockid);
	}
	else if (blockid >= MOB_START_NUM && blockid < FLOORITEM_START_NUM) {
		mob = map_id2mob((unsigned int)blockid);
	}
	else if (blockid >= NPC_START_NUM) {
		nd = map_id2npc((unsigned int)blockid);
	}

	//printf("item id: %u, amount: %i, dura: %i, protected: %i, owner: %i\n",id,amount,dura,protected,owner);

	def[0] = 0;
	CALLOC(fl, FLOORITEM, 1);
	fl->bl.m = m;
	fl->bl.x = x;
	fl->bl.y = y;
	fl->data.id = id;
	fl->data.amount = amount;
	//fl->gone_tick=0;
	fl->data.dura = dura;
	fl->data.protected = protected;
	fl->data.owner = owner;

	map_foreachincell(mob_addtocurrent, m, x, y, BL_ITEM, def, id, fl, sd);

	/*if (tsd) {
		if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `CharacterDeathDropLogs` (`CddChaId`, `CddMapId`, `CddX`, `CddY`, `CddItmId`, `CddAmount`) VALUES ('%u', '%u', '%u', '%u', '%u', '%u')",
		tsd->status.id, m, x, y, id, amount)) {
			SqlStmt_ShowDebug(sql_handle);
		}
	} else if (mob) {
		if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `MobDeathDropLogs` (`MddMobId`, `MddMapId`, `MddX`, `MddY`, `MddItmId`, `MddAmount`) VALUES ('%u', '%u', '%u', '%u', '%u', '%u')",
		mob->data->id, m, x, y, id, amount)) {
			SqlStmt_ShowDebug(sql_handle);
		}
	} else if (nd) {
		if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `NPCDeathDropLogs` (`NddNpcId`, `NddMapId`, `NddX`, `NddY`, `NddItmId`, `NddAmount`) VALUES ('%u', '%u', '%u', '%u', '%u', '%u')",
		nd->id, m, x, y, id, amount)) {
			SqlStmt_ShowDebug(sql_handle);
		}
	}*/

	fl->timer = time(NULL);

	memset(&fl->looters, 0, MAX_GROUP_MEMBERS);

	if (mob) {
		struct map_sessiondata* attacker = map_id2sd(mob->attacker);

		if (attacker) {
			if (attacker->group_count > 0) {
				for (z = 0; z < attacker->group_count; z++) {
					fl->looters[z] = groups[attacker->groupid][z];
				}
			}
			else {
				fl->looters[0] = attacker->bl.id;
			}
		}
	}

	if (!def[0]) {
		map_additem(&fl->bl);
		map_foreachinarea(clif_object_look_sub2, m, x, y, AREA, BL_PC, LOOK_SEND, &fl->bl);
	}
	else {
		FREE(fl);
	}

	return 0;
}
int mob_null(struct block_list* bl, va_list ap) {
	return 0;
}
int kill_mob(MOB* mob) {
	clif_mob_kill(mob);
	mob_flushmagic(mob);
	//sl_doscript_blargs(mob->data->yname,"on_death",2,&mob->bl,&sd->bl);
}
int mob_handle_sub(MOB* mob, va_list ap) {
	USER* sd = NULL;
	struct block_list* bl = NULL;
	MOB* tmob = NULL;
	int def[1];
	int test;
	int uc = 0;
	unsigned char i = 0;
	char invis = 0;
	char seeinvis = 0;
	unsigned int sptime = time(NULL);

	time_t seconds;
	seconds = time(NULL);

	nullpo_ret(0, mob);
	seeinvis = mob->data->seeinvis;

	if ((mob->start < mob->end && cur_time >= mob->start && cur_time <= mob->end)
		|| (mob->start > mob->end && (cur_time >= mob->start || cur_time <= mob->end))
		|| (mob->start == mob->end && cur_time == mob->start && cur_time == mob->end)
		|| (mob->start == 25 && mob->end == 25)
		|| mob->replace != 0) {
		if (mob->last_death + mob->data->spawntime <= sptime) {
			mob->spawncheck = 0;

			if (mob->state == MOB_DEAD && !mob->onetime) {
				mob->target = 0;
				mob->attacker = 0;
				if (map[mob->bl.m].user) { mob_respawn(mob); }
				else { mob_respawn_nousers(mob); }
			}
		}
	}

	if (mob->data->type >= 2) return 0;

	//if(!map[mob->bl.m].user && mob->onetime)  // this func disabled on 04-29-18 to disable one time mobs despawning on room exit
		//kill_mob(mob);

	if (!map[mob->bl.m].user && mob->onetime && mob->data->subtype != 2) { if (mob->state != MOB_DEAD) return 0; }
	if (!map[mob->bl.m].user && !mob->onetime && mob->data->subtype != 4) {
		if (mob->state != MOB_DEAD) return 0;
	}

	mob->time += 50;

	switch (mob->state) {
	case MOB_DEAD:

		if (mob->onetime) {
			map_delblock(&mob->bl);

			map_deliddb(&mob->bl); // This MOB needs to be free'd from memory
			free_onetime(mob);

			return 0;
		}

		break;
	case MOB_ALIVE:

		if ((mob->time >= mob->data->movetime && mob->time >= mob->newmove) || (mob->time >= mob->newmove && mob->newmove > 0)) {
			if (mob->data->type >= 2) return 0;
			if (mob->data->type == 1) { //Aggressive
				if (!mob->target) map_foreachinarea(mob_find_target, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC, mob);
			}

			bl = map_id2bl(mob->target);

			if (bl != NULL) {
				if (bl->m != mob->bl.m) {
					mob->target = 0;
					mob->attacker = 0;
					mob->state = MOB_ALIVE;
				}

				if (bl->type == BL_MOB) {
					tmob = (MOB*)bl;
					if (tmob->state == MOB_DEAD) {
						mob->target = 0;
						mob->attacker = 0;
						bl = NULL;
					}
				}
				else if (bl->type == BL_PC) {
					sd = (USER*)bl;

					if (sd->status.state == 1) {
						mob->target = 0;
						mob->attacker = 0;
						bl = NULL;
					}
				}
			}
			else {
				mob->target = 0;
				mob->attacker = 0;
				bl = NULL;
			}

			mob->time = 0;
			if (mob->data->subtype == 0) {
				sl_doscript_blargs("mob_ai_basic", "move", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 1) {
				sl_doscript_blargs("mob_ai_normal", "move", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 2) {
				sl_doscript_blargs("mob_ai_hard", "move", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 3) {
				sl_doscript_blargs("mob_ai_boss", "move", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 4) {
				sl_doscript_blargs(mob->data->yname, "move", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 5) {
				sl_doscript_blargs("mob_ai_ghost", "move", 2, &mob->bl, bl);
			}
		}
		break;

	case MOB_HIT:

		if ((mob->time >= mob->data->atktime && mob->time >= mob->newatk) || (mob->time >= mob->newatk && mob->newatk > 0)) {
			if (mob->data->type >= 2) return 0;

			bl = map_id2bl(mob->target);
			if (!bl) {
				mob->target = 0;
				mob->attacker = 0;
				mob->state = MOB_ALIVE;
				return 0;
			}
			if (bl) {
				//test=sizeof(*sd);
				if (bl->m != mob->bl.m) {
					mob->target = 0;
					mob->attacker = 0;
					mob->state = MOB_ALIVE;
					return 0;
				}

				if (bl->type == BL_MOB) {
					tmob = (MOB*)bl;

					if (tmob) {
						if (tmob->state == MOB_DEAD) {
							mob->target = 0;
							mob->attacker = 0;
							mob->state = MOB_ALIVE;
							return 0;
						}
					}
				}
				else if (bl->type == BL_PC) {
					sd = (USER*)bl;

					if (sd) {
						if (sd->status.state == 1) {
							mob->target = 0;
							mob->attacker = 0;
							mob->state = MOB_ALIVE;
							return 0;
						}
					}
				}
			}

			//if(mob->parastate==0) {
			mob->time = 0;
			//printf("Hit!\n");
			if (mob->data->subtype == 0) {
				sl_doscript_blargs("mob_ai_basic", "attack", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 1) {
				sl_doscript_blargs("mob_ai_normal", "attack", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 2) {
				sl_doscript_blargs("mob_ai_hard", "attack", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 3) {
				sl_doscript_blargs("mob_ai_boss", "attack", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 4) {
				sl_doscript_blargs(mob->data->yname, "attack", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 5) {
				sl_doscript_blargs("mob_ai_ghost", "attack", 2, &mob->bl, bl);
			}
		}
		break;

	case MOB_ESCAPE:

		if ((mob->time >= mob->data->movetime && mob->time >= mob->newmove) || (mob->time >= mob->newmove && mob->newmove > 0)) {
			if (mob->data->type >= 2) return 0;
			if (mob->data->type == 1) { //Aggressive
				if (!mob->target) map_foreachinarea(mob_find_target, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC, mob);
			}

			bl = map_id2bl(mob->target);

			if (bl != NULL) {
				if (bl->m != mob->bl.m) {
					mob->target = 0;
					mob->attacker = 0;
					mob->state = MOB_ALIVE;
				}

				if (bl->type == BL_MOB) {
					tmob = (MOB*)bl;
					if (tmob->state == MOB_DEAD) {
						mob->target = 0;
						mob->attacker = 0;
						bl = NULL;
					}
				}
				else if (bl->type == BL_PC) {
					sd = (USER*)bl;

					if (sd->status.state == 1) {
						mob->target = 0;
						mob->attacker = 0;
						bl = NULL;
					}
				}
			}
			else {
				mob->target = 0;
				mob->attacker = 0;
				bl = NULL;
			}

			mob->time = 0;
			if (mob->data->subtype == 0) {
				sl_doscript_blargs("mob_ai_basic", "escape", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 1) {
				sl_doscript_blargs("mob_ai_normal", "escape", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 2) {
				sl_doscript_blargs("mob_ai_hard", "escape", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 3) {
				sl_doscript_blargs("mob_ai_boss", "escape", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 4) {
				sl_doscript_blargs(mob->data->yname, "escape", 2, &mob->bl, bl);
			}
			else if (mob->data->subtype == 5) {
				sl_doscript_blargs("mob_ai_ghost", "escape", 2, &mob->bl, bl);
			}
		}
		break;

	default:
		break;
	}
	//free_unlock();
	return 0;
}
int mob_trap_look(struct block_list* bl, va_list ap) {
	struct npc_data* nd;
	MOB* mob;
	int type;
	int* def;

	if (bl->subtype != FLOOR && bl->subtype != 2)
		return 0;

	nullpo_ret(0, nd = (struct npc_data*)bl);
	nullpo_ret(0, mob = va_arg(ap, MOB*));
	type = va_arg(ap, int);
	def = va_arg(ap, int*);

	if (def[0]) return 0;
	if (type && bl->subtype == 2) {
	}
	else {
		def[0] = 1;
		sl_doscript_blargs(nd->name, "click", 2, &mob->bl, &nd->bl);
	}
	return 0;
}

int move_mob(MOB* mob) {
	int direction;
	int backx;
	int backy;
	int m;
	int c = 0;
	struct warp_list* i;
	//static last;
	int dx, dy;
	int cm;
	int x0, y0, x1, y1;
	int nothingnew = 0;
	int subt[1];
	int def[2];
	subt[0] = 0;
	m = mob->bl.m;
	backx = mob->bl.x;
	backy = mob->bl.y;
	dx = backx;
	dy = backy;
	direction = mob->side;
	//if(mob->canmove) return 1;
	//mob->side=direction;
	x0 = mob->bl.x;
	y0 = mob->bl.y;

	switch (direction) {
	case 0: //UP
		if (backy > 0) {
			dy = backy - 1;
			x0 -= 9;
			if (x0 < 0) x0 = 0;
			y0 -= 9;
			y1 = 1;
			x1 = 19;
			if (y0 < 7) nothingnew = 1;
			if (y0 == 7) {
				y1 += 7;
				y0 = 0;
			}
			if (x0 + 19 + 9 >= map[m].xs)
				x1 += 9 - ((x0 + 19 + 9) - map[m].xs);
			if (x0 <= 8) {
				x1 += x0;
				x0 = 0;
			}
		}

		break;
	case 1: //Right
		if (backx < map[m].xs) {
			x0 += 10;
			y0 -= 8;
			if (y0 < 0) y0 = 0;
			dx = backx + 1;
			y1 = 17;
			x1 = 1;
			if (x0 > map[m].xs - 9) nothingnew = 1;
			if (x0 == map[m].xs - 9) x1 += 9;
			if (y0 + 17 + 8 >= map[m].ys)
				y1 += 8 - ((y0 + 17 + 8) - map[m].ys);
			if (y0 <= 7) {
				y1 += y0;
				y0 = 0;
			}
		}
		break;
	case 2: //down
		if (backy < map[m].ys) {
			x0 -= 9;
			if (x0 < 0) x0 = 0;
			y0 += 9;
			dy = backy + 1;
			y1 = 1;
			x1 = 19;
			if (y0 + 8 > map[m].ys) nothingnew = 1;
			if (y0 + 8 == map[m].ys) y1 += 8;
			if (x0 + 19 + 9 >= map[m].xs)
				x1 += 9 - ((x0 + 19 + 9) - map[m].xs);
			if (x0 <= 8) {
				x1 += x0;
				x0 = 0;
			}
		}
		break;
	case 3: //left
		if (backx > 0) {
			x0 -= 10;
			y0 -= 8;
			if (y0 < 0) y0 = 0;
			y1 = 17;
			x1 = 1;
			dx = backx - 1;
			if (x0 < 8) nothingnew = 1;
			if (x0 == 8) {
				x0 = 0;
				x1 += 8;
			}
			if (y0 + 17 + 8 >= map[m].ys)
				y1 += 8 - ((y0 + 17 + 8) - map[m].ys);
			if (y0 <= 7) {
				y1 += y0;
				y0 = 0;
			}
		}
		break;
	default:
		break;
	}

	if (dx >= map[m].xs) dx = map[m].xs - 1;
	if (dy >= map[m].ys) dy = map[m].ys - 1;
	for (i = map[m].warp[dx / BLOCK_SIZE + (dy / BLOCK_SIZE) * map[m].bxs]; i && !c; i = i->next) {
		if (i->x == dx && i->y == dy) {
			c = 1;
			return 0;
		}
	}

	map_foreachincell(mob_move, m, dx, dy, BL_MOB, mob);
	map_foreachincell(mob_move, m, dx, dy, BL_PC, mob);
	map_foreachincell(mob_move, m, dx, dy, BL_NPC, mob);

	//if(read_pass(mob->bl.m,dx,dy)) mob->canmove = 1;

	if (clif_object_canmove(m, dx, dy, direction)) {
		mob->canmove = 0;
		return 0;
	}
	if (clif_object_canmove_from(m, backx, backy, direction)) {
		mob->canmove = 0;
		return 0;
	}
	cm = mob->canmove;
	if ((map_canmove(m, dx, dy) == 1) || (mob->canmove == 1)) {
		mob->canmove = 0;
		return 0;
	}

	if (x0 > map[m].xs) x0 = map[m].xs - 1;
	if (y0 > map[m].ys) y0 = map[m].ys - 1;
	if (x0 < 0) x0 = 0;
	if (y0 < 0) y0 = 0;

	if (dx >= map[m].xs) dx = backx;
	if (dy >= map[m].ys) dy = backy;
	if (dx < 0) dx = backx;
	if (dy < 0) dy = backy;

	//printf("-----------\n");

	if (dx != backx || dy != backy) {
		//printf("BX: %d BY: %d DX: %d DY: %d\n",backx,backy,dx,dy);

		//if(moveish) map_delblock(&mob->bl);
		mob->bx = backx;
		mob->by = backy;
		//mob->bl.next=NULL;
		//mob->bl.prev=NULL;
		//printf("Moved\n");
		map_moveblock(&mob->bl, dx, dy);
		//if(moveish) map_addblock(&mob->bl);
		//if(x0 || y0) {
		if (!nothingnew) {
			if (mob->data->mobtype == 1) {
				map_foreachinblock(clif_cmoblook_sub, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_SEND, mob);
			}
			else {
				//map_foreachinblock(clif_mob_look,mob->bl.m,x0,y0,x0+(x1-1),y0+(y1-1),BL_PC,LOOK_SEND,mob);
				map_foreachinblock(clif_mob_look_start_func, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, mob);
				map_foreachinblock(clif_object_look_sub, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_SEND, &mob->bl);
				map_foreachinblock(clif_mob_look_close_func, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, mob);
				//map_foreachinarea(clif_mob_look,mob->bl.m,mob->bl.x,mob->bl.y,CORNER,BL_PC,LOOK_SEND,mob);
				//map_foreachinarea(clif_mob_move,m,mob->bl.x,mob->bl.y,CORNER,BL_PC,LOOK_SEND,mob);
			}
		}

		map_foreachincell(mob_trap_look, m, mob->bl.x, mob->bl.y, BL_NPC, mob, 0, subt);
		map_foreachinarea(clif_mob_move, m, mob->bl.x, mob->bl.y, AREA, BL_PC, LOOK_SEND, mob);
		return 1;
	}
	else {
		return 0;
	}
}

int move_mob_ignore_object(MOB* mob) {
	int direction;
	int backx;
	int backy;
	int m;
	int c = 0;
	struct warp_list* i;
	//static last;
	int dx, dy;
	int cm;
	int x0, y0, x1, y1;
	int nothingnew = 0;
	int subt[1];
	int def[2];
	subt[0] = 0;
	m = mob->bl.m;
	backx = mob->bl.x;
	backy = mob->bl.y;
	dx = backx;
	dy = backy;
	direction = mob->side;
	//if(mob->canmove) return 1;
	//mob->side=direction;
	x0 = mob->bl.x;
	y0 = mob->bl.y;

	switch (direction) {
	case 0: //UP
		if (backy > 0) {
			dy = backy - 1;
			x0 -= 9;
			if (x0 < 0) x0 = 0;
			y0 -= 9;
			y1 = 1;
			x1 = 19;
			if (y0 < 7) nothingnew = 1;
			if (y0 == 7) {
				y1 += 7;
				y0 = 0;
			}
			if (x0 + 19 + 9 >= map[m].xs)
				x1 += 9 - ((x0 + 19 + 9) - map[m].xs);
			if (x0 <= 8) {
				x1 += x0;
				x0 = 0;
			}
		}

		break;
	case 1: //Right
		if (backx < map[m].xs) {
			x0 += 10;
			y0 -= 8;
			if (y0 < 0) y0 = 0;
			dx = backx + 1;
			y1 = 17;
			x1 = 1;
			if (x0 > map[m].xs - 9) nothingnew = 1;
			if (x0 == map[m].xs - 9) x1 += 9;
			if (y0 + 17 + 8 >= map[m].ys)
				y1 += 8 - ((y0 + 17 + 8) - map[m].ys);
			if (y0 <= 7) {
				y1 += y0;
				y0 = 0;
			}
		}
		break;
	case 2: //down
		if (backy < map[m].ys) {
			x0 -= 9;
			if (x0 < 0) x0 = 0;
			y0 += 9;
			dy = backy + 1;
			y1 = 1;
			x1 = 19;
			if (y0 + 8 > map[m].ys) nothingnew = 1;
			if (y0 + 8 == map[m].ys) y1 += 8;
			if (x0 + 19 + 9 >= map[m].xs)
				x1 += 9 - ((x0 + 19 + 9) - map[m].xs);
			if (x0 <= 8) {
				x1 += x0;
				x0 = 0;
			}
		}
		break;
	case 3: //left
		if (backx > 0) {
			x0 -= 10;
			y0 -= 8;
			if (y0 < 0) y0 = 0;
			y1 = 17;
			x1 = 1;
			dx = backx - 1;
			if (x0 < 8) nothingnew = 1;
			if (x0 == 8) {
				x0 = 0;
				x1 += 8;
			}
			if (y0 + 17 + 8 >= map[m].ys)
				y1 += 8 - ((y0 + 17 + 8) - map[m].ys);
			if (y0 <= 7) {
				y1 += y0;
				y0 = 0;
			}
		}
		break;
	default:
		break;
	}

	if (dx >= map[m].xs) dx = map[m].xs - 1;
	if (dy >= map[m].ys) dy = map[m].ys - 1;
	for (i = map[m].warp[dx / BLOCK_SIZE + (dy / BLOCK_SIZE) * map[m].bxs]; i && !c; i = i->next) {
		if (i->x == dx && i->y == dy) {
			c = 1;
			return 0;
		}
	}

	map_foreachincell(mob_move, m, dx, dy, BL_MOB, mob);
	map_foreachincell(mob_move, m, dx, dy, BL_PC, mob);
	map_foreachincell(mob_move, m, dx, dy, BL_NPC, mob);

	//if(read_pass(mob->bl.m,dx,dy)) mob->canmove = 1;

	if (clif_object_canmove(m, dx, dy, direction)) {
		mob->canmove = 0;
		return 0;
	}
	if (clif_object_canmove_from(m, backx, backy, direction)) {
		mob->canmove = 0;
		return 0;
	}

	cm = mob->canmove;

	/*if((map_canmove(m,dx,dy)==1) || (mob->canmove==1)) {
		mob->canmove=0;
		return 0;
	}*/

	if (x0 > map[m].xs) x0 = map[m].xs - 1;
	if (y0 > map[m].ys) y0 = map[m].ys - 1;
	if (x0 < 0) x0 = 0;
	if (y0 < 0) y0 = 0;

	if (dx >= map[m].xs) dx = backx;
	if (dy >= map[m].ys) dy = backy;
	if (dx < 0) dx = backx;
	if (dy < 0) dy = backy;

	//printf("-----------\n");

	if (dx != backx || dy != backy) {
		//printf("BX: %d BY: %d DX: %d DY: %d\n",backx,backy,dx,dy);

		//if(moveish) map_delblock(&mob->bl);
		mob->bx = backx;
		mob->by = backy;
		//mob->bl.next=NULL;
		//mob->bl.prev=NULL;
		//printf("Moved\n");
		map_moveblock(&mob->bl, dx, dy);
		//if(moveish) map_addblock(&mob->bl);
		//if(x0 || y0) {
		if (!nothingnew) {
			if (mob->data->mobtype == 1) {
				map_foreachinblock(clif_cmoblook_sub, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_SEND, mob);
			}
			else {
				//map_foreachinblock(clif_mob_look,mob->bl.m,x0,y0,x0+(x1-1),y0+(y1-1),BL_PC,LOOK_SEND,mob);
				map_foreachinblock(clif_mob_look_start_func, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, mob);
				map_foreachinblock(clif_object_look_sub, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_SEND, &mob->bl);
				map_foreachinblock(clif_mob_look_close_func, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, mob);
				//map_foreachinarea(clif_mob_look,mob->bl.m,mob->bl.x,mob->bl.y,CORNER,BL_PC,LOOK_SEND,mob);
				//map_foreachinarea(clif_mob_move,m,mob->bl.x,mob->bl.y,CORNER,BL_PC,LOOK_SEND,mob);
			}
		}

		map_foreachincell(mob_trap_look, m, mob->bl.x, mob->bl.y, BL_NPC, mob, 0, subt);
		map_foreachinarea(clif_mob_move, m, mob->bl.x, mob->bl.y, AREA, BL_PC, LOOK_SEND, mob);
		return 1;
	}
	else {
		return 0;
	}
}

int moveghost_mob(MOB* mob) {
	int direction;
	int backx;
	int backy;
	int m;
	int c = 0;
	struct warp_list* i;
	//static last;
	int dx, dy;
	int x0, y0, x1, y1;
	int nothingnew = 0;
	int subt[1];
	int def[2];
	subt[0] = 0;

	m = mob->bl.m;
	backx = mob->bl.x;
	backy = mob->bl.y;
	dx = backx;
	dy = backy;
	direction = mob->side;
	//if(mob->canmove) return 1;
	//mob->side=direction;
	x0 = mob->bl.x;
	y0 = mob->bl.y;

	switch (direction) {
	case 0: //UP
		if (backy > 0) {
			dy = backy - 1;
			x0 -= 9;
			if (x0 < 0) x0 = 0;
			y0 -= 9;
			y1 = 1;
			x1 = 19;
			if (y0 < 7) nothingnew = 1;

			if (y0 == 7) {
				y1 += 7;
				y0 = 0;
			}

			if (x0 + 19 + 9 >= map[m].xs)
				x1 += 9 - ((x0 + 19 + 9) - map[m].xs);
			if (x0 <= 8) {
				x1 += x0;
				x0 = 0;
			}
		}

		break;
	case 1: //Right
		if (backx < map[m].xs) {
			x0 += 10;
			y0 -= 8;
			if (y0 < 0) y0 = 0;
			dx = backx + 1;
			y1 = 17;
			x1 = 1;
			if (x0 > map[m].xs - 9) nothingnew = 1;
			if (x0 == map[m].xs - 9) x1 += 9;
			if (y0 + 17 + 8 >= map[m].ys)
				y1 += 8 - ((y0 + 17 + 8) - map[m].ys);

			if (y0 <= 7) {
				y1 += y0;
				y0 = 0;
			}
		}

		break;
	case 2: //down
		if (backy < map[m].ys) {
			x0 -= 9;
			if (x0 < 0) x0 = 0;
			y0 += 9;
			dy = backy + 1;
			y1 = 1;
			x1 = 19;
			if (y0 + 8 > map[m].ys) nothingnew = 1;
			if (y0 + 8 == map[m].ys) y1 += 8;
			if (x0 + 19 + 9 >= map[m].xs)
				x1 += 9 - ((x0 + 19 + 9) - map[m].xs);

			if (x0 <= 8) {
				x1 += x0;
				x0 = 0;
			}
		}

		break;
	case 3: //left
		if (backx > 0) {
			x0 -= 10;
			y0 -= 8;
			if (y0 < 0) y0 = 0;
			y1 = 17;
			x1 = 1;
			dx = backx - 1;
			if (x0 < 8) nothingnew = 1;

			if (x0 == 8) {
				x0 = 0;
				x1 += 8;
			}

			if (y0 + 17 + 8 >= map[m].ys)
				y1 += 8 - ((y0 + 17 + 8) - map[m].ys);

			if (y0 <= 7) {
				y1 += y0;
				y0 = 0;
			}
		}

		break;
	default:
		break;
	}

	if (dx >= map[m].xs) dx = map[m].xs - 1;
	if (dy >= map[m].ys) dy = map[m].ys - 1;

	for (i = map[m].warp[dx / BLOCK_SIZE + (dy / BLOCK_SIZE) * map[m].bxs]; i && !c; i = i->next) {
		if (i->x == dx && i->y == dy) {
			c = 1;
			return 0;
		}
	}

	map_foreachincell(mob_move, m, dx, dy, BL_MOB, mob);
	map_foreachincell(mob_move, m, dx, dy, BL_PC, mob);
	map_foreachincell(mob_move, m, dx, dy, BL_NPC, mob);

	//if(read_pass(mob->bl.m,dx,dy)) mob->canmove = 1;

	if (clif_object_canmove(m, dx, dy, direction) && mob->target == 0) {
		mob->canmove = 0;
		return 0;
	}

	if (clif_object_canmove_from(m, backx, backy, direction) && mob->target == 0) {
		mob->canmove = 0;
		return 0;
	}

	if (map_canmove(m, dx, dy) == 1 && mob->target == 0) {
		mob->canmove = 0;
		return 0;
	}

	if (mob->canmove == 1) {
		mob->canmove = 0;
		return 0;
	}

	if (x0 > map[m].xs) x0 = map[m].xs - 1;
	if (y0 > map[m].ys) y0 = map[m].ys - 1;
	if (x0 < 0) x0 = 0;
	if (y0 < 0) y0 = 0;

	if (dx >= map[m].xs) dx = backx;
	if (dy >= map[m].ys) dy = backy;
	if (dx < 0) dx = backx;
	if (dy < 0) dy = backy;

	//printf("-----------\n");

	if (dx != backx || dy != backy) {
		//printf("BX: %d BY: %d DX: %d DY: %d\n",backx,backy,dx,dy);

		//if(moveish) map_delblock(&mob->bl);
		mob->bx = backx;
		mob->by = backy;
		//mob->bl.next=NULL;
		//mob->bl.prev=NULL;
		//printf("Moved\n");
		map_moveblock(&mob->bl, dx, dy);
		//if(moveish) map_addblock(&mob->bl);
		//if(x0 || y0) {
		if (!nothingnew) {
			if (mob->data->mobtype == 1) {
				map_foreachinblock(clif_cmoblook_sub, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_SEND, mob);
			}
			else {
				//map_foreachinblock(clif_mob_look,mob->bl.m,x0,y0,x0+(x1-1),y0+(y1-1),BL_PC,LOOK_SEND,mob);
				map_foreachinblock(clif_mob_look_start_func, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, mob);
				map_foreachinblock(clif_object_look_sub, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_SEND, &mob->bl);
				map_foreachinblock(clif_mob_look_close_func, mob->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, mob);
				//map_foreachinarea(clif_mob_look,mob->bl.m,mob->bl.x,mob->bl.y,CORNER,BL_PC,LOOK_SEND,mob);
				//map_foreachinarea(clif_mob_move,m,mob->bl.x,mob->bl.y,CORNER,BL_PC,LOOK_SEND,mob);
			}
		}

		map_foreachincell(mob_trap_look, m, mob->bl.x, mob->bl.y, BL_NPC, mob, 0, subt);
		map_foreachinarea(clif_mob_move, m, mob->bl.x, mob->bl.y, AREA, BL_PC, LOOK_SEND, mob);
		return 1;
	}
	else {
		return 0;
	}
}
int mob_calcstat(MOB* mob) {
	USER* tsd = NULL;
	struct skill_info* p = NULL;
	int x = 0;

	mob->maxvita = mob->data->vita;
	mob->maxmana = mob->data->mana;
	mob->ac = mob->data->baseac;

	if (mob->ac < -95) mob->ac = -95;

	mob->miss = mob->data->miss;
	mob->newmove = mob->data->movetime;
	mob->newatk = mob->data->atktime;
	mob->hit = mob->data->hit;
	mob->mindam = mob->data->mindam;
	mob->maxdam = mob->data->maxdam;
	mob->might = mob->data->might;
	mob->grace = mob->data->grace;
	mob->will = mob->data->will;

	mob->block = mob->data->block;
	mob->protection = mob->data->protection;
	mob->charstate = mob->data->state;
	mob->clone = 0;
	mob->paralyzed = 0;
	mob->blind = 0;
	mob->confused = 0;
	mob->snare = 0;
	mob->sleep = 1.0f;
	mob->deduction = 1.0f;
	mob->crit = 0;
	mob->critmult = 0;
	mob->invis = 1.0f;
	mob->amnesia = 0;

	if (mob->state != MOB_DEAD) {
		for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
			p = &mob->da[x];
			if (p->id > 0 && p->duration > 0) {
				tsd = map_id2sd(p->caster_id);

				if (tsd != NULL) {
					sl_doscript_blargs(magicdb_yname(p->id), "recast", 2, &mob->bl, &tsd->bl);
				}
				else {
					sl_doscript_simple(magicdb_yname(p->id), "recast", &mob->bl);
				}
			}
		}
	}

	return 0;
}

int mob_respawn_getstats(MOB* mob) {
	if ((mob->start < mob->end && cur_time >= mob->start && cur_time <= mob->end)
		|| (mob->start > mob->end && (cur_time >= mob->start || cur_time <= mob->end))
		|| (mob->start == mob->end && cur_time == mob->start && cur_time == mob->end)
		|| (mob->start == 25 && mob->end == 25)) {
		mob->data = mobdb_search(mob->mobid);
	}
	else if (mob->replace != 0) {
		mob->data = mobdb_search(mob->replace);
	}
	else {
		mob->data = mobdb_search(mob->mobid);
	}

	mob->maxvita = mob->data->vita;

	mob->maxmana = mob->data->mana;
	mob->ac = mob->data->baseac;

	if (mob->ac < -95) mob->ac = -95;

	if (!mob->exp) mob->exp = mobdb_experience(mob->mobid);

	mob->miss = mob->data->miss;
	mob->newmove = mob->data->movetime;
	mob->newatk = mob->data->atktime;
	mob->current_vita = mob->maxvita;
	mob->current_mana = mob->maxmana;
	mob->maxdmg = mob->current_vita;
	mob->hit = mob->data->hit;
	mob->mindam = mob->data->mindam;
	mob->maxdam = mob->data->maxdam;
	mob->might = mob->data->might;
	mob->grace = mob->data->grace;
	mob->will = mob->data->will;
	mob->block = mob->data->block;
	mob->protection = mob->data->protection;
	mob->look = mob->data->look;
	mob->look_color = mob->data->look_color;
	mob->charstate = mob->data->state;
	mob->clone = 0;
	mob->time = 0;
	mob->paralyzed = 0;
	mob->blind = 0;
	mob->confused = 0;
	mob->snare = 0;
	mob->target = 0;
	mob->attacker = 0;
	//mob->owner = 0;
	mob->confused_target = 0;
	mob->rangeTarget = 0;
	mob->dmgshield = 0;
	mob->sleep = 1.0f;
	mob->deduction = 1.0f;
	mob->damage = 0;
	mob->critchance = 0;
	mob->crit = 0;
	mob->critmult = 0;
	mob->invis = 1.0f;

	return 0;
}

int mob_respawn_nousers(MOB* mob) {
	if (mob->bl.m != mob->startm) {
		mob_warp(mob, mob->startm, mob->startx, mob->starty);
	}
	else {
		map_moveblock(&mob->bl, mob->startx, mob->starty);
	}

	mob->state = MOB_ALIVE;
	mob_respawn_getstats(mob);
	//map_moveblock(&mob->bl,mob->startx,mob->starty);
	sl_doscript_blargs("on_spawn", NULL, 1, &mob->bl);
	sl_doscript_blargs(mob->data->yname, "on_spawn", 1, &mob->bl);
	//map_addblock(&mob->bl);
	//map_foreachinarea(clif_mob_look,mob->bl.m,mob->bl.x,mob->bl.y,AREA,BL_PC,LOOK_SEND,mob);
	return 0;
}
int mob_respawn(MOB* mob) {
	if (mob->bl.m != mob->startm) {
		mob_warp(mob, mob->startm, mob->startx, mob->starty);
	}
	else {
		map_moveblock(&mob->bl, mob->startx, mob->starty);
	}
	mob->state = MOB_ALIVE;
	mob_respawn_getstats(mob);
	//map_moveblock(&mob->bl,mob->startx,mob->starty);
	//map_addblock(&mob->bl);
	if (mob->data->mobtype == 1) {
		map_foreachinarea(clif_cmoblook_sub, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC, LOOK_SEND, mob);
	}
	else {
		map_foreachinarea(clif_mob_look_start_func, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC);
		map_foreachinarea(clif_object_look_sub, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC, LOOK_SEND, &mob->bl);
		map_foreachinarea(clif_mob_look_close_func, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC);
	}
	sl_doscript_blargs("on_spawn", NULL, 1, &mob->bl);
	sl_doscript_blargs(mob->data->yname, "on_spawn", 1, &mob->bl);
	return 0;
}
int mob_find_target(struct block_list* bl, va_list ap) {
	MOB* mob;
	USER* sd;
	int i = 0;
	char invis = 0;
	char seeinvis = 0;
	short num = 0;

	nullpo_ret(0, mob = va_arg(ap, MOB*));
	nullpo_ret(0, sd = (USER*)bl);
	seeinvis = mob->data->seeinvis;
	for (i = 0; i < MAX_MAGIC_TIMERS; i++) {
		if (sd->status.dura_aether[i].duration > 0) {
			if (!strcmpi(magicdb_name(sd->status.dura_aether[i].id), "sneak")) invis = 1;
			if (!strcmpi(magicdb_name(sd->status.dura_aether[i].id), "cloak")) invis = 2;
			if (!strcmpi(magicdb_name(sd->status.dura_aether[i].id), "hide")) invis = 3;
		}
	}

	switch (invis) {
	case 1:
		if (seeinvis != 1 && seeinvis != 3 && seeinvis != 5) return 0;
		break;
	case 2:
		if (seeinvis != 2 && seeinvis != 3 && seeinvis != 5) return 0;
		break;
	case 3:
		if (seeinvis != 4 && seeinvis != 5) return 0;
		break;
	default:
		break;
	}

	if (sd->status.state == 1) return 0;

	if (mob->confused && mob->confused_target == sd->bl.id) return 0;

	if (mob->target) {
		num = rnd(1000);
		if (num <= 499 && sd->status.gm_level < 50) {
			mob->target = sd->status.id;
		}
	}
	else if (sd->status.gm_level < 50) {
		mob->target = sd->status.id;
	}

	return 0;
}

float mob_calc_damage(MOB* mob, USER* sd) {
	float damage;
	int side1, side2;
	damage = ((float)(mob->data->might)) * 2.0f;
	side1 = mob->side;
	side2 = sd->status.side;
	if (side1 == side2) {
		damage = damage * 2.0f;
	}
	else if (abs(side1 - side2) == 2) {
		damage = damage * 1.5f;
	}

	return damage;
}

int mob_attack(MOB* mob, int id) {
	USER* sd = NULL;
	MOB* tmob = NULL;

	if (id < 0) return 0;

	struct block_list* bl = map_id2bl((unsigned int)id);
	int x = 0;

	if (bl == NULL) return 0;

	if (bl->type == BL_PC) {
		sd = (USER*)bl;
	}
	else if (bl->type == BL_MOB) {
		tmob = (MOB*)bl;
	}

	if (sd) {
		if (sd->uFlags & uFlag_immortal || sd->optFlags & optFlag_stealth) {
			mob->target = 0;
			mob->attacker = 0;
			return 0;
		}
	}

	/*int ac;
	float damage;
	//int min_dam,max_dam;
	int hit;
	int chance;
	int crit;
	int type=0;
	int x;
	min_dam=mob->data->might*0.5;
	max_dam=mob->data->might;
	ac=max_dam-min_dam;
	if(max_dam>0) {
	damage = (float) rnd(ac);
	damage+= (float) min_dam;
	}
	//clif_playsound(&mob->bl,9);
	clif_sendaction(&mob->bl,1,14,9);
	hit=(35+(mob->data->grace*0.5)-(sd->grace*0.5)+(mob->data->hit*1.5)+(mob->data->level-sd->status.level));
	if(hit<5) hit=5;
	if(hit>85) hit=85;

	chance=rnd(100);
	if(chance<hit) {
		crit=(hit*0.05)+(mob->data->hit*0.5);
		if(chance<crit) {
			type=2;
		} else {
			type=1;
		}
	}*/
	if (sd != NULL) {
		sl_doscript_blargs("hitCritChance", NULL, 2, &mob->bl, &sd->bl);
	}
	else if (tmob != NULL) {
		sl_doscript_blargs("hitCritChance", NULL, 2, &mob->bl, &tmob->bl);
	}
	//type = mob->crit;
	//check to see if it hit
	//check for critical
	//if critical, ignore ac, do 3x damage
	//if no critical, do normal(check ac)
	//damage=damage*mob_calc_damage(mob,sd);
	/*damage = mob->damage;
	if(type==2) damage=damage*3.0f;
	if(type==1 && sd->ac>0) damage=damage*(1.0f+(((float) sd->ac)*0.01f));
	if(type==1 && sd->ac<0) damage=damage*(((float) sd->ac)*-0.01f);*/

	if (mob->critchance) {
		if (sd != NULL) {
			sl_doscript_blargs("swingDamage", NULL, 2, &mob->bl, &sd->bl);

			for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
				if (mob->da[x].id > 0) {
					if (mob->da[x].duration > 0) {
						sl_doscript_blargs(magicdb_yname(mob->da[x].id), "on_hit_while_cast", 2, &mob->bl, &sd->bl);
					}
				}
			}
		}
		else if (tmob != NULL) {
			sl_doscript_blargs("swingDamage", NULL, 2, &mob->bl, &tmob->bl);

			for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
				if (mob->da[x].id > 0) {
					if (mob->da[x].duration > 0) {
						sl_doscript_blargs(magicdb_yname(mob->da[x].id), "on_hit_while_cast", 2, &mob->bl, &tmob->bl);
					}
				}
			}
		}
		int dmg = (int)(mob->damage += 0.5f);

		/*if(sd->status.hp < dmg) {
			sd->status.hp=0;
		} else {
			sd->status.hp -= dmg;
		}*/
		if (sd != NULL) {
			if (mob->critchance == 1) {
				clif_send_pc_health(sd, dmg, 33);
			}
			else {
				clif_send_pc_health(sd, dmg, 255);
			}
			clif_sendstatus(sd, SFLAG_HPMP);
		}
		else if (tmob != NULL) {
			if (mob->critchance == 1) {
				clif_send_mob_health(tmob, dmg, 33);
			}
			else {
				clif_send_mob_health(tmob, dmg, 255);
			}
		}

		//support for on_hit_cast
		//mob->damage = (int) damage;
		//mob->crit = type;
		/*for(x=0;x<MAX_MAGIC_TIMERS;x++) {
			if(mob->da[x].duration > 0) {
				sl_doscript_blargs(magicdb_yname(mob->da[x].id),"on_hit_cast",2,&mob->bl,&sd->bl);
			}
		}
		sl_doscript_blargs(mob->data->yname,"on_hit",2,&mob->bl,&sd->bl);*/
	}

	//ranged mobs
	/*if(mob->ranged = 1) {
		if(mob->rangeTarget > 0) {
			MOB *TheMob = NULL;
			struct block_list *tbl = map_id2bl(mob->rangeTarget);
			nullpo_ret(0,tbl);

			struct map_sessiondata *tsd = map_id2sd(tbl->id);

			if(mob->bl.id == tbl->id || (mob->bl.x == tbl->x && mob->bl.y == tbl->y)) {
				mob->rangeTarget = 0;
				return 0;
			}
			if(tbl->m != mob->bl.m || (tbl->x > mob->bl.x + 8 || tbl->x < mob->bl.x - 8) || (tbl->y > mob->bl.y + 8 || tbl->y < mob->bl.y - 8)) {
				mob->rangeTarget = 0;
				return 0;
			}
			if(tbl) {
				long health=0;
				if(tbl->type == BL_PC) {
					health = tsd->status.hp;
				}
				else if(tbl->type == BL_MOB) {
					TheMob = (MOB*)map_id2mob(tbl->id);

					health = TheMob->current_vita;
				}
				if(health > 0 || tbl->type == BL_PC) {
					sl_doscript_blargs(mob->data->yname,"thrown",2,&mob->bl,tbl);
				}
			}
		}
		else {
			sl_doscript_simple(mob->data->yname,"thrown",&mob->bl);
		}
	}
	//if miss or hit, do swing cast
	for(x=0;x<MAX_MAGIC_TIMERS;x++) {
		if(mob->da[x].duration > 0) {
			sl_doscript_simple(magicdb_yname(mob->da[x].id),"on_swing_cast",&mob->bl);
		}
	}
	sl_doscript_blargs(mob->data->yname,"on_swing",&mob->bl);*/
	return 0;
}

int mob_calc_critical(MOB* mob, USER* sd) {
	int equat;
	int chance;
	float crit;

	equat = (mob->data->hit + mob->data->level + (mob->data->might / 5) + 20) - (sd->status.level + (sd->grace / 2));
	equat = equat - (sd->grace / 4) + sd->status.level;

	chance = rnd(100);

	if (equat < 5) equat = 5;
	if (equat > 95) equat = 95;

	if (chance < equat) {
		crit = (float)equat * 0.33;
		if (chance < crit) {
			return 2;
		}
		else {
			return 1;
		}
	}
	else {
		return 0;
	}
}

int mob_move2(MOB* mob, int x, int y, int side) {
	int direction;
	int backx;
	int backy;
	int m;
	static last;
	int cm;
	if (mob->canmove) return 1;
	m = mob->bl.m;
	mob->side = side;
	map_foreachincell(mob_move, m, x, y, BL_MOB, mob);
	map_foreachincell(mob_move, m, x, y, BL_PC, mob);
	cm = mob->canmove;
	if (map_canmove(m, x, y) == 0 && cm == 0) {
		//map_delblock(&mob->bl);
		mob->bx = mob->bl.x;
		mob->by = mob->bl.y;
		mob->bl.x = x;
		mob->bl.y = y;
		//map_addblock(&mob->bl);
		map_foreachinarea(clif_mob_move, m, mob->bl.x, mob->bl.y, AREA, BL_PC, LOOK_SEND, mob);
		mob->canmove = 1;
	}
	else {
		mob->canmove = 0;
		return 0;
	}

	return 1;
}

int mob_move(struct block_list* bl, va_list ap) {
	MOB* mob;
	MOB* m2;
	USER* sd;

	nullpo_ret(0, mob = va_arg(ap, MOB*));
	if (mob->canmove == 1) return 0;
	if (bl->type == BL_NPC) {
		if (bl->subtype) {
			return 0;
		}
	}
	else if (bl->type == BL_MOB) {
		m2 = (MOB*)bl;
		if (m2) {
			if (m2->state == MOB_DEAD) {
				return 0;
			}
		}
	}
	else if (bl->type == BL_PC) {
		sd = (USER*)bl;
		if ((map[mob->bl.m].show_ghosts && sd->status.state == PC_DIE) || sd->status.state == -1 || sd->status.gm_level >= 50) {
			return 0;
		}
	}

	mob->canmove = 1;
	return 0;
}

//MOB AI STUFF GOES HERE
int mob_pathfind(MOB* mob) {
	USER* sd = map_id2sd(mob->target);

	if (sd->optFlags & optFlag_stealth || sd->uFlags & uFlag_immortal) {
		mob->target = 0;
		mob->attacker = 0;
		return 0;
	}

	int i;
	nullpo_ret(0, sd);

	int num = move_mob_intent(mob, sd);
	switch (num) {
	case 0:
		for (i = 0; i < 10; i++) {
			mob->side = rnd(4);
			if (move_mob(mob)) {
				return 0;
			}
		}
		break;
	case 1:
		break;
	case 2:
		return 1;
	}
	return 0;
}
int mobAIhit(MOB* mob) {
	int near;
	if (mob->target) {
		near = mob_pathfind(mob);
		if (near) {
			mob_attack(mob, map_id2sd(mob->target));
		}
	}
	return 0;
}
int mobAIeasy(MOB* mob, struct block_list* bl) {
	if (mob->paralyzed) return 0;
	if (mob->state != MOB_HIT) {
		mob->side = rnd(4);
		move_mob(mob);
	}
	else {
		//mobAIhit(mob);
	}
	return 0;
}

int mobAInormal(MOB* mob) {
	return 0;
}

int mobAIhard(MOB* mob) {
	return 0;
}
int move_mob_intent(MOB* mob, struct block_list* bl) {
	int mx, my;
	int px, py;
	int ax, ay;
	int rd;
	int side;
	int d = 0;
	//int zz=0;
	if (!bl) return 0;

	mob->canmove = 0;
	mx = mob->bl.x;
	my = mob->bl.y;
	px = bl->x;
	py = bl->y;
	ax = abs(mx - px);
	ay = abs(my - py);
	side = mob->side;
	//zz=rnd(2);
	if ((ax == 0 && ay == 1) || (ax == 1 && ay == 0)) { //means we are next to the player
		if (mx < px) mob->side = 1;
		if (mx > px) mob->side = 3;
		if (my < py) mob->side = 2;
		if (my > py) mob->side = 0;
		if (side != mob->side) clif_sendmob_side(mob);

		//mob_attack(mob,sd); //attack the SOB
		return 1;
	}
	else {
		return 0;
		/*if(mx < px && ay==0) { d= mob_move2(mob,mx+1,my,1); }
		if(mx > px && ay==0) { d=mob_move2(mob,mx-1,my,3); }
		if(my < py && ax==0) { d=mob_move2(mob,mx,my+1,2); }
		if(my > py && ax==0) { d= mob_move2(mob,mx,my-1,0); }
		*/
		/*if(zz) {
			if(my < py) { mob->side=2; d=move_mob(mob); }
			if(my > py && d==0) { mob->side=0; d=move_mob(mob); }
			if(mx < px && d==0) { mob->side=1; d=move_mob(mob); }
			if(mx > px && d==0) { mob->side=3; d=move_mob(mob); }
		} else {
			if(mx < px) { mob->side=1; d=move_mob(mob); }
			if(mx > px && d==0) { mob->side=3; d=move_mob(mob); }
			if(my < py && d==0) { mob->side=2; d=move_mob(mob); }
			if(my > py && d==0) { mob->side=0; d=move_mob(mob); }
		}*/
	}
	//  if(d==0) mob->side=side; //didn't move, change back
	//chances are it moved
	//return d;
}

int mob_warp(MOB* mob, int m, int x, int y) {
	nullpo_ret(0, mob);
	if (mob->bl.id < MOB_START_NUM || mob->bl.id >= NPC_START_NUM) return 0;
	map_delblock(&mob->bl);
	clif_lookgone(&mob->bl);
	mob->bl.m = m;
	mob->bl.x = x;
	mob->bl.y = y;
	mob->bl.type = BL_MOB;

	if (map_addblock(&mob->bl)) {
		printf("Error warping mob.\n");
	}

	//map_moveblock(&mob->bl, mob->bl.x, mob->bl.y);

	if (mob->data->mobtype == 1) {
		map_foreachinarea(clif_cmoblook_sub, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC, LOOK_SEND, mob);
	}
	else {
		map_foreachinarea(clif_object_look_sub2, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC, LOOK_SEND, mob);
	}
	return 0;
}

int mob_readglobalreg(MOB* mob, char* reg) {
	int i, exist;

	exist = -1;
	nullpo_ret(0, mob);
	nullpo_ret(0, reg);

	for (i = 0; i < MAX_GLOBALMOBREG; i++) {
		if (strcmpi(mob->registry[i].str, reg) == 0) {
			exist = i;
			break;
		}
	}

	if (exist != -1) {
		return mob->registry[exist].val;
	}
	else {
		return 0;
	}

	return 0;
}

int mob_setglobalreg(MOB* mob, char* reg, int val) {
	int i, exist;

	exist = -1;
	nullpo_ret(0, mob);
	nullpo_ret(0, reg);

	//if registry exists, get number
	for (i = 0; i < MAX_GLOBALMOBREG; i++) {
		if (strcmpi(mob->registry[i].str, reg) == 0) {
			exist = i;
			break;
		}
	}

	//if registry exists, set value
	if (exist != -1) {
		if (val == 0) {
			strcpy(mob->registry[exist].str, ""); //empty registry
			mob->registry[exist].val = val;
			return 0;
		}
		else {
			mob->registry[exist].val = val;
			return 0;
		}
	}
	else {
		for (i = 0; i < MAX_GLOBALMOBREG; i++) {
			if (strcmpi(mob->registry[i].str, "") == 0) {
				strcpy(mob->registry[i].str, reg);
				mob->registry[i].val = val;
				return 0;
			}
		}
	}

	printf("mob_setglobalreg : couldn't set %s\n", reg);
	return 1;
}
