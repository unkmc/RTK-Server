#ifndef _MMO_H_
#define _MMO_H_

#include <../map/itemdb.h>
#define FIFOSIZE_SERVER (512*1024)
#define MAX_MAP_SERVER	5
#define MAX_MAP_PER_SERVER 65535
#define MAX_GLOBALREG 5000
#define MAX_GLOBALPLAYERREG 500
#define MAX_GLOBALQUESTREG 250
#define MAX_GLOBALMOBREG 50
#define MAX_GLOBALNPCREG 100
#define MAX_KILLREG 5000
#define MAX_MAGIC_TIMERS 200
#define MAX_LEGENDS 1000
#define MAX_CHAR_BANK 100
#define MAX_ACCT_BANK 100
#define MAX_SPELLS 52
#define MAX_INVENTORY 52
#define MAX_EQUIP 15
#define MAX_BANK_SLOTS 255
#define MAX_THREATCOUNT 50

/*enum baseMaxes
{
	BASE_MGW = 96,
	BASE_ACMR = 60,
	BASE_VITAMANA = 1920,
	BASE_HEALING = 8,
	BASE_MINMAXDAM = 72,
	BASE_PD = 480,
	BASE_PROT = 8,
	BASE_SPEED = 16,
	BASE_WEAPARMOR = 42
};*/

enum settingFLAGS
{
	FLAG_WHISPER = 1,
	FLAG_GROUP = 2,
	FLAG_SHOUT = 4,
	FLAG_ADVICE = 8,
	FLAG_MAGIC = 16,
	FLAG_WEATHER = 32,
	FLAG_REALM = 64,
	FLAG_EXCHANGE = 128,
	FLAG_FASTMOVE = 256,
	FLAG_SOUND = 4096,
	FLAG_HELM = 8192,
	FLAG_NECKLACE = 16384
};
enum normalFlags
{
	FLAG_PARCEL = 1,
	FLAG_MAIL = 16
};

///Board Packet Flags
enum boardShowFlags
{
	BOARD_CAN_WRITE = 1,
	BOARD_CAN_DEL = 2
};

struct point {
	unsigned short m, x, y;
};

struct item {
	unsigned int id, owner, custom, time;
	int dura, amount;
	unsigned char pos;
	unsigned int customLook, customIcon;
	unsigned int customLookColor, customIconColor;
	unsigned int protected;
	unsigned int trapsTable[100];
	unsigned char buytext[64];

	char note[300];

	char repair;
	char real_name[64];
};

struct legend {
	unsigned short icon, color;
	char text[255], name[64];
	unsigned tchaid;
};

struct skill_info {
	int duration, aether, time;
	unsigned short id, animation;
	unsigned int caster_id, dura_timer, aether_timer;
	unsigned long lasttick_dura, lasttick_aether;
};

//for sql banks
struct bank_data {
	unsigned int item_id, amount, owner, time, customIcon, customLook;
	char real_name[64];
	unsigned int customLookColor, customIconColor, protected;
	char note[300];
};

struct kill_reg {
	unsigned int mob_id, amount;
};

struct global_reg {
	char str[64];
	unsigned int val;
};

struct global_regstring {
	char str[64];
	char val[255];
};

struct bank_space {
	int item_id, amount;
	char engrave[32];
	unsigned int customLook, customIcon;
	unsigned int customLookColor, customIconColor;
};

struct mmo_charstatus {
	unsigned int id, partner, clan, hp, basehp, mp, basemp, exp, money, maxslots, bankmoney;
	unsigned int killedby, killspk, pkduration;
	unsigned char profile_vitastats, profile_equiplist, profile_legends, profile_spells, profile_inventory, profile_bankitems;

	char name[16], pass[33], f1name[16], title[32], clan_title[32], ipaddress[255], gm_level, sex, country, state, side, clan_chat, novice_chat, afkmessage[80];
	unsigned char tutor;
	char subpath_chat, mute;
	char alignment;
	int basearmor;
	float karma;

	int clanRank;
	int classRank;

	unsigned int basemight, basewill, basegrace, might, will, grace, heroes, miniMapToggle;
	unsigned char level, totem, class, tier, mark, MagicNumber;
	unsigned char maxinv, pk;
	unsigned short face_color, hair, hair_color, armor_color, skin_color, settingFlags, face, disguise, disguisecolor, skill[MAX_SPELLS];
	unsigned long long expsoldmagic, expsoldhealth, expsoldstats;

	int map_server;
	int intpercentage;
	float percentage;
	unsigned int nextlevelxp, maxtnl, realtnl, tnl;

	struct point dest_pos;
	struct point last_pos;
	struct item equip[MAX_EQUIP];
	struct item inventory[MAX_INVENTORY];
	struct legend legends[MAX_LEGENDS];
	struct skill_info dura_aether[MAX_MAGIC_TIMERS];
	struct global_reg global_reg[MAX_GLOBALREG];
	struct global_regstring global_regstring[MAX_GLOBALREG];
	struct global_reg acctreg[MAX_GLOBALREG];
	struct global_reg npcintreg[MAX_GLOBALREG];
	struct global_reg questreg[MAX_GLOBALQUESTREG];
	struct kill_reg killreg[MAX_KILLREG];
	int global_reg_num;
	int global_regstring_num;
	struct bank_data banks[MAX_BANK_SLOTS]; //player banks
};
///User List Packet
struct user_list {
	int class, mark, server, clan, hunter;
	char name[16];
};

///Board Packets (Inter-Server Communication) 0 = From Map, 1 = From Char
struct boards_post_0 {
	int fd, board, nval;
	char name[16], topic[53], post[4001];
};

struct board_show_0 {
	int fd, board, bcount, flags;
	char popup, name[16];
};

struct boards_show_header_1 {
	int fd, board, count, flags1, flags2, array;
	char name[16];
};

struct boards_show_array_1 {
	int board_name, color, post_id, month, day;
	char user[32], topic[64];
};

struct boards_read_post_0 {
	char name[16];
	int fd, post, board, flags;
};

struct boards_read_post_1 {
	int fd, post, month, day, board, board_name, type, buttons;
	char name[16], msg[4000], user[52], topic[52];
};

unsigned int getTicks(void);
void crash_log(char*, ...);
#endif
