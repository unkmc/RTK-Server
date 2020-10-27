#ifndef _ITEM_H_
#define _ITEM_H_

#define ITEMDB_FILE "db/item_db.txt"

enum {
	EQ_WEAP,
	EQ_ARMOR,
	EQ_SHIELD,
	EQ_HELM,
	EQ_LEFT,
	EQ_RIGHT,
	EQ_SUBLEFT,
	EQ_SUBRIGHT,
	EQ_FACEACC,
	EQ_CROWN,
	EQ_MANTLE,
	EQ_NECKLACE,
	EQ_BOOTS,
	EQ_COAT,
	EQ_FACEACCTWO
};

enum {
	ITM_EAT, //0
	ITM_USE, //1
	ITM_SMOKE, //2
	ITM_WEAP, //3
	ITM_ARMOR, //4
	ITM_SHIELD, //5
	ITM_HELM, //6
	ITM_LEFT, //7
	ITM_RIGHT, //8
	ITM_SUBLEFT, //9
	ITM_SUBRIGHT, //10
	ITM_FACEACC, //11
	ITM_CROWN, //12
	ITM_MANTLE, //13
	ITM_NECKLACE, //14
	ITM_BOOTS, //15
	ITM_COAT, //16
	ITM_HAND, //17
	ITM_ETC, //18
	ITM_USESPC, //19
	ITM_TRAPS, //20
	ITM_BAG, // 21
	ITM_MAP, // 22
	ITM_QUIVER, // 23
	ITM_MOUNT, // 24
	ITM_FACE, // 25
	ITM_SET, // 26
	ITM_SKIN, // 27
	ITM_HAIR_DYE, // 28
	ITM_FACEACCTWO // 29
};

struct item_data {
	unsigned int id, sound, minSdam, maxSdam, minLdam, maxLdam, sound_hit, time, amount;
	char name[64], yname[64], text[64], buytext[64];
	unsigned char type, class, sex, level, icon_color, ethereal;
	unsigned char unequip;
	int price, sell, rank, stack_amount, look, look_color, dura, might, will, grace, ac, dam, hit, vita, mana, protection, protected, healing, wisdom, con, attack_speed, icon;
	int mightreq, depositable, exchangeable, droppable, thrown, thrownconfirm, repairable, max_amount, skinnable, bod;
	char* script, * equip_script, * unequip_script;
};

extern struct DBMap* item_db;
//extern struct DBMap *custom_db;

struct item_data* itemdb_search(unsigned int);
struct item_data* itemdb_searchexist(unsigned int);
struct item_data* itemdb_searchname(const char*);
int itemdb_thrown(unsigned int);
int itemdb_thrownconfirm(unsigned int);
unsigned int itemdb_id(char* str);
char* itemdb_name(unsigned int);
char* itemdb_yname(unsigned int);
int itemdb_attackspeed(signed int);
int itemdb_wisdom(unsigned int);
int itemdb_con(unsigned int);
int itemdb_maxamount(unsigned int);
int itemdb_sound(unsigned int);
int itemdb_dura(unsigned int);
int itemdb_look(unsigned int);
int itemdb_lookcolor(unsigned int);
int itemdb_icon(unsigned int);
int itemdb_iconcolor(unsigned int);
int itemdb_type(unsigned int);
int itemdb_level(unsigned int);
int itemdb_might(unsigned int);
int itemdb_mightreq(unsigned int);
int itemdb_grace(unsigned int);
int itemdb_will(unsigned int);
int itemdb_sex(unsigned int);
int itemdb_vita(unsigned int);
int itemdb_mana(unsigned int);
int itemdb_ac(unsigned int);
int itemdb_dam(unsigned int);
int itemdb_hit(unsigned int);
int itemdb_mindam(unsigned int);
int itemdb_maxdam(unsigned int);
int itemdb_mincritdam(unsigned int);
int itemdb_maxcritdam(unsigned int);
int itemdb_rank(unsigned int);
int itemdb_exchangeable(unsigned int);
int itemdb_breakondeath(unsigned int);
int itemdb_droppable(unsigned int);
int itemdb_depositable(unsigned int);
int itemdb_skinnable(unsigned int);
int itemdb_unequip(unsigned int);
unsigned int itemdb_soundhit(unsigned int);
char* itemdb_script(unsigned int);
char* itemdb_unequipscript(unsigned int);
char* itemdb_equipscript(unsigned int);
char* itemdb_text(unsigned int);
char* itemdb_buytext(unsigned int);
int itemdb_read();
int itemdb_term();
int itemdb_init();
unsigned int itemdb_reqvita(unsigned int);
unsigned int itemdb_reqmana(unsigned int);
int itemdb_maxamount(unsigned int);
int itemdb_healing(unsigned int);
int itemdb_ethereal(unsigned int);
int itemdb_repairable(unsigned int);
int itemdb_dodge(unsigned int);
int itemdb_block(unsigned int);
int itemdb_parry(unsigned int);
int itemdb_price(unsigned int);
int itemdb_class(unsigned int);
int itemdb_protection(unsigned int);
int itemdb_protected(unsigned int);
int itemdb_resist(unsigned int);
int itemdb_physdeduct(unsigned int);
int itemdb_time(unsigned int);

#endif
