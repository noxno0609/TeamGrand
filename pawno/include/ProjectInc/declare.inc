#include <mSelection>
//#include <jit>

//TextDraw
new Text:TDLoading;
new Text:TDPBank[MAX_PLAYERS];
new tdbank[50];

#define PLANTMONEY 5000
#define PLANTDRUG 2

#define OFFERWEAPON 1

#define MAXCUSTOMVEH 50
new aVeh[MAXCUSTOMVEH];
new Text3D:aVehLabel[MAXCUSTOMVEH];
new aColor[MAXCUSTOMVEH][2];

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
#define PLANT 1

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

//Medic
new Float:MedicPos[MAX_PLAYERS][3];
new MedicCaller[MAX_PLAYERS];
new CallMedic[MAX_PLAYERS];
new Dying[MAX_PLAYERS];
new DyingTimeOut[MAX_PLAYERS];
new Saving[MAX_PLAYERS];
new Saver[MAX_PLAYERS];
new SaveVehicle[MAX_PLAYERS];

//BUON LAU
new DDTime[MAX_PLAYERS];
new DrugDealing[MAX_PLAYERS];
new DrugDealer[MAX_PLAYERS];
new CarDD[MAX_PLAYERS];
new ChangeDD[MAX_PLAYERS];
new OldDD[MAX_PLAYERS];
new CoopDD[MAX_PLAYERS];

new Float:BuonLauTakeCP[3][3] =
{
	{ -383.8653, -1040.2242, 58.8907 },
	{ -1073.3174, -1208.0381, 129.2188 },
	{ - 415.5736, -1761.8284, 5.6117 }
};
new Float:BuonLauGiveCP[4][3] =
{
	{ -2445.0994, -1759.8325, 13.5898 },
	{ 2667.3279, -1458.4261, 30.5938 },
	{ 2123.8247, -1185.9852, 24.0214 },
	{ 2795.4939, -1619.3204, 10.9219 }
};

new Float:DocArrestOut[23][3] =
{
	{ 2578.0896, -1516.9482, -48.9141 },
	{ 2577.9795, -1513.4364, -48.9141 },
	{ 2578.0840, -1509.5540, -48.9141 },
	{ 2578.0181, -1506.0131, -48.9141 },
	{ 2577.8655, -1502.2213, -48.9141 },
	{ 2588.4314, -1517.9393, -48.9141 },
	{ 2588.4795, -1514.1781, -48.9141 },
	{ 2588.3044, -1510.4994, -48.9141 },
	{ 2588.3792, -1506.9188, -48.9141 },
	{ 2588.5024, -1503.1636, -48.9141 },
	{ 2587.7209, -1522.0472, -48.9141 },
	{ 2584.2358, -1522.2797, -48.9141 },
	{ 2580.5249, -1522.2711, -48.9141 },
	{ 2587.7322, -1529.3362, -45.2369 },
	{ 2583.9592, -1529.5356, -45.2369 },
	{ 2580.3674, -1529.3932, -45.2369 },
	{ 2570.6887, -1502.3342, -45.2369 },
	{ 2570.8069, -1506.0854, -45.2369 },
	{ 2570.8640, -1509.4326, -45.2369 },
	{ 2570.8611, -1513.0879, -45.2373 },
	{ 2570.8345, -1516.7938, -45.2373 },
	{ 2587.2979, -1535.0804, -47.3400 },
	{ 2580.8687, -1535.0698, -47.3400 }
};

new Float:DocArrestIn[23][3] =
{
	{ 2575.9727, -1516.8209, -48.9141 },
	{ 2575.9553, -1513.3483, -48.9141 },
	{ 2575.6096, -1509.6593, -48.9141 },
	{ 2575.6218, -1505.9529, -48.9141 },
	{ 2575.7466, -1502.1635, -48.9141 },
	{ 2590.3359, -1518.0035, -48.9141 },
	{ 2590.8240, -1514.3561, -48.9141 },
	{ 2590.0112, -1510.6479, -48.9141 },
	{ 2590.6521, -1507.0378, -48.9141 },
	{ 2590.5320, -1503.5839, -48.9141 },
	{ 2587.8455, -1524.3763, -48.9141 },
	{ 2584.2048, -1524.4270, -48.9141 },
	{ 2580.4438, -1525.7611, -48.9141 },
	{ 2587.5615, -1526.2703, -45.2369 },
	{ 2583.8953, -1526.2755, -45.2369 },
	{ 2580.4639, -1527.3052, -45.2369 },
	{ 2573.2329, -1502.3574, -45.2369 },
	{ 2573.6370, -1505.9093, -45.2369 },
	{ 2572.9968, -1509.9520, -45.2369 },
	{ 2573.7371, -1513.3970, -45.2373 },
	{ 2573.6582, -1517.1709, -45.2373 },
	{ 2589.1501, -1538.0702, -48.9141 },
	{ 2583.6245, -1539.0674, -48.9141 }
};

#define MAX_NAILS 38
#define LIMIT_NAILS 20
new NailObject[MAX_NAILS];
new Float:NailPos[MAX_NAILS][3] =
{
	{ 728.6450, -1320.7795, 13.3984 },
	{799.9040, -1346.5721, 13.3828 },
	{797.2269, -1422.2045, 13.3857},
	{774.0714, -1588.1799, 13.3828},
	{827.9992, -1616.8951, 13.3828},
	{817.8740, -1770.9966, 13.3828},
	{1007.0264, -1809.3763, 13.3828},
	{1185.4883, -1853.8613, 13.3828},
	{1520.8279, -1873.3431, 13.3828},
	{1548.0623, -1869.7402, 13.3828},
	{1682.1826, -1863.8546, 13.3828},
	{1890.2144, -1754.3682, 13.3828},
	{1940.4547, -1718.0732, 13.3828},
	{1941.2813, -1678.9716, 13.3828},
	{1945.6339, -1625.3254, 13.3828},
	{2007.5431, -1616.3417, 13.3828},
	{2092.4348, -1612.9803, 13.3828},
	{2126.4800, -1614.9279, 13.3828},
	{2288.6045, -1733.7295, 13.3828},
	{2394.3254, -1751.5524, 13.3828},
	{2409.3438, -1749.8817, 13.3828},
	{2419.7471, -1936.7133, 13.3828},
	{2487.7747, -1728.6785, 13.3828},
	{2515.9705, -1818.2275, 13.3828},
	{2072.2856, -1809.9269, 13.3828},
	{1749.4846, -1647.5687, 13.3828},
	{1697.6987, -1594.1803, 13.3828},
	{1527.7019, -1634.5322, 13.3828},
	{1534.1624, -1687.2218, 13.3828},
	{1450.9537, -1733.2712, 13.3828},
	{1312.5131, -1667.5985, 13.3828},
	{797.2224, -1258.4231, 13.3828},
	{671.3542, -1585.7765, 13.3828},
	{196.6848, -1633.4841, 13.5829},
	{359.8520, -1381.7119, 13.5829},
	{1758.0686, -1496.5553, 13.5829},
	{1753.4799, -1500.8778, 13.5829},
	{1208.4205, -1323.8865, 13.5829}
};

new LastShot[MAX_VEHICLES];

//Anti Checkpoint Cheat
new Float:AntiCPDistance[MAX_PLAYERS],
	AntiCPTime[MAX_PLAYERS],
	AntiCheckpoint[MAX_PLAYERS];

//PD Find
new PFind[MAX_PLAYERS];
new LSArea;
new Float:LSZone[] = {
	48.0, -1531.0, 324.0, -2083.0, 1324.0, -2739.0, 2916.0, -2735.0, 2896.0, -919.0, 1220.0, -771.0, 476.0, -1023.0, 48.0, -1531.0
};
new DOCArea;
new Float:DOCZone[] = {
	649.8716, -1383.8660, 650.1193, -1330.2158, 773.1381, -1331.3358, 773.2067, -1383.9464
};
new DOCCheck[MAX_PLAYERS];
new DOCDelay[MAX_PLAYERS];
new DOCAlarm = 0;
#define DOCAIR 40.0

new gPlayerUsingLoopingAnim[MAX_PLAYERS];
new gPlayerAnimLibsPreloaded[MAX_PLAYERS];

new Text:TDAnimHelp;

new Float:LastEntrance[MAX_PLAYERS][3];

//Nail


//Spec
new SpecPlayer[MAX_PLAYERS],
Spectating[MAX_PLAYERS],
Spectated[MAX_PLAYERS],
Float:SpecPos[MAX_PLAYERS][3],
SpecInt[MAX_PLAYERS],
SpecVWorld[MAX_PLAYERS];

new Trucking[MAX_VEHICLES];
new TruckTime[MAX_PLAYERS];
new Float:TruckPos[MAX_PLAYERS][3];
new TruckBiz[MAX_PLAYERS];
//TYPECAR
#define HARVESTVEH 1
#define DHARVESTVEH 2
#define SMUGGLEVEH 3
#define SWEEPERVEH 4
#define COPVEH 5
#define FBIVEH 6
#define NGVEH 7
#define GORVEH 8
#define HSPDVEH 9
#define AMBUVEH 10
#define TRUCKVEH 11
#define PIZZAVEH 12
#define BUSVEH 13
#define TOWVEH 14
#define SCHOOLVEH 15
#define RENTVEH 16
#define KARTVEH 17
#define NEWSVEH 18
#define TAXIVEH 19
#define HITMANVEH 20
#define DOCVEH 21

#define UPDLNOVEH 1
#define UPDLVEH 2

#define GATE 1
#define DOOR 2
#define DOCCELL 3

new mSkinList = mS_INVALID_LISTID;
//Reward Type
#define TRUCKREWARD 1

stock CreateServerTextDraw()
{
	TDLoading = TextDrawCreate(328.500000, 183.155548, "Loading...~n~Dang_lay_thong_tin_tai_khoan...");
	TextDrawLetterSize(TDLoading, 0.410500, 2.315554);
	TextDrawTextSize(TDLoading, 0.000000, 306.000000);
	TextDrawAlignment(TDLoading, 2);
	TextDrawColor(TDLoading, -1);
	TextDrawUseBox(TDLoading, 1);
	TextDrawBoxColor(TDLoading, 102);
	TextDrawSetShadow(TDLoading, 0);
	TextDrawSetOutline(TDLoading, 1);
	TextDrawBackgroundColor(TDLoading, 255);
	TextDrawFont(TDLoading, 2);
	TextDrawSetProportional(TDLoading, 1);
	TextDrawSetShadow(TDLoading, 0);
}

stock CreateServerPlayerTextDraw(playerid)
{
	TDPBank[playerid] = TextDrawCreate(608.437072, 95.833282, "Bank$_100,000,000");
	TextDrawLetterSize(TDPBank[playerid], 0.400000, 1.600000);
	TextDrawAlignment(TDPBank[playerid], 3);
	TextDrawColor(TDPBank[playerid], -2139094785);
	TextDrawSetShadow(TDPBank[playerid], 0);
	TextDrawSetOutline(TDPBank[playerid], 1);
	TextDrawBackgroundColor(TDPBank[playerid], 255);
	TextDrawFont(TDPBank[playerid], 1);
	TextDrawSetProportional(TDPBank[playerid], 1);
	TextDrawSetShadow(TDPBank[playerid], 0);
}

//Anti Car Repair
new CarRepairCheat[MAX_VEHICLES][4];
new CarCheatAttemping[MAX_PLAYERS];
new Float:CarHealthCheat[MAX_VEHICLES];
