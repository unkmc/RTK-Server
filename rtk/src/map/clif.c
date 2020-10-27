#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include "core.h"
#include "map.h"
#include "intif.h"
#include "socket.h"
#include "crypt.h"
#include "clif.h"
#include "malloc.h"
#include "md5calc.h"
#include "mmo.h"
#include "pc.h"
#include "itemdb.h"
#include "command.h"
#include "mob.h"
#include "npc.h"
#include "magic.h"
#include "timer.h"
#include "class_db.h"
#include "script.h"
#include "board_db.h"
#include "clan_db.h"
#include "sl.h"
#include "zlib.h"

#include "../common/db.h"
#include "../common/showmsg.h"
#include "../common/rndm.h"
#include "../common/db_mysql.h"
///testcxv
unsigned int groups[MAX_GROUPS][MAX_GROUP_MEMBERS];
unsigned int log_ip;
unsigned int log_port;
int flags[16] = { 1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16386,32768,0 };
const unsigned char clkey2[] = { 6,8,9,10,15,19,23,26,28,41,45,46,50,57 };
const unsigned char svkey2[] = { 4,7,8,11,12,19,23,24,51,54,57,64,99 };//added 125(7D)
const unsigned char svkey1packets[] = { 2,3,10,64,68,94,96,98,102,111 };
const unsigned char clkey1packets[] = { 2,3,4,11,21,38,58,66,67,75,80,87,98,113,115,123 };
//const unsigned char clkey1packets[] = {2,3,4,11,21,38,58,66,67,75,80,84,85,87,98,113,115,123}; // added packet 84 and 85
int clif_canmove_sub(struct block_list*, va_list);
int isKey2(int);
int isKey(int);

/*int isKey2(int fd)
{
	int x=0;
	for(x=0;x<(sizeof(clkey2)/sizeof(clkey2[0]));x++)
	{
		if(fd==clkey2[x])
			return 1;
	}

	return 0;
}
int isKey(int fd)
{
	int x=0;
	for(x=0; x<(sizeof(svkey2)/sizeof(svkey2[0]));x++)
	{
		if(fd==svkey2[x])
			return 1;
	}
	return 0;
}*/
int isKey2(int fd)
{
	int x = 0;
	for (x = 0; x < (sizeof(clkey1packets) / sizeof(clkey1packets[0])); x++)
	{
		if (fd == clkey1packets[x])
			return 0;
	}

	return 1;
}
int isKey(int fd)
{
	int x = 0;
	for (x = 0; x < (sizeof(svkey1packets) / sizeof(svkey1packets[0])); x++)
	{
		if (fd == svkey1packets[x])
			return 0;
	}
	return 1;
}

int getclifslotfromequiptype(int equipType) {
	int type;

	switch (equipType) {
	case EQ_WEAP:
		type = 0x01;
		break;
	case EQ_ARMOR:
		type = 0x02;
		break;
	case EQ_SHIELD:
		type = 0x03;
		break;
	case EQ_HELM:
		type = 0x04;
		break;
	case EQ_NECKLACE:
		type = 0x06;
		break;
	case EQ_LEFT:
		type = 0x07;
		break;
	case EQ_RIGHT:
		type = 0x08;
		break;
	case EQ_BOOTS:
		type = 13;
		break;
	case EQ_MANTLE:
		type = 14;
		break;
	case EQ_COAT:
		type = 16;
		break;
	case EQ_SUBLEFT:
		type = 20;
		break;
	case EQ_SUBRIGHT:
		type = 21;
		break;
	case EQ_FACEACC:
		type = 22;
		break;
	case EQ_CROWN:
		type = 23;
		break;
	default:
		type = 0;
	}

	return type;
}

/*int encrypt(int fd)
{
	USER* sd=NULL;
	sd = (USER*)session[fd]->session_data;

	if(isKey(WFIFOB(fd,3)))

	{	//crypt2(WFIFOP(fd,0),sd->status.EncKey);
		crypt2(WFIFOP(fd,0),&(sd->status.EncKey));
	//printf("Key %s (%d) (%s)\n",sd->status.name,WFIFOB(fd,3),sd->status.EncKey);
	} else {
		crypt(WFIFOP(fd,0));
	}

	return (int) SWAP16(*(unsigned short*)WFIFOP(fd, 1)) + 3;
}
int decrypt(int fd)
{
	USER* sd=NULL;
	sd = (USER*)session[fd]->session_data;

	if(isKey2(RFIFOB(fd,3)))
	{
		crypt2(RFIFOP(fd,0),&(sd->status.EncKey));
	} else {
		crypt(RFIFOP(fd, 0));
	}
}*/
int encrypt(int fd)
{
	USER* sd = NULL;
	char key[16];
	sd = (USER*)session[fd]->session_data;
	nullpo_ret(0, sd);
	set_packet_indexes(WFIFOP(fd, 0));
	//@(O.O)@
	//  (o)
	//  /)/)
	// (O.O)/)
	//o(")(")
	if (isKey(WFIFOB(fd, 3)))
	{
		generate_key2(WFIFOP(fd, 0), &(sd->EncHash), &(key), 0);
		crypt2(WFIFOP(fd, 0), &(key));
	}
	else {
		crypt(WFIFOP(fd, 0));
	}
	return (int)SWAP16(*(unsigned short*)WFIFOP(fd, 1)) + 3;
}
int decrypt(int fd)
{
	USER* sd = NULL;
	char key[16];
	sd = (USER*)session[fd]->session_data;
	nullpo_ret(0, sd);

	if (isKey2(RFIFOB(fd, 3)))
	{
		generate_key2(RFIFOP(fd, 0), &(sd->EncHash), &(key), 1);
		crypt2(RFIFOP(fd, 0), &(key));
	}
	else {
		crypt(RFIFOP(fd, 0));
	}
}

char* replace_str(char* str, char* orig, char* rep)
{
	//puts(replace_str("Hello, world!", "world", "Miami"));

	static char buffer[4096];
	char* p;

	if (!(p = strstr(str, orig)))  // Is 'orig' even in 'str'?
		return str;

	strncpy(buffer, str, p - str); // Copy characters from 'str' start to 'orig' st$
	buffer[p - str] = '\0';

	sprintf(buffer + (p - str), "%s%s", rep, p + strlen(orig));

	return buffer;
}

char* clif_getName(unsigned int id) {
	//char* name;
	//CALLOC(name,char,16);
	//memset(name,0,16);

	static char name[16];
	memset(name, 0, 16);

	SqlStmt* stmt;

	stmt = SqlStmt_Malloc(sql_handle);
	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaName` FROM `Character` WHERE `ChaId` = '%u'", id)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &name, sizeof(name), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
	}

	if (SQL_SUCCESS == SqlStmt_NextRow(stmt)) {}

	SqlStmt_Free(stmt);

	return &name[0];
}

int clif_Hacker(char* name, const char* reason) {
	char StringBuffer[1024];
	printf(CL_MAGENTA"%s "CL_NORMAL"possibly hacking"CL_BOLD"%s"CL_NORMAL"\n", name, reason);
	sprintf(StringBuffer, "%s possibly hacking: %s", name, reason);
	clif_broadcasttogm(StringBuffer, -1);
}
int clif_sendurl(USER* sd, int type, char* url)
{
	if (!sd) return 0;

	int ulen = strlen(url);
	int len = 0;

	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x66;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = type; // type. 0 = ingame browser, 1= popup open browser then close client, 2 = popup
	WFIFOW(sd->fd, 6) = SWAP16(strlen(url));
	memcpy(WFIFOP(sd->fd, 8), url, strlen(url));

	WFIFOW(sd->fd, 1) = SWAP16(strlen(url) + 8);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_sendprofile(USER* sd)
{
	if (!sd) return 0;

	int len = 0;

	char url[255];
	sprintf(url, "https://www.RetroTK.com/users");

	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x62;
	WFIFOB(sd->fd, 5) = 0x04;
	WFIFOB(sd->fd, 6) = strlen(url);
	memcpy(WFIFOP(sd->fd, 7), url, strlen(url));

	len += strlen(url) + 7;

	WFIFOW(sd->fd, 1) = SWAP16(len);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_sendboard(USER* sd) {
	int len = 0;

	//char url1[] = "http://board.nexustk.com";
	//char url2[] = "http://www.nexustk.com";
	char url1[] = "https://www.RetroTK.com/boards"; // this first URL doesnt appear to do shit.. might be like a referral
	char url2[] = "https://www.RetroTK.com/boards"; // This is the actual URL that the browser goes to

	char url3[] = "}domain=0&fkey=2&data=c3OPyAa3RaHPFuHmpuQmR]bl3bVK5KHmyAbkLmI92uHl34FKiAHPyUbmi]aYpYbl2OQkpKbsyUQmyNdl3nqPGJwkem1YqEVXhEFY3MIu"; // yea who fucking knows it was in the original packet though

	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x62;
	WFIFOB(sd->fd, 5) = 0x00; // type  0 = board

	len += 6;

	WFIFOB(sd->fd, len) = strlen(url1);
	memcpy(WFIFOP(sd->fd, len + 1), url1, strlen(url1));
	len += strlen(url1) + 1;

	WFIFOB(sd->fd, len) = strlen(url2);
	memcpy(WFIFOP(sd->fd, len + 1), url2, strlen(url2));
	len += strlen(url2) + 1;

	WFIFOB(sd->fd, len) = strlen(url3);
	memcpy(WFIFOP(sd->fd, len + 1), url3, strlen(url3));
	len += strlen(url3) + 1;

	WFIFOW(sd->fd, 1) = SWAP16(len);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

//profile URL 0x62
//worldmap location URL 0x70

int CheckProximity(struct point one, struct point two, int radius) {
	int ret = 0;

	if (one.m == two.m)
		if (abs(one.x - two.x) <= radius && abs(one.y - two.y) <= radius) ret = 1;

	return ret;
}

int clif_accept2(int fd, char* name, int name_len) {
	int i, a, b, c, d;
	char n[32];
	int t = 0;

	//struct auth_node* db=NULL;
	//printf("Namelen: %d\n",name_len);

	if (name_len <= 0 || name_len > 16) {
		session[fd]->eof = 11;
		return 0;
	}

	if (server_shutdown) {
		session[fd]->eof = 1;
		return 0;
	}
	memset(n, 0, 16);
	memcpy(n, name, name_len);
	//printf("Name: %s\n",n);

	/*for(i=0;i<AUTH_FIFO_SIZE;i++) {
		if((auth_fifo[i].ip == (unsigned int)session[fd]->client_addr.sin_addr.s_addr)) {
			if(!strcmpi(n,auth_fifo[i].name)) {
			intif_load(fd, auth_fifo[i].id, auth_fifo[i].name);
			auth_fifo[i].ip = 0;
			auth_fifo[i].id = 0;

			return 0;
		}
	}
	}*/

	int id = 0;

	SqlStmt* stmt;
	stmt = SqlStmt_Malloc(sql_handle);
	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return -1;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaId` FROM `Character` WHERE `ChaName` = '%s'", n)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_UINT, &id, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return -1;
	}

	if (SQL_SUCCESS == SqlStmt_NextRow(stmt)) {
		SqlStmt_Free(stmt);
	}

	memcpy(session[fd]->name, n, name_len);
	intif_load(fd, id, n);
	auth_delete(n);

	/*t=auth_check(n,session[fd]->client_addr.sin_addr.s_addr);

	if(t) {
		memcpy(session[fd]->name,n,name_len);
		intif_load(fd,t,n);
		auth_delete(n);
	} else {
	a=b=c=d=session[fd]->client_addr.sin_addr.s_addr;
	a &=0xff;
	b=(b>>8)&0xff;
	c=(c>>16)&0xff;
	d=(d>>24)&0xff;

	printf("Denied access to "CL_CYAN"%s"CL_NORMAL" (ip:"CL_MAGENTA"%u.%u.%u.%u)\n",n,a,b,c,d);
	session[fd]->eof = 1;
	}*/
	return 0;
}

int clif_timeout(int fd) {
	USER* sd = NULL;
	int a, b, c, d;

	if (fd == char_fd) return 0;
	if (fd <= 1) return 0;
	if (!session[fd]) return 0;
	if (!session[fd]->session_data) session[fd]->eof = 12;

	nullpo_ret(0, sd = (USER*)session[fd]->session_data);
	a = b = c = d = session[fd]->client_addr.sin_addr.s_addr;
	a &= 0xff;
	b = (b >> 8) & 0xff;
	c = (c >> 16) & 0xff;
	d = (d >> 24) & 0xff;

	printf("\033[1;32m%s \033[0m(IP: \033[1;40m%u.%u.%u.%u\033[0m) timed out!\n", sd->status.name, a, b, c, d);
	session[fd]->eof = 1;
	return 0;
}
int clif_popup(USER* sd, const char* buf) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, strlen(buf) + 5 + 3);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(strlen(buf) + 5);
	WFIFOB(sd->fd, 3) = 0x0A;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0x08;
	WFIFOW(sd->fd, 6) = SWAP16(strlen(buf));
	strcpy(WFIFOP(sd->fd, 8), buf);
	WFIFOSET(sd->fd, encrypt(sd->fd));
}

int clif_paperpopup(USER* sd, const char* buf, int width, int height) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, strlen(buf) + 11 + 3);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(strlen(buf) + 11);
	WFIFOB(sd->fd, 3) = 0x35;
	WFIFOB(sd->fd, 5) = 0; //dunno
	WFIFOB(sd->fd, 6) = width; //width of paper
	WFIFOB(sd->fd, 7) = height; //height of paper
	WFIFOB(sd->fd, 8) = 0; //dunno
	WFIFOW(sd->fd, 9) = SWAP16(strlen(buf)); //length of message
	strcpy(WFIFOP(sd->fd, 11), buf); //message
	WFIFOSET(sd->fd, encrypt(sd->fd));
}

int clif_paperpopupwrite(USER* sd, const char* buf, int width, int height, int invslot) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, strlen(buf) + 11 + 3);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(strlen(buf) + 11);
	WFIFOB(sd->fd, 3) = 0x1B;
	WFIFOB(sd->fd, 5) = invslot; // invslot
	WFIFOB(sd->fd, 6) = 0; //dunno
	WFIFOB(sd->fd, 7) = width; //width of paper
	WFIFOB(sd->fd, 8) = height; //height of paper
	WFIFOW(sd->fd, 9) = SWAP16(strlen(buf)); //length of message
	strcpy(WFIFOP(sd->fd, 11), buf); //message
	WFIFOSET(sd->fd, encrypt(sd->fd));
}

int clif_paperpopupwrite_save(USER* sd) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	char input[300];
	memset(input, 0, 300);

	memcpy(input, RFIFOP(sd->fd, 8), SWAP16(RFIFOW(sd->fd, 6)));
	unsigned int slot = RFIFOB(sd->fd, 5);

	if (strcmp(sd->status.inventory[slot].note, input) != 0) {
		memcpy(sd->status.inventory[slot].note, input, 300);
	}
}

int stringTruncate(char* buffer, int maxLength) {
	if (!buffer || maxLength <= 0 || strlen(buffer) == maxLength)
		return 0;

	buffer[maxLength] = '\0';
	return 0;
}

int clif_transfer(USER* sd, int serverid, int m, int x, int y) {
	int len = 0;
	int dest_port;
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	if (serverid == 0) dest_port = 2001;
	if (serverid == 1) dest_port = 2002;
	if (serverid == 2) dest_port = 2003;

	WFIFOHEAD(sd->fd, 255);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x03;
	WFIFOL(sd->fd, 4) = SWAP32(map_ip);
	WFIFOW(sd->fd, 8) = SWAP16(dest_port);
	WFIFOB(sd->fd, 10) = 0x16;
	WFIFOW(sd->fd, 11) = SWAP16(9);
	//len=strlen(sd->status.name);
	strcpy(WFIFOP(sd->fd, 13), "KruIn7inc");
	len = 11;
	WFIFOB(sd->fd, len + 11) = strlen(sd->status.name);
	strcpy(WFIFOP(sd->fd, len + 12), sd->status.name);
	len += strlen(sd->status.name) + 1;
	//WFIFOL(sd->fd,len+11)=SWAP32(sd->status.id);
	len += 4;

	WFIFOB(sd->fd, 10) = len;
	WFIFOW(sd->fd, 1) = SWAP16(len + 8);
	//set_packet_indexes(WFIFOP(sd->fd, 0));
	WFIFOSET(sd->fd, len + 11);// + 3);

	return 0;
}

int clif_transfer_test(USER* sd, int m, int x, int y) {
	int len = 0;
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	char map_ipaddress_s[] = "51.254.215.72";
	//char map_ipaddress_s[] = "52.88.44.46";
	//char map_ipaddress_s[] = "103.224.182.241"; // etk
	unsigned int map_ipaddress = inet_addr(map_ipaddress_s);

	WFIFOHEAD(sd->fd, 255);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x03;
	WFIFOL(sd->fd, 4) = SWAP32(map_ipaddress);
	WFIFOW(sd->fd, 8) = SWAP16(2001);
	WFIFOB(sd->fd, 10) = 0x16;
	WFIFOW(sd->fd, 11) = SWAP16(9);

	strcpy(WFIFOP(sd->fd, 13), "KruIn7inc");
	len = 11;
	WFIFOB(sd->fd, len + 11) = strlen("Peter");
	strcpy(WFIFOP(sd->fd, len + 12), "Peter");
	len += strlen("Peter") + 1;
	len += 4;

	WFIFOB(sd->fd, 10) = len;
	WFIFOW(sd->fd, 1) = SWAP16(len + 8);
	//set_packet_indexes(WFIFOP(sd->fd, 0));
	WFIFOSET(sd->fd, len + 11);// + 3);

	return 0;
}

int clif_sendBoardQuestionaire(USER* sd, struct board_questionaire* q, int count) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}
	//Player(2):sendBoardQuestions("Defendant :","Name of Person who commited the crime.",2,"When :","When was the crime commited?",1)

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x31;
	WFIFOB(sd->fd, 5) = 0x09;
	WFIFOB(sd->fd, 6) = count;
	int len = 7;
	for (int i = 0; i < count; i++) {
		WFIFOB(sd->fd, len) = strlen(q[i].header);
		len += 1;
		strcpy(WFIFOP(sd->fd, len), q[i].header);
		len += strlen(q[i].header);
		WFIFOB(sd->fd, len) = 1;
		WFIFOB(sd->fd, len + 1) = 2;
		len += 2;
		WFIFOB(sd->fd, len) = q[i].inputLines;
		len += 1;
		WFIFOB(sd->fd, len) = strlen(q[i].question);
		len += 1;
		strcpy(WFIFOP(sd->fd, len), q[i].question);
		len += strlen(q[i].question);
		WFIFOB(sd->fd, len) = 1;
		len += 1;
	}

	WFIFOB(sd->fd, len) = 0;
	WFIFOB(sd->fd, len + 1) = 0x6B;
	len += 2;

	WFIFOW(sd->fd, 1) = SWAP16(len + 3);

	/*printf("packet\n");
	for (int i = 0; i<len;i++) {
	printf("%i.      %c         %i          %02X\n",i,WFIFOB(sd->fd,i),WFIFOB(sd->fd,i),WFIFOB(sd->fd,i));
	}
	printf("\n");*/

	WFIFOSET(sd->fd, encrypt(sd->fd));
}

int clif_closeit(USER* sd) {
	int len = 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	/*WFIFOHEAD(sd->fd,255);
	WFIFOB(sd->fd,0)=0xAA;
	WFIFOB(sd->fd,3)=0x03;
	WFIFOL(sd->fd,4)=SWAP32(log_ip);
	WFIFOW(sd->fd,8)=SWAP16(log_port);
	//len=strlen(sd->status.name);
	WFIFOW(sd->fd,11)=SWAP16(9);
	strcpy(WFIFOP(sd->fd,13),"KruIn7inc");
	len=11;
	WFIFOB(sd->fd,len+11)=strlen(sd->status.name);
	strcpy(WFIFOP(sd->fd,len+12),sd->status.name);
	len+=strlen(sd->status.name)+1;
	WFIFOL(sd->fd,len+11)=SWAP32(sd->status.id);
	len+=4;
	WFIFOB(sd->fd,10)=len;
	WFIFOW(sd->fd,1)=SWAP16(len+8);
	//set_packet_indexes(WFIFOP(sd->fd, 0));
	WFIFOSET(sd->fd,len+11);// + 3);
	return 0;*/

	WFIFOHEAD(sd->fd, 255);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x03;
	WFIFOL(sd->fd, 4) = SWAP32(log_ip);
	WFIFOW(sd->fd, 8) = SWAP16(log_port);
	WFIFOB(sd->fd, 10) = 0x16;
	WFIFOW(sd->fd, 11) = SWAP16(9);
	strcpy(WFIFOP(sd->fd, 13), "KruIn7inc");
	len = 11;
	WFIFOB(sd->fd, len + 11) = strlen(sd->status.name);
	strcpy(WFIFOP(sd->fd, len + 12), sd->status.name);
	len += strlen(sd->status.name) + 1;
	//WFIFOL(sd->fd,len+11)=SWAP32(sd->status.id);
	len += 4;
	WFIFOB(sd->fd, 10) = len;
	WFIFOW(sd->fd, 1) = SWAP16(len + 8);
	//set_packet_indexes(WFIFOP(sd->fd, 0));
	WFIFOSET(sd->fd, len + 11);// + 3);
	return 0;
}

int addtokillreg(USER* sd, int mob) {
	for (int x = 0; x < MAX_KILLREG; x++) {
		if (sd->status.killreg[x].mob_id == mob) {
			sd->status.killreg[x].amount++;
			return 0;
		}
	}

	for (int x = 0; x < MAX_KILLREG; x++) {
		if (sd->status.killreg[x].mob_id == 0) {
			sd->status.killreg[x].mob_id = mob;
			sd->status.killreg[x].amount = 1;
			return 0;
		}
	}

	return 0;
}

int clif_addtokillreg(USER* sd, int mob) {
	USER* tsd = NULL;
	int x;
	nullpo_ret(0, sd);
	for (x = 0; x < sd->group_count; x++) {
		tsd = map_id2sd(groups[sd->groupid][x]);
		if (!tsd)
			continue;

		if (tsd->bl.m == sd->bl.m) {
			addtokillreg(tsd, mob);
		}
	}
	return 0;
}

/*int clif_sendguidelist(USER *sd) {
	int count=0;
	int x;
	int len=0;

	for(x=0;x<256;x++) {
		if(sd->status.guide[x]) {
		if (!session[sd->fd])
		{
			session[sd->fd]->eof = 8;
			return 0;
		}

		WFIFOHEAD(sd->fd,10);
		WFIFOB(sd->fd,0)=0xAA;
		WFIFOW(sd->fd,1)=SWAP16(0x07);
		WFIFOB(sd->fd,3)=0x12;
		WFIFOB(sd->fd,4)=0x03;
		WFIFOB(sd->fd,5)=0x00;
		WFIFOB(sd->fd,6)=0x02;
		WFIFOW(sd->fd,7)=sd->status.guide[x];
		WFIFOB(sd->fd,9)=0;
		WFIFOSET(sd->fd,encrypt(sd->fd));
		}
	}
	return 0;
}*/

int clif_sendheartbeat(int id, int none) {
	USER* sd = map_id2sd((unsigned int)id);
	nullpo_ret(1, sd);

	if (!session[sd->fd]) {
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 7);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(0x07);
	WFIFOB(sd->fd, 3) = 0x3B;

	WFIFOB(sd->fd, 5) = 0x5F;
	WFIFOB(sd->fd, 6) = 0x0A;  //0x00;
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int pc_sendpong(int id, int none) {
	//return 0;
	USER* sd = map_id2sd((unsigned int)id);
	nullpo_ret(1, sd);

	//if (DIFF_TICK(gettick(), sd->LastPongStamp) >= 300000) session[sd->fd]->eof = 12;

	if (sd) {
		if (!session[sd->fd])
		{
			session[sd->fd]->eof = 8;
			return 0;
		}

		WFIFOHEAD(sd->fd, 10);
		WFIFOB(sd->fd, 0) = 0xAA;
		WFIFOW(sd->fd, 1) = SWAP16(0x09);
		WFIFOB(sd->fd, 3) = 0x68;
		WFIFOL(sd->fd, 5) = SWAP32(gettick());
		WFIFOB(sd->fd, 9) = 0x00;

		WFIFOSET(sd->fd, encrypt(sd->fd));

		sd->LastPingTick = gettick(); //For measuring their arrival of response
	}

	return 0;
}

int clif_sendguidespecific(USER* sd, int guide) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 10);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(0x07);
	WFIFOB(sd->fd, 3) = 0x12;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0x00;
	WFIFOB(sd->fd, 6) = 0x02;
	WFIFOW(sd->fd, 7) = guide;
	WFIFOB(sd->fd, 8) = 0;
	WFIFOB(sd->fd, 9) = 1;
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_broadcast_sub(struct block_list* bl, va_list ap) {
	USER* sd = NULL;
	char* msg = NULL;
	//char buf[256];
	int len = 0;

	nullpo_ret(0, sd = (USER*)bl);
	msg = va_arg(ap, char*);
	len = strlen(msg);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	int flag = sd->status.settingFlags & FLAG_SHOUT;
	if (flag == 0)  return 0;

	WFIFOHEAD(sd->fd, len + 8);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x0A;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0x05; //this  is a broadcast
	WFIFOW(sd->fd, 6) = SWAP16(len);
	strcpy(WFIFOP(sd->fd, 8), msg);
	WFIFOW(sd->fd, 1) = SWAP16(len + 5);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	//Log_Add("broadcast","<%02d:%02d> %s to World -> %s\n",getHour(),getMinute(),sd->status.name,msg);

	return 0;
}
int clif_gmbroadcast_sub(struct block_list* bl, va_list ap) {
	USER* sd = NULL;
	char* msg = NULL;
	//char buf[256];
	int len = 0;

	nullpo_ret(0, sd = (USER*)bl);
	msg = va_arg(ap, char*);
	len = strlen(msg);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, len + 8);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x0A;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0x05; //this  is a broadcast
	WFIFOW(sd->fd, 6) = SWAP16(len);
	strcpy(WFIFOP(sd->fd, 8), msg);
	WFIFOW(sd->fd, 1) = SWAP16(len + 5);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	//Log_Add("broadcast","<%02d:%02d> %s to World -> %s\n",getHour(),getMinute(),sd->status.name,msg);

	return 0;
}

int clif_broadcasttogm_sub(struct block_list* bl, va_list ap) {
	USER* sd = NULL;
	char* msg = NULL;
	//char buf[256];
	int len = 0;

	nullpo_ret(0, sd = (USER*)bl);
	if (sd->status.gm_level)
	{
		msg = va_arg(ap, char*);
		len = strlen(msg);

		if (!session[sd->fd])
		{
			session[sd->fd]->eof = 8;
			return 0;
		}

		WFIFOHEAD(sd->fd, len + 8);
		WFIFOB(sd->fd, 0) = 0xAA;
		WFIFOB(sd->fd, 3) = 0x0A;
		WFIFOB(sd->fd, 4) = 0x03;
		WFIFOB(sd->fd, 5) = 0x05; //this  is a broadcast
		WFIFOW(sd->fd, 6) = SWAP16(len);
		strcpy(WFIFOP(sd->fd, 8), msg);
		WFIFOW(sd->fd, 1) = SWAP16(len + 5);
		WFIFOSET(sd->fd, encrypt(sd->fd));

		//Log_Add("GMbroadcast","<%02d:%02d> %s to World -> %s\n",getHour(),getMinute(),sd->status.name,msg);
	}
	return 0;
}

int clif_broadcast(char* msg, int m) {
	if (m == -1) {
		for (int x = 0; x < 65535; x++) {
			if (map_isloaded(x)) {
				map_foreachinarea(clif_broadcast_sub, x, 1, 1, SAMEMAP, BL_PC, msg);
			}
		}
	}
	else {
		map_foreachinarea(clif_broadcast_sub, m, 1, 1, SAMEMAP, BL_PC, msg);
	}

	return 0;
}

int clif_gmbroadcast(char* msg, int m) {
	if (m == -1) {
		for (int x = 0; x < 65535; x++) {
			if (map_isloaded(x)) {
				map_foreachinarea(clif_gmbroadcast_sub, x, 1, 1, SAMEMAP, BL_PC, msg);
			}
		}
	}
	else {
		map_foreachinarea(clif_gmbroadcast_sub, m, 1, 1, SAMEMAP, BL_PC, msg);
	}
	return 0;
}

int clif_broadcasttogm(char* msg, int m) {
	if (m == -1) {
		for (int x = 0; x < 65535; x++) {
			if (map_isloaded(x)) {
				map_foreachinarea(clif_broadcasttogm_sub, x, 1, 1, SAMEMAP, BL_PC, msg);
			}
		}
	}
	else {
		map_foreachinarea(clif_broadcasttogm_sub, m, 1, 1, SAMEMAP, BL_PC, msg);
	}
	return 0;
}

int clif_getequiptype(int val) {
	int type = 0;

	switch (val) {
	case EQ_WEAP:
		type = 1;
		break;
	case EQ_ARMOR:
		type = 2;
		break;
	case EQ_SHIELD:
		type = 3;
		break;
	case EQ_HELM:
		type = 4;
		break;
	case EQ_NECKLACE:
		type = 6;
		break;
	case EQ_LEFT:
		type = 7;
		break;
	case EQ_RIGHT:
		type = 8;
		break;
	case EQ_BOOTS:
		type = 13;
		break;
	case EQ_MANTLE:
		type = 14;
		break;
	case EQ_COAT:
		type = 16;
		break;
	case EQ_SUBLEFT:
		type = 20;
		break;
	case EQ_SUBRIGHT:
		type = 21;
		break;
	case EQ_FACEACC:
		type = 22;
		break;
	case EQ_CROWN:
		type = 23;
		break;

	default:
		return 0;
		break;
	}

	return type;
}

static short crctable[256] = {
	  0x0000,0x1021,0x2042,0x3063,0x4084,0x50A5,0x60C6,0x70E7,0x8108,0x9129,0xA14A,
	  0xB16B,0xC18C,0xD1AD,0xE1CE,0xF1EF,0x1231,0x0210,0x3273,0x2252,0x52B5,0x4294,
	  0x72F7,0x62D6,0x9339,0x8318,0xB37B,0xA35A,0xD3BD,0xC39C,0xF3FF,0xE3DE,0x2462,
	  0x3443,0x0420,0x1401,0x64E6,0x74C7,0x44A4,0x5485,0xA56A,0xB54B,0x8528,0x9509,
	  0xE5EE,0xF5CF,0xC5AC,0xD58D,0x3653,0x2672,0x1611,0x0630,0x76D7,0x66F6,0x5695,
	  0x46B4,0xB75B,0xA77A,0x9719,0x8738,0xF7DF,0xE7FE,0xD79D,0xC7BC,0x48C4,0x58E5,
	  0x6886,0x78A7,0x0840,0x1861,0x2802,0x3823,0xC9CC,0xD9ED,0xE98E,0xF9AF,0x8948,
	  0x9969,0xA90A,0xB92B,0x5AF5,0x4AD4,0x7AB7,0x6A96,0x1A71,0x0A50,0x3A33,0x2A12,
	  0xDBFD,0xCBDC,0xFBBF,0xEB9E,0x9B79,0x8B58,0xBB3B,0xAB1A,0x6CA6,0x7C87,0x4CE4,
	  0x5CC5,0x2C22,0x3C03,0x0C60,0x1C41,0xEDAE,0xFD8F,0xCDEC,0xDDCD,0xAD2A,0xBD0B,
	  0x8D68,0x9D49,0x7E97,0x6EB6,0x5ED5,0x4EF4,0x3E13,0x2E32,0x1E51,0x0E70,0xFF9F,
	  0xEFBE,0xDFDD,0xCFFC,0xBF1B,0xAF3A,0x9F59,0x8F78,0x9188,0x81A9,0xB1CA,0xA1EB,
	  0xD10C,0xC12D,0xF14E,0xE16F,0x1080,0x00A1,0x30C2,0x20E3,0x5004,0x4025,0x7046,
	  0x6067,0x83B9,0x9398,0xA3FB,0xB3DA,0xC33D,0xD31C,0xE37F,0xF35E,0x02B1,0x1290,
	  0x22F3,0x32D2,0x4235,0x5214,0x6277,0x7256,0xB5EA,0xA5CB,0x95A8,0x8589,0xF56E,
	  0xE54F,0xD52C,0xC50D,0x34E2,0x24C3,0x14A0,0x0481,0x7466,0x6447,0x5424,0x4405,
	  0xA7DB,0xB7FA,0x8799,0x97B8,0xE75F,0xF77E,0xC71D,0xD73C,0x26D3,0x36F2,0x0691,
	  0x16B0,0x6657,0x7676,0x4615,0x5634,0xD94C,0xC96D,0xF90E,0xE92F,0x99C8,0x89E9,
	  0xB98A,0xA9AB,0x5844,0x4865,0x7806,0x6827,0x18C0,0x08E1,0x3882,0x28A3,0xCB7D,
	  0xDB5C,0xEB3F,0xFB1E,0x8BF9,0x9BD8,0xABBB,0xBB9A,0x4A75,0x5A54,0x6A37,0x7A16,
	  0x0AF1,0x1AD0,0x2AB3,0x3A92,0xFD2E,0xED0F,0xDD6C,0xCD4D,0xBDAA,0xAD8B,0x9DE8,
	  0x8DC9,0x7C26,0x6C07,0x5C64,0x4C45,0x3CA2,0x2C83,0x1CE0,0x0CC1,0xEF1F,0xFF3E,
	  0xCF5D,0xDF7C,0xAF9B,0xBFBA,0x8FD9,0x9FF8,0x6E17,0x7E36,0x4E55,0x5E74,0x2E93,
	  0x3EB2,0x0ED1,0x1EF0
};

short nexCRCC(short* buf, int len)
{
	unsigned short crc, temp;

	crc = 0;
	while (len != 0)
	{
		crc = (crctable[crc >> 8] ^ (crc << 8)) ^ buf[0];
		temp = crctable[crc >> 8] ^ buf[1];
		crc = ((temp << 8) ^ crctable[(crc & 0xFF) ^ (temp >> 8)]) ^ buf[2];
		buf += 3;
		len -= 6;
	}
	return(crc);
}

int clif_debug(unsigned char* stringthing, int len) {
	int i;

	for (i = 0; i < len; i++) {
		printf("%02X ", stringthing[i]);
	}

	printf("\n");

	for (i = 0; i < len; i++) {
		if (stringthing[i] <= 32 || stringthing[i] > 126) {
			printf("   ");
		}
		else {
			printf("%02c ", stringthing[i]);
		}
	}

	printf("\n");
	return 0;
}

int clif_sendtowns(USER* sd) {
	char buf[256];
	int x;
	int len = 0;
	//x=sprintf(buf,"\xAA\x00\x07\x68\x59\xB5\x07\x3D\x7E\x37\xAA\x00\x29\x59\x5A\x54\x3F\x22\x17\x30\x13\x33\x77\x11\x60\x4A\x51\x55\x59\x13\x32\x73\x1A\x71\x48\x52\x4E\x59\x13\x32\x79\x03\x6E\x5D\x22\x31\x79\x71\x50\x54\x16\x7E\x5C\x26\xAA\x00\x0B\x75\x0B\xE7\x55\x6F\x2C\x66\xB1\xB6\xB1\x25");

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 0x59);
	WFIFOB(sd->fd, 0) = 0xAA;
	//WFIFOW(sd->fd,1)=SWAP16(0x13);
	WFIFOB(sd->fd, 3) = 0x59;
	//WFIFOB(sd->fd,4)=0x03;
	WFIFOB(sd->fd, 5) = 64;
	WFIFOW(sd->fd, 6) = 0;
	WFIFOB(sd->fd, 8) = 34;
	WFIFOB(sd->fd, 9) = town_n; //Town count
	for (x = 0; x < town_n; x++) {
		WFIFOB(sd->fd, len + 10) = x;
		WFIFOB(sd->fd, len + 11) = strlen(towns[x].name);
		strcpy(WFIFOP(sd->fd, len + 12), towns[x].name);
		len += strlen(towns[x].name) + 2;
	}

	WFIFOW(sd->fd, 1) = SWAP16(len + 9);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_user_list(USER* sd) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(char_fd, 4);
	WFIFOW(char_fd, 0) = 0x300B;
	WFIFOW(char_fd, 2) = sd->fd;
	WFIFOSET(char_fd, 4);

	return 0;
}

int clif_pc_damage(USER* sd, USER* src) {
	USER* tsd = NULL;
	int damage;
	int x;

	nullpo_ret(0, sd);
	nullpo_ret(0, src);

	if (src->status.state == 1) return 0;

	sl_doscript_blargs("hitCritChance", NULL, 2, &sd->bl, &src->bl);

	if (sd->critchance > 0) {
		sl_doscript_blargs("swingDamage", NULL, 2, &sd->bl, &src->bl);
		damage = (int)(sd->damage += 0.5f);

		if (sd->status.equip[EQ_WEAP].id > 0) {
			clif_playsound(&src->bl, itemdb_soundhit(sd->status.equip[EQ_WEAP].id));
		}

		for (x = 0; x < 14; x++) {
			if (sd->status.equip[x].id > 0) {
				sl_doscript_blargs(itemdb_yname(sd->status.equip[x].id), "on_hit", 2, &sd->bl, &src->bl);
			}
		}

		for (x = 0; x < MAX_SPELLS; x++) {
			if (sd->status.skill[x] > 0) {
				sl_doscript_blargs(magicdb_yname(sd->status.skill[x]), "passive_on_hit", 2, &sd->bl, &src->bl);
			}
		}

		for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
			if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].duration > 0) {
				tsd = map_id2sd(sd->status.dura_aether[x].caster_id);

				if (tsd) {
					sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "on_hit_while_cast", 3, &sd->bl, &src->bl, &tsd->bl);
				}
				else {
					sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "on_hit_while_cast", 2, &sd->bl, &src->bl);
				}
			}
		}

		if (sd->critchance == 1) {
			clif_send_pc_health(src, damage, 33);
		}
		else if (sd->critchance == 2) {
			clif_send_pc_health(src, damage, 255);
		}

		clif_sendstatus(src, SFLAG_HPMP);
	}

	return 0;
}

int clif_send_pc_health(USER* src, int damage, int critical) {
	struct block_list* bl = map_id2bl(src->attacker);

	if (bl == NULL) {
		bl = map_id2bl(src->bl.id);
	}

	sl_doscript_blargs("player_combat", "on_attacked", 2, &src->bl, bl);
	return 0;
}

void clif_delay(int milliseconds) {
	clock_t start_time = clock();

	while (clock() < start_time + milliseconds);
}

int clif_send_pc_healthscript(USER* sd, int damage, int critical) {
	unsigned int maxvita;
	unsigned int currentvita;
	float percentage;
	char buf[32];
	int x;
	USER* tsd = NULL;
	MOB* tmob = NULL;
	struct block_list* bl = map_id2bl(sd->attacker);

	nullpo_ret(0, sd);
	maxvita = sd->max_hp;
	currentvita = sd->status.hp;

	if (bl) {
		if (bl->type == BL_MOB) {
			tmob = (MOB*)bl;
			if (tmob->owner < MOB_START_NUM && tmob->owner > 0) {
				tsd = map_id2sd(tmob->owner);
			}
		}
		else if (bl->type == BL_PC) {
			tsd = (USER*)bl;
		}
	}

	if (damage > 0) {
		for (x = 0; x < MAX_SPELLS; x++) {
			if (sd->status.skill[x] > 0) {
				sl_doscript_blargs(magicdb_yname(sd->status.skill[x]), "passive_on_takingdamage", 2, &sd->bl, bl);
			}
		}
	}

	if (damage < 0) {
		sd->lastvita = currentvita;
		currentvita -= damage;
	}
	else {
		if (currentvita < damage) {
			sd->lastvita = currentvita;
			currentvita = 0;
		}
		else {
			sd->lastvita = currentvita;
			currentvita -= damage;
		}
	}

	if (currentvita > maxvita) {
		currentvita = maxvita;
	}

	sd->status.hp = currentvita;

	if (currentvita == 0) {
		percentage = 0;
	}
	else {
		percentage = (float)currentvita / (float)maxvita;
		percentage = (float)percentage * 100;
	}

	if (((int)percentage) == 0 && currentvita != 0) percentage = (float)1;
	//8 hit types * 32 colors
	WBUFB(buf, 0) = 0xAA;
	WBUFW(buf, 1) = SWAP16(12);
	WBUFB(buf, 3) = 0x13;
	//WBUFB(buf,4)=0x03;
	WBUFL(buf, 5) = SWAP32(sd->bl.id);
	WBUFB(buf, 9) = critical;
	WBUFB(buf, 10) = (int)percentage;
	WBUFL(buf, 11) = SWAP32((unsigned int)damage);

	//clif_send(buf,32,&sd->bl,AREA);
	if (sd->status.state == 2)	clif_send(buf, 32, &sd->bl, SELF);
	else 	clif_send(buf, 32, &sd->bl, AREA);

	if (sd->status.hp && damage > 0) {
		for (x = 0; x < MAX_SPELLS; x++) {
			if (sd->status.skill[x] > 0) {
				sl_doscript_blargs(magicdb_yname(sd->status.skill[x]), "passive_on_takedamage", 2, &sd->bl, bl);
			}
		}
		for (x = 0; x < MAX_MAGIC_TIMERS; x++) { //Spell stuff
			if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].duration > 0) {
				sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "on_takedamage_while_cast", 2, &sd->bl, bl);
			}
		}
		for (x = 0; x < 14; x++) { //Equipment stuff
			if (sd->status.equip[x].id > 0) {
				sl_doscript_blargs(itemdb_yname(sd->status.equip[x].id), "on_takedamage", 2, &sd->bl, bl);
			}
		}
	}

	/*if (!sd->status.hp) {
		for (x = 0; x < MAX_SPELLS; x++) {
			if (sd->status.skill[x] > 0) {
				sl_doscript_blargs(magicdb_yname(sd->status.skill[x]), "passive_before_death", 2, &sd->bl, bl);
			}
		}

		for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
			if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].duration > 0) {
				sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "before_death_while_cast", 2, &sd->bl, bl);
			}
		}
	}*/

	if (!sd->status.hp) {
		sl_doscript_blargs("onDeathPlayer", NULL, 1, &sd->bl);

		if (tsd != NULL) sl_doscript_blargs("onKill", NULL, 2, &sd->bl, &tsd->bl);

		/*for(x=0;x<14;x++) {
			if(sd->status.equip[x].id > 0) {
				sl_doscript_blargs(itemdb_yname(sd->status.equip[x].id),"on_death",1,&sd->bl);
				}
		}

		for(x=0;x<sd->status.maxinv;x++) {
			if(sd->status.inventory[x].id > 0) {
				sl_doscript_blargs(itemdb_yname(sd->status.inventory[x].id),"on_death",1,&sd->bl);
				}
		}

		if (tmob != NULL) {
			for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
				if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].duration > 0) {
					sl_doscript_blargs(magicdb_yname(tmob->da[x].id), "on_kill_while_cast", 2, &tmob->bl, &sd->bl);
				}
			}
		}

		if(tsd != NULL) {
			sl_doscript_blargs("onKill", NULL, 2, &sd->bl, &tsd->bl);

			if (tmob == NULL) {
				for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
					if (tsd->status.dura_aether[x].id > 0 && tsd->status.dura_aether[x].duration > 0) {
						sl_doscript_blargs(magicdb_yname(tsd->status.dura_aether[x].id), "on_kill_while_cast", 2, &tsd->bl, &sd->bl);
					}
				}

				for (x = 0; x < MAX_SPELLS; x++) {
					if (tsd->status.skill[x] > 0) {
						sl_doscript_blargs(magicdb_yname(tsd->status.skill[x]), "passive_on_kill", 2, &tsd->bl, &sd->bl);
					}
				}
			}
		}*/
	}

	if (sd->group_count > 0) {
		clif_grouphealth_update(sd);
	}

	return 0;
}

void clif_send_selfbar(USER* sd) {
	float percentage;

	if (sd->status.hp == 0) {
		percentage = 0;
	}
	else {
		percentage = (float)sd->status.hp / (float)sd->max_hp;
		percentage = (float)percentage * 100;
	}

	if ((int)percentage == 0 && sd->status.hp != 0) percentage = (float)1;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 15);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(12);
	WFIFOB(sd->fd, 3) = 0x13;
	WFIFOL(sd->fd, 5) = SWAP32(sd->bl.id);
	WFIFOB(sd->fd, 9) = 0;
	WFIFOB(sd->fd, 10) = (int)percentage;
	WFIFOL(sd->fd, 11) = SWAP32(0);
	WFIFOSET(sd->fd, encrypt(sd->fd));
}

void clif_send_groupbars(USER* sd, USER* tsd) {
	float percentage;

	nullpo_ret(0, sd);
	nullpo_ret(0, tsd);

	if (tsd->status.hp == 0) {
		percentage = 0;
	}
	else {
		percentage = (float)tsd->status.hp / (float)tsd->max_hp;
		percentage = (float)percentage * 100;
	}

	if ((int)percentage == 0 && tsd->status.hp != 0) percentage = (float)1;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 15);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(12);
	WFIFOB(sd->fd, 3) = 0x13;
	WFIFOL(sd->fd, 5) = SWAP32(tsd->bl.id);
	WFIFOB(sd->fd, 9) = 0;
	WFIFOB(sd->fd, 10) = (int)percentage;
	WFIFOL(sd->fd, 11) = SWAP32(0);
	WFIFOSET(sd->fd, encrypt(sd->fd));
}

void clif_send_mobbars(struct block_list* bl, va_list ap) {
	USER* sd = NULL;
	MOB* mob = NULL;
	float percentage;

	nullpo_ret(0, sd = va_arg(ap, USER*));
	nullpo_ret(0, mob = (MOB*)bl);

	if (mob->current_vita == 0) {
		percentage = 0;
	}
	else {
		percentage = (float)mob->current_vita / (float)mob->maxvita;
		percentage = (float)percentage * 100;
	}

	if ((int)percentage == 0 && mob->current_vita != 0) percentage = (float)1;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 15);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(12);
	WFIFOB(sd->fd, 3) = 0x13;
	WFIFOL(sd->fd, 5) = SWAP32(mob->bl.id);
	WFIFOB(sd->fd, 9) = 0;
	WFIFOB(sd->fd, 10) = (int)percentage;
	WFIFOL(sd->fd, 11) = SWAP32(0);
	WFIFOSET(sd->fd, encrypt(sd->fd));
}

int clif_findspell_pos(USER* sd, int id) {
	int x;
	for (x = 0; x < 52; x++) {
		if (sd->status.skill[x] == id) {
			return x;
		}
	}

	return -1;
}

int clif_calc_critical(USER* sd, struct block_list* bl) {
	int chance;
	int equat = 0;
	MOB* mob = NULL;
	USER* tsd = NULL;
	int crit = 0;
	int max_hit = 95;
	int dx, dy;

	if (bl->type == BL_PC) {
		tsd = (USER*)bl;
		//equat=sd->hit*2+(sd->grace/2)+(sd->status.level/2);
		//equat=equat-((tsd->grace/4)+(sd->status.level));
		equat = (55 + (sd->grace / 2)) - (tsd->grace / 2) + (sd->hit * 1.5) + (sd->status.level - tsd->status.level);
		//equat=(sd->hit*5+80+(sd->grace/3))-(tsd->grace);
		//equat=(sd->hit + sd->status.level + (sd->might/2) + 40) - (sd->status.level + (sd->grace/2));
	}
	else if (bl->type == BL_MOB) {
		mob = (MOB*)bl;
		//equat=sd->hit*2+(sd->grace/2)+(sd->status.level/2);
		//equat=equat-(mob->data->grace/4)-mobdb_level(mob->id);
		equat = (55 + (sd->grace / 2)) - (mob->data->grace / 2) + (sd->hit * 1.5) + (sd->status.level - mob->data->level);
		//equat=(sd->hit + sd->status.level + (sd->might/2) + 40) - (mobdb_level(mob->id) + (mob->data->grace/2));
	}
	if (equat < 5) equat = 5;
	if (equat > max_hit) equat = max_hit;

	chance = rnd(100);
	if (chance < (equat)) {
		crit = sd->hit / 3;
		if (crit < 1) crit = 1;
		if (crit >= 100) crit = 99;
		if (chance < crit) {
			return 2;
		}
		else {
			return 1;
		}
	}
	return 0;
}
int clif_has_aethers(USER* sd, int spell) {
	int x;

	for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
		if (sd->status.dura_aether[x].id == spell) {
			return sd->status.dura_aether[x].aether;
		}
	}

	return 0;
}

int clif_mob_look_start_func(struct block_list* bl, va_list ap) {
	USER* sd = NULL;

	nullpo_ret(0, sd = (USER*)bl);
	sd->mob_len = 0;
	sd->mob_count = 0;
	sd->mob_item = 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	//WFIFOB(sd->fd,0)=0xAA;
	//WFIFOB(sd->fd,3)=0x07;
	//WFIFOB(sd->fd,4)=0x03;
	return 0;
}

int clif_mob_look_close_func(struct block_list* bl, va_list ap) {
	USER* sd = NULL;

	nullpo_ret(0, sd = (USER*)bl);

	if (!sd->mob_count) return 0;
	/*if(sd->mob_count%2==1) {
		sd->mob_len++;
		WFIFOB(sd->fd,sd->mob_len+6)=0;
	}*/
	if (!sd->mob_item) {
		WFIFOB(sd->fd, sd->mob_len + 7) = 0;
		sd->mob_len++;
	}
	//WFIFOW(sd->fd,1)=SWAP16((sd->mob_len)+4);
	WFIFOHEADER(sd->fd, 0x07, sd->mob_len + 4);
	WFIFOW(sd->fd, 5) = SWAP16(sd->mob_count);
	//WFIFOB(sd->fd,(sd->mob_len*13)+7)=0;
	WFIFOSET(sd->fd, encrypt(sd->fd));
	//printf("Mob len: %d\n",sd->mob_len);
	sd->mob_len = 0;
	sd->mob_count = 0;

	return 0;
}

int clif_object_look_sub(struct block_list* bl, va_list ap) {
	//set up our types
	USER* sd = NULL;
	MOB* mob = NULL;
	NPC* nd = NULL;
	FLOORITEM* item = NULL;
	struct block_list* b = NULL;
	int type;
	int x;
	int nlen = 0;
	int animlen = 0;
	//struct npc_data *npc=NULL;
	int len = 0;
	//end setup
	type = va_arg(ap, int);
	if (type == LOOK_SEND) {
		nullpo_ret(0, sd = (USER*)bl);
		nullpo_ret(0, b = va_arg(ap, struct block_list*));
	}
	else {
		nullpo_ret(0, sd = va_arg(ap, USER*));
		nullpo_ret(0, b = bl);
	}

	if (b->type == BL_PC) return 0;
	//len+11 = type
	len = sd->mob_len;
	WFIFOW(sd->fd, len + 7) = SWAP16(b->x);
	WFIFOW(sd->fd, len + 9) = SWAP16(b->y);
	WFIFOL(sd->fd, len + 12) = SWAP32(b->id);

	switch (b->type) {
	case BL_MOB:
		mob = (MOB*)b;

		if (mob->state == MOB_DEAD || mob->data->mobtype == 1) return 0;

		nlen = 0;
		animlen = 0;

		if (mob->data->isnpc == 0) {
			WFIFOB(sd->fd, len + 11) = 0x05;
			WFIFOW(sd->fd, len + 16) = SWAP16(32768 + mob->look);
			WFIFOB(sd->fd, len + 18) = mob->look_color;
			WFIFOB(sd->fd, len + 19) = mob->side;
			WFIFOB(sd->fd, len + 20) = 0;
			WFIFOB(sd->fd, len + 21) = 0; //# of animations active
			for (x = 0; x < 50; x++) {
				if (mob->da[x].duration && mob->da[x].animation) {
					WFIFOW(sd->fd, nlen + len + 22) = SWAP16(mob->da[x].animation);
					WFIFOW(sd->fd, nlen + len + 22 + 2) = SWAP16(mob->da[x].duration / 1000);
					animlen++;
					nlen += 4;
				}
			}

			WFIFOB(sd->fd, len + 21) = animlen;
			WFIFOB(sd->fd, len + 22 + nlen) = 0; //pass flag
			sd->mob_len += 15 + nlen;
		}
		else if (mob->data->isnpc == 1) {
			WFIFOB(sd->fd, len + 11) = 12;
			WFIFOW(sd->fd, len + 16) = SWAP16(32768 + mob->look);
			WFIFOB(sd->fd, len + 18) = mob->look_color;
			WFIFOB(sd->fd, len + 19) = mob->side;
			WFIFOW(sd->fd, len + 20) = 0;
			WFIFOB(sd->fd, len + 22) = 0;
			sd->mob_len += 15;
		}

		break;
	case BL_NPC:
		nd = (NPC*)b;

		if (b->subtype || nd->bl.subtype || nd->npctype == 1) return 0;

		WFIFOB(sd->fd, len + 11) = 12;
		WFIFOW(sd->fd, len + 16) = SWAP16(32768 + b->graphic_id);
		WFIFOB(sd->fd, len + 18) = b->graphic_color;
		WFIFOB(sd->fd, len + 19) = nd->side;//Looking down
		WFIFOW(sd->fd, len + 20) = 0;
		WFIFOB(sd->fd, len + 22) = 0;
		//WFIFOB(sd->fd,len+22)=0;
		sd->mob_len += 15;
		break;
	case BL_ITEM:
		item = (FLOORITEM*)b;

		int inTable = 0;

		for (int j = 0; j < sizeof(item->data.trapsTable); j++) {
			if (item->data.trapsTable[j] == sd->status.id) inTable = 1;
		}

		//printf("func 1...  name: %s, inTable: %i\n",sd->status.name,inTable);

		if (itemdb_type(item->data.id) == ITM_TRAPS && !inTable) {
			return 0;
		}

		WFIFOB(sd->fd, len + 11) = 0x02;

		if (item->data.customIcon != 0) {
			WFIFOW(sd->fd, len + 16) = SWAP16(item->data.customIcon + 49152);
			WFIFOB(sd->fd, len + 18) = item->data.customIconColor;
		}
		else {
			WFIFOW(sd->fd, len + 16) = SWAP16(itemdb_icon(item->data.id));
			WFIFOB(sd->fd, len + 18) = itemdb_iconcolor(item->data.id);
		}

		WFIFOB(sd->fd, len + 19) = 0;
		WFIFOW(sd->fd, len + 20) = 0;
		WFIFOB(sd->fd, len + 22) = 0;
		sd->mob_len += 15;
		sd->mob_item = 1;
		break;
	}
	sd->mob_count++;
	return 0;
}

int clif_object_look_sub2(struct block_list* bl, va_list ap) {
	//set up our types
	USER* sd = NULL;
	MOB* mob = NULL;
	NPC* nd = NULL;
	FLOORITEM* item = NULL;
	struct block_list* b = NULL;
	//struct npc_data *npc=NULL;
	int type = 0;
	int len = 0;
	int nlen = 0, x = 0;
	//end setup
	type = va_arg(ap, int);
	if (type == LOOK_SEND) {
		nullpo_ret(0, sd = (USER*)bl);
		nullpo_ret(0, b = va_arg(ap, struct block_list*));
	}
	else {
		nullpo_ret(0, sd = va_arg(ap, USER*));
		nullpo_ret(0, b = bl);
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 6000);

	if (b->type == BL_PC) return 0;

	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(20);
	WFIFOB(sd->fd, 3) = 0x07;
	//WFIFOB(sd->fd,4)=0x03;
	WFIFOW(sd->fd, 5) = SWAP16(1);
	WFIFOW(sd->fd, 7) = SWAP16(b->x);
	WFIFOW(sd->fd, 9) = SWAP16(b->y);
	WFIFOL(sd->fd, 12) = SWAP32(b->id);

	switch (b->type) {
	case BL_MOB:
		mob = (MOB*)b;

		if (mob->state == MOB_DEAD || mob->data->mobtype == 1) return 0;

		nlen = 0;

		if (mob->data->isnpc == 0) {
			WFIFOB(sd->fd, 11) = 0x05;
			WFIFOW(sd->fd, 16) = SWAP16(32768 + mob->look);
			WFIFOB(sd->fd, 18) = mob->look_color;
			WFIFOB(sd->fd, 19) = mob->side;
			WFIFOB(sd->fd, 20) = 0;
			WFIFOB(sd->fd, 21) = 0;
			for (x = 0; x < 50; x++) {
				if (mob->da[x].duration && mob->da[x].animation) {
					WFIFOW(sd->fd, nlen + 22) = SWAP16(mob->da[x].animation);
					WFIFOW(sd->fd, nlen + 22 + 2) = SWAP16(mob->da[x].duration / 1000);
					nlen += 4;
				}
			}

			WFIFOB(sd->fd, 21) = nlen / 4;
			WFIFOB(sd->fd, nlen + 22) = 0; //passflag
			//WFIFOB(sd->fd,22)=0;
		}
		else if (mob->data->isnpc == 1) {
			WFIFOB(sd->fd, len + 11) = 12;
			WFIFOW(sd->fd, len + 16) = SWAP16(32768 + mob->look);
			WFIFOB(sd->fd, len + 18) = mob->look_color;
			WFIFOB(sd->fd, len + 19) = mob->side;
			WFIFOW(sd->fd, len + 20) = 0;
			WFIFOB(sd->fd, len + 22) = 0;
		}

		break;
	case BL_NPC:
		nd = (NPC*)b;
		//npc=va_arg(ap,struct npc_data*);
		if (b->subtype || nd->bl.subtype || nd->npctype == 1) return 0;

		WFIFOB(sd->fd, 11) = 12;
		WFIFOW(sd->fd, 16) = SWAP16(32768 + b->graphic_id);
		WFIFOB(sd->fd, 18) = b->graphic_color;
		WFIFOB(sd->fd, 19) = nd->side;//Looking down
		WFIFOW(sd->fd, 20) = 0;
		WFIFOB(sd->fd, 22) = 0;
		break;
	case BL_ITEM:
		item = (FLOORITEM*)b;

		int inTable = 0;

		for (int j = 0; j < sizeof(item->data.trapsTable); j++) {
			if (item->data.trapsTable[j] == sd->status.id) inTable = 1;
		}

		//printf("func 2,   name: %s, inTable: %i\n",sd->status.name,inTable);

		if (itemdb_type(item->data.id) == ITM_TRAPS && !inTable) {
			return 0;
		}

		WFIFOB(sd->fd, 11) = 0x02;

		if (item->data.customIcon != 0)
		{
			WFIFOW(sd->fd, 16) = SWAP16(item->data.customIcon + 49152);
			WFIFOB(sd->fd, 18) = item->data.customIconColor;
		}

		else {
			WFIFOW(sd->fd, 16) = SWAP16(itemdb_icon(item->data.id));
			WFIFOB(sd->fd, 18) = itemdb_iconcolor(item->data.id);
		}

		WFIFOB(sd->fd, 19) = 0;
		WFIFOW(sd->fd, 20) = 0;
		WFIFOB(sd->fd, 22) = 0;
		break;
	}
	WFIFOW(sd->fd, 1) = SWAP16(20 + nlen);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	//sd->mob_count++;
	return 0;
}
int clif_object_look_specific(USER* sd, unsigned int id) {
	MOB* mob = NULL;
	FLOORITEM* item = NULL;
	NPC* nd = NULL;
	struct block_list* b = NULL;
	//struct npc_data *npc=NULL;
	int type = 0;
	int len = 0;
	//end setup
	if (!sd) return 0;

	nullpo_ret(0, b = map_id2bl(id));

	if (b->type == BL_PC) return 0;
	//len+11 = type
	//len=sd->mob_len;

	WFIFOHEADER(sd->fd, 0x07, 20);
	WFIFOW(sd->fd, 5) = SWAP16(1);
	WFIFOW(sd->fd, 7) = SWAP16(b->x);
	WFIFOW(sd->fd, 9) = SWAP16(b->y);
	WFIFOL(sd->fd, 12) = SWAP32(b->id);
	switch (b->type) {
	case BL_MOB:
		mob = (MOB*)b;

		if (mob->state == MOB_DEAD || mob->data->mobtype == 1) return 0;

		if (mob->data->isnpc == 0) {
			WFIFOB(sd->fd, 11) = 0x05;
			WFIFOW(sd->fd, 16) = SWAP16(32768 + mob->look);
			WFIFOB(sd->fd, 18) = mob->look_color;
			WFIFOB(sd->fd, 19) = mob->side;
			WFIFOW(sd->fd, 20) = 0;
			WFIFOB(sd->fd, 22) = 0;
		}
		else if (mob->data->isnpc == 1) {
			WFIFOB(sd->fd, len + 11) = 12;
			WFIFOW(sd->fd, len + 16) = SWAP16(32768 + mob->look);
			WFIFOB(sd->fd, len + 18) = mob->look_color;
			WFIFOB(sd->fd, len + 19) = mob->side;
			WFIFOW(sd->fd, len + 20) = 0;
			WFIFOB(sd->fd, len + 22) = 0;
			sd->mob_len += 15;
		}

		break;
	case BL_NPC:
		nd = (NPC*)b;
		if (b->subtype || nd->bl.subtype || nd->npctype == 1) return 0;

		WFIFOB(sd->fd, 11) = 12;
		WFIFOW(sd->fd, 16) = SWAP16(32768 + b->graphic_id);
		WFIFOB(sd->fd, 18) = b->graphic_color;
		WFIFOB(sd->fd, 19) = 2;//Looking down
		WFIFOW(sd->fd, 20) = 0;
		WFIFOB(sd->fd, 22) = 0;
		//WFIFOB(sd->fd,22)=0;
		//sd->mob_=16;

		break;
	case BL_ITEM:
		item = (FLOORITEM*)b;

		int inTable = 0;

		for (int j = 0; j < sizeof(item->data.trapsTable); j++) {
			if (item->data.trapsTable[j] == sd->status.id) inTable = 1;
		}

		//printf("func 3,     name: %s, inTable: %i\n",sd->status.name,inTable);

		if (itemdb_type(item->data.id) == ITM_TRAPS && !inTable) {
			return 0;
		}

		WFIFOB(sd->fd, 11) = 0x02;

		if (item->data.customIcon != 0) {
			WFIFOW(sd->fd, 16) = SWAP16(item->data.customIcon + 49152);
			WFIFOB(sd->fd, 18) = item->data.customIconColor;
		}
		else {
			WFIFOW(sd->fd, 16) = SWAP16(itemdb_icon(item->data.id));
			WFIFOB(sd->fd, 18) = itemdb_iconcolor(item->data.id);
		}

		WFIFOB(sd->fd, 19) = 0;
		WFIFOW(sd->fd, 20) = 0;
		WFIFOB(sd->fd, 22) = 0;
		WFIFOB(sd->fd, 2) = 0x13;
		WFIFOSET(sd->fd, encrypt(sd->fd));
		return 0;
		//sd->mob_=15;
		break;
	}

	WFIFOSET(sd->fd, encrypt(sd->fd));
	//sd->mob_count++;
	return 0;
}
int clif_mob_look_start(USER* sd) {
	sd->mob_count = 0;
	sd->mob_len = 0;
	sd->mob_item = 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	//WFIFOB(sd->fd,0)=0xAA;
	//WFIFOW(sd->fd,1)=SWAP16(18);
	//WFIFOB(sd->fd,3)=0x07; //send mob graphic
	//WFIFOB(sd->fd,4)=0x03; //incremental
	//WFIFOW(sd->fd,5)=SWAP16(1);

	return 0;
}
int clif_mob_look_close(USER* sd) {
	if (sd->mob_count) {
		//printf("Mob count: %d\n",count[0]);

		//if(sd->mob_count%2==1) {
		//	sd->mob_len++;
		//	WFIFOB(sd->fd,sd->mob_len+6)=0;
		//}
		if (!sd->mob_item) {
			WFIFOB(sd->fd, sd->mob_len + 7) = 0;
			sd->mob_len++;
		}
		//WFIFOW(sd->fd,1)=SWAP16(sd->mob_len+4);
		WFIFOHEADER(sd->fd, 0x07, sd->mob_len + 4);
		WFIFOW(sd->fd, 5) = SWAP16(sd->mob_count);
		//WFIFOB(sd->fd,count[1]+7)=0;
		//WFIFOB(sd->fd,count[1]+7)=0;
		WFIFOSET(sd->fd, encrypt(sd->fd));
		//printf("Mob count: %d\n",count[0]);
		//printf("Len count: %d\n",count[1]);
	}
	return 0;
}

int clif_send_duration(USER* sd, int id, int time, USER* tsd) {
	int len;

	nullpo_ret(0, sd);

	char* name = NULL;
	name = magicdb_name(id);

	if (!magicdb_ticker(id)) return 0;

	if (id == 0) {
		len = 6;
	}
	else if (tsd) {
		len = strlen(name) + strlen(tsd->status.name) + 3;
	}
	else {
		len = strlen(name);
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, len + 10);
	WFIFOB(sd->fd, 5) = len;

	if (id == 0) {
		strcpy(WFIFOP(sd->fd, 6), "Shield");
	}
	else if (tsd != NULL) {
		char buf[len];
		sprintf(buf, "%s (%s)", name, tsd->status.name);
		strcpy(WFIFOP(sd->fd, 6), buf);
	}
	else {
		strcpy(WFIFOP(sd->fd, 6), name);
	}

	WFIFOL(sd->fd, len + 6) = SWAP32(time);

	WFIFOHEADER(sd->fd, 0x3A, len + 7);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_send_aether(USER* sd, int id, int time) {
	int pos;

	nullpo_ret(0, sd);
	pos = clif_findspell_pos(sd, id);
	if (pos < 0) return 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 11); //this is causing crashes
	WFIFOHEADER(sd->fd, 63, 8);
	WFIFOW(sd->fd, 5) = SWAP16(pos + 1);
	WFIFOL(sd->fd, 7) = SWAP32(time);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_npc_move(struct block_list* bl, va_list ap) {
	char* buf;
	int type;
	USER* sd = NULL;
	NPC* nd = NULL;

	type = va_arg(ap, int);
	nullpo_ret(0, sd = (USER*)bl);
	nullpo_ret(0, nd = va_arg(ap, NPC*));

	CALLOC(buf, char, 32);
	WBUFB(buf, 0) = 0xAA;
	WBUFB(buf, 1) = 0x00;
	WBUFB(buf, 2) = 0x0C;
	WBUFB(buf, 3) = 0x0C;
	//WBUFB(buf, 4) = 0x03;
	WBUFL(buf, 5) = SWAP32(nd->bl.id);
	WBUFW(buf, 9) = SWAP16(nd->bl.bx);
	WBUFW(buf, 11) = SWAP16(nd->bl.by);
	WBUFB(buf, 13) = nd->side;
	WBUFB(buf, 14) = 0x00;

	clif_send(buf, 32, &nd->bl, AREA_WOS); //come back
	FREE(buf);

	/*WFIFOHEAD(sd->fd,14);
	WFIFOHEADER(sd->fd, 0x0C, 11);
	WFIFOL(sd->fd,5) = SWAP32(cnd->bl.id);
	WFIFOW(sd->fd,9) = SWAP16(cnd->bl.bx);
	WFIFOW(sd->fd,11) = SWAP16(cnd->bl.by);
	WFIFOB(sd->fd,13) = cnd->side;
	encrypt(sd->fd);
	WFIFOSET(sd->fd,14);*/
	return 0;
}

int clif_mob_move(struct block_list* bl, va_list ap) {
	int type;
	USER* sd = NULL;
	MOB* mob = NULL;
	type = va_arg(ap, int);

	if (type == LOOK_GET) {
		nullpo_ret(0, sd = va_arg(ap, USER*));
		nullpo_ret(0, mob = (MOB*)bl);
		if (mob->state == MOB_DEAD)
			return 0;
	}
	else {
		nullpo_ret(0, sd = (USER*)bl);
		nullpo_ret(0, mob = va_arg(ap, MOB*));
		if (mob->state == MOB_DEAD)
			return 0;
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 14);
	WFIFOHEADER(sd->fd, 0x0C, 11);
	WFIFOL(sd->fd, 5) = SWAP32(mob->bl.id);
	WFIFOW(sd->fd, 9) = SWAP16(mob->bx);
	WFIFOW(sd->fd, 11) = SWAP16(mob->by);
	WFIFOB(sd->fd, 13) = mob->side;
	WFIFOSET(sd->fd, encrypt(sd->fd));
	//printf("Moved\n");
	return 0;
}
int clif_mob_damage(USER* sd, MOB* mob) {
	int damage;
	int x;

	nullpo_ret(0, sd);
	nullpo_ret(0, mob);

	if (mob->state == MOB_DEAD) return 0;

	sl_doscript_blargs("hitCritChance", NULL, 2, &sd->bl, &mob->bl);

	if (sd->critchance > 0) {
		sl_doscript_blargs("swingDamage", NULL, 2, &sd->bl, &mob->bl);

		if (sd->status.equip[EQ_WEAP].id > 0) {
			clif_playsound(&mob->bl, itemdb_soundhit(sd->status.equip[EQ_WEAP].id));
		}

		if (rnd(100) > 75) {
			clif_deductdura(sd, EQ_WEAP, 1);
		}

		damage = (int)(sd->damage += 0.5f);
		mob->lastaction = time(NULL);

		for (x = 0; x < MAX_THREATCOUNT; x++) {
			if (mob->threat[x].user == sd->bl.id) {
				mob->threat[x].amount = mob->threat[x].amount + damage;
				break;
			}
			else if (mob->threat[x].user == 0) {
				mob->threat[x].user = sd->bl.id;
				mob->threat[x].amount = damage;
				break;
			}
		}

		for (x = 0; x < 14; x++) {
			if (sd->status.equip[x].id > 0) {
				sl_doscript_blargs(itemdb_yname(sd->status.equip[x].id), "on_hit", 2, &sd->bl, &mob->bl);
			}
		}

		for (x = 0; x < MAX_SPELLS; x++) {
			if (sd->status.skill[x] > 0) {
				sl_doscript_blargs(magicdb_yname(sd->status.skill[x]), "passive_on_hit", 2, &sd->bl, &mob->bl);
			}
		}

		for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
			if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].duration > 0) {
				sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "on_hit_while_cast", 2, &sd->bl, &mob->bl);
			}
		}

		if (sd->critchance == 1) {
			clif_send_mob_health(mob, damage, 33);
		}
		else if (sd->critchance == 2) {
			clif_send_mob_health(mob, damage, 255);
		}
	}

	return 0;
}
int clif_send_mob_health_sub(struct block_list* bl, va_list ap) {
	USER* sd = NULL;
	USER* tsd = NULL;
	MOB* mob = NULL;

	int x;
	int critical;
	int percentage;
	int damage;
	nullpo_ret(0, sd = va_arg(ap, USER*));
	nullpo_ret(0, mob = va_arg(ap, MOB*));
	critical = va_arg(ap, int);
	percentage = va_arg(ap, int);
	damage = va_arg(ap, int);
	nullpo_ret(0, tsd = (USER*)bl);

	if (!clif_isingroup(tsd, sd)) {
		if (sd->bl.id != bl->id) {
			return 0;
		}
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(tsd->fd, 15);
	WFIFOHEADER(tsd->fd, 0x13, 12);
	WFIFOL(tsd->fd, 5) = SWAP32(mob->bl.id);
	WFIFOB(tsd->fd, 9) = critical;
	WFIFOB(tsd->fd, 10) = (int)percentage;
	WFIFOL(tsd->fd, 11) = SWAP32((unsigned int)damage);
	WFIFOSET(tsd->fd, encrypt(tsd->fd));
	return 0;
}
int clif_send_mob_health_sub_nosd(struct block_list* bl, va_list ap) {
	USER* sd = NULL;
	MOB* mob = NULL;

	int x;
	int critical;
	int percentage;
	int damage;
	nullpo_ret(0, mob = va_arg(ap, MOB*));
	critical = va_arg(ap, int);
	percentage = va_arg(ap, int);
	damage = va_arg(ap, int);
	nullpo_ret(0, sd = (USER*)bl);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 15);
	WFIFOHEADER(sd->fd, 0x13, 12);
	WFIFOL(sd->fd, 5) = SWAP32(mob->bl.id);
	WFIFOB(sd->fd, 9) = critical;
	WFIFOB(sd->fd, 10) = (int)percentage;
	WFIFOL(sd->fd, 11) = SWAP32((unsigned int)damage);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}
int clif_send_mob_health(MOB* mob, int damage, int critical) {
	struct block_list* bl = map_id2bl(mob->attacker);

	if (mob->bl.type != BL_MOB) return 0;

	if (bl == NULL) {
		bl = map_id2bl(mob->bl.id);
	}

	if (mob->data->subtype == 0) {
		sl_doscript_blargs("mob_ai_basic", "on_attacked", 2, &mob->bl, bl);
	}
	else if (mob->data->subtype == 1) {
		sl_doscript_blargs("mob_ai_normal", "on_attacked", 2, &mob->bl, bl);
	}
	else if (mob->data->subtype == 2) {
		sl_doscript_blargs("mob_ai_hard", "on_attacked", 2, &mob->bl, bl);
	}
	else if (mob->data->subtype == 3) {
		sl_doscript_blargs("mob_ai_boss", "on_attacked", 2, &mob->bl, bl);
	}
	else if (mob->data->subtype == 4) {
		sl_doscript_blargs(mob->data->yname, "on_attacked", 2, &mob->bl, bl);
	}
	else if (mob->data->subtype == 5) {
		sl_doscript_blargs("mob_ai_ghost", "on_attacked", 2, &mob->bl, bl);
	}

	return 0;
}

int clif_send_mob_healthscript(MOB* mob, int damage, int critical) {
	unsigned int dropid = 0;
	float dmgpct = 0.0f;
	char droptype = 0;
	int maxvita;
	int x;
	int currentvita;
	float percentage;
	struct block_list* bl = NULL;

	if (mob->attacker > 0) {
		bl = map_id2bl(mob->attacker);
	}
	USER* sd = NULL;
	USER* tsd = NULL;
	MOB* tmob = NULL;
	//USER *tsd;
	nullpo_ret(0, mob);
	//nullpo_ret(0,bl);
	if (bl != NULL) {
		if (bl->type == BL_PC) {
			sd = (USER*)bl;
		}
		else if (bl->type == BL_MOB) {
			tmob = (MOB*)bl;
			if (tmob->owner < MOB_START_NUM && tmob->owner > 0) {
				sd = map_id2sd(tmob->owner);
			}
		}
	}

	if (mob->state == MOB_DEAD) return 0;

	maxvita = mob->maxvita;
	currentvita = mob->current_vita;

	if (damage < 0) {
		if (currentvita - damage > maxvita) {
			mob->maxdmg += (float)(maxvita - currentvita);
		}
		else {
			mob->maxdmg -= (float)(damage);
		}

		mob->lastvita = currentvita;
		currentvita -= damage;
	}
	else {
		if (currentvita < damage) {
			mob->lastvita = currentvita;
			currentvita = 0;
		}
		else {
			mob->lastvita = currentvita;
			currentvita -= damage;
		}
	}

	if (currentvita > maxvita) {
		currentvita = maxvita;
	}

	if (currentvita <= 0) {
		percentage = 0.0f;
	}
	else {
		percentage = (float)currentvita / (float)maxvita;
		percentage = percentage * 100.0f;

		if (percentage < 1.0f && currentvita) percentage = 1.0f;
	}

	//for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
	//	if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].duration > 0) {
	//		sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "on_hit_while_cast", 2, &sd->bl, &mob->bl);
	//	}
	//}

	if (currentvita > 0 && damage > 0) {
		for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
			struct skill_info* p;
			p = &mob->da[x];

			if (p->id > 0 && p->duration > 0) {
				sl_doscript_blargs(magicdb_yname(p->id), "on_takedamage_while_cast", 2, &mob->bl, bl);
			}
		}
	}

	if (sd != NULL) {
		map_foreachinarea(clif_send_mob_health_sub, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC, sd, mob, critical, (int)percentage, damage);
	}
	else {
		map_foreachinarea(clif_send_mob_health_sub_nosd, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC, mob, critical, (int)percentage, damage);
	}

	mob->current_vita = currentvita;

	if (!mob->current_vita) {
		sl_doscript_blargs(mob->data->yname, "before_death", 2, &mob->bl, &sd->bl);
		sl_doscript_blargs("before_death", NULL, 2, &mob->bl, &sd->bl);

		for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
			if (mob->da[x].id > 0) {
				if (mob->da[x].duration > 0) {
					sl_doscript_blargs(magicdb_yname(mob->da[x].id), "before_death_while_cast", 2, &mob->bl, bl);
				}
			}
		}
	}

	if (!mob->current_vita) {
		mob_flushmagic(mob);
		clif_mob_kill(mob);

		if (tmob != NULL && mob->summon == 0) {
			for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
				if (tmob->da[x].id > 0) {
					if (tmob->da[x].duration > 0) {
						sl_doscript_blargs(magicdb_yname(tmob->da[x].id), "on_kill_while_cast", 2, &tmob->bl, &mob->bl);
					}
				}
			}
		}

		if (sd != NULL && mob->summon == 0) {
			if (tmob == NULL) {
				for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
					if (sd->status.dura_aether[x].id > 0) {
						if (sd->status.dura_aether[x].duration > 0) {
							sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "on_kill_while_cast", 2, &sd->bl, &mob->bl);
						}
					}
				}

				for (x = 0; x < MAX_SPELLS; x++) {
					if (sd->status.skill[x] > 0) {
						sl_doscript_blargs(magicdb_yname(sd->status.skill[x]), "passive_on_kill", 2, &sd->bl, &mob->bl);
					}
				}
			}

			for (x = 0; x < MAX_THREATCOUNT; x++) {
				if (mob->dmggrptable[x][1] / mob->maxdmg > dmgpct) {
					dropid = mob->dmggrptable[x][0];
					dmgpct = mob->dmggrptable[x][1] / mob->maxdmg;
				}

				if (mob->dmgindtable[x][1] / mob->maxdmg > dmgpct) {
					dropid = mob->dmgindtable[x][0];
					dmgpct = mob->dmgindtable[x][1] / mob->maxdmg;
					droptype = 1;
				}
			}

			if (droptype == 1) {
				tsd = map_id2sd(dropid);
			}
			else {
				tsd = map_id2sd(groups[dropid][0]);
			}

			if (tsd != NULL) {
				mobdb_drops(mob, tsd);
			}
			else {
				mobdb_drops(mob, sd);
			}

			// get experience from mobs..

			if (sd->group_count == 0) {
				if (mob->exp) addtokillreg(sd, mob->mobid);
			}
			else if (sd->group_count > 0) { clif_addtokillreg(sd, mob->mobid); }

			sl_doscript_blargs("onGetExp", NULL, 2, &sd->bl, &mob->bl);

			if (sd->group_count == 0) {
				pc_checklevel(sd);
			}
			else if (sd->group_count > 0) {
				for (x = 0; x < sd->group_count; x++) {
					tsd = map_id2sd(groups[sd->groupid][x]);
					if (!tsd)
						continue;
					if (tsd->bl.m == sd->bl.m && tsd->status.state != 1) {
						pc_checklevel(tsd);
					}
				}
			}

			/*unsigned int amount;
			SqlStmt* stmt = SqlStmt_Malloc(sql_handle);

			if(stmt == NULL) {
				SqlStmt_ShowDebug(stmt);
				SqlStmt_Free(stmt);
				return 0;
			}

			if(SQL_ERROR == SqlStmt_Prepare(stmt,"SELECT `KlgAmount` FROM `KillLogs` WHERE `KlgChaId` = '%u' AND `KlgMobId` = '%u'", sd->status.id, mob->mobid)
			|| SQL_ERROR == SqlStmt_Execute(stmt)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_UINT, &amount, 0, NULL, NULL)) {
				SqlStmt_ShowDebug(stmt);
				SqlStmt_Free(stmt);
				return 0;
			}

			if(SQL_SUCCESS == SqlStmt_NextRow(stmt)) {
				amount += 1;
				if(SQL_ERROR == Sql_Query(sql_handle,"UPDATE `KillLogs` SET `KlgAmount` = '%u' WHERE `KlgChaId` = '%u' AND `KlgMobId` = '%u'", amount, sd->status.id, mob->mobid)) {
					SqlStmt_ShowDebug(sql_handle);
					return 0;
				}
			} else {
				amount = 1;
				if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `KillLogs` (`KlgChaId`, `KlgMobId`, `KlgAmount`) VALUES ('%u', '%u', '%u')", sd->status.id, mob->mobid, amount)) {
					SqlStmt_ShowDebug(sql_handle);
					return 0;
				}
			}

			SqlStmt_Free(stmt);*/

			sl_doscript_blargs("onKill", NULL, 2, &mob->bl, &sd->bl);
		}

		for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
			if (mob->da[x].id > 0) {
				sl_doscript_blargs(magicdb_yname(mob->da[x].id), "after_death_while_cast", 2, &mob->bl, bl);
			}
		}

		sl_doscript_blargs(mob->data->yname, "after_death", 2, &mob->bl, bl);
		sl_doscript_blargs("after_death", NULL, 2, &mob->bl, &sd->bl);
	}

	return 0;
}

int clif_mob_kill(MOB* mob) {
	int x;
	//remove threat I had a <= MAX; so made it <
	for (x = 0; x < MAX_THREATCOUNT; x++) {
		mob->threat[x].user = 0;
		mob->threat[x].amount = 0;
		mob->dmggrptable[x][0] = 0;
		mob->dmggrptable[x][1] = 0;
		mob->dmgindtable[x][0] = 0;
		mob->dmgindtable[x][1] = 0;
	}

	mob->dmgdealt = 0;
	mob->dmgtaken = 0;
	mob->maxdmg = mob->data->vita;
	mob->state = MOB_DEAD;
	mob->last_death = time(NULL);
	//Do a check for 30 MINIMUM
	if (!mob->onetime) map_lastdeath_mob(mob);
	//map_delblock(&mob->bl);
	map_foreachinarea(clif_send_destroy, mob->bl.m, mob->bl.x, mob->bl.y, AREA, BL_PC, LOOK_GET, &mob->bl);
	//map_addblock(&mob->bl);
	return 0;
}

int clif_send_destroy(struct block_list* bl, va_list ap) {
	USER* sd = NULL;
	MOB* mob = NULL;
	int type;
	type = va_arg(ap, int);

	nullpo_ret(0, sd = (USER*)bl);
	nullpo_ret(0, mob = va_arg(ap, MOB*));

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	if (mob->data->mobtype == 1) {
		WFIFOHEAD(sd->fd, 9);
		WFIFOB(sd->fd, 0) = 0xAA;
		WFIFOW(sd->fd, 1) = SWAP16(6);
		WFIFOB(sd->fd, 3) = 0x0E;
		WFIFOB(sd->fd, 4) = 0x03;
		WFIFOL(sd->fd, 5) = SWAP32(mob->bl.id);
		WFIFOSET(sd->fd, encrypt(sd->fd));
	}
	else {
		WFIFOHEAD(sd->fd, 9);
		WFIFOB(sd->fd, 0) = 0xAA;
		WFIFOW(sd->fd, 1) = SWAP16(6);
		WFIFOB(sd->fd, 3) = 0x5F;
		WFIFOB(sd->fd, 4) = 0x03;
		WFIFOL(sd->fd, 5) = SWAP32(mob->bl.id);
		WFIFOSET(sd->fd, encrypt(sd->fd));
	}
	return 0;
}

void clif_send_timer(USER* sd, char type, unsigned int length) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 10);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(7);
	WFIFOB(sd->fd, 3) = 0x67;
	WFIFOB(sd->fd, 5) = type;
	WFIFOL(sd->fd, 6) = SWAP32(length);
	WFIFOSET(sd->fd, encrypt(sd->fd));
}

int clif_parsenpcdialog(USER* sd) {
	int npc_choice = RFIFOB(sd->fd, 13); // 2
	//unsigned int npc_id=sd->last_click; // this is for debugging so we know which npc for crash
	int npc_menu = 0;
	char input[100];
	memset(input, 0, 80);

	switch (RFIFOB(sd->fd, 5)) {
	case 0x01: //Dialog
		sl_resumedialog(npc_choice, sd);
		break;
	case 0x02: //Special menu
		//clif_debug(RFIFOP(sd->fd, 5), SWAP16(RFIFOW(sd->fd, 1)) - 5);

		npc_menu = RFIFOB(sd->fd, 15);
		sl_resumemenuseq(npc_choice, npc_menu, sd);
		break;
	case 0x04: // inputSeq returned input

		if (RFIFOB(sd->fd, 13) != 0x02) { sl_async_freeco(sd); return 1; }

		memcpy(input, RFIFOP(sd->fd, 16), RFIFOB(sd->fd, 15));

		sl_resumeinputseq(npc_choice, input, sd);

		break;
	}

	return 0;
}
int clif_send_sub(struct block_list* bl, va_list ap) {
	unsigned char* buf = NULL;
	int x, len;
	struct block_list* src_bl = NULL;
	int type;
	USER* sd = NULL;
	USER* tsd = NULL;

	//nullpo_ret(0, bl);
	nullpo_ret(0, ap);
	nullpo_ret(0, sd = (USER*)bl);

	buf = va_arg(ap, unsigned char*);
	len = va_arg(ap, int);
	nullpo_ret(0, src_bl = va_arg(ap, struct block_list*));
	if (src_bl->type == BL_PC) tsd = (USER*)src_bl;

	if (tsd) {
		if ((tsd->optFlags & optFlag_stealth) && !sd->status.gm_level && sd->status.id != tsd->status.id) {
			return 0;
		}

		if (map[tsd->bl.m].show_ghosts && tsd->status.state == 1 && tsd->bl.id != sd->bl.id && sd->status.state != 1 && !(sd->optFlags & optFlag_ghosts)) {
			return 0;
		}
	}

	if (sd && tsd) {
		if (RBUFB(buf, 3) == 0x0D && !clif_isignore(tsd, sd)) return 0;
	}

	type = va_arg(ap, int);

	switch (type) {
	case AREA_WOS:
	case SAMEAREA_WOS:
		if (bl == src_bl)
			return 0;
		break;
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	if (RBUFB(buf, 3) == 0x0D && RBUFB(buf, 5) >= 10) {
		if (pc_readglobalreg(sd, "chann_en") >= 1 && RBUFB(buf, 5) == 10) {
			WBUFB(buf, 5) = 0;
			WFIFOHEAD(sd->fd, len + 3);
			if (isActive(sd) && WFIFOP(sd->fd, 0) != buf)
				memcpy(WFIFOP(sd->fd, 0), buf, len);
			if (sd) WFIFOSET(sd->fd, encrypt(sd->fd));
			WBUFB(buf, 5) = 10;
		}
		else if (pc_readglobalreg(sd, "chann_es") >= 1 && RBUFB(buf, 5) == 11) {
			WBUFB(buf, 5) = 0;
			WFIFOHEAD(sd->fd, len + 3);
			if (isActive(sd) && WFIFOP(sd->fd, 0) != buf)
				memcpy(WFIFOP(sd->fd, 0), buf, len);
			if (sd) WFIFOSET(sd->fd, encrypt(sd->fd));
			WBUFB(buf, 5) = 11;
		}
		else if (pc_readglobalreg(sd, "chann_fr") >= 1 && RBUFB(buf, 5) == 12) {
			WBUFB(buf, 5) = 0;
			WFIFOHEAD(sd->fd, len + 3);
			if (isActive(sd) && WFIFOP(sd->fd, 0) != buf)
				memcpy(WFIFOP(sd->fd, 0), buf, len);
			if (sd) WFIFOSET(sd->fd, encrypt(sd->fd));
			WBUFB(buf, 5) = 12;
		}
		else if (pc_readglobalreg(sd, "chann_cn") >= 1 && RBUFB(buf, 5) == 13) {
			WBUFB(buf, 5) = 0;
			WFIFOHEAD(sd->fd, len + 3);
			if (isActive(sd) && WFIFOP(sd->fd, 0) != buf)
				memcpy(WFIFOP(sd->fd, 0), buf, len);
			if (sd) WFIFOSET(sd->fd, encrypt(sd->fd));
			WBUFB(buf, 5) = 13;
		}
		else if (pc_readglobalreg(sd, "chann_pt") >= 1 && RBUFB(buf, 5) == 14) {
			WBUFB(buf, 5) = 0;
			WFIFOHEAD(sd->fd, len + 3);
			if (isActive(sd) && WFIFOP(sd->fd, 0) != buf)
				memcpy(WFIFOP(sd->fd, 0), buf, len);
			if (sd) WFIFOSET(sd->fd, encrypt(sd->fd));
			WBUFB(buf, 5) = 14;
		}
		else if (pc_readglobalreg(sd, "chann_id") >= 1 && RBUFB(buf, 5) == 15) {
			WBUFB(buf, 5) = 0;
			WFIFOHEAD(sd->fd, len + 3);
			if (isActive(sd) && WFIFOP(sd->fd, 0) != buf)
				memcpy(WFIFOP(sd->fd, 0), buf, len);
			if (sd) WFIFOSET(sd->fd, encrypt(sd->fd));
			WBUFB(buf, 5) = 15;
		}
	}
	else {
		WFIFOHEAD(sd->fd, len + 3);
		if (isActive(sd) && WFIFOP(sd->fd, 0) != buf)
			memcpy(WFIFOP(sd->fd, 0), buf, len);
		if (sd) WFIFOSET(sd->fd, encrypt(sd->fd));
	}

	return 0;
}

int clif_send(unsigned char* buf, int len, struct block_list* bl, int type) {
	USER* sd = NULL;
	USER* tsd = NULL;
	struct socket_data* p = NULL;
	int i;

	switch (type) {
	case ALL_CLIENT:
	case SAMESRV:
		for (i = 0; i < fd_max; i++) {
			p = session[i];
			if (p && (sd = p->session_data)) {
				if (bl->type == BL_PC) tsd = (USER*)bl;

				if (tsd && RBUFB(buf, 3) == 0x0D && !clif_isignore(tsd, sd)) continue;

				WFIFOHEAD(i, len + 3);
				memcpy(WFIFOP(i, 0), buf, len);
				WFIFOSET(i, encrypt(i));
			}
		}
		break;
	case SAMEMAP:
		for (i = 0; i < fd_max; i++) {
			p = session[i];
			if (p && (sd = p->session_data) && sd->bl.m == bl->m) {
				if (bl->type == BL_PC) tsd = (USER*)bl;

				if (tsd && RBUFB(buf, 3) == 0x0D && !clif_isignore(tsd, sd)) continue;

				WFIFOHEAD(i, len + 3);
				memcpy(WFIFOP(i, 0), buf, len);
				WFIFOSET(i, encrypt(i));
			}
		}
		break;
	case SAMEMAP_WOS:
		for (i = 0; i < fd_max; i++) {
			p = session[i];
			if (p && (sd = p->session_data) && sd->bl.m == bl->m && sd != (USER*)bl) {
				if (bl->type == BL_PC) tsd = (USER*)bl;

				if (tsd && RBUFB(buf, 3) == 0x0D && !clif_isignore(tsd, sd)) continue;

				WFIFOHEAD(i, len + 3);
				memcpy(WFIFOP(i, 0), buf, len);
				WFIFOSET(i, encrypt(i));
			}
		}
		break;
	case AREA:
	case AREA_WOS:
		map_foreachinarea(clif_send_sub, bl->m, bl->x, bl->y, AREA, BL_PC, buf, len, bl, type);
		break;
	case SAMEAREA:
	case SAMEAREA_WOS:
		map_foreachinarea(clif_send_sub, bl->m, bl->x, bl->y, SAMEAREA, BL_PC, buf, len, bl, type);
		break;
	case CORNER:
		map_foreachinarea(clif_send_sub, bl->m, bl->x, bl->y, CORNER, BL_PC, buf, len, bl, type);
		break;
	case SELF:
		sd = (USER*)bl;

		WFIFOHEAD(sd->fd, len + 3);
		memcpy(WFIFOP(sd->fd, 0), buf, len);
		WFIFOSET(sd->fd, encrypt(sd->fd));
		break;
	}
	return 0;
}

int clif_sendtogm(unsigned char* buf, int len, struct block_list* bl, int type) {
	USER* sd = NULL;
	struct socket_data* p = NULL;
	int i;

	switch (type) {
	case ALL_CLIENT:
	case SAMESRV:
		for (i = 0; i < fd_max; i++) {
			p = session[i];
			if (p && (sd = p->session_data)) {
				WFIFOHEAD(i, len + 3);
				memcpy(WFIFOP(i, 0), buf, len);
				WFIFOSET(i, encrypt(i));
			}
		}
		break;
	case SAMEMAP:
		for (i = 0; i < fd_max; i++) {
			p = session[i];
			if (p && (sd = p->session_data) && sd->bl.m == bl->m) {
				WFIFOHEAD(i, len + 3);
				memcpy(WFIFOP(i, 0), buf, len);
				WFIFOSET(i, encrypt(i));
			}
		}
		break;
	case SAMEMAP_WOS:
		for (i = 0; i < fd_max; i++) {
			p = session[i];
			if (p && (sd = p->session_data) && sd->bl.m == bl->m && sd != (USER*)bl) {
				WFIFOHEAD(i, len + 3);
				memcpy(WFIFOP(i, 0), buf, len);
				WFIFOSET(i, encrypt(i));
			}
		}
		break;
	case AREA:
	case AREA_WOS:
		map_foreachinarea(clif_send_sub, bl->m, bl->x, bl->y, AREA, BL_PC, buf, len, bl, type);
		break;
	case SAMEAREA:
	case SAMEAREA_WOS:
		map_foreachinarea(clif_send_sub, bl->m, bl->x, bl->y, SAMEAREA, BL_PC, buf, len, bl, type);
		break;
	case CORNER:
		map_foreachinarea(clif_send_sub, bl->m, bl->x, bl->y, CORNER, BL_PC, buf, len, bl, type);
		break;
	case SELF:
		sd = (USER*)bl;

		WFIFOHEAD(sd->fd, len + 3);
		memcpy(WFIFOP(sd->fd, 0), buf, len);
		WFIFOSET(sd->fd, encrypt(sd->fd));
		break;
	}
	return 0;
}

int clif_quit(USER* sd) {
	map_delblock(&sd->bl);
	clif_lookgone(&sd->bl);
	return 0;
}

unsigned int clif_getlvlxp(int level) {
	double constant = 0.2;

	float xprequired = pow((level / constant), 2);

	return (unsigned int)(xprequired + 0.5);
}

int clif_mystaytus(USER* sd) {
	//int len;
	int x;
	int count = 0;
	char buf[128];

	char* class_name = NULL;
	char* name = NULL;
	char* partner = NULL;

	int tnl = clif_getLevelTNL(sd);
	int len = 0;
	nullpo_ret(0, sd);
	float percentage = clif_getXPBarPercent(sd);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	if (sd->armor < -127) sd->armor = -127;
	if (sd->armor > 127) sd->armor = 127;

	class_name = classdb_name(sd->status.class, sd->status.mark);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x39;
	WFIFOB(sd->fd, 5) = sd->armor; //AC Value
	WFIFOB(sd->fd, 6) = sd->dam;
	WFIFOB(sd->fd, 7) = sd->hit;

	//clan
	if (sd->status.clan == 0) {
		WFIFOB(sd->fd, 8) = 0;
		len += 1;
	}
	else {
		WFIFOB(sd->fd, 8) = strlen(clandb_name(sd->status.clan));
		//printf("Clan name length: %d\n",strlen(clandb_name(sd->status.clan)));
		strcpy(WFIFOP(sd->fd, 9), clandb_name(sd->status.clan));
		len += strlen(clandb_name(sd->status.clan)) + 1;
	}

	//clan title
	if (strlen(sd->status.clan_title)) {
		WFIFOB(sd->fd, len + 8) = strlen(sd->status.clan_title);
		strcpy(WFIFOP(sd->fd, len + 9), sd->status.clan_title);
		len += strlen(sd->status.clan_title) + 1;
	}
	else {
		WFIFOB(sd->fd, len + 8) = 0;
		len += 1;
	}

	//title
	if (strlen(sd->status.title)) {
		WFIFOB(sd->fd, len + 8) = strlen(sd->status.title);
		strcpy(WFIFOP(sd->fd, len + 9), sd->status.title);
		len += strlen(sd->status.title) + 1;
	}
	else {
		WFIFOB(sd->fd, len + 8) = 0;
		len += 1;
	}

	//partner
	if (sd->status.partner) {
		partner = map_id2name(sd->status.partner);
		sprintf(buf, "Partner: %s", map_id2name(sd->status.partner));
		FREE(partner);

		WFIFOB(sd->fd, len + 8) = strlen(buf);
		strcpy(WFIFOP(sd->fd, len + 9), buf);
		len += strlen(buf) + 1;
	}
	else {
		WFIFOB(sd->fd, len + 8) = 0; //this is where partner goes
		//strcpy(WFIFOP(sd->fd,len+10),"Partner: TheStalker");
		len += 1;
	}

	if (sd->status.settingFlags & FLAG_GROUP) {
		WFIFOB(sd->fd, len + 8) = 1; //group
	}
	else {
		WFIFOB(sd->fd, len + 8) = 0;
	}

	WFIFOL(sd->fd, len + 9) = SWAP32(tnl); //TNL
	len += 5;

	if (class_name) {
		WFIFOB(sd->fd, len + 8) = strlen(class_name); //Class name length
		strcpy(WFIFOP(sd->fd, len + 9), class_name);
		len += strlen(class_name) + 1;
	}
	else {
		WFIFOB(sd->fd, len + 8) = 0;
		len += 1;
	}

	for (x = 0; x < 14; x++) {
		//if(x==EQ_MANTLE) printf("Mantle: %d\n",sd->status.equip[x].id);
		if (sd->status.equip[x].id > 0) {
			if (sd->status.equip[x].customIcon != 0) {
				WFIFOW(sd->fd, len + 8) = SWAP16(sd->status.equip[x].customIcon + 49152);
				WFIFOB(sd->fd, len + 10) = sd->status.equip[x].customIconColor;
			}
			else {
				WFIFOW(sd->fd, len + 8) = SWAP16(itemdb_icon(sd->status.equip[x].id));
				WFIFOB(sd->fd, len + 10) = itemdb_iconcolor(sd->status.equip[x].id);
			}

			len += 3;

			if (strlen(sd->status.equip[x].real_name)) {
				name = sd->status.equip[x].real_name;
			}
			else {
				name = itemdb_name(sd->status.equip[x].id);
			}

			strcpy(buf, name);
			WFIFOB(sd->fd, len + 8) = strlen(buf);
			strcpy(WFIFOP(sd->fd, len + 9), buf);
			len += strlen(buf) + 1;

			WFIFOB(sd->fd, len + 8) = strlen(itemdb_name(sd->status.equip[x].id));
			strcpy(WFIFOP(sd->fd, len + 9), itemdb_name(sd->status.equip[x].id));
			len += strlen(itemdb_name(sd->status.equip[x].id)) + 1;

			WFIFOL(sd->fd, len + 8) = SWAP32(sd->status.equip[x].dura);
			WFIFOB(sd->fd, len + 12) = 0;

			if (sd->status.equip[x].protected >= itemdb_protected(sd->status.equip[x].id)) WFIFOB(sd->fd, len + 12) = sd->status.equip[x].protected; // This is the default item protection from the database. it will always override the custom item protection that can be added to items.
			if (itemdb_protected(sd->status.equip[x].id) >= sd->status.equip[x].protected) WFIFOB(sd->fd, len + 12) = itemdb_protected(sd->status.equip[x].id);

			len += 5;
		}
		else {
			WFIFOW(sd->fd, len + 8) = SWAP16(0);
			WFIFOB(sd->fd, len + 10) = 0;
			WFIFOB(sd->fd, len + 11) = 0;
			WFIFOB(sd->fd, len + 12) = 0;
			WFIFOL(sd->fd, len + 13) = SWAP32(0);
			WFIFOB(sd->fd, len + 14) = 0;
			len += 10;
		}
	}

	if (sd->status.settingFlags & FLAG_EXCHANGE) {
		WFIFOB(sd->fd, len + 8) = 1;
	}
	else {
		WFIFOB(sd->fd, len + 8) = 0;
	}

	if (sd->status.settingFlags & FLAG_GROUP) {
		WFIFOB(sd->fd, len + 9) = 1;
	}
	else {
		WFIFOB(sd->fd, len + 9) = 0;
	}

	len += 1;

	for (x = 0; x < MAX_LEGENDS; x++) {
		if (strlen(sd->status.legends[x].text) && strlen(sd->status.legends[x].name)) {
			count++;
		}
	}
	WFIFOB(sd->fd, len + 8) = 0;
	WFIFOW(sd->fd, len + 9) = SWAP16(count);
	len += 3;

	for (x = 0; x < MAX_LEGENDS; x++) {
		if (strlen(sd->status.legends[x].text) && strlen(sd->status.legends[x].name)) {
			WFIFOB(sd->fd, len + 8) = sd->status.legends[x].icon;
			WFIFOB(sd->fd, len + 9) = sd->status.legends[x].color;

			if (sd->status.legends[x].tchaid > 0) {
				char* name = clif_getName(sd->status.legends[x].tchaid);
				char* buff = replace_str(&sd->status.legends[x].text, "$player", name);
				WFIFOB(sd->fd, len + 10) = strlen(buff);
				strcpy(WFIFOP(sd->fd, len + 11), buff);
				len += strlen(buff) + 3;
			}
			else {
				WFIFOB(sd->fd, len + 10) = strlen(sd->status.legends[x].text);
				strcpy(WFIFOP(sd->fd, len + 11), sd->status.legends[x].text);
				len += strlen(sd->status.legends[x].text) + 3;
			}
		}
	}

	WFIFOW(sd->fd, 1) = SWAP16(len + 5);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_lookgone(struct block_list* bl) {
	char buf[16];

	if (bl->type == BL_PC || (bl->type == BL_NPC && ((NPC*)bl)->npctype == 1) || (bl->type == BL_MOB))

	{
		WBUFB(buf, 0) = 0xAA;
		WBUFW(buf, 1) = SWAP16(6);
		WBUFB(buf, 3) = 0x0E;
		WBUFB(buf, 4) = 0x03;
		WBUFL(buf, 5) = SWAP32(bl->id);
		//crypt(WBUFP(buf, 0));
		clif_send(buf, 16, bl, AREA_WOS);
	}
	else
	{
		WBUFB(buf, 0) = 0xAA;
		WBUFW(buf, 1) = SWAP16(6);
		WBUFB(buf, 3) = 0x5F;
		WBUFB(buf, 4) = 0x03;
		WBUFL(buf, 5) = SWAP32(bl->id);
		//crypt(WBUFP(buf, 0));
		clif_send(buf, 16, bl, AREA_WOS);
	}
	return 0;
}

int clif_cnpclook_sub(struct block_list* bl, va_list ap) {
	int len;
	int type;
	NPC* nd = NULL;
	USER* sd = NULL;

	type = va_arg(ap, int);

	if (type == LOOK_GET) {
		nullpo_ret(0, nd = (NPC*)bl);
		nullpo_ret(0, sd = va_arg(ap, USER*));
	}
	else if (type == LOOK_SEND) {
		nullpo_ret(0, nd = va_arg(ap, NPC*));
		nullpo_ret(0, sd = (USER*)bl);
	}

	if (nd->bl.m != sd->bl.m || nd->npctype != 1) {
		return 0;
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 512);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x33;
	//WFIFOB(sd->fd, 4) = 0x6D;
	WFIFOW(sd->fd, 5) = SWAP16(nd->bl.x);
	WFIFOW(sd->fd, 7) = SWAP16(nd->bl.y);
	WFIFOB(sd->fd, 9) = nd->side;
	WFIFOL(sd->fd, 10) = SWAP32(nd->bl.id);

	if (nd->state < 4) {
		WFIFOW(sd->fd, 14) = SWAP16(nd->sex);
	}
	else {
		WFIFOB(sd->fd, 14) = 1;
		WFIFOB(sd->fd, 15) = 15;
	}

	if (nd->state == 2 && sd->status.gm_level) {
		WFIFOB(sd->fd, 16) = 5; //Gm's need to see invis
	}
	else {
		WFIFOB(sd->fd, 16) = nd->state;
	}

	WFIFOB(sd->fd, 19) = 80;

	if (nd->state == 3) {
		WFIFOW(sd->fd, 17) = SWAP16(nd->bl.graphic_id);
	}
	else if (nd->state == 4) {
		WFIFOW(sd->fd, 17) = SWAP16(nd->bl.graphic_id + 32768);
		WFIFOB(sd->fd, 19) = nd->bl.graphic_color;
	}
	else {
		WFIFOW(sd->fd, 17) = 0;
	}

	WFIFOB(sd->fd, 20) = 0;
	WFIFOB(sd->fd, 21) = nd->face; //face
	WFIFOB(sd->fd, 22) = nd->hair; //hair
	WFIFOB(sd->fd, 23) = nd->hair_color; //hair color
	WFIFOB(sd->fd, 24) = nd->face_color;
	WFIFOB(sd->fd, 25) = nd->skin_color;

	//armor
	if (!nd->equip[EQ_ARMOR].amount) {
		WFIFOW(sd->fd, 26) = SWAP16(nd->sex);
	}
	else {
		WFIFOW(sd->fd, 26) = SWAP16(nd->equip[EQ_ARMOR].id);

		if (nd->armor_color > 0) {
			WFIFOB(sd->fd, 28) = nd->armor_color;
		}
		else {
			WFIFOB(sd->fd, 28) = nd->equip[EQ_ARMOR].customLookColor;
		}
	}

	//coat
	if (nd->equip[EQ_COAT].amount > 0) {
		WFIFOW(sd->fd, 26) = SWAP16(nd->equip[EQ_COAT].id);
		WFIFOB(sd->fd, 28) = nd->equip[EQ_COAT].customLookColor;
	}

	//weapon
	if (!nd->equip[EQ_WEAP].amount) {
		WFIFOW(sd->fd, 29) = 0xFFFF;
		WFIFOB(sd->fd, 31) = 0;
	}
	else {
		WFIFOW(sd->fd, 29) = SWAP16(nd->equip[EQ_WEAP].id);
		WFIFOB(sd->fd, 31) = nd->equip[EQ_WEAP].customLookColor;
	}

	//shield
	if (!nd->equip[EQ_SHIELD].amount) {
		WFIFOW(sd->fd, 32) = 0xFFFF;
		WFIFOB(sd->fd, 34) = 0;
	}
	else {
		WFIFOW(sd->fd, 32) = SWAP16(nd->equip[EQ_SHIELD].id);
		WFIFOB(sd->fd, 34) = nd->equip[EQ_SHIELD].customLookColor;
	}

	//helm
	if (!nd->equip[EQ_HELM].amount) {
		WFIFOB(sd->fd, 35) = 0; // supposed to be 1=Helm, 0=No helm
		WFIFOW(sd->fd, 36) = 0xFF; // supposed to be Helm num
	}
	else {
		WFIFOB(sd->fd, 35) = 1;
		WFIFOB(sd->fd, 36) = nd->equip[EQ_HELM].id;
		WFIFOB(sd->fd, 37) = nd->equip[EQ_HELM].customLookColor;
	}

	//beard stuff
	if (!nd->equip[EQ_FACEACC].amount) {
		WFIFOW(sd->fd, 38) = 0xFFFF;
		WFIFOB(sd->fd, 40) = 0;
	}
	else {
		WFIFOW(sd->fd, 38) = SWAP16(nd->equip[EQ_FACEACC].id); //beard num
		WFIFOB(sd->fd, 40) = nd->equip[EQ_FACEACC].customLookColor; //beard color
	}

	//crown
	if (!nd->equip[EQ_CROWN].amount) {
		WFIFOW(sd->fd, 41) = 0xFFFF;
		WFIFOB(sd->fd, 43) = 0;
	}
	else {
		WFIFOB(sd->fd, 35) = 0;
		WFIFOW(sd->fd, 41) = SWAP16(nd->equip[EQ_CROWN].id); //Crown
		WFIFOB(sd->fd, 43) = nd->equip[EQ_CROWN].customLookColor; //Crown color
	}

	if (!nd->equip[EQ_FACEACCTWO].amount) {
		WFIFOW(sd->fd, 44) = 0xFFFF; //second face acc
		WFIFOB(sd->fd, 46) = 0; //" color
	}
	else {
		WFIFOW(sd->fd, 44) = SWAP16(nd->equip[EQ_FACEACCTWO].id);
		WFIFOB(sd->fd, 46) = nd->equip[EQ_FACEACCTWO].customLookColor;
	}

	//mantle
	if (!nd->equip[EQ_MANTLE].amount) {
		WFIFOW(sd->fd, 47) = 0xFFFF;
		WFIFOB(sd->fd, 49) = 0xFF;
	}
	else {
		WFIFOW(sd->fd, 47) = SWAP16(nd->equip[EQ_MANTLE].id);
		WFIFOB(sd->fd, 49) = nd->equip[EQ_MANTLE].customLookColor;
	}

	//necklace
	if (!nd->equip[EQ_NECKLACE].amount) {
		WFIFOW(sd->fd, 50) = 0xFFFF;
		WFIFOB(sd->fd, 52) = 0;
	}
	else {
		WFIFOW(sd->fd, 50) = SWAP16(nd->equip[EQ_NECKLACE].id); //necklace
		WFIFOB(sd->fd, 52) = nd->equip[EQ_NECKLACE].customLookColor; //neckalce color
	}

	//boots
	if (!nd->equip[EQ_BOOTS].amount) {
		WFIFOW(sd->fd, 53) = SWAP16(nd->sex);
		WFIFOB(sd->fd, 55) = 0;
	}
	else {
		WFIFOW(sd->fd, 53) = SWAP16(nd->equip[EQ_BOOTS].id);
		WFIFOB(sd->fd, 55) = nd->equip[EQ_BOOTS].customLookColor;
	}

	WFIFOB(sd->fd, 56) = 0;
	WFIFOB(sd->fd, 57) = 128;
	WFIFOB(sd->fd, 58) = 0;

	len = strlen(nd->npc_name);

	if (nd->state != 2) {
		WFIFOB(sd->fd, 59) = len;
		strcpy(WFIFOP(sd->fd, 60), nd->npc_name);
	}
	else {
		WFIFOB(sd->fd, 59) = 0;
		len = 1;
	}

	if (nd->clone) {
		WFIFOB(sd->fd, 21) = nd->gfx.face;
		WFIFOB(sd->fd, 22) = nd->gfx.hair;
		WFIFOB(sd->fd, 23) = nd->gfx.chair;
		WFIFOB(sd->fd, 24) = nd->gfx.cface;
		WFIFOB(sd->fd, 25) = nd->gfx.cskin;
		WFIFOW(sd->fd, 26) = SWAP16(nd->gfx.armor);
		if (nd->gfx.dye > 0) {
			WFIFOB(sd->fd, 28) = nd->gfx.dye;
		}
		else {
			WFIFOB(sd->fd, 28) = nd->gfx.carmor;
		}
		WFIFOW(sd->fd, 29) = SWAP16(nd->gfx.weapon);
		WFIFOB(sd->fd, 31) = nd->gfx.cweapon;
		WFIFOW(sd->fd, 32) = SWAP16(nd->gfx.shield);
		WFIFOB(sd->fd, 34) = nd->gfx.cshield;

		if (nd->gfx.helm < 255) {
			WFIFOB(sd->fd, 35) = 1;
		}
		else if (nd->gfx.crown < 65535) {
			WFIFOB(sd->fd, 35) = 0xFF;
		}
		else {
			WFIFOB(sd->fd, 35) = 0;
		}

		WFIFOB(sd->fd, 36) = nd->gfx.helm;
		WFIFOB(sd->fd, 37) = nd->gfx.chelm;
		WFIFOW(sd->fd, 38) = SWAP16(nd->gfx.faceAcc);
		WFIFOB(sd->fd, 40) = nd->gfx.cfaceAcc;
		WFIFOW(sd->fd, 41) = SWAP16(nd->gfx.crown);
		WFIFOB(sd->fd, 43) = nd->gfx.ccrown;
		WFIFOW(sd->fd, 44) = SWAP16(nd->gfx.faceAccT);
		WFIFOB(sd->fd, 46) = nd->gfx.cfaceAccT;
		WFIFOW(sd->fd, 47) = SWAP16(nd->gfx.mantle);
		WFIFOB(sd->fd, 49) = nd->gfx.cmantle;
		WFIFOW(sd->fd, 50) = SWAP16(nd->gfx.necklace);
		WFIFOB(sd->fd, 52) = nd->gfx.cnecklace;
		WFIFOW(sd->fd, 53) = SWAP16(nd->gfx.boots);
		WFIFOB(sd->fd, 55) = nd->gfx.cboots;

		WFIFOB(sd->fd, 56) = 0;
		WFIFOB(sd->fd, 57) = 128;
		WFIFOB(sd->fd, 58) = 0;

		len = strlen(nd->gfx.name);
		if (strcmpi(nd->gfx.name, "")) {
			WFIFOB(sd->fd, 59) = len;
			strcpy(WFIFOP(sd->fd, 60), nd->gfx.name);
		}
		else {
			WFIFOW(sd->fd, 59) = 0;
			len = 1;
		}
	}

	//WFIFOB(sd->fd, len + 58) = 1;
	//WFIFOW(sd->fd, len + 59) = SWAP16(5);
	//WFIFOW(sd->fd, len + 61) = SWAP16(10);
	WFIFOW(sd->fd, 1) = SWAP16(len + 60);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_cmoblook_sub(struct block_list* bl, va_list ap) {
	int len;
	int type;
	MOB* mob = NULL;
	USER* sd = NULL;

	type = va_arg(ap, int);

	if (type == LOOK_GET) {
		nullpo_ret(0, mob = (MOB*)bl);
		nullpo_ret(0, sd = va_arg(ap, USER*));
	}
	else if (type == LOOK_SEND) {
		nullpo_ret(0, mob = va_arg(ap, MOB*));
		nullpo_ret(0, sd = (USER*)bl);
	}

	if (mob->bl.m != sd->bl.m || mob->data->mobtype != 1 || mob->state == 1) {
		return 0;
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 512);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x33;
	//WFIFOB(sd->fd, 4) = 0x6D;
	WFIFOW(sd->fd, 5) = SWAP16(mob->bl.x);
	WFIFOW(sd->fd, 7) = SWAP16(mob->bl.y);
	WFIFOB(sd->fd, 9) = mob->side;
	WFIFOL(sd->fd, 10) = SWAP32(mob->bl.id);

	if (mob->charstate < 4) {
		WFIFOW(sd->fd, 14) = SWAP16(mob->data->sex);
	}
	else {
		WFIFOB(sd->fd, 14) = 1;
		WFIFOB(sd->fd, 15) = 15;
	}

	if (mob->charstate == 2 && (sd->status.gm_level)) {
		WFIFOB(sd->fd, 16) = 5; //Gm's need to see invis
	}
	else {
		WFIFOB(sd->fd, 16) = mob->charstate;
	}

	WFIFOB(sd->fd, 19) = 80;

	if (mob->charstate == 3) {
		WFIFOW(sd->fd, 17) = SWAP16(mob->look);
	}
	else if (mob->charstate == 4) {
		WFIFOW(sd->fd, 17) = SWAP16(mob->look + 32768);
		WFIFOB(sd->fd, 19) = mob->look_color;
	}
	else {
		WFIFOW(sd->fd, 17) = 0;
	}

	WFIFOB(sd->fd, 20) = 0;
	WFIFOB(sd->fd, 21) = mob->data->face; //face
	WFIFOB(sd->fd, 22) = mob->data->hair; //hair
	WFIFOB(sd->fd, 23) = mob->data->hair_color; //hair color
	WFIFOB(sd->fd, 24) = mob->data->face_color;
	WFIFOB(sd->fd, 25) = mob->data->skin_color;

	//armor
	if (!mob->data->equip[EQ_ARMOR].amount) {
		WFIFOW(sd->fd, 26) = SWAP16(mob->data->sex);
	}
	else {
		WFIFOW(sd->fd, 26) = SWAP16(mob->data->equip[EQ_ARMOR].id);

		if (mob->data->armor_color > 0) {
			WFIFOB(sd->fd, 28) = mob->data->armor_color;
		}
		else {
			WFIFOB(sd->fd, 28) = mob->data->equip[EQ_ARMOR].customLookColor;
		}
	}

	//coat
	if (mob->data->equip[EQ_COAT].amount > 0) {
		WFIFOW(sd->fd, 26) = SWAP16(mob->data->equip[EQ_COAT].id);
		WFIFOB(sd->fd, 28) = mob->data->equip[EQ_COAT].customLookColor;
	}

	//weapon
	if (!mob->data->equip[EQ_WEAP].amount) {
		WFIFOW(sd->fd, 29) = 0xFFFF;
		WFIFOB(sd->fd, 31) = 0;
	}
	else {
		WFIFOW(sd->fd, 29) = SWAP16(mob->data->equip[EQ_WEAP].id);
		WFIFOB(sd->fd, 31) = mob->data->equip[EQ_WEAP].customLookColor;
	}

	//shield
	if (!mob->data->equip[EQ_SHIELD].amount) {
		WFIFOW(sd->fd, 32) = 0xFFFF;
		WFIFOB(sd->fd, 34) = 0;
	}
	else {
		WFIFOW(sd->fd, 32) = SWAP16(mob->data->equip[EQ_SHIELD].id);
		WFIFOB(sd->fd, 34) = mob->data->equip[EQ_SHIELD].customLookColor;
	}

	//helm
	if (!mob->data->equip[EQ_HELM].amount) {
		WFIFOB(sd->fd, 35) = 0; // supposed to be 1=Helm, 0=No helm
		WFIFOW(sd->fd, 36) = 0xFF; // supposed to be Helm num
	}
	else {
		WFIFOB(sd->fd, 35) = 1;
		WFIFOB(sd->fd, 36) = mob->data->equip[EQ_HELM].id;
		WFIFOB(sd->fd, 37) = mob->data->equip[EQ_HELM].customLookColor;
	}

	//beard stuff
	if (!mob->data->equip[EQ_FACEACC].amount) {
		WFIFOW(sd->fd, 38) = 0xFFFF;
		WFIFOB(sd->fd, 40) = 0;
	}
	else {
		WFIFOW(sd->fd, 38) = SWAP16(mob->data->equip[EQ_FACEACC].id); //beard num
		WFIFOB(sd->fd, 40) = mob->data->equip[EQ_FACEACC].customLookColor; //beard color
	}

	//crown
	if (!mob->data->equip[EQ_CROWN].amount) {
		WFIFOW(sd->fd, 41) = 0xFFFF;
		WFIFOB(sd->fd, 43) = 0;
	}
	else {
		WFIFOB(sd->fd, 35) = 0;
		WFIFOW(sd->fd, 41) = SWAP16(mob->data->equip[EQ_CROWN].id); //Crown
		WFIFOB(sd->fd, 43) = mob->data->equip[EQ_CROWN].customLookColor; //Crown color
	}

	if (!mob->data->equip[EQ_FACEACCTWO].amount) {
		WFIFOW(sd->fd, 44) = 0xFFFF; //second face acc
		WFIFOB(sd->fd, 46) = 0; //" color
	}
	else {
		WFIFOW(sd->fd, 44) = SWAP16(mob->data->equip[EQ_FACEACCTWO].id);
		WFIFOB(sd->fd, 46) = mob->data->equip[EQ_FACEACCTWO].customLookColor;
	}

	//mantle
	if (!mob->data->equip[EQ_MANTLE].amount) {
		WFIFOW(sd->fd, 47) = 0xFFFF;
		WFIFOB(sd->fd, 49) = 0xFF;
	}
	else {
		WFIFOW(sd->fd, 47) = SWAP16(mob->data->equip[EQ_MANTLE].id);
		WFIFOB(sd->fd, 49) = mob->data->equip[EQ_MANTLE].customLookColor;
	}

	//necklace
	if (!mob->data->equip[EQ_NECKLACE].amount) {
		WFIFOW(sd->fd, 50) = 0xFFFF;
		WFIFOB(sd->fd, 52) = 0;
	}
	else {
		WFIFOW(sd->fd, 50) = SWAP16(mob->data->equip[EQ_NECKLACE].id); //necklace
		WFIFOB(sd->fd, 52) = mob->data->equip[EQ_NECKLACE].customLookColor; //neckalce color
	}

	//boots
	if (!mob->data->equip[EQ_BOOTS].amount) {
		WFIFOW(sd->fd, 53) = SWAP16(mob->data->sex);
		WFIFOB(sd->fd, 55) = 0;
	}
	else {
		WFIFOW(sd->fd, 53) = SWAP16(mob->data->equip[EQ_BOOTS].id);
		WFIFOB(sd->fd, 55) = mob->data->equip[EQ_BOOTS].customLookColor;
	}

	WFIFOB(sd->fd, 56) = 0;
	WFIFOB(sd->fd, 57) = 128;
	WFIFOB(sd->fd, 58) = 0;

	len = strlen(mob->data->name);

	if (mob->state != 2) {
		WFIFOB(sd->fd, 59) = len;
		strcpy(WFIFOP(sd->fd, 60), mob->data->name);
	}
	else {
		WFIFOB(sd->fd, 59) = 0;
		len = 1;
	}

	if (mob->clone) {
		WFIFOB(sd->fd, 21) = mob->gfx.face;
		WFIFOB(sd->fd, 22) = mob->gfx.hair;
		WFIFOB(sd->fd, 23) = mob->gfx.chair;
		WFIFOB(sd->fd, 24) = mob->gfx.cface;
		WFIFOB(sd->fd, 25) = mob->gfx.cskin;
		WFIFOW(sd->fd, 26) = SWAP16(mob->gfx.armor);
		if (mob->gfx.dye > 0) {
			WFIFOB(sd->fd, 28) = mob->gfx.dye;
		}
		else {
			WFIFOB(sd->fd, 28) = mob->gfx.carmor;
		}
		WFIFOW(sd->fd, 29) = SWAP16(mob->gfx.weapon);
		WFIFOB(sd->fd, 31) = mob->gfx.cweapon;
		WFIFOW(sd->fd, 32) = SWAP16(mob->gfx.shield);
		WFIFOB(sd->fd, 34) = mob->gfx.cshield;

		if (mob->gfx.helm < 255) {
			WFIFOB(sd->fd, 35) = 1;
		}
		else if (mob->gfx.crown < 65535) {
			WFIFOB(sd->fd, 35) = 0xFF;
		}
		else {
			WFIFOB(sd->fd, 35) = 0;
		}

		WFIFOB(sd->fd, 36) = mob->gfx.helm;
		WFIFOB(sd->fd, 37) = mob->gfx.chelm;
		WFIFOW(sd->fd, 38) = SWAP16(mob->gfx.faceAcc);
		WFIFOB(sd->fd, 40) = mob->gfx.cfaceAcc;
		WFIFOW(sd->fd, 41) = SWAP16(mob->gfx.crown);
		WFIFOB(sd->fd, 43) = mob->gfx.ccrown;
		WFIFOW(sd->fd, 44) = SWAP16(mob->gfx.faceAccT);
		WFIFOB(sd->fd, 46) = mob->gfx.cfaceAccT;
		WFIFOW(sd->fd, 47) = SWAP16(mob->gfx.mantle);
		WFIFOB(sd->fd, 49) = mob->gfx.cmantle;
		WFIFOW(sd->fd, 50) = SWAP16(mob->gfx.necklace);
		WFIFOB(sd->fd, 52) = mob->gfx.cnecklace;
		WFIFOW(sd->fd, 53) = SWAP16(mob->gfx.boots);
		WFIFOB(sd->fd, 55) = mob->gfx.cboots;

		WFIFOB(sd->fd, 56) = 0;
		WFIFOB(sd->fd, 57) = 128;
		WFIFOB(sd->fd, 58) = 0;

		len = strlen(mob->gfx.name);
		if (strcmpi(mob->gfx.name, "")) {
			WFIFOB(sd->fd, 59) = len;
			strcpy(WFIFOP(sd->fd, 60), mob->gfx.name);
		}
		else {
			WFIFOW(sd->fd, 59) = 0;
			len = 1;
		}
	}

	WFIFOW(sd->fd, 1) = SWAP16(len + 60);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_show_ghost(USER* sd, USER* tsd) {
	/*if(map[sd->bl.m].show_ghosts && tsd->status.state==1 && (sd->bl.id!=tsd->bl.id)) {
		if(sd->status.state!=1 && !(sd->optFlags & optFlag_ghosts)) {
			return 0;
		}
	}*/

	// IF the map has SHOW GHOSTS set, then this overrides all  (to be used on path arena/clan & pc subpath areas)
	// Default setting for ALL maps is to have Show Ghosts set to 0 (off).

	if (!sd->status.gm_level) { // This set of rules ONLY applies to non GMs
		if (!map[sd->bl.m].show_ghosts && tsd->status.state == 1 && sd->bl.id != tsd->bl.id) {
			if (map[sd->bl.m].pvp) {
				if (sd->status.state == 1 && sd->optFlags & optFlag_ghosts) return 1;
				else return 0;
			}
			else return 1;
		}
	}

	return 1;
}

int clif_charlook_sub(struct block_list* bl, va_list ap) {
	char buf[64];
	USER* src_sd = NULL;
	USER* sd = NULL;
	int x, len, type;
	int exist = -1;

	type = va_arg(ap, int);

	if (type == LOOK_GET) {
		nullpo_ret(0, sd = (USER*)bl);
		nullpo_ret(0, src_sd = va_arg(ap, USER*));
		if (src_sd == sd)
			return 0;
	}
	else {
		nullpo_ret(0, src_sd = (USER*)bl);
		nullpo_ret(0, sd = va_arg(ap, USER*));
	}

	if (sd->bl.m != src_sd->bl.m) return 0; //Hopefully this'll cure seeing ppl on the map who arent there.

	if ((sd->optFlags & optFlag_stealth) && !src_sd->status.gm_level && (sd->status.id != src_sd->status.id))
		return 0;

	if (map[sd->bl.m].show_ghosts && sd->status.state == 1 && (sd->bl.id != src_sd->bl.id)) {
		if (src_sd->status.state != 1 && !(src_sd->optFlags & optFlag_ghosts)) {
			return 0;
		}
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(src_sd->fd, 512);
	WFIFOB(src_sd->fd, 0) = 0xAA;
	WFIFOB(src_sd->fd, 3) = 0x33;
	//WFIFOB(src_sd->fd, 4) = 0x03;
	WFIFOW(src_sd->fd, 5) = SWAP16(sd->bl.x);
	WFIFOW(src_sd->fd, 7) = SWAP16(sd->bl.y);
	WFIFOB(src_sd->fd, 9) = sd->status.side;
	WFIFOL(src_sd->fd, 10) = SWAP32(sd->status.id);

	if (sd->status.state < 4) {
		WFIFOW(src_sd->fd, 14) = SWAP16(sd->status.sex);
	}
	else {
		WFIFOB(src_sd->fd, 14) = 1;
		WFIFOB(src_sd->fd, 15) = 15;
	}

	if ((sd->status.state == 2 || (sd->optFlags & optFlag_stealth)) && sd->bl.id != src_sd->bl.id && (src_sd->status.gm_level || clif_isingroup(src_sd, sd) || (sd->gfx.dye == src_sd->gfx.dye && sd->gfx.dye != 0 && src_sd->gfx.dye != 0))) {
		WFIFOB(src_sd->fd, 16) = 5; //Gm's need to see invis
	}
	else {
		WFIFOB(src_sd->fd, 16) = sd->status.state;
	}

	if ((sd->optFlags & optFlag_stealth) && !sd->status.state && (!src_sd->status.gm_level || sd->bl.id == src_sd->bl.id))
		WFIFOB(src_sd->fd, 16) = 2;

	WFIFOB(src_sd->fd, 19) = sd->speed;

	if (sd->status.state == 3) {
		WFIFOW(src_sd->fd, 17) = SWAP16(sd->disguise);
		//WFIFOB(src_sd->fd,19)=sd->disguise_color;
	}
	else if (sd->status.state == 4) {
		WFIFOW(src_sd->fd, 17) = SWAP16(sd->disguise + 32768);
		WFIFOB(src_sd->fd, 19) = sd->disguise_color;
	}
	else {
		WFIFOW(src_sd->fd, 17) = SWAP16(0);
		//WFIFOB(src_sd->fd,19)=0;
	}

	WFIFOB(src_sd->fd, 20) = 0;

	WFIFOB(src_sd->fd, 21) = sd->status.face; //face
	WFIFOB(src_sd->fd, 22) = sd->status.hair; //hair
	WFIFOB(src_sd->fd, 23) = sd->status.hair_color; //hair color
	WFIFOB(src_sd->fd, 24) = sd->status.face_color;
	WFIFOB(src_sd->fd, 25) = sd->status.skin_color;

	//armor
	if (!pc_isequip(sd, EQ_ARMOR)) {
		WFIFOW(src_sd->fd, 26) = SWAP16(sd->status.sex);
	}
	else {
		if (sd->status.equip[EQ_ARMOR].customLook != 0) {
			WFIFOW(src_sd->fd, 26) = SWAP16(sd->status.equip[EQ_ARMOR].customLook);
		}
		else {
			WFIFOW(src_sd->fd, 26) = SWAP16(itemdb_look(pc_isequip(sd, EQ_ARMOR)));
		}

		if (sd->status.armor_color > 0) {
			WFIFOB(src_sd->fd, 28) = sd->status.armor_color;
		}
		else {
			if (sd->status.equip[EQ_ARMOR].customLook != 0) {
				WFIFOB(src_sd->fd, 28) = sd->status.equip[EQ_ARMOR].customLookColor;
			}
			else {
				WFIFOB(src_sd->fd, 28) = itemdb_lookcolor(pc_isequip(sd, EQ_ARMOR));
			}
		}
	}
	//coat
	if (pc_isequip(sd, EQ_COAT)) {
		WFIFOW(src_sd->fd, 26) = SWAP16(itemdb_look(pc_isequip(sd, EQ_COAT)));

		if (sd->status.armor_color > 0) {
			WFIFOB(src_sd->fd, 28) = sd->status.armor_color;
		}
		else {
			WFIFOB(src_sd->fd, 28) = itemdb_lookcolor(pc_isequip(sd, EQ_COAT));
		}
	}

	//weapon
	if (!pc_isequip(sd, EQ_WEAP)) {
		WFIFOW(src_sd->fd, 29) = 0xFFFF;
		WFIFOB(src_sd->fd, 31) = 0x0;
	}
	else {
		if (sd->status.equip[EQ_WEAP].customLook != 0) {
			WFIFOW(src_sd->fd, 29) = SWAP16(sd->status.equip[EQ_WEAP].customLook);
			WFIFOB(src_sd->fd, 31) = sd->status.equip[EQ_WEAP].customLookColor;
		}
		else {
			WFIFOW(src_sd->fd, 29) = SWAP16(itemdb_look(pc_isequip(sd, EQ_WEAP)));
			WFIFOB(src_sd->fd, 31) = itemdb_lookcolor(pc_isequip(sd, EQ_WEAP));
		}
	}

	//shield
	if (!pc_isequip(sd, EQ_SHIELD)) {
		WFIFOW(src_sd->fd, 32) = 0xFFFF;
		WFIFOB(src_sd->fd, 34) = 0;
	}
	else {
		if (sd->status.equip[EQ_SHIELD].customLook != 0) {
			WFIFOW(src_sd->fd, 32) = SWAP16(sd->status.equip[EQ_SHIELD].customLook);
			WFIFOB(src_sd->fd, 34) = sd->status.equip[EQ_SHIELD].customLookColor;
		}
		else {
			WFIFOW(src_sd->fd, 32) = SWAP16(itemdb_look(pc_isequip(sd, EQ_SHIELD)));
			WFIFOB(src_sd->fd, 34) = itemdb_lookcolor(pc_isequip(sd, EQ_SHIELD));
		}
	}

	if (!pc_isequip(sd, EQ_HELM) || !(sd->status.settingFlags & FLAG_HELM) || (itemdb_look(pc_isequip(sd, EQ_HELM)) == -1)) {
		//helm stuff goes here
		WFIFOB(src_sd->fd, 35) = 0; // supposed to be 1=Helm, 0=No helm
		WFIFOW(src_sd->fd, 36) = 0xFFFF; // supposed to be Helm num
	}
	else {
		WFIFOB(src_sd->fd, 35) = 1;
		if (sd->status.equip[EQ_HELM].customLook != 0) {
			WFIFOB(src_sd->fd, 36) = sd->status.equip[EQ_HELM].customLook;
			WFIFOB(src_sd->fd, 37) = sd->status.equip[EQ_HELM].customLookColor;
		}
		else {
			WFIFOB(src_sd->fd, 36) = itemdb_look(pc_isequip(sd, EQ_HELM));
			WFIFOB(src_sd->fd, 37) = itemdb_lookcolor(pc_isequip(sd, EQ_HELM));
		}
	}

	if (!pc_isequip(sd, EQ_FACEACC)) {
		//beard stuff
		WFIFOW(src_sd->fd, 38) = 0xFFFF;
		WFIFOB(src_sd->fd, 40) = 0;
	}
	else {
		WFIFOW(src_sd->fd, 38) = SWAP16(itemdb_look(pc_isequip(sd, EQ_FACEACC))); //beard num
		WFIFOB(src_sd->fd, 40) = itemdb_lookcolor(pc_isequip(sd, EQ_FACEACC)); //beard color
	}
	//crown
	if (!pc_isequip(sd, EQ_CROWN)) {
		WFIFOW(src_sd->fd, 41) = 0xFFFF;
		WFIFOB(src_sd->fd, 43) = 0;
	}
	else {
		WFIFOB(src_sd->fd, 35) = 0xFF;

		if (sd->status.equip[EQ_CROWN].customLook != 0) {
			WFIFOW(src_sd->fd, 41) = SWAP16(sd->status.equip[EQ_CROWN].customLook);
			WFIFOB(src_sd->fd, 43) = sd->status.equip[EQ_CROWN].customLookColor;
		}
		else {
			WFIFOW(src_sd->fd, 41) = SWAP16(itemdb_look(pc_isequip(sd, EQ_CROWN))); //Crown
			WFIFOB(src_sd->fd, 43) = itemdb_lookcolor(pc_isequip(sd, EQ_CROWN)); //Crown color
		}
	}

	if (!pc_isequip(sd, EQ_FACEACCTWO)) {
		WFIFOW(src_sd->fd, 44) = 0xFFFF; //second face acc
		WFIFOB(src_sd->fd, 46) = 0; //" color
	}
	else {
		WFIFOW(src_sd->fd, 44) = SWAP16(itemdb_look(pc_isequip(sd, EQ_FACEACCTWO)));
		WFIFOB(src_sd->fd, 46) = itemdb_lookcolor(pc_isequip(sd, EQ_FACEACCTWO));
	}

	if (!pc_isequip(sd, EQ_MANTLE)) {
		WFIFOW(src_sd->fd, 47) = 0xFFFF;
		WFIFOB(src_sd->fd, 49) = 0xFF;
	}
	else {
		WFIFOW(src_sd->fd, 47) = SWAP16(itemdb_look(pc_isequip(sd, EQ_MANTLE)));
		WFIFOB(src_sd->fd, 49) = itemdb_lookcolor(pc_isequip(sd, EQ_MANTLE));
	}
	if (!pc_isequip(sd, EQ_NECKLACE) || !(sd->status.settingFlags & FLAG_NECKLACE) || (itemdb_look(pc_isequip(sd, EQ_NECKLACE)) == -1)) {
		WFIFOW(src_sd->fd, 50) = 0xFFFF;
		WFIFOB(src_sd->fd, 52) = 0;
	}
	else {
		WFIFOW(src_sd->fd, 50) = SWAP16(itemdb_look(pc_isequip(sd, EQ_NECKLACE))); //necklace
		WFIFOB(src_sd->fd, 52) = itemdb_lookcolor(pc_isequip(sd, EQ_NECKLACE)); //neckalce color
	}
	if (!pc_isequip(sd, EQ_BOOTS)) {
		WFIFOW(src_sd->fd, 53) = SWAP16(sd->status.sex); //boots
		WFIFOB(src_sd->fd, 55) = 0;
	}
	else {
		if (sd->status.equip[EQ_BOOTS].customLook != 0) {
			WFIFOW(src_sd->fd, 53) = SWAP16(sd->status.equip[EQ_BOOTS].customLook);
			WFIFOB(src_sd->fd, 55) = sd->status.equip[EQ_BOOTS].customLookColor;
		}
		else {
			WFIFOW(src_sd->fd, 53) = SWAP16(itemdb_look(pc_isequip(sd, EQ_BOOTS)));
			WFIFOB(src_sd->fd, 55) = itemdb_lookcolor(pc_isequip(sd, EQ_BOOTS));
		}
	}

	// 56 color
	// 57 outline color   128 = black
	// 58 normal color when 56 & 57 set to 0

	WFIFOB(src_sd->fd, 56) = 0;
	WFIFOB(src_sd->fd, 57) = 128;
	WFIFOB(src_sd->fd, 58) = 0;

	if ((sd->status.state == 2 || (sd->optFlags & optFlag_stealth)) && sd->bl.id != src_sd->bl.id && (src_sd->status.gm_level || clif_isingroup(src_sd, sd) || (sd->gfx.dye == src_sd->gfx.dye && sd->gfx.dye != 0 && src_sd->gfx.dye != 0))) {
		WFIFOB(src_sd->fd, 56) = 0;
	}
	else {
		if (sd->gfx.dye) WFIFOB(src_sd->fd, 56) = sd->gfx.titleColor;
		else WFIFOB(src_sd->fd, 56) = 0;
	}

	sprintf(buf, "%s", sd->status.name);
	len = strlen(buf);

	if (src_sd->status.clan == sd->status.clan) {
		if (src_sd->status.clan > 0) {
			if (src_sd->status.id != sd->status.id) {
				WFIFOB(src_sd->fd, 58) = 3;
			}
		}
	}

	if (clif_isingroup(src_sd, sd)) {
		WFIFOB(src_sd->fd, 58) = 2;
	}

	for (x = 0; x < 20; x++) {
		if (src_sd->pvp[x][0] == sd->bl.id) {
			exist = x;
			break;
		}
	}

	if (sd->status.pk > 0 || exist != -1) {
		WFIFOB(src_sd->fd, 58) = 1;
	}

	if ((sd->status.state != 2) && (sd->status.state != 5)) {
		WFIFOB(src_sd->fd, 59) = len;
		strcpy(WFIFOP(src_sd->fd, 60), buf);
	}
	else {
		WFIFOB(src_sd->fd, 59) = 0;
		len = 0;
	}

	if ((sd->status.gm_level && sd->gfx.toggle) || sd->clone) {
		WFIFOB(src_sd->fd, 21) = sd->gfx.face;
		WFIFOB(src_sd->fd, 22) = sd->gfx.hair;
		WFIFOB(src_sd->fd, 23) = sd->gfx.chair;
		WFIFOB(src_sd->fd, 24) = sd->gfx.cface;
		WFIFOB(src_sd->fd, 25) = sd->gfx.cskin;
		WFIFOW(src_sd->fd, 26) = SWAP16(sd->gfx.armor);
		if (sd->gfx.dye > 0) {
			WFIFOB(src_sd->fd, 28) = sd->gfx.dye;
		}
		else {
			WFIFOB(src_sd->fd, 28) = sd->gfx.carmor;
		}
		WFIFOW(src_sd->fd, 29) = SWAP16(sd->gfx.weapon);
		WFIFOB(src_sd->fd, 31) = sd->gfx.cweapon;
		WFIFOW(src_sd->fd, 32) = SWAP16(sd->gfx.shield);
		WFIFOB(src_sd->fd, 34) = sd->gfx.cshield;

		if (sd->gfx.helm < 255) {
			WFIFOB(src_sd->fd, 35) = 1;
		}
		else if (sd->gfx.crown < 65535) {
			WFIFOB(src_sd->fd, 35) = 0xFF;
		}
		else {
			WFIFOB(src_sd->fd, 35) = 0;
		}

		WFIFOB(src_sd->fd, 36) = sd->gfx.helm;
		WFIFOB(src_sd->fd, 37) = sd->gfx.chelm;
		WFIFOW(src_sd->fd, 38) = SWAP16(sd->gfx.faceAcc);
		WFIFOB(src_sd->fd, 40) = sd->gfx.cfaceAcc;
		WFIFOW(src_sd->fd, 41) = SWAP16(sd->gfx.crown);
		WFIFOB(src_sd->fd, 43) = sd->gfx.ccrown;
		WFIFOW(src_sd->fd, 44) = SWAP16(sd->gfx.faceAccT);
		WFIFOB(src_sd->fd, 46) = sd->gfx.cfaceAccT;
		WFIFOW(src_sd->fd, 47) = SWAP16(sd->gfx.mantle);
		WFIFOB(src_sd->fd, 49) = sd->gfx.cmantle;
		WFIFOW(src_sd->fd, 50) = SWAP16(sd->gfx.necklace);
		WFIFOB(src_sd->fd, 52) = sd->gfx.cnecklace;
		WFIFOW(src_sd->fd, 53) = SWAP16(sd->gfx.boots);
		WFIFOB(src_sd->fd, 55) = sd->gfx.cboots;

		WFIFOB(src_sd->fd, 56) = 0;
		WFIFOB(src_sd->fd, 57) = 128;
		WFIFOB(src_sd->fd, 58) = 0;

		if ((sd->status.state == 2 || (sd->optFlags & optFlag_stealth)) && sd->bl.id != src_sd->bl.id && (src_sd->status.gm_level || clif_isingroup(src_sd, sd) || (sd->gfx.dye == src_sd->gfx.dye && sd->gfx.dye != 0 && src_sd->gfx.dye != 0))) {
			WFIFOB(src_sd->fd, 56) = 0;
		}
		else {
			if (sd->gfx.dye) WFIFOB(src_sd->fd, 56) = sd->gfx.titleColor;
			else WFIFOB(src_sd->fd, 56) = 0;

			/*switch(sd->gfx.dye) {
				case 60:
					WFIFOB(src_sd->fd,56)=8;
					break;
				case 61:
					WFIFOB(src_sd->fd,56)=15;
					break;
				case 63:
					WFIFOB(src_sd->fd,56)=4;
					break;
				case 66:
					WFIFOB(src_sd->fd,56)=1;
					break;

				default:
					WFIFOB(src_sd->fd,56)=0;
					break;
				}*/
		}

		len = strlen(sd->gfx.name);
		if ((sd->status.state != 2) && (sd->status.state != 5) && strcmpi(sd->gfx.name, "")) {
			WFIFOB(src_sd->fd, 59) = len;
			strcpy(WFIFOP(src_sd->fd, 60), sd->gfx.name);
		}
		else {
			WFIFOB(src_sd->fd, 59) = 0;
			len = 1;
		}

		/*len = strlen(sd->gfx.name);
		if (strcmpi(sd->gfx.name, "")) {
			WFIFOB(src_sd->fd, 59) = len;
			strcpy(WFIFOP(src_sd->fd, 60), sd->gfx.name);
		} else {
			WFIFOW(src_sd->fd,59) = 0;
			len = 1;
		}*/
	}

	WFIFOW(src_sd->fd, 1) = SWAP16(len + 60 + 3);

	WFIFOSET(src_sd->fd, encrypt(src_sd->fd));

	clif_sendanimations(src_sd, sd);

	return 0;
}

int clif_blockmovement(USER* sd, int flag) {
	nullpo_ret(0, sd);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 8);
	WFIFOHEADER(sd->fd, 0x51, 5);
	WFIFOB(sd->fd, 5) = flag;
	WFIFOB(sd->fd, 6) = 0;
	WFIFOB(sd->fd, 7) = 0;
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}
int clif_getchararea(USER* sd) {
	map_foreachinarea(clif_charlook_sub, sd->bl.m, sd->bl.x, sd->bl.y, SAMEAREA, BL_PC, LOOK_GET, sd);
	map_foreachinarea(clif_cnpclook_sub, sd->bl.m, sd->bl.x, sd->bl.y, SAMEAREA, BL_NPC, LOOK_GET, sd);
	map_foreachinarea(clif_cmoblook_sub, sd->bl.m, sd->bl.x, sd->bl.y, SAMEAREA, BL_MOB, LOOK_GET, sd);
	return 0;
}

int clif_getitemarea(USER* sd) {
	//map_foreachinarea(clif_object_look_sub,sd->bl.m,sd->bl.x,sd->bl.y,SAMEAREA,BL_ITEM,LOOK_GET,sd);

	return 0;
}

int clif_sendchararea(USER* sd) {
	map_foreachinarea(clif_charlook_sub, sd->bl.m, sd->bl.x, sd->bl.y, AREA, BL_PC, LOOK_SEND, sd);
	return 0;
}
int clif_charspecific(int sender, int id) {
	char buf[64];
	int len;
	int type;
	int x;
	USER* sd = NULL;
	USER* src_sd = NULL;
	//type=va_arg(ap, int);

	/*if (type==LOOK_GET) {
		nullpo_ret(0, sd=(USER*)bl);
		nullpo_ret(0, src_sd=va_arg(ap,USER*));
		if (src_sd==sd)
			return 0;
	} else {
		nullpo_ret(0, src_sd=(USER*)bl);
		nullpo_ret(0, sd=va_arg(ap,USER*));
	}
	*/
	nullpo_ret(0, sd = map_id2sd(sender));
	nullpo_ret(0, src_sd = map_id2sd(id));

	if ((sd->optFlags & optFlag_stealth) && (sd->bl.id != src_sd->bl.id) && (!src_sd->status.gm_level))
		return 0;

	if (map[sd->bl.m].show_ghosts && sd->status.state == 1 && (sd->bl.id != src_sd->bl.id)) {
		if (src_sd->status.state != 1 && !(src_sd->optFlags & optFlag_ghosts)) {
			return 0;
		}
	}

	//if (!clif_show_ghost(src_sd,sd)) return 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(src_sd->fd, 512);
	WFIFOB(src_sd->fd, 0) = 0xAA;
	WFIFOB(src_sd->fd, 3) = 0x33;
	WFIFOB(src_sd->fd, 4) = 0x03;
	WFIFOW(src_sd->fd, 5) = SWAP16(sd->bl.x);
	WFIFOW(src_sd->fd, 7) = SWAP16(sd->bl.y);
	WFIFOB(src_sd->fd, 9) = sd->status.side;
	WFIFOL(src_sd->fd, 10) = SWAP32(sd->status.id);
	if (sd->status.state < 4) {
		WFIFOW(src_sd->fd, 14) = SWAP16(sd->status.sex);
	}
	else {
		WFIFOB(src_sd->fd, 14) = 1;
		WFIFOB(src_sd->fd, 15) = 15;
	}

	if ((sd->status.state == 2 || sd->optFlags & optFlag_stealth) && sd->bl.id != src_sd->bl.id && (src_sd->status.gm_level || clif_isingroup(src_sd, sd) || (sd->gfx.dye == src_sd->gfx.dye && sd->gfx.dye != 0 && src_sd->gfx.dye != 0))) {
		WFIFOB(src_sd->fd, 16) = 5; //Gm's need to see invis
	}
	else {
		WFIFOB(src_sd->fd, 16) = sd->status.state;
	}

	if (sd->optFlags & optFlag_stealth && !sd->status.state && !src_sd->status.gm_level)WFIFOB(src_sd->fd, 16) = 2;

	WFIFOB(src_sd->fd, 19) = sd->speed;

	if (sd->status.state == 3) {
		WFIFOW(src_sd->fd, 17) = SWAP16(sd->disguise);
		//WFIFOB(src_sd->fd,19)=sd->disguise_color;
	}
	else if (sd->status.state == 4) {
		WFIFOW(src_sd->fd, 17) = SWAP16(sd->disguise + 32768);
		WFIFOB(src_sd->fd, 19) = sd->disguise_color;
	}
	else {
		WFIFOW(src_sd->fd, 17) = 0;
	}

	WFIFOB(src_sd->fd, 20) = 0;
	WFIFOB(src_sd->fd, 21) = sd->status.face; //face
	WFIFOB(src_sd->fd, 22) = sd->status.hair; //hair
	WFIFOB(src_sd->fd, 23) = sd->status.hair_color; //hair color
	WFIFOB(src_sd->fd, 24) = sd->status.face_color;
	WFIFOB(src_sd->fd, 25) = sd->status.skin_color;
	//WFIFOB(src_sd->fd,26)=0;
	//armor
	if (!pc_isequip(sd, EQ_ARMOR)) {
		WFIFOW(src_sd->fd, 26) = SWAP16(sd->status.sex);
	}
	else {
		if (sd->status.equip[EQ_ARMOR].customLook != 0) {
			WFIFOW(src_sd->fd, 26) = SWAP16(sd->status.equip[EQ_ARMOR].customLook);
		}
		else {
			WFIFOW(src_sd->fd, 26) = SWAP16(itemdb_look(pc_isequip(sd, EQ_ARMOR)));//-10000+16;
		}

		if (sd->status.armor_color > 0) {
			WFIFOB(src_sd->fd, 28) = sd->status.armor_color;
		}
		else {
			if (sd->status.equip[EQ_ARMOR].customLook != 0) {
				WFIFOB(src_sd->fd, 28) = sd->status.equip[EQ_ARMOR].customLookColor;
			}
			else {
				WFIFOB(src_sd->fd, 28) = itemdb_lookcolor(pc_isequip(sd, EQ_ARMOR));
			}
		}
	}
	if (pc_isequip(sd, EQ_COAT)) {
		WFIFOW(src_sd->fd, 26) = SWAP16(itemdb_look(pc_isequip(sd, EQ_COAT)));//-10000+16;
		WFIFOB(src_sd->fd, 28) = itemdb_lookcolor(pc_isequip(sd, EQ_COAT));
	}

	//weapon
	if (!pc_isequip(sd, EQ_WEAP)) {
		WFIFOW(src_sd->fd, 29) = 0xFFFF;
		WFIFOB(src_sd->fd, 31) = 0x0;
	}
	else {
		if (sd->status.equip[EQ_WEAP].customLook != 0) {
			WFIFOW(src_sd->fd, 29) = SWAP16(sd->status.equip[EQ_WEAP].customLook);
			WFIFOB(src_sd->fd, 31) = sd->status.equip[EQ_WEAP].customLookColor;
		}
		else {
			WFIFOW(src_sd->fd, 29) = SWAP16(itemdb_look(pc_isequip(sd, EQ_WEAP)));
			WFIFOB(src_sd->fd, 31) = itemdb_lookcolor(pc_isequip(sd, EQ_WEAP));
		}
	}

	//shield
	if (!pc_isequip(sd, EQ_SHIELD)) {
		WFIFOW(src_sd->fd, 32) = 0xFFFF;
		WFIFOB(src_sd->fd, 34) = 0;
	}
	else {
		if (sd->status.equip[EQ_SHIELD].customLook != 0) {
			WFIFOW(src_sd->fd, 32) = SWAP16(sd->status.equip[EQ_SHIELD].customLook);
			WFIFOB(src_sd->fd, 34) = sd->status.equip[EQ_SHIELD].customLookColor;
		}
		else {
			WFIFOW(src_sd->fd, 32) = SWAP16(itemdb_look(pc_isequip(sd, EQ_SHIELD)));
			WFIFOB(src_sd->fd, 34) = itemdb_lookcolor(pc_isequip(sd, EQ_SHIELD));
		}
	}

	if (!pc_isequip(sd, EQ_HELM) || !(sd->status.settingFlags & FLAG_HELM) || (itemdb_look(pc_isequip(sd, EQ_HELM)) == -1)) {
		//helm stuff goes here
		WFIFOB(src_sd->fd, 35) = 0; // supposed to be 1=Helm, 0=No helm
		WFIFOW(src_sd->fd, 36) = 0xFFFF; // supposed to be Helm num
	}
	else {
		WFIFOB(src_sd->fd, 35) = 1;

		if (sd->status.equip[EQ_HELM].customLook != 0) {
			WFIFOB(src_sd->fd, 36) = sd->status.equip[EQ_HELM].customLook;
			WFIFOB(src_sd->fd, 37) = sd->status.equip[EQ_HELM].customLookColor;
		}
		else {
			WFIFOB(src_sd->fd, 36) = itemdb_look(pc_isequip(sd, EQ_HELM));
			WFIFOB(src_sd->fd, 37) = itemdb_lookcolor(pc_isequip(sd, EQ_HELM));
		}
	}

	if (!pc_isequip(sd, EQ_FACEACC)) {
		//beard stuff
		WFIFOW(src_sd->fd, 38) = 0xFFFF;
		WFIFOB(src_sd->fd, 40) = 0x0;
	}
	else {
		WFIFOW(src_sd->fd, 38) = SWAP16(itemdb_look(pc_isequip(sd, EQ_FACEACC))); //beard num
		WFIFOB(src_sd->fd, 40) = itemdb_lookcolor(pc_isequip(sd, EQ_FACEACC)); //beard color
	}
	//crown
	if (!pc_isequip(sd, EQ_CROWN)) {
		WFIFOW(src_sd->fd, 41) = 0xFFFF;
		WFIFOB(src_sd->fd, 43) = 0x0;
	}
	else {
		WFIFOB(src_sd->fd, 35) = 0;

		if (sd->status.equip[EQ_CROWN].customLook != 0) {
			WFIFOW(src_sd->fd, 41) = SWAP16(sd->status.equip[EQ_CROWN].customLook); //Crown
			WFIFOB(src_sd->fd, 43) = sd->status.equip[EQ_CROWN].customLookColor; //Crown color
		}
		else {
			WFIFOW(src_sd->fd, 41) = SWAP16(itemdb_look(pc_isequip(sd, EQ_CROWN))); //Crown
			WFIFOB(src_sd->fd, 43) = itemdb_lookcolor(pc_isequip(sd, EQ_CROWN)); //Crown color
		}
	}

	if (!pc_isequip(sd, EQ_FACEACCTWO)) {
		WFIFOW(src_sd->fd, 44) = 0xFFFF; //second face acc
		WFIFOB(src_sd->fd, 46) = 0x0; //" color
	}
	else {
		WFIFOW(src_sd->fd, 44) = SWAP16(itemdb_look(pc_isequip(sd, EQ_FACEACCTWO)));
		WFIFOB(src_sd->fd, 46) = itemdb_lookcolor(pc_isequip(sd, EQ_FACEACCTWO));
	}

	if (!pc_isequip(sd, EQ_MANTLE)) {
		WFIFOW(src_sd->fd, 47) = 0xFFFF;
		WFIFOB(src_sd->fd, 49) = 0xFF;
	}
	else {
		WFIFOW(src_sd->fd, 47) = SWAP16(itemdb_look(pc_isequip(sd, EQ_MANTLE)));
		WFIFOB(src_sd->fd, 49) = itemdb_lookcolor(pc_isequip(sd, EQ_MANTLE));
	}
	if (!pc_isequip(sd, EQ_NECKLACE) || !(sd->status.settingFlags & FLAG_NECKLACE) || (itemdb_look(pc_isequip(sd, EQ_NECKLACE)) == -1)) {
		WFIFOW(src_sd->fd, 50) = 0xFFFF;
		WFIFOB(src_sd->fd, 52) = 0x0;
	}
	else {
		WFIFOW(src_sd->fd, 50) = SWAP16(itemdb_look(pc_isequip(sd, EQ_NECKLACE))); //necklace
		WFIFOB(src_sd->fd, 52) = itemdb_lookcolor(pc_isequip(sd, EQ_NECKLACE)); //neckalce color
	}
	if (!pc_isequip(sd, EQ_BOOTS)) {
		WFIFOW(src_sd->fd, 53) = SWAP16(sd->status.sex); //boots
		WFIFOB(src_sd->fd, 55) = 0x0;
	}
	else {
		if (sd->status.equip[EQ_BOOTS].customLook != 0) {
			WFIFOW(src_sd->fd, 53) = SWAP16(sd->status.equip[EQ_BOOTS].customLook);
			WFIFOB(src_sd->fd, 55) = sd->status.equip[EQ_BOOTS].customLookColor;
		}
		else {
			WFIFOW(src_sd->fd, 53) = SWAP16(itemdb_look(pc_isequip(sd, EQ_BOOTS)));
			WFIFOB(src_sd->fd, 55) = itemdb_lookcolor(pc_isequip(sd, EQ_BOOTS));
		}
	}

	WFIFOB(src_sd->fd, 56) = 0;
	WFIFOB(src_sd->fd, 57) = 128;
	WFIFOB(src_sd->fd, 58) = 0;

	if ((sd->status.state == 2 || (sd->optFlags & optFlag_stealth)) && sd->bl.id != src_sd->bl.id && (src_sd->status.gm_level || clif_isingroup(src_sd, sd) || (sd->gfx.dye == src_sd->gfx.dye && sd->gfx.dye != 0 && src_sd->gfx.dye != 0))) {
		WFIFOB(src_sd->fd, 56) = 0;
	}
	else {
		if (sd->gfx.dye) WFIFOB(src_sd->fd, 56) = sd->gfx.titleColor;
		else WFIFOB(src_sd->fd, 56) = 0;

		/*switch(sd->gfx.dye) {
			case 60:
				WFIFOB(src_sd->fd,56)=8;
				break;
			case 61:
				WFIFOB(src_sd->fd,56)=15;
				break;
			case 63:
				WFIFOB(src_sd->fd,56)=4;
				break;
			case 66:
				WFIFOB(src_sd->fd,56)=1;
				break;

			default:
				WFIFOB(src_sd->fd,56)=0;
				break;
			}*/
	}

	sprintf(buf, "%s", sd->status.name);

	len = strlen(buf);

	if (src_sd->status.clan == sd->status.clan) {
		if (src_sd->status.clan > 0) {
			if (src_sd->status.id != sd->status.id) {
				WFIFOB(src_sd->fd, 56) = 3;
			}
		}
	}

	if (clif_isingroup(src_sd, sd)) {
		WFIFOB(src_sd->fd, 56) = 2;
	}
	//if(sd->status.gm_level>1) {
//		WFIFOB(src_sd->fd,56)=1;
//	}

	if ((sd->status.state != 2) && (sd->status.state != 5)) {
		WFIFOB(src_sd->fd, 57) = len;
		strcpy(WFIFOP(src_sd->fd, 58), buf);
	}
	else {
		WFIFOW(src_sd->fd, 57) = 0;
		len = 1;
	}

	if ((sd->status.gm_level && sd->gfx.toggle) || sd->clone) {
		WFIFOB(src_sd->fd, 21) = sd->gfx.face;
		WFIFOB(src_sd->fd, 22) = sd->gfx.hair;
		WFIFOB(src_sd->fd, 23) = sd->gfx.chair;
		WFIFOB(src_sd->fd, 24) = sd->gfx.cface;
		WFIFOB(src_sd->fd, 25) = sd->gfx.cskin;
		WFIFOW(src_sd->fd, 26) = SWAP16(sd->gfx.armor);
		if (sd->gfx.dye > 0) {
			WFIFOB(src_sd->fd, 28) = sd->gfx.dye;
		}
		else {
			WFIFOB(src_sd->fd, 28) = sd->gfx.carmor;
		}
		WFIFOW(src_sd->fd, 29) = SWAP16(sd->gfx.weapon);
		WFIFOB(src_sd->fd, 31) = sd->gfx.cweapon;
		WFIFOW(src_sd->fd, 32) = SWAP16(sd->gfx.shield);
		WFIFOB(src_sd->fd, 34) = sd->gfx.cshield;

		if (sd->gfx.helm < 65535) {
			WFIFOB(src_sd->fd, 35) = 1;
		}
		else if (sd->gfx.crown < 65535) {
			WFIFOB(src_sd->fd, 35) = 0xFF;
		}
		else {
			WFIFOB(src_sd->fd, 35) = 0;
		}

		WFIFOB(src_sd->fd, 36) = sd->gfx.helm;

		WFIFOB(src_sd->fd, 37) = sd->gfx.chelm;
		WFIFOW(src_sd->fd, 38) = SWAP16(sd->gfx.faceAcc);
		WFIFOB(src_sd->fd, 40) = sd->gfx.cfaceAcc;
		WFIFOW(src_sd->fd, 41) = SWAP16(sd->gfx.crown);
		WFIFOB(src_sd->fd, 43) = sd->gfx.ccrown;
		WFIFOW(src_sd->fd, 44) = SWAP16(sd->gfx.faceAccT);
		WFIFOB(src_sd->fd, 46) = sd->gfx.cfaceAccT;
		WFIFOW(src_sd->fd, 47) = SWAP16(sd->gfx.mantle);
		WFIFOB(src_sd->fd, 49) = sd->gfx.cmantle;
		WFIFOW(src_sd->fd, 50) = SWAP16(sd->gfx.necklace);
		WFIFOB(src_sd->fd, 52) = sd->gfx.cnecklace;
		WFIFOW(src_sd->fd, 53) = SWAP16(sd->gfx.boots);
		WFIFOB(src_sd->fd, 55) = sd->gfx.cboots;

		len = strlen(sd->gfx.name);
		if ((sd->status.state != 2) && (sd->status.state != 5) && strcmpi(sd->gfx.name, "")) {
			WFIFOB(src_sd->fd, 57) = len;
			strcpy(WFIFOP(src_sd->fd, 58), sd->gfx.name);
		}
		else {
			WFIFOB(src_sd->fd, 57) = 0;
			len = 1;
		}

		/*len = strlen(sd->gfx.name);
		if (strcmpi(sd->gfx.name, "")) {
			WFIFOB(src_sd->fd, 57) = len;
			strcpy(WFIFOP(src_sd->fd, 58), sd->gfx.name);
		} else {
			WFIFOW(src_sd->fd,57) = 0;
			len = 1;
		}*/
	}

	WFIFOW(src_sd->fd, 1) = SWAP16(len + 55);
	WFIFOSET(src_sd->fd, encrypt(src_sd->fd));

	return 0;
}

int clif_sendack(USER* sd) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 255);
	WFIFOB(sd->fd, 0) = 0xAA;
	//WFIFOB(sd->fd, 1) = 0x00;
	//WFIFOB(sd->fd, 2) = 0x05;
	WFIFOB(sd->fd, 3) = 0x1E;
	//WFIFOB(sd->fd, 4) = 0x00;
	//WFIFOB(sd->fd, 5) = 0x48;
	WFIFOB(sd->fd, 5) = 0x06;
	WFIFOB(sd->fd, 6) = 0x00;
	WFIFOW(sd->fd, 1) = SWAP16(0x06);
	//WFIFOB(sd->fd, 6) = 0x65;
	//WFIFOB(sd->fd, 7) = 0x78;
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_retrieveprofile(USER* sd) {
	//retrieve profile
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x04;
	WFIFOB(sd->fd, 3) = 0x49;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOW(sd->fd, 5) = 0;
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_screensaver(USER* sd, int screen) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 4 + 3);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(0x04);
	WFIFOB(sd->fd, 3) = 0x5A;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0x00;
	WFIFOB(sd->fd, 6) = screen; //screensaver
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_sendtime(USER* sd) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 7);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x04;
	WFIFOB(sd->fd, 3) = 0x20;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = cur_time; //current time
	WFIFOB(sd->fd, 6) = cur_year; //current year
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_sendid(USER* sd) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 17);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x0E;
	WFIFOB(sd->fd, 3) = 0x05;
	//WFIFOB(sd->fd, 4) = 0x03;
	WFIFOL(sd->fd, 5) = SWAP32(sd->status.id);
	WFIFOW(sd->fd, 9) = 0;
	WFIFOB(sd->fd, 11) = 0;
	WFIFOB(sd->fd, 12) = 2;
	WFIFOB(sd->fd, 13) = 3;
	WFIFOW(sd->fd, 14) = SWAP16(0);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}
int clif_sendweather(USER* sd) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 6);
	WFIFOHEADER(sd->fd, 0x1F, 3);
	WFIFOB(sd->fd, 5) = 0;
	if (sd->status.settingFlags & FLAG_WEATHER) WFIFOB(sd->fd, 5) = map[sd->bl.m].weather;
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_sendmapinfo(USER* sd) {
	char len;

	if (!sd) return 0;
	//Map Title and Map X-Y
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 100);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x15;
	//WFIFOB(sd->fd, 4) = 0x03;
	WFIFOW(sd->fd, 5) = SWAP16(sd->bl.m);
	WFIFOW(sd->fd, 7) = SWAP16(map[sd->bl.m].xs);
	WFIFOW(sd->fd, 9) = SWAP16(map[sd->bl.m].ys);
	WFIFOB(sd->fd, 11) = 5;

	if (sd->status.settingFlags & FLAG_WEATHER) WFIFOB(sd->fd, 11) = 4; //Weather
	//if(!sd->status.gm_level) WFIFOB(sd->fd,11)=5;
	if (sd->status.settingFlags & FLAG_REALM) {
		WFIFOB(sd->fd, 12) = 0x01;
	}
	else {
		WFIFOB(sd->fd, 12) = 0x00;
	}
	len = strlen(map[sd->bl.m].title);
	WFIFOB(sd->fd, 13) = len;
	memcpy(WFIFOP(sd->fd, 14), map[sd->bl.m].title, len);

	WFIFOW(sd->fd, len + 14) = SWAP16(map[sd->bl.m].light);
	if (!map[sd->bl.m].light) WFIFOW(sd->fd, len + 14) = SWAP16(232);

	/*WFIFOB(sd->fd,len+14)= 0x00;
	WFIFOB(sd->fd,len+15)=map[sd->bl.m].light;
	if(!map[sd->bl.m].light) WFIFOB(sd->fd,len+15)=232;*/
	//WFIFOW(sd->fd,len+14)=SWAP16(map[sd->bl.m].light);
	//if(!map[sd->bl.m].light) WFIFOW(sd->fd,len+14)=SWAP16(232);

	WFIFOW(sd->fd, 1) = SWAP16(18 + len);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	//Map BGM
	/*WFIFOHEAD(sd->fd,100);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x14;
	WFIFOB(sd->fd, 3) = 0x19;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 1; //1
	WFIFOB(sd->fd, 6) = 0;//0
	WFIFOW(sd->fd, 7) = SWAP16(map[sd->bl.m].bgm);
	WFIFOB(sd->fd, 9) = 0;//0
	WFIFOB(sd->fd, 10) = 0;//0
	WFIFOB(sd->fd, 11) = 0xC0;//C0
	WFIFOL(sd->fd, 12) = SWAP32(88); //Settings?
	WFIFOB(sd->fd, 16) = 1;//1
	WFIFOB(sd->fd, 17) = 0;//0
	WFIFOB(sd->fd, 18) = 2;//2
	WFIFOB(sd->fd, 19) = 2;//2
	WFIFOB(sd->fd, 20) = 0;//0
	WFIFOB(sd->fd, 21) = 4;//4
	WFIFOB(sd->fd, 22) = 0;//0
	WFIFOSET(sd->fd, encrypt(sd->fd));*/

	clif_sendweather(sd);

	WFIFOHEAD(sd->fd, 100);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x12;
	WFIFOB(sd->fd, 3) = 0x19;
	WFIFOB(sd->fd, 5) = map[sd->bl.m].bgmtype; //1  1 = mp3/lsr, 2 = mid
	//WFIFOB(sd->fd, 6) = 5;//0 // doesnt appear to do shit but who knows
	WFIFOW(sd->fd, 7) = SWAP16(map[sd->bl.m].bgm);
	WFIFOW(sd->fd, 9) = SWAP16(map[sd->bl.m].bgm); // this had the same exact field info as field 7,8..  not sure why they are doing this twice.   (might be to tell it to play the next song?)
	WFIFOB(sd->fd, 11) = 0x64;
	WFIFOL(sd->fd, 12) = SWAP32(sd->status.settingFlags);
	WFIFOB(sd->fd, 16) = 0;//1
	WFIFOB(sd->fd, 17) = 0;//0
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_sendxy(USER* sd) {
	int subt[1];
	subt[0] = 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	/*

		Field:     Character:        Decimal:         Hex Value:
		0                               170              AA
		1                               0              00
		2                               13              0D
		3                               4              04
		4             +                 43                2B
		5                               0              00
		6                               5              05
		7                               0              00
		8                               8              08
		9                               0              00
		10                               8              08
		11                               0              00
		12                               10              0A
		13             !                 33                21
		14                               193              C1
		15                               168              A8

	*/

	WFIFOHEAD(sd->fd, 14);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(0x0D);
	WFIFOB(sd->fd, 3) = 0x04;

	WFIFOW(sd->fd, 5) = SWAP16(sd->bl.x);
	WFIFOW(sd->fd, 7) = SWAP16(sd->bl.y);

	//WFIFOW(sd->fd,9) = SWAP16(  (int)((16-map[sd->bl.m].xs)/2) + sd->bl.x );
	//WFIFOW(sd->fd,11) = SWAP16(  (int)((14-map[sd->bl.m].ys)/2) + sd->bl.y );

	if (map[sd->bl.m].xs >= 16) {
		if (sd->bl.x < 8)
			WFIFOW(sd->fd, 9) = SWAP16(sd->bl.x);
		else if (sd->bl.x >= map[sd->bl.m].xs - 8)
			WFIFOW(sd->fd, 9) = SWAP16(sd->bl.x - map[sd->bl.m].xs + 17);
		else
			WFIFOW(sd->fd, 9) = SWAP16(8);
	}
	else WFIFOW(sd->fd, 9) = SWAP16((int)((16 - map[sd->bl.m].xs) / 2) + sd->bl.x);

	if (map[sd->bl.m].ys >= 14) {
		if (sd->bl.y < 7)
			WFIFOW(sd->fd, 11) = SWAP16(sd->bl.y);
		else if (sd->bl.y >= map[sd->bl.m].ys - 7)
			WFIFOW(sd->fd, 11) = SWAP16(sd->bl.y - map[sd->bl.m].ys + 15);
		else
			WFIFOW(sd->fd, 11) = SWAP16(7);
	}
	else WFIFOW(sd->fd, 11) = SWAP16((int)((14 - map[sd->bl.m].ys) / 2) + sd->bl.y);

	WFIFOB(sd->fd, 13) = 0x00;
	WFIFOSET(sd->fd, encrypt(sd->fd));

	pc_runfloor_sub(sd);

	return 0;
}

int clif_sendxynoclick(USER* sd) {
	int subt[1];
	subt[0] = 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 14);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(0x0D);
	WFIFOB(sd->fd, 3) = 0x04;
	//WFIFOB(sd->fd, 4) = 0x03;
	WFIFOW(sd->fd, 5) = SWAP16(sd->bl.x);
	WFIFOW(sd->fd, 7) = SWAP16(sd->bl.y);

	if (map[sd->bl.m].xs >= 16) {
		if (sd->bl.x < 8)
			WFIFOW(sd->fd, 9) = SWAP16(sd->bl.x);
		else if (sd->bl.x >= map[sd->bl.m].xs - 8)
			WFIFOW(sd->fd, 9) = SWAP16(sd->bl.x - map[sd->bl.m].xs + 17);
		else
			WFIFOW(sd->fd, 9) = SWAP16(8);
	}
	else WFIFOW(sd->fd, 9) = SWAP16((int)((16 - map[sd->bl.m].xs) / 2) + sd->bl.x);

	if (map[sd->bl.m].ys >= 14) {
		if (sd->bl.y < 7)
			WFIFOW(sd->fd, 11) = SWAP16(sd->bl.y);
		else if (sd->bl.y >= map[sd->bl.m].ys - 7)
			WFIFOW(sd->fd, 11) = SWAP16(sd->bl.y - map[sd->bl.m].ys + 15);
		else
			WFIFOW(sd->fd, 11) = SWAP16(7);
	}
	else WFIFOW(sd->fd, 11) = SWAP16((int)((14 - map[sd->bl.m].ys) / 2) + sd->bl.y);

	WFIFOB(sd->fd, 13) = 0x00;
	WFIFOSET(sd->fd, encrypt(sd->fd));

	pc_runfloor_sub(sd);

	return 0;
}

int clif_sendxychange(USER* sd, int dx, int dy) {
	nullpo_ret(0, sd);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 14);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x0A;
	WFIFOB(sd->fd, 3) = 0x04;
	WFIFOW(sd->fd, 5) = SWAP16(sd->bl.x);
	WFIFOW(sd->fd, 7) = SWAP16(sd->bl.y);

	if (sd->bl.x - dx < 0)
		dx--;
	else if (sd->bl.x + (16 - dx) >= map[sd->bl.m].xs)
		dx++;

	WFIFOW(sd->fd, 9) = SWAP16(dx);
	sd->viewx = dx;

	if (sd->bl.y - dy < 0)
		dy--;
	else if (sd->bl.y + (14 - dy) >= map[sd->bl.m].ys)
		dy++;

	WFIFOW(sd->fd, 11) = SWAP16(dy);
	sd->viewy = dy;

	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_sendstatus(USER* sd, int flags) {
	int f = flags | SFLAG_ALWAYSON;
	int tnl = clif_getLevelTNL(sd);
	int len = 0;
	nullpo_ret(0, sd);
	float percentage = clif_getXPBarPercent(sd);

	nullpo_ret(0, sd);

	if (sd->status.gm_level && sd->optFlags & optFlag_walkthrough)
		f |= SFLAG_GMON;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 63);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = OUT_STATUS;
	//WFIFOB(sd->fd,4)=0x03;
	WFIFOB(sd->fd, 5) = f;

	if (f & SFLAG_FULLSTATS) {
		WFIFOB(sd->fd, 6) = 0; //Unknown
		WFIFOB(sd->fd, 7) = sd->status.country;//Nation
		WFIFOB(sd->fd, 8) = sd->status.totem;// -- Totem -- 0=JuJak, 1= Baekho, 2=Hyun Moo, 3=Chung Ryong, 4=Nothing
		WFIFOB(sd->fd, 9) = 0; //Unknown
		WFIFOB(sd->fd, 10) = sd->status.level;
		WFIFOL(sd->fd, 11) = SWAP32(sd->max_hp);
		WFIFOL(sd->fd, 15) = SWAP32(sd->max_mp);
		WFIFOB(sd->fd, 19) = sd->might;
		WFIFOB(sd->fd, 20) = sd->will;
		WFIFOB(sd->fd, 21) = 0x03;
		WFIFOB(sd->fd, 22) = 0x03;
		WFIFOB(sd->fd, 23) = sd->grace;
		WFIFOB(sd->fd, 24) = 0;
		WFIFOB(sd->fd, 25) = 0;
		WFIFOB(sd->fd, 26) = sd->armor; //AC
		WFIFOB(sd->fd, 27) = 0;
		WFIFOB(sd->fd, 28) = 0;
		WFIFOB(sd->fd, 29) = 0;
		WFIFOB(sd->fd, 30) = 0;
		WFIFOB(sd->fd, 31) = 0;
		WFIFOB(sd->fd, 32) = 0;
		WFIFOB(sd->fd, 33) = 0;
		WFIFOB(sd->fd, 34) = sd->status.maxinv;
		len += 29;
	}

	if (f & SFLAG_HPMP) {
		WFIFOL(sd->fd, len + 6) = SWAP32(sd->status.hp);
		WFIFOL(sd->fd, len + 10) = SWAP32(sd->status.mp);
		len += 8;
	}

	if (f & SFLAG_XPMONEY) {
		WFIFOL(sd->fd, len + 6) = SWAP32(sd->status.exp);
		WFIFOL(sd->fd, len + 10) = SWAP32(sd->status.money);
		WFIFOB(sd->fd, len + 14) = (int)percentage; //exp percent
		len += 9;
	}

	WFIFOB(sd->fd, len + 6) = sd->drunk; // drunk
	WFIFOB(sd->fd, len + 7) = sd->blind; //blind
	WFIFOB(sd->fd, len + 8) = 0;
	WFIFOB(sd->fd, len + 9) = 0; // hear self/others
	WFIFOB(sd->fd, len + 10) = 0;
	WFIFOB(sd->fd, len + 11) = sd->flags; //1=New parcel, 16=new Message, 17=New Parcel + Message
	WFIFOB(sd->fd, len + 12) = 0; //nothing
	WFIFOL(sd->fd, len + 13) = SWAP32(sd->status.settingFlags);
	len += 11;

	WFIFOW(sd->fd, 1) = SWAP16(len + 3);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	if (sd->group_count > 0) {
		clif_grouphealth_update(sd);
	}

	return 0;
}

int clif_sendoptions(USER* sd) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 12);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(9);
	WFIFOB(sd->fd, 3) = 0x23;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0;
	if (sd->status.settingFlags & FLAG_WEATHER) WFIFOB(sd->fd, 5) = 1; //Weather
	WFIFOB(sd->fd, 6) = 0;
	if (sd->status.settingFlags & FLAG_MAGIC) WFIFOB(sd->fd, 6) = 1; //magic
	WFIFOB(sd->fd, 7) = 0;
	if (sd->status.settingFlags & FLAG_ADVICE) WFIFOB(sd->fd, 7) = 1; //Advice
	WFIFOB(sd->fd, 8) = 0;
	if (sd->status.settingFlags & FLAG_FASTMOVE) WFIFOB(sd->fd, 8) = 1;
	WFIFOB(sd->fd, 9) = 0;
	if (sd->status.settingFlags & FLAG_SOUND) WFIFOB(sd->fd, 9) = 1; //sound!
	WFIFOB(sd->fd, 10) = 0;
	if (sd->status.settingFlags & FLAG_HELM) WFIFOB(sd->fd, 10) = 1; //Helm
	WFIFOB(sd->fd, 11) = 0;
	if (sd->status.settingFlags & FLAG_REALM) WFIFOB(sd->fd, 11) = 1;//realm?
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_spawn(USER* sd) {
	if (map_addblock(&sd->bl)) printf("Error Spawn\n");
	clif_sendchararea(sd);
	return 0;
}

int clif_parsewalk(USER* sd) {
	int moveblock;
	int dx, dy, xold, yold, c = 0;
	struct warp_list* x = NULL;
	int x0 = 0, y0 = 0, x1 = 0, y1 = 0, direction = 0;
	unsigned short checksum = 0;
	int xcheck, ycheck;
	//int speed=0;
	char* buf = NULL;
	int def[2];
	int subt[1];
	int i = 0;

	subt[0] = 0;
	def[0] = 0;
	def[1] = 0;

	//if (map_readglobalreg(sd->bl.m,"blackout") != 0) clif_refreshmap(sd);

	//speed = RFIFOB(sd->fd,7);

	//if ((speed != sd->speed || (speed != 80 && sd->status.state != 3)) && !sd->status.gm_level)
		//printf("Name: %s Speed Sent: %d, Char Speed: %d\n", sd->status.name, speed, sd->speed);

	//if (sd->LastWalk && RFIFOB(sd->fd, 6) == sd->LastWalk) {
	//	clif_Hacker(sd->status.name, "Walk Editing.");
	//	session[sd->fd]->eof = 14;
	//	return 0;
	//}

	/*float speed = (float)sd->speed;
	float factor = 330 * (speed/100);
	unsigned long time_buff = (unsigned long)(factor + 0.5f);
	unsigned long difftick = DIFF_TICK(gettick(),sd->LastWalkTick);

	//printf("difftick: %lu  time_buff: %lu\n",difftick,time_buff);

	sd->LastWalkTick = gettick();
	if (difftick <= time_buff && !sd->status.gm_level) return 0;*/

	if (!map[sd->bl.m].canMount && sd->status.state == 3 && !sd->status.gm_level) sl_doscript_blargs("onDismount", NULL, 1, &sd->bl);

	direction = RFIFOB(sd->fd, 5);

	xold = dx = SWAP16(RFIFOW(sd->fd, 8));
	yold = dy = SWAP16(RFIFOW(sd->fd, 10));

	if (RFIFOB(sd->fd, 3) == 6) {
		x0 = SWAP16(RFIFOW(sd->fd, 12));
		y0 = SWAP16(RFIFOW(sd->fd, 14));
		x1 = RFIFOB(sd->fd, 16);
		y1 = RFIFOB(sd->fd, 17);
		checksum = SWAP16(RFIFOW(sd->fd, 18));
	}

	if (dx != sd->bl.x) {
		clif_blockmovement(sd, 0);
		map_moveblock(&sd->bl, sd->bl.x, sd->bl.y);
		clif_sendxy(sd);
		clif_blockmovement(sd, 1);
		return 0;
	}

	if (dy != sd->bl.y) {
		clif_blockmovement(sd, 0);
		map_moveblock(&sd->bl, sd->bl.x, sd->bl.y);
		clif_sendxy(sd);
		clif_blockmovement(sd, 1);
		return 0;
	}

	sd->canmove = 0;

	switch (direction) {
	case 0:
		dy--;
		break;
	case 1:
		dx++;
		break;
	case 2:
		dy++;
		break;
	case 3:
		dx--;
		break;
	}

	if (dx < 0) dx = 0;
	if (dx >= map[sd->bl.m].xs) dx = map[sd->bl.m].xs - 1;
	if (dy < 0) dy = 0;
	if (dy >= map[sd->bl.m].ys) dy = map[sd->bl.m].ys - 1;

	if (!sd->status.gm_level) {
		map_foreachincell(clif_canmove_sub, sd->bl.m, dx, dy, BL_PC, sd);
		map_foreachincell(clif_canmove_sub, sd->bl.m, dx, dy, BL_MOB, sd);
		map_foreachincell(clif_canmove_sub, sd->bl.m, dx, dy, BL_NPC, sd);
		if (read_pass(sd->bl.m, dx, dy)) sd->canmove = 1;
	}

	//map_foreachincell(clif_canmove_sub,sd->bl.m,dx,dy,BL_NPC,sd);
	if ((sd->canmove || sd->paralyzed || sd->sleep != 1.0f || sd->snare) && !sd->status.gm_level) {
		clif_blockmovement(sd, 0);
		clif_sendxy(sd);
		clif_blockmovement(sd, 1);
		return 0;
	}

	if (direction == 0 && (dy <= sd->viewy || ((map[sd->bl.m].ys - 1 - dy) < 7 && sd->viewy > 7))) sd->viewy--;
	if (direction == 1 && ((dx < 8 && sd->viewx < 8) || 16 - (map[sd->bl.m].xs - 1 - dx) <= sd->viewx)) sd->viewx++;
	if (direction == 2 && ((dy < 7 && sd->viewy < 7) || 14 - (map[sd->bl.m].ys - 1 - dy) <= sd->viewy)) sd->viewy++;
	if (direction == 3 && (dx <= sd->viewx || ((map[sd->bl.m].xs - 1 - dx) < 8 && sd->viewx > 8))) sd->viewx--;
	if (sd->viewx < 0) sd->viewx = 0;
	if (sd->viewx > 16) sd->viewx = 16;
	if (sd->viewy < 0) sd->viewy = 0;
	if (sd->viewy > 14) sd->viewy = 14;

	//Fast Walk shit, will flag later.
	if (!(sd->status.settingFlags & FLAG_FASTMOVE)) {
		if (!session[sd->fd])
		{
			session[sd->fd]->eof = 8;
			return 0;
		}

		WFIFOHEAD(sd->fd, 15);
		WFIFOB(sd->fd, 0) = 0xAA;
		WFIFOB(sd->fd, 1) = 0x00;
		WFIFOB(sd->fd, 2) = 0x0C;
		WFIFOB(sd->fd, 3) = 0x26;
		//WFIFOB(sd->fd, 4) = 0x03;
		WFIFOB(sd->fd, 5) = direction;
		WFIFOW(sd->fd, 6) = SWAP16(xold);
		WFIFOW(sd->fd, 8) = SWAP16(yold);
		//if (x0 > 0 && x0 < map[sd->bl.m].xs - 1) {
		//if ((dx >= 0 && dx <= sd->viewx) || (dx <= map[sd->bl.m].xs - 1 && dx >= map[sd->bl.m].xs - 1 - abs(sd->viewx - 16))) {
		WFIFOW(sd->fd, 10) = SWAP16(sd->viewx);
		//} else {
		//	WFIFOW(sd->fd, 10) = SWAP16(dx);
		//}
		//if (y0 > 0 && y0 < map[sd->bl.m].xs - 1) {
		//if ((dy >= 0 && dy <= sd->viewy) || (dy <= map[sd->bl.m].ys - 1 && dy >= map[sd->bl.m].ys - 1 - abs(sd->viewy - 14))) {
		WFIFOW(sd->fd, 12) = SWAP16(sd->viewy);
		//} else {
		//	WFIFOW(sd->fd, 12) = SWAP16(dy);
		//}
		/*if (RFIFOB(sd->fd, 3) == 0x06) {
			WFIFOW(sd->fd, 10) = SWAP16(8);
			WFIFOW(sd->fd, 12) = SWAP16(7);
		} else {
			WFIFOW(sd->fd, 10) = SWAP16(dx);
			WFIFOW(sd->fd, 12) = SWAP16(dy);
		}*/

		WFIFOB(sd->fd, 14) = 0x00;
		WFIFOSET(sd->fd, encrypt(sd->fd));
	}

	if (dx == sd->bl.x && dy == sd->bl.y)
		return 0;

	CALLOC(buf, char, 32);
	WBUFB(buf, 0) = 0xAA;
	WBUFB(buf, 1) = 0x00;
	WBUFB(buf, 2) = 0x0C;
	WBUFB(buf, 3) = 0x0C;
	//WBUFB(buf, 4) = 0x03;//nowhere
	WBUFL(buf, 5) = SWAP32(sd->status.id);
	WBUFW(buf, 9) = SWAP16(xold);
	WBUFW(buf, 11) = SWAP16(yold);
	WBUFB(buf, 13) = direction;
	WBUFB(buf, 14) = 0x00;
	//crypt(WBUFP(buf, 0));
	if (sd->optFlags & optFlag_stealth) {
		clif_sendtogm(buf, 32, &sd->bl, AREA_WOS);
	}
	else {
		clif_send(buf, 32, &sd->bl, AREA_WOS); //come back
	}
	FREE(buf);

	//moveblock = (sd->bl.x/BLOCK_SIZE != dx/BLOCK_SIZE || sd->bl.y/BLOCK_SIZE != dy/BLOCK_SIZE);

	//if(moveblock)
	map_moveblock(&sd->bl, dx, dy);
	//if(moveblock) map_addblock(&sd->bl);

	if (RFIFOB(sd->fd, 3) == 0x06) {
		clif_sendmapdata(sd, sd->bl.m, x0, y0, x1, y1, checksum);
		//this is where all the "finding" code goes

		clif_mob_look_start(sd);

		map_foreachinblock(clif_object_look_sub, sd->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_ALL, LOOK_GET, sd);
		//map_foreachinarea(clif_mob_look_sub,sd->bl.m,x0,y0,x0+(x1-1),y0+(y1-1),SAMEAREA, BL_MOB,LOOK_GET,sd);
		//map_foreachinblock(clif_itemlook_sub2,sd->bl.m,x0,y0,x0+(x1-1),y0+(y1-1),BL_ALL,LOOK_GET,def,sd);
		clif_mob_look_close(sd);
		map_foreachinblock(clif_charlook_sub, sd->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_GET, sd);
		map_foreachinblock(clif_cnpclook_sub, sd->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_NPC, LOOK_GET, sd);
		map_foreachinblock(clif_cmoblook_sub, sd->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_MOB, LOOK_GET, sd);
		map_foreachinblock(clif_charlook_sub, sd->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_SEND, sd);
	}

	if (session[sd->fd]->eof)printf("%s eof set on.  19", sd->status.name);

	for (i = 0; i < 14; i++) {
		if (sd->status.equip[i].id > 0) {
			sl_doscript_blargs(itemdb_yname(sd->status.equip[i].id), "on_walk", 1, &sd->bl);
		}
	}

	for (i = 0; i < MAX_SPELLS; i++) {
		if (sd->status.skill[i] > 0) {
			sl_doscript_blargs(magicdb_yname(sd->status.skill[i]), "on_walk_passive", 1, &sd->bl);
		}
	}

	for (i = 0; i < MAX_MAGIC_TIMERS; i++) {
		if (sd->status.dura_aether[i].id > 0 && sd->status.dura_aether[i].duration > 0) {
			sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[i].id), "on_walk_while_cast", 1, &sd->bl);
		}
	}

	sl_doscript_blargs("onScriptedTile", NULL, 1, &sd->bl);
	pc_runfloor_sub(sd);
	//map_foreachincell(pc_runfloor_sub,sd->bl.m,sd->bl.x,sd->bl.y,BL_NPC,sd,0,subt);
	int fm = 0, fx = 0, fy = 0;
	int zm = 0, zx = 0, zy = 0;
	fm = sd->bl.m;
	fx = sd->bl.x;
	fy = sd->bl.y;
	if (fx >= map[fm].xs) fx = map[fm].xs - 1;
	if (fy >= map[fm].ys) fy = map[fm].ys - 1;
	for (x = map[fm].warp[fx / BLOCK_SIZE + (fy / BLOCK_SIZE) * map[fm].bxs]; x && !c; x = x->next) {
		if (x->x == fx && x->y == fy) {
			zm = x->tm;
			zx = x->tx;
			zy = x->ty;
			c = 1;
		}
	}

	/*zm=map[fm].warp[fx+fy*map[fm].xs].tm;
	zx=map[fm].warp[fx+fy*map[fm].xs].tx;
	zy=map[fm].warp[fx+fy*map[fm].xs].ty;
	*/
	if (zx || zy || zm) {
		if ((sd->status.level < map[zm].reqlvl || (sd->status.basehp < map[zm].reqvita && sd->status.basemp < map[zm].reqmana) || sd->status.mark < map[zm].reqmark || (map[zm].reqpath > 0 && sd->status.class != map[zm].reqpath)) && sd->status.gm_level == 0) {
			clif_pushback(sd);

			if (strcmpi(map[zm].maprejectmsg, "") == 0) {
				if (abs(map[zm].reqlvl - sd->status.level) >= 10) { clif_sendminitext(sd, "Nightmarish visions of your own death repel you."); }
				else if (abs(map[zm].reqlvl - sd->status.level) >= 5 && map[zm].reqlvl - sd->status.level < 10) { clif_sendminitext(sd, "You're not quite ready to enter yet."); }
				else if (abs(map[zm].reqlvl - sd->status.level) < 5) { clif_sendminitext(sd, "You almost understand the secrets to this entrance."); }
				else if (sd->status.mark < map[zm].reqmark) { clif_sendminitext(sd, "You do not understand the secrets to enter."); }
				else if (map[zm].reqpath > 0 && sd->status.class != map[zm].reqpath) { clif_sendminitext(sd, "Your path forbids it."); }
				else {
					clif_sendminitext(sd, "A powerful force repels you.");
				}
			}
			else { clif_sendminitext(sd, map[zm].maprejectmsg); }

			return 0;
		}
		if ((sd->status.level > map[zm].lvlmax || (sd->status.basehp > map[zm].vitamax && sd->status.basemp > map[zm].manamax)) && sd->status.gm_level == 0) {
			clif_pushback(sd);
			clif_sendminitext(sd, "A magical barrier prevents you from entering.");
			return 0;
		}

		pc_warp(sd, zm, zx, zy);
		//sd->LastWalkTick = 0;
	}

	//sd->canmove=0;
	//sd->iswalking=0;

	return 0;
}

int clif_noparsewalk(USER* sd, char speed) {
	int moveblock;
	char nothingnew;
	char flag;
	int dx, dy, xold, yold, c = 0;
	struct warp_list* x = NULL;
	int x0 = 0, y0 = 0, x1 = 0, y1 = 0, direction = 0;
	int xcheck, ycheck;
	unsigned short m = sd->bl.m;
	char* buf = NULL;
	int def[2];
	int subt[1];
	subt[0] = 0;
	def[0] = 0;
	def[1] = 0;

	xold = dx = sd->bl.x;
	yold = dy = sd->bl.y;

	if (dx != sd->bl.x) {
		clif_blockmovement(sd, 0);
		map_moveblock(&sd->bl, sd->bl.x, sd->bl.y);
		clif_sendxy(sd);
		clif_blockmovement(sd, 1);
		return 0;
	}

	if (dy != sd->bl.y) {
		clif_blockmovement(sd, 0);
		map_moveblock(&sd->bl, sd->bl.x, sd->bl.y);
		clif_sendxy(sd);
		clif_blockmovement(sd, 1);
		return 0;
	}

	//x0 = sd->bl.x;
	//y0 = sd->bl.y;

	if (!map[sd->bl.m].canMount && sd->status.state == 3 && !sd->status.gm_level) sl_doscript_blargs("onDismount", NULL, 1, &sd->bl);

	direction = sd->status.side;

	switch (direction) {
	case 0:
		dy--;
		x0 = sd->bl.x - (sd->viewx + 1);
		y0 = dy - (sd->viewy + 1);
		x1 = 19;
		y1 = 1;
		break;
	case 1:
		dx++;
		x0 = dx + (18 - (sd->viewx + 1));
		y0 = sd->bl.y - (sd->viewy + 1);
		x1 = 1;
		y1 = 17;
		break;
	case 2:
		dy++;
		x0 = sd->bl.x - (sd->viewx + 1);
		y0 = dy + (16 - (sd->viewy + 1));
		x1 = 19;
		y1 = 1;
		break;
	case 3:
		dx--;
		x0 = dx - (sd->viewx + 1);
		y0 = sd->bl.y - (sd->viewy + 1);
		x1 = 1;
		y1 = 17;
		break;
	}

	if (dx < 0) dx = 0;
	if (dx >= map[m].xs) dx = map[m].xs - 1;
	if (dy < 0) dy = 0;
	if (dy >= map[m].ys) dy = map[m].ys - 1;
	sd->canmove = 0;

	if (!sd->status.gm_level) {
		map_foreachincell(clif_canmove_sub, m, dx, dy, BL_PC, sd);
		map_foreachincell(clif_canmove_sub, m, dx, dy, BL_MOB, sd);
		map_foreachincell(clif_canmove_sub, m, dx, dy, BL_NPC, sd);
		if (read_pass(m, dx, dy)) sd->canmove = 1;
	}

	if (sd->canmove || sd->paralyzed || sd->sleep != 1.0f || sd->snare) {
		clif_blockmovement(sd, 0);
		clif_sendxy(sd);
		clif_blockmovement(sd, 1);
		return 0;
	}

	if (dx == sd->bl.x && dy == sd->bl.y)
		return 0;

	if (direction == 0 && (dy <= sd->viewy || ((map[m].ys - 1 - dy) < 7 && sd->viewy > 7))) sd->viewy--;
	if (direction == 1 && ((dx < 8 && sd->viewx < 8) || 16 - (map[m].xs - 1 - dx) <= sd->viewx)) sd->viewx++;
	if (direction == 2 && ((dy < 7 && sd->viewy < 7) || 14 - (map[m].ys - 1 - dy) <= sd->viewy)) sd->viewy++;
	if (direction == 3 && (dx <= sd->viewx || ((map[m].xs - 1 - dx) < 8 && sd->viewx > 8))) sd->viewx--;
	if (sd->viewx < 0) sd->viewx = 0;
	if (sd->viewx > 16) sd->viewx = 16;
	if (sd->viewy < 0) sd->viewy = 0;
	if (sd->viewy > 14) sd->viewy = 14;

	if (sd->status.settingFlags & FLAG_FASTMOVE) {
		sd->status.settingFlags ^= FLAG_FASTMOVE;
		clif_sendstatus(sd, NULL);
		flag = 1;
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 15);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x0C;
	WFIFOB(sd->fd, 3) = 0x26;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = direction;
	WFIFOW(sd->fd, 6) = SWAP16(xold);
	WFIFOW(sd->fd, 8) = SWAP16(yold);
	WFIFOW(sd->fd, 10) = SWAP16(sd->viewx);
	WFIFOW(sd->fd, 12) = SWAP16(sd->viewy);
	WFIFOB(sd->fd, 14) = 0x00;
	WFIFOSET(sd->fd, encrypt(sd->fd));

	if (flag == 1) {
		sd->status.settingFlags ^= FLAG_FASTMOVE;
		clif_sendstatus(sd, NULL);
		flag = 0;
	}

	CALLOC(buf, char, 32);
	WBUFB(buf, 0) = 0xAA;
	WBUFB(buf, 1) = 0x00;
	WBUFB(buf, 2) = 0x0C;
	WBUFB(buf, 3) = 0x0C;
	WBUFL(buf, 5) = SWAP32(sd->status.id);
	WBUFW(buf, 9) = SWAP16(xold);
	WBUFW(buf, 11) = SWAP16(yold);
	WBUFB(buf, 13) = direction;
	WBUFB(buf, 14) = 0x00;

	if (sd->optFlags & optFlag_stealth) {
		clif_sendtogm(buf, 32, &sd->bl, AREA_WOS);
	}
	else {
		clif_send(buf, 32, &sd->bl, AREA_WOS);
	}
	FREE(buf);

	map_moveblock(&sd->bl, dx, dy);

	if (x0 >= 0 && y0 >= 0 && x0 + (x1 - 1) < map[m].xs && y0 + (y1 - 1) < map[m].ys) {
		clif_sendmapdata(sd, m, x0, y0, x1, y1, 0);
		clif_mob_look_start(sd);
		map_foreachinblock(clif_object_look_sub, m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_ALL, LOOK_GET, sd);
		clif_mob_look_close(sd);
		map_foreachinblock(clif_charlook_sub, m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_GET, sd);
		map_foreachinblock(clif_cnpclook_sub, m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_NPC, LOOK_GET, sd);
		map_foreachinblock(clif_cmoblook_sub, m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_MOB, LOOK_GET, sd);
		map_foreachinblock(clif_charlook_sub, m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_SEND, sd);
	}

	if (session[sd->fd]->eof) printf("%s eof set on.  19", sd->status.name);

	sl_doscript_blargs("onScriptedTile", NULL, 1, &sd->bl);
	pc_runfloor_sub(sd);
	//map_foreachincell(pc_runfloor_sub, sd->bl.m, sd->bl.x, sd->bl.y, BL_NPC, sd, 0, subt);
	int fm = 0, fx = 0, fy = 0;
	int zm = 0, zx = 0, zy = 0;
	fm = sd->bl.m;
	fx = sd->bl.x;
	fy = sd->bl.y;
	if (fx >= map[fm].xs) fx = map[fm].xs - 1;
	if (fy >= map[fm].ys) fy = map[fm].ys - 1;
	for (x = map[fm].warp[fx / BLOCK_SIZE + (fy / BLOCK_SIZE) * map[fm].bxs]; x && !c; x = x->next) {
		if (x->x == fx && x->y == fy) {
			zm = x->tm;
			zx = x->tx;
			zy = x->ty;
			c = 1;
		}
	}

	if (zx || zy || zm) {
		if ((sd->status.level < map[zm].reqlvl || (sd->status.basehp < map[zm].reqvita && sd->status.basemp < map[zm].reqmana) || sd->status.mark < map[zm].reqmark || (map[zm].reqpath > 0 && sd->status.class != map[zm].reqpath)) && sd->status.gm_level == 0) {
			clif_pushback(sd);

			if (strcmpi(map[zm].maprejectmsg, "") == 0) {
				if (abs(map[zm].reqlvl - sd->status.level) >= 10) { clif_sendminitext(sd, "Nightmarish visions of your own death repel you."); }
				else if (abs(map[zm].reqlvl - sd->status.level) >= 5 && map[zm].reqlvl - sd->status.level < 10) { clif_sendminitext(sd, "You're not quite ready to enter yet."); }
				else if (abs(map[zm].reqlvl - sd->status.level) < 5) { clif_sendminitext(sd, "You almost understand the secrets to this entrance."); }
				else if (sd->status.mark < map[zm].reqmark) { clif_sendminitext(sd, "You do not understand the secrets to enter."); }
				else if (map[zm].reqpath > 0 && sd->status.class != map[zm].reqpath) { clif_sendminitext(sd, "Your path forbids it."); }
				else {
					clif_sendminitext(sd, "A powerful force repels you.");
				}
			}
			else { clif_sendminitext(sd, map[zm].maprejectmsg); }

			return 0;
		}
		if ((sd->status.level > map[zm].lvlmax || (sd->status.basehp > map[zm].vitamax && sd->status.basemp > map[zm].manamax)) && sd->status.gm_level == 0) {
			clif_pushback(sd);
			clif_sendminitext(sd, "A magical barrier prevents you from entering.");
			return 0;
		}

		//sd->LastWalkTick = 0;
		pc_warp(sd, zm, zx, zy);
	}

	return 1;
}

int clif_guitextsd(char* msg, USER* sd) {
	int len = 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 0);
	WFIFOB(sd->fd, 0) = 0xAA; // Packet Delimiter
	WFIFOB(sd->fd, 1) = 0x00; // Always 0
	WFIFOB(sd->fd, 3) = 0x58; // Packet ID
	//WFIFOB(fd, 4) = 0x00; // Always 0
	WFIFOB(sd->fd, 5) = 0x06; // Always 6
	//WFIFOB(sd->fd, 6) = 0x00; // Always 0
	//WFIFOB(sd->fd, 7) = strlen(msg);

	WFIFOW(sd->fd, 6) = SWAP16(strlen(msg));
	memcpy(WFIFOP(sd->fd, 8), msg, strlen(msg));

	WFIFOW(sd->fd, 1) = SWAP16(8 + strlen(msg) + 3);

	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_guitext(struct block_list* bl, va_list ap) {
	USER* sd = NULL;
	char* msg = NULL;
	//char buf[256];
	int len = 0;

	nullpo_ret(0, sd = (USER*)bl);

	msg = va_arg(ap, char*);
	len = strlen(msg);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 0);
	WFIFOB(sd->fd, 0) = 0xAA; // Packet Delimiter
	WFIFOB(sd->fd, 1) = 0x00; // Always 0
	WFIFOB(sd->fd, 3) = 0x58; // Packet ID
	//WFIFOB(fd, 4) = 0x00; // Always 0
	WFIFOB(sd->fd, 5) = 0x06; // Always 6
	//WFIFOB(sd->fd, 6) = 0x00; // Always 0
	//WFIFOB(sd->fd, 7) = strlen(msg);

	WFIFOW(sd->fd, 6) = SWAP16(strlen(msg));
	memcpy(WFIFOP(sd->fd, 8), msg, strlen(msg));

	WFIFOW(sd->fd, 1) = SWAP16(8 + strlen(msg) + 3);

	WFIFOSET(sd->fd, encrypt(sd->fd));
}

int sendRewardParcel(USER* sd, int eventid, int rank, int rewarditem, int rewardamount) {
	//printf("eventid: %i, rank: %i, rewardname: %s, rewarditmid: %i, rewardamount: %i\n",eventid,rank,reward,rewarditem,rewardamount);

	int success = 0;

	int i = 0;
	int pos = -1;
	int newest = -1;
	char escape[255];
	char engrave[31];

	sprintf(escape, "%s,\nCongratulations on attaining Rank %i!\nHere is your reward: (%i) %s", sd->status.name, rank, rewardamount, itemdb_name(rewarditem));

	strcpy(engrave, itemdb_name(rewarditem));

	int receiver = sd->status.id;
	int sender = 1;
	int owner = 0;
	char npcflag = 1;

	SqlStmt* stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return 1;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ParPosition` FROM `Parcels` WHERE `ParChaIdDestination` = '%u'", receiver)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &pos, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		return 1;
	}

	if (SqlStmt_NumRows(stmt) > 0) {
		for (i = 0; i < SqlStmt_NumRows(stmt) && SQL_SUCCESS == SqlStmt_NextRow(stmt); i++) {
			if (pos > newest) {
				newest = pos;
			}
		}
	}

	newest += 1;
	SqlStmt_Free(stmt);
	Sql_EscapeString(sql_handle, escape, engrave);

	if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `Parcels` (`ParChaIdDestination`, `ParSender`, `ParItmId`, `ParAmount`, `ParChaIdOwner`, `ParEngrave`, `ParPosition`, `ParNpc`) VALUES ('%u', '%u', '%u', '%u', '%u', '%s', '%d', '%d')",
		receiver, sender, rewarditem, rewardamount, owner, engrave, newest, npcflag)) {
		Sql_ShowDebug(sql_handle);
		success = 0;
		return 1;
	}

	else success = 1;

	/*if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `SendParcelLogs` (`SpcSender`, `SpcMapId`, `SpcX`, `SpcY`, `SpcItmId`, `SpcAmount`, `SpcChaIdDestination`, `SpcNpc`) VALUES ('%u', '%u', '%u', '%u', '%u', '%u', '%u', '%d')",
	sender, 0, 0, 0, rewarditem, rewardamount, receiver, npcflag)) {
		Sql_ShowDebug(sql_handle);
		success = 0;
		return 1;
				}
	else success = 1;*/

	return success;
}

int clif_getReward(USER* sd, int fd) {
	int eventid = RFIFOB(fd, 7);

	char legend[17];
	char reward[19];
	char reward1[19];
	char reward2[19];
	char eventname[41];

	char legendbuf[255];
	char msg[80];
	char monthyear[7];
	char season[7];

	int legendicon = 0, legendiconcolor = 0, legendicon1 = 0, legendicon1color = 0, legendicon2 = 0, legendicon2color = 0, legendicon3 = 0, legendicon3color = 0, legendicon4 = 0, legendicon4color = 0, legendicon5 = 0, legendicon5color = 0, reward1amount = 0, reward2amount = 0, rewardamount = 0, reward1item = 0, reward2item = 0;
	int rewardranks = 0;
	int rank = 0;
	int _1stPlaceReward1_ItmId = 0, _1stPlaceReward1_Amount = 0, _1stPlaceReward2_ItmId = 0, _1stPlaceReward2_Amount = 0, _2ndPlaceReward1_ItmId = 0, _2ndPlaceReward1_Amount = 0, _2ndPlaceReward2_ItmId = 0, _2ndPlaceReward2_Amount = 0, _3rdPlaceReward1_ItmId = 0, _3rdPlaceReward1_Amount = 0, _3rdPlaceReward2_ItmId = 0, _3rdPlaceReward2_Amount = 0, _4thPlaceReward1_ItmId = 0, _4thPlaceReward1_Amount = 0, _4thPlaceReward2_ItmId = 0, _4thPlaceReward2_Amount = 0, _5thPlaceReward1_ItmId = 0, _5thPlaceReward1_Amount = 0, _5thPlaceReward2_ItmId = 0, _5thPlaceReward2_Amount = 0;

	char message[4000];
	char topic[52];
	char rankname[4];

	sprintf(monthyear, "Moon %i", cur_year);

	SqlStmt* stmt;
	stmt = SqlStmt_Malloc(sql_handle);
	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `EventName`, `EventLegend`, `EventRewardRanks_Display`, `EventLegend`, `EventLegendIcon1`, `EventLegendIcon1Color`, `EventLegendIcon2`, `EventLegendIcon2Color`, `EventLegendIcon3`, `EventLegendIcon3Color`, `EventLegendIcon4`, `EventLegendIcon4Color`, `EventLegendIcon5`, `EventLegendIcon5Color`, `1stPlaceReward1_ItmId`, `1stPlaceReward1_Amount`, `1stPlaceReward2_ItmId`, `1stPlaceReward2_Amount`, `2ndPlaceReward1_ItmId`, `2ndPlaceReward1_Amount`, `2ndPlaceReward2_ItmId`, `2ndPlaceReward2_Amount`, `3rdPlaceReward1_ItmId`, `3rdPlaceReward1_Amount`, `3rdPlaceReward2_ItmId`, `3rdPlaceReward2_Amount`, `4thPlaceReward1_ItmId`, `4thPlaceReward1_Amount`, `4thPlaceReward2_ItmId`, `4thPlaceReward2_Amount`, `5thPlaceReward1_ItmId`, `5thPlaceReward1_Amount`, `5thPlaceReward2_ItmId`, `5thPlaceReward2_Amount` FROM `RankingEvents` WHERE `EventId` = '%u'", eventid)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &eventname, sizeof(eventname), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_STRING, &legend, sizeof(legend), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_INT, &rewardranks, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_STRING, &legend, sizeof(legend), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 4, SQLDT_INT, &legendicon1, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 5, SQLDT_INT, &legendicon1color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 6, SQLDT_INT, &legendicon2, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 7, SQLDT_INT, &legendicon2color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 8, SQLDT_INT, &legendicon3, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 9, SQLDT_INT, &legendicon3color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 10, SQLDT_INT, &legendicon4, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 11, SQLDT_INT, &legendicon4color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 12, SQLDT_INT, &legendicon5, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 13, SQLDT_INT, &legendicon5color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 14, SQLDT_INT, &_1stPlaceReward1_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 15, SQLDT_INT, &_1stPlaceReward1_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 16, SQLDT_INT, &_1stPlaceReward2_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 17, SQLDT_INT, &_1stPlaceReward2_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 18, SQLDT_INT, &_2ndPlaceReward1_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 19, SQLDT_INT, &_2ndPlaceReward1_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 20, SQLDT_INT, &_2ndPlaceReward2_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 21, SQLDT_INT, &_2ndPlaceReward2_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 22, SQLDT_INT, &_3rdPlaceReward1_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 23, SQLDT_INT, &_3rdPlaceReward1_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 24, SQLDT_INT, &_3rdPlaceReward2_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 25, SQLDT_INT, &_3rdPlaceReward2_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 26, SQLDT_INT, &_4thPlaceReward1_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 27, SQLDT_INT, &_4thPlaceReward1_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 28, SQLDT_INT, &_4thPlaceReward2_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 29, SQLDT_INT, &_4thPlaceReward2_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 30, SQLDT_INT, &_5thPlaceReward1_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 31, SQLDT_INT, &_5thPlaceReward1_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 32, SQLDT_INT, &_5thPlaceReward2_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 33, SQLDT_INT, &_5thPlaceReward2_Amount, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	} // end if statement

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	SqlStmt_Free;

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `Rank` FROM `RankingScores` WHERE `ChaId` = '%i' AND `EventId` = '%i'", sd->status.id, eventid)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &rank, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	} // end if statement

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	SqlStmt_Free;

	if (cur_season == 1) { strcpy(season, "Winter"); }
	if (cur_season == 2) { strcpy(season, "Spring"); }
	if (cur_season == 3) { strcpy(season, "Summer"); }
	if (cur_season == 4) { strcpy(season, "Fall"); }

	if (rank == 1) strcpy(rankname, "1st");
	if (rank == 2) strcpy(rankname, "2nd");
	if (rank == 3) strcpy(rankname, "3rd");
	if (rank == 4) strcpy(rankname, "4th");
	if (rank == 5) strcpy(rankname, "5th");
	if (rank == 6) strcpy(rankname, "6th");

	switch (rank) {
	case 1: sprintf(legendbuf, "%s [%s] (Moon %i, %s)", legend, rankname, cur_year, season); legendicon = legendicon1; legendiconcolor = legendicon1color; reward1item = _1stPlaceReward1_ItmId; reward1amount = _1stPlaceReward1_Amount; reward2item = _1stPlaceReward2_ItmId; reward2amount = _1stPlaceReward2_Amount; break;
	case 2: sprintf(legendbuf, "%s [%s] (Moon %i, %s)", legend, rankname, cur_year, season); legendicon = legendicon2; legendiconcolor = legendicon2color; reward1item = _2ndPlaceReward1_ItmId; reward1amount = _2ndPlaceReward1_Amount; reward2item = _2ndPlaceReward2_ItmId; reward2amount = _2ndPlaceReward2_Amount; break;
	case 3: sprintf(legendbuf, "%s [%s] (Moon %i, %s)", legend, rankname, cur_year, season); legendicon = legendicon3; legendiconcolor = legendicon3color; reward1item = _3rdPlaceReward1_ItmId; reward1amount = _3rdPlaceReward1_Amount; reward2item = _3rdPlaceReward2_ItmId; reward2amount = _3rdPlaceReward2_Amount; break;
	case 4: sprintf(legendbuf, "%s [%s] (Moon %i, %s)", legend, rankname, cur_year, season); legendicon = legendicon4; legendiconcolor = legendicon4color; reward1item = _4thPlaceReward1_ItmId; reward1amount = _4thPlaceReward1_Amount; reward2item = _4thPlaceReward2_ItmId; reward2amount = _4thPlaceReward2_Amount; break;
	case 5: sprintf(legendbuf, "%s [%s] (Moon %i, %s)", legend, rankname, cur_year, season); legendicon = legendicon5; legendiconcolor = legendicon5color; reward1item = _5thPlaceReward1_ItmId; reward1amount = _5thPlaceReward1_Amount; reward2item = _5thPlaceReward2_ItmId; reward2amount = _5thPlaceReward2_Amount; break;
	default: sprintf(legendbuf, "%s [%s] (Moon %i, %s)", legend, rankname, cur_year, season); legendicon = legendicon5; legendiconcolor = legendicon5color; reward1item = _5thPlaceReward1_ItmId; reward1amount = _5thPlaceReward1_Amount; reward2item = _5thPlaceReward2_ItmId; reward2amount = _5thPlaceReward2_Amount; break;
	}

	for (int i = 0; i < MAX_LEGENDS; i++) {
		if (strcmp(sd->status.legends[i].name, "") == 0 && strcmpi(sd->status.legends[i + 1].name, "") == 0) {
			strcpy(sd->status.legends[i].text, legendbuf);
			sprintf(sd->status.legends[i].name, "Event %i Place: %i", eventid, rank);
			sd->status.legends[i].icon = legendicon;
			sd->status.legends[i].color = legendiconcolor;
			break;
		}
	}

	sprintf(topic, "%s Prize", eventname);

	int sentParcelSuccess = 0;

	if (reward1amount >= 1 && reward2amount >= 1) {
		sentParcelSuccess = sendRewardParcel(sd, eventid, rank, reward1item, reward1amount);
		sentParcelSuccess += sendRewardParcel(sd, eventid, rank, reward2item, reward2amount);
	}
	if (reward1amount >= 1 && reward2amount == 0) { sentParcelSuccess = sendRewardParcel(sd, eventid, rank, reward1item, reward1amount); }

	//printf("parcelsuccess: %i\n",sentParcelSuccess);
	if (sentParcelSuccess == 2) {
		if (rank == 1) {
			sprintf(message, "Congratulations on winning the %s Event, %s!\n\nYou have been rewarded: (%i) %s, (%i) %s.\n\nPlease continue to play for more great rewards!", eventname, sd->status.name, reward1amount, itemdb_name(reward1item), reward2amount, itemdb_name(reward2item));
			sprintf(msg, "Congratulations on winning the event, %s! Please visit your post office to collect your winnings.", sd->status.name);
			nmail_sendmail(sd, sd->status.name, topic, message);
		}

		else {
			sprintf(message, "Thanks for participating in the %s Event, %s.\n\nRank:%s Place\n\nYou have been rewarded: (%i) %s, (%i) %s.\n\nPlease continue to play for more great rewards!", eventname, sd->status.name, rankname, reward1amount, itemdb_name(reward1item), reward2amount, itemdb_name(reward2item));
			sprintf(msg, "Thanks for participating in the Event, %s! Please visit your post office to collect your winnings.", sd->status.name);
			nmail_sendmail(sd, sd->status.name, topic, message);
		}
	}

	if (sentParcelSuccess == 1) {
		if (rank == 1) {
			sprintf(message, "Congratulations on winning the %s Event, %s!\n\nYou have been rewarded: (%i) %s.\n\nPlease continue to play for more great rewards!", eventname, sd->status.name, reward1amount, itemdb_name(reward1item));
			sprintf(msg, "Congratulations on winning the event, %s! Please visit your post office to collect your winnings.", sd->status.name);
			nmail_sendmail(sd, sd->status.name, topic, message);
		}

		else {
			sprintf(message, "Thanks for participating in the %s Event, %s.\n\nRank:%s Place\n\nYou have been rewarded: (%i) %s.\n\nPlease continue to play for more great rewards!", eventname, sd->status.name, rankname, reward1amount, itemdb_name(reward1item));
			sprintf(msg, "Thanks for participating in the event, %s. Please visit your post office to collect your winnings.", sd->status.name);
			nmail_sendmail(sd, sd->status.name, topic, message);
		}
	}

	if (sentParcelSuccess == 0) sprintf(msg, "Sorry %s, there was an error encountered while attempting to send your rewards in a parcel. Please contact a GM for assistance.", sd->status.name);

	clif_sendmsg(sd, 0, msg);

	if (sentParcelSuccess >= 1) {  // This function disables the reward after character claims. Will only function if items were claimed successfully prior
		if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `RankingScores` SET `EventClaim` = 2 WHERE `EventId` = '%u' AND `ChaId` = '%u'", eventid, sd->status.id)) {
			Sql_ShowDebug(sql_handle);
			return -1; //db error
		}
		if (SQL_SUCCESS != Sql_NextRow(sql_handle)) {
			Sql_FreeResult(sql_handle);
			clif_parseranking(sd, fd);
			return 0;  //name is free
		}
	}

	return 0;
}

int clif_sendRewardInfo(USER* sd, int fd) {
	WFIFOHEAD(fd, 0);
	WFIFOB(fd, 0) = 0xAA;
	WFIFOB(fd, 1) = 0x01;
	WFIFOB(fd, 3) = 0x7D;
	WFIFOB(fd, 5) = 0x05;
	WFIFOB(fd, 6) = 0;
	WFIFOB(fd, 7) = RFIFOB(fd, 7);
	WFIFOB(fd, 8) = 142;
	WFIFOB(fd, 9) = 227;
	WFIFOB(fd, 10) = 0;
	WFIFOB(fd, 12) = 1;

	//unsigned char cappacket[] = {0xAA, 0x01, 0x36, 0x7D, 0x25, 0x05, 0x00, 0xF5, 0xDC, 0x3D, 0x00, 0x05, 0x01, 0x31, 0x01, 0x31, 0x15, 0x54, 0x47, 0x20, 0x44, 0x61, 0x69, 0x6C, 0x79, 0x20, 0x31, 0x73, 0x74, 0x20, 0x28, 0x48, 0x79, 0x75, 0x6C, 0x38, 0x34, 0x29, 0x07, 0x80, 0x02, 0x12, 0x31, 0x30, 0x30, 0x20, 0x44, 0x61, 0x72, 0x6B, 0x20, 0x61, 0x6D, 0x62, 0x65, 0x72, 0x20, 0x62, 0x61, 0x67, 0x00, 0x00, 0x00, 0x0A, 0xC8, 0xB8, 0x01, 0x0F, 0x53, 0x6B, 0x69, 0x6C, 0x6C, 0x20, 0x6D, 0x6F, 0x64, 0x75, 0x6C, 0x61, 0x74, 0x6F, 0x72, 0x00, 0x00, 0x00, 0x01, 0xD1, 0x5D, 0x00, 0x01, 0x32, 0x01, 0x32, 0x15, 0x54, 0x47, 0x20, 0x44, 0x61, 0x69, 0x6C, 0x79, 0x20, 0x32, 0x6E, 0x64, 0x20, 0x28, 0x48, 0x79, 0x75, 0x6C, 0x38, 0x34, 0x29, 0x07, 0x80, 0x01, 0x12, 0x31, 0x30, 0x30, 0x20, 0x44, 0x61, 0x72, 0x6B, 0x20, 0x61, 0x6D, 0x62, 0x65, 0x72, 0x20, 0x62, 0x61, 0x67, 0x00, 0x00, 0x00, 0x08, 0xC8, 0xB8, 0x01, 0x01, 0x33, 0x01, 0x33, 0x15, 0x54, 0x47, 0x20, 0x44, 0x61, 0x69, 0x6C, 0x79, 0x20, 0x33, 0x72, 0x64, 0x20, 0x28, 0x48, 0x79, 0x75, 0x6C, 0x38, 0x34, 0x29, 0x07, 0x80, 0x01, 0x12, 0x31, 0x30, 0x30, 0x20, 0x44, 0x61, 0x72, 0x6B, 0x20, 0x61, 0x6D, 0x62, 0x65, 0x72, 0x20, 0x62, 0x61, 0x67, 0x00, 0x00, 0x00, 0x06, 0xC8, 0xB8, 0x01, 0x01, 0x34, 0x03, 0x32, 0x30, 0x25, 0x16, 0x54, 0x47, 0x20, 0x45, 0x78, 0x63, 0x65, 0x6C, 0x6C, 0x65, 0x6E, 0x63, 0x65, 0x20, 0x28, 0x48, 0x79, 0x75, 0x6C, 0x38, 0x34, 0x29, 0x07, 0x80, 0x01, 0x12, 0x31, 0x30, 0x30, 0x20, 0x44, 0x61, 0x72, 0x6B, 0x20, 0x61, 0x6D, 0x62, 0x65, 0x72, 0x20, 0x62, 0x61, 0x67, 0x00, 0x00, 0x00, 0x01, 0xC8, 0xB8, 0x01, 0x03, 0x32, 0x30, 0x25, 0x03, 0x35, 0x30, 0x25, 0x16, 0x54, 0x47, 0x20, 0x45, 0x78, 0x63, 0x65, 0x6C, 0x6C, 0x65, 0x6E, 0x63, 0x65, 0x20, 0x28, 0x48, 0x79, 0x75, 0x6C, 0x38, 0x34, 0x29, 0x07, 0x80, 0x01, 0x0A, 0x44, 0x61, 0x72, 0x6B, 0x20, 0x61, 0x6D, 0x62, 0x65, 0x72, 0x00, 0x00, 0x00, 0x14, 0xC1, 0x3E, 0x00};

	char buf[40];
	int i = 0;
	int pos = 0;
	int rewardranks;
	int eventid = RFIFOB(fd, 7);
	char legend[17];
	char monthyear[7];
	sprintf(monthyear, "Moon %i", cur_year);

	char rank;
	int rank_num;

	int legendicon, legendiconcolor, legendicon1, legendicon1color, legendicon2, legendicon2color, legendicon3, legendicon3color, legendicon4, legendicon4color, legendicon5, legendicon5color, reward1amount, reward2amount, rewardamount, rewarditm, reward2itm;

	int _1stPlaceReward1_ItmId, _1stPlaceReward1_Amount, _1stPlaceReward2_ItmId, _1stPlaceReward2_Amount, _2ndPlaceReward1_ItmId, _2ndPlaceReward1_Amount, _2ndPlaceReward2_ItmId, _2ndPlaceReward2_Amount, _3rdPlaceReward1_ItmId, _3rdPlaceReward1_Amount, _3rdPlaceReward2_ItmId, _3rdPlaceReward2_Amount, _4thPlaceReward1_ItmId, _4thPlaceReward1_Amount, _4thPlaceReward2_ItmId, _4thPlaceReward2_Amount, _5thPlaceReward1_ItmId, _5thPlaceReward1_Amount, _5thPlaceReward2_ItmId, _5thPlaceReward2_Amount;

	SqlStmt* stmt;
	stmt = SqlStmt_Malloc(sql_handle);
	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}
	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `EventRewardRanks_Display`, `EventLegend`, `EventLegendIcon1`, `EventLegendIcon1Color`, `EventLegendIcon2`, `EventLegendIcon2Color`, `EventLegendIcon3`, `EventLegendIcon3Color`, `EventLegendIcon4`, `EventLegendIcon4Color`, `EventLegendIcon5`, `EventLegendIcon5Color`, `1stPlaceReward1_ItmId`, `1stPlaceReward1_Amount`, `1stPlaceReward2_ItmId`, `1stPlaceReward2_Amount`, `2ndPlaceReward1_ItmId`, `2ndPlaceReward1_Amount`, `2ndPlaceReward2_ItmId`, `2ndPlaceReward2_Amount`, `3rdPlaceReward1_ItmId`, `3rdPlaceReward1_Amount`, `3rdPlaceReward2_ItmId`, `3rdPlaceReward2_Amount`, `4thPlaceReward1_ItmId`, `4thPlaceReward1_Amount`, `4thPlaceReward2_ItmId`, `4thPlaceReward2_Amount`, `5thPlaceReward1_ItmId`, `5thPlaceReward1_Amount`, `5thPlaceReward2_ItmId`, `5thPlaceReward2_Amount` FROM `RankingEvents` WHERE `EventId` = '%u'", eventid)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &rewardranks, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_STRING, &legend, sizeof(legend), NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_INT, &legendicon1, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_INT, &legendicon1color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 4, SQLDT_INT, &legendicon2, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 5, SQLDT_INT, &legendicon2color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 6, SQLDT_INT, &legendicon3, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 7, SQLDT_INT, &legendicon3color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 8, SQLDT_INT, &legendicon4, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 9, SQLDT_INT, &legendicon4color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 10, SQLDT_INT, &legendicon5, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 11, SQLDT_INT, &legendicon5color, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 12, SQLDT_INT, &_1stPlaceReward1_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 13, SQLDT_INT, &_1stPlaceReward1_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 14, SQLDT_INT, &_1stPlaceReward2_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 15, SQLDT_INT, &_1stPlaceReward2_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 16, SQLDT_INT, &_2ndPlaceReward1_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 17, SQLDT_INT, &_2ndPlaceReward1_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 18, SQLDT_INT, &_2ndPlaceReward2_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 19, SQLDT_INT, &_2ndPlaceReward2_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 20, SQLDT_INT, &_3rdPlaceReward1_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 21, SQLDT_INT, &_3rdPlaceReward1_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 22, SQLDT_INT, &_3rdPlaceReward2_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 23, SQLDT_INT, &_3rdPlaceReward2_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 24, SQLDT_INT, &_4thPlaceReward1_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 25, SQLDT_INT, &_4thPlaceReward1_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 26, SQLDT_INT, &_4thPlaceReward2_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 27, SQLDT_INT, &_4thPlaceReward2_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 28, SQLDT_INT, &_5thPlaceReward1_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 29, SQLDT_INT, &_5thPlaceReward1_Amount, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 30, SQLDT_INT, &_5thPlaceReward2_ItmId, 0, NULL, NULL)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 31, SQLDT_INT, &_5thPlaceReward2_Amount, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		rewardranks = 0;
		return 0;
	}

	SqlStmt_Free;

	if (rewardranks == 0) goto end; // This is the `EventRewardRanks_Display` integer in the database. Setting it to 0 will deactivate the event so that it will not show a reward. this stops the rest of this function so a blank page will be shown instead.

	for (i = 13; i < 900; i++) { WFIFOB(fd, i) = 0; } // Set our packets to 0. Minimizes erroneous data that may have been missed during deciphering packets

	WFIFOB(fd, 11) = rewardranks;

	pos += 13;

	for (i = 0; i < rewardranks; i++) {
		rank = i + 49;
		rank_num = i + 1;

		WFIFOB(fd, pos) = rank; // Rank 1st #
		WFIFOB(fd, pos + 1) = 1;  // Squigley or no squigley
		WFIFOB(fd, pos + 2) = rank; // Rank #

		pos += 3;

		switch (rank_num) {
		case 1: sprintf(buf, "%s [%ist] %s", legend, rank_num, monthyear); legendicon = legendicon1; legendiconcolor = legendicon1color; rewarditm = _1stPlaceReward1_ItmId; rewardamount = _1stPlaceReward1_Amount; reward2itm = _1stPlaceReward2_ItmId; reward2amount = _1stPlaceReward2_Amount; break;
		case 2: sprintf(buf, "%s [%ind] %s", legend, rank_num, monthyear); legendicon = legendicon2; legendiconcolor = legendicon2color; rewarditm = _2ndPlaceReward1_ItmId; rewardamount = _2ndPlaceReward1_Amount; reward2itm = _2ndPlaceReward2_ItmId; reward2amount = _2ndPlaceReward2_Amount; break;
		case 3: sprintf(buf, "%s [%ird] %s", legend, rank_num, monthyear); legendicon = legendicon3; legendiconcolor = legendicon3color; rewarditm = _3rdPlaceReward1_ItmId; rewardamount = _3rdPlaceReward1_Amount; reward2itm = _3rdPlaceReward2_ItmId; reward2amount = _3rdPlaceReward2_Amount; break;
		case 4: sprintf(buf, "%s [%ith] %s", legend, rank_num, monthyear); legendicon = legendicon4; legendiconcolor = legendicon4color; rewarditm = _4thPlaceReward1_ItmId; rewardamount = _4thPlaceReward1_Amount; reward2itm = _4thPlaceReward2_ItmId; reward2amount = _4thPlaceReward2_Amount; break;
		case 5: sprintf(buf, "%s [%ith] %s", legend, rank_num, monthyear); legendicon = legendicon5; legendiconcolor = legendicon5color; rewarditm = _5thPlaceReward1_ItmId; rewardamount = _5thPlaceReward1_Amount; reward2itm = _5thPlaceReward2_ItmId; reward2amount = _5thPlaceReward2_Amount; break;
		default: sprintf(buf, "%s [%ith] %s", legend, rank_num, monthyear); legendicon = legendicon5; legendiconcolor = legendicon5color; rewarditm = _5thPlaceReward1_ItmId; rewardamount = _5thPlaceReward1_Amount; reward2itm = _5thPlaceReward2_ItmId; reward2amount = _5thPlaceReward2_Amount; break;
		}

		WFIFOB(fd, pos) = strlen(buf);
		pos += 1;
		strncpy(WFIFOP(fd, pos), buf, strlen(buf));
		pos += strlen(buf);
		WFIFOB(fd, pos) = legendicon; // ICON
		pos += 1; // pos 39
		WFIFOB(fd, pos) = legendiconcolor; // COLOR
		pos += 1;
		if (reward2amount == 0) { WFIFOB(fd, pos) = 1; } // How many rewards for for rank 1
		else { WFIFOB(fd, pos) = 2; }
		pos += 1; // pos+=1 = 41
		sprintf(buf, "%s", itemdb_name(rewarditm));
		WFIFOB(fd, pos) = strlen(buf);
		pos++;
		strncpy(WFIFOP(fd, pos), buf, strlen(buf));
		pos += strlen(buf);
		pos += 3;// 63
		clif_intcheck(rewardamount, pos, fd);
		pos += 2; // Now 65
		clif_intcheck((itemdb_icon(rewarditm) - 49152), pos, fd); // Icon 2232 looks like black sack (Dark AMber bag)
		pos += 1;
		WFIFOB(fd, pos) = itemdb_iconcolor(rewarditm); // ICon Look
		pos += 1;
		if (reward2amount == 0) { WFIFOB(fd, pos) = 1; pos += 1; continue; } // This prevents Reward 2 from being displayed if a value of 0 is set
		sprintf(buf, "%s", itemdb_name(reward2itm));
		WFIFOB(fd, pos) = strlen(buf);
		pos++;
		strncpy(WFIFOP(fd, pos), buf, strlen(buf));
		pos += strlen(buf);
		pos += 3;
		clif_intcheck(reward2amount, pos, fd); // 86
		pos += 2;
		clif_intcheck((itemdb_icon(reward2itm) - 49152), pos, fd);; // 88
		pos += 1;
		WFIFOB(fd, pos) = itemdb_iconcolor(reward2itm);  // 89
		pos += 1;
		WFIFOB(fd, pos) = 1;
		pos += 1;
	} // end For loop

	WFIFOB(fd, 2) = pos - 3; // packetsize data packet. The -3 is because the encryption algorithm appends 3 bytes onto the data stream
	WFIFOSET(fd, encrypt(fd));

end: return 0;
}

void clif_intcheck(int number, int field, int fd) {
	if (field != 0) {
		if (number > 254) {
			if (number > 65535) { WFIFOL(fd, field - 3) = SWAP32(number); }
			if (number <= 65535) { WFIFOW(fd, field - 1) = SWAP16(number); }
		}
		else { WFIFOB(fd, field) = number; }
	}
}

/// RANKING SYSTEM HANDLING - ADDED IN V749 CLIENT ////

int clif_parseranking(USER* sd, int fd) {
	WFIFOHEAD(fd, 0);
	WFIFOB(fd, 0) = 0xAA; // Packet Delimiter
	WFIFOB(fd, 1) = 0x02; //  Paacket header
	WFIFOB(fd, 3) = 0x7D; // Packet ID
	WFIFOB(fd, 5) = 0x03; // Directs packets into the main window.
	WFIFOB(fd, 6) = 0; // Always set to 0

	void retrieveEventDates(int eventid, int pos) {
		int FromDate, FromTime, ToDate, ToTime;

		SqlStmt* stmt;
		stmt = SqlStmt_Malloc(sql_handle);
		if (stmt == NULL)
		{
			SqlStmt_ShowDebug(stmt);
			return 0;
		}
		if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `FromDate`, `FromTime`, `ToDate`, `ToTime` FROM `RankingEvents` WHERE `EventId` = '%u'", eventid)
			|| SQL_ERROR == SqlStmt_Execute(stmt)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &FromDate, 0, NULL, NULL)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_INT, &FromTime, 0, NULL, NULL)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_INT, &ToDate, 0, NULL, NULL)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_INT, &ToTime, 0, NULL, NULL)) {
			SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}

		if (SQL_SUCCESS != SqlStmt_NextRow(stmt)) {
			SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			FromDate = 0;
			FromTime = 0;
			ToDate = 0;
			ToTime = 0;
			return 0;
		}

		SqlStmt_Free;

		// FROM DATE
		clif_intcheck(FromDate, pos + 7, fd); // DATE-- Format: YYYY-MM-DD
		clif_intcheck(FromTime, pos + 11, fd);  // This will display as Hour:Min:Secs.

		// TO DATE
		clif_intcheck(ToDate, pos + 15, fd); // DATE-- Format: YYYY-MM-DD
		clif_intcheck(ToTime, pos + 19, fd);// This will display as Hour:Min:Secs, for example using 235959 yields 23:59:59
	}

	int checkPlayerScore(int eventid) {
		int score = 0;

		SqlStmt* stmt;
		stmt = SqlStmt_Malloc(sql_handle);
		if (stmt == NULL)
		{
			SqlStmt_ShowDebug(stmt);
			return 0;
		}
		if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `Score` FROM `RankingScores` WHERE `EventId` = '%u' AND `ChaId` = '%u'", eventid, sd->status.id)
			|| SQL_ERROR == SqlStmt_Execute(stmt)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_UINT, &score, 0, NULL, NULL)) {
			SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}

		if (SQL_SUCCESS != SqlStmt_NextRow(stmt)) {
			//SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}

		SqlStmt_Free;

		return score;
	}

	void updateRanks(int eventid) {
		int i = 0;

		SqlStmt* stmt = SqlStmt_Malloc(sql_handle);

		if (stmt == NULL) {
			SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}

		if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `Rank` FROM `RankingScores` WHERE `EventId` = '%i' ORDER BY `Score` DESC", eventid)
			|| SQL_ERROR == SqlStmt_Execute(stmt)) {
			SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}

		if (SQL_ERROR == Sql_Query(sql_handle, "SET @r=0")) {
			Sql_ShowDebug(sql_handle);
			SqlStmt_Free(sql_handle);
			return 0;
		}

		if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `RankingScores` SET `Rank`= @r:= (@r+1) WHERE `EventId` = '%i' ORDER BY `Score` DESC", eventid)) {
			Sql_ShowDebug(sql_handle);
			SqlStmt_Free(sql_handle);
			return 0;
		}
	}

	int checkPlayerRank(int eventid) {
		int rank = 0;

		SqlStmt* stmt;
		stmt = SqlStmt_Malloc(sql_handle);
		if (stmt == NULL)
		{
			SqlStmt_ShowDebug(stmt);
			return 0;
		}

		if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `Rank` FROM `RankingScores` WHERE `EventId` = '%u' AND `ChaId` = '%i'", eventid, sd->status.id)
			|| SQL_ERROR == SqlStmt_Execute(stmt)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_INT, &rank, 0, NULL, NULL)) {
			//SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}

		if (SQL_SUCCESS != SqlStmt_NextRow(stmt)) {
			//SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}
		return rank;
	}

	int checkevent_claim(int eventid) {
		int claim = 0;

		SqlStmt* stmt;
		stmt = SqlStmt_Malloc(sql_handle);
		if (stmt == NULL)
		{
			SqlStmt_ShowDebug(stmt);
			return 0;
		}
		if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `EventClaim` FROM `RankingScores` WHERE `EventId` = '%u' AND `ChaId` = '%u'", eventid, sd->status.id)
			|| SQL_ERROR == SqlStmt_Execute(stmt)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_UINT, &claim, 0, NULL, NULL)) {
			SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return claim;
		}

		if (SQL_SUCCESS != SqlStmt_NextRow(stmt)) { // If no record found, set claim=2 (no icon, disabled getreward)
			//SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			claim = 2;
			return claim;
		}

		return claim;
		SqlStmt_Free;
	}

	void dateevent_block(int pos, int eventid) {
		WFIFOB(fd, pos) = 0; // Always 0
		WFIFOB(fd, pos + 1) = eventid;
		WFIFOB(fd, pos + 2) = 142; //142
		WFIFOB(fd, pos + 3) = 227; // 227
		retrieveEventDates(eventid, pos);
		WFIFOB(fd, pos + 20) = checkevent_claim(eventid);  // Envelope.  0 = new, 1 = read/unclaimed, 2 = no reward -- enables/disables the GetReward button
	}

	void filler_block(int pos, int eventid) {
		int player_score = checkPlayerScore(eventid);
		int player_rank = checkPlayerRank(eventid);

		WFIFOB(fd, pos + 1) = RFIFOB(fd, 7); // This controls which event is displayed. It is the event request id packet
		WFIFOB(fd, pos + 2) = 142;
		WFIFOB(fd, pos + 3) = 227;
		WFIFOB(fd, pos + 4) = 1; // show self score - Leave to always enabled. If player does not have a score or is equal to 0, the client automatically blanks it out
		clif_intcheck(player_rank, pos + 8, fd);// Self rank
		clif_intcheck(player_score, pos + 12, fd); // Self score
		WFIFOB(fd, pos + 13) = checkevent_claim(eventid);
	}

	int gettotalscores(int eventid) {
		int scores;

		SqlStmt* stmt;
		stmt = SqlStmt_Malloc(sql_handle);
		if (stmt == NULL)
		{
			SqlStmt_ShowDebug(stmt);
			return 0;
		}
		if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaId` FROM `RankingScores` WHERE `EventId` = '%u'", eventid)
			|| SQL_ERROR == SqlStmt_Execute(stmt))
		{
			SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}
		scores = SqlStmt_NumRows(stmt);
		SqlStmt_Free(stmt);

		return scores;
	}

	int getevents() {
		int events;
		SqlStmt* stmt;
		stmt = SqlStmt_Malloc(sql_handle);
		if (stmt == NULL)
		{
			SqlStmt_ShowDebug(stmt);
			return 0;
		}
		if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `EventId` FROM `RankingEvents`") || SQL_ERROR == SqlStmt_Execute(stmt))
		{
			SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}
		events = SqlStmt_NumRows(stmt);
		SqlStmt_Free(stmt);
		return events;
	}

	int getevent_name(int pos) {
		char name[40];
		char buf[40];
		int i = 0;

		SqlStmt* stmt;
		stmt = SqlStmt_Malloc(sql_handle);
		if (stmt == NULL) {
			SqlStmt_ShowDebug(stmt);
			return 0;
		}

		if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `EventName` FROM `RankingEvents`")
			|| SQL_ERROR == SqlStmt_Execute(stmt)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &name, sizeof(name), NULL, NULL)) {
			SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}

		for (i = 0; (i < SqlStmt_NumRows(stmt)) && (SQL_SUCCESS == SqlStmt_NextRow(stmt)); i++) {
			dateevent_block(pos, i);
			pos += 21;
			sprintf(buf, "%s", name);
			WFIFOB(fd, pos) = strlen(buf);
			pos++;
			strncpy(WFIFOP(fd, pos), buf, strlen(buf));
			pos += strlen(buf);
		}

		return pos;
	}

	int getevent_playerscores(int eventid, int totalscores, int pos) {
		char name[16];
		int score;
		int rank;
		char buf[40];
		int offset = RFIFOB(fd, 17) - 10; // The purpose of this -10 is because the packet request is value 10 for page 1. Because of mysql integration, we want to offset so we start on row 0 for player scores loading
		int i = 0;

		SqlStmt* stmt;
		stmt = SqlStmt_Malloc(sql_handle);
		if (stmt == NULL) {
			SqlStmt_ShowDebug(stmt);
			return 0;
		}

		if (totalscores > 10) { SqlStmt_Prepare(stmt, "SELECT `ChaName`, `Score`, `Rank` FROM `RankingScores` WHERE `EventId` = '%u' ORDER BY `Rank` ASC LIMIT 10 OFFSET %u", eventid, offset); }
		else { SqlStmt_Prepare(stmt, "SELECT `ChaName`, `Score`, `Rank` FROM `RankingScores` WHERE `EventId` = '%u' ORDER BY `Rank` ASC LIMIT 10", eventid); }

		if (SQL_ERROR == SqlStmt_Execute(stmt)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &name, sizeof(name), NULL, NULL)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_INT, &score, 0, NULL, NULL)
			|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_INT, &rank, 0, NULL, NULL)) {
			SqlStmt_ShowDebug(stmt);
			SqlStmt_Free(stmt);
			return 0;
		}

		if (SqlStmt_NumRows(stmt) < 10) { WFIFOB(fd, pos - 1) = SqlStmt_NumRows(stmt); } // added 04-26-2017 removes trailing zeros that were present in the ranking feature

		for (i = 0; (i < SqlStmt_NumRows(stmt)) && (SQL_SUCCESS == SqlStmt_NextRow(stmt)); i++) {
			sprintf(buf, "%s", name);
			WFIFOB(fd, pos) = strlen(buf);
			pos++;
			strncpy(WFIFOP(fd, pos), buf, strlen(buf));
			pos += strlen(buf);
			pos += 3;

			WFIFOB(fd, pos) = rank; // # of rank
			pos += 4;
			clif_intcheck(score, pos, fd);
			pos++;
		}

		return pos;
	}

	//Original Packet = { 0xAA, 0x02, 0x95, 0x7D, 0x26, 0x03, 0x00, 0x0D, 0x01, 0x03, 0x8E, 0xE3, 0x01, 0x33, 0xC5, 0x78, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xC5, 0x93, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x09, 0x53, 0x6E, 0x6F, 0x77, 0x20, 0x46, 0x75, 0x72, 0x79, 0x01, 0x03, 0x8E, 0xE2, 0x01, 0x33, 0xC5, 0x78, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xC5, 0x93, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x0B, 0x53, 0x6E, 0x6F, 0x77, 0x20, 0x46, 0x72, 0x65, 0x6E, 0x7A, 0x79, 0x01, 0x03, 0x8E, 0xE1, 0x01, 0x33, 0xC5, 0x78, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xC5, 0x93, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x0B, 0x53, 0x6E, 0x6F, 0x77, 0x20, 0x46, 0x6C, 0x75, 0x72, 0x72, 0x79, 0x00, 0xF6, 0x01, 0xBF, 0x01, 0x33, 0xA2, 0xC7, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xC5, 0x77, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x09, 0x53, 0x6E, 0x6F, 0x77, 0x20, 0x46, 0x75, 0x72, 0x79, 0x00, 0xF6, 0x01, 0xBE, 0x01, 0x33, 0xA2, 0xC7, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xC5, 0x77, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x0B, 0x53, 0x6E, 0x6F, 0x77, 0x20, 0x46, 0x72, 0x65, 0x6E, 0x7A, 0x79, 0x00, 0xF6, 0x01, 0xBD, 0x01, 0x33, 0xA2, 0xC7, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xC5, 0x77, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x0B, 0x53, 0x6E, 0x6F, 0x77, 0x20, 0x46, 0x6C, 0x75, 0x72, 0x72, 0x79, 0x00, 0xF5, 0xDC, 0x3E, 0x01, 0x33, 0xA2, 0x63, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xA2, 0x67, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x14, 0x47, 0x72, 0x61, 0x6E, 0x64, 0x20, 0x54, 0x47, 0x20, 0x43, 0x6F, 0x6D, 0x70, 0x65, 0x74, 0x69, 0x74, 0x69, 0x6F, 0x6E, 0x00, 0xF5, 0xDC, 0x3D, 0x01, 0x33, 0xA2, 0x67, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xA2, 0x67, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x16, 0x54, 0x47, 0x20, 0x64, 0x61, 0x69, 0x6C, 0x79, 0x20, 0x43, 0x6F, 0x6D, 0x70, 0x65, 0x74, 0x69, 0x74, 0x69, 0x6F, 0x6E, 0x20, 0x35, 0x00, 0xF5, 0xDB, 0xD9, 0x01, 0x33, 0xA2, 0x66, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xA2, 0x66, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x16, 0x54, 0x47, 0x20, 0x64, 0x61, 0x69, 0x6C, 0x79, 0x20, 0x43, 0x6F, 0x6D, 0x70, 0x65, 0x74, 0x69, 0x74, 0x69, 0x6F, 0x6E, 0x20, 0x34, 0x00, 0xF5, 0xDB, 0x75, 0x01, 0x33, 0xA2, 0x65, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xA2, 0x65, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x16, 0x54, 0x47, 0x20, 0x64, 0x61, 0x69, 0x6C, 0x79, 0x20, 0x43, 0x6F, 0x6D, 0x70, 0x65, 0x74, 0x69, 0x74, 0x69, 0x6F, 0x6E, 0x20, 0x33, 0x00, 0xF5, 0xDB, 0x11, 0x01, 0x33, 0xA2, 0x64, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xA2, 0x64, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x16, 0x54, 0x47, 0x20, 0x64, 0x61, 0x69, 0x6C, 0x79, 0x20, 0x43, 0x6F, 0x6D, 0x70, 0x65, 0x74, 0x69, 0x74, 0x69, 0x6F, 0x6E, 0x20, 0x32, 0x00, 0xF5, 0xDA, 0xAD, 0x01, 0x33, 0xA2, 0x63, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xA2, 0x63, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x16, 0x54, 0x47, 0x20, 0x64, 0x61, 0x69, 0x6C, 0x79, 0x20, 0x43, 0x6F, 0x6D, 0x70, 0x65, 0x74, 0x69, 0x74, 0x69, 0x6F, 0x6E, 0x20, 0x31, 0x00, 0xF5, 0xD7, 0xF1, 0x01, 0x33, 0xA2, 0x5C, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0xA2, 0x60, 0x00, 0x03, 0x99, 0xB7, 0x02, 0x08, 0x53, 0x63, 0x61, 0x76, 0x65, 0x6E, 0x67, 0x65, 0x01, 0x03, 0x8E, 0xE3, 0x00, 0x00, 0x0A, 0x06, 0x48, 0x6F, 0x63, 0x61, 0x72, 0x69, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x01, 0x50, 0x07, 0x41, 0x6D, 0x62, 0x65, 0x72, 0x6C, 0x79, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x01, 0x3E, 0x09, 0x46, 0x72, 0x65, 0x6E, 0x63, 0x68, 0x46, 0x72, 0x79, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0xFC, 0x06, 0x73, 0x69, 0x75, 0x6C, 0x65, 0x74, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0xEE, 0x04, 0x4D, 0x75, 0x72, 0x63, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x38, 0x0A, 0x4C, 0x69, 0x6E, 0x75, 0x78, 0x6B, 0x69, 0x64, 0x64, 0x79, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x38, 0x05, 0x41, 0x75, 0x64, 0x69, 0x6F, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x2A, 0x07, 0x4E, 0x65, 0x6C, 0x6C, 0x69, 0x65, 0x6C, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x1C, 0x08, 0x50, 0x6F, 0x68, 0x77, 0x61, 0x72, 0x61, 0x6E, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x1C, 0x04, 0x53, 0x75, 0x72, 0x69, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x00, 0x10 };
	//int psize = sizeof(cappacket)/sizeof(cappacket[0]);
	//printf("cap packet size: %i\n",psize);
	//for (i=0;i<660;i++) { WFIFOB(fd, i) = cappacket[i]; }

	int i = 0;
	for (i = 8; i < 1500; i++) { WFIFOB(fd, i) = 0x00; } // Write Zero's to all fields that we won't be using.
	WFIFOB(fd, 7) = getevents(); // number of events  * affirmed
	int chosen_event = RFIFOB(fd, 7);

	updateRanks(chosen_event);

	int pos = 8;

	pos = getevent_name(pos);
	filler_block(pos, chosen_event);
	pos += 15;// was a 6
	WFIFOB(fd, pos) = 10; // # of scores to display on page. max 10
	int totalscores = gettotalscores(chosen_event);
	pos++;
	pos = getevent_playerscores(chosen_event, totalscores, pos);
	pos += 3;
	WFIFOB(fd, pos) = totalscores; // This number displays in the top right of the popup and indicates how many users played in specific event
	pos += 1;

	WFIFOB(fd, 2) = pos - 3; // packetsize packet. The -3 is because the encryption algorithm ends 3 bytes onto the end
	WFIFOSET(fd, encrypt(fd));

	return 0;
}

int clif_parsewalkpong(USER* sd) {
	int HASH = SWAP32(RFIFOL(sd->fd, 5));
	unsigned long  TS = SWAP32(RFIFOL(sd->fd, 9));

	if (sd->LastPingTick)
		sd->msPing = gettick() - sd->LastPingTick;

	if (sd->LastPongStamp)
	{
		int Difference = TS - sd->LastPongStamp;

		if (Difference > 43000)
		{
			//	 clif_Hacker(sd->status.name,"Virtually overclocked. (Speedhack). Booted.");
		//		 session[sd->fd]->eof=1;
		}
	}

	sd->LastPongStamp = TS;
	return 0;
}

int clif_parsemap(USER* sd) {
	int x0 = 0, y0 = 0, x1 = 0, y1 = 0;
	unsigned short checksum;
	int def[2];
	char buf[32];
	sd->loaded = 1;

	x0 = SWAP16(RFIFOW(sd->fd, 5));
	y0 = SWAP16(RFIFOW(sd->fd, 7));
	x1 = RFIFOB(sd->fd, 9);
	y1 = RFIFOB(sd->fd, 10);
	checksum = SWAP16(RFIFOW(sd->fd, 11));

	if (RFIFOB(sd->fd, 3) == 5) {
		checksum = 0;
	}

	clif_sendmapdata(sd, sd->bl.m, x0, y0, x1, y1, checksum);
	def[0] = 0;
	def[1] = 0;

	return 0;
}

int clif_sendmapdata(USER* sd, int m, int x0, int y0, int x1, int y1, unsigned short check) {
	int x, y, pos;
	unsigned short checksum;
	unsigned short buf[65536];

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	if (map_readglobalreg(m, "blackout") != 0) { sl_doscript_blargs("sendMapData", NULL, 1, &sd->bl); return 0; }

	WFIFOHEAD(sd->fd, 65535);
	char buf2[65536];
	int a = 0;
	int len = 0;
	checksum = 0;

	int side = sd->status.side;
	int max = 3;

	//if(((y1-y0)*(x1-x0)*6)>65535) {
	if ((x1 * y1) > 323) {
		printf("eof bug encountered by %s\n %u %u to %u %u\n", sd->status.name, x0, y0, x1, y1);
		//session[sd->fd]->eof=1;
		return 0;
	}
	if (x0 < 0)
		x0 = 0;
	if (y0 < 0)
		y0 = 0;
	if (x1 > map[m].xs)
		x1 = map[m].xs;
	if (y1 > map[m].ys)
		y1 = map[m].ys;
	WBUFB(buf2, 0) = 0xAA;
	WBUFB(buf2, 3) = 0x06;
	WBUFB(buf2, 4) = 0x03;
	WBUFB(buf2, 5) = 0;
	WBUFW(buf2, 6) = SWAP16(x0);
	WBUFW(buf2, 8) = SWAP16(y0);
	WBUFB(buf2, 10) = x1;
	WBUFB(buf2, 11) = y1;
	pos = 12;
	len = 0;

	for (y = 0; y < y1; y++) {
		if (y + y0 >= map[m].ys)
			break;
		for (x = 0; x < x1; x++) {
			if (x + x0 >= map[m].xs)
				break;
			buf[a] = read_tile(m, x0 + x, y0 + y);
			buf[a + 1] = read_pass(m, x0 + x, y0 + y);
			buf[a + 2] = read_obj(m, x0 + x, y0 + y);
			len = len + 6;

			WBUFW(buf2, pos) = SWAP16(read_tile(m, x0 + x, y0 + y));
			pos += 2;
			WBUFW(buf2, pos) = SWAP16(read_pass(m, x0 + x, y0 + y));
			pos += 2;
			WBUFW(buf2, pos) = SWAP16(read_obj(m, x0 + x, y0 + y));
			pos += 2;

			a += 3;
		}
	}

	checksum = nexCRCC(buf, len);

	if (pos <= 12)
		return 0;

	if (checksum == check) {
		return 0;
	}

	WBUFW(buf2, 1) = SWAP16(pos - 3);
	memcpy(WFIFOP(sd->fd, 0), buf2, pos);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_sendside(struct block_list* bl) {
	unsigned char buf[32];
	USER* sd = NULL;
	MOB* mob = NULL;
	NPC* nd = NULL;

	if (bl->type == BL_PC) {
		nullpo_ret(0, sd = (USER*)bl);
	}
	else if (bl->type == BL_MOB) {
		nullpo_ret(0, mob = (MOB*)bl);
	}
	else if (bl->type == BL_NPC) {
		nullpo_ret(0, nd = (NPC*)bl);
	}

	WBUFB(buf, 0) = 0xAA;
	WBUFB(buf, 1) = 0x00;
	WBUFB(buf, 2) = 0x08;
	WBUFB(buf, 3) = 0x11;
	//WBUFB(buf, 4) = 0x03;
	WBUFL(buf, 5) = SWAP32(bl->id);

	if (bl->type == BL_PC) {
		WBUFB(buf, 9) = sd->status.side;
	}
	else if (bl->type == BL_MOB) {
		WBUFB(buf, 9) = mob->side;
	}
	else if (bl->type == BL_NPC) {
		WBUFB(buf, 9) = nd->side;
	}

	WBUFB(buf, 10) = 0;

	if (bl->type == BL_PC) {
		clif_send(buf, 32, bl, AREA);
	}
	else {
		clif_send(buf, 32, bl, AREA_WOS);
	}
	return 0;
}
int clif_sendmob_side(MOB* mob) {
	unsigned char buf[16];
	WBUFB(buf, 0) = 0xAA;
	WBUFB(buf, 1) = 0x00;
	WBUFB(buf, 2) = 0x07;
	WBUFB(buf, 3) = 0x11;
	WBUFB(buf, 4) = 0x03;
	WBUFL(buf, 5) = SWAP32(mob->bl.id);
	WBUFB(buf, 9) = mob->side;
	//crypt(WBUFP(buf, 0));
	clif_send(buf, 16, &mob->bl, AREA_WOS);
	return 0;
}
int clif_runfloor_sub(struct block_list* bl, va_list ap) {
	NPC* nd = NULL;
	USER* sd = NULL;

	nullpo_ret(0, nd = (NPC*)bl);
	nullpo_ret(0, sd = va_arg(ap, USER*));

	if (bl->subtype != FLOOR) return 0;

	sl_async_freeco(sd);
	sl_doscript_blargs(nd->name, "click2", 2, &sd->bl, &nd->bl);
	return 0;
}
int clif_parseside(USER* sd) {
	sd->status.side = RFIFOB(sd->fd, 5);
	clif_sendside(&sd->bl);
	sl_doscript_blargs("onTurn", NULL, 1, &sd->bl);
	//map_foreachincell(clif_runfloor_sub,sd->bl.m,sd->bl.x,sd->bl.y,BL_NPC,sd,1);
	return 0;
}

int clif_parseemotion(USER* sd) {
	if (sd->status.state == 0) {
		clif_sendaction(&sd->bl, RFIFOB(sd->fd, 5) + 11, 0x4E, 0);
	}
	return 0;
}

int clif_sendmsg(USER* sd, int type, char* buf) {
	/*	Type:
		0 = Wisp (blue text)
		3 = Mini Text/Status Text
		5 = System
		11 = Group & subpath text
		12 = clan text
		99 = advice... 99 is not really a valid number but just using it as a type so we can do an advice exclusion below
	*/
	nullpo_ret(0, buf);

	int adviceFlag = sd->status.settingFlags & FLAG_ADVICE;
	if (type == 99 && adviceFlag) type = 11;
	else if (type == 99 && !adviceFlag) return 0;

	int len = strlen(buf);

	if (len > strlen(buf)) len = strlen(buf);

	WFIFOHEAD(sd->fd, 8 + len);
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 8 + len);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(5 + len);
	WFIFOB(sd->fd, 3) = 0x0A;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOW(sd->fd, 5) = type;
	WFIFOB(sd->fd, 7) = len;
	memcpy(WFIFOP(sd->fd, 8), buf, len);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_sendminitext(USER* sd, char* msg) {
	nullpo_ret(0, sd);
	if (!strlen(msg)) return 0;
	clif_sendmsg(sd, 3, msg);
	return 0;
}

int clif_sendwisp(USER* sd, char* srcname, unsigned char* msg) {
	int msglen = strlen(msg);
	int srclen = strlen(srcname);
	int newlen = 0;
	unsigned char* buf;
	unsigned char buf2[255];
	USER* src_sd = map_name2sd(srcname);
	if (strlen(msg) < msglen) msglen = strlen(msg);
	if (src_sd) {
		if (classdb_name(src_sd->status.class, src_sd->status.mark)) {
			newlen = sprintf(buf2, "\" (%s) ", classdb_name(src_sd->status.class, src_sd->status.mark));
		}
		else {
			newlen = sprintf(buf2, "\" () ");
		}

		CALLOC(buf, unsigned char, srclen + msglen + newlen);
		memcpy(WBUFP(buf, 0), srcname, srclen);
		strcpy(WBUFP(buf, srclen), buf2);
		memcpy(WBUFP(buf, srclen + newlen), msg, msglen);

		if (map[sd->bl.m].cantalk == 1 && !sd->status.gm_level) {
			clif_sendminitext(sd, "Your voice is carried away.");
			FREE(buf);
			return 0;
		}

		clif_sendmsg(sd, 0, buf);

		FREE(buf);
	}

	return 0;
}

int clif_retrwisp(USER* sd, char* dstname, unsigned char* msg) {
	int msglen = strlen(msg);

	int dstlen = strlen(dstname);
	unsigned char* buf[2 + dstlen + msglen];

	//CALLOC(buf, unsigned char, 2+dstlen+msglen);
	//memcpy(WBUFP(buf, 0), dstname, dstlen);

	//WBUFB(buf, dstlen) = '>';
	//WBUFB(buf, 1+dstlen) = ' ';
	//memcpy(WBUFP(buf, 2+dstlen), msg, msglen);

	sprintf(buf, "%s> %s", dstname, msg);

	clif_sendmsg(sd, 0, buf);
	//FREE(buf);
	return 0;
}

int clif_failwisp(USER* sd) {
	clif_sendmsg(sd, 0, map_msg[MAP_WHISPFAIL].message);
	return 0;
}

int clif_parsedropitem(USER* sd) {
	char RegStr[] = "goldbardupe";
	int DupeTimes = pc_readglobalreg(sd, RegStr);
	if (DupeTimes)
	{
		//char minibuf[]="Character under quarentine.";
		//clif_sendminitext(sd,minibuf);
		return 0;
	}

	if (sd->status.gm_level == 0) {
		if (sd->status.state == 3) {
			clif_sendminitext(sd, "You cannot do that while riding a mount.");
			return 0;
		}
		if (sd->status.state == 1) {
			clif_sendminitext(sd, "Spirits can't do that.");
			return 0;
		}
	}

	sd->fakeDrop = 0;

	int id = RFIFOB(sd->fd, 5) - 1;
	int all = RFIFOB(sd->fd, 6);
	if (id >= sd->status.maxinv) return 0;
	if (sd->status.inventory[id].id) {
		if (itemdb_droppable(sd->status.inventory[id].id)) {
			clif_sendminitext(sd, "You can't drop this item.");
			return 0;
		}
	}

	clif_sendaction(&sd->bl, 5, 20, 0);

	sd->invslot = id; // this sets player.invSlot so that we can access it in the on_drop_while_cast func

	sl_doscript_blargs(itemdb_yname(sd->status.inventory[id].id), "on_drop", 1, &sd->bl); // running this before pc_dropitemmap allows us to simulate a drop (fake) as seen on ntk. prevents abuse.

	for (int x = 0; x < MAX_MAGIC_TIMERS; x++) { //Spell stuff
		if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].duration > 0) {
			sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "on_drop_while_cast", 1, &sd->bl);
		}
	}

	for (int x = 0; x < MAX_MAGIC_TIMERS; x++) { //Spell stuff
		if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].aether > 0) {
			sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "on_drop_while_aether", 1, &sd->bl);
		}
	}

	if (sd->fakeDrop) return 0;

	pc_dropitemmap(sd, id, all);

	return 0;
}
int clif_deductdura(USER* sd, int equip, int val) {
	unsigned char eth;
	nullpo_ret(0, sd);
	if (!sd->status.equip[equip].id) return 0;
	if (map[sd->bl.m].pvp) return 0; // disable dura loss from mobs on pvp map

	eth = itemdb_ethereal(sd->status.equip[equip].id);

	if (!eth) {
		sd->status.equip[equip].dura -= val;
		clif_checkdura(sd, equip);
	}
	return 0;
}
int clif_deductweapon(USER* sd, int hit) {
	if (pc_isequip(sd, EQ_WEAP)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_WEAP, hit);
		}
	}

	return 0;
}

int clif_deductarmor(USER* sd, int hit) {
	if (pc_isequip(sd, EQ_WEAP)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_WEAP, hit);
		}
	}
	if (pc_isequip(sd, EQ_HELM)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_HELM, hit);
		}
	}
	if (pc_isequip(sd, EQ_ARMOR)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_ARMOR, hit);
		}
	}
	if (pc_isequip(sd, EQ_LEFT)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_LEFT, hit);
		}
	}
	if (pc_isequip(sd, EQ_RIGHT)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_RIGHT, hit);
		}
	}
	if (pc_isequip(sd, EQ_SUBLEFT)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_SUBLEFT, hit);
		}
	}
	if (pc_isequip(sd, EQ_SUBRIGHT)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_SUBRIGHT, hit);
		}
	}
	if (pc_isequip(sd, EQ_BOOTS)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_BOOTS, hit);
		}
	}
	if (pc_isequip(sd, EQ_MANTLE)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_MANTLE, hit);
		}
	}
	if (pc_isequip(sd, EQ_COAT)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_COAT, hit);
		}
	}
	if (pc_isequip(sd, EQ_SHIELD)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_SHIELD, hit);
		}
	}
	if (pc_isequip(sd, EQ_FACEACC)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_FACEACC, hit);
		}
	}
	if (pc_isequip(sd, EQ_CROWN)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_CROWN, hit);
		}
	}
	if (pc_isequip(sd, EQ_NECKLACE)) {
		if (rnd(100) > 50) {
			clif_deductdura(sd, EQ_NECKLACE, hit);
		}
	}
	return 0;
}

int clif_checkdura(USER* sd, int equip) {
	float percentage;
	int id;
	char buf[255];
	char escape[255];

	nullpo_ret(0, sd);
	if (!sd->status.equip[equip].id) return 0;
	id = sd->status.equip[equip].id;

	sd->equipslot = equip;

	percentage = (float)sd->status.equip[equip].dura / (float)itemdb_dura(id);

	if (percentage <= .5 && sd->status.equip[equip].repair == 0) {
		sprintf(buf, "Your %s is at 50%%.", itemdb_name(id));
		clif_sendmsg(sd, 5, buf);
		//clif_sendminitext(sd, buf);
		sd->status.equip[equip].repair = 1;
	}

	if (percentage <= .25 && sd->status.equip[equip].repair == 1) {
		sprintf(buf, "Your %s is at 25%%.", itemdb_name(id));
		clif_sendmsg(sd, 5, buf);
		//clif_sendminitext(sd, buf,strlen(buf));
		sd->status.equip[equip].repair = 2;
	}

	if (percentage <= .1 && sd->status.equip[equip].repair == 2) {
		sprintf(buf, "Your %s is at 10%%.", itemdb_name(id));
		clif_sendmsg(sd, 5, buf);
		//clif_sendminitext(sd, buf);
		sd->status.equip[equip].repair = 3;
	}

	if (percentage <= .05 && sd->status.equip[equip].repair == 3) {
		sprintf(buf, "Your %s is at 5%%.", itemdb_name(id));
		clif_sendmsg(sd, 5, buf);
		//clif_sendminitext(sd, buf);
		sd->status.equip[equip].repair = 4;
	}

	if (percentage <= .01 && sd->status.equip[equip].repair == 4) {
		sprintf(buf, "Your %s is at 1%%.", itemdb_name(id));
		clif_sendmsg(sd, 5, buf);
		//clif_sendminitext(sd, buf);
		sd->status.equip[equip].repair = 5;
	}

	if (sd->status.equip[equip].dura <= 0 || (sd->status.state == 1 && itemdb_breakondeath(sd->status.equip[equip].id) == 1)) {
		if (itemdb_protected(sd->status.equip[equip].id) || sd->status.equip[equip].protected >= 1) {
			sd->status.equip[equip].protected -= 1;
			sd->status.equip[equip].dura = itemdb_dura(sd->status.equip[equip].id); //recharge dura
			sprintf(buf, "Your %s has been restored!", itemdb_name(id));
			clif_sendstatus(sd, SFLAG_FULLSTATS | SFLAG_HPMP);
			clif_sendmsg(sd, 5, buf);
			sl_doscript_blargs("characterLog", "equipRestore", 1, &sd->bl);
			return 0;
		}

		sl_doscript_blargs("characterLog", "equipBreak", 1, &sd->bl);
		sprintf(buf, "Your %s was destroyed!", itemdb_name(id));

		sd->breakid = id;
		sl_doscript_blargs("onBreak", NULL, 1, &sd->bl);
		sl_doscript_blargs(itemdb_yname(id), "on_break", 1, &sd->bl);

		Sql_EscapeString(sql_handle, escape, sd->status.equip[equip].real_name);

		/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `BreakLogs` (`BrkChaId`, `BrkMapId`, `BrkX`, `BrkY`, `BrkItmId`) VALUES ('%u', '%u', '%u', '%u', '%u')",
				sd->status.id, sd->bl.m, sd->bl.x, sd->bl.y, sd->status.equip[equip].id)) {
			SqlStmt_ShowDebug(sql_handle);
		}*/

		sd->status.equip[equip].id = 0;
		sd->status.equip[equip].dura = 0;
		sd->status.equip[equip].amount = 0;
		sd->status.equip[equip].protected = 0;
		sd->status.equip[equip].owner = 0;
		sd->status.equip[equip].custom = 0;
		sd->status.equip[equip].customLook = 0;
		sd->status.equip[equip].customLookColor = 0;
		sd->status.equip[equip].customIcon = 0;
		sd->status.equip[equip].customIconColor = 0;
		memset(sd->status.equip[equip].trapsTable, 0, 100);
		sd->status.equip[equip].time = 0;
		sd->status.equip[equip].repair = 0;
		strcpy(sd->status.equip[equip].real_name, "");
		clif_unequipit(sd, clif_getequiptype(equip));

		//clif_sendchararea(sd); // was commented
		//clif_getchararea(sd); // was commented
		map_foreachinarea(clif_updatestate, sd->bl.m, sd->bl.x, sd->bl.y, AREA, BL_PC, sd);
		pc_calcstat(sd);
		clif_sendstatus(sd, SFLAG_FULLSTATS | SFLAG_HPMP);
		clif_sendmsg(sd, 5, buf);
		//clif_sendminitext(sd,buf);
	}

	return 0;
}

int clif_deductduraequip(USER* sd) {
	float percentage;
	int id;
	char buf[255];
	char escape[255];

	nullpo_ret(0, sd);

	for (int equip = 0; equip < 14; equip++) {
		if (!sd->status.equip[equip].id) continue;
		id = sd->status.equip[equip].id;

		unsigned char eth;
		nullpo_ret(0, sd);
		if (!sd->status.equip[equip].id) return 0;
		if (map[sd->bl.m].pvp) return 0;

		eth = itemdb_ethereal(sd->status.equip[equip].id);

		if (eth) continue;

		sd->equipslot = equip;

		sd->status.equip[equip].dura -= floor(itemdb_dura(sd->status.equip[equip].id) * 0.10);

		percentage = (float)sd->status.equip[equip].dura / (float)itemdb_dura(id);

		if (percentage <= .5 && sd->status.equip[equip].repair == 0) {
			sprintf(buf, "Your %s is at 50%%.", itemdb_name(id));
			clif_sendmsg(sd, 5, buf);
			//clif_sendminitext(sd, buf);
			sd->status.equip[equip].repair = 1;
		}

		if (percentage <= .25 && sd->status.equip[equip].repair == 1) {
			sprintf(buf, "Your %s is at 25%%.", itemdb_name(id));
			clif_sendmsg(sd, 5, buf);
			//clif_sendminitext(sd, buf);
			sd->status.equip[equip].repair = 2;
		}

		if (percentage <= .1 && sd->status.equip[equip].repair == 2) {
			sprintf(buf, "Your %s is at 10%%.", itemdb_name(id));
			clif_sendmsg(sd, 5, buf);
			//clif_sendminitext(sd, buf);
			sd->status.equip[equip].repair = 3;
		}

		if (percentage <= .05 && sd->status.equip[equip].repair == 3) {
			sprintf(buf, "Your %s is at 5%%.", itemdb_name(id));
			clif_sendmsg(sd, 5, buf);
			//clif_sendminitext(sd, buf);
			sd->status.equip[equip].repair = 4;
		}

		if (percentage <= .01 && sd->status.equip[equip].repair == 4) {
			sprintf(buf, "Your %s is at 1%%.", itemdb_name(id));
			clif_sendmsg(sd, 5, buf);
			//clif_sendminitext(sd, buf);
			sd->status.equip[equip].repair = 5;
		}

		if (sd->status.equip[equip].dura <= 0 || (sd->status.state == 1 && itemdb_breakondeath(sd->status.equip[equip].id) == 1)) {
			if (itemdb_protected(sd->status.equip[equip].id) || sd->status.equip[equip].protected >= 1) {
				sd->status.equip[equip].protected -= 1;
				sd->status.equip[equip].dura = itemdb_dura(sd->status.equip[equip].id); //recharge dura
				sprintf(buf, "Your %s has been restored!", itemdb_name(id));
				clif_sendstatus(sd, SFLAG_FULLSTATS | SFLAG_HPMP);
				clif_sendmsg(sd, 5, buf);
				sl_doscript_blargs("characterLog", "equipRestore", 1, &sd->bl);
				return 0;
			}

			memcpy(&sd->boditems.item[sd->boditems.bod_count], &sd->status.equip[equip], sizeof(sd->status.equip[equip]));
			sd->boditems.bod_count++;

			sl_doscript_blargs("characterLog", "equipBreak", 1, &sd->bl);
			sprintf(buf, "Your %s was destroyed!", itemdb_name(id));

			Sql_EscapeString(sql_handle, escape, sd->status.equip[equip].real_name);

			/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `BreakLogs` (`BrkChaId`, `BrkMapId`, `BrkX`, `BrkY`, `BrkItmId`) VALUES ('%u', '%u', '%u', '%u', '%u')",
					sd->status.id, sd->bl.m, sd->bl.x, sd->bl.y, sd->status.equip[equip].id)) {
				SqlStmt_ShowDebug(sql_handle);
			}*/

			sd->breakid = id;
			sl_doscript_blargs("onBreak", NULL, 1, &sd->bl);
			sl_doscript_blargs(itemdb_yname(id), "on_break", 1, &sd->bl);

			sd->status.equip[equip].id = 0;
			sd->status.equip[equip].dura = 0;
			sd->status.equip[equip].amount = 0;
			sd->status.equip[equip].protected = 0;
			sd->status.equip[equip].owner = 0;
			sd->status.equip[equip].custom = 0;
			sd->status.equip[equip].customLook = 0;
			sd->status.equip[equip].customLookColor = 0;
			sd->status.equip[equip].customIcon = 0;
			sd->status.equip[equip].customIconColor = 0;
			memset(sd->status.equip[equip].trapsTable, 0, 100);
			sd->status.equip[equip].time = 0;
			sd->status.equip[equip].repair = 0;
			strcpy(sd->status.equip[equip].real_name, "");
			clif_unequipit(sd, clif_getequiptype(equip));

			//clif_sendchararea(sd); // was commented
			//clif_getchararea(sd); // was commented
			map_foreachinarea(clif_updatestate, sd->bl.m, sd->bl.x, sd->bl.y, AREA, BL_PC, sd);
			pc_calcstat(sd);
			clif_sendstatus(sd, SFLAG_FULLSTATS | SFLAG_HPMP);
			clif_sendmsg(sd, 5, buf);
			//clif_sendminitext(sd,buf);
		}
	}

	sl_doscript_blargs("characterLog", "bodLog", 1, &sd->bl);
	sd->boditems.bod_count = 0;

	return 0;
}

int clif_checkinvbod(USER* sd) { // handles items in inventory
	float percentage;
	int id;
	char buf[255];
	char escape[255];

	nullpo_ret(0, sd);

	for (int x = 0; x < 52; x++) {
		sd->invslot = x;

		if (!sd->status.inventory[x].id) continue;

		id = sd->status.inventory[x].id;

		if (sd->status.state == 1 && itemdb_breakondeath(sd->status.inventory[x].id) == 1) {
			if (itemdb_protected(sd->status.inventory[x].id) || sd->status.inventory[x].protected >= 1) {
				sd->status.inventory[x].protected -= 1;
				sd->status.inventory[x].dura = itemdb_dura(sd->status.inventory[x].id); //recharge dura
				sprintf(buf, "Your %s has been restored!", itemdb_name(id));
				clif_sendstatus(sd, SFLAG_FULLSTATS | SFLAG_HPMP);
				//clif_sendminitext(sd,buf);
				clif_sendmsg(sd, 5, buf);
				sl_doscript_blargs("characterLog", "invRestore", 1, &sd->bl);
				return 0;
			}

			memcpy(&sd->boditems.item[sd->boditems.bod_count], &sd->status.inventory[x], sizeof(sd->status.inventory[x]));
			sd->boditems.bod_count++;

			sprintf(buf, "Your %s was destroyed!", itemdb_name(id));
			sl_doscript_blargs("characterLog", "invBreak", 1, &sd->bl);

			Sql_EscapeString(sql_handle, escape, sd->status.inventory[x].real_name);

			/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `BreakLogs` (`BrkChaId`, `BrkMapId`, `BrkX`, `BrkY`, `BrkItmId`) VALUES ('%u', '%u', '%u', '%u', '%u')",
					sd->status.id, sd->bl.m, sd->bl.x, sd->bl.y, sd->status.inventory[x].id)) {
				SqlStmt_ShowDebug(sql_handle);
			}*/

			sd->breakid = id;
			sl_doscript_blargs("onBreak", NULL, 1, &sd->bl);
			sl_doscript_blargs(itemdb_yname(id), "on_break", 1, &sd->bl);

			pc_delitem(sd, x, 1, 9);
			clif_sendmsg(sd, 5, buf);
			//clif_sendminitext(sd,buf);
		}

		map_foreachinarea(clif_updatestate, sd->bl.m, sd->bl.x, sd->bl.y, AREA, BL_PC, sd);
	}

	sl_doscript_blargs("characterLog", "bodLog", 1, &sd->bl);
	sd->boditems.bod_count = 0;

	return 0;
}

int clif_senddelitem(USER* sd, int num, int type) {
	/*	Type:
		0 = Remove	5 = Shot	10 = Sold
		1 = Drop	6 = Used	11 = Removed
		2 = Eat		7 = Posted	12 = *Item name*
		3 = Smoke	8 = Decayed	13 = Broke
		4 = Throw	9 = Gave
	*/
	sd->status.inventory[num].id = 0;
	sd->status.inventory[num].dura = 0;
	sd->status.inventory[num].protected = 0;
	sd->status.inventory[num].amount = 0;
	sd->status.inventory[num].owner = 0;
	sd->status.inventory[num].custom = 0;
	sd->status.inventory[num].customLook = 0;
	sd->status.inventory[num].customLookColor = 0;
	sd->status.inventory[num].customIcon = 0;
	sd->status.inventory[num].customIconColor = 0;
	memset(sd->status.inventory[num].trapsTable, 0, 100);

	sd->status.inventory[num].time = 0;
	strcpy(sd->status.inventory[num].real_name, "");

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 9);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x06;
	WFIFOB(sd->fd, 3) = 0x10;
	//WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = num + 1;
	WFIFOB(sd->fd, 6) = type;
	WFIFOB(sd->fd, 7) = 0x00;
	WFIFOB(sd->fd, 8) = 0x00;
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_sendadditem(USER* sd, int num) {
	char buf[128];
	char buf2[128];
	char* name = NULL;
	char* owner = NULL;
	int namelen = 0;
	int len = 0;
	int id = 0;

	id = sd->status.inventory[num].id;

	if (id < 4) {
		memset(&sd->status.inventory[num], 0, sizeof(sd->status.inventory[num]));
		return 0;
	}

	if (id > 0 && (!strcmpi(itemdb_name(id), "??"))) {
		memset(&sd->status.inventory[num], 0, sizeof(sd->status.inventory[num]));
		return 0;
	}

	if (strlen(sd->status.inventory[num].real_name)) {
		name = sd->status.inventory[num].real_name;
	}
	else {
		name = itemdb_name(id);
	}

	if (sd->status.inventory[num].amount > 1) {
		sprintf(buf, "%s (%d)", name, sd->status.inventory[num].amount);
	}
	else if (itemdb_type(sd->status.inventory[num].id) == ITM_SMOKE) {
		sprintf(buf, "%s [%d %s]", name, sd->status.inventory[num].dura, itemdb_text(sd->status.inventory[num].id));
	}
	else if (itemdb_type(sd->status.inventory[num].id) == ITM_BAG) {
		sprintf(buf, "%s [%d]", name, sd->status.inventory[num].dura);
	}
	else if (itemdb_type(sd->status.inventory[num].id) == ITM_MAP) {
		sprintf(buf, "[T%d] %s", sd->status.inventory[num].dura, name);
	}
	else if (itemdb_type(sd->status.inventory[num].id) == ITM_QUIVER) {
		sprintf(buf, "%s [%d]", name, sd->status.inventory[num].dura);
	}
	else {
		sprintf(buf, "%s", name);
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 255);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x0F;
	WFIFOB(sd->fd, 5) = num + 1;

	if (sd->status.inventory[num].customIcon != 0) {
		WFIFOW(sd->fd, 6) = SWAP16(sd->status.inventory[num].customIcon + 49152);
		WFIFOB(sd->fd, 8) = sd->status.inventory[num].customIconColor;
	}
	else {
		WFIFOW(sd->fd, 6) = SWAP16(itemdb_icon(id));
		WFIFOB(sd->fd, 8) = itemdb_iconcolor(id);
	}

	WFIFOB(sd->fd, 9) = strlen(buf);
	memcpy(WFIFOP(sd->fd, 10), buf, strlen(buf));

	len = strlen(buf) + 10;

	WFIFOB(sd->fd, len) = strlen(itemdb_name(id));
	strcpy(WFIFOP(sd->fd, len + 1), itemdb_name(id));
	len += strlen(itemdb_name(id)) + 1;

	WFIFOL(sd->fd, len) = SWAP32(sd->status.inventory[num].amount);
	len += 4;

	if (itemdb_type(id) >= 3 && itemdb_type(id) <= 17) {
		WFIFOB(sd->fd, len) = 0;
		WFIFOL(sd->fd, len + 1) = SWAP32(sd->status.inventory[num].dura);
		WFIFOB(sd->fd, len + 5) = 0; //REPLACE WITH PROTECTED

		if (sd->status.inventory[num].protected >= itemdb_protected(sd->status.inventory[num].id)) WFIFOB(sd->fd, len + 5) = sd->status.inventory[num].protected; // This is the default item protection from the database. it will always override the custom item protection that can be added to items.
		if (itemdb_protected(sd->status.inventory[num].id) >= sd->status.inventory[num].protected) WFIFOB(sd->fd, len + 5) = itemdb_protected(sd->status.inventory[num].id);

		len += 6;
	}
	else {
		if (itemdb_stackamount(sd->status.inventory[num].id) > 1) WFIFOB(sd->fd, len) = 1; // this is for stack
		else WFIFOB(sd->fd, len) = 0;

		WFIFOL(sd->fd, len + 1) = 0;
		WFIFOB(sd->fd, len + 5) = 0;

		if (sd->status.inventory[num].protected >= itemdb_protected(sd->status.inventory[num].id)) WFIFOB(sd->fd, len + 5) = sd->status.inventory[num].protected; // This is the default item protection from the database. it will always override the custom item protection that can be added to items.
		if (itemdb_protected(sd->status.inventory[num].id) >= sd->status.inventory[num].protected) WFIFOB(sd->fd, len + 5) = itemdb_protected(sd->status.inventory[num].id);

		len += 6;
	}

	if (sd->status.inventory[num].owner) {
		owner = map_id2name(sd->status.inventory[num].owner);
		WFIFOB(sd->fd, len) = strlen(owner);
		strcpy(WFIFOP(sd->fd, len + 1), owner);
		len += strlen(owner) + 1;
		FREE(owner);
	}
	else {
		WFIFOB(sd->fd, len) = 0; //len of owner
		len += 1;
	}
	WFIFOW(sd->fd, len) = 0x00;
	len += 2;
	WFIFOB(sd->fd, len) = 0x00;
	len += 1;

	//WFIFOW(sd->fd, len + 9) = SWAP16(0);
	WFIFOW(sd->fd, 1) = SWAP16(len);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_equipit(USER* sd, int id) {
	int len = 0;
	char* nameof = NULL;

	if (strlen(sd->status.equip[id].real_name)) {
		nameof = sd->status.equip[id].real_name;
	}
	else {
		nameof = itemdb_name(sd->status.equip[id].id);
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 255);
	WFIFOB(sd->fd, 5) = clif_getequiptype(id);

	if (sd->status.equip[id].customIcon != 0) {
		WFIFOW(sd->fd, 6) = SWAP16(sd->status.equip[id].customIcon + 49152);
		WFIFOB(sd->fd, 8) = sd->status.equip[id].customIconColor;
	}
	else {
		WFIFOW(sd->fd, 6) = SWAP16(itemdb_icon(sd->status.equip[id].id));
		WFIFOB(sd->fd, 8) = itemdb_iconcolor(sd->status.equip[id].id);
	}

	WFIFOB(sd->fd, 9) = strlen(nameof);
	strcpy(WFIFOP(sd->fd, 10), nameof);
	len += strlen(nameof) + 1;

	WFIFOB(sd->fd, len + 9) = strlen(itemdb_name(sd->status.equip[id].id));
	strcpy(WFIFOP(sd->fd, len + 10), itemdb_name(sd->status.equip[id].id));
	len += strlen(itemdb_name(sd->status.equip[id].id)) + 1;

	WFIFOL(sd->fd, len + 9) = SWAP32(sd->status.equip[id].dura);
	len += 4;
	WFIFOW(sd->fd, len + 9) = 0x0000;
	len += 2;
	WFIFOHEADER(sd->fd, 0x37, len + 6);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}
int clif_sendequip(USER* sd, int id) {
	char buff[256];
	char* name = NULL;
	int msgnum = 0;

	switch (id) {
	case EQ_HELM:
		msgnum = MAP_EQHELM;
		break;
	case EQ_WEAP:
		msgnum = MAP_EQWEAP;
		break;
	case EQ_ARMOR:
		msgnum = MAP_EQARMOR;
		break;
	case EQ_SHIELD:
		msgnum = MAP_EQSHIELD;
		break;
	case EQ_RIGHT:
		msgnum = MAP_EQRIGHT;
		break;
	case EQ_LEFT:
		msgnum = MAP_EQLEFT;
		break;
	case EQ_SUBLEFT:
		msgnum = MAP_EQSUBLEFT;
		break;
	case EQ_SUBRIGHT:
		msgnum = MAP_EQSUBRIGHT;
		break;
	case EQ_FACEACC:
		msgnum = MAP_EQFACEACC;
		break;
	case EQ_CROWN:
		msgnum = MAP_EQCROWN;
		break;
	case EQ_BOOTS:
		msgnum = MAP_EQBOOTS;
		break;
	case EQ_MANTLE:
		msgnum = MAP_EQMANTLE;
		break;
	case EQ_COAT:
		msgnum = MAP_EQCOAT;
		break;
	case EQ_NECKLACE:
		msgnum = MAP_EQNECKLACE;
		break;

	default:
		return -1;
		break;
	}

	if (sd->status.equip[id].id > 0 && !strcmpi(itemdb_name(sd->status.equip[id].id), "??")) {
		memset(&sd->status.equip[id], 0, sizeof(sd->status.equip[id]));
		return 0;
	}

	if (strlen(sd->status.equip[id].real_name)) {
		name = sd->status.equip[id].real_name;
	}
	else {
		name = itemdb_name(sd->status.equip[id].id);
	}

	sprintf(buff, map_msg[msgnum].message, name);
	clif_equipit(sd, id);
	clif_sendminitext(sd, buff);
	return 0;
}

int clif_mapmsgnum(USER* sd, int id) {
	int msgnum = 0;
	switch (id) {
	case EQ_HELM:
		msgnum = MAP_EQHELM;
		break;
	case EQ_WEAP:
		msgnum = MAP_EQWEAP;
		break;
	case EQ_ARMOR:
		msgnum = MAP_EQARMOR;
		break;
	case EQ_SHIELD:
		msgnum = MAP_EQSHIELD;
		break;
	case EQ_RIGHT:
		msgnum = MAP_EQRIGHT;
		break;
	case EQ_LEFT:
		msgnum = MAP_EQLEFT;
		break;
	case EQ_SUBLEFT:
		msgnum = MAP_EQSUBLEFT;
		break;
	case EQ_SUBRIGHT:
		msgnum = MAP_EQSUBRIGHT;
		break;
	case EQ_FACEACC:
		msgnum = MAP_EQFACEACC;
		break;
	case EQ_CROWN:
		msgnum = MAP_EQCROWN;
		break;
	case EQ_BOOTS:
		msgnum = MAP_EQBOOTS;
		break;
	case EQ_MANTLE:
		msgnum = MAP_EQMANTLE;
		break;
	case EQ_COAT:
		msgnum = MAP_EQCOAT;
		break;
	case EQ_NECKLACE:
		msgnum = MAP_EQNECKLACE;
		break;

	default:
		return -1;
		break;
	}

	return msgnum;
}
int clif_sendgroupmessage(USER* sd, unsigned char* msg, int msglen) {
	char buf[300];
	char buf2[65535];
	int i;
	char message[256];

	nullpo_ret(0, sd);
	memset(message, 0, 255);
	memcpy(message, msg, msglen);
	USER* tsd;

	if (classdb_name(sd->status.class, sd->status.mark)) {
		sprintf(buf2, "[!%s] (%s) %s", sd->status.name, classdb_name(sd->status.class, sd->status.mark), message);
	}
	else {
		sprintf(buf2, "[!%s] () %s", sd->status.name, message);
	}

	if (sd->uFlags & uFlag_silenced)
	{
		clif_sendbluemessage(sd, "You are silenced.");
		return 0;
	}

	if (map[sd->bl.m].cantalk == 1 && !sd->status.gm_level) {
		clif_sendminitext(sd, "Your voice is swept away by a strange wind.");
		return 0;
	}

	for (i = 0; i < sd->group_count; i++) {
		tsd = map_id2sd(groups[sd->groupid][i]);
		if (tsd && clif_isignore(sd, tsd)) {
			clif_sendmsg(tsd, 11, buf2);
		}
	}
	return 0;
}
int clif_sendsubpathmessage(USER* sd, unsigned char* msg, int msglen) {
	char buf[300];
	char buf2[65535];
	int i;
	char message[256];

	nullpo_ret(0, sd);
	memset(message, 0, 255);
	memcpy(message, msg, msglen);
	USER* tsd;

	if (classdb_name(sd->status.class, sd->status.mark)) {
		sprintf(buf2, "<@%s> (%s) %s", sd->status.name, classdb_name(sd->status.class, sd->status.mark), message);
	}
	else {
		sprintf(buf2, "<@%s> () %s", sd->status.name, message);
	}

	if (sd->uFlags & uFlag_silenced)
	{
		clif_sendbluemessage(sd, "You are silenced.");
		return 0;
	}

	if (map[sd->bl.m].cantalk == 1 && !sd->status.gm_level) {
		clif_sendminitext(sd, "Your voice is swept away by a strange wind.");
		return 0;
	}

	for (i = 0; i < fd_max; i++) {
		if (session[i] && (tsd = session[i]->session_data) && clif_isignore(sd, tsd)) {
			if (tsd->status.class == sd->status.class) {
				if (tsd->status.subpath_chat) {
					clif_sendmsg(tsd, 11, buf2);
				}
			}
		}
	}

	return 0;
}

int clif_sendclanmessage(USER* sd, unsigned char* msg, int msglen) {
	char buf[300];
	char buf2[65535];
	int i;
	char message[256];
	memset(buf2, 0, 65534);
	memset(message, 0, 255);
	memcpy(message, msg, msglen);
	USER* tsd = NULL;

	if (classdb_name(sd->status.class, sd->status.mark)) {
		sprintf(buf2, "<!%s> (%s) %s", sd->status.name, classdb_name(sd->status.class, sd->status.mark), message);
	}
	else {
		sprintf(buf2, "<!%s> () %s", sd->status.name, message);
	}

	if (sd->uFlags & uFlag_silenced)
	{
		clif_sendbluemessage(sd, "You are silenced.");
		return 0;
	}

	if (map[sd->bl.m].cantalk == 1 && !sd->status.gm_level) {
		clif_sendminitext(sd, "Your voice is swept away by a strange wind.");
		return 0;
	}

	for (i = 0; i < fd_max; i++) {
		if (session[i] && (tsd = session[i]->session_data) && clif_isignore(sd, tsd)) {
			if (tsd->status.clan == sd->status.clan) {
				if (tsd->status.clan_chat) {
					clif_sendmsg(tsd, 12, buf2);
				}
			}
		}
	}

	return 0;
}

int clif_sendnovicemessage(USER* sd, unsigned char* msg, int msglen) {
	char buf[300];
	char buf2[65535];
	int i;
	char message[256];
	memset(buf2, 0, 65534);
	memset(message, 0, 255);
	memcpy(message, msg, msglen);
	USER* tsd = NULL;

	sprintf(buf2, "[Novice](%s) %s> %s", classdb_name(sd->status.class, sd->status.mark), sd->status.name, message);

	if (sd->uFlags & uFlag_silenced)
	{
		clif_sendbluemessage(sd, "You are silenced.");
		return 0;
	}

	if (map[sd->bl.m].cantalk == 1 && !sd->status.gm_level) {
		clif_sendminitext(sd, "Your voice is swept away by a strange wind.");
		return 0;
	}

	if (sd->status.tutor == 0) { // Added to simulate to a non-tutor that their message was indeed sent (since they won't be able to see it)
		clif_sendmsg(sd, 11, buf2); // This function will make it appear on their screen
	}

	for (i = 0; i < fd_max; i++) {
		if (session[i] && (tsd = session[i]->session_data) && clif_isignore(sd, tsd)) {
			if ((tsd->status.tutor || tsd->status.gm_level > 0) && tsd->status.novice_chat) {
				clif_sendmsg(tsd, 12, buf2);
			}
		}
	}

	return 0;
}

int ignorelist_add(USER* sd, const char* name)
{
	//return 0;
	 //int ret=0;

	struct sd_ignorelist* Current = sd->IgnoreList;
	//Make sure name isnt already on list
	while (Current)
	{
		if (strcmpi(Current->name, name) == 0)
			return 1;

		Current = Current->Next;
	}

	//If name wasnt already on list, add it to chain
	struct sd_ignorelist* New = NULL;
	CALLOC(New, struct sd_ignorelist, 1);
	//struct sd_ignorelist *New = (struct sd_ignorelist*)calloc(sizeof(struct sd_ignorelist));

	strcpy(New->name, name);
	New->Next = sd->IgnoreList;
	sd->IgnoreList = New;

	//Return error result
	return 0;
}

int ignorelist_remove(USER* sd, const char* name)
{
	char IgBuffer[32];
	char IgCmp[32];

	strcpy(IgBuffer, name);
	//strlwr(IgBuffer);

	int ret = 1; //Default error = name not found on list

	if (sd->IgnoreList)
	{
		struct sd_ignorelist* Current = sd->IgnoreList;
		struct sd_ignorelist* Prev = NULL;
		while (Current)
		{
			strcpy(IgCmp, Current->name);
			//strlwr(IgCmp);

			if (strcmpi(IgCmp, IgBuffer) == 0)
			{
				ret = 0; break;
			}

			Prev = Current;
			Current = Current->Next;
		}

		//If found name to delete
		if (ret == 0)
		{
			if (Prev)
			{
				Prev->Next = Current->Next;
				//Current->Next=NULL;
				//Current->Prev=NULL;
				FREE(Current);
			}
			else
			{
				FREE(sd->IgnoreList);
				sd->IgnoreList = NULL;
			}
		}
	}
	else ret = 2; //Set error to empty ignore list, therefore name not on list

	return ret;
}

int clif_isignore(USER* sd, USER* dst_sd) {
	struct sd_ignorelist* Current = dst_sd->IgnoreList;
	char LowerName[32];
	char IgCmp[32];

	strcpy(LowerName, sd->status.name);

	while (Current) {
		strcpy(IgCmp, Current->name);

		if (strcmpi(IgCmp, LowerName) == 0) return 0;

		Current = Current->Next;
	}

	Current = sd->IgnoreList;
	strcpy(LowerName, dst_sd->status.name);

	while (Current) {
		strcpy(IgCmp, Current->name);

		if (strcmpi(IgCmp, LowerName) == 0) return 0;

		Current = Current->Next;
	}

	return 1;
}

int canwhisper(USER* sd, USER* dst_sd)
{
	if (!dst_sd)	return 0;

	//int ret=1;
	if (sd->uFlags & uFlag_silenced) return 0;
	else if (!sd->status.gm_level && !(dst_sd->status.settingFlags & FLAG_WHISPER)) { return 0; }
	else if (!sd->status.gm_level)
	{
		return clif_isignore(sd, dst_sd);
	}

	return 1;
}
int clif_parsewisp(USER* sd) {
	char dst_name[100];
	char strText[255];
	USER* dst_sd = NULL;
	int dstlen, srclen, msglen, afklen;
	unsigned char buf[255];
	char msg[100];
	char afk[100];
	char escape[255];

	//StringBuf buf;

	//StringBuf_Init(&buf);

	if (!(sd->status.settingFlags & FLAG_WHISPER) && !(sd->status.gm_level))
	{
		clif_sendbluemessage(sd, "You have whispering turned off.");
		return 0;
	}

	if (sd->uFlags & uFlag_silenced)
	{
		clif_sendbluemessage(sd, "You are silenced.");
		return 0;
	}

	if (map[sd->bl.m].cantalk == 1 && !sd->status.gm_level) {
		clif_sendminitext(sd, "Your voice is swept away by a strange wind.");
		return 0;
	}

	nullpo_ret(0, sd);
	dstlen = RFIFOB(sd->fd, 5);

	srclen = strlen(sd->status.name);
	msglen = RFIFOB(sd->fd, 6 + dstlen);

	if ((msglen > 80) || (dstlen > 80) || (dstlen > RFIFOREST(sd->fd)) || (dstlen > SWAP16(RFIFOW(sd->fd, 1))) || (msglen > RFIFOREST(sd->fd)) || (msglen > SWAP16(RFIFOW(sd->fd, 1)))) {
		clif_Hacker(sd->status.name, "Whisper packet");
		return 0;
	}

	memset(dst_name, 0, 80);
	memset(msg, 0, 80);

	memcpy(dst_name, RFIFOP(sd->fd, 6), dstlen);
	memcpy(msg, RFIFOP(sd->fd, 7 + dstlen), msglen);

	msg[80] = '\0';

	/*
		if(!strcmpi(dst_name,sd->status.name)) {
			clif_sendbluemessage(sd, "Cannot whisper yourself!");
			return 0;
		}
	*/
	Sql_EscapeString(sql_handle, escape, msg);

	if (!strcmp(dst_name, "!")) {
		if (sd->status.clan == 0) {
			clif_sendbluemessage(sd, "You are not in a clan");
		}
		else {
			if (sd->status.clan_chat) {
				sl_doscript_strings("characterLog", "clanChatLog", 2, sd->status.name, msg);
				clif_sendclanmessage(sd, RFIFOP(sd->fd, 7 + dstlen), msglen);
			}
			else {
				clif_sendbluemessage(sd, "Clan chat is off.");
			}
		}
	}
	else if (!strcmp(dst_name, "!!")) {
		if (sd->group_count == 0) {
			clif_sendbluemessage(sd, "You are not in a group");
		}
		else {
			sl_doscript_strings("characterLog", "groupChatLog", 2, sd->status.name, msg);
			clif_sendgroupmessage(sd, RFIFOP(sd->fd, 7 + dstlen), msglen);
		}
	}
	else if (!strcmp(dst_name, "@")) {
		if (classdb_chat(sd->status.class)) {
			sl_doscript_strings("characterLog", "subPathChatLog", 2, sd->status.name, msg);
			clif_sendsubpathmessage(sd, RFIFOP(sd->fd, 7 + dstlen), msglen);
		}
		else {
			clif_sendbluemessage(sd, "You cannot do that.");
		}
	}
	else if (!strcmp(dst_name, "?")) {
		if (sd->status.tutor == 0 && sd->status.gm_level == 0) {
			if (sd->status.level < 99) {
				sl_doscript_strings("characterLog", "noviceChatLog", 2, sd->status.name, msg);
				clif_sendnovicemessage(sd, RFIFOP(sd->fd, 7 + dstlen), msglen);
			}
			else {
				clif_sendbluemessage(sd, "You cannot do that.");
			}
		}
		else {
			sl_doscript_strings("characterLog", "noviceChatLog", 2, sd->status.name, msg);
			clif_sendnovicemessage(sd, RFIFOP(sd->fd, 7 + dstlen), msglen);
		}
	}
	else {
		dst_sd = map_name2sd(dst_name);
		if (!dst_sd) {
			sprintf(strText, "%s is nowhere to be found.", dst_name);
			clif_sendbluemessage(sd, strText);
		}
		else {
			if (canwhisper(sd, dst_sd)) {
				if (dst_sd->afk && strcmp(dst_sd->afkmessage, "") != 0) {
					sl_doscript_strings("characterLog", "whisperLog", 3, dst_sd->status.name, sd->status.name, msg);

					clif_sendwisp(dst_sd, sd->status.name, msg);
					clif_sendwisp(dst_sd, dst_sd->status.name, dst_sd->afkmessage);

					if (!sd->status.gm_level && (dst_sd->optFlags & optFlag_stealth)) {
						sprintf(strText, "%s is nowhere to be found.", dst_name);
					}
					else {
						clif_retrwisp(sd, dst_sd->status.name, msg);
						clif_retrwisp(sd, dst_sd->status.name, dst_sd->afkmessage);
					}
				}
				else {
					sl_doscript_strings("characterLog", "whisperLog", 3, dst_sd->status.name, sd->status.name, msg);

					clif_sendwisp(dst_sd, sd->status.name, msg);

					if (!sd->status.gm_level && (dst_sd->optFlags & optFlag_stealth)) {
						sprintf(strText, "%s is nowhere to be found.", dst_name);
						clif_sendbluemessage(sd, strText);
					}
					else {
						clif_retrwisp(sd, dst_sd->status.name, msg);
					}
				}
			}
			else {
				clif_sendbluemessage(sd, "They cannot hear you right now.");
			}
		}
	}
	return 0;
}

int clif_sendsay(USER* sd, char* msg, int msglen, int type) {
	char i;
	/*	Type:
		0 = Talk
		1 = Shout
		2 = Skill
	*/
	if (type == 1) {
		sd->talktype = 1;
		strcpy(sd->speech, msg);
	}
	else {
		sd->talktype = 0;
		strcpy(sd->speech, msg);
	}

	for (i = 0; i < MAX_SPELLS; i++) {
		if (sd->status.skill[i] > 0) {
			sl_doscript_blargs(magicdb_yname(sd->status.skill[i]), "on_say", 1, &sd->bl);
		}
	}
	sl_doscript_blargs("onSay", NULL, 1, &sd->bl);
}

int clif_sendscriptsay(USER* sd, char* msg, int msglen, int type) {
	char* buf;
	char name[25];
	char escape[255];
	int namelen = strlen(sd->status.name);

	if (map[sd->bl.m].cantalk == 1 && !sd->status.gm_level) {
		clif_sendminitext(sd, "Your voice is swept away by a strange wind.");
		return 0;
	}

	Sql_EscapeString(sql_handle, escape, msg);

	if (is_command(sd, msg, msglen)) {
		/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SayLogs` (`SayChaId`, `SayMessage`, `SayType`) VALUES ('%u', '%s', '%s')",
			sd->status.id, escape, "Slash")) {
			SqlStmt_ShowDebug(sql_handle);
		}*/

		return 0;
	}

	if (sd->uFlags & uFlag_silenced)
	{
		clif_sendminitext(sd, "Shut up for now. ^^");
		return 0;
	}

	/*switch (type) {
		case 1:
			if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SayLogs` (`SayChaId`, `SayMessage`, `SayType`) VALUES ('%u', '%s', '%s')",
				sd->status.id, escape, "Yell")) {
				SqlStmt_ShowDebug(sql_handle);
			}

			break;
		case 10:
			if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SayLogs` (`SayChaId`, `SayMessage`, `SayType`) VALUES ('%u', '%s', '%s')",
				sd->status.id, escape, "English")) {
				SqlStmt_ShowDebug(sql_handle);
			}

			break;
		case 11:
			if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SayLogs` (`SayChaId`, `SayMessage`, `SayType`) VALUES ('%u', '%s', '%s')",
				sd->status.id, escape, "Spanish")) {
				SqlStmt_ShowDebug(sql_handle);
			}

			break;
		case 12:
			if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SayLogs` (`SayChaId`, `SayMessage`, `SayType`) VALUES ('%u', '%s', '%s')",
				sd->status.id, escape, "French")) {
				SqlStmt_ShowDebug(sql_handle);
			}

			break;
		case 13:
			if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SayLogs` (`SayChaId`, `SayMessage`, `SayType`) VALUES ('%u', '%s', '%s')",
				sd->status.id, escape, "Chinese")) {
				SqlStmt_ShowDebug(sql_handle);
			}

			break;
		case 14:
			if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SayLogs` (`SayChaId`, `SayMessage`, `SayType`) VALUES ('%u', '%s', '%s')",
				sd->status.id, escape, "Portuguese")) {
				SqlStmt_ShowDebug(sql_handle);
			}

			break;
		case 15:
			if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SayLogs` (`SayChaId`, `SayMessage`, `SayType`) VALUES ('%u', '%s', '%s')",
				sd->status.id, escape, "Bahasa")) {
				SqlStmt_ShowDebug(sql_handle);
			}

			break;
		default:
			if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SayLogs` (`SayChaId`, `SayMessage`, `SayType`) VALUES ('%u', '%s', '%s')",
				sd->status.id, escape, "Say")) {
				SqlStmt_ShowDebug(sql_handle);
			}

			break;
	}*/
	//Log_Add("Say","<%02d:%02d> %s -> %s\n",getHour(),getMinute(),sd->status.name, msg);

	if (type >= 10) {
		namelen += 4;

		if (!session[sd->fd])
		{
			session[sd->fd]->eof = 8;
			return 0;
		}

		WFIFOHEAD(sd->fd, msglen + namelen + 13);
		CALLOC(buf, char, 16 + namelen + msglen);
		WBUFB(buf, 0) = 0xAA;
		WBUFW(buf, 1) = SWAP16(10 + namelen + msglen);
		WBUFB(buf, 3) = 0x0D;
		//WBUFB(buf, 4) = 0x03;
		WBUFB(buf, 5) = type;
		WBUFL(buf, 6) = SWAP32(sd->status.id);
		WBUFB(buf, 10) = namelen + msglen + 2;
		switch (type) {
		case 10:
			sprintf(name, "EN[%s]", sd->status.name);
			break;
		case 11:
			sprintf(name, "ES[%s]", sd->status.name);
			break;
		case 12:
			sprintf(name, "FR[%s]", sd->status.name);
			break;
		case 13:
			sprintf(name, "CN[%s]", sd->status.name);
			break;
		case 14:
			sprintf(name, "PT[%s]", sd->status.name);
			break;
		case 15:
			sprintf(name, "ID[%s]", sd->status.name);
			break;
		default:
			break;
		}
		memcpy(WBUFP(buf, 11), name, namelen);
		WBUFB(buf, 11 + namelen) = ':';
		WBUFB(buf, 12 + namelen) = ' ';
		memcpy(WBUFP(buf, 13 + namelen), msg, msglen);
		//crypt(WBUFP(buf, 0));
		clif_send(buf, 16 + namelen + msglen, &sd->bl, SAMEAREA);
	}
	else {
		if (!session[sd->fd])
		{
			session[sd->fd]->eof = 8;
			return 0;
		}

		WFIFOHEAD(sd->fd, msglen + namelen + 13);
		CALLOC(buf, char, 16 + namelen + msglen);
		WBUFB(buf, 0) = 0xAA;
		WBUFW(buf, 1) = SWAP16(10 + namelen + msglen);
		WBUFB(buf, 3) = 0x0D;
		//WBUFB(buf, 4) = 0x03;
		WBUFB(buf, 5) = type;
		WBUFL(buf, 6) = SWAP32(sd->status.id);
		WBUFB(buf, 10) = namelen + msglen + 2;
		memcpy(WBUFP(buf, 11), sd->status.name, namelen);
		if (type == 1)
			WBUFB(buf, 11 + namelen) = '!';
		else
			WBUFB(buf, 11 + namelen) = ':';
		WBUFB(buf, 12 + namelen) = ' ';
		memcpy(WBUFP(buf, 13 + namelen), msg, msglen);
		//crypt(WBUFP(buf, 0));
		if (type == 1) {
			clif_send(buf, 16 + namelen + msglen, &sd->bl, SAMEMAP);
		}
		else {
			clif_send(buf, 16 + namelen + msglen, &sd->bl, SAMEAREA);
		}
	}

	strcpy(sd->speech, msg);

	if (type == 1) {
		map_foreachinarea(clif_sendnpcyell, sd->bl.m, sd->bl.x, sd->bl.y, SAMEMAP, BL_NPC, msg, sd);
		map_foreachinarea(clif_sendmobyell, sd->bl.m, sd->bl.x, sd->bl.y, SAMEMAP, BL_MOB, msg, sd);
	}
	else {
		map_foreachinarea(clif_sendnpcsay, sd->bl.m, sd->bl.x, sd->bl.y, AREA, BL_NPC, msg, sd);
		map_foreachinarea(clif_sendmobsay, sd->bl.m, sd->bl.x, sd->bl.y, AREA, BL_MOB, msg, sd);
	}
	FREE(buf);
	return 0;
}

int clif_distance(struct block_list* bl, struct block_list* bl2) {
	int distance = 0;

	distance += abs(bl->x - bl2->x);
	distance += abs(bl->y - bl2->y);

	//printf("distance: %i\n",distance);
	return distance;
}

int clif_sendnpcsay(struct block_list* bl, va_list ap) {
	NPC* nd = NULL;
	USER* sd = NULL;
	char* msg = NULL;
	char temp[256];
	char* temp2 = NULL;
	char temp3[256];

	if (bl->subtype != SCRIPT) return 0;

	msg = va_arg(ap, char*);
	nullpo_ret(0, sd = va_arg(ap, USER*));
	nullpo_ret(0, nd = (NPC*)bl);

	if (clif_distance(&sd->bl, &nd->bl) <= 10) {
		sd->last_click = bl->id;
		sl_async_freeco(sd);
		sl_doscript_blargs(nd->name, "onSayClick", 2, &sd->bl, &nd->bl);
	}

	return 0;
}

int clif_sendmobsay(struct block_list* bl, va_list ap) {
	/*MOB* mob = NULL;
	USER* sd = NULL;
	char* msg = NULL;
	char temp[256];
	char* temp2 = NULL;
	char temp3[256];

	msg = va_arg(ap, char*);
	nullpo_ret(0, sd = va_arg(ap, USER*));
	nullpo_ret(0, mob = (MOB*)bl);

	if (bl->type != BL_MOB) return 0;
	if (mob->data->subtype != 4) return 0;

	if (clif_distance(&sd->bl,&mob->bl) <= 10) {
		sd->last_click=bl->id;
		sl_async_freeco(sd);
		sl_doscript_blargs(mob->data->yname, "onSayClick", 2, &sd->bl, &mob->bl);
	}*/

	return 0;
}

int clif_sendnpcyell(struct block_list* bl, va_list ap) {
	NPC* nd = NULL;
	USER* sd = NULL;
	char* msg = NULL;
	char temp[256];
	char* temp2 = NULL;
	char temp3[256];

	if (bl->subtype != SCRIPT) return 0;

	msg = va_arg(ap, char*);
	nullpo_ret(0, sd = va_arg(ap, USER*));
	nullpo_ret(0, nd = (NPC*)bl);

	if (clif_distance(&sd->bl, &nd->bl) <= 20) {
		sd->last_click = bl->id;
		sl_async_freeco(sd);
		sl_doscript_blargs(nd->name, "onSayClick", 2, &sd->bl, &nd->bl); // calls same speech script as everything else, just within range now
	}

	return 0;
}

int clif_sendmobyell(struct block_list* bl, va_list ap) {
	/*MOB* mob = NULL;
	USER* sd = NULL;
	char* msg = NULL;
	char temp[256];
	char* temp2 = NULL;
	char temp3[256];

	msg = va_arg(ap, char*);
	nullpo_ret(0, sd = va_arg(ap, USER*));
	nullpo_ret(0, mob = (MOB*)bl);

	if (bl->type != BL_MOB) return 0;
	if (mob->data->subtype != 4) return 0;

	if (clif_distance(&sd->bl,&mob->bl) <= 20) {
		sd->last_click=bl->id;
		sl_async_freeco(sd);
		sl_doscript_blargs(mob->data->yname, "onSayClick", 2, &sd->bl, &mob->bl); // calls same speech script as everything else, just within range now
	}*/

	return 0;
}

int clif_speak(struct block_list* bl, va_list ap) {
	struct block_list* nd = NULL;
	USER* sd = NULL;
	char* msg = NULL;
	int len;
	int type;

	msg = va_arg(ap, char*);
	nullpo_ret(0, nd = va_arg(ap, struct block_list*));
	type = va_arg(ap, int);
	nullpo_ret(0, sd = (USER*)bl);
	len = strlen(msg);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, strlen(msg) + 11);
	WFIFOB(sd->fd, 5) = type;
	WFIFOL(sd->fd, 6) = SWAP32(nd->id);
	WFIFOB(sd->fd, 10) = len;
	len = len + 8;
	strcpy(WFIFOP(sd->fd, 11), msg);

	WFIFOHEADER(sd->fd, 0x0D, len);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_parseignore(USER* sd) {
	unsigned char iCmd = RFIFOB(sd->fd, 5);
	unsigned char nLen = RFIFOB(sd->fd, 6);
	char nameBuf[32];

	memset(nameBuf, 0, 32);
	if (nLen <= 16)
		switch (iCmd)
		{
			//Add name
		case 0x02:

			memcpy(nameBuf, RFIFOP(sd->fd, 7), nLen);
			//nameBuf[nLen]=0x00;
			ignorelist_add(sd, nameBuf);

			break;

			//Remove name
		case 0x03:
			memcpy(nameBuf, RFIFOP(sd->fd, 7), nLen);
			//nameBuf[nLen]=0x00;
			ignorelist_remove(sd, nameBuf);

			break;
		}
}

int clif_parsesay(USER* sd) {
	char i;
	char* msg = RFIFOP(sd->fd, 7);

	sd->talktype = RFIFOB(sd->fd, 5);

	if (sd->talktype > 1 || RFIFOB(sd->fd, 6) > 100) {
		clif_sendminitext(sd, "I just told the GM on you!");
		printf("Talk Hacker: %s\n", sd->status.name);
		return 0;
	}

	//memcpy(msg,RFIFOP(sd->fd, 7),RFIFOB(sd->fd, 6));
	strcpy(sd->speech, msg);
	for (i = 0; i < MAX_SPELLS; i++) {
		if (sd->status.skill[i] > 0) {
			sl_doscript_blargs(magicdb_yname(sd->status.skill[i]), "on_say", 1, &sd->bl);
		}
	}
	sl_doscript_blargs("onSay", NULL, 1, &sd->bl);

	/*if(map[sd->bl.m].cantalk==1 && !sd->status.gm_level) {
		clif_sendminitext(sd,"Your voice is swept away by a strange wind.");
		return 0;
	}

	if (is_command(sd, RFIFOP(sd->fd, 7), RFIFOB(sd->fd, 6)))
		return 0;

	if(sd->uFlags&uFlag_silenced)
	{
		clif_sendminitext(sd,"Shut up for now. ^^");
		return 0;
	}

	Log_Add("Say","<%02d:%02d> %s -> %s\n",getHour(),getMinute(),sd->status.name, msg);
	clif_sendsay(sd, RFIFOP(sd->fd, 7), RFIFOB(sd->fd, 6), tMode);*/
	return 0;
}
int clif_destroyold(USER* sd) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 6);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(3);
	WFIFOB(sd->fd, 3) = 0x58;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0x00;
	//WFIFOB(sd->fd,6)=0x00;
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_refresh(USER* sd) {
	clif_sendmapinfo(sd);
	clif_sendxy(sd);
	clif_mob_look_start(sd);
	map_foreachinarea(clif_object_look_sub, sd->bl.m, sd->bl.x, sd->bl.y, SAMEAREA, BL_ALL, LOOK_GET, sd);
	clif_mob_look_close(sd);
	clif_destroyold(sd);
	clif_sendchararea(sd);
	clif_getchararea(sd);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 5);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(2);
	WFIFOB(sd->fd, 3) = 0x22;
	WFIFOB(sd->fd, 4) = 0x03;
	set_packet_indexes(WFIFOP(sd->fd, 0));
	WFIFOSET(sd->fd, 5 + 3);
	//sd->refresh_check=1;

	if (!map[sd->bl.m].canGroup) {
		char buff[256];
		sd->status.settingFlags ^= FLAG_GROUP;

		if (sd->status.settingFlags & FLAG_GROUP) { // not enabled
			//sprintf(buff,"Join a group     :ON");
		}
		else {
			if (sd->group_count > 0) {
				clif_leavegroup(sd);
			}

			sprintf(buff, "Join a group     :OFF");
			clif_sendstatus(sd, NULL);
			clif_sendminitext(sd, buff);
		}
	}

	return 0;
}

int clif_refreshnoclick(USER* sd)
{
	clif_sendmapinfo(sd);
	clif_sendxynoclick(sd);
	clif_mob_look_start(sd);
	map_foreachinarea(clif_object_look_sub, sd->bl.m, sd->bl.x, sd->bl.y, SAMEAREA, BL_ALL, LOOK_GET, sd);
	clif_mob_look_close(sd);
	clif_destroyold(sd);
	clif_sendchararea(sd);
	clif_getchararea(sd);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 5);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(2);
	WFIFOB(sd->fd, 3) = 0x22;
	WFIFOB(sd->fd, 4) = 0x03;
	set_packet_indexes(WFIFOP(sd->fd, 0));
	WFIFOSET(sd->fd, 5 + 3);

	if (!map[sd->bl.m].canGroup) {
		char buff[256];
		sd->status.settingFlags ^= FLAG_GROUP;

		if (sd->status.settingFlags & FLAG_GROUP) { // not enabled
			//sprintf(buff,"Join a group     :ON");
		}
		else {
			if (sd->group_count > 0) {
				clif_leavegroup(sd);
			}

			sprintf(buff, "Join a group     :OFF");
			clif_sendstatus(sd, NULL);
			clif_sendminitext(sd, buff);
		}
	}

	//sd->refresh_check=1;
	return 0;
}

int clif_sendupdatestatus(USER* sd) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 33);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x1C;
	WFIFOB(sd->fd, 3) = 0x08;
	//WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0x38;
	WFIFOL(sd->fd, 6) = SWAP32(sd->status.hp);
	WFIFOL(sd->fd, 10) = SWAP32(sd->status.mp);
	WFIFOL(sd->fd, 14) = SWAP32(sd->status.exp);
	WFIFOL(sd->fd, 18) = SWAP32(sd->status.money);
	WFIFOL(sd->fd, 22) = 0x00;
	WFIFOB(sd->fd, 26) = 0x00;
	WFIFOB(sd->fd, 27) = 0x00;
	WFIFOB(sd->fd, 28) = sd->blind;
	WFIFOB(sd->fd, 29) = sd->drunk;
	WFIFOB(sd->fd, 30) = 0x00;
	WFIFOB(sd->fd, 31) = 0x73;
	WFIFOB(sd->fd, 32) = 0x35;
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_sendupdatestatus2(USER* sd) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	float percentage = clif_getXPBarPercent(sd);

	WFIFOHEAD(sd->fd, 25);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x08;
	WFIFOB(sd->fd, 5) = 0x18;
	WFIFOL(sd->fd, 6) = SWAP32(sd->status.exp);
	WFIFOL(sd->fd, 10) = SWAP32(sd->status.money);
	WFIFOB(sd->fd, 14) = (int)percentage;
	WFIFOB(sd->fd, 15) = sd->drunk;
	WFIFOB(sd->fd, 16) = sd->blind;
	WFIFOB(sd->fd, 17) = 0x00;
	WFIFOB(sd->fd, 18) = 0x00; // hear others
	WFIFOB(sd->fd, 19) = 0x00;
	WFIFOB(sd->fd, 20) = sd->flags;
	WFIFOB(sd->fd, 21) = 0x01;
	WFIFOL(sd->fd, 22) = SWAP32(sd->status.settingFlags);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

clif_sendupdatestatus_onkill(USER* sd) {
	int tnl = clif_getLevelTNL(sd);
	int len = 0;
	nullpo_ret(0, sd);
	float percentage = clif_getXPBarPercent(sd);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 33);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x1C;
	WFIFOB(sd->fd, 3) = 0x08;
	WFIFOB(sd->fd, 5) = 0x19; // packet subtype 24 = take damage, 25 = onKill,  88 = unEquip, 89 = Equip

	WFIFOL(sd->fd, 6) = SWAP32(sd->status.exp);
	WFIFOL(sd->fd, 10) = SWAP32(sd->status.money);

	WFIFOB(sd->fd, 14) = (int)percentage; //exp percent
	WFIFOB(sd->fd, 15) = sd->drunk;
	WFIFOB(sd->fd, 16) = sd->blind;
	WFIFOB(sd->fd, 17) = 0;
	WFIFOB(sd->fd, 18) = 0; // hear others
	WFIFOB(sd->fd, 19) = 0; // seeminly nothing
	WFIFOB(sd->fd, 20) = sd->flags; //1=New parcel, 16=new Message, 17=New Parcel + Message
	WFIFOB(sd->fd, 21) = 0; // seemingly nothing
	WFIFOL(sd->fd, 22) = SWAP32(sd->status.settingFlags);
	WFIFOL(sd->fd, 26) = SWAP32(tnl);
	WFIFOB(sd->fd, 30) = sd->armor;
	WFIFOB(sd->fd, 31) = sd->dam;
	WFIFOB(sd->fd, 32) = sd->hit;
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_getLevelTNL(USER* sd) {
	int tnl = 0;

	int currLevelExp, nextLevelExp = 0;
	int path = sd->status.class;
	int level = sd->status.level;
	if (path > 5) path = classdb_path(path);

	if (level < 99) tnl = classdb_level(path, level) - sd->status.exp;

	return tnl;
}

float clif_getXPBarPercent(USER* sd) {
	float percentage;

	int path = sd->status.class;
	int level = sd->status.level;
	int expInLevel = 0;
	int tnl = 0;

	if (path > 5) path = classdb_path(path);

	path = sd->status.class;
	level = sd->status.level;
	if (path > 5) path = classdb_path(path);
	if (level < 99) {
		expInLevel = classdb_level(path, level);
		expInLevel -= classdb_level(path, level - 1);
		tnl = classdb_level(path, level) - (sd->status.exp);
		percentage = (((float)(expInLevel - tnl)) / (expInLevel)) * 100;

		if (!sd->underLevelFlag && sd->status.exp < classdb_level(path, level - 1)) sd->underLevelFlag = sd->status.level;

		if (sd->underLevelFlag != sd->status.level) sd->underLevelFlag = 0; // means we leveled, unset flag

		if (sd->underLevelFlag) percentage = ((float)sd->status.exp / classdb_level(path, level)) * 100;
	}
	else {
		percentage = ((float)sd->status.exp / 4294967295) * 100;
	}

	return percentage;
}

clif_sendupdatestatus_onequip(USER* sd) {
	int tnl = clif_getLevelTNL(sd);
	int len = 0;
	nullpo_ret(0, sd);
	float percentage = clif_getXPBarPercent(sd);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 62);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 65;
	WFIFOB(sd->fd, 3) = 0x08;
	WFIFOB(sd->fd, 5) = 89; // packet subtype 24 = take damage, 25 = onKill,  88 = unEquip, 89 = Equip

	WFIFOB(sd->fd, 6) = 0x00;
	WFIFOB(sd->fd, 7) = sd->status.country;
	WFIFOB(sd->fd, 8) = sd->status.totem;
	WFIFOB(sd->fd, 9) = 0x00;
	WFIFOB(sd->fd, 10) = sd->status.level;
	WFIFOL(sd->fd, 11) = SWAP32(sd->max_hp);
	WFIFOL(sd->fd, 15) = SWAP32(sd->max_mp);
	WFIFOB(sd->fd, 19) = sd->might;
	WFIFOB(sd->fd, 20) = sd->will;
	WFIFOB(sd->fd, 21) = 0x03;
	WFIFOB(sd->fd, 22) = 0x03;
	WFIFOB(sd->fd, 23) = sd->grace;
	WFIFOB(sd->fd, 24) = 0;
	WFIFOB(sd->fd, 25) = 0;
	WFIFOB(sd->fd, 26) = 0;
	WFIFOB(sd->fd, 27) = 0;
	WFIFOB(sd->fd, 28) = 0;
	WFIFOB(sd->fd, 29) = 0;
	WFIFOB(sd->fd, 30) = 0;
	WFIFOB(sd->fd, 31) = 0;
	WFIFOB(sd->fd, 32) = 0;
	WFIFOB(sd->fd, 33) = 0;
	WFIFOB(sd->fd, 34) = sd->status.maxinv;
	WFIFOL(sd->fd, 35) = SWAP32(sd->status.exp);
	WFIFOL(sd->fd, 39) = SWAP32(sd->status.money);
	WFIFOB(sd->fd, 43) = (int)percentage;

	WFIFOB(sd->fd, 44) = sd->drunk; // drunk
	WFIFOB(sd->fd, 45) = sd->blind; // blind
	WFIFOB(sd->fd, 46) = 0x00;
	WFIFOB(sd->fd, 47) = 0x00; // hear others
	WFIFOB(sd->fd, 48) = 0x00;
	WFIFOB(sd->fd, 49) = sd->flags;
	WFIFOB(sd->fd, 50) = 0x00;
	WFIFOL(sd->fd, 51) = SWAP32(sd->status.settingFlags);
	WFIFOL(sd->fd, 55) = SWAP32(tnl);
	WFIFOB(sd->fd, 59) = sd->armor;
	WFIFOB(sd->fd, 60) = sd->dam;
	WFIFOB(sd->fd, 61) = sd->hit;

	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

clif_sendupdatestatus_onunequip(USER* sd) {
	int tnl = clif_getLevelTNL(sd);
	int len = 0;
	nullpo_ret(0, sd);
	float percentage = clif_getXPBarPercent(sd);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 52);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 55;
	WFIFOB(sd->fd, 3) = 0x08;
	WFIFOB(sd->fd, 5) = 88; // packet subtype 24 = take damage, 25 = onKill,  88 = unEquip, 89 = Equip

	WFIFOB(sd->fd, 6) = 0x00;
	WFIFOB(sd->fd, 7) = 20; // dam?
	WFIFOB(sd->fd, 8) = 0x00; // hit?
	WFIFOB(sd->fd, 9) = 0x00;
	WFIFOB(sd->fd, 10) = 0x00; // might?
	WFIFOL(sd->fd, 11) = sd->status.hp;
	WFIFOL(sd->fd, 15) = sd->status.mp;
	WFIFOB(sd->fd, 19) = 0;
	WFIFOB(sd->fd, 20) = 0;
	WFIFOB(sd->fd, 21) = 0;
	WFIFOB(sd->fd, 22) = 0;
	WFIFOB(sd->fd, 23) = 0;
	WFIFOB(sd->fd, 24) = 0;
	WFIFOB(sd->fd, 25) = 0;
	WFIFOB(sd->fd, 26) = sd->armor;
	WFIFOB(sd->fd, 27) = 0;
	WFIFOB(sd->fd, 28) = 0;
	WFIFOB(sd->fd, 29) = 0;
	WFIFOB(sd->fd, 30) = 0;
	WFIFOB(sd->fd, 31) = 0;
	WFIFOB(sd->fd, 32) = 0;
	WFIFOB(sd->fd, 33) = 0;
	WFIFOB(sd->fd, 34) = 0;
	WFIFOL(sd->fd, 35) = SWAP32(sd->status.exp);
	WFIFOL(sd->fd, 39) = SWAP32(sd->status.money);
	WFIFOB(sd->fd, 43) = (int)percentage;
	WFIFOB(sd->fd, 44) = sd->drunk;
	WFIFOB(sd->fd, 45) = sd->blind;
	WFIFOB(sd->fd, 46) = 0x00;
	WFIFOB(sd->fd, 47) = 0x00; // hear others
	WFIFOB(sd->fd, 48) = 0x00;
	WFIFOB(sd->fd, 49) = sd->flags;
	WFIFOL(sd->fd, 50) = tnl;

	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_sendbluemessage(USER* sd, char* msg) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, strlen(msg) + 8);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x0A;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOW(sd->fd, 5) = 0;
	WFIFOB(sd->fd, 7) = strlen(msg);
	strcpy(WFIFOP(sd->fd, 8), msg);
	WFIFOW(sd->fd, 1) = SWAP16(strlen(msg) + 5);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_playsound(struct block_list* bl, int sound) {
	unsigned char buf2[32];
	WBUFB(buf2, 0) = 0xAA;
	WBUFW(buf2, 1) = SWAP16(0x14);
	WBUFB(buf2, 3) = 0x19;
	WBUFB(buf2, 4) = 0x03;
	WBUFW(buf2, 5) = SWAP16(3);
	WBUFW(buf2, 7) = SWAP16(sound);
	WBUFB(buf2, 9) = 100;
	WBUFW(buf2, 10) = SWAP16(4);
	WBUFL(buf2, 12) = SWAP32(bl->id);
	WBUFB(buf2, 16) = 1;
	WBUFB(buf2, 17) = 0;
	WBUFB(buf2, 18) = 2;
	WBUFB(buf2, 19) = 2;
	WBUFW(buf2, 20) = SWAP16(4);
	WBUFB(buf2, 22) = 0;
	//crypt(WBUFP(buf2,0));
	clif_send(buf2, 32, bl, SAMEAREA);
	return 0;
}
int clif_sendaction(struct block_list* bl, int type, int time, int sound) {
	/*	Type:
		0 = Stand/None	6 = Magic
		1 = Attack	7 = Eat*
		2 = Throw	8 = Eat
		3 = Shot
		4 = Sit
		5 = Sit*
	*/
	USER* sd = NULL;
	unsigned char buf[32];

	WBUFB(buf, 0) = 0xAA;
	WBUFB(buf, 1) = 0x00;
	WBUFB(buf, 2) = 0x0B;
	WBUFB(buf, 3) = 0x1A;
	//WBUFB(buf, 4) = 0x03;
	WBUFL(buf, 5) = SWAP32(bl->id);
	WBUFB(buf, 9) = type;
	WBUFB(buf, 10) = 0x00;
	WBUFB(buf, 11) = time;
	WBUFW(buf, 12) = 0x00;
	//crypt(WBUFP(buf, 0));
	clif_send(buf, 32, bl, SAMEAREA);

	if (sound > 0) clif_playsound(bl, sound);

	if (bl->type == BL_PC) {
		sd = (USER*)bl;
		sd->action = type;
		sl_doscript_blargs("onAction", NULL, 1, &sd->bl);
	}

	return 0;
}
int clif_sendmob_action(MOB* mob, int type, int time, int sound) {
	/*	Type:
		0 = Stand/None	6 = Magic
		1 = Attack	7 = Eat*
		2 = Throw	8 = Eat
		3 = Shot
		4 = Sit
		5 = Sit*
	*/
	unsigned char buf[32];
	WBUFB(buf, 0) = 0xAA;
	WBUFB(buf, 1) = 0x00;
	WBUFB(buf, 2) = 0x0B;
	WBUFB(buf, 3) = 0x1A;
	WBUFB(buf, 4) = 0x03;
	WBUFL(buf, 5) = SWAP32(mob->bl.id);
	WBUFB(buf, 9) = type;
	WBUFB(buf, 10) = 0x00;
	WBUFB(buf, 11) = time;
	WBUFB(buf, 12) = 0x00;
	//crypt(WBUFP(buf, 0));
	clif_send(buf, 32, &mob->bl, SAMEAREA);

	if (sound > 0) clif_playsound(&mob->bl, sound);

	return 0;
}
int clif_sendanimation_xy(struct block_list* bl, va_list ap) {
	USER* src = NULL;
	int anim, times, x, y;

	anim = va_arg(ap, int);
	times = va_arg(ap, int);
	x = va_arg(ap, int);
	y = va_arg(ap, int);
	nullpo_ret(0, src = (USER*)bl);

	if (!session[src->fd])
	{
		session[src->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(src->fd, 0x30);
	WFIFOB(src->fd, 0) = 0xAA;
	WFIFOW(src->fd, 1) = SWAP16(14);
	WFIFOB(src->fd, 3) = 0x29;
	WFIFOL(src->fd, 5) = 0;
	WFIFOW(src->fd, 9) = SWAP16(anim);
	WFIFOW(src->fd, 11) = SWAP16(times);
	WFIFOW(src->fd, 13) = SWAP16(x);
	WFIFOW(src->fd, 15) = SWAP16(y);
	WFIFOSET(src->fd, encrypt(src->fd));
	return 0;
}

int clif_sendanimation(struct block_list* bl, va_list ap) {
	struct block_list* t = NULL;
	USER* sd = NULL;
	int anim, times;

	anim = va_arg(ap, int);
	nullpo_ret(0, t = va_arg(ap, struct block_list*));
	nullpo_ret(0, sd = (USER*)bl);
	times = va_arg(ap, int);

	if (sd->status.settingFlags & FLAG_MAGIC) {
		if (!session[sd->fd])
		{
			session[sd->fd]->eof = 8;
			return 0;
		}

		WFIFOHEAD(sd->fd, 13);
		WFIFOB(sd->fd, 0) = 0xAA;
		WFIFOW(sd->fd, 1) = SWAP16(0x0A);
		WFIFOB(sd->fd, 3) = 0x29;
		WFIFOL(sd->fd, 5) = SWAP32(t->id);
		WFIFOW(sd->fd, 9) = SWAP16(anim);
		WFIFOW(sd->fd, 11) = SWAP16(times);
		WFIFOSET(sd->fd, encrypt(sd->fd));
	}

	return 0;
}

int clif_animation(USER* src, USER* sd, int animation, int duration) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(src->fd, 0x0A + 3);
	if (src->status.settingFlags & FLAG_MAGIC) {
		WFIFOB(src->fd, 0) = 0xAA;
		WFIFOW(src->fd, 1) = SWAP16(0x0A);
		WFIFOB(src->fd, 3) = 0x29;
		WFIFOB(src->fd, 4) = 0x03;
		WFIFOL(src->fd, 5) = SWAP32(sd->bl.id);
		WFIFOW(src->fd, 9) = SWAP16(animation);
		WFIFOW(src->fd, 11) = SWAP16(duration / 1000);
		WFIFOSET(src->fd, encrypt(src->fd));
	}
	return 0;
}

int clif_sendanimations(USER* src, USER* sd) {
	int x;
	for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
		if (sd->status.dura_aether[x].duration > 0 && sd->status.dura_aether[x].animation) {
			clif_animation(src, sd, sd->status.dura_aether[x].animation, sd->status.dura_aether[x].duration);
		}
	}
	return 0;
}

int clif_sendmagic(USER* sd, int pos) {
	int len;
	int id;
	int type;
	char* name = NULL;
	char* question = NULL;

	id = sd->status.skill[pos];
	name = magicdb_name(id);
	question = magicdb_question(id);
	type = magicdb_type(id);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 255);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x17;
	//WFIFOB(sd->fd,4)=0x03;
	WFIFOB(sd->fd, 5) = pos + 1;
	WFIFOB(sd->fd, 6) = type; //this is type
	WFIFOB(sd->fd, 7) = strlen(name);
	len = strlen(name);
	strcpy(WFIFOP(sd->fd, 8), name);
	WFIFOB(sd->fd, len + 8) = strlen(question);
	strcpy(WFIFOP(sd->fd, len + 9), question);
	len = len + strlen(question) + 1;

	WFIFOW(sd->fd, 1) = SWAP16(len + 5);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_parsemagic(USER* sd) {
	struct block_list* bl = NULL;
	char* answer = NULL;
	int pos;
	int time;
	int i, x;
	int newtime;
	char msg[255];
	char escape[255];
	int len;
	int q_len = 0;

	pos = RFIFOB(sd->fd, 5) - 1;

	/*if(sd->status.gm_level == 0) {
		if (sd->status.state == 1 && strcmpi(magicdb_yname(sd->status.skill[pos]), "hyun_moo_revival")) { // this checks that you are dead and your spell is NOT hyun_moo_revival_poet
		clif_sendminitext(sd,"Spirits can't do that."); return 0; }

		if (sd->status.state == 3) {
		clif_sendminitext(sd,"You can't do that while riding a mount."); return 0; }
	}*/

	i = clif_has_aethers(sd, sd->status.skill[pos]);

	if (i > 0) {
		time = i / 1000;
		sl_doscript_blargs(magicdb_yname(sd->status.skill[pos]), "on_aethers", 1, &sd->bl);
		len = sprintf(msg, "Wait %d second(s) for aethers to settle.", time);
		clif_sendminitext(sd, msg);
		return 0;
	}

	if (sd->silence > 0 && magicdb_mute(sd->status.skill[pos]) <= sd->silence)
	{
		sl_doscript_blargs(magicdb_yname(sd->status.skill[pos]), "on_mute", 1, &sd->bl);
		clif_sendminitext(sd, "You have been silenced.");
		return 0;
	}

	sd->target = 0;
	sd->attacker = 0;

	switch (magicdb_type(sd->status.skill[pos])) {
	case 1:
		memset(sd->question, 0, 64);
		//for(x=0;x<64;x++) {
		//	if(RFIFOB(sd->fd,x+6)) {
		//		q_len++;
		//	} else {
		//		break;
		//	}
		//}
		//memcpy(sd->question,RFIFOP(sd->fd,6),q_len);
		strcpy(sd->question, RFIFOP(sd->fd, 6));
		Sql_EscapeString(sql_handle, escape, sd->question);

		/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SpellLogs` (`SlgChaId`, `SlgSplId`, `SlgMapId`, `SlgX`, `SlgY`, `SlgType`, `SlgText`) VALUES ('%u', '%u', '%u', '%u', '%u', '%s', '%s')",
		sd->status.id, sd->status.skill[pos], sd->bl.m, sd->bl.x, sd->bl.y, "Question", escape)) {
			SqlStmt_ShowDebug(sql_handle);
		}*/
		break;
	case 2:
		sd->target = SWAP32(RFIFOL(sd->fd, 6));
		sd->attacker = SWAP32(RFIFOL(sd->fd, 6));
		bl = map_id2bl(sd->target);

		if (bl) {
			/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SpellLogs` (`SlgChaId`, `SlgSplId`, `SlgMapId`, `SlgX`, `SlgY`, `SlgType`) VALUES ('%u', '%u', '%u', '%u', '%u', '%s')",
			sd->status.id, sd->status.skill[pos], sd->bl.m, sd->bl.x, sd->bl.y, "Target")) {
				SqlStmt_ShowDebug(sql_handle);
			}*/
		}
		else {
			//printf("User %s has an invalid target with ID: %u\n", sd->status.name, sd->target); // disabled on 12-21-2018. annoying af
		}
		break;
	case 5:
		/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `SpellLogs` (`SlgChaId`, `SlgSplId`, `SlgMapId`, `SlgX`, `SlgY`, `SlgType`) VALUES ('%u', '%u', '%u', '%u', '%u', '%s')",
		sd->status.id, sd->status.skill[pos], sd->bl.m, sd->bl.x, sd->bl.y, "Self")) {
			SqlStmt_ShowDebug(sql_handle);
		}*/

		break;
	default:
		return 0;
		break;
	}

	sl_doscript_blargs("onCast", NULL, 1, &sd->bl);

	if (sd->target) {
		MOB* TheMob = NULL;
		struct block_list* tbl = map_id2bl(sd->target);
		nullpo_ret(0, tbl);

		struct map_sessiondata* tsd = map_id2sd(tbl->id);

		if (tbl)
		{
			if (tbl->type == BL_PC) {
				if ((tsd->optFlags & optFlag_stealth)) { return 0; }
			}

			struct point one = { tbl->m,tbl->x,tbl->y };
			struct point two = { sd->bl.m, sd->bl.x, sd->bl.y };

			if (CheckProximity(one, two, 21) == 1) {
				long health = 0;
				int twill = 0;
				int tprotection = 0;

				if (tbl->type == BL_PC) { health = tsd->status.hp; twill = tsd->will; tprotection = tsd->protection; }
				else if (tbl->type == BL_MOB) { TheMob = (MOB*)map_id2mob(tbl->id); health = TheMob->current_vita; twill = TheMob->will; tprotection = TheMob->protection; }

				if (magicdb_canfail(sd->status.skill[pos]) == 1) {
					//printf("\n");
					int willDiff = twill - sd->will;

					if (willDiff < 0) willDiff = 0;

					int prot = tprotection + (int)((willDiff / 10) + 0.5);
					if (prot < 0) prot = 0;

					//printf("prot: %i\n",prot);
					int failChance = (int)(100 - (pow(0.9, prot) * 100) + 0.5);

					//printf("failChance: %i\n",failChance);

					int castTest = rand() % 100;
					//printf("castTest: %i\n",castTest);
					if (castTest < failChance) { clif_sendminitext(sd, "The magic has been deflected."); return 0; }
				}

				if (health > 0 || tbl->type == BL_PC) { sl_async_freeco(sd); sl_doscript_blargs(magicdb_yname(sd->status.skill[pos]), "cast", 2, &sd->bl, tbl); }
				else if (tbl->type == BL_MOB) {}
			}
		}
	}
	else { sl_async_freeco(sd); sl_doscript_blargs(magicdb_yname(sd->status.skill[pos]), "cast", 2, &sd->bl, NULL); }

	/*
	//logging
	unsigned int amount = 0;
	unsigned int casts = 0;
	SqlStmt* stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `SctValue` FROM `SpellCasts` WHERE `SctChaId` = '%u' AND `SctSplId` = '%u'", sd->status.id, sd->status.skill[pos])
	|| SQL_ERROR == SqlStmt_Execute(stmt)
	|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_UINT, &casts, 0, NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
	}

	if (SQL_SUCCESS == SqlStmt_NextRow(stmt)) {
		amount = casts;
	}

	SqlStmt_Free(stmt);

	if (amount > 0) {
		if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `SpellCasts` SET `SctValue` = '%u' WHERE `SctChaId` = '%u' AND `SctSplId` = '%u'", amount + 1, sd->status.id, sd->status.skill[pos])) {
			Sql_ShowDebug(sql_handle);
		}
	} else {
		if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `SpellCasts` (`SctChaId`, `SctSplId`, `SctValue`) VALUES ('%u', '%u', '%u')", sd->status.id, sd->status.skill[pos], 1)) {
			Sql_ShowDebug(sql_handle);
		}
	}*/
	return 0;
}

int clif_scriptmes(USER* sd, int id, char* msg, int previous, int next) {
	int graphic_id = sd->npc_g;
	int color = sd->npc_gc;
	NPC* nd = map_id2npc((unsigned int)id);
	int type = sd->dialogtype;

	if (nd) {
		nd->lastaction = time(NULL);
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 1024);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x30;
	//WFIFOB(sd->fd,4)=0x03;
	WFIFOW(sd->fd, 5) = SWAP16(1);
	//WFIFOB(sd->fd,5)=val[0];
	WFIFOL(sd->fd, 7) = SWAP32(id);

	if (type == 0) {
		if (graphic_id == 0) {
			WFIFOB(sd->fd, 11) = 0;
		}
		else if (graphic_id >= 49152) {
			WFIFOB(sd->fd, 11) = 2;
		}
		else {
			WFIFOB(sd->fd, 11) = 1;
		}

		WFIFOB(sd->fd, 12) = 1;
		WFIFOW(sd->fd, 13) = SWAP16(graphic_id); // graphic id
		WFIFOB(sd->fd, 15) = color; //graphic color
		WFIFOB(sd->fd, 16) = 1;
		WFIFOW(sd->fd, 17) = SWAP16(graphic_id);
		WFIFOB(sd->fd, 19) = color;
		WFIFOL(sd->fd, 20) = SWAP32(1);
		WFIFOB(sd->fd, 24) = previous; // Previous
		WFIFOB(sd->fd, 25) = next; // Next
		WFIFOW(sd->fd, 26) = SWAP16(strlen(msg));
		strcpy(WFIFOP(sd->fd, 28), msg);
		WFIFOW(sd->fd, 1) = SWAP16(strlen(msg) + 25);
	}
	else if (type == 1) {
		WFIFOB(sd->fd, 11) = 1;
		WFIFOW(sd->fd, 12) = SWAP16(nd->sex);
		WFIFOB(sd->fd, 14) = nd->state;
		WFIFOB(sd->fd, 15) = 0;
		WFIFOW(sd->fd, 16) = SWAP16(nd->equip[EQ_ARMOR].id);
		WFIFOB(sd->fd, 18) = 0;
		WFIFOB(sd->fd, 19) = nd->face;
		WFIFOB(sd->fd, 20) = nd->hair;
		WFIFOB(sd->fd, 21) = nd->hair_color;
		WFIFOB(sd->fd, 22) = nd->face_color;
		WFIFOB(sd->fd, 23) = nd->skin_color;

		//armor
		if (!nd->equip[EQ_ARMOR].id) {
			WFIFOW(sd->fd, 24) = 0xFFFF;
			WFIFOB(sd->fd, 26) = 0;
		}
		else {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_ARMOR].id);

			if (nd->armor_color) {
				WFIFOB(sd->fd, 26) = nd->armor_color;
			}
			else {
				WFIFOB(sd->fd, 26) = nd->equip[EQ_ARMOR].customLookColor;
			}
		}

		//coat
		if (nd->equip[EQ_COAT].id) {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_COAT].id);
			WFIFOB(sd->fd, 26) = nd->equip[EQ_COAT].customLookColor;
		}

		//weap
		if (!nd->equip[EQ_WEAP].id) {
			WFIFOW(sd->fd, 27) = 0xFFFF;
			WFIFOB(sd->fd, 29) = 0;
		}
		else {
			WFIFOW(sd->fd, 27) = SWAP16(nd->equip[EQ_WEAP].id);
			WFIFOB(sd->fd, 29) = nd->equip[EQ_WEAP].customLookColor;
		}

		//shield
		if (!nd->equip[EQ_SHIELD].id) {
			WFIFOW(sd->fd, 30) = 0xFFFF;
			WFIFOB(sd->fd, 32) = 0;
		}
		else {
			WFIFOW(sd->fd, 30) = SWAP16(nd->equip[EQ_SHIELD].id);
			WFIFOB(sd->fd, 32) = nd->equip[EQ_SHIELD].customLookColor;
		}

		//helm
		if (!nd->equip[EQ_HELM].id) {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOB(sd->fd, 34) = 0xFF;
			WFIFOB(sd->fd, 35) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 1;
			WFIFOB(sd->fd, 34) = nd->equip[EQ_HELM].id;
			WFIFOB(sd->fd, 35) = nd->equip[EQ_HELM].customLookColor;
		}

		//faceacc
		if (!nd->equip[EQ_FACEACC].id) {
			WFIFOW(sd->fd, 36) = 0xFFFF;
			WFIFOB(sd->fd, 38) = 0;
		}
		else {
			WFIFOW(sd->fd, 36) = SWAP16(nd->equip[EQ_FACEACC].id);
			WFIFOB(sd->fd, 38) = nd->equip[EQ_FACEACC].customLookColor;
		}

		//crown
		if (!nd->equip[EQ_CROWN].id) {
			WFIFOW(sd->fd, 39) = 0xFFFF;
			WFIFOB(sd->fd, 41) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 39) = SWAP16(nd->equip[EQ_CROWN].id);
			WFIFOB(sd->fd, 41) = nd->equip[EQ_CROWN].customLookColor;
		}

		if (!nd->equip[EQ_FACEACCTWO].id) {
			WFIFOW(sd->fd, 42) = 0xFFFF;
			WFIFOB(sd->fd, 44) = 0;
		}
		else {
			WFIFOW(sd->fd, 42) = SWAP16(nd->equip[EQ_FACEACCTWO].id);
			WFIFOB(sd->fd, 44) = nd->equip[EQ_FACEACCTWO].customLookColor;
		}

		//mantle
		if (!nd->equip[EQ_MANTLE].id) {
			WFIFOW(sd->fd, 45) = 0xFFFF;
			WFIFOB(sd->fd, 47) = 0;
		}
		else {
			WFIFOW(sd->fd, 45) = SWAP16(nd->equip[EQ_MANTLE].id);
			WFIFOB(sd->fd, 47) = nd->equip[EQ_MANTLE].customLookColor;
		}

		//necklace
		if (!nd->equip[EQ_NECKLACE].id) {
			WFIFOW(sd->fd, 48) = 0xFFFF;
			WFIFOB(sd->fd, 50) = 0;
		}
		else {
			WFIFOW(sd->fd, 48) = SWAP16(nd->equip[EQ_NECKLACE].id);
			WFIFOB(sd->fd, 50) = nd->equip[EQ_NECKLACE].customLookColor;
		}

		//boots
		if (!nd->equip[EQ_BOOTS].id) {
			WFIFOW(sd->fd, 51) = SWAP16(nd->sex);
			WFIFOB(sd->fd, 53) = 0;
		}
		else {
			WFIFOW(sd->fd, 51) = SWAP16(nd->equip[EQ_BOOTS].id);
			WFIFOB(sd->fd, 53) = nd->equip[EQ_BOOTS].customLookColor;
		}

		WFIFOB(sd->fd, 54) = 1;
		WFIFOW(sd->fd, 55) = SWAP16(graphic_id);
		WFIFOB(sd->fd, 57) = color;
		WFIFOL(sd->fd, 58) = SWAP32(1);
		WFIFOB(sd->fd, 62) = previous;
		WFIFOB(sd->fd, 63) = next;
		WFIFOW(sd->fd, 64) = SWAP16(strlen(msg));
		strcpy(WFIFOP(sd->fd, 66), msg);
		WFIFOW(sd->fd, 1) = SWAP16(strlen(msg) + 63);
	}
	else if (type == 2) {
		WFIFOB(sd->fd, 11) = 1;
		WFIFOW(sd->fd, 12) = SWAP16(nd->sex);
		WFIFOB(sd->fd, 14) = nd->state;
		WFIFOB(sd->fd, 15) = 0;
		WFIFOW(sd->fd, 16) = SWAP16(nd->gfx.armor);
		WFIFOB(sd->fd, 18) = 0;
		WFIFOB(sd->fd, 19) = nd->gfx.face;
		WFIFOB(sd->fd, 20) = nd->gfx.hair;
		WFIFOB(sd->fd, 21) = nd->gfx.chair;
		WFIFOB(sd->fd, 22) = nd->gfx.cface;
		WFIFOB(sd->fd, 23) = nd->gfx.cskin;

		//armor
		WFIFOW(sd->fd, 24) = SWAP16(nd->gfx.armor);
		WFIFOB(sd->fd, 26) = nd->gfx.carmor;

		//weap
		WFIFOW(sd->fd, 27) = SWAP16(nd->gfx.weapon);
		WFIFOB(sd->fd, 29) = nd->gfx.cweapon;

		//shield
		WFIFOW(sd->fd, 30) = SWAP16(nd->gfx.shield);
		WFIFOB(sd->fd, 32) = nd->gfx.cshield;

		//helm
		if (nd->gfx.helm == 65535) {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOB(sd->fd, 34) = 0xFF;
			WFIFOB(sd->fd, 35) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 1;
			WFIFOB(sd->fd, 34) = nd->gfx.helm;
			WFIFOB(sd->fd, 35) = nd->gfx.chelm;
		}

		//faceacc
		WFIFOW(sd->fd, 36) = SWAP16(nd->gfx.faceAcc);
		WFIFOB(sd->fd, 38) = nd->gfx.cfaceAcc;

		//crown
		if (nd->gfx.crown == 65535) {
			WFIFOW(sd->fd, 39) = 0xFFFF;
			WFIFOB(sd->fd, 41) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 39) = SWAP16(nd->gfx.crown);
			WFIFOB(sd->fd, 41) = nd->gfx.ccrown;
		}

		//faceacctwo
		WFIFOW(sd->fd, 42) = SWAP16(nd->gfx.faceAccT);;
		WFIFOB(sd->fd, 44) = nd->gfx.cfaceAccT;

		//mantle
		WFIFOW(sd->fd, 45) = SWAP16(nd->gfx.mantle);
		WFIFOB(sd->fd, 47) = nd->gfx.cmantle;

		//necklace
		WFIFOW(sd->fd, 48) = SWAP16(nd->gfx.necklace);
		WFIFOB(sd->fd, 50) = nd->gfx.cnecklace;

		//boots
		WFIFOW(sd->fd, 51) = SWAP16(nd->gfx.boots);
		WFIFOB(sd->fd, 53) = nd->gfx.cboots;

		WFIFOB(sd->fd, 54) = 1;
		WFIFOW(sd->fd, 55) = SWAP16(graphic_id);
		WFIFOB(sd->fd, 57) = color;
		WFIFOL(sd->fd, 58) = SWAP32(1);
		WFIFOB(sd->fd, 62) = previous;
		WFIFOB(sd->fd, 63) = next;
		WFIFOW(sd->fd, 64) = SWAP16(strlen(msg));
		strcpy(WFIFOP(sd->fd, 66), msg);
		WFIFOW(sd->fd, 1) = SWAP16(strlen(msg) + 63);
	}

	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}
int clif_scriptmenu(USER* sd, int id, char* dialog, char* menu[], int size) { // this function does not appear to get called any where at all
	int graphic = sd->npc_g;
	int color = sd->npc_gc;
	int x;
	int len;
	int i;
	NPC* nd = map_id2npc((unsigned int)id);
	int type = sd->dialogtype;

	if (nd) {
		nd->lastaction = time(NULL);
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x2F; //THis is a menu packet
		//WFIFOB(sd->fd,4)=3;
	WFIFOW(sd->fd, 5) = SWAP16(1);
	//WFIFOB(sd->fd,5)=1;
	WFIFOL(sd->fd, 7) = SWAP32(id);

	if (type == 0) {
		if (graphic == 0) {
			WFIFOB(sd->fd, 11) = 0;
		}
		else if (graphic >= 49152) {
			WFIFOB(sd->fd, 11) = 2;
		}
		else {
			WFIFOB(sd->fd, 11) = 1;
		}

		WFIFOB(sd->fd, 12) = 1;
		WFIFOW(sd->fd, 13) = SWAP16(graphic);
		WFIFOB(sd->fd, 15) = color;
		WFIFOB(sd->fd, 16) = 1;
		WFIFOW(sd->fd, 17) = SWAP16(graphic);
		WFIFOB(sd->fd, 19) = color;
		WFIFOW(sd->fd, 20) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 22), dialog);
		WFIFOB(sd->fd, strlen(dialog) + 22) = size;
		len = strlen(dialog);

		for (x = 1; x < size + 1; x++) {
			WFIFOB(sd->fd, len + 23) = strlen(menu[x]);
			strcpy(WFIFOP(sd->fd, len + 24), menu[x]);
			len += strlen(menu[x]) + 1;
			WFIFOW(sd->fd, len + 23) = SWAP16(x);
			len += 2;
		}

		WFIFOW(sd->fd, 1) = SWAP16(len + 20);
	}
	else if (type == 1) {
		WFIFOB(sd->fd, 11) = 1;
		WFIFOW(sd->fd, 12) = SWAP16(nd->sex);
		WFIFOB(sd->fd, 14) = nd->state;
		WFIFOB(sd->fd, 15) = 0;
		WFIFOW(sd->fd, 16) = SWAP16(nd->equip[EQ_ARMOR].id);
		WFIFOB(sd->fd, 18) = 0;
		WFIFOB(sd->fd, 19) = nd->face;
		WFIFOB(sd->fd, 20) = nd->hair;
		WFIFOB(sd->fd, 21) = nd->hair_color;
		WFIFOB(sd->fd, 22) = nd->face_color;
		WFIFOB(sd->fd, 23) = nd->skin_color;

		//armor
		if (!nd->equip[EQ_ARMOR].id) {
			WFIFOW(sd->fd, 24) = 0xFFFF;
			WFIFOB(sd->fd, 26) = 0;
		}
		else {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_ARMOR].id);

			if (nd->armor_color) {
				WFIFOB(sd->fd, 26) = nd->armor_color;
			}
			else {
				WFIFOB(sd->fd, 26) = nd->equip[EQ_ARMOR].customLookColor;
			}
		}

		//coat
		if (nd->equip[EQ_COAT].id) {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_COAT].id);
			WFIFOB(sd->fd, 26) = nd->equip[EQ_COAT].customLookColor;
		}

		//weap
		if (!nd->equip[EQ_WEAP].id) {
			WFIFOW(sd->fd, 27) = 0xFFFF;
			WFIFOB(sd->fd, 29) = 0;
		}
		else {
			WFIFOW(sd->fd, 27) = SWAP16(nd->equip[EQ_WEAP].id);
			WFIFOB(sd->fd, 29) = nd->equip[EQ_WEAP].customLookColor;
		}

		//shield
		if (!nd->equip[EQ_SHIELD].id) {
			WFIFOW(sd->fd, 30) = 0xFFFF;
			WFIFOB(sd->fd, 32) = 0;
		}
		else {
			WFIFOW(sd->fd, 30) = SWAP16(nd->equip[EQ_SHIELD].id);
			WFIFOB(sd->fd, 32) = nd->equip[EQ_SHIELD].customLookColor;
		}

		//helm
		if (!nd->equip[EQ_HELM].id) {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOB(sd->fd, 34) = 0xFF;
			WFIFOB(sd->fd, 35) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 1;
			WFIFOB(sd->fd, 34) = nd->equip[EQ_HELM].id;
			WFIFOB(sd->fd, 35) = nd->equip[EQ_HELM].customLookColor;
		}

		//faceacc
		if (!nd->equip[EQ_FACEACC].id) {
			WFIFOW(sd->fd, 36) = 0xFFFF;
			WFIFOB(sd->fd, 38) = 0;
		}
		else {
			WFIFOW(sd->fd, 36) = SWAP16(nd->equip[EQ_FACEACC].id);
			WFIFOB(sd->fd, 38) = nd->equip[EQ_FACEACC].customLookColor;
		}

		//crown
		if (!nd->equip[EQ_CROWN].id) {
			WFIFOW(sd->fd, 39) = 0xFFFF;
			WFIFOB(sd->fd, 41) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 39) = SWAP16(nd->equip[EQ_CROWN].id);
			WFIFOB(sd->fd, 41) = nd->equip[EQ_CROWN].customLookColor;
		}

		if (!nd->equip[EQ_FACEACCTWO].id) {
			WFIFOW(sd->fd, 42) = 0xFFFF;
			WFIFOB(sd->fd, 44) = 0;
		}
		else {
			WFIFOW(sd->fd, 42) = SWAP16(nd->equip[EQ_FACEACCTWO].id);
			WFIFOB(sd->fd, 44) = nd->equip[EQ_FACEACCTWO].customLookColor;
		}

		//mantle
		if (!nd->equip[EQ_MANTLE].id) {
			WFIFOW(sd->fd, 45) = 0xFFFF;
			WFIFOB(sd->fd, 47) = 0;
		}
		else {
			WFIFOW(sd->fd, 45) = SWAP16(nd->equip[EQ_MANTLE].id);
			WFIFOB(sd->fd, 47) = nd->equip[EQ_MANTLE].customLookColor;
		}

		//necklace
		if (!nd->equip[EQ_NECKLACE].id) {
			WFIFOW(sd->fd, 48) = 0xFFFF;
			WFIFOB(sd->fd, 50) = 0;
		}
		else {
			WFIFOW(sd->fd, 48) = SWAP16(nd->equip[EQ_NECKLACE].id);
			WFIFOB(sd->fd, 50) = nd->equip[EQ_NECKLACE].customLookColor;
		}

		//boots
		if (!nd->equip[EQ_BOOTS].id) {
			WFIFOW(sd->fd, 51) = SWAP16(nd->sex);
			WFIFOB(sd->fd, 53) = 0;
		}
		else {
			WFIFOW(sd->fd, 51) = SWAP16(nd->equip[EQ_BOOTS].id);
			WFIFOB(sd->fd, 53) = nd->equip[EQ_BOOTS].customLookColor;
		}

		WFIFOB(sd->fd, 54) = 1;
		WFIFOW(sd->fd, 55) = SWAP16(graphic);
		WFIFOB(sd->fd, 57) = color;
		WFIFOW(sd->fd, 58) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 60), dialog);
		WFIFOB(sd->fd, strlen(dialog) + 60) = size;
		len = strlen(dialog);

		for (x = 1; x < size + 1; x++) {
			WFIFOB(sd->fd, len + 61) = strlen(menu[x]);
			strcpy(WFIFOP(sd->fd, len + 62), menu[x]);
			len += strlen(menu[x]) + 1;
			WFIFOW(sd->fd, len + 61) = SWAP16(x);
			len += 2;
		}

		WFIFOW(sd->fd, 1) = SWAP16(len + 58);
	}
	else if (type == 2) {
		WFIFOB(sd->fd, 11) = 1;
		WFIFOW(sd->fd, 12) = SWAP16(nd->sex);
		WFIFOB(sd->fd, 14) = nd->state;
		WFIFOB(sd->fd, 15) = 0;
		WFIFOW(sd->fd, 16) = SWAP16(nd->gfx.armor);
		WFIFOB(sd->fd, 18) = 0;
		WFIFOB(sd->fd, 19) = nd->gfx.face;
		WFIFOB(sd->fd, 20) = nd->gfx.hair;
		WFIFOB(sd->fd, 21) = nd->gfx.chair;
		WFIFOB(sd->fd, 22) = nd->gfx.cface;
		WFIFOB(sd->fd, 23) = nd->gfx.cskin;

		//armor
		WFIFOW(sd->fd, 24) = SWAP16(nd->gfx.armor);
		WFIFOB(sd->fd, 26) = nd->gfx.carmor;

		//weap
		WFIFOW(sd->fd, 27) = SWAP16(nd->gfx.weapon);
		WFIFOB(sd->fd, 29) = nd->gfx.cweapon;

		//shield
		WFIFOW(sd->fd, 30) = SWAP16(nd->gfx.shield);
		WFIFOB(sd->fd, 32) = nd->gfx.cshield;

		//helm
		if (nd->gfx.helm == 65535) {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOB(sd->fd, 34) = 0xFF;
			WFIFOB(sd->fd, 35) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 1;
			WFIFOB(sd->fd, 34) = nd->gfx.helm;
			WFIFOB(sd->fd, 35) = nd->gfx.chelm;
		}

		//faceacc
		WFIFOW(sd->fd, 36) = SWAP16(nd->gfx.faceAcc);
		WFIFOB(sd->fd, 38) = nd->gfx.cfaceAcc;

		//crown
		if (nd->gfx.crown == 65535) {
			WFIFOW(sd->fd, 39) = 0xFFFF;
			WFIFOB(sd->fd, 41) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 39) = SWAP16(nd->gfx.crown);
			WFIFOB(sd->fd, 41) = nd->gfx.ccrown;
		}

		//faceacctwo
		WFIFOW(sd->fd, 42) = SWAP16(nd->gfx.faceAccT);
		WFIFOB(sd->fd, 44) = nd->gfx.cfaceAccT;

		//mantle
		WFIFOW(sd->fd, 45) = SWAP16(nd->gfx.mantle);
		WFIFOB(sd->fd, 47) = nd->gfx.cmantle;

		//necklace
		WFIFOW(sd->fd, 48) = SWAP16(nd->gfx.necklace);
		WFIFOB(sd->fd, 50) = nd->gfx.cnecklace;

		//boots
		WFIFOW(sd->fd, 51) = SWAP16(nd->gfx.boots);
		WFIFOB(sd->fd, 53) = nd->gfx.cboots;

		WFIFOB(sd->fd, 54) = 1;
		WFIFOW(sd->fd, 55) = SWAP16(graphic);
		WFIFOB(sd->fd, 57) = color;
		WFIFOW(sd->fd, 58) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 60), dialog);
		WFIFOB(sd->fd, strlen(dialog) + 60) = size;
		len = strlen(dialog);

		for (x = 1; x < size + 1; x++) {
			WFIFOB(sd->fd, len + 61) = strlen(menu[x]);
			strcpy(WFIFOP(sd->fd, len + 62), menu[x]);
			len += strlen(menu[x]) + 1;
			WFIFOW(sd->fd, len + 61) = SWAP16(x);
			len += 2;
		}

		WFIFOW(sd->fd, 1) = SWAP16(len + 58);
	}

	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_scriptmenuseq(USER* sd, int id, char* dialog, char* menu[], int size, int previous, int next) {
	int graphic_id = sd->npc_g;
	int color = sd->npc_gc;
	int x;
	int len = 0;
	NPC* nd = map_id2npc((unsigned int)id);
	int type = sd->dialogtype;

	if (nd) {
		nd->lastaction = time(NULL);
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x30;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0x02;

	WFIFOB(sd->fd, 6) = 0x02;
	//WFIFOW(sd->fd,5)=SWAP16(1);
	WFIFOL(sd->fd, 7) = SWAP32(id);

	if (type == 0) {
		if (graphic_id == 0)
			WFIFOB(sd->fd, 11) = 0;
		else if (graphic_id >= 49152)
			WFIFOB(sd->fd, 11) = 2;
		else
			WFIFOB(sd->fd, 11) = 1;

		WFIFOB(sd->fd, 12) = 1;
		WFIFOW(sd->fd, 13) = SWAP16(graphic_id); // graphic id

		WFIFOB(sd->fd, 15) = color; //graphic color
		WFIFOB(sd->fd, 16) = 1;
		WFIFOW(sd->fd, 17) = SWAP16(graphic_id);
		WFIFOB(sd->fd, 19) = color;
		WFIFOL(sd->fd, 20) = SWAP32(1);
		WFIFOB(sd->fd, 24) = previous; // Previous
		WFIFOB(sd->fd, 25) = next; // Next
		WFIFOW(sd->fd, 26) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 28), dialog);
		len = strlen(dialog) + 1;
		WFIFOB(sd->fd, len + 27) = size;
		len += 1;
		for (x = 1; x < size + 1; x++) {
			WFIFOB(sd->fd, len + 27) = strlen(menu[x]);
			strcpy(WFIFOP(sd->fd, len + 28), menu[x]);
			len += strlen(menu[x]) + 1;
		}
		WFIFOW(sd->fd, 1) = SWAP16(len + 24);
	}
	else if (type == 1) { // showing NPC look
		WFIFOB(sd->fd, 11) = 1;
		WFIFOW(sd->fd, 12) = SWAP16(nd->sex);
		WFIFOB(sd->fd, 14) = nd->state;
		WFIFOB(sd->fd, 15) = 0;
		WFIFOW(sd->fd, 16) = SWAP16(nd->equip[EQ_ARMOR].id);
		WFIFOB(sd->fd, 18) = 0;
		WFIFOB(sd->fd, 19) = nd->face;
		WFIFOB(sd->fd, 20) = nd->hair;
		WFIFOB(sd->fd, 21) = nd->hair_color;
		WFIFOB(sd->fd, 22) = nd->face_color;
		WFIFOB(sd->fd, 23) = nd->skin_color;

		//armor
		if (!nd->equip[EQ_ARMOR].id) {
			WFIFOW(sd->fd, 24) = 0xFFFF;
			WFIFOB(sd->fd, 26) = 0;
		}
		else {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_ARMOR].id);

			if (nd->armor_color) {
				WFIFOB(sd->fd, 26) = nd->armor_color;
			}
			else {
				WFIFOB(sd->fd, 26) = nd->equip[EQ_ARMOR].customLookColor;
			}
		}

		//coat
		if (nd->equip[EQ_COAT].id) {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_COAT].id);
			WFIFOB(sd->fd, 26) = nd->equip[EQ_COAT].customLookColor;
		}

		//weap
		if (!nd->equip[EQ_WEAP].id) {
			WFIFOW(sd->fd, 27) = 0xFFFF;
			WFIFOB(sd->fd, 29) = 0;
		}
		else {
			WFIFOW(sd->fd, 27) = SWAP16(nd->equip[EQ_WEAP].id);
			WFIFOB(sd->fd, 29) = nd->equip[EQ_WEAP].customLookColor;
		}

		//shield
		if (!nd->equip[EQ_SHIELD].id) {
			WFIFOW(sd->fd, 30) = 0xFFFF;
			WFIFOB(sd->fd, 32) = 0;
		}
		else {
			WFIFOW(sd->fd, 30) = SWAP16(nd->equip[EQ_SHIELD].id);
			WFIFOB(sd->fd, 32) = nd->equip[EQ_SHIELD].customLookColor;
		}

		//helm
		if (!nd->equip[EQ_HELM].id) {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOB(sd->fd, 34) = 0xFF;
			WFIFOB(sd->fd, 35) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 1;
			WFIFOB(sd->fd, 34) = nd->equip[EQ_HELM].id;
			WFIFOB(sd->fd, 35) = nd->equip[EQ_HELM].customLookColor;
		}

		//faceacc
		if (!nd->equip[EQ_FACEACC].id) {
			WFIFOW(sd->fd, 36) = 0xFFFF;
			WFIFOB(sd->fd, 38) = 0;
		}
		else {
			WFIFOW(sd->fd, 36) = SWAP16(nd->equip[EQ_FACEACC].id);
			WFIFOB(sd->fd, 38) = nd->equip[EQ_FACEACC].customLookColor;
		}

		//crown
		if (!nd->equip[EQ_CROWN].id) {
			WFIFOW(sd->fd, 39) = 0xFFFF;
			WFIFOB(sd->fd, 41) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 39) = SWAP16(nd->equip[EQ_CROWN].id);
			WFIFOB(sd->fd, 41) = nd->equip[EQ_CROWN].customLookColor;
		}

		if (!nd->equip[EQ_FACEACCTWO].id) {
			WFIFOW(sd->fd, 42) = 0xFFFF;
			WFIFOB(sd->fd, 44) = 0;
		}
		else {
			WFIFOW(sd->fd, 42) = SWAP16(nd->equip[EQ_FACEACCTWO].id);
			WFIFOB(sd->fd, 44) = nd->equip[EQ_FACEACCTWO].customLookColor;
		}

		//mantle
		if (!nd->equip[EQ_MANTLE].id) {
			WFIFOW(sd->fd, 45) = 0xFFFF;
			WFIFOB(sd->fd, 47) = 0;
		}
		else {
			WFIFOW(sd->fd, 45) = SWAP16(nd->equip[EQ_MANTLE].id);
			WFIFOB(sd->fd, 47) = nd->equip[EQ_MANTLE].customLookColor;
		}

		//necklace
		if (!nd->equip[EQ_NECKLACE].id) {
			WFIFOW(sd->fd, 48) = 0xFFFF;
			WFIFOB(sd->fd, 50) = 0;
		}
		else {
			WFIFOW(sd->fd, 48) = SWAP16(nd->equip[EQ_NECKLACE].id);
			WFIFOB(sd->fd, 50) = nd->equip[EQ_NECKLACE].customLookColor;
		}

		//boots
		if (!nd->equip[EQ_BOOTS].id) {
			WFIFOW(sd->fd, 51) = SWAP16(nd->sex);
			WFIFOB(sd->fd, 53) = 0;
		}
		else {
			WFIFOW(sd->fd, 51) = SWAP16(nd->equip[EQ_BOOTS].id);
			WFIFOB(sd->fd, 53) = nd->equip[EQ_BOOTS].customLookColor;
		}

		WFIFOB(sd->fd, 55) = 0;
		WFIFOB(sd->fd, 56) = 1;
		WFIFOW(sd->fd, 55) = SWAP16(graphic_id);
		WFIFOB(sd->fd, 59) = color;
		WFIFOL(sd->fd, 60) = SWAP32(1);
		WFIFOB(sd->fd, 64) = previous; // Previous
		WFIFOB(sd->fd, 65) = next; // Next
		WFIFOW(sd->fd, 66) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 68), dialog);
		len = strlen(dialog) + 68;
		WFIFOB(sd->fd, len) = size;
		len += 1;
		for (x = 1; x < size + 1; x++) {
			WFIFOB(sd->fd, len) = strlen(menu[x]);
			strcpy(WFIFOP(sd->fd, len + 1), menu[x]);
			len += strlen(menu[x]) + 1;
		}

		WFIFOW(sd->fd, 1) = SWAP16(len + 68);
	}
	else if (type == 2) { // showing player gfx look
		WFIFOB(sd->fd, 11) = 1;
		WFIFOW(sd->fd, 12) = SWAP16(sd->status.sex);
		WFIFOB(sd->fd, 14) = sd->status.state;
		WFIFOB(sd->fd, 15) = 0;
		WFIFOW(sd->fd, 16) = SWAP16(sd->gfx.armor);
		WFIFOB(sd->fd, 18) = 0;
		WFIFOB(sd->fd, 19) = sd->gfx.face;
		WFIFOB(sd->fd, 20) = sd->gfx.hair;
		WFIFOB(sd->fd, 21) = sd->gfx.chair;
		WFIFOB(sd->fd, 22) = sd->gfx.cface;
		WFIFOB(sd->fd, 23) = sd->gfx.cskin;

		//armor
		WFIFOW(sd->fd, 24) = SWAP16(sd->gfx.armor);
		WFIFOB(sd->fd, 26) = sd->gfx.carmor;

		//weap
		WFIFOW(sd->fd, 27) = SWAP16(sd->gfx.weapon);
		WFIFOB(sd->fd, 29) = sd->gfx.cweapon;

		//shield
		WFIFOW(sd->fd, 30) = SWAP16(sd->gfx.shield);
		WFIFOB(sd->fd, 32) = sd->gfx.cshield;

		//helm
		if (sd->gfx.helm == 65535) {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOB(sd->fd, 34) = 0xFF;
			WFIFOB(sd->fd, 35) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 1;
			WFIFOB(sd->fd, 34) = sd->gfx.helm;
			WFIFOB(sd->fd, 35) = sd->gfx.chelm;
		}

		//faceacc
		WFIFOW(sd->fd, 36) = SWAP16(sd->gfx.faceAcc);
		WFIFOB(sd->fd, 38) = sd->gfx.cfaceAcc;

		//crown
		if (sd->gfx.crown == 65535) {
			WFIFOW(sd->fd, 39) = 0xFFFF;
			WFIFOB(sd->fd, 41) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 39) = SWAP16(sd->gfx.crown);
			WFIFOB(sd->fd, 41) = sd->gfx.ccrown;
		}

		//faceacctwo
		WFIFOW(sd->fd, 42) = SWAP16(sd->gfx.faceAccT);
		WFIFOB(sd->fd, 44) = sd->gfx.cfaceAccT;

		//mantle
		WFIFOW(sd->fd, 45) = SWAP16(sd->gfx.mantle);
		WFIFOB(sd->fd, 47) = sd->gfx.cmantle;

		//necklace
		WFIFOW(sd->fd, 48) = SWAP16(sd->gfx.necklace);
		WFIFOB(sd->fd, 50) = sd->gfx.cnecklace;

		//boots
		WFIFOW(sd->fd, 51) = SWAP16(sd->gfx.boots);
		WFIFOB(sd->fd, 53) = sd->gfx.cboots;

		WFIFOB(sd->fd, 55) = 0;
		WFIFOB(sd->fd, 56) = 1;
		WFIFOW(sd->fd, 55) = SWAP16(graphic_id);
		WFIFOB(sd->fd, 59) = color;
		WFIFOL(sd->fd, 60) = SWAP32(1);
		WFIFOB(sd->fd, 64) = previous; // Previous
		WFIFOB(sd->fd, 65) = next; // Next
		WFIFOW(sd->fd, 66) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 68), dialog);
		len = strlen(dialog) + 68;
		WFIFOB(sd->fd, len) = size;
		len += 1;
		for (x = 1; x < size + 1; x++) {
			WFIFOB(sd->fd, len) = strlen(menu[x]);
			strcpy(WFIFOP(sd->fd, len + 1), menu[x]);
			len += strlen(menu[x]) + 1;
		}

		WFIFOW(sd->fd, 1) = SWAP16(len + 68);
	}

	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_inputseq(USER* sd, int id, char* dialog, char* dialog2, char* dialog3, char* menu[], int size, int previous, int next) {
	int graphic_id = sd->npc_g;
	int color = sd->npc_gc;
	int x;
	int len = 0;

	NPC* nd = map_id2npc((unsigned int)id);
	int type = sd->dialogtype;

	if (nd) {
		nd->lastaction = time(NULL);
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x30;
	WFIFOB(sd->fd, 4) = 0x5C;
	WFIFOL(sd->fd, 7) = SWAP32(id);

	WFIFOB(sd->fd, 5) = 0x04;
	WFIFOB(sd->fd, 6) = 0x04;

	if (graphic_id == 0)
		WFIFOB(sd->fd, 11) = 0;
	else if (graphic_id >= 49152)
		WFIFOB(sd->fd, 11) = 2;
	else
		WFIFOB(sd->fd, 11) = 1;

	WFIFOB(sd->fd, 12) = 1;
	WFIFOW(sd->fd, 13) = SWAP16(graphic_id); // graphic id

	WFIFOB(sd->fd, 15) = color; //graphic color
	WFIFOB(sd->fd, 16) = 1;
	WFIFOW(sd->fd, 17) = SWAP16(graphic_id);
	WFIFOB(sd->fd, 19) = color;
	WFIFOL(sd->fd, 20) = SWAP32(1);
	WFIFOB(sd->fd, 24) = previous; // Previous
	WFIFOB(sd->fd, 25) = next; // Next

	WFIFOW(sd->fd, 26) = SWAP16(strlen(dialog));
	strcpy(WFIFOP(sd->fd, 28), dialog);
	len += strlen(dialog) + 28;

	WFIFOB(sd->fd, len) = strlen(dialog2);
	strcpy(WFIFOP(sd->fd, len + 1), dialog2);
	len += strlen(dialog2) + 1;

	WFIFOB(sd->fd, len) = 42;
	len += 1;
	WFIFOB(sd->fd, len) = strlen(dialog3);
	strcpy(WFIFOP(sd->fd, len + 1), dialog3);
	len += strlen(dialog3) + 3;

	WFIFOW(sd->fd, 1) = SWAP16(len);

	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_parseuseitem(USER* sd) {
	pc_useitem(sd, RFIFOB(sd->fd, 5) - 1);
	return 0;
}

int clif_parseeatitem(USER* sd) {
	if (itemdb_type(sd->status.inventory[RFIFOB(sd->fd, 5) - 1].id) == ITM_EAT) {
		pc_useitem(sd, RFIFOB(sd->fd, 5) - 1);
	}
	else {
		clif_sendminitext(sd, "That item is not edible.");
	}

	return 0;
}

int clif_parsegetitem(USER* sd) {
	if (sd->status.state == 1 || sd->status.state == 3) return 0; //Dead people can't pick up

	if (sd->status.state == 2)
	{
		sd->status.state = 0;
		sl_doscript_blargs("invis_rogue", "uncast", 1, &sd->bl);
		map_foreachinarea(clif_updatestate, sd->bl.m, sd->bl.x, sd->bl.y, AREA, BL_PC, sd);
	}

	clif_sendaction(&sd->bl, 4, 40, 0);

	sd->pickuptype = RFIFOB(sd->fd, 5);

	for (int x = 0; x < MAX_MAGIC_TIMERS; x++) { //Spell stuff
		if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].duration > 0) {
			sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "on_pickup_while_cast", 1, &sd->bl);
		}
	}

	sl_doscript_blargs("onPickUp", NULL, 1, &sd->bl);

	return 0;
}

int clif_unequipit(USER* sd, int spot) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 7);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(4);
	WFIFOB(sd->fd, 3) = 0x38;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = spot;
	WFIFOB(sd->fd, 6) = 0x00;
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}
int clif_parseunequip(USER* sd) {
	int type;
	int x;
	if (!sd) return 0;

	switch (RFIFOB(sd->fd, 5)) {
	case 0x01:
		type = EQ_WEAP;
		break;
	case 0x02:
		type = EQ_ARMOR;
		break;
	case 0x03:
		type = EQ_SHIELD;
		break;
	case 0x04:
		type = EQ_HELM;
		break;
	case 0x06:
		type = EQ_NECKLACE;
		break;
	case 0x07:
		type = EQ_LEFT;
		break;
	case 0x08:
		type = EQ_RIGHT;
		break;
	case 13:
		type = EQ_BOOTS;
		break;
	case 14:
		type = EQ_MANTLE;
		break;
	case 16:
		type = EQ_COAT;
		break;
	case 20:
		type = EQ_SUBLEFT;
		break;
	case 21:
		type = EQ_SUBRIGHT;
		break;
	case 22:
		type = EQ_FACEACC;
		break;
	case 23:
		type = EQ_CROWN;
		break;

	default:
		return 0;
	}

	if (itemdb_unequip(sd->status.equip[type].id) == 1 && !sd->status.gm_level) {
		char text[] = "You are unable to unequip that.";
		clif_sendminitext(sd, text);
		return 0;
	}

	for (x = 0; x < sd->status.maxinv; x++) {
		if (!sd->status.inventory[x].id) {
			pc_unequip(sd, type);
			clif_unequipit(sd, RFIFOB(sd->fd, 5));
			return 0;
		}
	}

	clif_sendminitext(sd, "Your inventory is full.");
	return 0;
}

int clif_parselookat_sub(struct block_list* bl, va_list ap) {
	USER* sd = NULL;
	nullpo_ret(0, bl);
	nullpo_ret(0, sd = va_arg(ap, USER*));

	sl_doscript_blargs("onLook", NULL, 2, &sd->bl, bl);
	return 0;
}

int clif_parselookat_scriptsub(USER* sd, struct block_list* bl) {
	/*MOB* mob = NULL;
	FLOORITEM* fl = NULL;
	USER *tsd = NULL;
	struct npc_data* nd = NULL;
	char buff[255];
	char *nameof = NULL;
	int d,c,b,a;
	nullpo_ret(0, bl);
	nullpo_ret(0, sd);
	float percentage=0.00;

	//unsigned int percentage=0;
	if(bl->type==BL_MOB) {
		mob=(MOB*)bl;
		if(mob->state==MOB_DEAD) return 0;
		percentage=((float)mob->current_vita/(float)mob->maxvita)*100;
		//percentage=mob->current_vita*100/mob->data->vita;
		if(sd->status.gm_level >= 50) {
			//sprintf(buff,"%s (%d%%) \a %u \a %u \a %u \a %s",mob->data->name,(int)percentage,mob->id, mob->data->id, mob->bl.id, mob->data->yname);
			sprintf(buff,"%s (%s) \a ID: %u \a Lvl: %u \a Vita: %u \a AC: %i",mob->data->name,mob->data->yname, mob->data->id, mob->data->level, mob->current_vita, mob->ac);
		} else {
			sprintf(buff,"%s",mob->data->name);
		}
	} else if(bl->type==BL_PC) {
		tsd=(USER*)bl;
		a=b=c=d=session[tsd->fd]->client_addr.sin_addr.s_addr;
		a &=0xff;
		b=(b>>8)&0xff;
		c=(c>>16)&0xff;
		d=(d>>24)&0xff;
		percentage = ((float)tsd->status.hp / (float)tsd->max_hp) * 100;

		if((tsd->optFlags & optFlag_stealth))return 0;

		//if (classdb_name(tsd->status.class, tsd->status.mark)) {
		//	sprintf(buff, "%s", classdb_name(tsd->status.class, tsd->status.mark));
		//}else {
			sprintf(buff, " ");
		//}

		if(sd->status.gm_level >= 50) {
			sprintf(buff,"%s %s \a (%d%%) \a (IP: %u.%u.%u.%u) \a %u", buff,tsd->status.name,(int)percentage,a,b,c,d,tsd->status.id);
		} else {
			sprintf(buff,"%s %s", buff,tsd->status.name);
		}
	} else if(bl->type==BL_ITEM) {
		fl=(FLOORITEM*)bl;
		if(fl) {
			if(strlen(fl->data.real_name)) {
				nameof=fl->data.real_name;
			} else {
				nameof=itemdb_name(fl->data.id);
			}
			if(fl->data.amount>1) {
				if(sd->status.gm_level >= 50) {
					sprintf(buff,"%s (%u) \a %u \a %s",nameof,fl->data.amount,fl->data.id,itemdb_yname(fl->data.id));
				} else if(itemdb_type(fl->data.id) != ITM_TRAPS) {
					sprintf(buff,"%s (%u)",nameof,fl->data.amount);
				} else {
					return 0;
				}
			} else {
				if(sd->status.gm_level >= 50) {
					sprintf(buff,"%s \a %u \a %s",nameof,fl->data.id,itemdb_yname(fl->data.id));
				} else if(itemdb_type(fl->data.id) != ITM_TRAPS) {
					sprintf(buff,"%s",nameof);
				} else {
					return 0;
				}
			}
		}
	} else if(bl->type==BL_NPC) {
		nd=(NPC*)bl;

		if(nd->bl.subtype==0) {
			//if(nd->bl.graphic_id>0) {
			if(sd->status.gm_level >= 50) {
				sprintf(buff,"%s \a %u \a %s",nd->npc_name,nd->id,nd->name);
			} else {
				sprintf(buff,"%s",nd->npc_name);
			}
			//}
		} else {
			return 0;
		}
	}
	if(strlen(buff)>1) {
		clif_sendminitext(sd,buff);
	}*/
	return 0;
}
int clif_parselookat_2(USER* sd) {
	int x, dx;
	int y, dy;

	dx = sd->bl.x;
	dy = sd->bl.y;

	switch (sd->status.side) {
	case 0:
		dy--;
		break;
	case 1:
		dx++;
		break;
	case 2:
		dy++;
		break;
	case 3:
		dx--;
		break;
	}

	map_foreachincell(clif_parselookat_sub, sd->bl.m, dx, dy, BL_PC, sd);
	map_foreachincell(clif_parselookat_sub, sd->bl.m, dx, dy, BL_MOB, sd);
	map_foreachincell(clif_parselookat_sub, sd->bl.m, dx, dy, BL_ITEM, sd);
	map_foreachincell(clif_parselookat_sub, sd->bl.m, dx, dy, BL_NPC, sd);
	return 0;
}
int clif_parselookat(USER* sd) {
	int x = 0, y = 0;

	x = SWAP16(RFIFOW(sd->fd, 5));
	y = SWAP16(RFIFOW(sd->fd, 7));

	map_foreachincell(clif_parselookat_sub, sd->bl.m, x, y, BL_PC, sd);
	map_foreachincell(clif_parselookat_sub, sd->bl.m, x, y, BL_MOB, sd);
	map_foreachincell(clif_parselookat_sub, sd->bl.m, x, y, BL_ITEM, sd);
	map_foreachincell(clif_parselookat_sub, sd->bl.m, x, y, BL_NPC, sd);
	return 0;
}

int clif_parseattack(USER* sd) {
	struct block_list* bl = NULL;
	USER* tsd = NULL;

	int id;
	int attackspeed;
	int x;
	int tick = 0;
	int exist = -1;

	attackspeed = sd->attack_speed;

	if (sd->paralyzed || sd->sleep != 1.0f) return 0;

	id = sd->status.equip[EQ_WEAP].id;

	if (sd->status.state == 1 || sd->status.state == 3) return 0;

	//thrown rangeTarget support
	/*if(itemdb_thrown(sd->status.equip[EQ_WEAP].id)) {// && sd->time < 3) {
		if(sd->rangeTarget > 0) {
			MOB *TheMob = NULL;
			struct block_list *tbl = map_id2bl(sd->rangeTarget);
			nullpo_ret(0,tbl);

			struct map_sessiondata *tsd = map_id2sd(tbl->id);

			if(sd->bl.id == tbl->id || (sd->bl.x == tbl->x && sd->bl.y == tbl->y)) {
				sd->rangeTarget = 0;
				clif_sendminitext(sd,"You cannot shoot at yourself!");
				return 0;
			}
			if(tbl->m != sd->bl.m || (tbl->x > sd->bl.x + 8 || tbl->x < sd->bl.x - 8) || (tbl->y > sd->bl.y + 8 || tbl->y < sd->bl.y - 8)) {
				sd->rangeTarget = 0;
				clif_sendminitext(sd,"Your target has escaped!");
				return 0;
			}
			if(tbl) {
				long health = 0;
				if(tbl->type == BL_PC) {
					health = tsd->status.hp;
				}
				else if(tbl->type == BL_MOB) {
					TheMob = (MOB*)map_id2mob(tbl->id);

					health = TheMob->current_vita;
				}
				if(health > 0 || tbl->type == BL_PC) {
					tick = 1;
					sl_doscript_blargs(itemdb_yname(sd->status.equip[EQ_WEAP].id),"thrown",2,&sd->bl,tbl);
				}
			}
		}
		else {
			tick = 1;
			sl_doscript_simple(itemdb_yname(sd->status.equip[EQ_WEAP].id),"thrown",&sd->bl);
		}
	} else {*/

	if (itemdb_sound(sd->status.equip[EQ_WEAP].id) == 0) {
		clif_sendaction(&sd->bl, 1, attackspeed, 9);
	}
	else {
		clif_sendaction(&sd->bl, 1, attackspeed, itemdb_sound(sd->status.equip[EQ_WEAP].id));
	}

	sl_doscript_blargs("swingDamage", NULL, 1, &sd->bl);

	sl_doscript_blargs("swing", NULL, 1, &sd->bl);
	sl_doscript_blargs("onSwing", NULL, 1, &sd->bl);

	if (itemdb_look(sd->status.equip[EQ_WEAP].id) >= 20000 && itemdb_look(sd->status.equip[EQ_WEAP].id) < 30000) { // bows
		sl_doscript_blargs(itemdb_yname(sd->status.equip[EQ_WEAP].id), "shootArrow", NULL, 1, &sd->bl);
		sl_doscript_blargs("shootArrow", NULL, 1, &sd->bl);
	}

	//}
	//on_swing should activate ON SWING as it's called. use on_hit if you want it to activate that way.
	for (x = 0; x < 14; x++) {
		if (sd->status.equip[x].id > 0) {
			sl_doscript_blargs(itemdb_yname(sd->status.equip[x].id), "on_swing", 1, &sd->bl);
		}
	}

	//swing to cast
	for (x = 0; x < MAX_SPELLS; x++) {
		if (sd->status.skill[x] > 0) {
			sl_doscript_blargs(magicdb_yname(sd->status.skill[x]), "passive_on_swing", 1, &sd->bl);
		}
	}

	//swing cast handling (has duration)
	for (x = 0; x < MAX_MAGIC_TIMERS; x++) {
		if (sd->status.dura_aether[x].id > 0) {
			if (sd->status.dura_aether[x].duration > 0) {
				sl_doscript_simple(magicdb_yname(sd->status.dura_aether[x].id), "on_swing_while_cast", &sd->bl);
			}
		}
	}

	return 0;
}

int clif_parsechangepos(USER* sd) {
	if (!RFIFOB(sd->fd, 5)) {
		pc_changeitem(sd, RFIFOB(sd->fd, 6) - 1, RFIFOB(sd->fd, 7) - 1);
	}
	else {
		clif_sendminitext(sd, "You are busy.");
	}
	return 0;
}

/*int clif_showguide(USER *sd) {
	int g_count=0;
	int x;
	int len=0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd,255);
	WFIFOB(sd->fd,0)=0xAA;
	//WFIFOW(sd->fd,1)=SWAP16(7);
	WFIFOB(sd->fd,3)=0x12;
	WFIFOB(sd->fd,4)=0x03;
	WFIFOB(sd->fd,5)=0;
	WFIFOB(sd->fd,6)=0;
	for(x=0;x<256;x++) {
	//	if(x<15) {
	//	printf("Guide at %d is %d\n",x,sd->status.guide[x]);
	//	}
		if(sd->status.guide[x]>0) {
			//printf("%d\n",len);
			WFIFOB(sd->fd,8+(g_count*2))=sd->status.guide[x];
			WFIFOB(sd->fd,9+(g_count*2))=0;
			g_count++;
		}
	}
	len=g_count*2;
	//len=2;
	WFIFOB(sd->fd,7)=g_count;
	//WFIFOB(sd->fd,8)=1;
	//WFIFOB(sd->fd,9)=0;
	WFIFOW(sd->fd,1)=SWAP16(len+5);
	//WFIFOW(sd->fd,8)=SWAP16(1);
	WFIFOSET(sd->fd,encrypt(sd->fd));

	return 0;
}*/

/*int clif_showguide2(USER *sd) {
	WFIFOB(sd->fd,0)=0xAA;
	WFIFOW(sd->fd,1)=SWAP16(24);
	WFIFOB(sd->fd,3)=0x12;
	WFIFOB(sd->fd,4)=0x03;
	WFIFOW(sd->fd,5)=SWAP16(1);
	WFIFOW(sd->fd,7)=SWAP16(16);
	WFIFOB(sd->fd,9)=1;
	WFIFOL(sd->fd,10)=0;
	WFIFOL(sd->fd,14)=0;
	WFIFOL(sd->fd,18)=0;
	WFIFOL(sd->fd,22)=0;
	WFIFOB(sd->fd,26)=0;

	encrypt(WFIFOP(sd->fd,0));
	WFIFOSET(sd->fd,27);

	sl_doscript_blargs(guidedb_yname(SWAP16(RFIFOW(sd->fd,7))),"run",1,&sd->bl);
}*/
int clif_parsewield(USER* sd) {
	int pos = RFIFOB(sd->fd, 5) - 1;
	int id = sd->status.inventory[pos].id;
	int type = itemdb_type(id);

	if (type >= 3 && type <= 16) {
		pc_useitem(sd, pos);
	}
	else {
		clif_sendminitext(sd, "You cannot wield that!");
	}
	return 0;
}
int clif_addtocurrent(struct block_list* bl, va_list ap) {
	int* def = NULL;
	unsigned int amount;
	USER* sd = NULL;
	FLOORITEM* fl = NULL;

	nullpo_ret(0, fl = (FLOORITEM*)bl);

	def = va_arg(ap, int*);
	amount = va_arg(ap, unsigned int);
	nullpo_ret(0, sd = va_arg(ap, USER*));

	if (def[0]) return 0;

	if (fl->data.id >= 0 && fl->data.id <= 3) {
		fl->data.amount += amount;
		def[0] = 1;
	}
	return 0;
}
int clif_dropgold(USER* sd, unsigned int amounts) {
	char escape[255];
	char RegStr[] = "goldbardupe";
	int DupeTimes = pc_readglobalreg(sd, RegStr);
	if (DupeTimes)
	{
		//char minibuf[]="Character under quarentine.";
		//clif_sendminitext(sd,minibuf);
		return 0;
	}

	if (sd->status.gm_level == 0) {
		//dead can't drop gold
		if (sd->status.state == 1) {
			clif_sendminitext(sd, "Spirits can't do that.");
			return 0;
		}
		if (sd->status.state == 3) {
			clif_sendminitext(sd, "You cannot do that while riding a mount.");
			return 0;
		}

		if (sd->status.state == 4) {
			clif_sendminitext(sd, "You cannot do that while transformed.");
			return 0;
		}
	}

	FLOORITEM* fl;

	unsigned int amount = amounts;
	if (!sd->status.money) return 0;
	if (!amounts) return 0;
	int def[1];
	clif_sendaction(&sd->bl, 5, 20, 0);
	def[0] = 0;
	CALLOC(fl, FLOORITEM, 1);
	fl->bl.m = sd->bl.m;
	fl->bl.x = sd->bl.x;
	fl->bl.y = sd->bl.y;

	if (sd->status.money < amount) {
		amount = sd->status.money;
		sd->status.money = 0;
	}
	else {
		sd->status.money -= amount;
	}

	if (amount == 1)
	{
		fl->data.id = 0;
		fl->data.amount = amount;
	}
	else if (amount >= 2 && amount <= 99)
	{
		fl->data.id = 1;
		fl->data.amount = amount;
	}
	else if (amount >= 100 && amount <= 999)
	{
		fl->data.id = 2;
		fl->data.amount = amount;
	}
	else if (amount >= 1000)
	{
		fl->data.id = 3;
		fl->data.amount = amount;
	}

	sd->fakeDrop = 0; // sets initial

	sl_doscript_blargs("on_drop_gold", NULL, 2, &sd->bl, &fl->bl);

	for (int x = 0; x < MAX_MAGIC_TIMERS; x++) { //Spell stuff
		if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].duration > 0) {
			sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "on_drop_gold_while_cast", 2, &sd->bl, &fl->bl);
		}
	}

	for (int x = 0; x < MAX_MAGIC_TIMERS; x++) { //Spell stuff
		if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].aether > 0) {
			sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "on_drop_gold_while_aether", 2, &sd->bl, &fl->bl);
		}
	}

	if (sd->fakeDrop) return 0;

	char mini[64];
	sprintf(mini, "You dropped %d coins\0", fl->data.amount);
	clif_sendminitext(sd, mini);

	map_foreachincell(clif_addtocurrent, sd->bl.m, sd->bl.x, sd->bl.y, BL_ITEM, def, amount);

	Sql_EscapeString(sql_handle, escape, fl->data.real_name);

	/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `DropLogs` (`DrpChaId`, `DrpMapId`, `DrpX`, `DrpY`, `DrpItmId`, `DrpAmount`) VALUES ('%u', '%u', '%u', '%u', '%u', '%u')",
			sd->status.id, sd->bl.m, sd->bl.x, sd->bl.y, fl->data.id, fl->data.amount)) {
		SqlStmt_ShowDebug(sql_handle);
	}*/

	if (!def[0]) {
		map_additem(&fl->bl);

		sl_doscript_blargs("after_drop_gold", NULL, 2, &sd->bl, &fl->bl);

		for (int x = 0; x < MAX_MAGIC_TIMERS; x++) { //Spell stuff
			if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].duration > 0) {
				sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "after_drop_gold_while_cast", 2, &sd->bl, &fl->bl);
			}
		}

		for (int x = 0; x < MAX_MAGIC_TIMERS; x++) { //Spell stuff
			if (sd->status.dura_aether[x].id > 0 && sd->status.dura_aether[x].aether > 0) {
				sl_doscript_blargs(magicdb_yname(sd->status.dura_aether[x].id), "after_drop_gold_while_aether", 2, &sd->bl, &fl->bl);
			}
		}

		sl_doscript_blargs("characterLog", "dropWrite", 2, &sd->bl, &fl->bl);
		map_foreachinarea(clif_object_look_sub2, sd->bl.m, sd->bl.x, sd->bl.y, AREA, BL_PC, LOOK_SEND, &fl->bl);
	}
	else {
		FREE(fl);
	}

	clif_sendstatus(sd, SFLAG_XPMONEY);

	return 0;
}

int clif_open_sub(USER* sd) {
	nullpo_ret(0, sd);

	sl_doscript_blargs("onOpen", NULL, 1, &sd->bl);
	return 0;
}

int clif_parsechangespell(USER* sd) {
	int start_pos = RFIFOB(sd->fd, 6) - 1;
	int stop_pos = RFIFOB(sd->fd, 7) - 1;
	int start_id = 0;
	int stop_id = 0;

	start_id = sd->status.skill[start_pos];
	stop_id = sd->status.skill[stop_pos];

	clif_removespell(sd, start_pos);
	clif_removespell(sd, stop_pos);
	sd->status.skill[start_pos] = stop_id;
	sd->status.skill[stop_pos] = start_id;
	pc_loadmagic(sd);
	pc_reload_aether(sd);
	return 0;
}

int clif_removespell(USER* sd, int pos) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 6);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(3);
	WFIFOB(sd->fd, 3) = 0x18;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = pos + 1;
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}
int clif_throwitem_sub(USER* sd, int id, int type, int x, int y) {
	FLOORITEM* fl = NULL;

	if (!sd->status.inventory[id].id)
		return 0;

	if (sd->status.inventory[id].amount <= 0) { clif_senddelitem(sd, id, 4); return 0; }

	CALLOC(fl, FLOORITEM, 1);
	fl->bl.m = sd->bl.m;
	fl->bl.x = x;
	fl->bl.y = y;
	//printf("%d\n",type);
	memcpy(&fl->data, &sd->status.inventory[id], sizeof(struct item));
	sd->invslot = id;
	sd->throwx = x;
	sd->throwy = y;
	sl_doscript_blargs("onThrow", NULL, 2, &sd->bl, &fl->bl);
	return 0;
}

int clif_throwitem_script(USER* sd) {
	FLOORITEM* fl = NULL;
	char escape[255];
	char sndbuf[48];
	int len = 0;
	int def[1];
	int id = sd->invslot;
	int x = sd->throwx;
	int y = sd->throwy;
	int type = 0;

	CALLOC(fl, FLOORITEM, 1);
	fl->bl.m = sd->bl.m;
	fl->bl.x = x;
	fl->bl.y = y;
	memcpy(&fl->data, &sd->status.inventory[id], sizeof(struct item));
	def[0] = 0;
	//item check goes here(to see if there are previous items added

	if (fl->data.dura == itemdb_dura(fl->data.id)) {
		map_foreachincell(pc_addtocurrent, sd->bl.m, x, y, BL_ITEM, def, id, type, sd);
	}

	sd->status.inventory[id].amount--;

	/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `ThrowLogs` (`ThwChaId`, `ThwMapId`, `ThwX`, `ThwY`, `ThwItmId`, `ThwMapIdDestination`, `ThwXDestination`, `ThwYDestination`) VALUES ('%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u')",
			sd->status.id, sd->bl.m, sd->bl.x, sd->bl.y, fl->data.id, fl->bl.m, x, y)) {
		SqlStmt_ShowDebug(sql_handle);
	}*/

	if (type || !sd->status.inventory[id].amount) {
		memset(&sd->status.inventory[id], 0, sizeof(struct item));
		clif_senddelitem(sd, id, 4);
	}
	else {
		fl->data.amount = 1;
		clif_sendadditem(sd, id);
	}

	if (sd->bl.x != x) {
		WBUFB(sndbuf, 0) = 0xAA;
		WBUFW(sndbuf, 1) = SWAP16(0x1B);
		WBUFB(sndbuf, 3) = 0x16;
		WBUFB(sndbuf, 4) = 0x03;
		WBUFL(sndbuf, 5) = SWAP32(sd->bl.id);

		if (fl->data.customIcon != 0) {
			WBUFW(sndbuf, 9) = SWAP16(fl->data.customIcon + 49152);
			WBUFB(sndbuf, 11) = fl->data.customIconColor;
		}
		else {
			WBUFW(sndbuf, 9) = SWAP16(itemdb_icon(fl->data.id));
			WBUFB(sndbuf, 11) = itemdb_iconcolor(fl->data.id);
		}

		if (def[0]) {
			WBUFL(sndbuf, 12) = (unsigned int)def[0];
		}
		else {
			WBUFL(sndbuf, 12) = (unsigned int)fl->bl.id;
		}
		WBUFW(sndbuf, 16) = SWAP16(sd->bl.x);
		WBUFW(sndbuf, 18) = SWAP16(sd->bl.y);
		WBUFW(sndbuf, 20) = SWAP16(x);
		WBUFW(sndbuf, 22) = SWAP16(y);
		WBUFL(sndbuf, 24) = 0;
		WBUFB(sndbuf, 28) = 0x02;
		WBUFB(sndbuf, 29) = 0x00;
		//crypt(WBUFP(sndbuf,0));
		clif_send(sndbuf, 48, &sd->bl, SAMEAREA);
	}
	else {
		clif_sendaction(&sd->bl, 2, 30, 0);
	}
	//WFIFOSET(sd->fd,30);

	if (!def[0]) {
		map_additem(&fl->bl);
		map_foreachinarea(clif_object_look_sub2, sd->bl.m, sd->bl.x, sd->bl.y, AREA, BL_PC, LOOK_SEND, &fl->bl);
	}
	else {
		FREE(fl);
	}

	return 0;
}
int clif_throw_check(struct block_list* bl, va_list ap) {
	MOB* mob = NULL;
	USER* sd = NULL;

	int* found = NULL;
	found = va_arg(ap, int*);
	if (found[0]) return 0;
	if (bl->type == BL_NPC) {
		if (bl->subtype != SCRIPT) return 0;
	}
	if (bl->type == BL_MOB) {
		mob = (MOB*)bl;
		if (mob->state == MOB_DEAD) return 0;
	}
	if (bl->type == BL_PC) {
		sd = (USER*)bl;
		if (sd->status.state == 1 || (sd->optFlags & optFlag_stealth)) return 0;
	}

	found[0] += 1;
	return 0;
}

int clif_throwconfirm(USER* sd) {
	WFIFOHEAD(sd->fd, 7);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(7);
	WFIFOB(sd->fd, 3) = 0x4E;
	WFIFOB(sd->fd, 5) = RFIFOB(sd->fd, 6);
	WFIFOB(sd->fd, 6) = 0;
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_parsethrow(USER* sd) {
	struct warp_list* x = NULL;

	char RegStr[] = "goldbardupe";
	int DupeTimes = pc_readglobalreg(sd, RegStr);
	if (DupeTimes)
	{
		//char minibuf[]="Character under quarentine.";
		//clif_sendminitext(sd,minibuf);
		return 0;
	}

	if (sd->status.gm_level == 0) {
		//dead can't throw
		if (sd->status.state == 1) {
			clif_sendminitext(sd, "Spirits can't do that.");
			return 0;
		}
		//mounted can't throw
		if (sd->status.state == 3) {
			clif_sendminitext(sd, "You cannot do that while riding a mount.");
			return 0;
		}
		if (sd->status.state == 4) {
			clif_sendminitext(sd, "You cannot do that while transformed.");
			return 0;
		}
	}

	int pos = RFIFOB(sd->fd, 6) - 1;
	if (itemdb_droppable(sd->status.inventory[pos].id)) {
		clif_sendminitext(sd, "You can't throw this item.");
		return 0;
	}

	int max = 8;
	int newx = sd->bl.x;
	int newy = sd->bl.y;
	int xmod = 0, x1;
	int ymod = 0, y1;
	int xside = 0, yside = 0;
	int found[1];
	int i;
	found[0] = 0;
	switch (sd->status.side) {
	case 0: //up
		ymod = -1;

		break;
	case 1: //left
		xmod = 1;
		break;
	case 2: //down
		ymod = 1;
		break;
	case 3: //right
		xmod = -1;
		break;
	}
	for (i = 0; i < max; i++) {
		x1 = sd->bl.x + (i * xmod) + xmod;
		y1 = sd->bl.y + (i * ymod) + ymod;
		if (x1 < 0) x1 = 0;
		if (y1 < 0) y1 = 0;
		if (x1 >= map[sd->bl.m].xs) x1 = map[sd->bl.m].xs - 1;
		if (y1 >= map[sd->bl.m].ys) y1 = map[sd->bl.m].ys - 1;

		map_foreachincell(clif_throw_check, sd->bl.m, x1, y1, BL_NPC, found);
		map_foreachincell(clif_throw_check, sd->bl.m, x1, y1, BL_PC, found);
		map_foreachincell(clif_throw_check, sd->bl.m, x1, y1, BL_MOB, found);
		found[0] += read_pass(sd->bl.m, x1, y1);
		found[0] += clif_object_canmove(sd->bl.m, x1, y1, sd->status.side);
		found[0] += clif_object_canmove_from(sd->bl.m, x1, y1, sd->status.side);
		for (x = map[sd->bl.m].warp[x1 / BLOCK_SIZE + (y1 / BLOCK_SIZE) * map[sd->bl.m].bxs]; x && !found[0]; x = x->next) {
			if (x->x == x1 && x->y == y1) {
				found[0] += 1;
			}
		}
		if (found[0]) {
			break;
		}
		newx = x1;
		newy = y1;
	}
	clif_throwitem_sub(sd, pos, 0, newx, newy);
}

int clif_parseviewchange(USER* sd) {
	int dx = 0, dy = 0;
	int x0, y0, x1, y1, direction = 0;
	unsigned short checksum;

	direction = RFIFOB(sd->fd, 5);
	dx = RFIFOB(sd->fd, 6);
	dy = RFIFOB(sd->fd, 7);
	x0 = SWAP16(RFIFOW(sd->fd, 8));
	y0 = SWAP16(RFIFOW(sd->fd, 10));
	x1 = RFIFOB(sd->fd, 12);
	y1 = RFIFOB(sd->fd, 13);
	checksum = SWAP16(RFIFOW(sd->fd, 14));

	if (sd->status.state == 3) {
		clif_sendminitext(sd, "You cannot do that while riding a mount.");
		return 0;
	}

	switch (direction) {
	case 0:
		dy++;
		break;
	case 1:
		dx--;
		break;
	case 2:
		dy--;
		break;
	case 3:
		dx++;
		break;
	default:
		break;
	}

	clif_sendxychange(sd, dx, dy);
	clif_mob_look_start(sd);
	map_foreachinblock(clif_object_look_sub, sd->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_ALL, LOOK_GET, sd);
	clif_mob_look_close(sd);
	map_foreachinblock(clif_charlook_sub, sd->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_GET, sd);
	map_foreachinblock(clif_cnpclook_sub, sd->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_NPC, LOOK_GET, sd);
	map_foreachinblock(clif_cmoblook_sub, sd->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_MOB, LOOK_GET, sd);
	map_foreachinblock(clif_charlook_sub, sd->bl.m, x0, y0, x0 + (x1 - 1), y0 + (y1 - 1), BL_PC, LOOK_SEND, sd);

	return 0;
}

int clif_parsefriends(USER* sd, char* friendList, int len) {
	int i = 0;
	int j = 0;
	char friends[20][16];
	char escape[16];
	int friendCount = 0;
	SqlStmt* stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	memset(friends, 0, sizeof(char) * 20 * 16);

	do
	{
		j = 0;

		if (friendList[i] == 0x0C)
		{
			do
			{
				i = i + 1;
				friends[friendCount][j] = friendList[i];
				j = j + 1;
			} while (friendList[i] != 0x00);

			friendCount = friendCount + 1;
		}

		i = i + 1;
	} while (i < len);

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT * FROM `Friends` WHERE `FndChaId` = %d", sd->status.id)
		|| SQL_ERROR == SqlStmt_Execute(stmt))
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	if (SqlStmt_NumRows(stmt) == 0)
	{
		if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `Friends` (`FndChaId`) VALUES (%d)", sd->status.id))
			Sql_ShowDebug(sql_handle);
	}

	for (i = 0; i < 20; i++)
	{
		Sql_EscapeString(sql_handle, escape, friends[i]);

		if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Friends` SET `FndChaName%d` = '%s' WHERE `FndChaId` = '%u'", i + 1, escape, sd->status.id))
			Sql_ShowDebug(sql_handle);
	}

	SqlStmt_Free(stmt);
	return 0;
}

int clif_changeprofile(USER* sd) {
	sd->profilepic_size = SWAP16(RFIFOW(sd->fd, 5)) + 2;
	sd->profile_size = RFIFOB(sd->fd, 5 + sd->profilepic_size) + 1;

	memcpy(sd->profilepic_data, RFIFOP(sd->fd, 5), sd->profilepic_size);
	memcpy(sd->profile_data, RFIFOP(sd->fd, 5 + sd->profilepic_size), sd->profile_size);
}

//this is for preventing hackers from fucking up the server

int check_packet_size(int fd, int len) {
	//USER *sd=session[fd]->session_data;

	if (session[fd]->rdata_size > len) {//there is more here, so check for congruity
		if (RFIFOB(fd, len) != 0xAA) {
			RFIFOREST(fd);
			session[fd]->eof = 1;
			return 1;
		}
	}

	return 0;
}
int canusepowerboards(USER* sd) {
	if (sd->status.gm_level) return 1;

	if (!pc_readglobalreg(sd, "carnagehost")) return 0;

	if (sd->bl.m >= 2001 && sd->bl.m <= 2099)
		return 1;

	return 0;
}
int clif_stoptimers(USER* sd) {
	for (int x = 0; x < MAX_MAGIC_TIMERS; x++) {
		if (sd->status.dura_aether[x].dura_timer) { timer_remove(sd->status.dura_aether[x].dura_timer); }
		if (sd->status.dura_aether[x].aether_timer) { timer_remove(sd->status.dura_aether[x].aether_timer); }
	}
}
int clif_handle_disconnect(USER* sd) {
	USER* tsd = NULL;
	struct block_list* bl = NULL;
	if (sd->exchange.target) {
		tsd = map_id2sd(sd->exchange.target);
		clif_exchange_close(sd);

		if (tsd && tsd->exchange.target == sd->bl.id) {
			clif_exchange_message(tsd, "Exchange cancelled.", 4, 0);
			clif_exchange_close(tsd);
		}
	}
	//printf("033[1;37m%s\033[0m disconnecting.\n",sd->status.name);

	pc_stoptimer(sd);
	sl_async_freeco(sd);

	clif_leavegroup(sd);
	clif_stoptimers(sd);

	sl_doscript_blargs("logout", NULL, 1, &sd->bl);
	intif_savequit(sd);
	clif_quit(sd);
	map_deliddb(&sd->bl);

	if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Character` SET `ChaOnline` = '0' WHERE `ChaId` = '%u'", sd->status.id))
		Sql_ShowDebug(sql_handle);

	printf(CL_MAGENTA"%s"CL_NORMAL" disconnecting\n", sd->status.name);
	return 0;
}
int clif_handle_missingobject(USER* sd) {
	struct block_list* bl = NULL;
	bl = map_id2bl(SWAP32(RFIFOL(sd->fd, 5)));

	if (bl) {
		if (bl->type == BL_PC) {
			clif_charspecific(sd->status.id, SWAP32(RFIFOL(sd->fd, 5)));
			clif_charspecific(SWAP32(RFIFOL(sd->fd, 5)), sd->status.id);
		}
		else {
			//mob=(MOB*)bl;
			clif_object_look_specific(sd, SWAP32(RFIFOL(sd->fd, 5)));
			//clif_mob_look3(sd,mob);
		}
	}
	return 0;
}
int clif_handle_menuinput(USER* sd) {
	int npcinf;
	npcinf = RFIFOB(sd->fd, 5);

	if (!hasCoref(sd))
		return 0;

	switch (npcinf) {
	case 0: //menu
		sl_async_freeco(sd);
		break;
	case 1: //input
		clif_parsemenu(sd);
		break;
	case 2: //buy
		clif_parsebuy(sd);
		break;
	case 3: //input
		clif_parseinput(sd);
		break;
	case 4: //sell
		clif_parsesell(sd);
		break;
	default:
		sl_async_freeco(sd);
		break;
	}

	return 0;
}
int clif_handle_clickgetinfo(USER* sd) {
	struct block_list* bl = NULL;
	struct npc_data* nd = NULL;
	USER* tsd = NULL;
	MOB* mob = NULL;

	//clif_debug(RFIFOP(sd->fd, 0), SWAP16(RFIFOW(sd->fd, 1)));

	if (RFIFOL(sd->fd, 6) == 0)
		bl = map_id2bl(sd->last_click);
	else {
		if (SWAP32(RFIFOL(sd->fd, 6)) == 0xFFFFFFFE) { // subpath chat
			if (!sd->status.subpath_chat) {
				sd->status.subpath_chat = 1;
				clif_sendminitext(sd, "Subpath Chat: ON");
			}
			else {
				sd->status.subpath_chat = 0;
				clif_sendminitext(sd, "Subpath Chat: OFF");
			}

			return 0;
		}

		bl = map_id2bl(SWAP32(RFIFOL(sd->fd, 6)));
	}

	if (bl) {
		struct point one = { sd->bl.m,sd->bl.x,sd->bl.y };
		struct point two = { bl->m,bl->x,bl->y };
		int Radius = 10;

		switch (bl->type) {
		case BL_PC:

			tsd = map_id2sd(bl->id);
			struct point cone = { sd->bl.m,sd->bl.x,sd->bl.y };
			struct point ctwo = { tsd->bl.m,tsd->bl.x,tsd->bl.y };

			if (CheckProximity(cone, ctwo, 21) == 1)
				if (sd->status.gm_level || (!(tsd->optFlags & optFlag_noclick) && !(tsd->optFlags & optFlag_stealth))) sl_doscript_blargs("onClick", NULL, 1, &sd->bl);

			clif_clickonplayer(sd, bl);
			break;

		case BL_NPC:

			nd = (NPC*)bl;

			if (bl->subtype == FLOOR)Radius = 0;

			if (nd->bl.m == 0 || CheckProximity(one, two, Radius) == 1) {  //F1NPC
				sd->last_click = bl->id;
				sl_async_freeco(sd);
				//sd->dialogtype = 0;

				if (sd->status.karma <= -3.0f && strcmp(nd->name, "F1Npc") != 0 && strcmp(nd->name, "TotemNpc") != 0) {
					clif_scriptmes(sd, nd->bl.id, "Go away scum!", 0, 0);
					return 0;
				}

				/*if (sd->status.state == 1 && strcmpi(nd->name,"F1Npc") != 0 && strcmpi(nd->name,"ShamanNpc") != 0 && strcmpi(nd->name,"ArenaShopNpc") != 0) {
					clif_scriptmes(sd, nd->bl.id, "Go away scum!", 0, 0);
					return 0;
				}*/

				sl_doscript_blargs(nd->name, "click", 2, &sd->bl, &nd->bl);
			}
			break;

		case BL_MOB:
			mob = (MOB*)bl;

			if (mob->data->type == 3) Radius = 0;

			if (CheckProximity(one, two, Radius) == 1) {
				sd->last_click = bl->id;
				sl_async_freeco(sd);
				sl_doscript_blargs("onLook", NULL, 2, &sd->bl, &mob->bl);
				sl_doscript_blargs(mob->data->yname, "click", 2, &sd->bl, &mob->bl);
				//sl_doscript_blargs("onClick", NULL, 2, &sd->bl, &mob->bl);
			}

			break;
		}
	}
	return 0;
}
int clif_handle_powerboards(USER* sd) {
	USER* tsd = NULL;

	//if(canusepowerboards(sd))
	   //	{
	tsd = map_id2sd(SWAP32(RFIFOL(sd->fd, 11)));
	if (tsd)
		sd->pbColor = RFIFOB(sd->fd, 15);
	else
		sd->pbColor = 0;

	if (tsd != NULL)
		sl_doscript_blargs("powerBoard", NULL, 2, &sd->bl, &tsd->bl);
	else
		sl_doscript_blargs("powerBoard", NULL, 2, &sd->bl, 0);

	//	  tsd=map_id2sd(SWAP32(RFIFOL(sd->fd,11)));
	//	  if(tsd) {
	//		int armColor=RFIFOB(sd->fd,15);
	/*		if(sd->status.gm_level) {
			tsd->status.armor_color=armColor;
			} else {
				if(armColor==0) tsd->status.armor_color=armColor;
				if(armColor==60) tsd->status.armor_color=armColor;
				if(armColor==61) tsd->status.armor_color=armColor;
				if(armColor==63) tsd->status.armor_color=armColor;
				if(armColor==65) tsd->status.armor_color=armColor;
			}
			map_foreachinarea(clif_updatestate,tsd->bl.m,tsd->bl.x,tsd->bl.y,AREA,BL_PC,tsd);
		  }
		  clif_sendpowerboard(sd);
		}
		else
		clif_Hacker(sd->status.name,"Accessing dye boards");
*/
	return 0;
}

clif_sendminimap(USER* sd) {
	if (!sd) return 0;

	WFIFOHEAD(sd->fd, 0);

	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x06;
	WFIFOB(sd->fd, 3) = 0x70;
	WFIFOB(sd->fd, 4) = SWAP16(sd->bl.m);// 0x1D
	WFIFOB(sd->fd, 5) = 0x00;

	WFIFOSET(sd->fd, encrypt(sd->fd));

	//official packet[] = { 0xAA, 0x00, 0x06, 0x70, 0x1E, 0x00};
	//WFIFOSET(sd->fd, encrypt(fd));

	return 0;
}

int clif_handle_boards(USER* sd) {
	int postcolor;
	switch (RFIFOB(sd->fd, 5)) {
	case 1: //Show Board
		sd->bcount = 0;
		sd->board_popup = 0;
		clif_showboards(sd);
		break;
	case 2: //Show posts from board #
		if (RFIFOB(sd->fd, 8) == 127) sd->bcount = 0;

		boards_showposts(sd, SWAP16(RFIFOW(sd->fd, 6)));

		break;
	case 3: //Read post/nmail
		boards_readpost(sd, SWAP16(RFIFOW(sd->fd, 6)), SWAP16(RFIFOW(sd->fd, 8)));
		break;
	case 4: //Make post
		boards_post(sd, SWAP16(RFIFOW(sd->fd, 6)));
		break;
	case 5: //delete post!
		boards_delete(sd, SWAP16(RFIFOW(sd->fd, 6)));
		break;
	case 6: //Send nmail
		if (sd->status.level >= 10) nmail_write(sd);
		else clif_sendminitext(sd, "You must be at least level 10 to view/send nmail.");
		break;
	case 7: //Change
		if (sd->status.gm_level) {
			postcolor = map_getpostcolor(SWAP16(RFIFOW(sd->fd, 6)), SWAP16(RFIFOW(sd->fd, 8)));
			postcolor ^= 1;
			map_changepostcolor(SWAP16(RFIFOW(sd->fd, 6)), SWAP16(RFIFOW(sd->fd, 8)), postcolor);
			nmail_sendmessage(sd, "Post updated.", 6, 0);
		}
		break;
	case 8: // SPECIAL WRITE
		sl_doscript_blargs(boarddb_yname(SWAP16(RFIFOW(sd->fd, 6))), "write", 1, &sd->bl);

	case 9: //Nmail

		sd->bcount = 0;
		boards_showposts(sd, 0);

		break;
	}
	return 0;
}

int clif_print_disconnect(int fd) {
	if (session[fd]->eof == 4) //Ignore this.
		return 0;

	printf(CL_NORMAL"(Reason: "CL_GREEN);
	switch (session[fd]->eof) {
	case 0x00:
	case 0x01:
		printf("NORMAL_EOF");
		break;
	case 0x02:
		printf("SOCKET_SEND_ERROR");
		break;
	case 0x03:
		printf("SOCKET_RECV_ERROR");
		break;
	case 0x04:
		printf("ZERO_RECV_ERROR(NORMAL)");
		break;
	case 0x05:
		printf("MISSING_WDATA");
		break;
	case 0x06:
		printf("WDATA_REALLOC");
		break;
	case 0x07:
		printf("NO_MMO_DATA");
		break;
	case 0x08:
		printf("SESSIONDATA_EXISTS");
		break;
	case 0x09:
		printf("PLAYER_CONNECTING");
		break;
	case 0x0A:
		printf("INVALID_EXCHANGE");
		break;
	case 0x0B:
		printf("ACCEPT_NAMELEN_ERROR");
		break;
	case 0x0C:
		printf("PLAYER_TIMEOUT");
		break;
	case 0x0D:
		printf("INVALID_PACKET_HEADER");
		break;
	case 0x0E:
		printf("WPE_HACK");
		break;
	default:
		printf("UNKNOWN");
		break;
	}
	printf(CL_NORMAL")\n");
	return 0;
}
int clif_parse(int fd) {
	unsigned short len;
	USER* sd = NULL;
	int time;
	int pnum;
	int lasteof;
	unsigned char CurrentSeed;

	if (fd<0 || fd>fd_max) return 0;
	if (!session[fd]) return 0;

	sd = (USER*)session[fd]->session_data;

	//for(pnum=0;pnum<3 && session[fd] && session[fd]->rdata_size;pnum++) {
	if (session[fd]->eof) {
		if (sd) {
			printf("Char: %s\n", sd->status.name);
			clif_handle_disconnect(sd);
			clif_closeit(sd);
			//sd->fd=0;
		}
		//printf("Reason for disconnect: %d\n",session[fd]->eof);
		clif_print_disconnect(fd);
		session_eof(fd);
		return 0;
	}

	//if(!session[fd]->rdata_size) return 0;
	if (session[fd]->rdata_size > 0 && RFIFOB(fd, 0) != 0xAA) {
		int head_err = 0;
		session[fd]->eof = 13;
		return 0;
	}

	if (RFIFOREST(fd) < 3)
		return 0;

	len = SWAP16(RFIFOW(fd, 1)) + 3;

	//if(check_packet_size(fd,len)) return 0; //Hacker prevention?
	//ok the biggest packet we might POSSIBLY get wont be bigger than 10k, so set a limit
	if (RFIFOREST(fd) < len)
		return 0;

	//printf("parsing %d\n",fd);
	if (!sd) {
		switch (RFIFOB(fd, 3)) {
		case 0x10:
			//clif_debug(RFIFOP(sd->fd,4),SWAP16(RFIFOW(sd->fd,1)))
			clif_accept2(fd, RFIFOP(fd, 16), RFIFOB(fd, 15));

			break;

		default:
			//session[fd]->eof=1;
			break;
		}

		RFIFOSKIP(fd, len);
		return 0;
	}

	nullpo_ret(0, sd);
	CurrentSeed = RFIFOB(fd, 4);

	/*if ((sd->PrevSeed == 0 && sd->NextSeed == 0 && CurrentSeed == 0)
	|| ((sd->PrevSeed || sd->NextSeed) && CurrentSeed != sd->NextSeed)) {
		char RegStr[] = "WPEtimes";
		char AlertStr[32] = "";
		int WPEtimes = 0;

		sprintf(AlertStr, "Packet editing of 0x%02X detected", RFIFOB(fd, 3));
		clif_Hacker(sd->status.name, AlertStr);
		WPEtimes = pc_readglobalreg(sd, RegStr) + 1;
		pc_setglobalreg(sd, RegStr, WPEtimes);
		session[sd->fd]->eof = 14;
		return 0;
	}*/

	sd->PrevSeed = CurrentSeed;
	sd->NextSeed = CurrentSeed + 1;

	int logincount = 0;
	USER* tsd = NULL;
	for (int i = 0; i < fd_max; i++) {
		if (session[i] && (tsd = session[i]->session_data)) {
			if (sd->status.id == tsd->status.id) logincount++;

			if (logincount >= 2) {
				printf("%s attempted dual login on IP:%s\n", sd->status.name, sd->status.ipaddress);
				session[sd->fd]->eof = 1;
				session[tsd->fd]->eof = 1;
				break;
			}
		}
	}

	//Incoming Packet Decryption
	decrypt(fd);

	//printf("packet id: %i\n",RFIFOB(fd,3));

	/*printf("Packet:\n");
for (int i = 0; i < SWAP16(RFIFOW(fd, 1)); i++) {
printf("%02X ",RFIFOB(fd,i));
}
printf("\n");*/

	switch (RFIFOB(fd, 3)) {
	case 0x05:
		//clif_cancelafk(sd); -- conflict with light function, causes character to never enter AFK status
		clif_parsemap(sd);
		break;
	case 0x06:
		clif_cancelafk(sd);
		clif_parsewalk(sd);
		break;
	case 0x07:
		clif_cancelafk(sd);
		sd->time += 1;
		if (sd->time < 4) {
			clif_parsegetitem(sd);
		}
		break;
	case 0x08:
		clif_cancelafk(sd);
		clif_parsedropitem(sd);
		break;
	case 0x09:
		clif_cancelafk(sd);
		clif_parselookat_2(sd);

		break;
	case 0x0A:
		clif_cancelafk(sd);

		clif_parselookat(sd);
		break;
	case 0x0B:
		clif_cancelafk(sd);
		clif_closeit(sd);
		break;
	case 0x0C: // < missing object/char/monster
		clif_handle_missingobject(sd);
		break;
	case 0x0D:
		clif_parseignore(sd);
		break;
	case 0x0E:
		clif_cancelafk(sd);
		if (sd->status.gm_level) {
			clif_parsesay(sd);
		}
		else {
			sd->chat_timer += 1;
			if (sd->chat_timer < 2 && !sd->status.mute) {
				clif_parsesay(sd);
			}
		}
		break;

	case 0x0F: //magic
		clif_cancelafk(sd);
		sd->time += 1;

		if (!sd->paralyzed && sd->sleep == 1.0f) {
			if (sd->time < 4) {
				if (map[sd->bl.m].spell || sd->status.gm_level) {
					clif_parsemagic(sd);
				}
				else {
					clif_sendminitext(sd, "That doesn't work here.");
				}
			}
		}
		break;
	case 0x11:
		clif_cancelafk(sd);
		clif_parseside(sd);
		break;
	case 0x12:
		clif_cancelafk(sd);
		clif_parsewield(sd);
		break;
	case 0x13:
		clif_cancelafk(sd);
		sd->time++;

		if (sd->attacked != 1 && sd->attack_speed > 0) {
			sd->attacked = 1;
			timer_insert(((sd->attack_speed * 1000) / 60), ((sd->attack_speed * 1000) / 60), pc_atkspeed, sd->status.id, 0);
			clif_parseattack(sd);
		}
		else {
			//clif_parseattack(sd);
		}
		break;
	case 0x17:
		clif_cancelafk(sd);

		int pos = RFIFOB(sd->fd, 6);
		int confirm = RFIFOB(sd->fd, 5);

		if (itemdb_thrownconfirm(sd->status.inventory[pos - 1].id) == 1)
		{
			if (confirm == 1) clif_parsethrow(sd);
			else  clif_throwconfirm(sd);
		}
		else clif_parsethrow(sd);

		/*printf("throw packet\n");
		for (int i = 0; i< SWAP16(RFIFOW(sd->fd,1));i++) {
			printf("%02X ",RFIFOB(sd->fd,i));
		}
		printf("\n");*/

		break;
	case 0x18:
		clif_cancelafk(sd);
		//clif_sendtowns(sd);
		clif_user_list(sd);
		break;
	case 0x19:
		clif_cancelafk(sd);
		clif_parsewisp(sd);
		break;
	case 0x1A:
		clif_cancelafk(sd);
		clif_parseeatitem(sd);

		break;
	case 0x1B:
		if (sd->loaded) clif_changestatus(sd, RFIFOB(sd->fd, 6));

		break;
	case 0x1C:
		clif_cancelafk(sd);
		clif_parseuseitem(sd);

		break;
	case 0x1D:
		clif_cancelafk(sd);
		sd->time++;
		if (sd->time < 4) {
			clif_parseemotion(sd);
		}
		break;
	case 0x1E:
		clif_cancelafk(sd);
		sd->time++;
		if (sd->time < 4)	clif_parsewield(sd);
		break;
	case 0x1F:
		clif_cancelafk(sd);
		if (sd->time < 4) clif_parseunequip(sd);
		break;
	case 0x20: //Clicked 'O'
		clif_cancelafk(sd);
		clif_open_sub(sd);
		//map_foreachincell(clif_open_sub,sd->bl.m,sd->bl.x,sd->bl.y,BL_NPC,sd);
		break;
	case 0x23:
		//paperpopupwritable SAVE
		clif_paperpopupwrite_save(sd);
		break;
	case 0x24:
		clif_cancelafk(sd);
		clif_dropgold(sd, SWAP32(RFIFOL(sd->fd, 5)));
		break;
	case 0x27: // PACKET SENT WHEN SOMEONE CLICKS QUEST tab or SHIFT Z key
		clif_cancelafk(sd);

		//clif_sendurl(sd,0,"https://www.RetroTK.com/questguide/");

		/*if(SWAP16(RFIFOW(sd->fd,5))==0) {
			clif_showguide(sd);
		} else {
			clif_showguide2(sd);
		}*/

		break;
	case 0x29:
		clif_cancelafk(sd);
		clif_handitem(sd);
		//	clif_parse_exchange(sd);
		break;
	case 0x2A:
		clif_cancelafk(sd);
		clif_handgold(sd);
		break;
	case 0x2D:
		clif_cancelafk(sd);

		if (RFIFOB(sd->fd, 5) == 0) {
			clif_mystaytus(sd);
		}
		else {
			//clif_startexchange(sd,sd->bl.id);
			clif_groupstatus(sd);
		}

		break;
	case 0x2E:
		clif_cancelafk(sd);

		clif_addgroup(sd);
		break;
	case 0x30:
		clif_cancelafk(sd);

		if (RFIFOB(sd->fd, 5) == 1) {
			clif_parsechangespell(sd);
		}
		else {
			clif_parsechangepos(sd);
		}
		break;
	case 0x32:
		clif_cancelafk(sd);

		clif_parsewalk(sd);

		break;
	case 0x34:
		clif_cancelafk(sd);

		clif_postitem(sd);

		/*case 0x36: -- clan bank packet
			clif_cancelafk(sd);
			clif_parseClanBankWithdraw(sd);*/

	case 0x38:
		clif_cancelafk(sd);

		clif_refresh(sd);
		break;

	case 0x39: //menu & input
		clif_cancelafk(sd);

		clif_handle_menuinput(sd);

		break;
	case 0x3A:
		clif_cancelafk(sd);

		clif_parsenpcdialog(sd);

		//if(hasCoref(sd)) clif_parsenpcdialog(sd);

		break;

	case 0x3B:
		clif_cancelafk(sd);

		clif_handle_boards(sd);

		break;
	case 0x3F: //Map change packet
		pc_warp(sd, SWAP16(RFIFOW(sd->fd, 5)), SWAP16(RFIFOW(sd->fd, 7)), SWAP16(RFIFOW(sd->fd, 9)));
		break;
	case 0x41:
		clif_cancelafk(sd);
		clif_parseparcel(sd);
		break;
	case 0x42: //Client crash debug.
		break;
	case 0x43:
		clif_cancelafk(sd);
		clif_handle_clickgetinfo(sd);
		break;
		//Packet 45 responds from 3B
	case 0x4A:
		clif_cancelafk(sd);
		clif_parse_exchange(sd);
		break;
	case 0x4C:
		clif_cancelafk(sd);
		clif_handle_powerboards(sd);
		break;
	case 0x4F: //Profile change
		clif_cancelafk(sd);
		clif_changeprofile(sd);
		break;
	case 0x60: //PING
		break;
	case 0x66:
		clif_cancelafk(sd);
		clif_sendtowns(sd);
		break;
	case 0x69: //Obstruction(something blocking movement)
		//clif_debug(RFIFOP(sd->fd,5),SWAP16(RFIFOW(sd->fd,1))-2);
		//if(sd->status.gm_level>0) {
		//	clif_handle_obstruction(sd);
		//}
		break;
	case 0x6B: //creation system
		clif_cancelafk(sd);
		createdb_start(sd);
		break;
	case 0x73: //web board
		clif_cancelafk(sd);
		//BOARD AA 00 0B 73 08 00 00 74 32 B1 42
		//LOOK  AA 00 0B 73 07 04 00 E7 9E 13 16

		if (RFIFOB(sd->fd, 5) == 0x04) { //Userlook
			clif_sendprofile(sd);
		}
		if (RFIFOB(sd->fd, 5) == 0x00) { //Board
			clif_sendboard(sd);
		}

		//clif_debug(RFIFOP(sd->fd, 0), SWAP16(RFIFOW(sd->fd, 1)));

		break;
	case 0x75:
		clif_parsewalkpong(sd);
		break;

	case 0x7B: //Request Item Information!
		printf("request: %u\n", RFIFOB(sd->fd, 5));
		switch (RFIFOB(sd->fd, 5)) {
		case 0: //Request the file asking for
			send_meta(sd);
			break;
		case 1: //Requqest the list to use
			send_metalist(sd);

			break;
		}
		break;

	case 0x7C:  // map
		clif_cancelafk(sd);
		clif_sendminimap(sd);
		break;

	case 0x7D: // Ranking SYSTEM
		clif_cancelafk(sd);
		switch (RFIFOB(fd, 5)) { // Packet fd 5 is the mode choice. 5 = send reward, 6 = get reward, everything else is to show the ranking list
		case 5: { clif_sendRewardInfo(sd, fd); break; }
		case 6: { clif_getReward(sd, fd); break; }
		default: { clif_parseranking(sd, fd); break;  }
		}
		break;

	case 0x77:
		clif_cancelafk(sd);
		clif_parsefriends(sd, RFIFOP(sd->fd, 5), SWAP16(RFIFOW(sd->fd, 1)) - 5);
		break;
	case 0x82:
		clif_cancelafk(sd);
		clif_parseviewchange(sd);
		break;
	case 0x83: //screenshots...
		break;

	case 0x84: // add to hunter list (new client function)
		clif_cancelafk(sd);
		clif_huntertoggle(sd);

		break;

	case 0x85: // modified for 736  -- this packet is called when you double click on a hunter on the userlist
		clif_sendhunternote(sd);

		clif_cancelafk(sd);
		break;

	default:
		printf("[Map] Unknown Packet ID: %02X\nPacket content:\n", RFIFOB(sd->fd, 3));
		clif_debug(RFIFOP(sd->fd, 0), SWAP16(RFIFOW(sd->fd, 1)));
		//if (dump_save)
		//	add_dmp(fd, len);
		break;
	}

	RFIFOSKIP(fd, len);
	//}
	return 0;
}

unsigned int metacrc(char* file) {
	FILE* fp = NULL;

	unsigned int checksum = 0;
	unsigned int size;
	unsigned int size2;
	char fileinf[196608];
	fp = fopen(file, "rb");
	if (!fp) return 0;
	fseek(fp, 0, SEEK_END);
	size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	fread(fileinf, 1, size, fp);
	fclose(fp);
	checksum = crc32(checksum, fileinf, size);

	return checksum;
}

int send_metafile(USER* sd, char* file) {
	int len = 0;
	unsigned int checksum = 0;
	unsigned int clen = 0;
	Bytef* ubuf;
	Bytef* cbuf;
	unsigned int ulen = 0;
	char filebuf[255];
	unsigned int retval;
	FILE* fp = NULL;

	sprintf(filebuf, "meta/%s", file);

	checksum = metacrc(filebuf);

	fp = fopen(filebuf, "rb");
	if (!fp) return 0;

	fseek(fp, 0, SEEK_END);
	ulen = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	//CALLOC(ubuf,0,ulen);
	ubuf = (char*)calloc(ulen + 1, sizeof(char));
	clen = compressBound(ulen);
	cbuf = (char*)calloc(clen + 1, sizeof(char));
	fread(ubuf, 1, ulen, fp);
	fclose(fp);

	retval = compress(cbuf, &clen, ubuf, ulen);

	if (retval != 0) printf("Fucked up %d\n", retval);
	WFIFOHEAD(sd->fd, 65535 * 2);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x6F;
	//WFIFOB(sd->fd,4)=0x08;
	WFIFOB(sd->fd, 5) = 0; //this is sending file data
	WFIFOB(sd->fd, 6) = strlen(file);
	strcpy(WFIFOP(sd->fd, 7), file);
	len += strlen(file) + 1;
	WFIFOL(sd->fd, len + 6) = SWAP32(checksum);
	len += 4;
	WFIFOW(sd->fd, len + 6) = SWAP16(clen);
	len += 2;
	memcpy(WFIFOP(sd->fd, len + 6), cbuf, clen);
	len += clen;
	WFIFOB(sd->fd, len + 6) = 0;
	len += 1;
	//printf("%s\n",file);
	WFIFOW(sd->fd, 1) = SWAP16(len + 3);
	set_packet_indexes(WFIFOP(sd->fd, 0));
	crypt(WFIFOP(sd->fd, 0));
	WFIFOSET(sd->fd, len + 6 + 3);

	free(cbuf);
	free(ubuf);
	return 0;
}
int send_meta(USER* sd) {
	char temp[255];

	memset(temp, 0, 255);
	memcpy(temp, RFIFOP(sd->fd, 7), RFIFOB(sd->fd, 6));

	send_metafile(sd->fd, temp);

	return 0;
}
int send_metalist(USER* sd) {
	int len = 0;
	unsigned int checksum;
	char filebuf[255];
	int count = 0;
	int x;

	WFIFOHEAD(sd->fd, 65535 * 2);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x6F;
	//WFIFOB(sd->fd,4)=0x00;
	WFIFOB(sd->fd, 5) = 1;
	WFIFOW(sd->fd, 6) = SWAP16(metamax);
	len += 2;
	for (x = 0; x < metamax; x++) {
		WFIFOB(sd->fd, (len + 6)) = strlen(meta_file[x]);
		memcpy(WFIFOP(sd->fd, len + 7), meta_file[x], strlen(meta_file[x]));
		len += strlen(meta_file[x]) + 1;
		sprintf(filebuf, "meta/%s", meta_file[x]);
		checksum = metacrc(filebuf);
		WFIFOL(sd->fd, len + 6) = SWAP32(checksum);
		len += 4;
	}

	WFIFOW(sd->fd, 1) = SWAP16(len + 4);
	set_packet_indexes(WFIFOP(sd->fd, 0));
	crypt(WFIFOP(sd->fd, 0));
	WFIFOSET(sd->fd, len + 7 + 3);

	return 0;
}

int clif_handle_obstruction(USER* sd) {
	int xold = 0, yold = 0, nx = 0, ny = 0;
	sd->canmove = 0;
	xold = SWAP16(RFIFOW(sd->fd, 5));
	yold = SWAP16(RFIFOW(sd->fd, 7));
	nx = xold;
	ny = yold;

	switch (RFIFOB(sd->fd, 9)) {
	case 0: //up
		ny = yold - 1;
		break;
	case 1: //right
		nx = xold + 1;
		break;
	case 2: //down
		ny = yold + 1;
		break;
	case 3: //left
		nx = xold - 1;
		break;
	}

	sd->bl.x = nx;
	sd->bl.y = ny;

	//if(clif_canmove(sd)) {
//		sd->bl.x=xold;
	//	sd->bl.y=yold;

	//}

	clif_sendxy(sd);
	return 0;
}
int clif_sendtest(USER* sd) {
	static int number;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 7);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 2) = 0x04;
	WFIFOB(sd->fd, 3) = 0x63;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = number;
	WFIFOB(sd->fd, 6) = 0;
	WFIFOSET(sd->fd, encrypt(sd->fd));
	number++;

	return 0;
}
int clif_parsemenu(USER* sd) {
	int selection;
	unsigned int id;
	id = SWAP32(RFIFOL(sd->fd, 6));
	selection = SWAP16(RFIFOW(sd->fd, 10));
	sl_resumemenu(selection, sd);
	return 0;
}
int clif_updatestate(struct block_list* bl, va_list ap) {
	char buf[64];
	USER* sd = NULL;
	USER* src_sd = NULL;
	int len = 0;

	nullpo_ret(0, sd = va_arg(ap, USER*));
	nullpo_ret(0, src_sd = (USER*)bl);

	//if( (sd->optFlags & optFlag_stealth && !src_sd->status.gm_level) && src_sd->status.id != sd->status.id)return 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(src_sd->fd, 512);
	WFIFOB(src_sd->fd, 0) = 0xAA;
	WFIFOB(src_sd->fd, 3) = 0x1D;
	//WFIFOB(src_sd->fd,4)=0x03;
	WFIFOL(src_sd->fd, 5) = SWAP32(sd->bl.id);

	if (sd->status.state == 4)
	{
		WFIFOB(src_sd->fd, 9) = 1;
		WFIFOB(src_sd->fd, 10) = 15;
		WFIFOB(src_sd->fd, 11) = sd->status.state;
		WFIFOW(src_sd->fd, 12) = SWAP16(sd->disguise + 32768);
		WFIFOB(src_sd->fd, 14) = sd->disguise_color;

		sprintf(buf, "%s", sd->status.name);

		WFIFOB(src_sd->fd, 16) = strlen(buf);
		len += strlen(sd->status.name) + 1;
		strcpy(WFIFOP(src_sd->fd, 17), buf);

		WFIFOW(src_sd->fd, 1) = SWAP16(len + 13);
		WFIFOSET(src_sd->fd, encrypt(src_sd->fd));
	}
	else {
		WFIFOW(src_sd->fd, 9) = SWAP16(sd->status.sex);

		if ((sd->status.state == 2 || (sd->optFlags & optFlag_stealth)) && sd->bl.id != src_sd->bl.id && (src_sd->status.gm_level || clif_isingroup(src_sd, sd) || (sd->gfx.dye == src_sd->gfx.dye && sd->gfx.dye != 0 && src_sd->gfx.dye != 0))) {
			WFIFOB(src_sd->fd, 11) = 5; //Gm's need to see invis
		}
		else {
			WFIFOB(src_sd->fd, 11) = sd->status.state;
		}

		if ((sd->optFlags & optFlag_stealth) && !sd->status.state && !src_sd->status.gm_level) WFIFOB(src_sd->fd, 11) = 2;

		if (sd->status.state == 3) {
			WFIFOW(src_sd->fd, 12) = SWAP16(sd->disguise);
		}
		else {
			WFIFOW(src_sd->fd, 12) = SWAP16(0);
		}

		WFIFOB(src_sd->fd, 14) = sd->speed;

		WFIFOB(src_sd->fd, 15) = 0;
		WFIFOB(src_sd->fd, 16) = sd->status.face; //face
		WFIFOB(src_sd->fd, 17) = sd->status.hair; //hair
		WFIFOB(src_sd->fd, 18) = sd->status.hair_color; //hair color
		WFIFOB(src_sd->fd, 19) = sd->status.face_color;
		WFIFOB(src_sd->fd, 20) = sd->status.skin_color;
		//WFIFOB(src_sd->fd,21)=0;

	//armor
		if (!pc_isequip(sd, EQ_ARMOR)) {
			WFIFOW(src_sd->fd, 21) = SWAP16(sd->status.sex);
		}
		else {
			if (sd->status.equip[EQ_ARMOR].customLook != 0) {
				WFIFOW(src_sd->fd, 21) = SWAP16(sd->status.equip[EQ_ARMOR].customLook);
			}
			else {
				WFIFOW(src_sd->fd, 21) = SWAP16(itemdb_look(pc_isequip(sd, EQ_ARMOR)));//-10000+16;
			}

			if (sd->status.armor_color > 0) {
				WFIFOB(src_sd->fd, 23) = sd->status.armor_color;
			}
			else {
				if (sd->status.equip[EQ_ARMOR].customLook != 0) {
					WFIFOB(src_sd->fd, 23) = sd->status.equip[EQ_ARMOR].customLookColor;
				}
				else {
					WFIFOB(src_sd->fd, 23) = itemdb_lookcolor(pc_isequip(sd, EQ_ARMOR));
				}
			}
		}

		//coat
		if (pc_isequip(sd, EQ_COAT)) {
			WFIFOW(src_sd->fd, 21) = SWAP16(itemdb_look(pc_isequip(sd, EQ_COAT)));//-10000+16;

			if (sd->status.armor_color > 0) {
				WFIFOB(src_sd->fd, 23) = sd->status.armor_color;
			}
			else {
				WFIFOB(src_sd->fd, 23) = itemdb_lookcolor(pc_isequip(sd, EQ_COAT));
			}
		}

		//weapon
		if (!pc_isequip(sd, EQ_WEAP)) {
			WFIFOW(src_sd->fd, 24) = 0xFFFF;
			WFIFOB(src_sd->fd, 26) = 0x0;
		}
		else {
			if (sd->status.equip[EQ_WEAP].customLook != 0) { // edited on 07-16-2017 to support custom WEapon Skins
				WFIFOW(src_sd->fd, 24) = SWAP16(sd->status.equip[EQ_WEAP].customLook);
				WFIFOB(src_sd->fd, 26) = sd->status.equip[EQ_WEAP].customLookColor;
			}
			else {
				WFIFOW(src_sd->fd, 24) = SWAP16(itemdb_look(pc_isequip(sd, EQ_WEAP)));
				WFIFOB(src_sd->fd, 26) = itemdb_lookcolor(pc_isequip(sd, EQ_WEAP));
			}
		}

		//shield
		if (!pc_isequip(sd, EQ_SHIELD)) {
			WFIFOW(src_sd->fd, 27) = 0xFFFF;
			WFIFOB(src_sd->fd, 29) = 0;
		}
		else {
			if (sd->status.equip[EQ_SHIELD].customLook != 0) {
				WFIFOW(src_sd->fd, 27) = SWAP16(sd->status.equip[EQ_SHIELD].customLook);
				WFIFOB(src_sd->fd, 29) = sd->status.equip[EQ_SHIELD].customLookColor;
			}
			else {
				WFIFOW(src_sd->fd, 27) = SWAP16(itemdb_look(pc_isequip(sd, EQ_SHIELD)));
				WFIFOB(src_sd->fd, 29) = itemdb_lookcolor(pc_isequip(sd, EQ_SHIELD));
			}
		}

		if (!pc_isequip(sd, EQ_HELM) || !(sd->status.settingFlags & FLAG_HELM) || (itemdb_look(pc_isequip(sd, EQ_HELM)) == -1)) {
			//helm stuff goes here
			WFIFOB(src_sd->fd, 30) = 0; // supposed to be 1=Helm, 0=No helm
			WFIFOW(src_sd->fd, 31) = 0xFFFF; // supposed to be Helm num
		}
		else {
			WFIFOB(src_sd->fd, 30) = 1;

			if (sd->status.equip[EQ_HELM].customLook != 0) {
				WFIFOB(src_sd->fd, 31) = sd->status.equip[EQ_HELM].customLook;
				WFIFOB(src_sd->fd, 32) = sd->status.equip[EQ_HELM].customLookColor;
			}
			else {
				WFIFOB(src_sd->fd, 31) = itemdb_look(pc_isequip(sd, EQ_HELM));
				WFIFOB(src_sd->fd, 32) = itemdb_lookcolor(pc_isequip(sd, EQ_HELM));
			}
		}
		//faceacc
		if (!pc_isequip(sd, EQ_FACEACC)) {
			//beard stuff
			WFIFOW(src_sd->fd, 33) = 0xFFFF;
			WFIFOB(src_sd->fd, 35) = 0x0;
		}
		else {
			WFIFOW(src_sd->fd, 33) = SWAP16(itemdb_look(pc_isequip(sd, EQ_FACEACC))); //beard num
			WFIFOB(src_sd->fd, 35) = itemdb_lookcolor(pc_isequip(sd, EQ_FACEACC)); //beard color
		}
		//crown
		if (!pc_isequip(sd, EQ_CROWN)) {
			WFIFOW(src_sd->fd, 36) = 0xFFFF;
			WFIFOB(src_sd->fd, 38) = 0x0;
		}
		else {
			WFIFOB(src_sd->fd, 30) = 0;
			if (sd->status.equip[EQ_CROWN].customLook != 0) {
				WFIFOW(src_sd->fd, 36) = SWAP16(sd->status.equip[EQ_CROWN].customLook); //Crown
				WFIFOB(src_sd->fd, 38) = sd->status.equip[EQ_CROWN].customLookColor; //Crown color
			}
			else {
				WFIFOW(src_sd->fd, 36) = SWAP16(itemdb_look(pc_isequip(sd, EQ_CROWN))); //Crown
				WFIFOB(src_sd->fd, 38) = itemdb_lookcolor(pc_isequip(sd, EQ_CROWN)); //Crown color
			}
		}

		if (!pc_isequip(sd, EQ_FACEACCTWO)) {
			WFIFOW(src_sd->fd, 39) = 0xFFFF; //second face acc
			WFIFOB(src_sd->fd, 41) = 0x0; //" color
		}
		else {
			WFIFOW(src_sd->fd, 39) = SWAP16(itemdb_look(pc_isequip(sd, EQ_FACEACCTWO)));
			WFIFOB(src_sd->fd, 41) = itemdb_lookcolor(pc_isequip(sd, EQ_FACEACCTWO));
		}

		//mantle
		if (!pc_isequip(sd, EQ_MANTLE)) {
			WFIFOW(src_sd->fd, 42) = 0xFFFF;
			WFIFOB(src_sd->fd, 44) = 0xFF;
		}
		else {
			WFIFOW(src_sd->fd, 42) = SWAP16(itemdb_look(pc_isequip(sd, EQ_MANTLE)));
			WFIFOB(src_sd->fd, 44) = itemdb_lookcolor(pc_isequip(sd, EQ_MANTLE));
		}

		//necklace
		if (!pc_isequip(sd, EQ_NECKLACE) || !(sd->status.settingFlags & FLAG_NECKLACE) || (itemdb_look(pc_isequip(sd, EQ_NECKLACE)) == -1)) { // Necklace Toggle bug fix. 07-07-17
			WFIFOW(src_sd->fd, 45) = 0xFFFF;
			WFIFOB(src_sd->fd, 47) = 0x0;
		}
		else {
			WFIFOW(src_sd->fd, 45) = SWAP16(itemdb_look(pc_isequip(sd, EQ_NECKLACE))); //necklace
			WFIFOB(src_sd->fd, 47) = itemdb_lookcolor(pc_isequip(sd, EQ_NECKLACE)); //neckalce color
		}
		//boots
		if (!pc_isequip(sd, EQ_BOOTS)) {
			WFIFOW(src_sd->fd, 48) = SWAP16(sd->status.sex); //boots
			WFIFOB(src_sd->fd, 50) = 0x0;
		}
		else {
			if (sd->status.equip[EQ_BOOTS].customLook != 0) {
				WFIFOW(src_sd->fd, 48) = SWAP16(sd->status.equip[EQ_BOOTS].customLook);
				WFIFOB(src_sd->fd, 50) = sd->status.equip[EQ_BOOTS].customLookColor;
			}
			else {
				WFIFOW(src_sd->fd, 48) = SWAP16(itemdb_look(pc_isequip(sd, EQ_BOOTS)));
				WFIFOB(src_sd->fd, 50) = itemdb_lookcolor(pc_isequip(sd, EQ_BOOTS));
			}
		}

		// 51 color
		// 52 outline color   128 = black
		// 53 normal color when 51 & 52 set to 0

		WFIFOB(src_sd->fd, 51) = 0;
		WFIFOB(src_sd->fd, 52) = 128;
		WFIFOB(src_sd->fd, 53) = 0;

		if (sd->gfx.dye != 0 && src_sd->gfx.dye != 0 && src_sd->gfx.dye != sd->gfx.dye && sd->status.state == 2) {
			WFIFOB(src_sd->fd, 51) = 0;
		}
		else {
			if (sd->gfx.dye) WFIFOB(src_sd->fd, 51) = sd->gfx.titleColor;
			else WFIFOB(src_sd->fd, 51) = 0;

			/*switch(sd->gfx.dye) {
				case 60:
					WFIFOB(src_sd->fd,51)=8;
					break;
				case 61:
					WFIFOB(src_sd->fd,51)=15;
					break;
				case 63:
					WFIFOB(src_sd->fd,51)=4;
					break;
				case 66:
					WFIFOB(src_sd->fd,51)=1;
					break;

				default:
					WFIFOB(src_sd->fd,51)=0;
					break;
				}*/
		}

		sprintf(buf, "%s", sd->status.name);

		len = strlen(buf);

		if (src_sd->status.clan == sd->status.clan) {
			if (src_sd->status.clan > 0) {
				if (src_sd->status.id != sd->status.id) {
					WFIFOB(src_sd->fd, 53) = 3;
				}
			}
		}

		if (clif_isingroup(src_sd, sd)) {
			if (sd->status.id != src_sd->status.id) {
				WFIFOB(src_sd->fd, 53) = 2;
			}
		}

		if ((sd->status.state != 5) && (sd->status.state != 2)) {
			WFIFOB(src_sd->fd, 54) = len;
			strcpy(WFIFOP(src_sd->fd, 55), buf);
		}
		else {
			WFIFOB(src_sd->fd, 54) = 0;
			len = 0;
		}

		if ((sd->status.gm_level && sd->gfx.toggle) || sd->clone) {
			WFIFOB(src_sd->fd, 16) = sd->gfx.face;
			WFIFOB(src_sd->fd, 17) = sd->gfx.hair;
			WFIFOB(src_sd->fd, 18) = sd->gfx.chair;
			WFIFOB(src_sd->fd, 19) = sd->gfx.cface;
			WFIFOB(src_sd->fd, 20) = sd->gfx.cskin;
			WFIFOW(src_sd->fd, 21) = SWAP16(sd->gfx.armor);
			if (sd->gfx.dye > 0) {
				WFIFOB(src_sd->fd, 23) = sd->gfx.dye;
			}
			else {
				WFIFOB(src_sd->fd, 23) = sd->gfx.carmor;
			}
			WFIFOW(src_sd->fd, 24) = SWAP16(sd->gfx.weapon);
			WFIFOB(src_sd->fd, 26) = sd->gfx.cweapon;
			WFIFOW(src_sd->fd, 27) = SWAP16(sd->gfx.shield);
			WFIFOB(src_sd->fd, 29) = sd->gfx.cshield;

			if (sd->gfx.helm < 255) {
				WFIFOB(src_sd->fd, 30) = 1;
			}
			else if (sd->gfx.crown < 65535) {
				WFIFOB(src_sd->fd, 30) = 0xFF;
			}
			else {
				WFIFOB(src_sd->fd, 30) = 0;
			}

			WFIFOB(src_sd->fd, 31) = sd->gfx.helm;
			WFIFOB(src_sd->fd, 32) = sd->gfx.chelm;

			WFIFOW(src_sd->fd, 33) = SWAP16(sd->gfx.faceAcc);
			WFIFOB(src_sd->fd, 35) = sd->gfx.cfaceAcc;
			WFIFOW(src_sd->fd, 36) = SWAP16(sd->gfx.crown);
			WFIFOB(src_sd->fd, 38) = sd->gfx.ccrown;
			WFIFOW(src_sd->fd, 39) = SWAP16(sd->gfx.faceAccT);
			WFIFOB(src_sd->fd, 41) = sd->gfx.cfaceAccT;
			WFIFOW(src_sd->fd, 42) = SWAP16(sd->gfx.mantle);
			WFIFOB(src_sd->fd, 44) = sd->gfx.cmantle;
			WFIFOW(src_sd->fd, 45) = SWAP16(sd->gfx.necklace);
			WFIFOB(src_sd->fd, 47) = sd->gfx.cnecklace;
			WFIFOW(src_sd->fd, 48) = SWAP16(sd->gfx.boots);
			WFIFOB(src_sd->fd, 50) = sd->gfx.cboots;

			len = strlen(sd->gfx.name);
			if ((sd->status.state != 2) && (sd->status.state != 5) && strcmpi(sd->gfx.name, "")) {
				WFIFOB(src_sd->fd, 52) = len;
				strcpy(WFIFOP(src_sd->fd, 53), sd->gfx.name);
			}
			else {
				WFIFOB(src_sd->fd, 52) = 0;
				len = 1;
			}

			/*len = strlen(sd->gfx.name);
			if (strcmpi(sd->gfx.name, "")) {
				WFIFOB(src_sd->fd, 52) = len;
				strcpy(WFIFOP(src_sd->fd, 53), sd->gfx.name);
			} else {
				WFIFOW(src_sd->fd,52) = 0;
				len = 1;
			}*/
		}

		WFIFOW(src_sd->fd, 1) = SWAP16(len + 55 + 3);
		WFIFOSET(src_sd->fd, encrypt(src_sd->fd));
	}

	if (map[sd->bl.m].show_ghosts) {
		if (sd->status.state == 1 && (src_sd->bl.id != sd->bl.id)) {
			if (src_sd->status.state != 1 && !(src_sd->optFlags & optFlag_ghosts)) {
				WFIFOB(src_sd->fd, 0) = 0xAA;
				WFIFOB(src_sd->fd, 1) = 0x00;
				WFIFOB(src_sd->fd, 2) = 0x06;
				WFIFOB(src_sd->fd, 3) = 0x0E;
				WFIFOB(src_sd->fd, 4) = 0x03;
				WFIFOL(src_sd->fd, 5) = SWAP32(sd->bl.id);
				WFIFOSET(src_sd->fd, encrypt(src_sd->fd));

				return 0;
			}
			else {
				clif_charspecific(src_sd->bl.id, sd->bl.id);
			}

			/*} else if(sd->status.state==0 && (src_sd->bl.id!=sd->bl.id)) {
				if(src_sd->status.state==1) {
					WFIFOB(sd->fd, 0) = 0xAA;
					WFIFOB(sd->fd, 1) = 0x00;
					WFIFOB(sd->fd, 2) = 0x06;
					WFIFOB(sd->fd, 3) = 0x5F;
					WFIFOB(sd->fd, 4) = 0x03;
					WFIFOL(sd->fd, 5) = SWAP32(src_sd->bl.id);
					encrypt(WFIFOP(sd->fd,0));
					WFIFOSET(sd->fd,9);
				} */
		}
	}

	return 0;
}

/* This is where Board commands go */

int clif_showboards(USER* sd) {
	int len;
	int x, i;
	int b_count;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x31;
	WFIFOB(sd->fd, 4) = 3;
	WFIFOB(sd->fd, 5) = 1;
	WFIFOB(sd->fd, 6) = 13;
	strcpy(WFIFOP(sd->fd, 7), "NexusTKBoards");
	len = 15;
	b_count = 0;
	for (i = 0; i < 256; i++)
	{
		for (x = 0; x < 256; x++)
		{
			if (boarddb_sort(x) == i && boarddb_level(x) <= sd->status.level && boarddb_gmlevel(x) <= sd->status.gm_level
				&& (boarddb_path(x) == sd->status.class || boarddb_path(x) == 0) && (boarddb_clan(x) == sd->status.clan || boarddb_clan(x) == 0)) {
				WFIFOW(sd->fd, len + 6) = SWAP16(x);
				WFIFOB(sd->fd, len + 8) = strlen(boarddb_name(x));
				strcpy(WFIFOP(sd->fd, len + 9), boarddb_name(x));
				len += strlen(boarddb_name(x)) + 3;
				b_count += 1;
				break;
			}
		}
	}
	WFIFOB(sd->fd, 20) = b_count;
	WFIFOW(sd->fd, 1) = SWAP16(len + 3);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

char* clif_getofflinename(unsigned int owner) {
	char name[16] = "";
	SqlStmt* stmt;

	stmt = SqlStmt_Malloc(sql_handle);
	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaName` FROM `Character` WHERE `ChaId` = '%u'", owner)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &name, sizeof(name), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	if (SQL_SUCCESS == SqlStmt_NextRow(stmt)) {
		SqlStmt_Free(stmt);
	}
	else {
		SqlStmt_Free(stmt);
	}

	return &name[0];
}

int clif_buydialog(USER* sd, unsigned int id, char* dialog, struct item* item, int price[], int count) {
	NPC* nd = NULL;
	int graphic = sd->npc_g;
	int color = sd->npc_gc;
	int x = 0;
	int len;
	int i;

	char name[64];
	char buff[64];

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 47; //THis is a buy packet
	//WFIFOB(sd->fd,4)=3;
	WFIFOB(sd->fd, 5) = 4;//This is a buy packet(id)
	WFIFOB(sd->fd, 6) = 2; //For parsing purposes
	WFIFOL(sd->fd, 7) = SWAP32(id);

	if (graphic > 0) {
		if (graphic > 49152)
			WFIFOB(sd->fd, 11) = 2;
		else
			WFIFOB(sd->fd, 11) = 1;

		WFIFOB(sd->fd, 12) = 1;
		WFIFOW(sd->fd, 13) = SWAP16(graphic);
		WFIFOB(sd->fd, 15) = color;
		WFIFOB(sd->fd, 16) = 1;
		WFIFOW(sd->fd, 17) = SWAP16(graphic);
		WFIFOB(sd->fd, 19) = color;

		WFIFOW(sd->fd, 20) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 22), dialog);
		len = strlen(dialog);
		WFIFOW(sd->fd, len + 22) = strlen(dialog);
		len += 2;
		WFIFOW(sd->fd, len + 22) = SWAP16(count);
		len += 2;

		for (x = 0; x < count; x++) {
			memset(name, 0, 64);

			if (item[x].customIcon > 0)
			{
				WFIFOW(sd->fd, len + 22) = SWAP16(item[x].customIcon + 49152);
				WFIFOB(sd->fd, len + 24) = item[x].customIconColor;
			}
			else {
				WFIFOW(sd->fd, len + 22) = SWAP16(itemdb_icon(item[x].id));
				WFIFOB(sd->fd, len + 24) = itemdb_iconcolor(item[x].id);
			}

			len += 3;
			WFIFOL(sd->fd, len + 22) = SWAP32(price[x]);
			len += 4;

			if (strcmp(item[x].real_name, "") != 0) {
				sprintf(name, "%s", item[x].real_name);
				//strcpy(name,item[x].real_name);
			}
			else
			{
				sprintf(name, "%s", itemdb_name(item[x].id));
				//strcpy(name,itemdb_name(item[x].id));
			}

			if (item[x].owner != 0) {
				sprintf(name + strlen(name), " - BONDED");
			}

			//printf("%s\n",name);

			WFIFOB(sd->fd, len + 22) = strlen(name);
			strcpy(WFIFOP(sd->fd, len + 23), name);
			len += strlen(name) + 1;

			if (strcmp(itemdb_buytext(item[x].id), "") != 0) {
				strcpy(buff, itemdb_buytext(item[x].id));
			}
			else if (strcmp(item[x].buytext, "") != 0) {
				strcpy(buff, item[x].buytext);
			}
			else {
				char* path = classdb_name(itemdb_class(item[x].id), itemdb_rank(item[x].id));
				sprintf(buff, "%s level %u", path, itemdb_level(item[x].id));
			}

			WFIFOB(sd->fd, len + 22) = strlen(buff);
			memcpy(WFIFOP(sd->fd, len + 23), buff, strlen(buff));
			len += strlen(buff) + 1;
		}

		WFIFOW(sd->fd, 1) = SWAP16(len + 19);
		WFIFOSET(sd->fd, encrypt(sd->fd));
	}
	else {
		nd = map_id2npc(id);
		WFIFOB(sd->fd, 11) = 1;
		WFIFOW(sd->fd, 12) = SWAP16(nd->sex);
		WFIFOB(sd->fd, 14) = nd->state;
		WFIFOB(sd->fd, 15) = 0;
		WFIFOW(sd->fd, 16) = SWAP16(nd->equip[EQ_ARMOR].id);
		WFIFOB(sd->fd, 18) = 0;
		WFIFOB(sd->fd, 19) = nd->face;
		WFIFOB(sd->fd, 20) = nd->hair;
		WFIFOB(sd->fd, 21) = nd->hair_color;
		WFIFOB(sd->fd, 22) = nd->face_color;
		WFIFOB(sd->fd, 23) = nd->skin_color;

		//armor
		if (!nd->equip[EQ_ARMOR].id) {
			WFIFOW(sd->fd, 24) = 0xFFFF;
			WFIFOB(sd->fd, 26) = 0;
		}
		else {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_ARMOR].id);

			if (nd->armor_color) {
				WFIFOB(sd->fd, 26) = nd->armor_color;
			}
			else {
				WFIFOB(sd->fd, 26) = nd->equip[EQ_ARMOR].customLookColor;
			}
		}

		//coat
		if (nd->equip[EQ_COAT].id) {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_COAT].id);
			WFIFOB(sd->fd, 26) = nd->equip[EQ_COAT].customLookColor;
		}

		//weap
		if (!nd->equip[EQ_WEAP].id) {
			WFIFOW(sd->fd, 27) = 0xFFFF;
			WFIFOB(sd->fd, 29) = 0;
		}
		else {
			WFIFOW(sd->fd, 27) = SWAP16(nd->equip[EQ_WEAP].id);
			WFIFOB(sd->fd, 29) = nd->equip[EQ_WEAP].customLookColor;
		}

		//shield
		if (!nd->equip[EQ_SHIELD].id) {
			WFIFOW(sd->fd, 30) = 0xFFFF;
			WFIFOB(sd->fd, 32) = 0;
		}
		else {
			WFIFOW(sd->fd, 30) = SWAP16(nd->equip[EQ_SHIELD].id);
			WFIFOB(sd->fd, 32) = nd->equip[EQ_SHIELD].customLookColor;
		}

		//helm
		if (!nd->equip[EQ_HELM].id) {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 34) = 0xFF;
			WFIFOB(sd->fd, 35) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 1;
			WFIFOW(sd->fd, 34) = nd->equip[EQ_HELM].id;
			WFIFOB(sd->fd, 35) = nd->equip[EQ_HELM].customLookColor;
		}

		//faceacc
		if (!nd->equip[EQ_FACEACC].id) {
			WFIFOW(sd->fd, 36) = 0xFFFF;
			WFIFOB(sd->fd, 38) = 0;
		}
		else {
			WFIFOW(sd->fd, 36) = SWAP16(nd->equip[EQ_FACEACC].id);
			WFIFOB(sd->fd, 38) = nd->equip[EQ_FACEACC].customLookColor;
		}

		//crown
		if (!nd->equip[EQ_CROWN].id) {
			WFIFOW(sd->fd, 39) = 0xFFFF;
			WFIFOB(sd->fd, 41) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 39) = SWAP16(nd->equip[EQ_CROWN].id);
			WFIFOB(sd->fd, 41) = nd->equip[EQ_CROWN].customLookColor;
		}

		if (!nd->equip[EQ_FACEACCTWO].id) {
			WFIFOW(sd->fd, 42) = 0xFFFF;
			WFIFOB(sd->fd, 44) = 0;
		}
		else {
			WFIFOW(sd->fd, 42) = SWAP16(nd->equip[EQ_FACEACCTWO].id);
			WFIFOB(sd->fd, 44) = nd->equip[EQ_FACEACCTWO].customLookColor;
		}

		//mantle
		if (!nd->equip[EQ_MANTLE].id) {
			WFIFOW(sd->fd, 45) = 0xFFFF;
			WFIFOB(sd->fd, 47) = 0;
		}
		else {
			WFIFOW(sd->fd, 45) = SWAP16(nd->equip[EQ_MANTLE].id);
			WFIFOB(sd->fd, 47) = nd->equip[EQ_MANTLE].customLookColor;
		}

		//necklace
		if (!nd->equip[EQ_NECKLACE].id) {
			WFIFOW(sd->fd, 48) = 0xFFFF;
			WFIFOB(sd->fd, 50) = 0;
		}
		else {
			WFIFOW(sd->fd, 48) = SWAP16(nd->equip[EQ_NECKLACE].id);
			WFIFOB(sd->fd, 50) = nd->equip[EQ_NECKLACE].customLookColor;
		}

		//boots
		if (!nd->equip[EQ_BOOTS].id) {
			WFIFOW(sd->fd, 51) = SWAP16(nd->sex);
			WFIFOB(sd->fd, 53) = 0;
		}
		else {
			WFIFOW(sd->fd, 51) = SWAP16(nd->equip[EQ_BOOTS].id);
			WFIFOB(sd->fd, 53) = nd->equip[EQ_BOOTS].customLookColor;
		}

		WFIFOB(sd->fd, 54) = 1;
		WFIFOW(sd->fd, 55) = SWAP16(graphic);
		WFIFOB(sd->fd, 57) = color;

		WFIFOW(sd->fd, 60) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 62), dialog);
		len = strlen(dialog);
		WFIFOW(sd->fd, len + 62) = strlen(dialog);
		len += 2;
		WFIFOW(sd->fd, len + 62) = SWAP16(count);
		len += 2;

		for (x = 0; x < count; x++) {
			memset(name, 0, 64);

			if (item[x].customIcon > 0)
			{
				WFIFOW(sd->fd, len + 62) = SWAP16(item[x].customIcon);
				WFIFOB(sd->fd, len + 64) = item[x].customIconColor;
			}
			else {
				WFIFOW(sd->fd, len + 62) = SWAP16(itemdb_icon(item[x].id));
				WFIFOB(sd->fd, len + 64) = itemdb_iconcolor(item[x].id);
			}

			len += 3;
			WFIFOL(sd->fd, len + 62) = SWAP32(price[x]);
			len += 4;

			if (strcmp(item[x].real_name, "") != 0) {
				strcpy(name, item[x].real_name);
			}
			else
			{
				strcpy(name, itemdb_name(item[x].id));
			}

			if (item[x].owner != 0) {
				sprintf(name + strlen(name), " - BONDED");
			}

			WFIFOB(sd->fd, len + 62) = strlen(name);
			strcpy(WFIFOP(sd->fd, len + 63), name);
			len += strlen(name) + 1;

			if (strcmp(itemdb_buytext(item[x].id), "") != 0) {
				strcpy(buff, itemdb_buytext(item[x].id));
			}
			else if (strcmp(item[x].buytext, "") != 0) {
				strcpy(buff, item[x].buytext);
			}
			else {
				char* path = classdb_name(itemdb_class(item[x].id), itemdb_rank(item[x].id));
				sprintf(buff, "%s level %u", path, itemdb_level(item[x].id));
			}

			WFIFOB(sd->fd, len + 62) = strlen(buff);
			memcpy(WFIFOP(sd->fd, len + 63), buff, strlen(buff));
			len += strlen(buff) + 1;
		}
		WFIFOW(sd->fd, 1) = SWAP16(len + 63);
		WFIFOSET(sd->fd, encrypt(sd->fd));
	}

	FREE(item);
	return 0;
}

int clif_parsebuy(USER* sd) {
	char itemname[255];
	struct item_data* item = NULL;

	memset(itemname, 0, 255);
	memcpy(itemname, RFIFOP(sd->fd, 13), RFIFOB(sd->fd, 12));

	//clif_debug(RFIFOP(sd->fd, 0), SWAP16(RFIFOW(sd->fd, 1)));

	//char *pos = strstr(itemname, " - BONDED");

	//if(pos != NULL) *pos = '\0';

	/*item=itemdb_searchname(itemname);

	if (item) {
		sl_resumebuy(item->id,sd);
	}*/

	if (strcmp(itemname, "") != 0) sl_resumebuy(itemname, sd);

	return 0;
}

int clif_selldialog(USER* sd, unsigned int id, char* dialog, int item[], int count) {
	NPC* nd = NULL;
	int graphic = sd->npc_g;
	int color = sd->npc_gc;
	int x;
	int len;
	int i;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 47; //THis is a buy packet
	WFIFOB(sd->fd, 4) = 3;
	WFIFOB(sd->fd, 5) = 5;//This is a buy packet(id)
	WFIFOB(sd->fd, 6) = 4; //For parsing purposes
	WFIFOL(sd->fd, 7) = SWAP32(id);

	if (graphic > 0) {
		if (graphic > 49152) {
			WFIFOB(sd->fd, 11) = 2;
		}
		else {
			WFIFOB(sd->fd, 11) = 1;
		}
		WFIFOB(sd->fd, 12) = 1;
		WFIFOW(sd->fd, 13) = SWAP16(graphic);
		WFIFOB(sd->fd, 15) = color;
		WFIFOB(sd->fd, 16) = 1;
		WFIFOW(sd->fd, 17) = SWAP16(graphic);
		WFIFOB(sd->fd, 19) = color;

		WFIFOW(sd->fd, 20) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 22), dialog);
		len = strlen(dialog) + 2;
		WFIFOW(sd->fd, len + 20) = SWAP16(strlen(dialog));
		len += 2;
		WFIFOB(sd->fd, len + 20) = count;
		len += 1;
		for (i = 0; i < count; i++) {
			WFIFOB(sd->fd, len + 20) = item[i] + 1;
			len += 1;
		}
		WFIFOW(sd->fd, 1) = SWAP16(len + 17);
		WFIFOSET(sd->fd, encrypt(sd->fd));
	}
	else {
		nd = map_id2npc(id);
		WFIFOB(sd->fd, 11) = 1;
		WFIFOW(sd->fd, 12) = SWAP16(nd->sex);
		WFIFOB(sd->fd, 14) = nd->state;
		WFIFOB(sd->fd, 15) = 0;
		WFIFOW(sd->fd, 16) = SWAP16(nd->equip[EQ_ARMOR].id);
		WFIFOB(sd->fd, 18) = 0;
		WFIFOB(sd->fd, 19) = nd->face;
		WFIFOB(sd->fd, 20) = nd->hair;
		WFIFOB(sd->fd, 21) = nd->hair_color;
		WFIFOB(sd->fd, 22) = nd->face_color;
		WFIFOB(sd->fd, 23) = nd->skin_color;

		//armor
		if (!nd->equip[EQ_ARMOR].id) {
			WFIFOW(sd->fd, 24) = 0xFFFF;
			WFIFOB(sd->fd, 26) = 0;
		}
		else {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_ARMOR].id);

			if (nd->armor_color) {
				WFIFOB(sd->fd, 26) = nd->armor_color;
			}
			else {
				WFIFOB(sd->fd, 26) = nd->equip[EQ_ARMOR].customLookColor;
			}
		}

		//coat
		if (nd->equip[EQ_COAT].id) {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_COAT].id);
			WFIFOB(sd->fd, 26) = nd->equip[EQ_COAT].customLookColor;
		}

		//weap
		if (!nd->equip[EQ_WEAP].id) {
			WFIFOW(sd->fd, 27) = 0xFFFF;
			WFIFOB(sd->fd, 29) = 0;
		}
		else {
			WFIFOW(sd->fd, 27) = SWAP16(nd->equip[EQ_WEAP].id);
			WFIFOB(sd->fd, 29) = nd->equip[EQ_WEAP].customLookColor;
		}

		//shield
		if (!nd->equip[EQ_SHIELD].id) {
			WFIFOW(sd->fd, 30) = 0xFFFF;
			WFIFOB(sd->fd, 32) = 0;
		}
		else {
			WFIFOW(sd->fd, 30) = SWAP16(nd->equip[EQ_SHIELD].id);
			WFIFOB(sd->fd, 32) = nd->equip[EQ_SHIELD].customLookColor;
		}

		//helm
		if (!nd->equip[EQ_HELM].id) {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 34) = 0xFF;
			WFIFOB(sd->fd, 35) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 1;
			WFIFOW(sd->fd, 34) = nd->equip[EQ_HELM].id;
			WFIFOB(sd->fd, 35) = nd->equip[EQ_HELM].customLookColor;
		}

		//faceacc
		if (!nd->equip[EQ_FACEACC].id) {
			WFIFOW(sd->fd, 36) = 0xFFFF;
			WFIFOB(sd->fd, 38) = 0;
		}
		else {
			WFIFOW(sd->fd, 36) = SWAP16(nd->equip[EQ_FACEACC].id);
			WFIFOB(sd->fd, 38) = nd->equip[EQ_FACEACC].customLookColor;
		}

		//crown
		if (!nd->equip[EQ_CROWN].id) {
			WFIFOW(sd->fd, 39) = 0xFFFF;
			WFIFOB(sd->fd, 41) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 39) = SWAP16(nd->equip[EQ_CROWN].id);
			WFIFOB(sd->fd, 41) = nd->equip[EQ_CROWN].customLookColor;
		}

		if (!nd->equip[EQ_FACEACCTWO].id) {
			WFIFOW(sd->fd, 42) = 0xFFFF;
			WFIFOB(sd->fd, 44) = 0;
		}
		else {
			WFIFOW(sd->fd, 42) = SWAP16(nd->equip[EQ_FACEACCTWO].id);
			WFIFOB(sd->fd, 44) = nd->equip[EQ_FACEACCTWO].customLookColor;
		}

		//mantle
		if (!nd->equip[EQ_MANTLE].id) {
			WFIFOW(sd->fd, 45) = 0xFFFF;
			WFIFOB(sd->fd, 47) = 0;
		}
		else {
			WFIFOW(sd->fd, 45) = SWAP16(nd->equip[EQ_MANTLE].id);
			WFIFOB(sd->fd, 47) = nd->equip[EQ_MANTLE].customLookColor;
		}

		//necklace
		if (!nd->equip[EQ_NECKLACE].id) {
			WFIFOW(sd->fd, 48) = 0xFFFF;
			WFIFOB(sd->fd, 50) = 0;
		}
		else {
			WFIFOW(sd->fd, 48) = SWAP16(nd->equip[EQ_NECKLACE].id);
			WFIFOB(sd->fd, 50) = nd->equip[EQ_NECKLACE].customLookColor;
		}

		//boots
		if (!nd->equip[EQ_BOOTS].id) {
			WFIFOW(sd->fd, 51) = SWAP16(nd->sex);
			WFIFOB(sd->fd, 53) = 0;
		}
		else {
			WFIFOW(sd->fd, 51) = SWAP16(nd->equip[EQ_BOOTS].id);
			WFIFOB(sd->fd, 53) = nd->equip[EQ_BOOTS].customLookColor;
		}

		WFIFOB(sd->fd, 54) = 1;
		WFIFOW(sd->fd, 55) = SWAP16(graphic);
		WFIFOB(sd->fd, 57) = color;

		WFIFOW(sd->fd, 60) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 62), dialog);
		len = strlen(dialog);
		WFIFOW(sd->fd, len + 62) = strlen(dialog);
		len += 2;
		WFIFOB(sd->fd, len + 62) = count;
		len += 1;

		for (i = 0; i < count; i++) {
			WFIFOB(sd->fd, len + 62) = item[i] + 1;
			len += 1;
		}

		WFIFOW(sd->fd, 1) = SWAP16(len + 62);
		WFIFOSET(sd->fd, encrypt(sd->fd));
	}
	return 0;
}

int clif_parsesell(USER* sd) {
	sl_resumesell(RFIFOB(sd->fd, 12), sd);
	return 0;
}

int clif_isregistered(unsigned int id) {
	int accountid = 0;

	SqlStmt* stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `AccountId` FROM `Accounts` WHERE `AccountCharId1` = '%u' OR `AccountCharId2` = '%u' OR `AccountCharId3` = '%u' OR `AccountCharId4` = '%u' OR `AccountCharId5` = '%u' OR `AccountCharId6` = '%u'", id, id, id, id, id, id)
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

	//if (accountid > 0) return 1;
	//else return 0;
}

char* clif_getaccountemail(unsigned int id) {
	//char email[255];

	char* email;
	CALLOC(email, char, 255);
	memset(email, 0, 255);

	int acctid = clif_isregistered(id);
	if (acctid == 0) return 0;

	SqlStmt* stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `AccountEmail` FROM `Accounts` WHERE `AccountId` = '%u'", acctid)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &email[0], 255, NULL, NULL))
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	if (SQL_SUCCESS != SqlStmt_NextRow(stmt))
	{
	}

	//printf("email is: %s\n",email);
	return &email[0];
}

int clif_input(USER* sd, int id, char* dialog, char* item) {
	int graphic = sd->npc_g;
	int color = sd->npc_gc;

	int x, i, len;
	NPC* nd = map_id2npc((unsigned int)id);
	int type = sd->dialogtype;

	if (nd) {
		nd->lastaction = time(NULL);
	}

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 1000);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x2F; //THis is a buy packet
	//WFIFOB(sd->fd,4)=3;
	WFIFOB(sd->fd, 5) = 3;//This is a input amount packet(id=3)
	WFIFOB(sd->fd, 6) = 3;//For parsing purposes
	WFIFOL(sd->fd, 7) = SWAP32(id);

	if (type == 0) {
		if (graphic == 0)
			WFIFOB(sd->fd, 11) = 0;
		else if (graphic >= 49152) {
			WFIFOB(sd->fd, 11) = 2;
		}
		else {
			WFIFOB(sd->fd, 11) = 1;
		}
		WFIFOB(sd->fd, 12) = 1;
		WFIFOW(sd->fd, 13) = SWAP16(graphic);
		WFIFOB(sd->fd, 15) = color;
		WFIFOB(sd->fd, 16) = 1;
		WFIFOW(sd->fd, 17) = SWAP16(graphic);
		WFIFOB(sd->fd, 19) = color;

		WFIFOW(sd->fd, 20) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 22), dialog);
		len = strlen(dialog);
		WFIFOB(sd->fd, len + 22) = strlen(item);
		len += 1;
		strcpy(WFIFOP(sd->fd, len + 23), item);
		len += strlen(item) + 1;
		WFIFOW(sd->fd, len + 22) = SWAP16(76);
		len += 2;

		WFIFOW(sd->fd, 1) = SWAP16(len + 19);
		WFIFOSET(sd->fd, encrypt(sd->fd));
	}
	else if (type == 1) {
		WFIFOB(sd->fd, 11) = 1;
		WFIFOW(sd->fd, 12) = SWAP16(nd->sex);
		WFIFOB(sd->fd, 14) = nd->state;
		WFIFOB(sd->fd, 15) = 0;
		WFIFOW(sd->fd, 16) = SWAP16(nd->equip[EQ_ARMOR].id);
		WFIFOB(sd->fd, 18) = 0;
		WFIFOB(sd->fd, 19) = nd->face;
		WFIFOB(sd->fd, 20) = nd->hair;
		WFIFOB(sd->fd, 21) = nd->hair_color;
		WFIFOB(sd->fd, 22) = nd->face_color;
		WFIFOB(sd->fd, 23) = nd->skin_color;

		//armor
		if (!nd->equip[EQ_ARMOR].id) {
			WFIFOW(sd->fd, 24) = 0xFFFF;
			WFIFOB(sd->fd, 26) = 0;
		}
		else {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_ARMOR].id);

			if (nd->armor_color) {
				WFIFOB(sd->fd, 26) = nd->armor_color;
			}
			else {
				WFIFOB(sd->fd, 26) = nd->equip[EQ_ARMOR].customLookColor;
			}
		}

		//coat
		if (nd->equip[EQ_COAT].id) {
			WFIFOW(sd->fd, 24) = SWAP16(nd->equip[EQ_COAT].id);
			WFIFOB(sd->fd, 26) = nd->equip[EQ_COAT].customLookColor;
		}

		//weap
		if (!nd->equip[EQ_WEAP].id) {
			WFIFOW(sd->fd, 27) = 0xFFFF;
			WFIFOB(sd->fd, 29) = 0;
		}
		else {
			WFIFOW(sd->fd, 27) = SWAP16(nd->equip[EQ_WEAP].id);
			WFIFOB(sd->fd, 29) = nd->equip[EQ_WEAP].customLookColor;
		}

		//shield
		if (!nd->equip[EQ_SHIELD].id) {
			WFIFOW(sd->fd, 30) = 0xFFFF;
			WFIFOB(sd->fd, 32) = 0;
		}
		else {
			WFIFOW(sd->fd, 30) = SWAP16(nd->equip[EQ_SHIELD].id);
			WFIFOB(sd->fd, 32) = nd->equip[EQ_SHIELD].customLookColor;
		}

		//helm
		if (!nd->equip[EQ_HELM].id) {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOB(sd->fd, 34) = 0xFF;
			WFIFOB(sd->fd, 35) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 1;
			WFIFOB(sd->fd, 34) = nd->equip[EQ_HELM].id;
			WFIFOB(sd->fd, 35) = nd->equip[EQ_HELM].customLookColor;
		}

		//faceacc
		if (!nd->equip[EQ_FACEACC].id) {
			WFIFOW(sd->fd, 36) = 0xFFFF;
			WFIFOB(sd->fd, 38) = 0;
		}
		else {
			WFIFOW(sd->fd, 36) = SWAP16(nd->equip[EQ_FACEACC].id);
			WFIFOB(sd->fd, 38) = nd->equip[EQ_FACEACC].customLookColor;
		}

		//crown
		if (!nd->equip[EQ_CROWN].id) {
			WFIFOW(sd->fd, 39) = 0xFFFF;
			WFIFOB(sd->fd, 41) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 39) = SWAP16(nd->equip[EQ_CROWN].id);
			WFIFOB(sd->fd, 41) = nd->equip[EQ_CROWN].customLookColor;
		}

		if (!nd->equip[EQ_FACEACCTWO].id) {
			WFIFOW(sd->fd, 42) = 0xFFFF;
			WFIFOB(sd->fd, 44) = 0;
		}
		else {
			WFIFOW(sd->fd, 42) = SWAP16(nd->equip[EQ_FACEACCTWO].id);
			WFIFOB(sd->fd, 44) = nd->equip[EQ_FACEACCTWO].customLookColor;
		}

		//mantle
		if (!nd->equip[EQ_MANTLE].id) {
			WFIFOW(sd->fd, 45) = 0xFFFF;
			WFIFOB(sd->fd, 47) = 0;
		}
		else {
			WFIFOW(sd->fd, 45) = SWAP16(nd->equip[EQ_MANTLE].id);
			WFIFOB(sd->fd, 47) = nd->equip[EQ_MANTLE].customLookColor;
		}

		//necklace
		if (!nd->equip[EQ_NECKLACE].id) {
			WFIFOW(sd->fd, 48) = 0xFFFF;
			WFIFOB(sd->fd, 50) = 0;
		}
		else {
			WFIFOW(sd->fd, 48) = SWAP16(nd->equip[EQ_NECKLACE].id);
			WFIFOB(sd->fd, 50) = nd->equip[EQ_NECKLACE].customLookColor;
		}

		//boots
		if (!nd->equip[EQ_BOOTS].id) {
			WFIFOW(sd->fd, 51) = SWAP16(nd->sex);
			WFIFOB(sd->fd, 53) = 0;
		}
		else {
			WFIFOW(sd->fd, 51) = SWAP16(nd->equip[EQ_BOOTS].id);
			WFIFOB(sd->fd, 53) = nd->equip[EQ_BOOTS].customLookColor;
		}

		WFIFOB(sd->fd, 54) = 1;
		WFIFOW(sd->fd, 55) = SWAP16(graphic);
		WFIFOB(sd->fd, 57) = color;
		WFIFOW(sd->fd, 58) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 60), dialog);
		len = strlen(dialog);
		WFIFOB(sd->fd, len + 60) = strlen(item);
		len += 1;
		strcpy(WFIFOP(sd->fd, len + 61), item);
		len += strlen(item) + 1;
		WFIFOW(sd->fd, len + 60) = SWAP16(76);
		len += 2;

		WFIFOW(sd->fd, 1) = SWAP16(len + 57);
		WFIFOSET(sd->fd, encrypt(sd->fd));
	}
	else if (type == 2) {
		WFIFOB(sd->fd, 11) = 1;
		WFIFOW(sd->fd, 12) = SWAP16(nd->sex);
		WFIFOB(sd->fd, 14) = nd->state;
		WFIFOB(sd->fd, 15) = 0;
		WFIFOW(sd->fd, 16) = SWAP16(nd->gfx.armor);
		WFIFOB(sd->fd, 18) = 0;
		WFIFOB(sd->fd, 19) = nd->gfx.face;
		WFIFOB(sd->fd, 20) = nd->gfx.hair;
		WFIFOB(sd->fd, 21) = nd->gfx.chair;
		WFIFOB(sd->fd, 22) = nd->gfx.cface;
		WFIFOB(sd->fd, 23) = nd->gfx.cskin;

		//armor
		WFIFOW(sd->fd, 24) = SWAP16(nd->gfx.armor);
		WFIFOB(sd->fd, 26) = nd->gfx.carmor;

		//weap
		WFIFOW(sd->fd, 27) = SWAP16(nd->gfx.weapon);
		WFIFOB(sd->fd, 29) = nd->gfx.cweapon;

		//shield
		WFIFOW(sd->fd, 30) = SWAP16(nd->gfx.shield);
		WFIFOB(sd->fd, 32) = nd->gfx.cshield;

		//helm
		if (nd->gfx.helm == 65535) {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOB(sd->fd, 34) = 0xFF;
			WFIFOB(sd->fd, 35) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 1;
			WFIFOB(sd->fd, 34) = nd->gfx.helm;
			WFIFOB(sd->fd, 35) = nd->gfx.chelm;
		}

		//faceacc
		WFIFOW(sd->fd, 36) = SWAP16(nd->gfx.faceAcc);
		WFIFOB(sd->fd, 38) = nd->gfx.cfaceAcc;

		//crown
		if (nd->gfx.crown == 65535) {
			WFIFOW(sd->fd, 39) = 0xFFFF;
			WFIFOB(sd->fd, 41) = 0;
		}
		else {
			WFIFOB(sd->fd, 33) = 0;
			WFIFOW(sd->fd, 39) = SWAP16(nd->gfx.crown);
			WFIFOB(sd->fd, 41) = nd->gfx.ccrown;
		}

		WFIFOW(sd->fd, 42) = SWAP16(nd->gfx.faceAccT);
		WFIFOB(sd->fd, 44) = nd->gfx.cfaceAccT;

		//mantle
		WFIFOW(sd->fd, 45) = SWAP16(nd->gfx.mantle);
		WFIFOB(sd->fd, 47) = nd->gfx.cmantle;

		//necklace
		WFIFOW(sd->fd, 48) = SWAP16(nd->gfx.necklace);
		WFIFOB(sd->fd, 50) = nd->gfx.cnecklace;

		//boots
		WFIFOW(sd->fd, 51) = SWAP16(nd->gfx.boots);
		WFIFOB(sd->fd, 53) = nd->gfx.cboots;

		WFIFOB(sd->fd, 54) = 1;
		WFIFOW(sd->fd, 55) = SWAP16(graphic);
		WFIFOB(sd->fd, 57) = color;
		WFIFOW(sd->fd, 58) = SWAP16(strlen(dialog));
		strcpy(WFIFOP(sd->fd, 60), dialog);
		len = strlen(dialog);
		WFIFOB(sd->fd, len + 60) = strlen(item);
		len += 1;
		strcpy(WFIFOP(sd->fd, len + 61), item);
		len += strlen(item) + 1;
		WFIFOW(sd->fd, len + 60) = SWAP16(76);
		len += 2;

		WFIFOW(sd->fd, 1) = SWAP16(len + 57);
		WFIFOSET(sd->fd, encrypt(sd->fd));
	}

	return 0;
}

int clif_parseinput(USER* sd) {
	char output[256];
	char output2[256];
	int tlen = 0;

	memset(output, 0, 256);
	memset(output2, 0, 256);
	memcpy(output, RFIFOP(sd->fd, 13), RFIFOB(sd->fd, 12));
	tlen = RFIFOB(sd->fd, 12) + 1;
	memcpy(output2, RFIFOP(sd->fd, tlen + 13), RFIFOB(sd->fd, tlen + 12));

	sl_resumeinput(output, output2, sd);
	return 0;
}

int clif_clickonplayer(USER* sd, struct block_list* bl) {
	USER* tsd = NULL;
	int len = 0;
	char equip_status[65535];
	char buff[256];
	char buf[255];
	int x, count = 0, equip_len = 0;
	char* nameof = NULL;

	tsd = map_id2sd(bl->id);
	equip_status[0] = '\0';

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);

	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x34;
	//WFIFOB(sd->fd,4)=0x03;

	//Title
	if (strlen(tsd->status.title) > 0) {
		WFIFOB(sd->fd, 5) = strlen(tsd->status.title);
		strcpy(WFIFOP(sd->fd, 6), tsd->status.title);
		len += strlen(tsd->status.title) + 1;
	}
	else {
		WFIFOB(sd->fd, 5) = 0;
		len += 1;
	}

	//Clan
	if (tsd->status.clan > 0) {
		WFIFOB(sd->fd, len + 5) = strlen(clandb_name(tsd->status.clan));
		strcpy(WFIFOP(sd->fd, len + 6), clandb_name(tsd->status.clan));
		len += strlen(clandb_name(tsd->status.clan)) + 1;
	}
	else {
		WFIFOB(sd->fd, len + 5) = 0;
		len += 1;
	}

	//Clan Title
	if (strlen(tsd->status.clan_title) > 0) {
		WFIFOB(sd->fd, len + 5) = strlen(tsd->status.clan_title);
		strcpy(WFIFOP(sd->fd, len + 6), tsd->status.clan_title);
		len += strlen(tsd->status.clan_title) + 1;
	}
	else {
		WFIFOB(sd->fd, len + 5) = 0;
		len += 1;
	}

	//Class
	if (classdb_name(tsd->status.class, tsd->status.mark)) {
		WFIFOB(sd->fd, len + 5) = strlen(classdb_name(tsd->status.class, tsd->status.mark));
		strcpy(WFIFOP(sd->fd, len + 6), classdb_name(tsd->status.class, tsd->status.mark));
		len += strlen(classdb_name(tsd->status.class, tsd->status.mark)) + 1;
	}
	else {
		WFIFOB(sd->fd, len + 5) = 0;
		len += 1;
	}

	//Name
	WFIFOB(sd->fd, len + 5) = strlen(tsd->status.name);
	strcpy(WFIFOP(sd->fd, len + 6), tsd->status.name);
	len += strlen(tsd->status.name);

	//WFIFOW(sd->fd,len+5)=SWAP16(1);
	//len-=1;
	WFIFOW(sd->fd, len + 6) = SWAP16(tsd->status.sex);
	WFIFOB(sd->fd, len + 8) = tsd->status.state;

	WFIFOW(sd->fd, len + 9) = SWAP16(0);
	WFIFOB(sd->fd, len + 11) = tsd->speed;

	if (tsd->status.state == 3) {
		WFIFOW(sd->fd, len + 9) = SWAP16(tsd->disguise);
	}
	else if (tsd->status.state == 4) {
		WFIFOW(sd->fd, len + 9) = SWAP16(tsd->disguise + 32768);
		WFIFOB(sd->fd, len + 11) = tsd->disguise_color;
	}

	WFIFOB(sd->fd, len + 12) = 0;
	WFIFOB(sd->fd, len + 13) = tsd->status.face; //face
	WFIFOB(sd->fd, len + 14) = tsd->status.hair; //hair
	WFIFOB(sd->fd, len + 15) = tsd->status.hair_color; //hair color
	WFIFOB(sd->fd, len + 16) = tsd->status.face_color;
	WFIFOB(sd->fd, len + 17) = tsd->status.skin_color;

	len += 14;

	if (!pc_isequip(tsd, EQ_ARMOR)) {
		WFIFOW(sd->fd, len + 4) = SWAP16(tsd->status.sex);
	}
	else {
		if (tsd->status.equip[EQ_ARMOR].customLook != 0) {
			WFIFOW(sd->fd, len + 4) = SWAP16(tsd->status.equip[EQ_ARMOR].customLook);
		}
		else {
			WFIFOW(sd->fd, len + 4) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_ARMOR)));
		}

		if (tsd->status.armor_color > 0) {
			WFIFOB(sd->fd, len + 6) = tsd->status.armor_color;
		}
		else {
			if (tsd->status.equip[EQ_ARMOR].customLook != 0) {
				WFIFOB(sd->fd, len + 6) = tsd->status.equip[EQ_ARMOR].customLookColor;
			}
			else {
				WFIFOB(sd->fd, len + 6) = itemdb_lookcolor(pc_isequip(tsd, EQ_ARMOR));
			}
		}
	}
	//coat
	if (pc_isequip(tsd, EQ_COAT)) {
		WFIFOW(sd->fd, len + 4) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_COAT)));

		if (tsd->status.armor_color > 0) {
			WFIFOB(sd->fd, len + 6) = tsd->status.armor_color;
		}
		else {
			WFIFOB(sd->fd, len + 6) = itemdb_lookcolor(pc_isequip(tsd, EQ_COAT));
		}
	}

	len += 3;
	//weapon
	if (!pc_isequip(tsd, EQ_WEAP)) {
		WFIFOW(sd->fd, len + 4) = 0xFFFF;
		WFIFOB(sd->fd, len + 6) = 0;
	}
	else {
		if (tsd->status.equip[EQ_WEAP].customLook != 0) { // edited on 07-16-2017 to support custom WEapon Skins
			WFIFOW(sd->fd, len + 4) = SWAP16(tsd->status.equip[EQ_WEAP].customLook);
			WFIFOB(sd->fd, len + 6) = tsd->status.equip[EQ_WEAP].customLookColor;
		}
		else {
			WFIFOW(sd->fd, len + 4) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_WEAP)));
			WFIFOB(sd->fd, len + 6) = itemdb_lookcolor(pc_isequip(tsd, EQ_WEAP));
		}
	}
	len += 3;
	//shield
	if (!pc_isequip(tsd, EQ_SHIELD)) {
		WFIFOW(sd->fd, len + 4) = 0xFFFF;
		WFIFOB(sd->fd, len + 6) = 0;
	}
	else {
		if (tsd->status.equip[EQ_SHIELD].customLook != 0) {
			WFIFOW(sd->fd, len + 4) = SWAP16(tsd->status.equip[EQ_SHIELD].customLook);
			WFIFOB(sd->fd, len + 6) = tsd->status.equip[EQ_SHIELD].customLookColor;
		}
		else {
			WFIFOW(sd->fd, len + 4) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_SHIELD)));
			WFIFOB(sd->fd, len + 6) = itemdb_lookcolor(pc_isequip(tsd, EQ_SHIELD));
		}
	}
	len += 3;
	if (!pc_isequip(tsd, EQ_HELM) || !(tsd->status.settingFlags & FLAG_HELM) || (itemdb_look(pc_isequip(tsd, EQ_HELM)) == -1)) {
		//helm stuff goes here
		WFIFOB(sd->fd, len + 4) = 0; // supposed to be 1=Helm, 0=No helm
		WFIFOW(sd->fd, len + 5) = 0xFFFF; // supposed to be Helm num
	}
	else {
		WFIFOB(sd->fd, len + 4) = 1;

		if (tsd->status.equip[EQ_HELM].customLook != 0) {
			WFIFOB(sd->fd, len + 5) = tsd->status.equip[EQ_HELM].customLook;
			WFIFOB(sd->fd, len + 6) = tsd->status.equip[EQ_HELM].customLookColor;
		}
		else {
			WFIFOB(sd->fd, len + 5) = itemdb_look(pc_isequip(tsd, EQ_HELM));
			WFIFOB(sd->fd, len + 6) = itemdb_lookcolor(pc_isequip(tsd, EQ_HELM));
		}
	}
	len += 3;
	//faceacc
	if (!pc_isequip(tsd, EQ_FACEACC)) {
		//beard stuff
		WFIFOW(sd->fd, len + 4) = 0xFFFF;
		WFIFOB(sd->fd, len + 6) = 0;
	}
	else {
		WFIFOW(sd->fd, len + 4) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_FACEACC))); //beard num
		WFIFOB(sd->fd, len + 6) = itemdb_lookcolor(pc_isequip(tsd, EQ_FACEACC)); //beard color
	}
	len += 3;
	//crown
	if (!pc_isequip(tsd, EQ_CROWN)) {
		WFIFOW(sd->fd, len + 4) = 0xFFFF;
		WFIFOB(sd->fd, len + 6) = 0;
	}
	else {
		WFIFOB(sd->fd, len) = 0;

		if (tsd->status.equip[EQ_CROWN].customLook != 0) {
			WFIFOW(sd->fd, len + 4) = SWAP16(tsd->status.equip[EQ_CROWN].customLook); //Crown
			WFIFOB(sd->fd, len + 6) = tsd->status.equip[EQ_CROWN].customLookColor; //Crown color
		}
		else {
			WFIFOW(sd->fd, len + 4) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_CROWN))); //Crown
			WFIFOB(sd->fd, len + 6) = itemdb_lookcolor(pc_isequip(tsd, EQ_CROWN)); //Crown color
		}
	}
	len += 3;

	if (!pc_isequip(tsd, EQ_FACEACCTWO)) {
		WFIFOW(sd->fd, len + 4) = 0xFFFF; //second face acc
		WFIFOB(sd->fd, len + 6) = 0; //" color
	}
	else {
		WFIFOW(sd->fd, len + 4) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_FACEACCTWO)));
		WFIFOB(sd->fd, len + 6) = itemdb_lookcolor(pc_isequip(tsd, EQ_FACEACCTWO));
	}

	len += 3;
	//mantle
	if (!pc_isequip(tsd, EQ_MANTLE)) {
		WFIFOW(sd->fd, len + 4) = 0xFFFF;
		WFIFOB(sd->fd, len + 6) = 0xFF;
	}
	else {
		WFIFOW(sd->fd, len + 4) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_MANTLE)));
		WFIFOB(sd->fd, len + 6) = itemdb_lookcolor(pc_isequip(tsd, EQ_MANTLE));
	}
	len += 3;

	//necklace
	if (!pc_isequip(tsd, EQ_NECKLACE) || !(tsd->status.settingFlags & FLAG_NECKLACE) || (itemdb_look(pc_isequip(tsd, EQ_NECKLACE)) == -1)) {
		WFIFOW(sd->fd, len + 4) = 0xFFFF;
		WFIFOB(sd->fd, len + 6) = 0;
	}
	else {
		WFIFOW(sd->fd, len + 4) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_NECKLACE))); //necklace
		WFIFOB(sd->fd, len + 6) = itemdb_lookcolor(pc_isequip(tsd, EQ_NECKLACE)); //neckalce color
	}
	len += 3;
	//boots
	if (!pc_isequip(tsd, EQ_BOOTS)) {
		WFIFOW(sd->fd, len + 4) = SWAP16(tsd->status.sex); //boots
		WFIFOB(sd->fd, len + 6) = 0;
	}
	else {
		if (tsd->status.equip[EQ_BOOTS].customLook != 0) {
			WFIFOW(sd->fd, len + 4) = SWAP16(tsd->status.equip[EQ_BOOTS].customLook);
			WFIFOB(sd->fd, len + 6) = tsd->status.equip[EQ_BOOTS].customLookColor;
		}
		else {
			WFIFOW(sd->fd, len + 4) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_BOOTS)));
			WFIFOB(sd->fd, len + 6) = itemdb_lookcolor(pc_isequip(tsd, EQ_BOOTS));
		}
	}

	len += 3;
	//WFIFOL(sd->fd,len+6)=0;
	//len+=4;
	for (x = 0; x < 14; x++) {
		if (tsd->status.equip[x].id > 0) {
			if (tsd->status.equip[x].customIcon != 0) {
				WFIFOW(sd->fd, len + 6) = SWAP16(tsd->status.equip[x].customIcon + 49152);
				WFIFOB(sd->fd, len + 8) = tsd->status.equip[x].customIconColor;
			}
			else {
				WFIFOW(sd->fd, len + 6) = SWAP16(itemdb_icon(tsd->status.equip[x].id));
				WFIFOB(sd->fd, len + 8) = itemdb_iconcolor(tsd->status.equip[x].id);
			}

			len += 3;

			if (strlen(tsd->status.equip[x].real_name)) {
				sprintf(buf, "%s", tsd->status.equip[x].real_name);
			}
			else {
				sprintf(buf, "%s", itemdb_name(tsd->status.equip[x].id));
			}

			WFIFOB(sd->fd, len + 6) = strlen(buf);
			strcpy(WFIFOP(sd->fd, len + 7), buf);
			len += strlen(buf) + 1;
			WFIFOB(sd->fd, len + 6) = strlen(itemdb_name(tsd->status.equip[x].id));
			strcpy(WFIFOP(sd->fd, len + 7), itemdb_name(tsd->status.equip[x].id));
			len += strlen(itemdb_name(tsd->status.equip[x].id)) + 1;
			WFIFOL(sd->fd, len + 6) = SWAP32(tsd->status.equip[x].dura);
			len += 5;
		}
		else {
			WFIFOW(sd->fd, len + 6) = SWAP16(0);
			WFIFOB(sd->fd, len + 8) = 0;
			WFIFOB(sd->fd, len + 9) = 0;
			WFIFOB(sd->fd, len + 10) = 0;
			WFIFOL(sd->fd, len + 11) = SWAP32(0);
			len += 10;
		}

		if (tsd->status.equip[x].id > 0 && (itemdb_type(tsd->status.equip[x].id) >= 3) && (itemdb_type(tsd->status.equip[x].id) <= 16)) {
			if (strlen(tsd->status.equip[x].real_name)) {
				nameof = tsd->status.equip[x].real_name;
			}
			else {
				nameof = itemdb_name(tsd->status.equip[x].id);
			}

			sprintf(buff, map_msg[clif_mapmsgnum(tsd, x)].message, nameof);
			strcat(equip_status, buff);
			strcat(equip_status, "\x0A");
		}
	}

	if (strlen(equip_status) == 0) {
		strcat(equip_status, "No items equipped.");
	}

	equip_len = strlen(equip_status);
	if (equip_len > 255) equip_len = 255;
	WFIFOB(sd->fd, len + 6) = equip_len;
	strcpy(WFIFOP(sd->fd, len + 7), equip_status);
	//printf("Len is %d\n",strlen(equip_status));
	len += equip_len + 1;

	WFIFOL(sd->fd, len + 6) = SWAP32(bl->id);
	len += 4;

	if (tsd->status.settingFlags & FLAG_GROUP) {
		WFIFOB(sd->fd, len + 6) = 1;
	}
	else {
		WFIFOB(sd->fd, len + 6) = 0;
	}

	if (tsd->status.settingFlags & FLAG_EXCHANGE) {
		WFIFOB(sd->fd, len + 7) = 1;
	}
	else {
		WFIFOB(sd->fd, len + 7) = 0;
	}

	WFIFOB(sd->fd, len + 8) = 2 - tsd->status.sex;
	len += 3;

	WFIFOW(sd->fd, len + 6) = 0;
	len += 2;

	memcpy(WFIFOP(sd->fd, len + 6), tsd->profilepic_data, tsd->profilepic_size);
	len += tsd->profilepic_size;

	memcpy(WFIFOP(sd->fd, len + 6), tsd->profile_data, tsd->profile_size);
	len += tsd->profile_size;

	/*if(tsd->profile_size==0) {
		WFIFOW(sd->fd,len+6)=0;
		len+=2;
		WFIFOB(sd->fd,len+6)=0;
		len+=1;
		//WFIFOB(sd->fd,len+6)=0;
		//len+=1;
	} else {
		WFIFOB
		WFIFOB(sd->fd, len + 6) = tsd->profile_size;
		memcpy(WFIFOP(sd->fd, len + 7), tsd->profile_data, tsd->profile_size);
		len += tsd->profile_size + 1;
	}*/
	//WFIFOB(sd->fd,len+7)=0;

	/*WFIFOB(sd->fd,len+6)=strlen(tsd->profile_text);
	strcpy(WFIFOP(sd->fd,len+7),tsd->profile_text);

	len+=strlen(tsd->profile_text)+1;
	*/
	//WFIFOW(sd->fd,len+6)=0;

	for (x = 0; x < MAX_LEGENDS; x++) {
		if (strlen(tsd->status.legends[x].text) && strlen(tsd->status.legends[x].name)) {
			count++;
		}
	}

	WFIFOW(sd->fd, len + 6) = SWAP16(count);
	len += 2;

	for (x = 0; x < MAX_LEGENDS; x++) {
		if (strlen(tsd->status.legends[x].text) && strlen(tsd->status.legends[x].name)) {
			WFIFOB(sd->fd, len + 6) = tsd->status.legends[x].icon;
			WFIFOB(sd->fd, len + 7) = tsd->status.legends[x].color;

			if (tsd->status.legends[x].tchaid > 0) {
				char* name = clif_getName(tsd->status.legends[x].tchaid);
				char* buff = replace_str(&tsd->status.legends[x].text, "$player", name);

				WFIFOB(sd->fd, len + 8) = strlen(buff);
				memcpy(WFIFOP(sd->fd, len + 9), buff, strlen(buff));
				len += strlen(buff) + 3;
			}
			else {
				WFIFOB(sd->fd, len + 8) = strlen(tsd->status.legends[x].text);
				memcpy(WFIFOP(sd->fd, len + 9), tsd->status.legends[x].text, strlen(tsd->status.legends[x].text));
				len += strlen(tsd->status.legends[x].text) + 3;
			}
		}
	}

	WFIFOB(sd->fd, len + 6) = 3 - tsd->status.sex;

	if (clif_isregistered(tsd->status.id) > 0) WFIFOB(sd->fd, len + 7) = 1;
	else WFIFOB(sd->fd, len + 7) = 0;

	len += 5;

	WFIFOW(sd->fd, 1) = SWAP16(len + 3);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	sl_doscript_blargs("onClick", NULL, 2, &sd->bl, &tsd->bl);
	return 0;
}

int clif_groupstatus(USER* sd) {
	int x, n, w, r, m, p, a, g;
	int len = 0;
	int y;
	int count;
	char buf[32];
	int rogue[256];
	int warrior[256];
	int mage[256];
	int poet[256];
	int peasant[256];
	int gm[256];

	memset(rogue, 0, sizeof(int) * 256);
	memset(warrior, 0, sizeof(int) * 256);
	memset(mage, 0, sizeof(int) * 256);
	memset(poet, 0, sizeof(int) * 256);
	memset(peasant, 0, sizeof(int) * 256);
	memset(gm, 0, sizeof(int) * 256);

	USER* tsd = NULL;
	count = 0;
	//if(sd->group_count==1) sd->group_count==0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 1) = 0x00;
	WFIFOB(sd->fd, 3) = 0x63;
	WFIFOB(sd->fd, 5) = 2;
	WFIFOB(sd->fd, 6) = sd->group_count;

	for (x = 0, n = 0, w = 0, r = 0, m = 0, p = 0, g = 0; (n + w + r + m + p + g) < sd->group_count; x++) {
		tsd = map_id2sd(groups[sd->groupid][x]);
		if (!tsd)
			continue;

		// TNL TEST SHIT

		if (tsd->status.level < 99) {
			tsd->status.maxtnl = classdb_level(tsd->status.class, tsd->status.level);

			tsd->status.maxtnl -= classdb_level(tsd->status.class, tsd->status.level - 1);

			tsd->status.tnl = classdb_level(tsd->status.class, tsd->status.level) - (tsd->status.exp);

			tsd->status.percentage = (((float)(tsd->status.maxtnl - tsd->status.tnl) / tsd->status.maxtnl) * 100 + 0.5) + 0.5;
		}

		else { tsd->status.percentage = ((float)(tsd->status.exp / 4294967295) * 100) + 0.5; }

		tsd->status.intpercentage = (int)tsd->status.percentage;
		tsd->status.intpercentage = tsd->status.intpercentage;

		count++;

		switch (classdb_path(tsd->status.class)) {
		case 0:
			peasant[n] = groups[sd->groupid][x];
			n++;
			break;
		case 1:
			warrior[w] = groups[sd->groupid][x];
			w++;
			break;
		case 2:
			rogue[r] = groups[sd->groupid][x];
			r++;
			break;
		case 3:
			mage[m] = groups[sd->groupid][x];
			m++;
			break;
		case 4:
			poet[p] = groups[sd->groupid][x];
			p++;
			break;
		default:
			gm[g] = groups[sd->groupid][x];
			g++;
			break;
		}
	}

	for (x = 0, n = 0, w = 0, r = 0, m = 0, p = 0, g = 0; (n + w + r + m + p + g) < sd->group_count; x++) {
		if (rogue[r] != 0) {
			tsd = map_id2sd(rogue[r]);
			r++;
		}
		else if (warrior[w] != 0) {
			tsd = map_id2sd(warrior[w]);
			w++;
		}
		else if (mage[m] != 0) {
			tsd = map_id2sd(mage[m]);
			m++;
		}
		else if (poet[p] != 0) {
			tsd = map_id2sd(poet[p]);
			p++;
		}
		else if (peasant[n] != 0) {
			tsd = map_id2sd(peasant[n]);
			n++;
		}
		else if (gm[g] != 0) {
			tsd = map_id2sd(gm[g]);
			g++;
		}
		if (!tsd)
			continue;

		sprintf(buf, "%s", tsd->status.name);

		WFIFOL(sd->fd, len + 7) = SWAP32(tsd->bl.id);

		WFIFOB(sd->fd, len + 11) = strlen(buf);
		strcpy(WFIFOP(sd->fd, len + 12), buf);

		len += 11;
		len += strlen(buf) + 1;

		if (sd->group_leader == tsd->status.id) {
			WFIFOB(sd->fd, len) = 1;
		}
		else {
			WFIFOB(sd->fd, len) = 0;
		}

		WFIFOB(sd->fd, len + 1) = tsd->status.state; // 22
		WFIFOB(sd->fd, len + 2) = tsd->status.face;  //23
		WFIFOB(sd->fd, len + 3) = tsd->status.hair; //24
		WFIFOB(sd->fd, len + 4) = tsd->status.hair_color; //25
		WFIFOB(sd->fd, len + 5) = 0; // 26

		if (!pc_isequip(tsd, EQ_HELM) || !(tsd->status.settingFlags & FLAG_HELM) || (itemdb_look(pc_isequip(tsd, EQ_HELM)) == -1)) {
			//helm stuff goes here
			WFIFOB(sd->fd, len + 6) = 0; // supposed to be 1=Helm, 0=No helm
			WFIFOW(sd->fd, len + 7) = 0xFFFF; // supposed to be Helm num
			WFIFOB(sd->fd, len + 9) = 0;
		}
		else {
			WFIFOB(sd->fd, len + 6) = 1;

			if (tsd->status.equip[EQ_HELM].customLook != 0) {
				WFIFOW(sd->fd, len + 7) = SWAP16(tsd->status.equip[EQ_HELM].customLook);
				WFIFOB(sd->fd, len + 9) = tsd->status.equip[EQ_HELM].customLookColor;
			}
			else {
				WFIFOW(sd->fd, len + 7) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_HELM)));
				WFIFOB(sd->fd, len + 9) = itemdb_lookcolor(pc_isequip(tsd, EQ_HELM));
			}
		}

		if (!pc_isequip(tsd, EQ_FACEACC)) {
			//beard stuff
			WFIFOW(sd->fd, len + 10) = 0xFFFF;
			WFIFOB(sd->fd, len + 12) = 0x0;
		}
		else {
			WFIFOW(sd->fd, len + 10) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_FACEACC))); //beard num
			WFIFOB(sd->fd, len + 12) = itemdb_lookcolor(pc_isequip(tsd, EQ_FACEACC)); //beard color
		}

		if (!pc_isequip(tsd, EQ_CROWN)) {
			WFIFOW(sd->fd, len + 13) = 0xFFFF;
			WFIFOB(sd->fd, len + 15) = 0x0;
		}
		else {
			WFIFOB(sd->fd, len + 6) = 0;

			if (tsd->status.equip[EQ_CROWN].customLook != 0) {
				WFIFOW(sd->fd, len + 13) = SWAP16(tsd->status.equip[EQ_CROWN].customLook); //Crown
				WFIFOB(sd->fd, len + 15) = tsd->status.equip[EQ_CROWN].customLookColor; //Crown color
			}
			else {
				WFIFOW(sd->fd, len + 13) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_CROWN))); //Crown
				WFIFOB(sd->fd, len + 15) = itemdb_lookcolor(pc_isequip(tsd, EQ_CROWN)); //Crown color
			}
		}

		if (!pc_isequip(tsd, EQ_FACEACCTWO)) {
			WFIFOW(sd->fd, len + 16) = 0xFFFF; //second face acc
			WFIFOB(sd->fd, len + 18) = 0x0; //" color
		}
		else {
			WFIFOW(sd->fd, len + 16) = SWAP16(itemdb_look(pc_isequip(tsd, EQ_FACEACCTWO)));
			WFIFOB(sd->fd, len + 18) = itemdb_lookcolor(pc_isequip(tsd, EQ_FACEACCTWO));
		}

		len += 12; // 33

		WFIFOL(sd->fd, len + 7) = SWAP32(tsd->max_hp);
		len += 4; // 37
		WFIFOL(sd->fd, len + 7) = SWAP32(tsd->status.hp);
		len += 4; // 41
		WFIFOL(sd->fd, len + 7) = SWAP32(tsd->max_mp);
		len += 4; // 45
		WFIFOL(sd->fd, len + 7) = SWAP32(tsd->status.mp);
		len += 4; // 49
	}

	WFIFOB(sd->fd, 6) = sd->group_count;

	len += 6;

	WFIFOW(sd->fd, 1) = SWAP16(len + 3);

	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_grouphealth_update(USER* sd) {
	//clif_groupstatus(sd);

	/*
	// TNL TEST SHIT
	unsigned nextlevelxp, tnl;
	float percentage;
	int intpercentage;

	nextlevelxp=clif_getlvlxp(sd->status.level+1);

			//maxtnl-=clif_getlvlxp(99)-1;
	tnl=nextlevelxp-sd->status.exp;
	percentage=(((float)tnl/nextlevelxp)*100) + 0.5;
	intpercentage = (int)percentage;
	intpercentage = 100 - intpercentage;
	*/

	int x;
	int len;
	char buf[32];
	USER* tsd = NULL;

	for (x = 0; x < sd->group_count; x++) {
		len = 0;
		tsd = map_id2sd(groups[sd->groupid][x]);
		if (!tsd)
			continue;

		if (!session[sd->fd])
		{
			session[sd->fd]->eof = 8;
			return 0;
		}

		WFIFOHEAD(sd->fd, 512);
		WFIFOB(sd->fd, 0) = 0xAA;
		WFIFOB(sd->fd, 3) = 0x63;
		WFIFOB(sd->fd, 4) = 0x03;
		WFIFOB(sd->fd, 5) = 0x03;

		/*WFIFOB(sd->fd,6)=1;
		WFIFOB(sd->fd,7)=26;
		WFIFOB(sd->fd,8)=60;
		WFIFOB(sd->fd,9)=195;*/

		WFIFOL(sd->fd, 6) = SWAP32(tsd->bl.id);

		sprintf(buf, "%s", tsd->status.name);

		WFIFOB(sd->fd, 10) = strlen(buf);
		strcpy(WFIFOP(sd->fd, 11), buf);

		len += 10;
		len += strlen(buf) + 1;

		WFIFOL(sd->fd, len) = SWAP32(tsd->status.hp);
		len += 4;
		WFIFOL(sd->fd, len) = SWAP32(tsd->status.mp);
		len += 4;

		/*printf("packet sent: \n");
		for (int i=0; i<len+3;i++) {
		printf("%i ", WFIFOB(tsd->fd,i)); }
		printf("\n\n\n");*/

		WFIFOW(sd->fd, 1) = SWAP16(len + 3);
		WFIFOSET(sd->fd, encrypt(sd->fd));

		clif_groupstatus(sd);
	}

	return 0;
}

int clif_addgroup(USER* sd) {
	int x;
	char nameof[256];
	USER* tsd = NULL;
	int len = 0;
	char buff[256];
	memset(nameof, 0, 256);
	memcpy(nameof, RFIFOP(sd->fd, 6), RFIFOB(sd->fd, 5));

	nullpo_ret(0, tsd = map_name2sd(nameof));

	if (!sd->status.gm_level && tsd->optFlags & optFlag_stealth)return 0;

	if (tsd->status.id == sd->status.id) {
		clif_sendminitext(sd, "You can't group yourself...");
		return 0;
	}

	if (tsd->group_count) {
		if (tsd->group_leader == sd->group_leader && sd->group_leader == sd->bl.id) {
			clif_leavegroup(tsd);
			return 0;
		}
	}
	if (sd->group_count >= MAX_GROUP_MEMBERS) {
		clif_sendminitext(sd, "Your group is already full.");
		return 0;
	}
	if (tsd->status.state == 1) { // dead check. on NTK, a ghost is able to group others. But if you are alive, you are unable to add ghosts to your group
		clif_sendminitext(sd, "They are unable to join your party.");
		return 0;
	}

	if (!map[sd->bl.m].canGroup) {
		clif_sendminitext(sd, "You are unable to join a party. (Grouping disabled on map)");
		return 0;
	}
	if (!map[tsd->bl.m].canGroup) {
		clif_sendminitext(sd, "They are unable to join your party. (Grouping disabled on map)");
		return 0;
	}

	if (!(tsd->status.settingFlags & FLAG_GROUP)) {
		clif_sendminitext(sd, "They have refused to join your party.");
		return 0;
	}
	if (tsd->group_count != 0) {
		clif_sendminitext(sd, "They have refused to join your party.");
		return 0;
	}

	if (sd->group_count == 0) {
		for (x = 1; x < MAX_GROUPS; x++) {
			if (groups[x][0] == 0) {
				break;
			}
		}

		if (x == MAX_GROUPS)
		{
			clif_sendminitext(sd, "All groups are currently occupied, please try again later.");
			return 0;
		}

		groups[x][0] = sd->status.id;
		sd->group_leader = groups[x][0];
		groups[x][1] = tsd->status.id;
		sd->group_count = 2;
		sd->groupid = x;
		tsd->groupid = sd->groupid;
	}
	else {
		groups[sd->groupid][sd->group_count] = tsd->status.id;
		sd->group_count++;
		tsd->groupid = sd->groupid;
	}

	len = sprintf(buff, "%s is joining the group.", tsd->status.name);

	clif_updategroup(sd, buff);

	clif_groupstatus(sd);

	return 0;
}

int clif_updategroup(USER* sd, char* message) {
	int x, y;

	int len = 0;

	USER* tsd;

	for (x = 0; x < sd->group_count; x++) {
		tsd = map_id2sd(groups[sd->groupid][x]);

		if (!tsd)
			continue;

		tsd->group_count = sd->group_count;
		tsd->group_leader = sd->group_leader;
		//tsd->status.settingFlags^=FLAG_GROUP;
		//tsd->group_on=0;
		//for (y = 0; y < sd->group_count; y++) {
		//	groups[tsd->groupid][y] = groups[sd->groupid][y];
		//}
		if (tsd->group_count == 1) {
			groups[sd->groupid][0] = 0;
			tsd->group_count = 0;
			tsd->groupid = 0;
		}
		clif_sendminitext(tsd, message);
		clif_grouphealth_update(tsd);
		clif_groupstatus(tsd);
	}

	return 0;
}

int clif_leavegroup(USER* sd) {
	int x;
	int taken = 0;
	char buff[256];

	for (x = 0; x < sd->group_count; x++) {
		if (taken == 1) {
			groups[sd->groupid][x - 1] = groups[sd->groupid][x];
		}
		else {
			if (groups[sd->groupid][x] == sd->status.id) {
				groups[sd->groupid][x] = 0;
				taken = 1;
				if (sd->group_leader == sd->status.id) {
					sd->group_leader = groups[sd->groupid][0];
				}
			}
		}
	}

	if (sd->group_leader == 0) {
		sd->group_leader = groups[sd->groupid][0];
	}

	sprintf(buff, "%s is leaving the group.", sd->status.name);
	sd->group_count--;
	clif_updategroup(sd, buff);
	sprintf(buff, "You have left the group.");
	clif_sendminitext(sd, buff);

	// Your group has disbanded
	// Name has taken command of the group.

	sd->group_count = 0;
	sd->groupid = 0;
	clif_groupstatus(sd);
}
int clif_findmount(USER* sd) {
	struct block_list* bl = NULL;
	MOB* mob = NULL;
	int x = sd->bl.x;
	int y = sd->bl.y;

	switch (sd->status.side) {
	case 0: //up
		y = sd->bl.y - 1;
		break;
	case 1: //right
		x = sd->bl.x + 1;
		break;
	case 2: //down
		y = sd->bl.y + 1;
		break;
	case 3: //left
		x = sd->bl.x - 1;
		break;
	}

	bl = map_firstincell(sd->bl.m, x, y, BL_MOB);

	if (!bl) return 0;

	mob = (MOB*)bl;

	if (sd->status.state != 0) return 0;
	if (!map[sd->bl.m].canMount && !sd->status.gm_level) { clif_sendminitext(sd, "You cannot mount here."); return 0; }

	sl_doscript_blargs("onMount", NULL, 2, &sd->bl, &mob->bl);
	//sl_doscript_blargs(mob->data->yname, "on_mount", 2, &sd->bl, &mob->bl);
	return 0;
}
int clif_object_canmove(int m, int x, int y, int side) {
	int object = read_obj(m, x, y);
	unsigned char flag = objectFlags[object];
	/*struct block_list *bl=NULL;
	struct map_sessiondata *tsd=NULL;

	bl = map_id2bl(object);
	if(bl->type == BL_PC) {
		tsd = map_id2sd(object);
	}*/

	switch (side) {
	case 0: //heading NORTH
		if (flag & OBJ_UP)// || tsd->optFlags&optFlag_stealth)
			return 1;
		break;
	case 1: //RIGHT
		if (flag & OBJ_RIGHT)// || tsd->optFlags&optFlag_stealth)
			return 1;
		break;
	case 2: //DOWN
		if (flag & OBJ_DOWN)// || tsd->optFlags&optFlag_stealth)
			return 1;
		break;
	case 3: //LEFT
		if (flag & OBJ_LEFT)// || tsd->optFlags&optFlag_stealth)
			return 1;
		break;
	}

	return 0;
}
int clif_object_canmove_from(int m, int x, int y, int side) {
	int object = read_obj(m, x, y);
	unsigned char flag = objectFlags[object];

	switch (side) {
	case 0: //heading NORTH
		if (flag & OBJ_DOWN)
			return 1;
		break;
	case 1: //RIGHT
		if (flag & OBJ_LEFT)
			return 1;
		break;
	case 2: //DOWN
		if (flag & OBJ_UP)
			return 1;
		break;
	case 3: //LEFT
		if (flag & OBJ_RIGHT)
			return 1;
		break;
	}

	return 0;
}
int clif_changestatus(USER* sd, int type) {
	int oldm, oldx, oldy;
	char buff[256];

	switch (type) {
	case 0x00: //Ride/something else
		if (RFIFOB(sd->fd, 7) == 1) {
			if (sd->status.state == 0) {
				clif_findmount(sd);

				if (sd->status.state == 0) clif_sendminitext(sd, "Good try, but there is nothing here that you can ride.");
			}
			else if (sd->status.state == 1) {
				clif_sendminitext(sd, "Spirits can't do that.");
			}
			else if (sd->status.state == 2) {
				clif_sendminitext(sd, "Good try, but there is nothing here that you can ride.");
			}
			else if (sd->status.state == 3) {
				sl_doscript_blargs("onDismount", NULL, 1, &sd->bl);
			}
			else if (sd->status.state == 4) {
				clif_sendminitext(sd, "You cannot do that while transformed.");
			}
		}
		break;

	case 0x01: //Whisper (F5)
		sd->status.settingFlags ^= FLAG_WHISPER;

		//sd->optFlags ^= optFlag_nowhisp;
		if (sd->status.settingFlags & FLAG_WHISPER) {
			clif_sendminitext(sd, "Listen to whisper:ON");
		}
		else {
			clif_sendminitext(sd, "Listen to whisper:OFF");
		}
		clif_sendstatus(sd, NULL);
		break;
	case 0x02: //group
		sd->status.settingFlags ^= FLAG_GROUP;

		if (sd->status.settingFlags & FLAG_GROUP) {
			sprintf(buff, "Join a group     :ON");
		}
		else {
			if (sd->group_count > 0) {
				clif_leavegroup(sd);
			}

			sprintf(buff, "Join a group     :OFF");
		}

		clif_sendstatus(sd, NULL);
		clif_sendminitext(sd, buff);
		break;
	case 0x03: //Shout
		sd->status.settingFlags ^= FLAG_SHOUT;
		if (sd->status.settingFlags & FLAG_SHOUT) {
			clif_sendminitext(sd, "Listen to shout  :ON");
		}
		else {
			clif_sendminitext(sd, "Listen to shout  :OFF");
		}
		clif_sendstatus(sd, NULL);
		break;
	case 0x04: //Advice
		sd->status.settingFlags ^= FLAG_ADVICE;
		if (sd->status.settingFlags & FLAG_ADVICE) {
			clif_sendminitext(sd, "Listen to advice :ON");
		}
		else {
			clif_sendminitext(sd, "Listen to advice :OFF");
		}
		clif_sendstatus(sd, NULL);
		break;
	case 0x05: //Magic
		sd->status.settingFlags ^= FLAG_MAGIC;
		if (sd->status.settingFlags & FLAG_MAGIC) {
			clif_sendminitext(sd, "Believe in magic :ON");
		}
		else {
			clif_sendminitext(sd, "Believe in magic :OFF");
		}
		clif_sendstatus(sd, NULL);
		break;
	case 0x06: //Weather
		sd->status.settingFlags ^= FLAG_WEATHER;
		if (sd->status.settingFlags & FLAG_WEATHER) {
			sprintf(buff, "Weather change   :ON");
		}
		else {
			sprintf(buff, "Weather change   :OFF");
		}
		clif_sendminitext(sd, buff);

		clif_sendweather(sd);
		clif_sendstatus(sd, NULL);
		break;
	case 0x07: //Realm center (F4)
		oldm = sd->bl.m;
		oldx = sd->bl.x;
		oldy = sd->bl.y;
		sd->status.settingFlags ^= FLAG_REALM;
		clif_quit(sd);
		clif_sendmapinfo(sd);
		pc_setpos(sd, oldm, oldx, oldy);
		clif_sendmapinfo(sd);
		clif_spawn(sd);
		clif_mob_look_start(sd);
		map_foreachinarea(clif_object_look_sub, sd->bl.m, sd->bl.x, sd->bl.y, SAMEAREA, BL_ALL, LOOK_GET, sd);
		clif_mob_look_close(sd);
		clif_destroyold(sd);
		clif_sendchararea(sd);
		clif_getchararea(sd);

		if (sd->status.settingFlags & FLAG_REALM) {
			clif_sendminitext(sd, "Realm-centered   :ON");
		}
		else {
			clif_sendminitext(sd, "Realm-centered   :OFF");
		}
		clif_sendstatus(sd, NULL);
		break;
	case 0x08: //exchange
		sd->status.settingFlags ^= FLAG_EXCHANGE;
		//sd->exchange_on^=1;

		if (sd->status.settingFlags & FLAG_EXCHANGE) {
			sprintf(buff, "Exchange         :ON");
		}
		else {
			sprintf(buff, "Exchange         :OFF");
		}

		clif_sendstatus(sd, NULL);
		clif_sendminitext(sd, buff);
		break;
	case 0x09: //Fast move
		sd->status.settingFlags ^= FLAG_FASTMOVE;

		if (sd->status.settingFlags & FLAG_FASTMOVE) {
			clif_sendminitext(sd, "Fast Move        :ON");
		}
		else {
			clif_sendminitext(sd, "Fast Move        :OFF");
		}
		clif_sendstatus(sd, NULL);
		break;
	case 10: //Clan chat
		sd->status.clan_chat = (sd->status.clan_chat + 1) % 2;
		if (sd->status.clan_chat) {
			clif_sendminitext(sd, "Clan whisper     :ON");
		}
		else {
			clif_sendminitext(sd, "Clan whisper     :OFF");
		}
		break;
	case 13: //Sound
		if (RFIFOB(sd->fd, 4) == 3) return 0; //just started so dont do anything
		sd->status.settingFlags ^= FLAG_SOUND;
		if (sd->status.settingFlags & FLAG_SOUND) {
			sprintf(buff, "Hear sounds      :ON");
		}
		else {
			sprintf(buff, "Hear sounds      :OFF");
		}
		clif_sendminitext(sd, buff);
		clif_sendstatus(sd, NULL);
		break;

	case 14: //Helm
		//sd->status.show_helm=(sd->status.s6=how_helm+1)%2;
		sd->status.settingFlags ^= FLAG_HELM;
		if (sd->status.settingFlags & FLAG_HELM) {
			clif_sendminitext(sd, "Show Helmet      :ON");
			pc_setglobalreg(sd, "show_helmet", 1);			//Added 4/6/17 to give registry for helmet status
		}
		else {
			clif_sendminitext(sd, "Show Helmet      :OFF");
			pc_setglobalreg(sd, "show_helmet", 0);          //Added 4/6/17 to give registry for helmet status
		}
		clif_sendstatus(sd, NULL);
		clif_sendchararea(sd);
		clif_getchararea(sd);
		//map_foreachinarea(clif_updatestate,sd->bl.m,sd->bl.x,sd->bl.y,AREA,BL_PC,sd); // was commented
		break;

	case 15: //Necklace
				//sd->status.show_necklace=(sd->status.s6=how_neck+1)%2;
		sd->status.settingFlags ^= FLAG_NECKLACE;
		if (sd->status.settingFlags & FLAG_NECKLACE) {
			clif_sendminitext(sd, "Show Necklace      :ON");
			pc_setglobalreg(sd, "show_necklace", 1);                  //Added 4/6/17 to give registry for helmet status
		}
		else {
			clif_sendminitext(sd, "Show Necklace      :OFF");
			pc_setglobalreg(sd, "show_necklace", 0);          //Added 4/6/17 to give registry for helmet status
		}
		clif_sendstatus(sd, NULL);
		clif_sendchararea(sd);
		clif_getchararea(sd);
		//map_foreachinarea(clif_updatestate,sd->bl.m,sd->bl.x,sd->bl.y,AREA,BL_PC,sd); // was commented
		break;

	default:
		break;
	}

	return 0;
}

int clif_handgold(USER* sd) {
	char buff[256];

	/*int len = SWAP16(RFIFOW(sd->fd,1));

	printf("Hand Gold packet\n");
	for(int i = 0;i<len;i++) {
	printf("%02X ",RFIFOB(sd->fd,i));
	}
	printf("\n");
	for(int i = 0;i<len;i++) {
	printf("%i ",RFIFOB(sd->fd,i));
	}
	printf("\n");
	for(int i = 0;i<len;i++) {
	printf("%c ",RFIFOB(sd->fd,i));
	}
	printf("\n");*/

	unsigned int gold = SWAP32(RFIFOL(sd->fd, 5));

	if (gold < 0) gold = 0;
	if (gold == 0) return 0;
	if (gold > sd->status.money) gold = sd->status.money;

	int x = 0;
	int y = 0;

	if (sd->status.side == 0) { x = sd->bl.x, y = sd->bl.y - 1; }
	if (sd->status.side == 1) { x = sd->bl.x + 1, y = sd->bl.y; }
	if (sd->status.side == 2) { x = sd->bl.x; y = sd->bl.y + 1; }
	if (sd->status.side == 3) { x = sd->bl.x - 1; y = sd->bl.y; }

	struct block_list* bl = NULL;

	bl = map_firstincell(sd->bl.m, x, y, BL_ALL);
	USER* tsd = NULL;

	sd->exchange.gold = gold;

	sprintf(buff, "They have refused to exchange with you");

	if (bl != NULL) {
		if (bl->type == BL_PC) {
			tsd = map_id2sd(bl->id);

			if (tsd->status.settingFlags & FLAG_EXCHANGE) {
				clif_startexchange(sd, bl->id);
				clif_exchange_money(sd, tsd);
			}
			else clif_sendminitext(sd, buff);
		}
	}

	return 0;
}

int clif_postitem(USER* sd) {
	struct item_data* item = NULL;

	int slot = RFIFOB(sd->fd, 5) - 1;

	item = itemdb_search(sd->status.inventory[slot].id);

	int x = 0;
	int y = 0;

	if (sd->status.side == 0) { x = sd->bl.x, y = sd->bl.y - 1; }
	if (sd->status.side == 1) { x = sd->bl.x + 1, y = sd->bl.y; }
	if (sd->status.side == 2) { x = sd->bl.x; y = sd->bl.y + 1; }
	if (sd->status.side == 3) { x = sd->bl.x - 1; y = sd->bl.y; }

	if (x < 0 || y < 0) return 0;

	int obj = read_obj(sd->bl.m, x, y);

	if (obj == 1619 || obj == 1620) { //board object
		if (sd->status.inventory[slot].amount > 1)
			clif_input(sd, sd->last_click, "How many would you like to post?", "");
	}

	//printf("Slot: %i\n",slot);

	//printf("item to post: %s\n",item->name);

	sd->invslot = slot;

	/*printf("packet 34 received\n");
	for (int i = 0; i < SWAP16(RFIFOW(sd->fd,1));i++) {
		printf("%02X ",RFIFOB(sd->fd,i));
	}
	printf("\n");*/

	return 0;
}

int clif_handitem(USER* sd) {
	struct mobdb_data* db;

	char buff[256];

	int slot = RFIFOB(sd->fd, 5) - 1;
	int handgive = RFIFOB(sd->fd, 6); // hand (h) = 0, give (H) = 1
	int amount = 0;

	int itemid = sd->status.inventory[slot].id;

	if (handgive == 0) amount = 1;
	else if (handgive == 1) amount = sd->status.inventory[slot].amount;

	int x = 0;
	int y = 0;

	if (sd->status.side == 0) { x = sd->bl.x, y = sd->bl.y - 1; }
	if (sd->status.side == 1) { x = sd->bl.x + 1, y = sd->bl.y; }
	if (sd->status.side == 2) { x = sd->bl.x; y = sd->bl.y + 1; }
	if (sd->status.side == 3) { x = sd->bl.x - 1; y = sd->bl.y; }

	struct block_list* bl = NULL;
	struct item_data* item = NULL;
	char msg[80];
	char* buf;
	struct npc_data* nd = NULL;

	bl = map_firstincell(sd->bl.m, x, y, BL_ALL);
	USER* tsd = NULL;
	MOB* mob = NULL;

	sprintf(buff, "They have refused to exchange with you");

	//printf("Slot: %i\n",slot);
	//printf("name: %s\n",itemdb_name(sd->status.inventory[slot].id));

	sd->invslot = slot;

	if (bl != NULL) {
		if (bl->type == BL_PC) {//printf("block id: %i\n",bl->id);
			tsd = map_id2sd(bl->id);

			if (tsd->status.settingFlags & FLAG_EXCHANGE) {
				clif_startexchange(sd, bl->id);
				clif_exchange_additem(sd, tsd, slot, amount);
			}
			else clif_sendminitext(sd, buff);
		}
		if (bl->type == BL_MOB) {
			mob = (MOB*)map_id2mob(bl->id);

			if (itemdb_exchangeable(sd->status.inventory[slot].id) == 1) return 0;

			for (int i = 0; i < MAX_INVENTORY; i++) {
				if (mob->inventory[i].id == sd->status.inventory[slot].id && mob->inventory[i].dura == sd->status.inventory[slot].dura && mob->inventory[i].owner == sd->status.inventory[slot].owner && mob->inventory[i].protected == sd->status.inventory[slot].protected) {
					mob->inventory[i].amount += amount;
					break;
				}
				else if (mob->inventory[i].id == 0) {
					mob->inventory[i].id = sd->status.inventory[slot].id;
					mob->inventory[i].amount = amount;
					mob->inventory[i].owner = sd->status.inventory[slot].owner;
					mob->inventory[i].dura = sd->status.inventory[slot].dura;
					mob->inventory[i].protected = sd->status.inventory[slot].protected;
					break;
				}
			}

			pc_delitem(sd, slot, amount, 9);
		}
		if (bl->type == BL_NPC) {
			//item = itemdb_search(sd->status.inventory[slot].id);
			nd = map_id2npc((unsigned int)bl->id);

			if (itemdb_exchangeable(sd->status.inventory[slot].id) || itemdb_droppable(sd->status.inventory[slot].id)) return 0;

			if (nd->receiveItem == 1)
				sl_doscript_blargs(nd->name, "handItem", 2, &sd->bl, &nd->bl);
			else {
				sprintf(msg, "What are you trying to do? Keep your junky %s with you!", itemdb_name(sd->status.inventory[slot].id));
				//printf("string: %s\n",msg);

				WFIFOHEAD(sd->fd, strlen(msg) + 11);
				WFIFOB(sd->fd, 5) = 0;
				WFIFOL(sd->fd, 6) = SWAP32((unsigned int)bl->id);
				WFIFOB(sd->fd, 10) = strlen(msg);
				strcpy(WFIFOP(sd->fd, 11), msg);

				WFIFOHEADER(sd->fd, 0x0D, strlen(msg) + 11);
				WFIFOSET(sd->fd, encrypt(sd->fd));
			}
		}
	}

	return 0;
}

//adjust for item struct
int clif_parse_exchange(USER* sd) {
	int type = RFIFOB(sd->fd, 5);
	int id;
	unsigned int amount;
	USER* tsd = NULL;

	char RegStr[] = "goldbardupe";
	int DupeTimes = pc_readglobalreg(sd, RegStr);
	if (DupeTimes)
	{
		//char minibuf[]="Character under quarentine.";
		//clif_sendminitext(sd,minibuf);
		//return 0;
	}

	switch (type) {
	case 0: //this is a "initiation", so we do this
		tsd = map_id2sd(SWAP32(RFIFOL(sd->fd, 6)));
		if (!tsd || sd->bl.m != tsd->bl.m || tsd->bl.type != BL_PC) return 0;
		if (sd->status.gm_level || !(tsd->optFlags & optFlag_stealth))
			clif_startexchange(sd, SWAP32(RFIFOL(sd->fd, 6)));
		break;
	case 1: //amount?
		id = RFIFOB(sd->fd, 10) - 1;
		if (sd->status.inventory[id].amount > 1) {
			if (!session[sd->fd])
			{
				session[sd->fd]->eof = 8;
				return 0;
			}

			WFIFOHEAD(sd->fd, 7);
			WFIFOB(sd->fd, 0) = 0xAA;
			WFIFOW(sd->fd, 1) = SWAP16(4);
			WFIFOB(sd->fd, 3) = 0x42;
			WFIFOB(sd->fd, 4) = 0x03;
			WFIFOB(sd->fd, 5) = 0x01;
			WFIFOB(sd->fd, 6) = id + 1;
			WFIFOSET(sd->fd, encrypt(sd->fd));
		}
		else if (sd->status.inventory[id].id) {
			tsd = map_id2sd(SWAP32(RFIFOL(sd->fd, 6)));
			clif_exchange_additem(sd, tsd, id, 1);
		}
		else //clif_Hacker(sd->status.name, "Attempted to exchange-hack-add a blank slot");
			break;
	case 2: //after ask amount
		id = RFIFOB(sd->fd, 10) - 1;
		amount = RFIFOB(sd->fd, 11);
		tsd = map_id2sd(SWAP32(RFIFOL(sd->fd, 6)));
		if (amount > 0 && (sd->status.inventory[id].id && amount <= sd->status.inventory[id].amount)) {
			clif_exchange_additem(sd, tsd, id, amount);
		}
		else if (!sd->status.inventory[id].id || amount == 0) {
			//clif_Hacker(sd->status.name, "Attempted to exchange-hack-add a blank slot");
		}
		break;
	case 3: //exchanging gold
		tsd = map_id2sd(SWAP32(RFIFOL(sd->fd, 6)));
		amount = SWAP32(RFIFOL(sd->fd, 10));

		if (amount > sd->status.money) {
			clif_exchange_money(sd, tsd);
		}
		else {
			sd->exchange.gold = amount;
			clif_exchange_money(sd, tsd);
		}
		break;

	case 4: //Quit exchange
		tsd = map_id2sd(SWAP32(RFIFOL(sd->fd, 6)));
		clif_exchange_message(sd, "Exchange cancelled.", 4, 0);
		if (tsd) clif_exchange_message(tsd, "Exchange cancelled.", 4, 0);
		clif_exchange_close(sd);
		clif_exchange_close(tsd);
		break;
	case 5: //Finish exchange

		tsd = map_id2sd(SWAP32(RFIFOL(sd->fd, 6)));
		if (sd->exchange.target != SWAP32(RFIFOL(sd->fd, 6))) {
			clif_exchange_close(sd);
			clif_exchange_message(sd, "Exchange cancelled.", 4, 0);
			if (tsd && tsd->exchange.target == sd->bl.id) {
				clif_exchange_message(tsd, "Exchange cancelled.", 4, 0);
				clif_exchange_close(tsd);
				session[sd->fd]->eof = 10;
				break;
			}
			//clif_exchange_close(tsd);
		}
		if (sd->exchange.gold > sd->status.money) {
			clif_exchange_message(sd, "You do not have that amount.", 4, 0);
			clif_exchange_message(tsd, "Exchange cancelled.", 4, 0);
			clif_exchange_close(sd);
			clif_exchange_close(tsd);
		}
		else
			if (tsd) { clif_exchange_sendok(sd, tsd); }
			else { clif_exchange_close(sd); }

		break;

	default:
		break;
	}
	return 0;
}

int clif_startexchange(USER* sd, unsigned int target) {
	int len = 0;
	char buff[256];
	USER* tsd = map_id2sd(target);
	nullpo_ret(0, sd);

	if (target == sd->bl.id) {
		sprintf(buff, "You move your items from one hand to another, but quickly get bored.");
		clif_sendminitext(sd, buff);
		return 0;
	}

	if (!tsd) return 0;

	sd->exchange.target = target;
	tsd->exchange.target = sd->bl.id;

	if (tsd->status.settingFlags & FLAG_EXCHANGE) {
		if (classdb_name(tsd->status.class, tsd->status.mark)) {
			sprintf(buff, "%s(%s)", tsd->status.name, classdb_name(tsd->status.class, tsd->status.mark));
		}
		else {
			sprintf(buff, "%s()", tsd->status.name);
		}

		if (!session[sd->fd])
		{
			session[sd->fd]->eof = 8;
			return 0;
		}

		WFIFOHEAD(sd->fd, 512);
		WFIFOB(sd->fd, 0) = 0xAA;
		WFIFOB(sd->fd, 3) = 0x42;
		WFIFOB(sd->fd, 4) = 0x03;
		WFIFOB(sd->fd, 5) = 0x00;
		WFIFOL(sd->fd, 6) = SWAP32(tsd->bl.id);
		len = 4;
		WFIFOB(sd->fd, len + 6) = strlen(buff);
		strcpy(WFIFOP(sd->fd, len + 7), buff);
		len += strlen(buff) + 1;
		WFIFOW(sd->fd, len + 6) = SWAP16(tsd->status.level);
		len += 2;

		WFIFOW(sd->fd, 1) = SWAP16(len + 3);
		WFIFOSET(sd->fd, encrypt(sd->fd));

		if (!session[sd->fd])
		{
			session[sd->fd]->eof = 8;
			return 0;
		}

		WFIFOHEAD(tsd->fd, 512);

		if (classdb_name(sd->status.class, sd->status.mark)) {
			sprintf(buff, "%s(%s)", sd->status.name, classdb_name(sd->status.class, sd->status.mark));
		}
		else {
			sprintf(buff, "%s()", sd->status.name);
		}

		WFIFOB(tsd->fd, 0) = 0xAA;
		WFIFOB(tsd->fd, 3) = 0x42;
		WFIFOB(tsd->fd, 4) = 0x03;
		WFIFOB(tsd->fd, 5) = 0x00;
		WFIFOL(tsd->fd, 6) = SWAP32(sd->bl.id);
		len = 4;
		WFIFOB(tsd->fd, len + 6) = strlen(buff);
		strcpy(WFIFOP(tsd->fd, len + 7), buff);
		len += strlen(buff) + 1;
		WFIFOW(tsd->fd, len + 6) = SWAP16(sd->status.level);
		len += 2;

		WFIFOW(tsd->fd, 1) = SWAP16(len + 3);
		WFIFOSET(tsd->fd, encrypt(tsd->fd));
		sd->status.settingFlags ^= FLAG_EXCHANGE;
		tsd->status.settingFlags ^= FLAG_EXCHANGE;

		sd->exchange.item_count = 0;
		tsd->exchange.item_count = 0;
		sd->exchange.list_count = 0;
		tsd->exchange.list_count = 1;
	}
	else {
		sprintf(buff, "They have refused to exchange with you");
		clif_sendminitext(sd, buff);
	}

	return 0;
}
int clif_exchange_additem_else(USER* sd, USER* tsd, int id) {
	int len = 0;
	char buff[256];
	int i;
	float percentage;
	char nameof[255];
	if (!sd) return 0;
	if (!tsd) return 0;
	sprintf(nameof, "%s", sd->exchange.item[sd->exchange.item_count - 1].real_name);
	sd->exchange.list_count++;
	stringTruncate(nameof, 15);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 2000);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x42;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0x02;
	WFIFOB(sd->fd, 6) = 0x00;
	WFIFOB(sd->fd, 7) = sd->exchange.list_count;
	len = 0;
	i = sd->exchange.item_count;

	sprintf(buff, "%s", nameof);
	WFIFOW(sd->fd, len + 8) = 0xFFFF;
	WFIFOB(sd->fd, len + 10) = 0x00;
	WFIFOB(sd->fd, len + 11) = strlen(buff);
	strcpy(WFIFOP(sd->fd, len + 12), buff);
	len += strlen(buff) + 5;

	WFIFOW(sd->fd, 1) = SWAP16(len + 5);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	len = 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(tsd->fd, 2000);
	WFIFOB(tsd->fd, 0) = 0xAA;
	WFIFOB(tsd->fd, 3) = 0x42;
	WFIFOB(tsd->fd, 4) = 0x03;
	WFIFOB(tsd->fd, 5) = 0x02;
	WFIFOB(tsd->fd, 6) = 0x01;
	WFIFOB(tsd->fd, 7) = sd->exchange.list_count;

	sprintf(buff, "%s", nameof);
	WFIFOW(tsd->fd, 8) = 0xFFFF;
	WFIFOB(tsd->fd, 10) = 0;
	WFIFOB(tsd->fd, 11) = strlen(buff);
	strcpy(WFIFOP(tsd->fd, 12), buff);
	len += strlen(buff) + 1;
	WFIFOW(tsd->fd, 1) = SWAP16(len + 8);
	WFIFOSET(tsd->fd, encrypt(tsd->fd));

	return 0;
}

int clif_exchange_additem(USER* sd, USER* tsd, int id, int amount) {
	int len = 0;
	char buff[256];
	int i;
	float percentage;
	char nameof[255];
	if (!sd) return 0;
	if (!tsd) return 0;

	if (sd->status.inventory[id].id) {
		if (itemdb_exchangeable(sd->status.inventory[id].id)) {
			clif_sendminitext(sd, "You cannot exchange that.");
			return 0;
		}
	}

	/*if(pc_isinvenspace(sd, id, owner, engrave, customLook, customLookColor, customIcon, customIconColor) >= sd->status.maxinv) {
		lua_pushboolean(state, 0);
		return 1;
	}*/

	if (pc_isinvenspace(tsd, sd->status.inventory[id].id, sd->status.inventory[id].owner, sd->status.inventory[id].real_name, sd->status.inventory[id].customLook, sd->status.inventory[id].customLookColor, sd->status.inventory[id].customIcon, sd->status.inventory[id].customIconColor) >= tsd->status.maxinv) {
		clif_sendminitext(sd, "Receiving player does not have enough inventory space.");
		return 0;
	}

	sd->exchange.item[sd->exchange.item_count] = sd->status.inventory[id];
	sd->exchange.item[sd->exchange.item_count].amount = amount;
	sprintf(nameof, "%s", itemdb_name(sd->exchange.item[sd->exchange.item_count].id));
	sd->exchange.list_count++;
	stringTruncate(nameof, 15);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 2000);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x42;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0x02;
	WFIFOB(sd->fd, 6) = 0x00;
	WFIFOB(sd->fd, 7) = sd->exchange.list_count;
	len = 0;
	i = sd->exchange.item_count;

	if (amount > 1) {
		sprintf(buff, "%s(%d)", nameof, amount);
	}
	else {
		sprintf(buff, "%s", nameof);
	}

	if (itemdb_type(sd->exchange.item[i].id) > 2 && itemdb_type(sd->exchange.item[i].id) < 17) {
		percentage = ((float)sd->exchange.item[i].dura / itemdb_dura(sd->exchange.item[i].id)) * 100;
		sprintf(buff, "%s (%d%%)", nameof, (int)percentage);
	}
	else if (itemdb_type(sd->exchange.item[i].id) == ITM_SMOKE) {
		sprintf(buff, "%s [%d %s]", nameof, sd->exchange.item[i].dura, itemdb_text(sd->exchange.item[i].id));
	}
	else if (itemdb_type(sd->exchange.item[i].id) == ITM_BAG) {
		sprintf(buff, "%s [%d]", nameof, sd->exchange.item[i].dura);
	}
	else if (itemdb_type(sd->exchange.item[i].id) == ITM_MAP) {
		sprintf(buff, "[T%d] %s", sd->exchange.item[i].dura, nameof);
	}
	else if (itemdb_type(sd->exchange.item[i].id) == ITM_QUIVER) {
		sprintf(buff, "%s [%d]", nameof, sd->exchange.item[i].dura);
	}

	if (sd->exchange.item[i].customIcon != 0) {
		WFIFOW(sd->fd, len + 8) = SWAP16(sd->exchange.item[i].customIcon + 49152);
		WFIFOB(sd->fd, len + 10) = sd->exchange.item[i].customIconColor;
	}
	else {
		WFIFOW(sd->fd, len + 8) = SWAP16(itemdb_icon(sd->exchange.item[i].id));
		WFIFOB(sd->fd, len + 10) = itemdb_iconcolor(sd->exchange.item[i].id);
	}

	WFIFOB(sd->fd, len + 11) = strlen(buff);
	strcpy(WFIFOP(sd->fd, len + 12), buff);
	len += strlen(buff) + 5;

	WFIFOW(sd->fd, 1) = SWAP16(len + 5);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	len = 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(tsd->fd, 2000);
	WFIFOB(tsd->fd, 0) = 0xAA;
	WFIFOB(tsd->fd, 3) = 0x42;
	WFIFOB(tsd->fd, 4) = 0x03;
	WFIFOB(tsd->fd, 5) = 0x02;
	WFIFOB(tsd->fd, 6) = 0x01;
	WFIFOB(tsd->fd, 7) = sd->exchange.list_count;

	if (amount > 1) {
		sprintf(buff, "%s (%d)", nameof, amount);
	}
	else {
		sprintf(buff, "%s", nameof);
	}
	if (itemdb_type(sd->exchange.item[i].id) > 2 && itemdb_type(sd->exchange.item[i].id) < 17) {
		//if(!sd->exchange.item[i].custom) {
		percentage = ((float)sd->exchange.item[i].dura / itemdb_dura(sd->exchange.item[i].id)) * 100;
		//} else {
		//	percentage=((float)sd->exchange.item[i].dura / itemdb_durac(sd->exchange.item[i].custom))*100;
		//}
		sprintf(buff, "%s (%d%%)", nameof, (int)percentage);
	}
	else if (itemdb_type(sd->exchange.item[i].id) == ITM_SMOKE) {
		sprintf(buff, "%s [%d %s]", nameof, sd->exchange.item[i].dura, itemdb_text(sd->exchange.item[i].id));
	}
	else if (itemdb_type(sd->exchange.item[i].id) == ITM_BAG) {
		sprintf(buff, "%s [%d]", nameof, sd->exchange.item[i].dura);
	}
	else if (itemdb_type(sd->exchange.item[i].id) == ITM_MAP) {
		sprintf(buff, "[T%d] %s", sd->exchange.item[i].dura, nameof);
	}
	else if (itemdb_type(sd->exchange.item[i].id) == ITM_QUIVER) {
		sprintf(buff, "%s [%d]", nameof, sd->exchange.item[i].dura);
	}

	if (sd->exchange.item[i].customIcon != 0) {
		WFIFOW(tsd->fd, 8) = SWAP16(sd->exchange.item[i].customIcon + 49152);
		WFIFOB(tsd->fd, 10) = sd->exchange.item[i].customIconColor;
	}
	else {
		WFIFOW(tsd->fd, 8) = SWAP16(itemdb_icon(sd->exchange.item[i].id));
		WFIFOB(tsd->fd, 10) = itemdb_iconcolor(sd->exchange.item[i].id);
	}

	WFIFOB(tsd->fd, 11) = strlen(buff);
	strcpy(WFIFOP(tsd->fd, 12), buff);
	len += strlen(buff) + 1;
	WFIFOW(tsd->fd, 1) = SWAP16(len + 8);
	WFIFOSET(tsd->fd, encrypt(tsd->fd));

	sd->exchange.item_count++;
	if (strlen(sd->exchange.item[i].real_name)) {
		clif_exchange_additem_else(sd, tsd, id);
	}
	pc_delitem(sd, id, amount, 9);

	return 0;
}

int clif_exchange_money(USER* sd, USER* tsd) {
	if (!sd) return 0;
	if (!tsd) return 0;

	/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `ExchangeLogs` (`ExgChaId`, `ExgMapId`, `ExgX`, `ExgY`, `ExgTarget`, `ExgMapIdTarget`, `ExgXTarget`, `ExgYTarget`, `ExgItmId`, `ExgAmount`) VALUES ('%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u')",
			sd->status.id, sd->bl.m, sd->bl.x, sd->bl.y, tsd->status.id, tsd->bl.m, tsd->bl.x, tsd->bl.y, 0, sd->exchange.gold)) {
		SqlStmt_ShowDebug(sql_handle);
	}

	if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `ExchangeLogs` (`ExgChaId`, `ExgMapId`, `ExgX`, `ExgY`, `ExgTarget`, `ExgMapIdTarget`, `ExgXTarget`, `ExgYTarget`, `ExgItmId`, `ExgAmount`) VALUES ('%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u')",
			tsd->status.id, tsd->bl.m, tsd->bl.x, tsd->bl.y, sd->status.id, sd->bl.m, sd->bl.x, sd->bl.y, 0, tsd->exchange.gold)) {
		SqlStmt_ShowDebug(sql_handle);
	}*/

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	if (!session[tsd->fd])
	{
		session[tsd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 11);
	WFIFOHEAD(tsd->fd, 11);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOW(sd->fd, 1) = SWAP16(8);
	WFIFOB(sd->fd, 3) = 0x42;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = 0x03;
	WFIFOB(sd->fd, 6) = 0x00;
	WFIFOL(sd->fd, 7) = SWAP32(sd->exchange.gold);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	WFIFOB(tsd->fd, 0) = 0xAA;
	WFIFOW(tsd->fd, 1) = SWAP16(8);
	WFIFOB(tsd->fd, 3) = 0x42;
	WFIFOB(tsd->fd, 4) = 0x03;
	WFIFOB(tsd->fd, 5) = 0x03;
	WFIFOB(tsd->fd, 6) = 0x01;
	WFIFOL(tsd->fd, 7) = SWAP32(sd->exchange.gold);
	WFIFOSET(tsd->fd, encrypt(tsd->fd));

	return 0;
}

int clif_exchange_sendok(USER* sd, USER* tsd) {
	if (tsd->exchange.exchange_done == 1) {
		clif_exchange_finalize(sd, tsd);

		clif_exchange_message(sd, "You exchanged, and gave away ownership of the items.", 5, 0);
		clif_exchange_message(tsd, "You exchanged, and gave away ownership of the items.", 5, 0);

		clif_exchange_cleanup(sd);
		clif_exchange_cleanup(tsd);
	}
	else {
		sd->exchange.exchange_done = 1;
		clif_exchange_message(tsd, "You exchanged, and gave away ownership of the items.", 5, 1);
		clif_exchange_message(sd, "You exchanged, and gave away ownership of the items.", 5, 1);
	}

	return 0;
}

int clif_exchange_finalize(USER* sd, USER* tsd) {
	int i;
	int id;
	int amount;
	struct item* it;
	struct item* it2;
	CALLOC(it, struct item, 1);
	CALLOC(it2, struct item, 1);
	char escape[255];

	sl_doscript_blargs("characterLog", "exchangeLogWrite", 2, &sd->bl, &tsd->bl); // this is the global write that will be used to record exchanges in one big daily file

	for (i = 0; i < sd->exchange.item_count; i++) {
		memcpy(it, &sd->exchange.item[i], sizeof(sd->exchange.item[i]));
		Sql_EscapeString(sql_handle, escape, it->real_name);

		/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `ExchangeLogs` (`ExgChaId`, `ExgMapId`, `ExgX`, `ExgY`, `ExgItmId`, `ExgAmount`, `ExgTarget`, `ExgMapIdTarget`, `ExgXTarget`, `ExgYTarget`) VALUES ('%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u')",
				sd->status.id, sd->bl.m, sd->bl.x, sd->bl.y, it->id, it->amount, tsd->status.id, tsd->bl.m, tsd->bl.x, tsd->bl.y)) {
			SqlStmt_ShowDebug(sql_handle);
		}*/
		//it->id=id;
		//it->dura=sd->exchange.dura[i];
		//it->amount=sd->exchange.item_amount[i];
		//strcpy(it->real_name,sd->exchange.real_name[i]);
		//it->owner_id=sd->exchange.item_owner[i];
		pc_additem(tsd, it);
	}

	tsd->status.money += sd->exchange.gold;
	sd->status.money -= sd->exchange.gold;
	sd->exchange.gold = 0;

	for (i = 0; i < tsd->exchange.item_count; i++) {
		memcpy(it2, &tsd->exchange.item[i], sizeof(sd->exchange.item[i]));
		Sql_EscapeString(sql_handle, escape, it2->real_name);

		/*if(SQL_ERROR == Sql_Query(sql_handle,"INSERT INTO `ExchangeLogs` (`ExgChaId`, `ExgMapId`, `ExgX`, `ExgY`, `ExgItmId`, `ExgAmount`, `ExgTarget`, `ExgMapIdTarget`, `ExgXTarget`, `ExgYTarget`) VALUES ('%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u', '%u')",
				tsd->status.id, tsd->bl.m, tsd->bl.x, tsd->bl.y, it2->id, it2->amount, sd->status.id, sd->bl.m, sd->bl.x, sd->bl.y)) {
			SqlStmt_ShowDebug(sql_handle);
		}*/
		//it2->id=id;
		//it2->dura=tsd->exchange.dura[i];
		//it2->amount=tsd->exchange.item_amount[i];
		//strcpy(it2->real_name,tsd->exchange.real_name[i]);
		//it2->owner_id=tsd->exchange.item_owner[i];
		pc_additem(sd, it2);
	}

	FREE(it);
	FREE(it2);

	sd->status.money += tsd->exchange.gold;
	tsd->status.money -= tsd->exchange.gold;
	tsd->exchange.gold = 0;

	clif_sendstatus(sd, SFLAG_XPMONEY);
	clif_sendstatus(tsd, SFLAG_XPMONEY);
	return 0;
}

int clif_exchange_message(USER* sd, char* message, int type, int extra) {
	int len = 0;
	if (extra > 1) extra = 0;
	nullpo_ret(0, sd);
	len = strlen(message) + 5;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, strlen(message) + 8);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x42;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = type;
	WFIFOB(sd->fd, 6) = extra;
	WFIFOB(sd->fd, 7) = strlen(message);
	strcpy(WFIFOP(sd->fd, 8), message);
	//len+=strlen(message)+2;
	WFIFOW(sd->fd, 1) = SWAP16(len + 3);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_exchange_close(USER* sd) {
	int i;
	int id = 0;
	struct item* it;

	nullpo_ret(0, sd);
	CALLOC(it, struct item, 1);
	sd->exchange.target = 0;

	for (i = 0; i < sd->exchange.item_count; i++) {
		memcpy(it, &sd->exchange.item[i], sizeof(sd->exchange.item[i]));
		//it->id=id;
		//it->dura=sd->exchange.dura[i];
		//it->amount=sd->exchange.item_amount[i];
		//it->owner_id=sd->exchange.item_owner[i];
		//strcpy(it->real_name,sd->exchange.real_name[i]);
		pc_additemnolog(sd, it);
	}
	FREE(it);
	clif_exchange_cleanup(sd);
	return 0;
}

int clif_exchange_cleanup(USER* sd) {
	sd->exchange.exchange_done = 0;
	sd->exchange.gold = 0;
	sd->exchange.item_count = 0;
	return 0;
}

int clif_isingroup(USER* sd, USER* tsd) {
	int x;
	for (x = 0; x < sd->group_count; x++) {
		if (groups[sd->groupid][x] == tsd->bl.id) {
			return 1;
		}
	}
	return 0;
}
int clif_canmove_sub(struct block_list* bl, va_list ap) {
	USER* sd = NULL;
	USER* tsd = NULL;
	MOB* mob = NULL;
	int i = 0;

	nullpo_ret(0, sd = va_arg(ap, USER*));

	if (sd->canmove == 1) return 0;

	if (bl->type == BL_PC) {
		tsd = (USER*)bl;

		if (tsd) {
			if ((map[tsd->bl.m].show_ghosts && tsd->status.state == 1 && tsd->bl.id != sd->bl.id && sd->status.state != 1 && !(sd->optFlags & optFlag_ghosts))
				|| (tsd->status.state == -1 || (tsd->status.gm_level && (tsd->optFlags & optFlag_stealth)))) {
				return 0;
			}
		}
	}

	if (bl->type == BL_MOB) {
		mob = (MOB*)bl;

		if (mob->state == MOB_DEAD) {
			return 0;
		}
	}

	if (bl->type == BL_NPC && bl->subtype == 2) {
		return 0;
	}

	if (bl && bl->id != sd->bl.id) {
		sd->canmove = 1;
	}

	return 0;
}
int clif_canmove(USER* sd, int direct) {
	int nx = 0, ny = 0;
	if (sd->status.gm_level) return 0;
	switch (direct) {
	case 0:
		ny = sd->bl.y - 1;
		break;
	case 1:
		nx = sd->bl.x + 1;
		break;
	case 2:
		ny = sd->bl.y + 1;
		break;
	case 3:
		nx = sd->bl.x - 1;
		break;
	}

	map_foreachincell(clif_canmove_sub, sd->bl.m, sd->bl.x, sd->bl.y, BL_MOB, sd);
	map_foreachincell(clif_canmove_sub, sd->bl.m, sd->bl.x, sd->bl.y, BL_PC, sd);
	map_foreachincell(clif_canmove_sub, sd->bl.m, nx, ny, BL_PC, sd);
	if (clif_object_canmove(sd->bl.m, nx, ny, direct)) {
		sd->canmove = 1;
	}
	return sd->canmove;
}

/*int clif_clanBankWithdraw(USER *sd,struct item_data *items,int count) {
	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	int len = 0;

	WFIFOHEAD(sd->fd,65535);
	WFIFOB(sd->fd,0)=0xAA;
	WFIFOB(sd->fd,3)=0x3D;
	//WFIFOB(sd->fd,4)=0x03;
	WFIFOB(sd->fd,5)=0x0A;

	WFIFOB(sd->fd,6) = count;

	len += 7;

	for (int x = 0; x<count; x++) {
		WFIFOB(sd->fd,len) = x+1; // slot number
		len += 1;

		if (items[x].customIcon != 0) WFIFOW(sd->fd,len) = SWAP16(items[x].customIcon+49152);
		else WFIFOW(sd->fd,len) = SWAP16(itemdb_icon(items[x].id)); // packet only supports icon number, no colors

		len += 2;

		if (!strcmpi(items[x].real_name,"")) { // no engrave
			WFIFOB(sd->fd,len) = strlen(itemdb_name(items[x].id));
			strcpy(WFIFOP(sd->fd,len+1),itemdb_name(items[x].id));
			len += strlen(itemdb_name(items[x].id)) + 1;
		} else { // has engrave
			WFIFOB(sd->fd,len) = strlen(items[x].real_name);
			strcpy(WFIFOP(sd->fd,len+1),items[x].real_name);
			len += strlen(items[x].real_name) + 1;
		}

		WFIFOB(sd->fd,len) = strlen(itemdb_name(items[x].id));
		strcpy(WFIFOP(sd->fd,len+1),itemdb_name(items[x].id));
		len += strlen(itemdb_name(items[x].id)) + 1;

		//WFIFOL(sd->fd,len) = SWAP32(48); // item count
		WFIFOL(sd->fd,len) = SWAP32(items[x].amount);

		len += 4;

		WFIFOB(sd->fd,len) = 1;
		WFIFOB(sd->fd,len+1) = 0;
		WFIFOB(sd->fd,len+2) = 1;
		WFIFOB(sd->fd,len+3) = 0;

		len += 4;

		WFIFOB(sd->fd,len) = 255; // This might be the max withdraw limit at a time?  number is always 100 or 255

		len += 1;
	}

	WFIFOW(sd->fd,1)=SWAP16(len+3);
	WFIFOSET(sd->fd,encrypt(sd->fd));

	FREE(items);
	// /lua Player(2):clanBankWithdraw()

	return 0;
}*/

/*int clif_parseClanBankWithdraw(USER *sd) {
	unsigned int slot = RFIFOB(sd->fd,7);
	unsigned int amount = SWAP32(RFIFOL(sd->fd,9));

	sl_resumeclanbankwithdraw(RFIFOB(sd->fd,5),slot,amount,sd);

	return 0;
}*/

int clif_mapselect(USER* sd, char* wm, int* x0, int* y0, char** mname, unsigned int* id, int* x1, int* y1, int i) {
	int len = 0;
	int x, y;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x2E;
	WFIFOB(sd->fd, 4) = 0x03;
	WFIFOB(sd->fd, 5) = strlen(wm);
	strcpy(WFIFOP(sd->fd, 6), wm);
	len += strlen(wm) + 1;
	WFIFOB(sd->fd, len + 5) = i;
	WFIFOB(sd->fd, len + 6) = 0; //Maybe look?
	len += 2;

	for (x = 0; x < i; x++) {
		WFIFOW(sd->fd, len + 5) = SWAP16(x0[x]);
		WFIFOW(sd->fd, len + 7) = SWAP16(y0[x]);
		len += 4;
		WFIFOB(sd->fd, len + 5) = strlen(mname[x]);
		strcpy(WFIFOP(sd->fd, len + 6), mname[x]);
		len += strlen(mname[x]) + 1;
		WFIFOL(sd->fd, len + 5) = SWAP32(id[x]);
		WFIFOW(sd->fd, len + 9) = SWAP16(x1[x]);
		WFIFOW(sd->fd, len + 11) = SWAP16(y1[x]);
		len += 8;
		WFIFOW(sd->fd, len + 5) = SWAP16(i);
		len += 2;
		for (y = 0; y < i; y++) {
			WFIFOW(sd->fd, len + 5) = SWAP16(y);
			len += 2;
		}
	}

	WFIFOW(sd->fd, 1) = SWAP16(len + 3);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}
int clif_pb_sub(struct block_list* bl, va_list ap) {
	USER* sd = NULL;
	USER* tsd = NULL;
	int* len = NULL;
	unsigned int power_rating;

	nullpo_ret(0, tsd = (USER*)bl);
	nullpo_ret(0, sd = va_arg(ap, USER*));
	len = va_arg(ap, int*);

	int path = classdb_path(tsd->status.class);

	if (path == 5)
		path = 2;

	if (path == 50 || path == 0)
		return 0;
	else {
		//clif_sendminitext(sd,"Entered stage 1 - Power rating");
		power_rating = tsd->status.basehp + tsd->status.basemp;
		//clif_sendminitext(sd,"Entered stage 2 - unknown");
		WFIFOL(sd->fd, len[0] + 8) = SWAP32(tsd->bl.id);
		//clif_sendminitext(sd,"Entered stage 3 - class sorting?");
		WFIFOB(sd->fd, len[0] + 12) = path;
		//clif_sendminitext(sd,"Entered stage 4 - power rating");
		WFIFOL(sd->fd, len[0] + 13) = SWAP32(power_rating);
		//clif_sendminitext(sd,"Entered stage 5 - dye");
		WFIFOB(sd->fd, len[0] + 17) = tsd->status.armor_color;
		//clif_sendminitext(sd,"Entered stage 6 - name 1");
		WFIFOB(sd->fd, len[0] + 18) = strlen(tsd->status.name);
		//clif_sendminitext(sd,"Entered stage 7 - name 2");
		strcpy(WFIFOP(sd->fd, len[0] + 19), tsd->status.name);
		//clif_sendminitext(sd,"Entered stage 8 - name 3");
		len[0] += strlen(tsd->status.name) + 11;
		len[1]++;
	}
	return 0;
}
int clif_sendpowerboard(USER* sd) {
	int len[2];
	len[0] = 0;
	len[1] = 0;

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x46; //Powerboard packet
	WFIFOB(sd->fd, 4) = 0x03; //#?
	WFIFOB(sd->fd, 5) = 1; //Subtype?
	map_foreachinarea(clif_pb_sub, sd->bl.m, sd->bl.x, sd->bl.y, SAMEMAP, BL_PC, sd, len);
	WFIFOW(sd->fd, 6) = SWAP16(len[1]);
	WFIFOW(sd->fd, 1) = SWAP16(len[0] + 5);
	WFIFOSET(sd->fd, encrypt(sd->fd));
	return 0;
}

int clif_parseparcel(USER* sd) {
	nullpo_ret(0, sd);
	clif_sendminitext(sd, "You should go see your kingdom's messenger to collect this parcel");
	return 0;
}

int clif_huntertoggle(USER* sd) {
	// printf("clicked hunter list\n");

	//first character of input starts on (sd->fd,7)
	//unsigned int psize = SWAP16(RFIFOW(sd->fd,1));

	// Packet field 0x05 determines if hunter flag set. Store in SessionData

	sd->hunter = RFIFOB(sd->fd, 5);

	char hunter_tag[40] = ""; // set array to hold maximum 40 characters from user input

	memcpy(hunter_tag, RFIFOP(sd->fd, 7), RFIFOB(sd->fd, 6));

	SqlStmt* stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	if (SQL_ERROR == Sql_Query(sql_handle, "UPDATE `Character` SET `ChaHunter` = '%i', `ChaHunterNote` = '%s' WHERE `ChaId` = '%d'", sd->hunter, hunter_tag, sd->status.id)) {
		Sql_ShowDebug(sql_handle);
		SqlStmt_Free(stmt);
		return 0;
	}

	//if (SQL_SUCCESS == SqlStmt_NextRow(stmt)) SqlStmt_Free(stmt);

	if (!session[sd->fd])
	{
		session[sd->fd]->eof = 8;
		return 0;
	}

	WFIFOHEAD(sd->fd, 5);
	WFIFOB(sd->fd, 0) = 0xAA;
	WFIFOB(sd->fd, 3) = 0x83;
	WFIFOB(sd->fd, 5) = sd->hunter;
	WFIFOW(sd->fd, 1) = SWAP16(5);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

int clif_sendhunternote(USER* sd) {
	int len = 0;
	char huntername[16] = "";

	char hunternote[41] = "";

	memcpy(huntername, RFIFOP(sd->fd, 6), RFIFOB(sd->fd, 5));

	if (strcmpi(sd->status.name, huntername) == 0) return 1;

	SqlStmt* stmt = SqlStmt_Malloc(sql_handle);

	if (stmt == NULL) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0;
	}

	if (SQL_ERROR == SqlStmt_Prepare(stmt, "SELECT `ChaHunterNote` FROM `Character` WHERE `ChaName` = '%s'", huntername)
		|| SQL_ERROR == SqlStmt_Execute(stmt)
		|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &hunternote, sizeof(hunternote), NULL, NULL)) {
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 1;
	}

	if (SQL_SUCCESS == SqlStmt_NextRow(stmt)) SqlStmt_Free(stmt);

	if (hunternote == "") return 1;

	WFIFOHEAD(sd->fd, 65535);
	WFIFOB(sd->fd, 0) = 0xAA;

	WFIFOB(sd->fd, 3) = 0x84;

	WFIFOB(sd->fd, 5) = strlen(huntername);

	len += 6;

	memcpy(WFIFOP(sd->fd, len), huntername, strlen(huntername));

	len += strlen(huntername); // fd 17

	WFIFOB(sd->fd, len) = strlen(hunternote);

	len += 1;

	memcpy(WFIFOP(sd->fd, len), hunternote, strlen(hunternote));

	len += strlen(hunternote);

	WFIFOW(sd->fd, 1) = SWAP16(len);
	WFIFOSET(sd->fd, encrypt(sd->fd));

	return 0;
}

clif_pushback(USER* sd) {
	switch (sd->status.side) {
	case 0: pc_warp(sd, sd->bl.m, sd->bl.x, sd->bl.y + 2);
		break;
	case 1: pc_warp(sd, sd->bl.m, sd->bl.x - 2, sd->bl.y);
		break;
	case 2: pc_warp(sd, sd->bl.m, sd->bl.x, sd->bl.y - 2);
		break;
	case 3: pc_warp(sd, sd->bl.m, sd->bl.x + 2, sd->bl.y);
		break;
	}

	return 0;
}

int clif_cancelafk(USER* sd) {
	int reset = 0;

	nullpo_ret(0, sd);

	if (sd->afk) reset = 1;

	sd->afktime = 0;
	sd->afk = 0;

	/*if (reset) {
		if (SQL_ERROR == Sql_Query(sql_handle, "INSERT INTO `UnAfkLogs` (`UfkChaId`, `UfkMapId`, `UfkX`, `UfkY`) VALUES ('%u', '%u', '%u', '%u')",
		sd->status.id, sd->bl.m, sd->bl.x, sd->bl.y)) {
			Sql_ShowDebug(sql_handle);
			return 0;
		}
	}*/

	return 0;
}
/*int clif_ispass(USER *sd) {
	char md52[32]="";
	char buf[255]="";
	char name2[32]="";
	char pass2[32]="";

	strcpy(name2,name);
	strcpy(pass2,pass);
	sprintf(buf,"%s %s",strlwr(name2),strlwr(pass2));
	MD5_String(buf,md52);

	if(!strcmpi(md5,md52)) {
		return 1;
	} else {
		return 0;
	}
}
int clif_switchchar(USER *sd, char* name, char* pass) {
	int result;
	char md5[64]="";
	char pass2[64]="";
	int expiration=0;
	int ban=0;
	int map=0;
	int nID=0;
	SqlStmt* stmt=SqlStmt_Malloc(sql_handle);

	nullpo_ret(0, sd);
	if(stmt == NULL)
	{
		SqlStmt_ShowDebug(stmt);
		return 0;
	}

	if(SQL_ERROR == SqlStmt_Prepare(stmt,"SELECT `pass` FROM `character` WHERE `name`='%s'",name)
	|| SQL_ERROR == SqlStmt_Execute(stmt)
	|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_STRING, &md5, sizeof(md5), NULL, NULL)
	)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0; //db_error
	}

	if(SQL_SUCCESS != SqlStmt_NextRow(stmt))
	{
		SqlStmt_Free(stmt);
		return 0; //name doesn't exist
	}
	if(!ispass(name,pass,md5))
	{
		SqlStmt_Free(stmt);
		return 0; //wrong password, try again!
	}

	if(SQL_ERROR == SqlStmt_Prepare(stmt,"SELECT `id`, `pass`, `ban`, `map` FROM `character` WHERE `name`='%s'",name)
	|| SQL_ERROR == SqlStmt_Execute(stmt)
	|| SQL_ERROR == SqlStmt_BindColumn(stmt, 0, SQLDT_UINT, &nID, 0, NULL, NULL)
	|| SQL_ERROR == SqlStmt_BindColumn(stmt, 1, SQLDT_STRING, &pass2, sizeof(pass2), NULL, NULL)
	|| SQL_ERROR == SqlStmt_BindColumn(stmt, 2, SQLDT_UCHAR, &ban, 0, NULL, NULL)
	|| SQL_ERROR == SqlStmt_BindColumn(stmt, 3, SQLDT_USHORT, &map, 0, NULL, NULL)
	)
	{
		SqlStmt_ShowDebug(stmt);
		SqlStmt_Free(stmt);
		return 0; //db_error
	}

	if(SQL_SUCCESS != SqlStmt_NextRow(stmt))
	{
		SqlStmt_Free(stmt);
		return 0; //name doesn't exist
	}

	if(ban)
		return 2; //you are banned, go away

	SqlStmt_Free(stmt);
	return 1;
}*/
