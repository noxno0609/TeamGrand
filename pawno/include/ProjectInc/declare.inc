#include <YSI\y_timers>
#include <foreach>
#include <zones>
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
