#include <YSI\y_timers>
#include <YSI\y_iterate>
#include <zones>
#include <YSI\y_ini>
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

new VehicleNames[][] =
{
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
	"Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
	"Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
	"Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van",
	"Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
	"Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
	"Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
	"Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin",
	"Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
	"Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
	"Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
	"FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
	"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
	"Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
	"Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
	"Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
	"Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratium",
	"Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
	"Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
	"Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
	"News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car",
	"Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
	"Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville",
	"Tiller", "Utility Trailer"
};

stock GetVehicleName(vehicleid)
{
	new str[128];
	format(str, sizeof(str), "%s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
	return str;
}

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

new DriverLicenseCar[MAX_PLAYERS];
new Float:DriverLicenseTime[MAX_PLAYERS];
new Timer:DriverLicenseLoop[MAX_PLAYERS];
new PlayerText:DriverLicenseTD[MAX_PLAYERS][5];
new Float:DriverLicensePos[10][3] = {
	{2054.9548,-1932.3621,13.3908}, //Start
	{1961.6324,-1932.2354,13.3828},
	{1961.6705,-2166.4866,13.3828},
	{1964.2754,-2205.9233,13.5469}, //LS's Airport junp
	{1879.9777,-2469.4734,13.6028}, //Start Driver License
	{1856.8535,-2409.0413,13.6028},
	{1849.5590,-2452.4497,13.6028},
	{1829.0403,-2413.6301,13.6106},
	{1834.8435,-2456.9551,13.6106}, // Finish Driver License Test
	{2056.3091,-1904.6545,13.2496} // Get Driver License
};