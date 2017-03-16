#include <mSelection>
#include <timestamp>
//#include <jit>

new stock VehicleNames[213][255] = {
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Pereniel",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Mr Whoopee",
	"BF Injection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Trailer", //artict1
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RC Bandit",
	"Romero",
	"Packer",
	"Monster",
	"Admiral",
	"Squalo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Trailer", //artict2
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Berkley's RC Van",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RC Baron",
	"RC Raider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR3 50",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Maverick",
	"News Chopper",
	"Rancher",
	"FBI Rancher",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring",
	"Sandking",
	"Blista Compact",
	"Police Maverick",
	"Boxville",
	"Benson",
	"Mesa",
	"RC Goblin",
	"Hotring Racer", //hotrina
	"Hotring Racer", //hotrinb
	"Bloodring Banger",
	"Rancher",
	"Super GT",
	"Elegant",
	"Journey",
	"Bike",
	"Mountain Bike",
	"Beagle",
	"Cropdust",
	"Stunt",
	"Tanker", //petro
	"RoadTrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"Hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"Cement Truck",
	"Tow Truck",
	"Fortune",
	"Cadrona",
	"FBI Truck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight",
	"Streak",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck", //firela
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster", //monstera
	"Monster", //monsterb
	"Uranus",
	"Jester",
	"Sultan",
	"Stratum",
	"Elegy",
	"Raindance",
	"RC Tiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"Freight", //freiflat
	"Trailer", //streakc
	"Kart",
	"Mower",
	"Duneride",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"Newsvan",
	"Tug",
	"Trailer", //petrotr
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"Trailer", //freibox
	"Trailer", //artict3
	"Andromada",
	"Dodo",
	"RC Cam",
	"Launch",
	"Police Car (LSPD)",
	"Police Car (SFPD)",
	"Police Car (LVPD)",
	"Police Ranger",
	"Picador",
	"S.W.A.T. Van",
	"Alpha",
	"Phoenix",
	"Glendale",
	"Sadler",
	"Luggage Trailer", //bagboxa
	"Luggage Trailer", //bagboxb
	"Stair Trailer", //tugstair
	"Boxville",
	"Farm Plow", //farmtr1
	"Utility Trailer", //utiltr1
	"Invalid Vehicle" //just to return if the modelid is invalid
};

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
#define TRUCK 2
#define PIZZA 3
#define MECHANIC 4

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

#define MAX_NAILS 127
#define LIMIT_NAILS 35
new CountNails = 0;
new TimeNails[MAX_PLAYERS];
new SearchNails[MAX_PLAYERS];
new NailObject[MAX_NAILS];
new InNails[MAX_VEHICLES];
new Float:NailPos[MAX_NAILS][4] =
{
	{ 728.6450, -1320.7795, 13.3984, -90.0 },
	{ 799.9040, -1346.5721, 13.3828, -90.0 },
	{ 797.2269, -1422.2045, 13.3857, -90.0 },
	{ 774.0714, -1588.1799, 13.3828, -90.0 },
	{ 827.9992, -1616.8951, 13.3828, -90.0 },
	{ 817.8740, -1770.9966, 13.3828, -90.0 },
	{ 1007.0264, -1809.3763, 13.3828, -90.0 },
	{ 1185.4883, -1853.8613, 13.3828, -90.0 },
	{ 1520.8279, -1873.3431, 13.3828, -90.0 },
	{ 1548.0623, -1869.7402, 13.3828, -90.0 },
	{ 1682.1826, -1863.8546, 13.3828, -90.0 },
	{ 1890.2144, -1754.3682, 13.3828, -90.0 },
	{ 1940.4547, -1718.0732, 13.3828, -90.0 },
	{ 1941.2813, -1678.9716, 13.3828, -90.0 },
	{ 1945.6339, -1625.3254, 13.3828, -90.0 },
	{ 2007.5431, -1616.3417, 13.3828, -90.0 },
	{ 2092.4348, -1612.9803, 13.3828, -90.0 },
	{ 2126.4800, -1614.9279, 13.3828, -90.0 },
	{ 2288.6045, -1733.7295, 13.3828, -90.0 },
	{ 2394.3254, -1751.5524, 13.3828, -90.0 },
	{ 2409.3438, -1749.8817, 13.3828, -90.0 },
	{ 2419.7471, -1936.7133, 13.3828, -90.0 },
	{ 2487.7747, -1728.6785, 13.3828, -90.0 },
	{ 2515.9705, -1818.2275, 13.3828, -90.0 },
	{ 2072.2856, -1809.9269, 13.3828, -90.0 },
	{ 1749.4846, -1647.5687, 13.3828, -90.0 },
	{ 1697.6987, -1594.1803, 13.3828, -90.0 },
	{ 1527.7019, -1634.5322, 13.3828, -90.0 },
	{ 1534.1624, -1687.2218, 13.3828, -90.0 },
	{ 1450.9537, -1733.2712, 13.3828, -90.0 },
	{ 1312.5131, -1667.5985, 13.3828, -90.0 },
	{ 797.2224, -1258.4231, 13.3828, -90.0 },
	{ 671.3542, -1585.7765, 13.3828, -90.0 },
	{ 196.6848, -1633.4841, 13.5829, -90.0 },
	{ 359.8520, -1381.7119, 13.5829, -90.0 },
	{ 1758.0686, -1496.5553, 13.5829, -90.0 },
	{ 1753.4799, -1500.8778, 13.5829, -90.0 },
	{ 1208.4205, -1323.8865, 13.5829, -90.0 },
	{ 1355.4004, -986.3817, 29.6185, 90.0 },
	{1356.7314, -1208.1207, 17.2340, 90.0 },
	{1298.6150, -1604.7634, 13.3828, 90.0 },
	{1428.8035, -1709.9276, 13.3828, 90.0 },
	{1455.6887, -1409.7604, 13.3828, 90.0 },
	{1453.9257, -1173.9480, 23.7508, 90.0 },
	{1482.7883, -1147.3765, 23.9063, 90.0 },
	{1481.0729, -1054.7466, 23.6536, 90.0 },
	{1714.3423, -1180.7100, 23.6596, 90.0 },
	{1715.5841, -1296.0073, 13.3906, 90.0 },
	{1715.7869, -1428.4838, 13.3828, 90.0 },
	{1655.8702, -1461.7355, 13.3850, 90.0 },
	{1658.3876, -1579.5190, 13.3906, 90.0 },
	{1688.7194, -1634.1912, 13.3828, 90.0 },
	{1689.2428, -1729.6924, 13.3837, 90.0 },
	{1750.0969, -1717.6025, 13.3828, 90.0 },
	{1750.2872, -1621.7094, 13.3854, 90.0 },
	{1691.1243, -1823.7585, 13.3828, 90.0 },
	{1685.1206, -1860.4302, 13.3906, 90.0 },
	{1820.5314, -1877.6859, 13.3735, 90.0 },
	{1819.3440, -1769.5991, 13.3828, 90.0 },
	{1821.0054, -1624.1442, 13.3828, 90.0 },
	{1826.7620, -1555.6427, 13.3700, 90.0 },
	{1849.8151, -1442.7332, 13.4010, 90.0 },
	{1851.1796, -1343.5352, 13.3969, 90.0 },
	{1850.5322, -1262.5765, 13.3906, 90.0 },
	{1851.1960, -1198.5354, 22.5718, 90.0 },
	{1867.8810, -1142.5807, 23.7380, 90.0 },
	{1865.0367, -1076.6849, 23.6693, 90.0 },
	{1976.8998, -1078.8448, 24.9035, 90.0 },
	{1969.8295, -1152.7965, 25.8429, 90.0 },
	{1975.1041, -1244.2910, 24.1078, 90.0 },
	{2069.2075, -1129.7338, 23.7342, 90.0 },
	{2069.1335, -1231.9622, 23.8068, 90.0 },
	{2068.8787, -1363.2617, 23.8151, 90.0 },
	{2112.8406, -1459.2571, 23.8328, 90.0 },
	{2096.1509, -1736.4115, 13.3988, 90.0 },
	{2083.4050, -1894.5131, 13.3906, 90.0 },
	{2215.8066, -1711.1886, 13.3958, 90.0 },
	{2342.8013, -1582.0952, 23.7454, 90.0 },
	{2430.7952, -1503.9253, 23.8412, 90.0 },
	{2451.7251, -1410.9452, 23.8212, 90.0 },
	{2642.9937, -1458.6864, 30.2813, 90.0 },
	{2642.7847, -1430.8481, 30.2813, 90.0 },
	{2642.7217, -1268.2590, 49.4541, 90.0 },
	{2642.1868, -1239.5077, 49.8438, 90.0 },
	{2737.7815, -1315.7203, 51.0077, 90.0 },
	{2723.3191, -1328.7393, 48.6601, 90.0 },
	{2722.9404, -1582.4027, 15.8896, 90.0 },
	{2737.6526, -1564.5127, 20.7922, 90.0 },
	{2676.6914, -1462.6385, 30.3858, 90.0 },
	{2642.3757, -1067.6028, 69.4531, 90.0 },
	{1989.6840, -1030.6248, 24.8396, 90.0 },
	{1972.5956, -1222.0398, 25.0310, 90.0},
	{ 1813.5942, -1735.6245, 13.3828, 45.0 },
	{ 1828.7854, -1750.2850, 13.3828, 0.0 },
	{ 2046.8873, -1748.2388, 13.3828, 0.0 },
	{ 2175.6125, -1638.7552, 14.7322, 0.0 },
	{ 2252.0212, -1592.9293, 2.7347, 0.0 },
	{ 2058.0713, -1811.2554, 13.3828, 0.0 },
	{ 1760.4757, -1828.5929, 13.3828, 45.0 },
	{ 1688.7168, -1856.9003, 13.3828, 45.0 },
	{ 1594.2640, -1867.5999, 13.3828, 0.0 },
	{ 1049.7651, -1816.7489, 13.5915, 45.0 },
	{ 889.7949, -1770.1495, 13.3828, 0.0 },
	{ 801.9298, -1786.3522, 13.3057, 0.0 },
	{ 766.6042, -1777.7972, 12.8640, 0.0 },
	{ 83.8787, -1542.6871, 5.6306, 0.0 },
	{ 75.1096, -1533.3793, 5.2545, 0.0 },
	{ 40.7615, -1525.7382, 5.1920, 0.0 },
	{ 648.0573, -1586.4985, 15.5065, 0.0 },
	{ 670.4305, -1389.5850, 13.6168, 45.0 },
	{ 698.1785, -1410.1447, 13.4027, 45.0 },
	{ 1395.5315, -1406.7401, 13.3905, 0.0 },
	{ 1417.2698, -1396.2533, 13.3828, 0.0 },
	{ 1604.8142, -1445.5448, 13.3828, 0.0 },
	{ 1620.3564, -1160.5326, 23.8970, 0.0 },
	{ 1880.1550, -1047.6953, 23.6797, 45.0 },
	{ 2121.4116, -1082.5577, 24.2509, 45.0 },
	{ 2219.0979, -1115.2620, 25.6478, 45.0 },
	{ 2317.3169, -1149.0255, 26.8045, 0.0 },
	{ 2243.0964, -1384.0061, 23.8427, 0.0 },
	{ 2206.4390, -1647.3447, 15.2661, 0.0 },
	{ 2174.2524, -1751.6830, 13.3848, 0.0 },
	{ 1911.1361, -1755.7390, 13.3828, 0.0 },
	{ 2630.4563, -1256.0563, 49.6610, 0.0 },
	{ 2188.3042, -1385.3724, 23.8310, 0.0 },
	{ 2284.2844, -1381.7566, 24.0957, 0.0 },
	{ 2570.1814, -1251.1011, 45.9766, 0.0 }
};

new TireBinary[16][] = 
{
	{ "0000" }, 
	{ "0001" },
	{ "0010" },
	{ "0011" },
	{ "0100" },
	{ "0101" },
	{ "0110" },
	{ "0111" },
	{ "1000" },
	{ "1001" },
	{ "1010" },
	{ "1011" },
	{ "1100" },
	{ "1101" },
	{ "1110" },
	{ "1111" }
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
new TruckBType[MAX_PLAYERS];
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
#define FAMILYVEH 22

#define UPDLNOVEH 1
#define UPDLVEH 2

#define GATE 1
#define DOOR 2
#define DOCCELL 3

#define PUBTYPE 0
#define FACTYPE 1
#define GANGTYPE 2

#define TIMESTAMP 0
#define HOUR 1
#define MINUTE 2
#define SECOND 3
#define DAY 4
#define MONTH 5
#define YEAR 6
#define FULLTIME 7
#define FULLDATE 8
#define ALL 9

#define PD 1
#define FBI 2
#define NG 3
#define FD 4
#define MAYOR 7
#define HITMAN 8
#define NEWS 9
#define TAXI 10
#define DOC 17

#define TEAMGOV 1
#define TEAMGANG 2
#define TEAMVILLAIN 4
#define TEAMCIVILLAIN 3

new mSkinList = mS_INVALID_LISTID;
new fpsObj[MAX_PLAYERS];

new NowGTTime[MAX_PLAYERS];
new WaitGTString[MAX_PLAYERS][20][128];

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

new Float:PizzaPos[MAX_PLAYERS][3];
new Float:PizzaDistance[MAX_PLAYERS];
new PizzaGet[MAX_PLAYERS];
new PizzaVehicle[MAX_VEHICLES];
new PizzaCallTime[MAX_PLAYERS];

//Anti Car Repair
new CarRepairCheat[MAX_VEHICLES][4];
new CarCheatAttemping[MAX_PLAYERS];
new Float:CarHealthCheat[MAX_VEHICLES];

new DriverLicenseCar[MAX_PLAYERS];
new Float:DriverLicenseTime[MAX_PLAYERS];
new Timer:DriverLicenseLoop[MAX_PLAYERS];
new PlayerText:DriverLicenseTD[MAX_PLAYERS][5];
new Float:DriverLicensePos[10][3] = {
	{ 2054.9548, -1932.3621, 13.3908 }, //Start
	{ 1961.6324, -1932.2354, 13.3828 },
	{ 1961.6705, -2166.4866, 13.3828 },
	{ 1993.6191, -2226.5842, 13.0795 }, //LS's Airport
	{ 1879.9777, -2469.4734, 13.6028 }, //Start Driver License
	{ 1856.8535, -2409.0413, 13.6028 },
	{ 1849.5590, -2452.4497, 13.6028 },
	{ 1829.0403, -2413.6301, 13.6106 },
	{ 1834.8435, -2456.9551, 13.6106 }, // Finish Driver License Test
	{ 2054.8250, -1919.2405, 13.5469 } // Get Driver License
};

enum ColorFormat {
	RGBA,
	ARGB,
	RGB
}

// %0 means src and %1 byte number (starting from zero)
#define getByteN(%0,%1) ((%0 >> (%1*8)) & 0xFF)

stock getR(color, ColorFormat:format) {
	switch (format) {
	case RGBA: {
					  return getByteN(color, 3);
	}
	case ARGB: {
					  return getByteN(color, 2);
	}
	case RGB: {
					 return getByteN(color, 2);
	}
	}
	return 0;
}

stock getG(color, ColorFormat:format) {
	switch (format) {
	case RGBA: {
					  return getByteN(color, 2);
	}
	case ARGB: {
					  return getByteN(color, 1);
	}
	case RGB: {
					 return getByteN(color, 1);
	}
	}
	return 0; // unknown format
}

stock getB(color, ColorFormat:format) {
	switch (format) {
	case RGBA: {
					  return getByteN(color, 1);
	}
	case ARGB: {
					  return getByteN(color, 0);
	}
	case RGB: {
					 return getByteN(color, 0);
	}
	}
	return 0;
}

new VehicleColoursTableRGBA[256] =
{
	// The existing colours from San Andreas
	0x000000FF, 0xF5F5F5FF, 0x2A77A1FF, 0x840410FF, 0x263739FF, 0x86446EFF, 0xD78E10FF, 0x4C75B7FF, 0xBDBEC6FF, 0x5E7072FF,
	0x46597AFF, 0x656A79FF, 0x5D7E8DFF, 0x58595AFF, 0xD6DAD6FF, 0x9CA1A3FF, 0x335F3FFF, 0x730E1AFF, 0x7B0A2AFF, 0x9F9D94FF,
	0x3B4E78FF, 0x732E3EFF, 0x691E3BFF, 0x96918CFF, 0x515459FF, 0x3F3E45FF, 0xA5A9A7FF, 0x635C5AFF, 0x3D4A68FF, 0x979592FF,
	0x421F21FF, 0x5F272BFF, 0x8494ABFF, 0x767B7CFF, 0x646464FF, 0x5A5752FF, 0x252527FF, 0x2D3A35FF, 0x93A396FF, 0x6D7A88FF,
	0x221918FF, 0x6F675FFF, 0x7C1C2AFF, 0x5F0A15FF, 0x193826FF, 0x5D1B20FF, 0x9D9872FF, 0x7A7560FF, 0x989586FF, 0xADB0B0FF,
	0x848988FF, 0x304F45FF, 0x4D6268FF, 0x162248FF, 0x272F4BFF, 0x7D6256FF, 0x9EA4ABFF, 0x9C8D71FF, 0x6D1822FF, 0x4E6881FF,
	0x9C9C98FF, 0x917347FF, 0x661C26FF, 0x949D9FFF, 0xA4A7A5FF, 0x8E8C46FF, 0x341A1EFF, 0x6A7A8CFF, 0xAAAD8EFF, 0xAB988FFF,
	0x851F2EFF, 0x6F8297FF, 0x585853FF, 0x9AA790FF, 0x601A23FF, 0x20202CFF, 0xA4A096FF, 0xAA9D84FF, 0x78222BFF, 0x0E316DFF,
	0x722A3FFF, 0x7B715EFF, 0x741D28FF, 0x1E2E32FF, 0x4D322FFF, 0x7C1B44FF, 0x2E5B20FF, 0x395A83FF, 0x6D2837FF, 0xA7A28FFF,
	0xAFB1B1FF, 0x364155FF, 0x6D6C6EFF, 0x0F6A89FF, 0x204B6BFF, 0x2B3E57FF, 0x9B9F9DFF, 0x6C8495FF, 0x4D8495FF, 0xAE9B7FFF,
	0x406C8FFF, 0x1F253BFF, 0xAB9276FF, 0x134573FF, 0x96816CFF, 0x64686AFF, 0x105082FF, 0xA19983FF, 0x385694FF, 0x525661FF,
	0x7F6956FF, 0x8C929AFF, 0x596E87FF, 0x473532FF, 0x44624FFF, 0x730A27FF, 0x223457FF, 0x640D1BFF, 0xA3ADC6FF, 0x695853FF,
	0x9B8B80FF, 0x620B1CFF, 0x5B5D5EFF, 0x624428FF, 0x731827FF, 0x1B376DFF, 0xEC6AAEFF, 0x000000FF,
	// SA-MP extended colours (0.3x)
	0x177517FF, 0x210606FF, 0x125478FF, 0x452A0DFF, 0x571E1EFF, 0x010701FF, 0x25225AFF, 0x2C89AAFF, 0x8A4DBDFF, 0x35963AFF,
	0xB7B7B7FF, 0x464C8DFF, 0x84888CFF, 0x817867FF, 0x817A26FF, 0x6A506FFF, 0x583E6FFF, 0x8CB972FF, 0x824F78FF, 0x6D276AFF,
	0x1E1D13FF, 0x1E1306FF, 0x1F2518FF, 0x2C4531FF, 0x1E4C99FF, 0x2E5F43FF, 0x1E9948FF, 0x1E9999FF, 0x999976FF, 0x7C8499FF,
	0x992E1EFF, 0x2C1E08FF, 0x142407FF, 0x993E4DFF, 0x1E4C99FF, 0x198181FF, 0x1A292AFF, 0x16616FFF, 0x1B6687FF, 0x6C3F99FF,
	0x481A0EFF, 0x7A7399FF, 0x746D99FF, 0x53387EFF, 0x222407FF, 0x3E190CFF, 0x46210EFF, 0x991E1EFF, 0x8D4C8DFF, 0x805B80FF,
	0x7B3E7EFF, 0x3C1737FF, 0x733517FF, 0x781818FF, 0x83341AFF, 0x8E2F1CFF, 0x7E3E53FF, 0x7C6D7CFF, 0x020C02FF, 0x072407FF,
	0x163012FF, 0x16301BFF, 0x642B4FFF, 0x368452FF, 0x999590FF, 0x818D96FF, 0x99991EFF, 0x7F994CFF, 0x839292FF, 0x788222FF,
	0x2B3C99FF, 0x3A3A0BFF, 0x8A794EFF, 0x0E1F49FF, 0x15371CFF, 0x15273AFF, 0x375775FF, 0x060820FF, 0x071326FF, 0x20394BFF,
	0x2C5089FF, 0x15426CFF, 0x103250FF, 0x241663FF, 0x692015FF, 0x8C8D94FF, 0x516013FF, 0x090F02FF, 0x8C573AFF, 0x52888EFF,
	0x995C52FF, 0x99581EFF, 0x993A63FF, 0x998F4EFF, 0x99311EFF, 0x0D1842FF, 0x521E1EFF, 0x42420DFF, 0x4C991EFF, 0x082A1DFF,
	0x96821DFF, 0x197F19FF, 0x3B141FFF, 0x745217FF, 0x893F8DFF, 0x7E1A6CFF, 0x0B370BFF, 0x27450DFF, 0x071F24FF, 0x784573FF,
	0x8A653AFF, 0x732617FF, 0x319490FF, 0x56941DFF, 0x59163DFF, 0x1B8A2FFF, 0x38160BFF, 0x041804FF, 0x355D8EFF, 0x2E3F5BFF,
	0x561A28FF, 0x4E0E27FF, 0x706C67FF, 0x3B3E42FF, 0x2E2D33FF, 0x7B7E7DFF, 0x4A4442FF, 0x28344EFF
};

stock HexColorToVehColor(color, ColorFormat:format = RGBA) {
	new srcR = getR(color, format), srcG = getG(color, format), srcB = getB(color, format);
	new closerColorIdx = 0;
	new minTotal = 0xFFFFFF;

	for (new i; i < sizeof(VehicleColoursTableRGBA); i++) {
		new iR = getR(VehicleColoursTableRGBA[i], RGBA);
		new iG = getG(VehicleColoursTableRGBA[i], RGBA);
		new iB = getB(VehicleColoursTableRGBA[i], RGBA);

		new rDiff = floatround(floatabs(iR - srcR)),
			gDiff = floatround(floatabs(iG - srcG)),
			bDiff = floatround(floatabs(iB - srcB));

		new total = rDiff + gDiff + bDiff;

		if (total < minTotal) {
			minTotal = total;
			closerColorIdx = i;
		}
	}
	return closerColorIdx;
}
