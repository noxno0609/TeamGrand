#include <YSI\y_timers>
#include <foreach>
//#include <jit>

#define OFFERWEAPON 1

#define MAXCUSTOMVEH 50
new aVeh[MAXCUSTOMVEH];
new Text3D:aVehLabel[MAXCUSTOMVEH];

new Tazering[MAX_PLAYERS];
new Tazered[MAX_PLAYERS];
new WearTazer[MAX_PLAYERS];

//Newbie Chat
new NewbieChannelActive = 0;
new CountAdvisor = 0;
new Text3D:DanhHieu[MAX_PLAYERS];

//Bike Fall System
new HitTimes[MAX_PLAYERS];

//Ap Giai - Escort
new Escorted[MAX_PLAYERS];
new EscortedPlayer[MAX_PLAYERS];
new Escorting[MAX_PLAYERS];

/////////////////Skill Define//
#define FARMER 1

////////////FARMER////////////
#define MAXSEED 150
#define MAX_SEED_PLAYER 3
#define TIME_BONPHAN 20000 // milliseconds
#define TIME_CAYHEO 180000 // milliseconds
#define TIME_CAYCHET 120000 // milliseconds
#define TIME_SEEDGROWTH 60000 // milliseconds
new
	SeedGrowth[MAX_OBJECTS],
	SeedTuoiNuoc[MAX_OBJECTS],
	//SeedBonPhan[MAX_OBJECTS],
	SeedGatLua[MAX_OBJECTS],
	SeedCount[MAX_PLAYERS] = 0,
	Float:SeedPos[MAX_OBJECTS][3],
	SeedObject[MAX_OBJECTS],
	SeedOwner[MAX_OBJECTS][MAX_PLAYER_NAME + 1],
	SeedTime[MAX_OBJECTS],
	SeedTotal[MAX_OBJECTS],
	Text3D:SeedText[MAX_OBJECTS];
