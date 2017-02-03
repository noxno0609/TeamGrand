/*
 *
 *          -- Los Angeles Roleplay (Godfather edition) --
 *
 *
 *
 *                Los Angeles Roleplay by Ellis & Hoodstar.
 *         based on the original Godfather script by FeaR
 *  This is the fixable version of Los Angeles RolePlay by Brian_Furious aka Anthony_Prince
 *
 */
//======================= Credits: =============================================
// FeaR for original GF
// Ellis & Hoodstar for LA-RP since 1.0 version
// Brian_Furious for LA-RP modified and fixed the 3.0 Version
//======================= Extra Credits: =======================================
// Incognito for Streamer
// Virtual1ty for solve Max 12 Chars Name

#define SCRIPT_VERSION "LA-RP 3.0 Fixable"

//INCLUDE
#include <a_samp>
#include <a_mysql>
#include <core>
#include <float>
#include <time>
#include <file>
#include <utils>
#include <morphinc>
#include <streamer>
#include <zcmd>
#include <sscanf2>
#include <YSI\y_timers>
//MYSQLDEFINE
new MySQL:conn;

//DEFINE
#include <ProjectInc\declare>

#define DIALOG_REG 1
#define DIALOG_LOGIN 2

#define SCRIPT_OWNCARS 85 //
#define SCRIPT_MAXPLAYERS 50 //
#define SCRIPT_MAXHOUSES 36 //
#define MAX_BIZ 7 //
#define MAX_SBIZ 13 //
//==============================
//#define strcpy(%1,%2,%3) strmid(%1,%2,0,%3,strlen(%2)+1)
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#pragma semicolon 0
#define MAX_TRUNK_SLOTS		(5) // Is actually 4.
#define MAX_VEHICLE_MODELS	(70)
#define MAX_PLYVEH_RATIO	(20) // per player.
#define MAX_VEHICLE_PLATE	(7)
//==============================
#undef MAX_PLAYERS
#define MAX_PLAYERS SCRIPT_MAXPLAYERS
//==============================

#define MAX_STRING 255
#define CHECKPOINT_NONE 0
#define COLOR_ASKQ 0xFF0000FF
#define CHECKPOINT_HOME 12

// DMV Defines
#define DrivingTestCash 5000 // Edit this if needed. 5000 = the cash that you'll pay to take the driving test
#define TooSlow 120 // 120 = if the time is 110 or more, you are driving too slow. You may edit this if needed.
#define TooFast 105 // 105 = if the time is less than 105, you are driving too fast. You may edit this if needed.
#define MINVEHHP 900 // 900 = the minimum vehicle health the vehicle can have to pass the test. You may edit this if needed.

#define GasMax 100
#define RunOutTime 25000
#define RefuelWait 5000
#define CAR_AMOUNT 700 //Change to Your Vehicle Amount

#define GREEN 0x21DD00FF
#define RED 0xE60000FF
#define YELLOW 0xFFFF00FF
#define ORANGE 0xF97804FF
#define GRAY 0xCECECEFF
#define LIGHTBLUE 0x00C2ECFF 
#define cop_color 0xC2A2DAFF
#define COLOR_BLACK 0x000000FF
#define COLOR_NICERED 0xFF0000FF
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD6 0xF0F0F0FF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x9EC73DAA
#define COLOR_GROVE 0x00FF00FF
#define COLOR_RED 0xAA3333AA
#define COLOR_LIGHTRED 0xFF6347AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_LIGHTGREEN 0x9ACD32AA
#define COLOR_CYAN 0x00FFFFFF
#define COLOR_YELLOW 0xDABB3EAA
#define COLOR_YELLOW2 0xF5DEB3AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_DBLUE 0x2641FEAA
#define COLOR_ALLDEPT 0xFF8282AA
#define COLOR_NEWS 0x458E1DAA
//#define COLOR_OOC 0xE0FFFFAA
#define COLOR_OOC 0xB1C8FBAA
#define TEAM_CYAN 1
#define TEAM_BLUE 2
#define TEAM_GREEN 3
#define TEAM_ORANGE 4
#define TEAM_COR 5
#define TEAM_BAR 6
#define TEAM_TAT 7
#define TEAM_CUN 8
#define TEAM_STR 9
#define TEAM_HIT 10
#define TEAM_ADMIN 11
#define OBJECTIVE_COLOR 0x64000064
#define TEAM_GREEN_COLOR 0xFFFFFFAA
#define TEAM_JOB_COLOR 0xFFB6C1AA
#define TEAM_HIT_COLOR 0xFFFFFF00
#define TEAM_BLUE_COLOR 0x8D8DFF00
#define TEAM_RADIO_COLOR 0xF2D068FF
#define COLOR_ADD 0x63FF60AA
#define TEAM_GROVE_COLOR 0x00D900C8
#define TEAM_VAGOS_COLOR 0xFFC801C8
#define TEAM_BALLAS_COLOR 0xD900D3C8
#define TEAM_AZTECAS_COLOR 0x01FCFFC8
#define TEAM_CYAN_COLOR 0xFF8282AA
#define TEAM_ORANGE_COLOR 0xFF830000
#define TEAM_COR_COLOR 0x39393900
#define TEAM_BAR_COLOR 0x00D90000
#define TEAM_TAT_COLOR 0xBDCB9200
#define TEAM_CUN_COLOR 0xD900D300
#define TEAM_STR_COLOR 0x01FCFF00
#define TEAM_ADMIN_COLOR 0x00808000
#define COLOR_INVIS 0xAFAFAF00
#define COLOR_SPEC 0xBFC0C200
#pragma tabsize 0
#define COLOR_BLUE 0x2641FEAA
#define COLOR_DARKNICERED 0x9D000096
#define COLOR_LIGHT_BLUE 0x9FB1EEAA
#define COLOR_NEWBIE 0x7DAEFFFF
//FORWARD
forward RefreshMenuHeader(playerid,Menu:menu,text[]);
new Menu:burgermenu, Menu:chickenmenu, Menu:pizzamenu, Menu:donutshop;
new Menu:Guide, Menu:JobLocations, Menu:JobLocations2, Menu:Place;

forward CheckForWalkingTeleport(playerid);
forward ResetRoadblockTimer();
forward RemoveRoadblock(playerid);
forward BackupClear(playerid, calledbytimer);
/*forward IsAGangCar(carid);
forward IsAGangCar2(carid);
forward IsAGangCar3(carid);
forward IsAGangCar4(carid);
forward IsAGangCar5(carid);*/
forward IsABike(carid);
forward IsAOBike(carid);
forward IsATank(carid);
forward GateClose(playerid);
forward GateClose2();
forward GateClose3();
forward GateClose4();
forward GateClose5();
forward GateClose6();
//forward GateClose7();
forward elevator1(playerid);
forward elevator2(playerid);
forward LoadProperty();
forward LoadBizz();
forward LoadSBizz();
forward LoadStuff();
forward SaveStuff();
forward LoadCK();
forward SaveCK();
forward LoadFamilies();
forward SaveFamilies();
forward LoadTurfs();
forward SaveTurfs();
forward LoadIRC();
forward SaveIRC();
forward LoadPapers();
forward SavePapers();
forward LoadCar();
forward SaveCarCoords();
forward LoadBoxer();
forward SaveBoxer();
forward OnPropUpdate();
forward ExtortionBiz(bizid, money);
forward ExtortionSBiz(bizid, money);
forward JoinChannel(playerid, number, line[]);
forward JoinChannelNr(playerid, number);
forward IsAtClothShop(playerid);
forward IsAtGasStation(playerid);
forward IsAtFishPlace(playerid);
forward IsAtCookPlace(playerid);
forward IsAtBar(playerid);
forward SearchingHit(playerid);
forward DollahScoreUpdate();
forward SetPlayerSpawn(playerid);
forward SetupPlayerForClassSelection(playerid);
forward SetPlayerTeamFromClass(playerid,classid);
forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
forward PlayerToPointStripped(Float:radi, playerid, Float:x, Float:y, Float:z, Float:curx, Float:cury, Float:curz);
forward CrimInRange(Float:radi, playerid,copid);
forward SendEnemyMessage(color, string[]);
forward SendTeamBeepMessage(team, color, string[]);
forward ABroadCast(color,const string[],level);
forward CBroadCast(color, const string[], level);
forward DateProp(playerid);
forward GetClosestPlayer(p1);
forward IsPlayerInTurf(playerid, turfid);
forward LoadMission(playerid,name[]);
forward SaveMission(playerid,name[]);
forward PrintBizInfo(playerid,targetid);
forward PrintSBizInfo(playerid,targetid);
forward SetPlayerUnjail();
forward OtherTimer();
forward RingTonerRev();
forward RingToner();
forward HireCost(carid);
forward BanLog(string[]);
forward KickLog(string[]);
forward PayLog(string[]);
forward CKLog(string[]);
forward IsATruck(carid);
forward IsAPizzabike(carid);
forward IsABus(carid);
forward IsATowcar(carid);
forward IsAnAmbulance(carid);
forward IsACopCar(carid);
forward IsAnFbiCar(carid);
forward IsNgCar(carid);
forward IsAGovernmentCar(carid);
forward IsAHspdCar(carid);
forward IsAnOwnableCar(vehicleid);
forward IsAtDealership(playerid);
forward IsAtCarrental(playerid);
forward IsAPlane(carid);
forward IsABoat(carid);
forward IsAHarvest(carid);
forward IsADrugHarvest(carid);
forward IsASmuggleCar(carid);
forward IsASweeper(carid);
forward IsACop(playerid);
forward IsAPDMember(playerid);
forward IsAMember(playerid);
forward IsAnInstructor(playerid);
forward Spectator();
forward ConvertTicks(ticks);
forward Encrypt(string[]);
forward KartingEnded();
forward StartKarting();
forward PrepareKarting();
forward PaintballEnded();
forward StartPaintball();
forward PreparePaintball();
forward Float:GetDistanceBetweenPlayers(p1,p2);
forward GameModeExitFunc();
forward SetAllPlayerCheckpoint(Float:allx, Float:ally, Float:allz, Float:radi, num);
forward SetAllCopCheckpoint(Float:allx, Float:ally, Float:allz, Float:radi);
forward SetPlayerCriminal(playerid,declare,reason[]);
forward SetPlayerCriminalEx(playerid,declare,reason[]);
forward SetPlayerFree(playerid,declare,reason[]);
forward SetPlayerWeapons(playerid);
forward ShowStats(playerid,targetid);
forward SetPlayerToTeamColor(playerid);
forward GameModeInitExitFunc();
forward split(const strsrc[], strdest[][], delimiter);
forward OnPlayerLogin(playerid,password[]);
forward SavePlayer(playerid);
forward OnPlayerRegister(playerid, password[]);
forward BroadCast(color,const string[]);
forward OOCOff(color,const string[]);
forward OOCNews(color,const string[]);
forward SendJobMessage(job, color, string[]);
forward SendFamilyMessage(family, color, string[]);
forward SendNewFamilyMessage(family, color, string[]);
forward SendIRCMessage(channel, color, string[]);
forward SendTeamMessage(team, color, string[]);
forward SendRadioMessage(member, color, string[]);
forward SendAdminMessage(color, string[]);
forward AddCar(carcoords);
forward ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
forward ProxDetectorS(Float:radi, playerid, targetid);
forward ClearCK(ck);
forward ClearFamily(family);
forward ClearMarriage(playerid);
forward ClearPaper(paper);
forward ClearCrime(playerid);
forward FishCost(playerid, fish);
forward ClearFishes(playerid);
forward ClearFishID(playerid, fish);
forward ClearCooking(playerid);
forward ClearCookingID(playerid, cook);
forward ClearGroceries(playerid);
forward Lotto(number);
forward CarCheck();
forward CarInit();
forward CarTow(carid);
forward CarRespawn(carid);
forward LockCar(carid);
forward UnLockCar(carid);
forward InitLockDoors(playerid);
forward CheckGas();
forward Fillup();
forward StoppedVehicle();
forward SyncTime();
forward SyncUp();
forward SaveAccounts();
forward IsPlayerInZone(playerid, zoneid);
forward Production();
forward Checkprop();
forward PayDay();
forward ini_GetKey( line[] );
forward ini_GetValue( line[] );
forward PlayerPlayMusic(playerid);
forward StopMusic();
forward PlayerFixRadio(playerid);
forward PlayerFixRadio2();
forward HouseLevel(playerid);
forward CHouseLevel(houseid);
forward CustomPickups();
forward IdleKick();
forward SetCamBack(playerid);
forward FixHour(hour);
forward AddsOn();
forward IsPlayerInArea(playerid, Float:minx, Float:maxx, Float:miny, Float:maxy);
forward AdvertiseToPlayersAtBusStop(Float:stopX, Float:stopY, Float:stopZ, eastorwest);
forward SendBusRoute(playerid, eastorwest);
forward IsInBusrouteZone(playerid);
forward BusrouteEnd(playerid, vehicleid);
forward CreateFoodMenus();
forward OnPlayerEnterFood(playerid, foodid);
forward OnPlayerExitFood(playerid);
forward ClearChatbox(playerid, lines);
forward CreateGuideMenus();
forward Startup(playerid, vehicleid);
forward engine2(playerid);
forward busroutestoptimer(playerid);
forward CheckCarHealth();
forward StartingTheVehicle(playerid);
forward FarmerExit(playerid);
forward DrugFarmerExit(playerid);
forward LoadDrugSystem();
forward SaveDrugSystem();
forward LoadMatsSystem();
forward SaveMatsSystem();
forward LoadingDrugsForSmugglers(playerid);
forward SmugglerExit(playerid);
forward SafeGivePlayerMoney(plyid, amounttogive);
forward SafeGivePlayerWeapon(plyid, weaponid, ammo);
forward SafeResetPlayerMoney(plyid);
forward SafeResetPlayerWeapons(plyid);
forward UpdateWeaponSlots(plyid);
forward GlobalHackCheck();
forward BanAdd(bantype, sqlplayerid, ip[], hackamount);
forward UnsetFirstSpawn(playerid);
forward LoadHQLocks();
forward SaveHQLocks();
forward ClearKnock(playerid);
forward DrugEffectGone(playerid);
forward UsingDrugsUnset(playerid);
//forward UpdatePlayerPosition(playerid);
forward CrashPlayer(playerid);
forward UnsetAfterTutorial(playerid);
forward AfterSpray1(playerid);
forward AfterSpray2(playerid);
forward AfterSpray3(playerid);
forward AfterSpray4(playerid);
forward UnsetCrash(playerid);
forward backtoclothes(playerid);
forward RemovePlayerWeapon(playerid, weaponid);
forward SaveTrunk();
forward LoadTrunk();
forward UpdateBurgerPositions();
forward ShowMenuBurger(i);
forward UpdateChickenPositions();
forward ShowMenuChicken(i);
forward CanDriveThruAgain(playerid);
forward Float:GetDistance(playerid, Float:x, Float:y);
forward TraceLastCall();
forward ReportReset(playerid);
forward ReduceTimer(playerid);

//NEW
new gTeam[MAX_PLAYERS];
//------------------------------------------------------------------------------------------------------
//new CarAutolock[999];
//new cartrack[256];
//new street_zone;
new GangCar[MAX_PLAYERS];
new togtactical[MAX_PLAYERS];
new togauthorizetactical;
//new surenos;
//new black_yakuza;
//new nortenos;
//new jefferson_saints;
new pdgate1;
new pdgate2;
new pdgate3;
new tugate;
new lspddoor1;
new lspddoor2;
new armygate1;
new armygate2;
new fbigate;
new hspdgate;
new lucianogate;
//new iorgate;
/*new license_pu;
new license_pu2;
new license_pu3;
new license_pu4;
new license_pu5;*/
new Security = 0;
//new gPlayerUsingLoopingAnim[MAX_PLAYERS];
//new Text:txtAnimHelper;
new CreatedCars[100];
//new CreatedCar = 0;
new Tax = 0;
new TaxValue = 0;
new Jackpot = 0;
new StartingPaintballRound = 0;
new AnnouncedPaintballRound = 0;
new PaintballPlayers = 0;
new PaintballRound = 0;
new PaintballWinner = 999;
new PaintballWinnerKills = 0;
new StartingKartRound = 0;
new EndingKartRound = 0;
new AnnouncedKartRound = 0;
new KartingPlayers = 0;
new KartingRound = 0;
new FirstKartWinner = 999;
new SecondKartWinner = 999;
new ThirdKartWinner = 999;
new InRing = 0;
new RoundStarted = 0;
new BoxDelay = 0;
new Boxer1 = 255;
new Boxer2 = 255;
new TBoxer = 255;
new PlayerBoxing[MAX_PLAYERS];
new hitfound = 0;
new hitid = 999;
new Medics = 0;
new MedicCall = 999;
new MedicCallTime[MAX_PLAYERS];
new Mechanics = 0;
new MechanicCall = 999;
new MechanicCallTime[MAX_PLAYERS];
new TaxiDrivers = 0;
new TaxiCall = 999;
new TaxiCallTime[MAX_PLAYERS];
new TaxiAccepted[MAX_PLAYERS];
new BusDrivers = 0;
new BusCall = 999;
new ScriptMoney[MAX_PLAYERS];
new ScriptWeapons[MAX_PLAYERS][13];
new ScriptMoneyUpdated[MAX_PLAYERS];
new ScriptWeaponsUpdated[MAX_PLAYERS];
new BusCallTime[MAX_PLAYERS];
new BusAccepted[MAX_PLAYERS];
new TransportDuty[MAX_PLAYERS];
new TransportValue[MAX_PLAYERS];
new TransportMoney[MAX_PLAYERS];
new TransportTime[MAX_PLAYERS];
new TransportCost[MAX_PLAYERS];
new TransportDriver[MAX_PLAYERS];
new JobDuty[MAX_PLAYERS];
new RegistrationStep[MAX_PLAYERS];
new MapIconsShown[MAX_PLAYERS];
new OnCK[MAX_PLAYERS];
new GettingCK[MAX_PLAYERS];
new PlayerPaintballing[MAX_PLAYERS];
new PlayerPaintballKills[MAX_PLAYERS];
new PlayerKarting[MAX_PLAYERS];
new PlayerInKart[MAX_PLAYERS];
new SchoolSpawn[MAX_PLAYERS];
new TakingLesson[MAX_PLAYERS];
new UsedFind[MAX_PLAYERS];
new PlayersChannel[MAX_PLAYERS];
new PlayerOnMission[MAX_PLAYERS];
new MissionCheckpoint[MAX_PLAYERS];
new WatchingTV[MAX_PLAYERS];
new NoFuel[MAX_PLAYERS];
new MatsHolding[MAX_PLAYERS];
new DivorceOffer[MAX_PLAYERS];
new MarriageCeremoney[MAX_PLAYERS];
new ProposeOffer[MAX_PLAYERS];
new ProposedTo[MAX_PLAYERS];
new GotProposedBy[MAX_PLAYERS];
new MarryWitness[MAX_PLAYERS];
new MarryWitnessOffer[MAX_PLAYERS];
new TicketOffer[MAX_PLAYERS];
new TicketMoney[MAX_PLAYERS];
new PlayerStoned[MAX_PLAYERS];
//new ConsumingMoney[MAX_PLAYERS];
new BringingPaper[MAX_PLAYERS]; //Paper Boys must pick up a Paper first, then use /deliver
new GotPaper[MAX_PLAYERS]; //The player has a paper so he can use /read
new WritingPaper[MAX_PLAYERS]; //Used for onplayertext so he can type in lines
new WritingPaperNumber[MAX_PLAYERS]; //To which Paper in PaperInfo will it be written
new WritingLine[MAX_PLAYERS]; //Used for onplayertext to see which line he's at
new FishCount[MAX_PLAYERS];
new SpawnChange[MAX_PLAYERS];
new TutTime[MAX_PLAYERS];
new PlayerDrunk[MAX_PLAYERS];
new PlayerDrunkTime[MAX_PLAYERS];
new PlayerTazeTime[MAX_PLAYERS];
new FindTimePoints[MAX_PLAYERS];
new FindTime[MAX_PLAYERS];
new BoxWaitTime[MAX_PLAYERS];
new TestFishes[MAX_PLAYERS];
new PaperOffer[MAX_PLAYERS];
new BoxOffer[MAX_PLAYERS];
new CarOffer[MAX_PLAYERS];
new CarPrice[MAX_PLAYERS];
new CarID[MAX_PLAYERS];
new CarCalls[MAX_PLAYERS];
new GotHit[MAX_PLAYERS];
new GoChase[MAX_PLAYERS];
new GetChased[MAX_PLAYERS];
new OrderReady[MAX_PLAYERS];
new ConnectedToPC[MAX_PLAYERS];
new MedicTime[MAX_PLAYERS];
new NeedMedicTime[MAX_PLAYERS];
new MedicBill[MAX_PLAYERS];
new PlayerTied[MAX_PLAYERS];
new PlayerCuffed[MAX_PLAYERS];
new PlayerCuffedTime[MAX_PLAYERS];
new LiveOffer[MAX_PLAYERS];
new TalkingLive[MAX_PLAYERS];
new PlacedNews[MAX_PLAYERS];
new SelectChar[MAX_PLAYERS];
new SelectCharID[MAX_PLAYERS];
new SelectCharPlace[MAX_PLAYERS];
new ChosenSkin[MAX_PLAYERS];
new GettingJob[MAX_PLAYERS];
new GuardOffer[MAX_PLAYERS];
new GuardPrice[MAX_PLAYERS];
new ApprovedLawyer[MAX_PLAYERS];
new CallLawyer[MAX_PLAYERS];
new WantLawyer[MAX_PLAYERS];
new CurrentMoney[MAX_PLAYERS];
new KickPlayer[MAX_PLAYERS];
new Robbed[MAX_PLAYERS];
new RobbedTime[MAX_PLAYERS];
new CP[MAX_PLAYERS];
new MoneyMessage[MAX_PLAYERS];
new Condom[MAX_PLAYERS];
new Rope[MAX_PLAYERS];
new STDPlayer[MAX_PLAYERS];
new SexOffer[MAX_PLAYERS];
new SexPrice[MAX_PLAYERS];
new RepairOffer[MAX_PLAYERS];
new RepairPrice[MAX_PLAYERS];
new RefillOffer[MAX_PLAYERS];
new RefillPrice[MAX_PLAYERS];
new RepairCar[MAX_PLAYERS];
new DrugOffer[MAX_PLAYERS];
new DrugPrice[MAX_PLAYERS];
new DrugGram[MAX_PLAYERS];
new JailPrice[MAX_PLAYERS];
new WantedPoints[MAX_PLAYERS];
new WantedLevel[MAX_PLAYERS];
new togswat[MAX_PLAYERS];
new OnDuty[MAX_PLAYERS];
new gPlayerCheckpointStatus[MAX_PLAYERS];
new gPlayerLogged[MAX_PLAYERS];
new gPlayerLogTries[MAX_PLAYERS];
new gPlayerSpawned[MAX_PLAYERS];
new gActivePlayers[MAX_PLAYERS];
new gLastCar[301];
new gOoc[MAX_PLAYERS];
new gNews[MAX_PLAYERS];
new gFam[MAX_PLAYERS];
new BigEar[MAX_PLAYERS];
new Spectate[MAX_PLAYERS];
new CellTime[MAX_PLAYERS];
new StartTime[MAX_PLAYERS];
new HireCar[MAX_PLAYERS];
new SafeTime[MAX_PLAYERS];
new Specing[MAX_PLAYERS];
new HidePM[MAX_PLAYERS];
new PhoneOnline[MAX_PLAYERS];
new gDice[MAX_PLAYERS];
new gGas[MAX_PLAYERS];
new gSpeedo[MAX_PLAYERS];
new gSpentCash[MAX_PLAYERS];
new FirstSpawn[MAX_PLAYERS];
new SwitchKey[MAX_PLAYERS];
new Fixr[MAX_PLAYERS];
new Locator[MAX_PLAYERS];
new Mobile[MAX_PLAYERS];
new RingTone[MAX_PLAYERS];
new gPlayerAccount[MAX_PLAYERS];
new gPlayerMission[MAX_PLAYERS];
new BusrouteEast[MAX_PLAYERS][2];
new BusrouteWest[MAX_PLAYERS][2];
new Float:BusShowLocation[MAX_PLAYERS][4];
new BusShowLocationC[MAX_PLAYERS];
new InAFoodPlace[MAX_PLAYERS];
new gLastDriver[302];
new gCarLock[265];
new MissionPlayable = 0;
new togOOC = 0;
new adds = 1;
new addtimer = 60000;
new Float:rx, Float:ry, Float:rz;
new carselect[15];
new objstore[128];
new cbjstore[128];
new motd[256];
//new RStart;
new ghour = 0;
new gminute = 0;
new gsecond = 0;
new numplayers = 0;
new dollah = 0; // Amount player recieves on spawn.
new realtime = 1;
new wtime = 16;
//new levelcost = 5000;
new deathcost = 100;
new callcost = 2; //20 seconds
new realchat = 1;
new timeshift = -1;
new shifthour;
new othtimer;
new hackchecktimer;
new synctimer;
new newmistimer;
new unjailtimer;
new turftimer;
new pickuptimer;
new spectatetimer;
new idletimer;
new productiontimer;
new SetWorld;
new accountstimer;
new checkgastimer;
new stoppedvehtimer;
new checkcarhealthtimer;
//new updateplayerpos;
new cartimer;
new intrate = 1;
new levelexp = 4;
new idletime = 600000; //10 mins
new civnokill = 0;
new suecost = 100;
new cchargetime = 60;
new txtcost = 1;
new pickups;
new togauthorizeswat;
new PizzaBoys = 0;
new PizzaCall = 999;
new PizzaCallTime[MAX_PLAYERS];
new bPizza[MAX_PLAYERS];
new sPizza[MAX_PLAYERS];
new CIV[] = {7,19,20,23,73,101,122};
new STD1[] = {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3};
new STD2[] = {0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3};
new STD3[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3};
new STD4[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 3};
new SELLCAR1[] = { 250, 263, 274, 301, 309, 342, 368, 389, 402, 433, 502 };
new SELLCAR2[] = { 504, 509, 525, 531, 538, 544, 548, 555, 568, 577, 580 };
new SELLCAR3[] = { 586, 591, 594, 599, 603, 609, 611, 619, 623, 631, 633 };
new SELLCAR4[] = { 642, 648, 653, 661, 668, 672, 674, 687, 693, 698, 703 };
new Float:ChangePos[MAX_PLAYERS][3];
new ChangePos2[MAX_PLAYERS][2];
new Float:PlayerPos[MAX_PLAYERS][6];
new Float:TeleportDest[MAX_PLAYERS][3];
new Float:TelePos[MAX_PLAYERS][6];
new roadblocktimer = 0;
new engineOn[MAX_VEHICLES];
new vehicleEntered[MAX_PLAYERS][MAX_VEHICLES];
new gEngine[MAX_PLAYERS];
new FarmerVar[MAX_PLAYERS];
new FarmerPickup[MAX_PLAYERS][2];
new DrugFarmerVar[MAX_PLAYERS];
new DrugFarmerPickup[MAX_PLAYERS][2];
new JustStarted[MAX_PLAYERS];
new SmugglerWork[MAX_PLAYERS];
new SmuggledDrugs[MAX_PLAYERS];
new PayDaySecure[MAX_PLAYERS];
new JustDied[MAX_PLAYERS];
new KnockedDown[MAX_PLAYERS];
new UnidentifedCall[MAX_PLAYERS];
new LicenseOffer[MAX_PLAYERS];
new LicensePrice[MAX_PLAYERS];
new LicenseType[MAX_PLAYERS];
new DefaultWeather = 10;
new UsingDrugs[MAX_PLAYERS];
new AfterTutorial[MAX_PLAYERS];
new OwnableCarOffer[MAX_PLAYERS];
new OwnableCarID[MAX_PLAYERS];
new OwnableCarPrice[MAX_PLAYERS];
new BlindFold[MAX_PLAYERS];
new PlayerIsSweeping[MAX_PLAYERS];
// Trunk system
new vehTrunkCounter[MAX_VEHICLES] = 1;
new vehTrunk[MAX_VEHICLES][MAX_TRUNK_SLOTS];
new vehTrunkAmmo[MAX_VEHICLES][MAX_TRUNK_SLOTS];
new Float:vehTrunkArmour[MAX_VEHICLES];
// ------------
new VehicleWindows[MAX_VEHICLES] = 0;
new AdminDuty[MAX_PLAYERS];
new BurgerPickUp[9];
new ChickenPickUp[9];
new Menu:BurgerShot;
new Menu:CluckinBell;
new IsMenuShowed[MAX_PLAYERS] = 0;
new burgertimer;
new	chickentimer;
new pdtrace = 0;
new Float:pdtrace_x;
new Float:pdtrace_y;
new Float:pdtrace_z;
new emdtrace = 0;
new Float:emdtrace_x;
new Float:emdtrace_y;
new Float:emdtrace_z;
new tracetimer;
new JustReported[MAX_PLAYERS];
new PlayerNeedsHelp[MAX_PLAYERS];
new AdminSpec[MAX_PLAYERS];
new IsSmoking[MAX_PLAYERS];
new UsingSmokeAnim[MAX_PLAYERS];
new ReduceTime[MAX_PLAYERS];
new CreatingGun[MAX_PLAYERS];
new CreatingGunAmmo[MAX_PLAYERS];
new CreatingGunPrice[MAX_PLAYERS];
new IsPuttingMaterials[MAX_PLAYERS];
new IsTakingGun[MAX_PLAYERS];
//============================
new Text3D:HouseLabel[MAX_PLAYERS];
new Text3D:BizzLabel[MAX_PLAYERS];
new Text3D:SBizzLabel[MAX_PLAYERS];
new Gas[CAR_AMOUNT];

new Refueling[MAX_PLAYERS];
new SpeedMode = 1;
new UpdateSeconds = 1;

new Music[MAX_PLAYERS];
/*new Songs[7][1] = {
{1187},
{1185},
{1183},
{1097},
{1076},
{1068},
{1062}
};*/

new Float:BurgerDriveIn[6][3] = {
	{ 801.5522, -1628.91, 13.3828 },
	{ 1209.958, -896.7405, 42.9259 },
	{ -2341.86, 1021.184, 50.6953 },
	{ 2485.291, 2022.611, 10.8203 },
	{ 1859.496, 2084.797, 10.8203 },
	{ -2349.49, -152.182, 35.3203 }
};

new Float:ChickenDriveIn[3][3] = {
	{ 2409.651, -1488.65, 23.8281 },
	{ 2377.733, -1909.27, 13.3828 },
	{ 2375.014, 2021.186, 10.8203 }
};

new FishNamesNumber = 22;
new FishNames[22][20] = {
	{ "Jacket" },
	{ "Amberjack" },
	{ "Grouper" },
	{ "Red Snapper" },
	{ "Pants" },
	{ "Trout" },
	{ "Blue Marlin" },
	{ "Can" },
	{ "Mackeral" },
	{ "Sea Bass" },
	{ "Shoes" },
	{ "Pike" },
	{ "Sail Fish" },
	{ "Garbage" },
	{ "Tuna" },
	{ "Eel" },
	{ "Dolphin" },
	{ "Shark" },
	{ "Turtle" },
	{ "Catfish" },
	{ "Money Bag" },
	{ "Swordfish" }
};

new Float:PaintballSpawns[7][3] = {
	{ -394.8027, 2232.2317, 42.4297 },
	{ -430.8412, 2240.5371, 42.9834 },
	{ -369.2361, 2248.3127, 42.4844 },
	{ -350.8910, 2218.0215, 42.4912 },
	{ -384.0544, 2206.2908, 42.4235 },
	{ -395.7100, 2214.9480, 42.4297 },
	{ -445.3718, 2222.5481, 42.4297 }
};

new Float:gInviteSpawns[10][4] = {
	{ -1976.5912, 166.1818, 36.9623, 272.6393 },
	{ -1975.8610, 162.1945, 36.9623, 272.0126 },
	{ -1975.7461, 157.5404, 36.9623, 276.1093 },
	{ -1975.2136, 151.4920, 36.9623, 268.2993 },
	{ -1974.9963, 145.3430, 36.9623, 269.2628 },
	{ -1975.5842, 140.8170, 36.9623, 269.8895 },
	{ -1975.7874, 134.0368, 36.9623, 271.7696 },
	{ -1975.1681, 129.0926, 36.9623, 270.8531 },
	{ -1975.9069, 121.4700, 36.9623, 270.5631 },
	{ -1975.3311, 112.7078, 36.9623, 267.7665 }
};

new Float:gMedicSpawns[3][3] = {
	{ 348.9868, 165.0690, 1014.6947 },
	{ 348.8042, 162.5563, 1014.6947 },
	{ 348.8767, 159.9840, 1014.6947 }
};

new Float:gCopPlayerSpawns[2][3] = {
	{ 216.9725, 79.1339, 1005.0391 },
	{ 219.8852, 75.5487, 1005.0391 }
	//{614.8,-608.2,17.2},
	//{611.5,-607.8,17.2}
};

new Float:gMedPlayerSpawns[2][3] = {
	{ 1178.1, -1321.0, 14.1 },
	{ 1177.7, -1325.0, 14.0 }
};

new Float:gSweeperPoints[16][3] = {
	{ 2003.3517, -1730.5336, 13.1080 },
	{ 2243.8682, -1895.1603, 13.1057 },
	{ 2872.5264, -1507.8936, 10.5887 },
	{ 2733.4851, -1079.1128, 69.0215 },
	{ 2491.6882, -1096.9484, 48.1798 },
	{ 1973.2815, -1173.0474, 25.6866 },
	{ 1441.3285, -1038.8422, 23.4461 },
	{ 1041.5815, -776.1030, 104.3925 },
	{ 958.6799, -1034.2134, 29.8119 },
	{ 995.9623, -1351.8215, 13.0737 },
	{ 793.3896, -1583.4993, 13.1155 },
	{ 368.1902, -1977.2362, 7.3970 },
	{ 834.1572, -1794.8837, 13.5680 },
	{ 1243.4885, -1853.9174, 13.1080 },
	{ 1527.9438, -1663.3240, 13.1080 },
	{ 2083.6062, -1843.3563, 13.1080 }
};
new RandCars[20][1] = {
	{ 496 }, { 542 }, { 507 }, { 585 },
	{ 466 }, { 492 }, { 579 }, { 559 },
	{ 400 }, { 551 }, { 516 }, { 475 },
	{ 561 }, { 550 }, { 566 }, { 558 },
	{ 562 }, { 562 }, { 603 }, { 560 }
};


new RandLCars[1][1] = {
	{ 431 }// coach
};


new GunPrice[30][1] = {
	{ 500 }, //parachute
	{ 400 }, //golfclub
	{ 300 }, //nightstick
	{ 200 }, //knife
	{ 700 }, //baseballbat
	{ 300 }, //shovel
	{ 100 }, //poolcue
	{ 400 }, //purpledildo
	{ 780 }, //whitedildo
	{ 560 }, //longwhitedildo
	{ 530 }, //whitedildo2
	{ 200 }, //flowers
	{ 600 }, //cane
	{ 500 }, //sdpistol
	{ 1000 }, //colt45
	{ 3000 }, //deagle
	{ 2000 }, //Tec9
	{ 3000 }, //uzi
	{ 2500 }, //mp5
	{ 3000 }, //shotgun
	{ 6000 }, //spas12
	{ 4000 }, //sawnoff
	{ 5000 }, //ak47
	{ 5000 }, //m4
	{ 1000 }, //rifle
	{ 25 }, //pistolammo
	{ 40 }, //shotgunammo
	{ 25 }, //smgammo
	{ 40 }, //assaultammo
	{ 50 } //rifle
};

new JoinPed[69][1] = {
	{ 280 },//POLICE_FORCE
	{ 281 },
	{ 282 },
	{ 283 },
	{ 284 },
	{ 285 },
	{ 288 },
	{ 71 },
	{ 166 },
	{ 295 },
	{ 148 },
	{ 286 },//FBI/ATF
	{ 164 },
	{ 163 },
	{ 287 },//NATIONAL_GUARD
	{ 285 },
	{ 70 },//FIRE/AMBULANCE
	{ 274 },
	{ 275 },
	{ 276 },
	{ 277 },
	{ 278 },
	{ 279 },
	{ 292 },//SURENOS
	{ 114 },
	{ 115 },
	{ 175 },
	{ 174 },
	{ 116 },
	{ 173 },
	{ 176 },
	{ 124 },//LUCIANO
	{ 125 },
	{ 126 },
	{ 111 },
	{ 123 },
	{ 186 },
	{ 228 },
	{ 249 },//HITMANS
	{ 68 },
	{ 72 },
	{ 121 },
	{ 295 },
	{ 148 },//NEWS_REPORTERS
	{ 188 },
	{ 187 },
	{ 255 },//TAXI_CAB_COMPANY
	{ 253 },
	{ 153 },//DRIVING/FLYING_SCHOOL
	{ 156 },//DRIVING/FLYING_SCHOOL
	{ 206 },//DRIVING/FLYING_SCHOOL
	{ 221 },//DRIVING/FLYING_SCHOOL
	{ 19 },//nortenos
	{ 22 },
	{ 22 },
	{ 144 },
	{ 170 },
	{ 180 },
	{ 270 },//18TH_STREET_FAMYLY
	{ 271 },
	{ 269 },
	{ 105 },
	{ 106 },
	{ 107 },
	{ 66 },//Institute of Race
	{ 67 },
	{ 180 },
	{ 297 },
	{ 188 }
};

new CivMalePeds[52][1] = {
	// Male civilians down here (by Ellis)
	{ 2 },
	{ 47 },
	{ 48 },
	{ 50 },
	{ 58 },
	{ 60 },
	{ 68 },
	{ 72 },
	{ 73 },
	{ 80 },
	{ 81 },
	{ 82 },
	{ 83 },
	{ 95 },
	{ 100 },
	{ 101 },
	{ 102 },
	{ 103 },
	{ 104 },
	{ 108 },
	{ 109 },
	{ 110 },
	{ 121 },
	{ 122 },
	{ 123 },
	{ 135 },
	{ 142 },
	{ 143 },
	{ 144 },
	{ 146 },
	{ 153 },
	{ 154 },
	{ 155 },
	{ 156 },
	{ 158 },
	{ 159 },
	{ 160 },
	{ 161 },
	{ 170 },
	{ 179 },
	{ 180 },
	{ 189 },
	{ 202 },
	{ 203 },
	{ 204 },
	{ 258 },
	{ 259 },
	{ 260 },
	{ 293 },
	{ 295 },
	{ 296 },
	{ 297 }
};

new CivFemalePeds[33][1] = {
	// Female civilians down here (by Ellis)
	{ 55 },
	{ 56 },
	{ 63 },
	{ 69 },
	{ 76 },
	{ 85 },
	{ 91 },
	{ 93 },
	{ 131 },
	{ 141 },
	{ 148 },
	{ 150 },
	{ 151 },
	{ 152 },
	{ 157 },
	{ 169 },
	{ 172 },
	{ 190 },
	{ 192 },
	{ 193 },
	{ 194 },
	{ 195 },
	{ 198 },
	{ 201 },
	{ 214 },
	{ 216 },
	{ 219 },
	{ 225 },
	{ 233 },
	{ 237 },
	{ 251 },
	{ 263 },
	{ 298 }
};


new Peds[200][1] = {
	{ 7 },
	/*{288},//TEAM_ADMIN
	{286},{287},{228},{113},{120},{147},{294},{227},{61},{171},*/
	{ 247 },//CIVILIANS DOWN HERE
	{ 248 }, { 100 }, { 256 }, { 263 }, { 262 }, { 261 }, { 260 }, { 259 }, { 258 }, { 257 }, { 256 }, { 255 },
	{ 253 }, { 252 }, { 251 }, { 246 }, { 245 }, { 244 }, { 243 }, { 242 }, { 241 }, { 239 },
	{ 238 }, { 237 }, { 236 }, { 235 }, { 234 }, { 233 }, { 232 }, { 231 }, { 230 }, { 229 },
	{ 226 }, { 225 }, { 224 }, { 223 }, { 222 }, { 221 }, { 220 }, { 219 }, { 218 },
	{ 217 }, { 216 }, { 215 }, { 214 }, { 213 }, { 212 }, { 211 }, { 210 }, { 209 },
	{ 207 }, { 206 }, { 205 }, { 204 }, { 203 }, { 202 }, { 201 }, { 200 }, { 199 }, { 198 }, { 197 }, { 196 },
	{ 195 }, { 194 }, { 193 }, { 192 }, { 191 }, { 190 }, { 189 }, { 185 }, { 184 }, { 183 },
	{ 182 }, { 181 }, { 180 }, { 179 }, { 178 }, { 176 }, { 172 }, { 170 }, { 168 }, { 167 }, { 162 },
	{ 161 }, { 160 }, { 159 }, { 158 }, { 157 }, { 156 }, { 155 }, { 154 }, { 153 }, { 152 }, { 151 },
	{ 146 }, { 145 }, { 144 }, { 143 }, { 142 }, { 141 }, { 140 }, { 139 }, { 138 }, { 137 }, { 136 }, { 135 },
	{ 134 }, { 133 }, { 132 }, { 131 }, { 130 }, { 129 }, { 128 }, { 254 }, { 99 }, { 97 }, { 96 }, { 95 }, { 94 },
	{ 92 }, { 90 }, { 89 }, { 88 }, { 87 }, { 85 }, { 84 }, { 83 }, { 82 }, { 81 }, { 80 }, { 79 }, { 78 }, { 77 }, { 76 },
	{ 75 }, { 73 }, { 72 }, { 69 }, { 68 }, { 67 }, { 66 }, { 64 }, { 63 }, { 62 }, { 58 }, { 57 }, { 56 }, { 55 },
	{ 54 }, { 53 }, { 52 }, { 51 }, { 50 }, { 49 }, { 45 }, { 44 }, { 43 }, { 41 }, { 39 }, { 38 }, { 37 }, { 36 }, { 35 },
	{ 34 }, { 33 }, { 32 }, { 31 }, { 30 }, { 29 }, { 28 }, { 27 }, { 26 }, { 25 }, { 24 }, { 23 }, { 22 }, { 21 }, { 20 },
	{ 19 }, { 18 }, { 17 }, { 16 }, { 15 }, { 14 }, { 13 }, { 12 }, { 11 }, { 10 }, { 1 }, { 2 },
	{ 290 },//ROSE
	{ 291 },//PAUL
	{ 293 },//OGLOC
	{ 187 },
	{ 296 },//JIZZY
	{ 297 },//MADDOGG
	{ 298 },//CAT
	{ 299 }//ZERO
};

/*new Float:HouseCarSpawns[34][4] = {
{-2637.2544,165.0454,4.2919,179.9976},//House 2
{2064.4,-1694.4,13.1,271.1561},//House 1
{-2712.7625,870.3005,70.5348,89.1608},//House 2
{1109.8,-968.0,42.7,0.0},//house 3
{2497.6274,-2025.6306,13.2521,355.4281}, // House 4
{2645.0,-1990.8,13.1,180.0},//House - 5
{-2724.8965,914.8384,67.4253,110.1072},//house 6
{1910.5149,-1120.5304,25.4493,177.8350},//house 7
{828.8,-887.0,68.5,230.7095},//House 8
{2149.6,-1610.9,14.0,90.7904},//House 9
{760.1,-1687.8,4.3,180.6},//House 10
{645.5,-1616.1,14.9,0.0},//House 11
{-2635.2371,931.1931,71.5643,215.3709},//House 12
{-2665.9224,989.9724,64.6955,1.7814},//House 13
{959.5864,-901.0845,45.8584,177.3087},//House 14
{2445.8,-1326.8,23.6,18.4},//House 15
{2845.9,-1286.8,18.9,90.0},//house 16
{2159.8,-1803.9,13.3,271.4}, //House 17
{-2693.7847,132.3186,4.1676,89.5330},//House 18
{-2723.0105,977.7357,54.2926,359.9068},//House 19
{1514.0,-694.6,94.5,90.0},//House 20
{1246.7,-1107.6,25.5,266.4},//House 21
{831.7,-857.5,69.9,180.0},//House 22
{1007.9,-659.4,121.1,130.6194},//House 23
{1110.0,-726.4,100.1,90.0},//House 24
{259.7,-1221.0,74.7,202.0011},//House 25
{1463.7,-901.7,55.8,359.0},//house 26
{1440.1,-890.6,51.2,0.0},//house 27
{-2528.8298,2250.2998,4.8112,334.9590},//house 28
{-2554.7874,2270.5356,4.9064,333.9774}, //House 29
{-2371.1323,2438.4104,9.0698,159.2582},//House 30
{-2237.9492,893.7390,66.4872,89.7571},//House 31
{-2529.4817,-142.6608,19.7107,4.2929}, //House 32
{-2616.1897,-108.4479,4.1693,269.8246}//House 33
};*/


/*new CarSpawns[186][eCars] = {
{405,2205.2,-1177.0,25.7,270.8},//carid 90
{554,2205.1,-1169.1,25.7,270.8},
{426,1544.6674,16.3512,24.2420,277.0196},
{445,1287.3030,331.6524,19.5783,61.2593},
{492,2229.2,-1170.2,25.7,86.9},
{507,2228.9,-1162.7,25.7,87.8},
{545,2217.0,-1157.2,25.7,269.8},
{540,169.1929,-1342.3611,69.7396,180.4404},
{482,422.8060,-1263.5979,51.6681,21.4204},
{547,405.9748,-1264.3921,50.1237,24.2110},
{550,2242.3, -1235.4, 24.3,359.7513},
{551,749.8617,-549.1844,17.1578,2.3866},
{560,2106.4695,-1248.7920,24.0461,0.1524},
{566,2196.2891,-1277.7905,24.2147,180.4522},
{402,198.6057,-1437.2435,13.1844,318.3837},
{405,216.5521,-1431.4004,13.0853,132.5749},
{554,334.2231,-1343.7405,14.3828,209.9581},
{426,481.0428,-1320.8564,15.4095,35.6808},
{507,697.4343,-1230.9486,16.5063,298.7916},
{545,723.9850,-1121.5535,18.1450,333.9010},
{540,912.2176,-996.2035,38.1402,7.5764},
{482,982.1829,-921.8636,41.8776,262.3163},
{547,981.8715,-917.3546,41.5443,88.0589},
{550,1188.4082,-925.1859,42.8590,277.5563},
{474,1307.5226,-914.4717,39.0082,269.3765},
{405,1450.2,-937.1,36.2,269.6909}, //116
{492,2148.3257,-1175.2518,24.1959,269.6909},
{507,2161.4871,-1163.1450,23.6760,269.1628},
{545,2216.8965,-1165.9469,25.4697,89.8643},
{540,2348.2910,-1167.9983,27.3637,323.1586},
{482,2502.0388,-1134.9507,39.1953,150.9506},
{547,2909.4895,-1180.3746,11.0176,222.1346},
{550,2853.1858,-1326.8011,11.1511,278.9301},
{551,2797.2690,-1549.3374,10.4935,93.0282},
{533,2796.9031,-1567.2024,10.6386,272.4041},
{482,2813.2175,-1673.0276,9.6638,2.3369},
{547,2827.6736,-1703.9755,9.7308,77.2896},
{550,2809.3872,-1837.2391,9.7398,268.9880},
{551,2870.8789,-1943.2599,11.4834,359.2344},
{566,2411.5386,-2134.7576,13.9352,0.7795},
{554,1389.7467,-2695.9370,13.4164,121.1818},
{405,783.1359,-1601.8208,13.2577,270.9069},
{554,782.7205,-1619.3584,13.2653,93.0550},
{426,923.0841,-1361.7990,13.0324,181.1371},
{445,911.7986,-1352.7415,13.1543,359.3287},
{492,1174.6599,-922.1939,43.1189,276.8927},
{507,1363.0210,-1288.3124,13.2839,180.1453},
{545,1363.2723,-1260.8229,13.0954,179.5841},
{540,2383.5627,-1927.9207,13.2436,359.6281},
{482,2377.0374,-1927.8434,13.1071,0.7843},
{547,2391.7234,-1978.0658,13.1963,90.1736},
{550,2396.6899,-1966.8123,13.2793,271.6838},
{551,2391.1135,-1500.6554,23.6355,269.7709},
{560,2390.7446,-1490.9093,23.5335,271.1926},
{405,321.2212,-1809.3561,4.2627,179.7758},
{554,2358.0640,-59.2127,27.1269,182.6377},
{426,1354.6172,241.7501,19.2247,334.5147},
{445,499.4850,-1764.0182,5.3367,89.7930},
{492,646.4998,-1771.6411,13.2905,348.7706},
{507,740.4332,-1797.7659,13.9196,349.9927},//150
{545,652.4496,-1656.7273,14.4585,91.3294},
{540,546.0256,-1622.4747,16.4585,180.7857},
{482,438.9431,-1625.4088,25.7951,0.1850},
{547,453.3896,-1494.3240,30.7917,7.7513},
{550,487.6469,-1516.2312,20.0235,185.5384},
{551,300.5775,-1490.8882,24.3748,235.1359},
{560,297.9918,-1535.9011,24.3758,231.2773},
{566,524.0590,-1375.0093,15.8231,193.3626},
{405,598.9131,-1519.1414,14.8214,180.4083},
{554,593.2022,-1519.3578,14.9461,181.5466},
{426,733.5679,-1438.4880,13.3203,266.7551},
{445,770.4971,-1431.1127,13.3247,0.7436},
{492,735.9440,-1346.2430,13.3003,88.3069},
{507,736.8572,-1337.1550,13.3140,271.3832},
{545,856.7003,-1363.1852,13.4093,179.8542},//165
{482,888.1506,-1659.2727,13.3296,1.2414},
{547,879.1024,-1669.2560,13.3305,180.5853},
{550,888.0242,-1678.5981,13.3294,358.4990},
{551,920.4441,-1823.0966,12.3452,84.1821},
{560,986.5818,-1761.2992,13.4014,181.9385},
{566,1062.6744,-1757.9412,13.1956,89.0572},
{405,1084.3831,-1763.8369,13.1501,269.0443},
{554,1081.8948,-1629.9564,13.4064,90.0880},
{426,981.7941,-1523.5115,13.3379,267.2751},
{445,1014.7464,-1434.4586,13.3292,266.3129},
{492,2684.6,-1990.2,13.3,180.0931},
{507,2684.6,-2019.0,13.3 ,0.8777},
{545,1096.1,-1379.9,13.3,270.1909},//178
{540,1151.6812,-1203.2323,20.2889,273.5155},//179
{482,1182.2568,-1219.2407,18.4163,0.5578},
{547,1260.9978,-1187.1921,23.3559,183.3606},
{550,1331.9304,-1081.3899,24.9941,90.4092},
{551,1284.8755,-1525.5013,13.3451,269.4388},
{560,1279.1887,-1539.2032,13.3201,94.8070},
{566,1275.9120,-1646.7448,13.3273,267.2669},
{405,1318.2792,-1785.7821,13.2429,182.4215},
{554,1253.9153,-1833.3832,13.1734,175.3692},
{426,1279.2875,-1814.4156,13.1657,93.6385},
{445,1198.5004,-1835.2216,13.1820,93.6780},
{492,1462.7026,-1737.7279,13.2662,270.2439},
{507,1508.1047,-1737.7089,13.2418,270.0250},
{545,1618.0411,-1891.1044,13.3278,0.3364},
{540,1623.7291,-1892.7234,13.3307,180.0126},
{482,2189.4170,-2252.4854,13.2933,317.2735},
{547,371.4392,-2041.8478,7.3034,359.5139},
{550,1838.1904,-1871.3842,13.1703,358.5452},
{551,1841.4791,-1871.6549,13.1687,179.3825},
{560,1646.6588,-1695.6704,20.0420,88.7770},
{566,1671.7789,-1718.8323,20.0718,358.2389},
{566,1981.0780,-1986.3513,13.3275,2.1479},
{405,1987.6057,-1994.9520,13.3296,359.9128},
{554,1978.0371,-2066.7500,13.1640,358.2871},
{426,1984.7471,-2066.7776,13.1625,359.7226},
{445,1938.0565,-2086.8459,13.3429,268.3414},
{589,1947.1119,-2136.3887,13.3286,90.9804},
{507,1932.1523,-2141.5220,13.3429,1.8383},
{545,1793.9172,-2148.5300,13.3781,359.7861},
{540,1748.0751,-2084.2090,13.3324,0.4337},
{482,1560.5026,-2260.5457,13.3258,268.7398},
{547,1461.6943,-1505.1688,13.2541,356.9007},
{550,1426.4930,-1402.3170,13.1800,181.0290},
{551,1435.0645,-1325.6835,13.2580,270.9400},
{560,1513.9486,-1272.5691,14.2685,181.0697},
{566,1583.7561,-1338.7435,16.1896,359.8619},
{405,1573.8772,-1209.9202,17.1378,92.7502},
{554,1476.2012,-1120.3083,23.5660,359.9746},
{426,1430.2316,-1054.8555,22.8693,359.3625},
{445,1574.1168,-1036.7643,23.6151,145.6786},
{492,1617.6676,-1009.8663,23.6052,356.8697},
{507,1645.3188,-1036.5238,23.6027,0.7258},
{545,1735.2826,-1010.5402,23.6588,346.3133},
{540,1770.4874,-1060.9886,23.6658,179.2750},
{482,1739.9854,-1084.5490,23.6660,176.8026},
{547,1653.1766,-1134.8994,23.6110,178.6835},
{550,1617.3746,-1132.8293,23.6117,91.7300},
{551,1790.0190,-1292.9065,13.2653,267.2964},
{560,1754.3009,-1476.8170,13.2402,269.6320},
{554,2003.3417,-1121.4993,26.3879,357.4926},
{426,2084.2334,-1170.0986,24.2042,91.8975},
{445,2229.1128,-1357.8774,23.6930,268.2194},
{492,2229.2278,-1345.4033,23.6892,93.3009},
{507,2332.5684,-1362.4845,23.7297,358.1198},
{545,2384.1567,-1275.6326,23.9198,101.6528},
{540,2432.3149,-1226.0785,24.9941,17.9805},
{482,2426.9612,-1224.4158,25.0000,202.7159},
{547,2438.4309,-1321.6925,24.1225,269.7535},
{551,2612.9702,-1262.6970,48.2461,269.4752},
{560,2659.4529,-1428.4343,30.1790,266.5051},
{566,2659.7053,-1422.6743,30.1714,89.8159},
{405,2485.5313,-1556.1823,23.7478,178.8338},
{554,2478.7664,-1555.7006,23.7226,183.6043},
{426,2605.3967,-1365.8829,34.6461,359.9891},
{445,2754.7136,-1373.0253,40.1154,91.4169},
{492,2717.3662,-1468.0308,30.0894,1.0298},
{507,2816.7195,-1449.4285,15.9549,268.9106},
{545,2816.9937,-1441.5880,15.9544,90.7779},
{540,2681.9016,-1673.3879,9.1290,0.5605},
{482,2442.5845,-1642.7507,13.1644,180.3454},
{547,2361.3120,-1674.6146,13.2505,357.4959},
{550,2298.3535,-1633.7542,14.3849,80.8107},
{551,2297.9077,-1639.9464,14.4352,94.4292},
{560,2255.4045,-1664.5736,15.1304,74.6898},
{566,2234.1057,-1726.9386,13.1665,271.7536},
{405,2319.3833,-1716.6823,13.2518,359.8540},
{554,2474.5105,-1755.9194,13.2522,270.5967},
{426,2501.8213,-1754.2794,13.1208,176.4916}, //= 255
{445,2489.1560,-1952.6886,13.1366,178.1629},
{492,2495.4326,-1953.2922,13.1299,356.5514},
{507,2306.7168,-1989.6796,13.2639,184.8385},
{482,2056.1807,-1904.7751,13.2502,2.2910},
{550,2064.9871,-1919.1674,13.2504,180.8575},
{551,1886.4812,-2022.9338,13.0964,179.4265},
{560,1824.8976,-2019.8374,13.0875,272.5273},
{566,1942.1669,-1862.6425,13.2679,264.5590},
{405,1923.9409,-1795.5616,13.0877,90.0886},
{554,1807.0905,-1571.7120,13.1659,125.1048},
{426,1809.9016,-1676.0603,13.2422,180.7589},
{445,1809.6266,-1653.3402,13.2365,180.6530},
{492,1809.7056,-1660.3019,13.2380,180.6262},
{589,1978.4003,-1675.0157,15.6741,269.7336},
{545,1974.8230,-1693.5488,15.6741,92.1162},
{540,1929.2253,-1584.6954,13.2700,185.5542},
{482,1731.9725,-1590.8959,13.1630,77.7249},
{547,1721.5776,-1589.2834,13.1526,80.9057},
{550,1695.1428,-1519.2667,13.1671,0.7121},
{551,1694.7080,-1501.7454,13.1675,357.8150}
};
*/

//ENUM
enum SavePlayerPosEnum
{
Float:LastX,
	Float:LastY,
		  Float:LastZ
}
new SavePlayerPos[MAX_PLAYERS][SavePlayerPosEnum];

enum pBoxingStats
{
	TitelName[128],
	TitelWins,
	TitelLoses,
};
new Titel[pBoxingStats];

enum cCKInfo
{
	cSendername[20],
	cGiveplayer[20],
	cUsed,
};
new CKInfo[10][cCKInfo];

enum pPaperInfo
{
	PaperUsed,
	PaperMaker[20],
	PaperTitle[64],
	PaperText1[128],
	PaperText2[128],
	PaperText3[128],
	PaperText4[128],
	PaperText5[128],
	PaperText6[128],
	PaperText7[128],
	SafeSaving,
};
new PaperInfo[10][pPaperInfo];

enum pPaper
{
	pMaker[20],
	pTitle[64],
	pLine1[128],
	pLine2[128],
	pLine3[128],
	pLine4[128],
	pLine5[128],
	pLine6[128],
	pLine7[128],
};
new Paper[MAX_PLAYERS][pPaper];

enum fInfo
{
	FamilyTaken,
	FamilyName[20],
	FamilyMOTD[128],
	FamilyColor[20],
	FamilyLeader[MAX_PLAYER_NAME],
	FamilyMembers,
Float:FamilySpawn[4],
		FamilyInterior,
};
new FamilyInfo[10][fInfo];

enum zInfo
{
	zOwner[64],
	zColor[20],
Float:zMinX,
	Float:zMinY,
		  Float:zMaxX,
				 Float:zMaxY,
};
new TurfInfo[6][zInfo];
new Turfs[6];

enum pFishing
{
	pFish1[20],
	pFish2[20],
	pFish3[20],
	pFish4[20],
	pFish5[20],
	pWeight1,
	pWeight2,
	pWeight3,
	pWeight4,
	pWeight5,
	pFid1,
	pFid2,
	pFid3,
	pFid4,
	pFid5,
	pLastFish,
	pFishID,
	pLastWeight,
};
new Fishes[MAX_PLAYERS][pFishing];

enum pCooking
{
	pCook1[20],
	pCook2[20],
	pCook3[20],
	pCook4[20],
	pCook5[20],
	pCWeight1,
	pCWeight2,
	pCWeight3,
	pCWeight4,
	pCWeight5,
	pCookID1,
	pCookID2,
	pCookID3,
	pCookID4,
	pCookID5,
};
new Cooking[MAX_PLAYERS][pCooking];

enum pGroceries
{
	pChickens,
	pChicken,
	pHamburgers,
	pHamburger,
	pPizzas,
	pPizza,
};
new Groceries[MAX_PLAYERS][pGroceries];

enum pSpec
{
Float:Coords[3],
	Float:sPx,
		  Float:sPy,
				 Float:sPz,
							sPint,
							sLocal,
							sCam,
};

new Unspec[MAX_PLAYERS][pSpec];

enum eCars
{
	model_id,
Float:pos_x,
	Float:pos_y,
		  Float:pos_z,
				 Float:z_angle,
};

enum hNews
{
	hTaken1,
	hTaken2,
	hTaken3,
	hTaken4,
	hTaken5,
	hAdd1[128],
	hAdd2[128],
	hAdd3[128],
	hAdd4[128],
	hAdd5[128],
	hContact1[128],
	hContact2[128],
	hContact3[128],
	hContact4[128],
	hContact5[128],
};
new News[hNews];

const noteSize1 = 5;
const noteSize2 = 128;
const noteSize = noteSize1 * noteSize2;
enum pInfo
{
	pKey[128],
	pLevel,
	pAdmin,
	pHelper,
	pDonateRank,
	gPupgrade,
	pConnectTime,
	pReg,
	pSex,
	pAge,
	pOrigin,
	pCK,
	pMuted,
	pExp,
	pCash,
	pAccount,
	pCrimes,
	pKills,
	pDeaths,
	pArrested,
	pWantedDeaths,
	pPhoneBook,
	pLottoNr,
	pFishes,
	pBiggestFish,
	pJob,
	pPayCheck,
	pHeadValue,
	pJailed,
	pJailTime,
	pMats,
	pDrugs,
	pLeader,
	pMember,
	pFMember,
	pRank,
	pChar,
	//pContractTime,
	pDetSkill,
	pSexSkill,
	pBoxSkill,
	pLawSkill,
	pMechSkill,
	pJackSkill,
	pCarSkill,
	pNewsSkill,
	pDrugsSkill,
	pCookSkill,
	pFishSkill,
Float:pHealth,
	Float:pSHealth,
			  pInt,
			  pLocal,
			  pTeam,
			  pModel,
			  pPnumber,
			  pPhousekey,
			  pPcarkey[3],
			  pGangKey,
			  pPbiskey,
		  Float:pPos_x,
			  Float:pPos_y,
					 Float:pPos_z,
								pCarLic,
								pFlyLic,
								pBoatLic,
								pFishLic,
								pGunLic,
								pGun[4],
								pAmmo[4],
								pCarTime,
								pPayDay,
								pPayDayHad,
								pWatch,
								pCrashed,
								pWins,
								pLoses,
								pAlcoholPerk,
								pDrugPerk,
								pMiserPerk,
								pPainPerk,
								pTraderPerk,
								pTut,
								pMissionNr,
								pWarns,
								pVirWorld,
								pFuel,
								pMarried,
								pMarriedTo[128],
								pFishTool,
								pNote[noteSize],
								pNotes[5],
								pInvWeapon,
								pInvAmmo,
								pLighter,
								pCigarettes,
								pRequestingBackup,
								pRoadblock,
								pMask,
								pMaskuse,
								pHideNumber,
								pSpeaker,
								pLocked
								//pSQLID,
};
new PlayerInfo[MAX_PLAYERS][pInfo];

#define pNote][%1][%2] pNote][((%1)*noteSize2)+(%2)]

enum p2Info
{
	HouseEntered,
	CallCost,
};
new PlayerInfo2[p2Info][MAX_PLAYERS];

enum hInfo
{
	Float:hEntrancex,
	Float:hEntrancey,
	Float:hEntrancez,
	Float:hExitx,
	Float:hExity,
	Float:hExitz,
	hHealthx,
	hHealthy,
	hHealthz,
	hArmourx,
	hArmoury,
	hArmourz,
	hOwner[MAX_PLAYER_NAME],
	hDiscription[MAX_PLAYER_NAME],
	hValue,
	hHel,
	hArm,
	hInt,
	hLock,
	hOwned,
	hRooms,
	hRent,
	hRentabil,
	hTakings,
	hVec,
	hVcol1,
	hVcol2,
	hDate,
	hLevel,
	hWorld
};

new HouseInfo[SCRIPT_MAXHOUSES][hInfo];

enum cInfo
{
	cModel,
Float:cLocationx,
	Float:cLocationy,
		  Float:cLocationz,
				 Float:cAngle,
							cColorOne,
							cColorTwo,
							cOwner[MAX_PLAYER_NAME],
							cDescription[MAX_PLAYER_NAME],
							cValue,
							cLicense,
							cRegistration,
							cOwned,
							cLock,
};

new CarInfo[SCRIPT_OWNCARS][cInfo];

enum bInfo
{
	bOwned,
	bOwner[64],
	bMessage[128],
	bExtortion[MAX_PLAYER_NAME],
Float:bEntranceX,
	Float:bEntranceY,
		  Float:bEntranceZ,
				 Float:bExitX,
						Float:bExitY,
							  Float:bExitZ,
										 bLevelNeeded,
										 bBuyPrice,
										 bEntranceCost,
										 bTill,
										 bLocked,
										 bInterior,
										 bProducts,
										 bMaxProducts,
										 bPriceProd,
};
new BizzInfo[MAX_BIZ][bInfo];

enum sbInfo
{
	sbOwned,
	sbOwner[64],
	sbMessage[128],
	sbExtortion[MAX_PLAYER_NAME],
Float:sbEntranceX,
	Float:sbEntranceY,
		  Float:sbEntranceZ,
					 sbLevelNeeded,
					 sbBuyPrice,
					 sbEntranceCost,
					 sbTill,
					 sbLocked,
					 sbInterior,
					 sbProducts,
					 sbMaxProducts,
					 sbPriceProd,
};
new SBizzInfo[MAX_SBIZ][sbInfo];

enum pHaul
{
	pCapasity,
	pLoad,
};

new PlayerHaul[113][pHaul];

enum pCrime
{
	pBplayer[32],
	pAccusing[32],
	pAccusedof[32],
	pVictim[32],
};
new PlayerCrime[MAX_PLAYERS][pCrime];

enum mInfo
{
	mTitle[128],
	mText1[128],
	mText2[128],
	mText3[128],
	mText4[128],
	mText5[128],
	mText6[128],
	mText7[128],
	mText8[128],
	mText9[128],
	mText10[128],
	mText11[128],
	mText12[128],
	mText13[128],
	mText14[128],
	mText15[128],
	mText16[128],
	mText17[128],
	mText18[128],
	mGText1[128],
	mGText2[128],
	mGText3[128],
	mGText4[128],
	mGText5[128],
	mGText6[128],
Float:mCP1[3],
	Float:mCP2[3],
		  Float:mCP3[3],
				 Float:mCP4[3],
						Float:mCP5[3],
							  Float:mCP6[3],
										 mReward,
										 mToggle,
};
new MissionInfo[mInfo];

enum kInfo
{
	kTitle[128],
	kMaker[MAX_PLAYER_NAME],
	kText1[128],
	kText2[128],
	kText3[128],
	kText4[128],
	kText5[128],
	kText6[128],
	kText7[128],
	kText8[128],
	kText9[128],
	kText10[128],
	kText11[128],
	kText12[128],
	kText13[128],
	kText14[128],
	kText15[128],
	kText16[128],
	kText17[128],
	kText18[128],
	kGText1[128],
	kGText2[128],
	kGText3[128],
	kGText4[128],
	kGText5[128],
	kGText6[128],
Float:kCP1[3],
	Float:kCP2[3],
		  Float:kCP3[3],
				 Float:kCP4[3],
						Float:kCP5[3],
							  Float:kCP6[3],
										 kNumber,
										 kReward,
										 kToggle,
};
new PlayMission[kInfo];

enum iInfo
{
	iAdmin[128],
	iMOTD[128],
	iPassword[128],
	iNeedPass,
	iLock,
	iPlayers,
};
new IRCInfo[10][iInfo];

enum dDrug
{
	DrugAmmount,
};
new drugsys[dDrug];

enum dMats
{
	MatsAmmount,
};
new matssys[dMats];

enum hqLocks
{
	surlock,
	luclock,
	stlock,
	iolock,
};
new hqlock[hqLocks];

main()
{
	print("\n");
	print("\tLos Angeles Roleplay ");
	print("----------------------------------------");
	print("\tBy: Team Grand");
	print("\tAuthor: Ellis & Hoodstar");
	print("\n");
}

#include <ProjectInc\onevent>

//CONNECTMYSQL
forward ConnectMySQL();
public ConnectMySQL()
{
	conn = mysql_connect_file();
	mysql_log(ERROR);
	if (mysql_errno(conn) == 0)
		print("[MySQL] Connection successful!\n");
	else
		print("[MySQL] Connection failed!\n");
}

//SAVE+LOAD
public SaveAccounts()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			SavePlayer(i);
			/*if (PlayerInfo[i][pJob] > 0)
			{
				if (PlayerInfo[i][pContractTime] < 25)
				{
					PlayerInfo[i][pContractTime] ++;
				}
			}*/
		}
	}
}
public SavePlayer(playerid)
{
	if (IsPlayerConnected(playerid))
	{
		if (gPlayerLogged[playerid])
		{
			new playername3[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername3, sizeof(playername3));

			//Save Befor Update
			PlayerInfo[playerid][pCash] = GetPlayerMoney(playerid);
			GetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
			if ((PlayerInfo[playerid][pPos_x] == 0.0 && PlayerInfo[playerid][pPos_y] == 0.0 && PlayerInfo[playerid][pPos_z] == 0.0))
			{
				PlayerInfo[playerid][pPos_x] = 1684.9;
				PlayerInfo[playerid][pPos_y] = -2244.5;
				PlayerInfo[playerid][pPos_z] = 13.5;
			}
			if (Spectate[playerid] != 255)
			{
				PlayerInfo[playerid][pPos_x] = Unspec[playerid][sPx];
				PlayerInfo[playerid][pPos_y] = Unspec[playerid][sPy];
				PlayerInfo[playerid][pPos_z] = Unspec[playerid][sPz];
				PlayerInfo[playerid][pInt] = Unspec[playerid][sPint];
				PlayerInfo[playerid][pLocal] = Unspec[playerid][sLocal];
			}
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			PlayerInfo[playerid][pPos_x] = x;
			PlayerInfo[playerid][pPos_y] = y;
			PlayerInfo[playerid][pPos_z] = z;
			if (PlayerInfo[playerid][pDonateRank] < 1) { PlayerInfo[playerid][pFuel] = 0; }

			//Query
			new sql[3000];
			format(sql, sizeof(sql), "UPDATE user SET \
				Level=%d,\
				AdminLevel=%d,\
				HelperLevel=%d,\
				DonateRank=%d,\
				UpgradePoints=%d,\
				ConnectedTime=%d,\
				Registered=%d,\
				Sex=%d,\
				Age=%d,\
				Origin=%d,\
				CK=%d,\
				Muted=%d,\
				Respect=%d,\
				`Money`=%d,\
				Bank=%d,\
				Crimes=%d,\
				Kills=%d,\
				Deaths=%d,\
				Arrested=%d,", 
				PlayerInfo[playerid][pLevel],
				PlayerInfo[playerid][pAdmin],
				PlayerInfo[playerid][pHelper],
				PlayerInfo[playerid][pDonateRank],
				PlayerInfo[playerid][gPupgrade],
				PlayerInfo[playerid][pConnectTime],
				PlayerInfo[playerid][pReg],
				PlayerInfo[playerid][pSex],
				PlayerInfo[playerid][pAge],
				PlayerInfo[playerid][pOrigin],
				PlayerInfo[playerid][pCK],
				PlayerInfo[playerid][pMuted],
				PlayerInfo[playerid][pExp],
				PlayerInfo[playerid][pCash],
				PlayerInfo[playerid][pAccount],
				PlayerInfo[playerid][pCrimes],
				PlayerInfo[playerid][pKills],
				PlayerInfo[playerid][pDeaths],
				PlayerInfo[playerid][pArrested]);

			format(sql, sizeof(sql), "%s \
				WantedDeaths=%d,\
				Phonebook=%d,\
				LottoNr=%d,\
				Fishes=%d,\
				BiggestFish=%d,\
				Job=%d,\
				Paycheck=%d,\
				HeadValue=%d,\
				Jailed=%d,\
				JailTime=%d,\
				Materials=%d,\
				Drugs=%d,\
				Leader=%d,\
				Member=%d,\
				FMember=%d,\
				Rank=%d,\
				`Char`=%d,",
				sql,
				PlayerInfo[playerid][pWantedDeaths],
				PlayerInfo[playerid][pPhoneBook],
				PlayerInfo[playerid][pLottoNr],
				PlayerInfo[playerid][pFishes],
				PlayerInfo[playerid][pBiggestFish],
				PlayerInfo[playerid][pJob],
				PlayerInfo[playerid][pPayCheck],
				PlayerInfo[playerid][pHeadValue],
				PlayerInfo[playerid][pJailed],
				PlayerInfo[playerid][pJailTime],
				PlayerInfo[playerid][pMats],
				PlayerInfo[playerid][pDrugs],
				PlayerInfo[playerid][pLeader], 
				PlayerInfo[playerid][pMember],
				PlayerInfo[playerid][pFMember],
				PlayerInfo[playerid][pRank],
				PlayerInfo[playerid][pChar]);
				/*PlayerInfo[playerid][pContractTime]*/

			format(sql, sizeof(sql), "%s \
				DetSkill=%d,\
				SexSkill=%d,\
				BoxSkill=%d,\
				LawSkill=%d,\
				MechSkill=%d,\
				JackSkill=%d,\
				CarSkill=%d,\
				NewsSkill=%d,\
				DrugsSkill=%d,\
				CookSkill=%d,\
				FishSkill=%d,\
				pSHealth=%f,\
				pHealth=%f,\
				`Int`=%d,\
				Local=%d,\
				`Team`=%d,\
				Model=%d,\
				PhoneNr=%d,",
				sql,
				PlayerInfo[playerid][pDetSkill],
				PlayerInfo[playerid][pSexSkill],
				PlayerInfo[playerid][pBoxSkill],
				PlayerInfo[playerid][pLawSkill],
				PlayerInfo[playerid][pMechSkill],
				PlayerInfo[playerid][pJackSkill],
				PlayerInfo[playerid][pCarSkill],
				PlayerInfo[playerid][pNewsSkill],
				PlayerInfo[playerid][pDrugsSkill],
				PlayerInfo[playerid][pCookSkill],
				PlayerInfo[playerid][pFishSkill],
				PlayerInfo[playerid][pSHealth],
				PlayerInfo[playerid][pHealth],
				PlayerInfo[playerid][pInt],
				PlayerInfo[playerid][pLocal],
				PlayerInfo[playerid][pTeam],
				PlayerInfo[playerid][pModel],
				PlayerInfo[playerid][pPnumber]);

			format(sql, sizeof(sql), "%s \
				Car=%d,\
				Car2=%d,\
				Car3=%d,\
				House=%d,\
				Biz=%d,\
				Pos_x=%f,\
				Pos_y=%f,\
				Pos_z=%f,\
				CarLic=%d,\
				FlyLic=%d,\
				BoatLic=%d,\
				FishLic=%d,\
				GunLic=%d,\
				CarTime=%d,\
				PayDay=%d,\
				PayDayHad=%d,\
				Watch=%d,\
				Crashed=%d,",
				sql,
				PlayerInfo[playerid][pPcarkey][0],
				PlayerInfo[playerid][pPcarkey][1],
				PlayerInfo[playerid][pPcarkey][2],
				PlayerInfo[playerid][pPhousekey],
				PlayerInfo[playerid][pPbiskey],
				PlayerInfo[playerid][pPos_x],
				PlayerInfo[playerid][pPos_y],
				PlayerInfo[playerid][pPos_z],
				PlayerInfo[playerid][pCarLic],
				PlayerInfo[playerid][pFlyLic],
				PlayerInfo[playerid][pBoatLic],
				PlayerInfo[playerid][pFishLic],
				PlayerInfo[playerid][pGunLic],
				PlayerInfo[playerid][pCarTime],
				PlayerInfo[playerid][pPayDay],
				PlayerInfo[playerid][pPayDayHad],
				PlayerInfo[playerid][pWatch],
				PlayerInfo[playerid][pCrashed]);

			for (new i = 1; i < 6; i++)
			{
				if (i < 5)
				{
					format(sql, sizeof(sql), "%s Gun%d=%d,", sql, i, PlayerInfo[playerid][pGun][i - 1]);
					format(sql, sizeof(sql), "%s Ammo%d=%d,", sql, i, PlayerInfo[playerid][pAmmo][i - 1]);
				}
				format(sql, sizeof(sql), "%s Note%d='%s',", sql, i, PlayerInfo[playerid][pNote][i - 1]);
				format(sql, sizeof(sql), "%s Note%ds=%d,", sql, i, PlayerInfo[playerid][pNotes][i - 1]);
			}
		
			format(sql, sizeof(sql), "%s \
				Wins=%d,\
				Loses=%d,\
				AlcoholPerk=%d,\
				DrugPerk=%d,\
				MiserPerk=%d,\
				PainPerk=%d,\
				TraderPerk=%d,\
				Tutorial=%d,\
				Mission=%d,\
				Warnings=%d,\
				VirWorld=%d,\
				Fuel=%d,\
				Married=%d,\
				MarriedTo='%s',\
				FishTool=%d,\
				InvWeapon=%d,\
				InvAmmo=%d,\
				Lighter=%d,\
				Cigarettes=%d,\
				Locked=%d,\
				HouseEntered=%d WHERE `Name` = '%s'",
				sql,
				PlayerInfo[playerid][pWins],
				PlayerInfo[playerid][pLoses],
				PlayerInfo[playerid][pAlcoholPerk],
				PlayerInfo[playerid][pDrugPerk],
				PlayerInfo[playerid][pMiserPerk],
				PlayerInfo[playerid][pPainPerk],
				PlayerInfo[playerid][pTraderPerk],
				PlayerInfo[playerid][pTut],
				PlayerInfo[playerid][pMissionNr],
				PlayerInfo[playerid][pWarns],
				PlayerInfo[playerid][pVirWorld],
				PlayerInfo[playerid][pFuel],
				PlayerInfo[playerid][pMarried],
				PlayerInfo[playerid][pMarriedTo],
				PlayerInfo[playerid][pFishTool],
				PlayerInfo[playerid][pInvWeapon],
				PlayerInfo[playerid][pInvAmmo],
				PlayerInfo[playerid][pLighter],
				PlayerInfo[playerid][pCigarettes],
				PlayerInfo[playerid][pLocked],
				PlayerInfo2[HouseEntered][playerid],
				playername3);

			mysql_query(conn, sql);
		}
	}
	return 1;
}
public SaveMission(playerid, name[])
{
	if (IsPlayerConnected(playerid))
	{
		new coordsstring[256];
		new missionname[64];
		new var[128];
		new makername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, makername, sizeof(makername));
		new rand = random(999);
		if (rand == 0) { rand = 1; }
		new number = rand;
		if (MissionInfo[mToggle] == 0 || MissionInfo[mToggle] == 1) {}
		else { MissionInfo[mToggle] = 1; }
		format(missionname, sizeof(missionname), "%s.mis", name);
		new File: hFile = fopen(missionname, io_write);
		format(var, 128, "Title=%s\n", MissionInfo[mTitle]); fwrite(hFile, var);
		format(var, 128, "Maker=%s\n", makername); fwrite(hFile, var);
		format(var, 128, "Text1=%s\n", MissionInfo[mText1]); fwrite(hFile, var);
		format(var, 128, "Text2=%s\n", MissionInfo[mText2]); fwrite(hFile, var);
		format(var, 128, "Text3=%s\n", MissionInfo[mText3]); fwrite(hFile, var);
		format(var, 128, "Text4=%s\n", MissionInfo[mText4]); fwrite(hFile, var);
		format(var, 128, "Text5=%s\n", MissionInfo[mText5]); fwrite(hFile, var);
		format(var, 128, "Text6=%s\n", MissionInfo[mText6]); fwrite(hFile, var);
		format(var, 128, "Text7=%s\n", MissionInfo[mText7]); fwrite(hFile, var);
		format(var, 128, "Text8=%s\n", MissionInfo[mText8]); fwrite(hFile, var);
		format(var, 128, "Text9=%s\n", MissionInfo[mText9]); fwrite(hFile, var);
		format(var, 128, "Text10=%s\n", MissionInfo[mText10]); fwrite(hFile, var);
		format(var, 128, "Text11=%s\n", MissionInfo[mText11]); fwrite(hFile, var);
		format(var, 128, "Text12=%s\n", MissionInfo[mText12]); fwrite(hFile, var);
		format(var, 128, "Text13=%s\n", MissionInfo[mText13]); fwrite(hFile, var);
		format(var, 128, "Text14=%s\n", MissionInfo[mText14]); fwrite(hFile, var);
		format(var, 128, "Text15=%s\n", MissionInfo[mText15]); fwrite(hFile, var);
		format(var, 128, "Text16=%s\n", MissionInfo[mText16]); fwrite(hFile, var);
		format(var, 128, "Text17=%s\n", MissionInfo[mText17]); fwrite(hFile, var);
		format(var, 128, "Text18=%s\n", MissionInfo[mText18]); fwrite(hFile, var);
		format(var, 128, "GText1=%s\n", MissionInfo[mGText1]); fwrite(hFile, var);
		format(var, 128, "GText2=%s\n", MissionInfo[mGText2]); fwrite(hFile, var);
		format(var, 128, "GText3=%s\n", MissionInfo[mGText3]); fwrite(hFile, var);
		format(var, 128, "GText4=%s\n", MissionInfo[mGText4]); fwrite(hFile, var);
		format(var, 128, "GText5=%s\n", MissionInfo[mGText5]); fwrite(hFile, var);
		format(var, 128, "GText6=%s\n", MissionInfo[mGText6]); fwrite(hFile, var);
		format(var, 128, "CP1X=%f\n", MissionInfo[mCP1][0]); fwrite(hFile, var);
		format(var, 128, "CP1Y=%f\n", MissionInfo[mCP1][1]); fwrite(hFile, var);
		format(var, 128, "CP1Z=%f\n", MissionInfo[mCP1][2]); fwrite(hFile, var);
		format(var, 128, "CP2X=%f\n", MissionInfo[mCP2][0]); fwrite(hFile, var);
		format(var, 128, "CP2Y=%f\n", MissionInfo[mCP2][1]); fwrite(hFile, var);
		format(var, 128, "CP2Z=%f\n", MissionInfo[mCP2][2]); fwrite(hFile, var);
		format(var, 128, "CP3X=%f\n", MissionInfo[mCP3][0]); fwrite(hFile, var);
		format(var, 128, "CP3Y=%f\n", MissionInfo[mCP3][1]); fwrite(hFile, var);
		format(var, 128, "CP3Z=%f\n", MissionInfo[mCP3][2]); fwrite(hFile, var);
		format(var, 128, "CP4X=%f\n", MissionInfo[mCP4][0]); fwrite(hFile, var);
		format(var, 128, "CP4Y=%f\n", MissionInfo[mCP4][1]); fwrite(hFile, var);
		format(var, 128, "CP4Z=%f\n", MissionInfo[mCP4][2]); fwrite(hFile, var);
		format(var, 128, "CP5X=%f\n", MissionInfo[mCP5][0]); fwrite(hFile, var);
		format(var, 128, "CP5Y=%f\n", MissionInfo[mCP5][1]); fwrite(hFile, var);
		format(var, 128, "CP5Z=%f\n", MissionInfo[mCP5][2]); fwrite(hFile, var);
		format(var, 128, "CP6X=%f\n", MissionInfo[mCP6][0]); fwrite(hFile, var);
		format(var, 128, "CP6Y=%f\n", MissionInfo[mCP6][1]); fwrite(hFile, var);
		format(var, 128, "CP6Z=%f\n", MissionInfo[mCP6][2]); fwrite(hFile, var);
		format(var, 128, "Number=%d\n", number); fwrite(hFile, var);
		format(var, 128, "Reward=%d\n", MissionInfo[mReward]); fwrite(hFile, var);
		format(var, 128, "Toggle=%d\n", MissionInfo[mToggle]); fwrite(hFile, var);
		fclose(hFile);
		format(coordsstring, sizeof(coordsstring), "%s Mission Saved.", name);
		SendClientMessage(playerid, COLOR_GREEN, coordsstring);
	}
	return 1;
}
public SaveBoxer()
{
	new coordsstring[256];
	format(coordsstring, sizeof(coordsstring), "%d,%s,%d", Titel[TitelWins], Titel[TitelName], Titel[TitelLoses]);
	new File: file2 = fopen("boxer.ini", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public SaveStuff()
{
	new coordsstring[256];
	format(coordsstring, sizeof(coordsstring), "%d,%d,%d,%d", Jackpot, Tax, TaxValue, Security);
	new File: file2 = fopen("stuff.ini", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public SaveTurfs()
{
	new idx;
	new File: file2;
	while (idx < sizeof(TurfInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%s|%s|%f|%f|%f|%f|%f|%f\n",
			TurfInfo[idx][zOwner],
			TurfInfo[idx][zColor],
			TurfInfo[idx][zMinX],
			TurfInfo[idx][zMinY],
			TurfInfo[idx][zMaxX],
			TurfInfo[idx][zMaxY]);
		if (idx == 0)
		{
			file2 = fopen("turfs.cfg", io_write);
		}
		else
		{
			file2 = fopen("turfs.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}
public SaveCK()
{
	new idx;
	new File: file2;
	while (idx < sizeof(CKInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%s|%s|%d\n",
			CKInfo[idx][cSendername],
			CKInfo[idx][cGiveplayer],
			CKInfo[idx][cUsed]);
		if (idx == 0)
		{
			file2 = fopen("ck.cfg", io_write);
		}
		else
		{
			file2 = fopen("ck.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}
public SaveIRC()
{
	new idx;
	new File: file2;
	while (idx < sizeof(IRCInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%s|%s|%s|%d|%d\n",
			IRCInfo[idx][iAdmin],
			IRCInfo[idx][iMOTD],
			IRCInfo[idx][iPassword],
			IRCInfo[idx][iNeedPass],
			IRCInfo[idx][iLock]);
		if (idx == 0)
		{
			file2 = fopen("channels.cfg", io_write);
		}
		else
		{
			file2 = fopen("channels.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}
public SaveFamilies()
{
	new idx;
	new File: file2;
	while (idx < sizeof(FamilyInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%d|%s|%s|%s|%s|%d|%f|%f|%f|%f|%d\n",
			FamilyInfo[idx][FamilyTaken],
			FamilyInfo[idx][FamilyName],
			FamilyInfo[idx][FamilyMOTD],
			FamilyInfo[idx][FamilyColor],
			FamilyInfo[idx][FamilyLeader],
			FamilyInfo[idx][FamilyMembers],
			FamilyInfo[idx][FamilySpawn][0],
			FamilyInfo[idx][FamilySpawn][1],
			FamilyInfo[idx][FamilySpawn][2],
			FamilyInfo[idx][FamilySpawn][3],
			FamilyInfo[idx][FamilyInterior]);
		if (idx == 0)
		{
			file2 = fopen("families.cfg", io_write);
		}
		else
		{
			file2 = fopen("families.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}
public SavePapers()
{
	new idx;
	new File: file2;
	while (idx < sizeof(IRCInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%d|%s|%s|%s|%s|%s|%s|%s|%s|%s|%d\n",
			PaperInfo[idx][PaperUsed],
			PaperInfo[idx][PaperMaker],
			PaperInfo[idx][PaperTitle],
			PaperInfo[idx][PaperText1],
			PaperInfo[idx][PaperText2],
			PaperInfo[idx][PaperText3],
			PaperInfo[idx][PaperText4],
			PaperInfo[idx][PaperText5],
			PaperInfo[idx][PaperText6],
			PaperInfo[idx][PaperText7],
			PaperInfo[idx][SafeSaving]);
		if (idx == 0)
		{
			file2 = fopen("papers.cfg", io_write);
		}
		else
		{
			file2 = fopen("papers.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}
public SaveCarCoords()
{
	new idx;
	new File: file2;
	while (idx < sizeof(CarInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%d|%f|%f|%f|%f|%d|%d\n",
			CarInfo[idx][cModel],
			CarInfo[idx][cLocationx],
			CarInfo[idx][cLocationy],
			CarInfo[idx][cLocationz],
			CarInfo[idx][cAngle],
			CarInfo[idx][cColorOne],
			CarInfo[idx][cColorTwo]);
		if (idx == 0)
		{
			file2 = fopen("cars.cfg", io_write);
		}
		else
		{
			file2 = fopen("cars.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}
public SaveDrugSystem()
{
	new coordsstring[256];
	format(coordsstring, sizeof(coordsstring), "%d", drugsys[DrugAmmount]);
	new File: file2 = fopen("drugs_system.ini", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public SaveMatsSystem()
{
	new coordsstring[256];
	format(coordsstring, sizeof(coordsstring), "%d", matssys[MatsAmmount]);
	new File: file2 = fopen("mats_system.ini", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public SaveHQLocks()
{
	new coordsstring[256];
	format(coordsstring, sizeof(coordsstring), "%d,%d,%d,%d", hqlock[surlock], hqlock[luclock], hqlock[stlock], hqlock[iolock]);
	new File: file2 = fopen("hq_locks.ini", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public SaveTrunk()
{
	new idx;
	new File: file2;
	idx = 1;
	while (idx < sizeof(CarInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%i,%i,%i,%i,%i,%i,%i,%i,%i,%f\n",
			vehTrunk[idx][1],
			vehTrunkAmmo[idx][1],
			vehTrunk[idx][2],
			vehTrunkAmmo[idx][2],
			vehTrunk[idx][3],
			vehTrunkAmmo[idx][3],
			vehTrunk[idx][4],
			vehTrunkAmmo[idx][4],
			vehTrunkCounter[idx],
			vehTrunkArmour[idx]);
		if (idx == 1)
		{
			file2 = fopen("trunk.cfg", io_write);
		}
		else
		{
			file2 = fopen("trunk.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}

public LoadMission(playerid, name[])
{
	if (IsPlayerConnected(playerid))
	{
		new strFromFile2[128];
		new missionname[64];
		format(missionname, sizeof(missionname), "%s.mis", name);
		new File: file = fopen(missionname, io_read);
		if (file)
		{
			new key[256], val[256];
			new Data[256];
			while (fread(file, Data, sizeof(Data)))
			{
				key = ini_GetKey(Data);
				if (strcmp(key, "Title", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kTitle], val, 0, strlen(val), 255); }
				if (strcmp(key, "Maker", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kMaker], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text1", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText1], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text2", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText2], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text3", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText3], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text4", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText4], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text5", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText5], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text6", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText6], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text7", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText7], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text8", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText8], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text9", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText9], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text10", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText10], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text11", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText11], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text12", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText12], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text13", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText13], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text14", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText14], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text15", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText15], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text16", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText16], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text17", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText17], val, 0, strlen(val), 255); }
				if (strcmp(key, "Text18", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kText18], val, 0, strlen(val), 255); }
				if (strcmp(key, "GText1", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kGText1], val, 0, strlen(val), 255); }
				if (strcmp(key, "GText2", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kGText2], val, 0, strlen(val), 255); }
				if (strcmp(key, "GText3", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kGText3], val, 0, strlen(val), 255); }
				if (strcmp(key, "GText4", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kGText4], val, 0, strlen(val), 255); }
				if (strcmp(key, "GText5", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kGText5], val, 0, strlen(val), 255); }
				if (strcmp(key, "GText6", true) == 0) { val = ini_GetValue(Data); strmid(PlayMission[kGText6], val, 0, strlen(val), 255); }
				if (strcmp(key, "CP1X", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP1][0] = floatstr(val); }
				if (strcmp(key, "CP1Y", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP1][1] = floatstr(val); }
				if (strcmp(key, "CP1Z", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP1][2] = floatstr(val); }
				if (strcmp(key, "CP2X", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP2][0] = floatstr(val); }
				if (strcmp(key, "CP2Y", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP2][1] = floatstr(val); }
				if (strcmp(key, "CP2Z", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP2][2] = floatstr(val); }
				if (strcmp(key, "CP3X", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP3][0] = floatstr(val); }
				if (strcmp(key, "CP3Y", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP3][1] = floatstr(val); }
				if (strcmp(key, "CP3Z", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP3][2] = floatstr(val); }
				if (strcmp(key, "CP4X", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP4][0] = floatstr(val); }
				if (strcmp(key, "CP4Y", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP4][1] = floatstr(val); }
				if (strcmp(key, "CP4Z", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP4][2] = floatstr(val); }
				if (strcmp(key, "CP5X", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP5][0] = floatstr(val); }
				if (strcmp(key, "CP5Y", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP5][1] = floatstr(val); }
				if (strcmp(key, "CP5Z", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP5][2] = floatstr(val); }
				if (strcmp(key, "CP6X", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP6][0] = floatstr(val); }
				if (strcmp(key, "CP6Y", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP6][1] = floatstr(val); }
				if (strcmp(key, "CP6Z", true) == 0) { val = ini_GetValue(Data); PlayMission[kCP6][2] = floatstr(val); }
				if (strcmp(key, "Number", true) == 0) { val = ini_GetValue(Data); PlayMission[kNumber] = strval(val); }
				if (strcmp(key, "Reward", true) == 0) { val = ini_GetValue(Data); PlayMission[kReward] = strval(val); }
				if (strcmp(key, "Toggle", true) == 0) { val = ini_GetValue(Data); PlayMission[kToggle] = strval(val); }
			}
			fclose(file);
			format(strFromFile2, sizeof(strFromFile2), "%s Mission Loaded.", name);
			SendClientMessage(playerid, COLOR_GREEN, strFromFile2);
			format(strFromFile2, sizeof(strFromFile2), "Mission Available: %s, By : %s | Reward: $%d", PlayMission[kTitle], PlayMission[kMaker], PlayMission[kReward]);
			SendClientMessageToAll(COLOR_GREEN, strFromFile2);
			MissionPlayable = PlayMission[kNumber];
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREEN, "Mission File not found.");
		}
	}
	return 1;
}
public LoadBoxer()
{
	new arrCoords[3][64];
	new strFromFile2[256];
	new File: file = fopen("boxer.ini", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, ',');
		Titel[TitelWins] = strval(arrCoords[0]);
		strmid(Titel[TitelName], arrCoords[1], 0, strlen(arrCoords[1]), 255);
		Titel[TitelLoses] = strval(arrCoords[2]);
		fclose(file);
	}
	return 1;
}
public LoadStuff()
{
	new arrCoords[4][64];
	new strFromFile2[256];
	new File: file = fopen("stuff.ini", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, ',');
		Jackpot = strval(arrCoords[0]);
		Tax = strval(arrCoords[1]);
		TaxValue = strval(arrCoords[2]);
		Security = strval(arrCoords[3]);
		fclose(file);
		if (Security == 0 || Security == 1)
		{
		}
		else
		{
			GameModeExit();
		}
	}
	else
	{
		GameModeExit();
	}
	return 1;
}
public LoadTurfs()
{
	new arrCoords[6][64];
	new strFromFile2[256];
	new File: file = fopen("turfs.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(TurfInfo))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			strmid(TurfInfo[idx][zOwner], arrCoords[0], 0, strlen(arrCoords[0]), 255);
			strmid(TurfInfo[idx][zColor], arrCoords[1], 0, strlen(arrCoords[1]), 255);
			TurfInfo[idx][zMinX] = floatstr(arrCoords[2]);
			TurfInfo[idx][zMinY] = floatstr(arrCoords[3]);
			TurfInfo[idx][zMaxX] = floatstr(arrCoords[4]);
			TurfInfo[idx][zMaxY] = floatstr(arrCoords[5]);
			//printf("Turf:%d Name: %s Owner:%s MinX:%f MinY:%f MinZ:%f MaxX:%f MaxY:%f MaxZ:%f\n",
			//idx,TurfInfo[idx][zName],TurfInfo[idx][zOwner],TurfInfo[idx][zMinX],TurfInfo[idx][zMinY],TurfInfo[idx][zMinZ],TurfInfo[idx][zMaxX],TurfInfo[idx][zMaxY],TurfInfo[idx][zMaxZ]);
			idx++;
		}
		fclose(file);
	}
	return 1;
}
public LoadCK()
{
	new arrCoords[3][64];
	new strFromFile2[256];
	new File: file = fopen("ck.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(CKInfo))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			strmid(CKInfo[idx][cSendername], arrCoords[0], 0, strlen(arrCoords[0]), 255);
			strmid(CKInfo[idx][cGiveplayer], arrCoords[1], 0, strlen(arrCoords[1]), 255);
			CKInfo[idx][cUsed] = strval(arrCoords[2]);
			printf("CK:%d Taken: %d Sendername:%s Giveplayer: %s",
				idx, CKInfo[idx][cUsed], CKInfo[idx][cSendername], CKInfo[idx][cGiveplayer]);
			idx++;
		}
		fclose(file);
	}
	return 1;
}
public LoadIRC()
{
	new arrCoords[5][64];
	new strFromFile2[256];
	new File: file = fopen("channels.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(IRCInfo))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			strmid(IRCInfo[idx][iAdmin], arrCoords[0], 0, strlen(arrCoords[0]), 255);
			strmid(IRCInfo[idx][iMOTD], arrCoords[1], 0, strlen(arrCoords[1]), 255);
			strmid(IRCInfo[idx][iPassword], arrCoords[2], 0, strlen(arrCoords[2]), 255);
			IRCInfo[idx][iNeedPass] = strval(arrCoords[3]);
			IRCInfo[idx][iLock] = strval(arrCoords[4]);
			printf("IRC:%d Admin:%s MOTD: %s Password: %s NeedPass: %d Lock: %d", idx, IRCInfo[idx][iAdmin], IRCInfo[idx][iMOTD], IRCInfo[idx][iPassword], IRCInfo[idx][iNeedPass], IRCInfo[idx][iLock]);
			idx++;
		}
		fclose(file);
	}
	return 1;
}
public LoadFamilies()
{
	new arrCoords[11][64];
	new strFromFile2[256];
	new File: file = fopen("families.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(FamilyInfo))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			FamilyInfo[idx][FamilyTaken] = strval(arrCoords[0]);
			strmid(FamilyInfo[idx][FamilyName], arrCoords[1], 0, strlen(arrCoords[1]), 255);
			strmid(FamilyInfo[idx][FamilyMOTD], arrCoords[2], 0, strlen(arrCoords[2]), 255);
			strmid(FamilyInfo[idx][FamilyColor], arrCoords[3], 0, strlen(arrCoords[3]), 255);
			strmid(FamilyInfo[idx][FamilyLeader], arrCoords[4], 0, strlen(arrCoords[4]), 255);
			FamilyInfo[idx][FamilyMembers] = strval(arrCoords[5]);
			FamilyInfo[idx][FamilySpawn][0] = floatstr(arrCoords[6]);
			FamilyInfo[idx][FamilySpawn][1] = floatstr(arrCoords[7]);
			FamilyInfo[idx][FamilySpawn][2] = floatstr(arrCoords[8]);
			FamilyInfo[idx][FamilySpawn][3] = floatstr(arrCoords[9]);
			FamilyInfo[idx][FamilyInterior] = strval(arrCoords[10]);
			printf("Family:%d Taken: %d Name:%s MOTD:%s Leader:%s Members:%d SpawnX:%f SpawnY:%f SpawnZ:%f Int:%d",
				idx, FamilyInfo[idx][FamilyTaken], FamilyInfo[idx][FamilyName], FamilyInfo[idx][FamilyMOTD], FamilyInfo[idx][FamilyLeader], FamilyInfo[idx][FamilyMembers], FamilyInfo[idx][FamilySpawn][0], FamilyInfo[idx][FamilySpawn][1], FamilyInfo[idx][FamilySpawn][2], FamilyInfo[idx][FamilyInterior]);
			idx++;
		}
		fclose(file);
	}
	return 1;
}
public LoadPapers()
{
	new arrCoords[11][64];
	new strFromFile2[256];
	new File: file = fopen("papers.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(PaperInfo))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			PaperInfo[idx][PaperUsed] = strval(arrCoords[0]);
			strmid(PaperInfo[idx][PaperMaker], arrCoords[1], 0, strlen(arrCoords[1]), 255);
			strmid(PaperInfo[idx][PaperTitle], arrCoords[2], 0, strlen(arrCoords[2]), 255);
			strmid(PaperInfo[idx][PaperText1], arrCoords[3], 0, strlen(arrCoords[3]), 255);
			strmid(PaperInfo[idx][PaperText2], arrCoords[4], 0, strlen(arrCoords[4]), 255);
			strmid(PaperInfo[idx][PaperText3], arrCoords[5], 0, strlen(arrCoords[5]), 255);
			strmid(PaperInfo[idx][PaperText4], arrCoords[6], 0, strlen(arrCoords[6]), 255);
			strmid(PaperInfo[idx][PaperText5], arrCoords[7], 0, strlen(arrCoords[7]), 255);
			strmid(PaperInfo[idx][PaperText6], arrCoords[8], 0, strlen(arrCoords[8]), 255);
			strmid(PaperInfo[idx][PaperText7], arrCoords[9], 0, strlen(arrCoords[9]), 255);
			PaperInfo[idx][SafeSaving] = strval(arrCoords[10]);
			printf("Paper:%d Used: %d Maker:%s Title: %s Text1: %s Text2: %s Text3: %s Text4: %s Text5: %s Text6: %s Text7: %s",
				idx, PaperInfo[idx][PaperUsed], PaperInfo[idx][PaperMaker], PaperInfo[idx][PaperTitle], PaperInfo[idx][PaperText1], PaperInfo[idx][PaperText2], PaperInfo[idx][PaperText3], PaperInfo[idx][PaperText4], PaperInfo[idx][PaperText5], PaperInfo[idx][PaperText6], PaperInfo[idx][PaperText7]);
			idx++;
		}
		fclose(file);
	}
	return 1;
}
public LoadCar()
{
	new arrCoords[13][64];
	new strFromFile2[256];
	new File: file = fopen("cars.cfg", io_read);
	if (file)
	{
		new idx = 184;
		while (idx < sizeof(CarInfo))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, ',');
			CarInfo[idx][cModel] = strval(arrCoords[0]);
			CarInfo[idx][cLocationx] = floatstr(arrCoords[1]);
			CarInfo[idx][cLocationy] = floatstr(arrCoords[2]);
			CarInfo[idx][cLocationz] = floatstr(arrCoords[3]);
			CarInfo[idx][cAngle] = floatstr(arrCoords[4]);
			CarInfo[idx][cColorOne] = strval(arrCoords[5]);
			CarInfo[idx][cColorTwo] = strval(arrCoords[6]);
			strmid(CarInfo[idx][cOwner], arrCoords[7], 0, strlen(arrCoords[7]), 255);
			strmid(CarInfo[idx][cDescription], arrCoords[8], 0, strlen(arrCoords[8]), 255);
			CarInfo[idx][cValue] = strval(arrCoords[9]);
			CarInfo[idx][cLicense] = strval(arrCoords[10]);
			CarInfo[idx][cOwned] = strval(arrCoords[11]);
			CarInfo[idx][cLock] = strval(arrCoords[12]);
			printf("CarInfo: %d Owner:%s LicensePlate %s", idx, CarInfo[idx][cOwner], CarInfo[idx][cLicense]);
			idx++;
		}
	}
	return 1;
}
public LoadProperty()
{
	new arrCoords[30][64];
	new strFromFile2[256];
	new File: file = fopen("property.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(HouseInfo))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, ',');
			HouseInfo[idx][hEntrancex] = floatstr(arrCoords[0]);
			HouseInfo[idx][hEntrancey] = floatstr(arrCoords[1]);
			HouseInfo[idx][hEntrancez] = floatstr(arrCoords[2]);
			HouseInfo[idx][hExitx] = floatstr(arrCoords[3]);
			HouseInfo[idx][hExity] = floatstr(arrCoords[4]);
			HouseInfo[idx][hExitz] = floatstr(arrCoords[5]);
			HouseInfo[idx][hHealthx] = strval(arrCoords[6]);
			HouseInfo[idx][hHealthy] = strval(arrCoords[7]);
			HouseInfo[idx][hHealthz] = strval(arrCoords[8]);
			HouseInfo[idx][hArmourx] = strval(arrCoords[9]);
			HouseInfo[idx][hArmoury] = strval(arrCoords[10]);
			HouseInfo[idx][hArmourz] = strval(arrCoords[11]);
			//printf("HouseInfo hEntrancez %f",HouseInfo[idx][hEntrancez]);
			strmid(HouseInfo[idx][hOwner], arrCoords[12], 0, strlen(arrCoords[12]), 255);
			strmid(HouseInfo[idx][hDiscription], arrCoords[13], 0, strlen(arrCoords[13]), 255);
			HouseInfo[idx][hValue] = strval(arrCoords[14]);
			HouseInfo[idx][hHel] = strval(arrCoords[15]);
			HouseInfo[idx][hArm] = strval(arrCoords[16]);
			HouseInfo[idx][hInt] = strval(arrCoords[17]);
			HouseInfo[idx][hLock] = strval(arrCoords[18]);
			HouseInfo[idx][hOwned] = strval(arrCoords[19]);
			HouseInfo[idx][hRooms] = strval(arrCoords[20]);
			HouseInfo[idx][hRent] = strval(arrCoords[21]);
			HouseInfo[idx][hRentabil] = strval(arrCoords[22]);
			HouseInfo[idx][hTakings] = strval(arrCoords[23]);
			HouseInfo[idx][hVec] = strval(arrCoords[24]);
			if (HouseInfo[idx][hVec] == 457)
			{
				HouseInfo[idx][hVec] = 411;
			}
			HouseInfo[idx][hVcol1] = strval(arrCoords[25]);
			HouseInfo[idx][hVcol2] = strval(arrCoords[26]);
			HouseInfo[idx][hDate] = strval(arrCoords[27]);
			HouseInfo[idx][hLevel] = strval(arrCoords[28]);
			HouseInfo[idx][hWorld] = strval(arrCoords[29]);

			printf("HouseInfo:%d Owner:%s hTakings %d hVec %d", idx, HouseInfo[idx][hOwner], HouseInfo[idx][hTakings], HouseInfo[idx][hVec]);
			idx++;
		}
		fclose(file);
	}
	return 1;
}
public LoadBizz()
{
	new arrCoords[19][64];
	new strFromFile2[256];
	new File: file = fopen("bizz.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(BizzInfo))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			BizzInfo[idx][bOwned] = strval(arrCoords[0]);
			strmid(BizzInfo[idx][bOwner], arrCoords[1], 0, strlen(arrCoords[1]), 255);
			strmid(BizzInfo[idx][bMessage], arrCoords[2], 0, strlen(arrCoords[2]), 255);
			strmid(BizzInfo[idx][bExtortion], arrCoords[3], 0, strlen(arrCoords[3]), 255);
			BizzInfo[idx][bEntranceX] = floatstr(arrCoords[4]);
			BizzInfo[idx][bEntranceY] = floatstr(arrCoords[5]);
			BizzInfo[idx][bEntranceZ] = floatstr(arrCoords[6]);
			BizzInfo[idx][bExitX] = floatstr(arrCoords[7]);
			BizzInfo[idx][bExitY] = floatstr(arrCoords[8]);
			BizzInfo[idx][bExitZ] = floatstr(arrCoords[9]);
			BizzInfo[idx][bLevelNeeded] = strval(arrCoords[10]);
			BizzInfo[idx][bBuyPrice] = strval(arrCoords[11]);
			BizzInfo[idx][bEntranceCost] = strval(arrCoords[12]);
			BizzInfo[idx][bTill] = strval(arrCoords[13]);
			BizzInfo[idx][bLocked] = strval(arrCoords[14]);
			BizzInfo[idx][bInterior] = strval(arrCoords[15]);
			BizzInfo[idx][bProducts] = strval(arrCoords[16]);
			BizzInfo[idx][bMaxProducts] = strval(arrCoords[17]);
			BizzInfo[idx][bPriceProd] = strval(arrCoords[18]);
			printf("BizzInfo:%d Owner:%s Message:%s Entfee:%d Till:%d Products:%d/%d Interior:%d.\n",
				idx,
				BizzInfo[idx][bOwner],
				BizzInfo[idx][bMessage],
				BizzInfo[idx][bEntranceCost],
				BizzInfo[idx][bTill],
				BizzInfo[idx][bProducts],
				BizzInfo[idx][bMaxProducts],
				BizzInfo[idx][bInterior]);
			idx++;
		}
		fclose(file);
	}
	return 1;
}
public LoadSBizz()
{
	new arrCoords[16][64];
	new strFromFile2[256];
	new File: file = fopen("sbizz.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(SBizzInfo))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			SBizzInfo[idx][sbOwned] = strval(arrCoords[0]);
			strmid(SBizzInfo[idx][sbOwner], arrCoords[1], 0, strlen(arrCoords[1]), 255);
			strmid(SBizzInfo[idx][sbMessage], arrCoords[2], 0, strlen(arrCoords[2]), 255);
			strmid(SBizzInfo[idx][sbExtortion], arrCoords[3], 0, strlen(arrCoords[3]), 255);
			SBizzInfo[idx][sbEntranceX] = floatstr(arrCoords[4]);
			SBizzInfo[idx][sbEntranceY] = floatstr(arrCoords[5]);
			SBizzInfo[idx][sbEntranceZ] = floatstr(arrCoords[6]);
			SBizzInfo[idx][sbLevelNeeded] = strval(arrCoords[7]);
			SBizzInfo[idx][sbBuyPrice] = strval(arrCoords[8]);
			SBizzInfo[idx][sbEntranceCost] = strval(arrCoords[9]);
			SBizzInfo[idx][sbTill] = strval(arrCoords[10]);
			SBizzInfo[idx][sbLocked] = strval(arrCoords[11]);
			SBizzInfo[idx][sbInterior] = strval(arrCoords[12]);
			SBizzInfo[idx][sbProducts] = strval(arrCoords[13]);
			SBizzInfo[idx][sbMaxProducts] = strval(arrCoords[14]);
			SBizzInfo[idx][sbPriceProd] = strval(arrCoords[15]);
			printf("SBizzInfo:%d Owner:%s Message:%s Entfee:%d Till:%d Products:%d/%d Interior:%d.\n",
				idx,
				SBizzInfo[idx][sbOwner],
				SBizzInfo[idx][sbMessage],
				SBizzInfo[idx][sbEntranceCost],
				SBizzInfo[idx][sbTill],
				SBizzInfo[idx][sbProducts],
				SBizzInfo[idx][sbMaxProducts],
				SBizzInfo[idx][sbInterior]);
			idx++;
		}
		fclose(file);
	}
	return 1;
}
public LoadDrugSystem()
{
	new arrCoords[1][64];
	new strFromFile2[256];
	new File: file = fopen("drugs_system.ini", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, ',');
		drugsys[DrugAmmount] = strval(arrCoords[0]);
		fclose(file);
	}
	return 1;
}
public LoadMatsSystem()
{
	new arrCoords[1][64];
	new strFromFile2[256];
	new File: file = fopen("mats_system.ini", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, ',');
		matssys[MatsAmmount] = strval(arrCoords[0]);
		fclose(file);
	}
	return 1;
}
public LoadHQLocks()
{
	new arrCoords[4][64];
	new strFromFile2[256];
	new File: file = fopen("hq_locks.ini", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, ',');
		hqlock[surlock] = strval(arrCoords[0]);
		hqlock[luclock] = strval(arrCoords[1]);
		hqlock[stlock] = strval(arrCoords[2]);
		hqlock[iolock] = strval(arrCoords[3]);
		fclose(file);
	}
	return 1;
}
public LoadTrunk()
{
	new arrCoords[13][64];
	new strFromFile2[256];
	new File: file = fopen("trunk.cfg", io_read);
	if (file)
	{
		new idx = 1;
		while (idx < sizeof(CarInfo))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, ',');
			vehTrunk[idx][1] = strval(arrCoords[0]);
			vehTrunkAmmo[idx][1] = strval(arrCoords[1]);
			vehTrunk[idx][2] = strval(arrCoords[2]);
			vehTrunkAmmo[idx][2] = strval(arrCoords[3]);
			vehTrunk[idx][3] = strval(arrCoords[4]);
			vehTrunkAmmo[idx][3] = strval(arrCoords[5]);
			vehTrunk[idx][4] = strval(arrCoords[6]);
			vehTrunkAmmo[idx][4] = strval(arrCoords[7]);
			vehTrunkCounter[idx] = strval(arrCoords[8]);
			vehTrunkArmour[idx] = floatstr(arrCoords[9]);
			idx++;
		}
	}
	return 1;
}

//FUNCTION+STOCK
public Float:GetDistanceBetweenPlayers(p1, p2)
{
	new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
	if (!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
	{
		return -1.00;
	}
	GetPlayerPos(p1, x1, y1, z1);
	GetPlayerPos(p2, x2, y2, z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2, x1)), 2) + floatpower(floatabs(floatsub(y2, y1)), 2) + floatpower(floatabs(floatsub(z2, z1)), 2));
}

public SearchingHit(playerid)
{
	new string[256];
	new giveplayer[MAX_PLAYER_NAME];
	new searchhit = 0;
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(searchhit == 0)
		    {
			    if(PlayerInfo[i][pHeadValue] > 0 && GotHit[i] == 0 && PlayerInfo[i][pMember] != 8)
			    {
			        GetPlayerName(i, giveplayer, sizeof(giveplayer));
			        searchhit = 1;
			        hitfound = 1;
			        hitid = i;
			        for(new k=0; k<MAX_PLAYERS; k++)
					{
						if(IsPlayerConnected(k))
						{
				        	if(PlayerInfo[k][pMember] == 8 || PlayerInfo[k][pLeader] == 8)
				        	{
	               				SendClientMessage(k, COLOR_WHITE, "|__________________ Hitman Agency News __________________|");
				                SendClientMessage(k, COLOR_DBLUE, "*** Incoming Message: A Hit has become available. ***");
				                format(string, sizeof(string), "Person: %s   ID: %d   Value: $%d", giveplayer, i, PlayerInfo[i][pHeadValue]);
								SendClientMessage(k, COLOR_DBLUE, string);
								SendClientMessage(k, COLOR_YELLOW, "Use Givehit hitmanid, to assign the Contract to one of the Hitmans.");
								SendClientMessage(k, COLOR_WHITE, "|________________________________________________________|");
	      					}
					    }
					}
					return 0;
			    }
			}
		}
	}
	if(searchhit == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY, "   Khong co hop dong nao !");
	}
	return 0;
}

public ExtortionBiz(bizid, money)
{
    new string[256];
    format(string, sizeof(string), "No-one");
    if(strcmp(BizzInfo[bizid][bExtortion],string, true ) == 0 )
	{
	    return 0;
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new name[MAX_PLAYER_NAME];
			new wstring[MAX_PLAYER_NAME];
			GetPlayerName(i, name, sizeof(name));
			format(string, sizeof(string), "%s", name);
			strmid(wstring, string, 0, strlen(string), 255);
			if(strcmp(BizzInfo[bizid][bExtortion] ,wstring, true ) == 0 )
			{
			    new value = money / 100;
			    value = value * 10;
			    SafeGivePlayerMoney(i, value);
			    BizzInfo[bizid][bTill] -= value;
			}
		}
	}
	return 1;
}

public ExtortionSBiz(bizid, money)
{
    new string[256];
    format(string, sizeof(string), "No-one");
    if(strcmp(SBizzInfo[bizid][sbExtortion],string, true ) == 0 )
	{
	    return 0;
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new name[MAX_PLAYER_NAME];
			new wstring[MAX_PLAYER_NAME];
			GetPlayerName(i, name, sizeof(name));
			format(string, sizeof(string), "%s", name);
			strmid(wstring, string, 0, strlen(string), 255);
			if(strcmp(SBizzInfo[bizid][sbExtortion] ,wstring, true ) == 0 )
			{
			    new value = money / 100;
			    value = value * 10;
			    SafeGivePlayerMoney(i, value);
			    SBizzInfo[bizid][sbTill] -= value;
			}
		}
	}
	return 1;
}

public PreparePaintball()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PlayerPaintballing[i] != 0)
	        {
	            SendClientMessage(i, COLOR_YELLOW, "Tran dau se bat dau sau 20 giay nua.");
	        }
		}
	}
 	SetTimer("Tran dau bat dau", 20000, 0);
	return 1;
}

public StartPaintball()
{
	PaintballRound = 1;
	StartingPaintballRound = 0;
	PaintballWinner = 999;
	PaintballWinnerKills = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PlayerPaintballing[i] != 0)
	        {
	            SafeResetPlayerWeapons(i);
	            SafeGivePlayerWeapon(i, 29, 999);
	            TogglePlayerControllable(i, 1);
	            SendClientMessage(i, COLOR_YELLOW, "Tran dau se ket thuc sau 4 phut nua.");
	            PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
	        }
	    }
	}
	SetTimer("Ket thuc tran dau", 240000, 0);
	return 1;
}

public PaintballEnded()
{
	new string[256];
	new name[MAX_PLAYER_NAME];
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PlayerPaintballing[i] != 0)
	        {
	            if(IsPlayerConnected(PaintballWinner))
	            {
	                GetPlayerName(PaintballWinner, name, sizeof(name));
	                format(string,sizeof(string), "** %s won the Paintball Match with %d kills **",name,PaintballWinnerKills);
	                SendClientMessage(i, COLOR_WHITE, string);
	            }
	            SafeResetPlayerWeapons(i);
	            PlayerPaintballing[i] = 0;
	            SetPlayerPos(i, SBizzInfo[10][sbEntranceX],SBizzInfo[10][sbEntranceY],SBizzInfo[10][sbEntranceZ]);
	        }
		}
	}
	AnnouncedPaintballRound = 0;
    PaintballRound = 0;
	return 1;
}

public PrepareKarting()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PlayerKarting[i] != 0 && PlayerInKart[i] != 0)
	        {
	            CP[i] = 9;
				SetPlayerCheckpoint(i,2308.3540,-2354.0039,12.6842,8.0);
				SendClientMessage(i, COLOR_YELLOW, "Kart Race se bat dau trong 20s, Hay di den vach xuat phat.");
	        }
		}
	}
	SetTimer("Bat dau", 20000, 0);
	return 1;
}

public StartKarting()
{
	KartingRound = 1;
	StartingKartRound = 0;
	EndingKartRound = 0;
	FirstKartWinner = 999;
	SecondKartWinner = 999;
	ThirdKartWinner = 999;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PlayerKarting[i] != 0 && PlayerInKart[i] != 0)
	        {
	            CP[i] = 10;
	            SendClientMessage(i, COLOR_YELLOW, "Start, go go go !");
	            PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
	            SetPlayerCheckpoint(i,2308.3540,-2354.0039,12.6842,8.0);
	        }
	    }
	}
	SetTimer("Cuoc dua ket thuc", 240000, 0);
	return 1;
}

public KartingEnded()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PlayerKarting[i] != 0 && PlayerInKart[i] != 0)
	        {
	            CP[i] = 0;
	            DisablePlayerCheckpoint(i);
	        }
		}
	}
	AnnouncedKartRound = 0;
    KartingRound = 0;
	return 1;
}

public DollahScoreUpdate()
{
	new LevScore;
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
   			LevScore = PlayerInfo[i][pLevel];
			SetPlayerScore(i, LevScore);
		}
	}
	return 1;
}

//LoopingAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
//{
//    gPlayerUsingLoopingAnim[playerid] = 1;
//    ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
//    TextDrawShowForPlayer(playerid,txtAnimHelper);
//}

public Encrypt(string[])
{
	for(new x=0; x < strlen(string); x++)
	  {
		  string[x] += (3^x) * (x % 15);
		  if(string[x] > (0xff))
		  {
			  string[x] -= 256;
		  }
	  }
	return 1;
}

stock right(source[], len)
{
	new retval[MAX_STRING], srclen;
	srclen = strlen(source);
	strmid(retval, source, srclen - len, srclen, MAX_STRING);
	return retval;
}

stock sscanf(string[], format[], {Float,_}:...)
{
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs();
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if (ch >= '0' && ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return 1;
					}
				}
				while ((ch = string[stringPos]) && ch != ' ');
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					ch,
					num = 0;
				while ((ch = string[stringPos++]))
				{
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						case ' ':
						{
							break;
						}
						default:
						{
							return 1;
						}
					}
				}
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{
				new tmp[25];
				strmid(tmp, string, stringPos, stringPos+sizeof(tmp)-2);
				setarg(paramPos, 0, _:floatstr(tmp));
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != ' ')
					{
						setarg(paramPos, i++, ch);
					}
					if (!i) return 1;
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != ' ')
		{
			stringPos++;
		}
		while (string[stringPos] == ' ')
		{
			stringPos++;
		}
		paramPos++;
	}
	while (format[formatPos] == 'z') formatPos++;
	return format[formatPos];
}

public Spectator()
{
	new string[256];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(KickPlayer[i]==1) { Kick(i); }
			else if(KickPlayer[i]==2) { Ban(i); }
			//if(GetPlayerPing(i) >= 500 && PlayerInfo[i][pAdmin] < 1) { Kick(i); }
			if(Spectate[i] < 253 && Spectate[i] != 255)
			{
				SetPlayerColor(i,COLOR_SPEC);
				TogglePlayerControllable(i, 0);
				new targetid = Spectate[i];
				if(IsPlayerConnected(targetid))
				{
				    TogglePlayerSpectating(i, 1);
				    if(PlayerInfo[i][pAdmin] >= 1)
				    {
				        new Float:health;
					    new name[MAX_PLAYER_NAME];
					    GetPlayerName(targetid, name, sizeof(name));
					    GetPlayerHealth(targetid, health);
					    format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~y~%s(ID:%d)~n~~y~health:%.1f",name,targetid,health);
					    GameTextForPlayer(i, string, 2500, 3);
				    }
				    if(IsPlayerInAnyVehicle(targetid))
					{
					    new carid = GetPlayerVehicleID(targetid);
					    PlayerSpectateVehicle(i, carid);
					}
					else
					{
					    PlayerSpectatePlayer(i, targetid);
					}
					if(GetPlayerInterior(targetid) == 0)
					{
						SetPlayerInterior(i,0);
					}
					else if(GetPlayerInterior(targetid) > 0)
					{
						SetPlayerInterior(i,GetPlayerInterior(targetid));
					}
				}//Targetid connected
			}
			if(Spectate[i] == 253)
			{
				TogglePlayerControllable(i, 1);
				TogglePlayerSpectating(i, 0);
				SetPlayerInterior(i,Unspec[i][sPint]);
				PlayerInfo[i][pInt] = Unspec[i][sPint];
				PlayerInfo[i][pLocal] = Unspec[i][sLocal];
				Unspec[i][sLocal] = 255;
				SetSpawnInfo(i, PlayerInfo[i][pTeam], PlayerInfo[i][pModel], Unspec[i][sPx],  Unspec[i][sPy], Unspec[i][sPz]-1.0, 1.0, -1, -1, -1, -1, -1, -1);
				gTeam[i] = PlayerInfo[i][pTeam];
				SetPlayerToTeamColor(i);
				MedicBill[i] = 0;
				if(PlayerInfo[i][pDonateRank] > 0)
		        {
		            SetSpawnInfo(i, PlayerInfo[i][pTeam], PlayerInfo[i][pModel], Unspec[i][Coords][0], Unspec[i][Coords][1], Unspec[i][Coords][2], 10.0, -1, -1, -1, -1, -1, -1);
					SpawnPlayer(i);
					SetCameraBehindPlayer(i);
		        }
		        else
		        {
					SpawnPlayer(i);
				}
				Spectate[i] = 255;
			}
			if(Spectate[i] == 254)
			{
				TogglePlayerControllable(i, 1);
				SetPlayerInterior(i,Unspec[i][sPint]);
				PlayerInfo[i][pInt] = Unspec[i][sPint];
				PlayerInfo[i][pLocal] = Unspec[i][sLocal];
				SetPlayerPos(i, Unspec[i][sPx],  Unspec[i][sPy], Unspec[i][sPz]);
				Spectate[i] = 255;
			}
			if(Spectate[i] == 256)
			{
				SetPlayerToTeamColor(i);
				Spectate[i] = 255;
			}
			if(Spectate[i] == 257)
			{
				Spectate[i] = 254;
			}
		}
	}
}

public IsAnInstructor(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    new leader = PlayerInfo[playerid][pLeader];
	    new member = PlayerInfo[playerid][pMember];
	    if(member==11)
		{
		    return 1;
		}
		if(leader==11)
		{
		    return 1;
		}
	}
	return 0;
}

public IsAMember(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    new leader = PlayerInfo[playerid][pLeader];
	    new member = PlayerInfo[playerid][pMember];
	    if(member==5 || member==6 || member==8 || member==14 || member==15 || member==16)
		{
		    return 1;
		}
		if(leader==5 || leader==6 || leader==8 || leader==14 || leader==15 || leader==16)
		{
		    return 1;
		}
	}
	return 0;
}

public IsACop(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    new leader = PlayerInfo[playerid][pLeader];
	    new member = PlayerInfo[playerid][pMember];
	    if(member==1 || member==2 || member==3)
		{
		    return 1;
		}
		else if(leader==1 || leader==2 || leader==3)
		{
		    return 1;
		}
	}
	return 0;
}

public IsAPDMember(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    new leader = PlayerInfo[playerid][pLeader];
	    new member = PlayerInfo[playerid][pMember];
	    if(member==1)
		{
		    return 1;
		}
		else if(leader==1)
		{
		    return 1;
		}
	}
	return 0;
}

public IsAnOwnableCar(vehicleid)
{
	if(vehicleid >= 184 && vehicleid <= 268) { return 1; }
	return 0;
}

public IsAtDealership(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(PlayerToPoint(25.0,playerid,2128.0864,-1135.3912,25.5855) || PlayerToPoint(50,playerid,537.3366,-1293.2140,17.2422) || PlayerToPoint(35,playerid,2521.5544,-1524.4504,23.8365) || PlayerToPoint(50,playerid,2155.0146,-1177.3333,23.8211) || PlayerToPoint(50,playerid,299.1723,-1518.6627,24.6007))
		{
			return 1;
		}
	}
	return 0;
}
public IsAtCarrental(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(PlayerToPoint(30.0,playerid,1696.5543,-1053.4685,23.9063))
		{
			return 1;
		}
	}
	return 0;
}

public IsAtClothShop(playerid)
{
    if(IsPlayerConnected(playerid))
	{
        if(PlayerToPoint(25.0,playerid,20.5627,-103.7291,1005.2578) || PlayerToPoint(25.0,playerid,203.9068,-41.0728,1001.8047))
		{//Binco & Suburban
		    return 1;
		}
		else if(PlayerToPoint(30.0,playerid,214.4470,-7.6471,1001.2109) || PlayerToPoint(50.0,playerid,161.3765,-83.8416,1001.8047))
		{//Zip & Victim
		    return 1;
		}
	}
	return 0;
}

public IsAtGasStation(playerid)
{
    if(IsPlayerConnected(playerid))
	{
		if(PlayerToPoint(6.0,playerid,1004.0070,-939.3102,42.1797) || PlayerToPoint(6.0,playerid,1944.3260,-1772.9254,13.3906))
		{//LS
		    return 1;
		}
		else if(PlayerToPoint(6.0,playerid,-90.5515,-1169.4578,2.4079) || PlayerToPoint(6.0,playerid,-1609.7958,-2718.2048,48.5391))
		{//LS
		    return 1;
		}
		else if(PlayerToPoint(6.0,playerid,-2029.4968,156.4366,28.9498) || PlayerToPoint(8.0,playerid,-2408.7590,976.0934,45.4175))
		{//SF
		    return 1;
		}
		else if(PlayerToPoint(5.0,playerid,-2243.9629,-2560.6477,31.8841) || PlayerToPoint(8.0,playerid,-1676.6323,414.0262,6.9484))
		{//Between LS and SF
		    return 1;
		}
		else if(PlayerToPoint(6.0,playerid,2202.2349,2474.3494,10.5258) || PlayerToPoint(10.0,playerid,614.9333,1689.7418,6.6968))
		{//LV
		    return 1;
		}
		else if(PlayerToPoint(8.0,playerid,-1328.8250,2677.2173,49.7665) || PlayerToPoint(6.0,playerid,70.3882,1218.6783,18.5165))
		{//LV
		    return 1;
		}
		else if(PlayerToPoint(8.0,playerid,2113.7390,920.1079,10.5255) || PlayerToPoint(6.0,playerid,-1327.7218,2678.8723,50.0625))
		{//LV
		    return 1;
		}
		else if(PlayerToPoint(8.0,playerid,656.4265,-559.8610,16.5015) || PlayerToPoint(6.0,playerid,656.3797,-570.4138,16.5015))
		{//Dillimore
		    return 1;
		}
	}
	return 0;
}

public IsAtFishPlace(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(PlayerToPoint(1.0,playerid,403.8266,-2088.7598,7.8359) || PlayerToPoint(1.0,playerid,398.7553,-2088.7490,7.8359))
		{//Fishplace at the bigwheel
		    return 1;
		}
		else if(PlayerToPoint(1.0,playerid,396.2197,-2088.6692,7.8359) || PlayerToPoint(1.0,playerid,391.1094,-2088.7976,7.8359))
		{//Fishplace at the bigwheel
		    return 1;
		}
		else if(PlayerToPoint(1.0,playerid,383.4157,-2088.7849,7.8359) || PlayerToPoint(1.0,playerid,374.9598,-2088.7979,7.8359))
		{//Fishplace at the bigwheel
		    return 1;
		}
		else if(PlayerToPoint(1.0,playerid,369.8107,-2088.7927,7.8359) || PlayerToPoint(1.0,playerid,367.3637,-2088.7925,7.8359))
		{//Fishplace at the bigwheel
		    return 1;
		}
		else if(PlayerToPoint(1.0,playerid,362.2244,-2088.7981,7.8359) || PlayerToPoint(1.0,playerid,354.5382,-2088.7979,7.8359))
		{//Fishplace at the bigwheel
		    return 1;
		}
	}
	return 0;
}

public IsAtCookPlace(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(PlayerToPoint(3.0,playerid,369.9786,-4.0798,1001.8589))
	    {//Cluckin Bell
	        return 1;
	    }
	    else if(PlayerToPoint(3.0,playerid,376.4466,-60.9574,1001.5078) || PlayerToPoint(3.0,playerid,378.1215,-57.4928,1001.5078))
		{//Burgershot
		    return 1;
		}
		else if(PlayerToPoint(3.0,playerid,374.1185,-113.6361,1001.4922) || PlayerToPoint(3.0,playerid,377.7971,-113.7668,1001.4922))
		{//Well Stacked Pizza
		    return 1;
		}
	}
	return 0;
}

public IsAtBar(playerid)
{
    if(IsPlayerConnected(playerid))
	{
		if(PlayerToPoint(4.0,playerid,495.7801,-76.0305,998.7578) || PlayerToPoint(4.0,playerid,499.9654,-20.2515,1000.6797))
		{//In grove street bar (with girlfriend), and in Havanna
		    return 1;
		}
		else if(PlayerToPoint(4.0,playerid,1215.9480,-13.3519,1000.9219) || PlayerToPoint(10.0,playerid,-2658.9749,1407.4136,906.2734))
		{//PIG Pen
		    return 1;
		}
		else if(PlayerToPoint(4.0,playerid,-791.016,512.249,1336.41) || PlayerToPoint(10.0,playerid,-799.122,520.988,1336.41))
		{//Nortenos House
		    return 1;
		}
	}
	return 0;
}

public IsABoat(carid)
{
	if(carid == 10 || carid == 11)
	{
		return 1;
	}
	return 0;
}

public IsAHarvest(carid)
{
	if(carid == 155 || carid == 156 || carid == 157 || carid == 158)
	{
		return 1;
	}
	return 0;
}

public IsADrugHarvest(carid)
{
	if(carid == 159 || carid == 160 || carid == 161 || carid == 162)
	{
		return 1;
	}
	return 0;
}

public IsASmuggleCar(carid)
{
	if(carid == 163 || carid == 164 || carid == 165)
	{
		return 1;
	}
	return 0;
}

public IsASweeper(carid)
{
	if((carid >= 169) && (carid <= 171))
	{
	    return 1;
	}
	return 0;
}

public IsAPlane(carid)
{
	if(carid == 38 || carid == 55 || carid == 73 || carid == 167 || carid == 168)
	{
		return 1;
	}
	return 0;
}

public IsACopCar(carid)
{
	if((carid >= 16) && (carid <= 38))
	{
		return 1;
	}
	return 0;
}

public IsAnFbiCar(carid)
{
	if((carid >= 39) && (carid <= 43))
	{
	    return 1;
	}
	return 0;
}

public IsNgCar(carid)
{
	if((carid >= 1) && (carid <= 11))
	{
	    return 1;
	}
	return 0;
}

public IsAGovernmentCar(carid)
{
	if((carid >= 12) && (carid <= 15) || carid == 168)
	{
		return 1;
	}
	return 0;
}

public IsAHspdCar(carid)
{
	if((carid >= 44) && (carid <= 51))
	{
	    return 1;
	}
	return 0;
}

public IsATank(carid)
{
	if(carid==5)
	{
		return 1;
	}
	return 0;
}

public IsAnAmbulance(carid)
{
	if((carid >= 52) && (carid <= 55))
	{
		return 1;
	}
	return 0;
}

public IsATruck(carid)
{
	if(carid >= 108 && carid <= 111)
	{
		return 1;
	}
	return 0;
}

public IsAPizzabike(carid)
{
	if(carid >= 102 && carid <= 107)
	{
		return 1;
	}
	return 0;
}

public IsABus(carid)
{
	if(carid == 59 || carid == 60)
	{
		return 1;
	}
	return 0;
}

public IsATowcar(carid)
{
	if(carid >= 74 && carid <= 77)
	{
		return 1;
	}
	return 0;
}

/*public IsAGangCar(carid)
{
if(carid >= 160 && carid <= 163)
	{
		return 1;
	}
	return 0;
}

public IsAGangCar2(carid)
{
if(carid >= 164 && carid <= 167)
	{
		return 1;
	}
	return 0;
}

public IsAGangCar3(carid)
{
if(carid >= 189 && carid <= 191)
	{
		return 1;
	}
	return 0;
}

public IsAGangCar4(carid)
{
if(carid >= 155 && carid <= 159)
	{
		return 1;
	}
	return 0;
}

public IsAGangCar5(carid)
{
if(carid >= 168 && carid <= 171)
	{
		return 1;
	}
	return 0;
}*/

public IsABike(carid)
{
if((carid >= 102 && carid <= 107) || (carid >= 112 && carid <= 130) || (carid >= 262 && carid <= 267))
	{
		return 1;
	}
	return 0;
}

public IsAOBike(carid)
{
if((carid >= 237 && carid <= 267))
	{
		return 1;
	}
	return 0;
}

public JoinChannel(playerid, number, line[])
{
    if(IsPlayerConnected(playerid))
	{
	    if(strcmp(IRCInfo[number][iPassword],line, true ) == 0 )
		{
	        JoinChannelNr(playerid, number);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREY, "   Sai mat khau!");
	    }
	}
	return 1;
}

public JoinChannelNr(playerid, number)
{
	if(IsPlayerConnected(playerid))
	{
	    new string[256];
		new sendername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(PlayersChannel[playerid] < 999)
	    {
			format(string, sizeof(string), "* %s Da roi khoi Channel.", sendername);
			SendIRCMessage(PlayersChannel[playerid], COLOR_GREEN, string);
			IRCInfo[PlayersChannel[playerid]][iPlayers] -= 1;
	    }
		new channel; channel = number; channel += 1;
	    PlayersChannel[playerid] = number;
	    IRCInfo[PlayersChannel[playerid]][iPlayers] += 1;
    	new wstring[128];
		format(string, sizeof(string), "%s", sendername);
		strmid(wstring, string, 0, strlen(string), 255);
		if(strcmp(IRCInfo[number][iAdmin],wstring, true ) == 0 )
		{
		    format(string, sizeof(string), "* Ban da tham gia Channel IRC %d voi tu cach Admin.", channel);
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
		else
		{
		    format(string, sizeof(string), "* Ban da tham gia Channel IRC %d, Admin: %s.", channel, IRCInfo[number][iAdmin]);
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
		format(string, sizeof(string), "MOTD: %s.", IRCInfo[number][iMOTD]);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "* %s da tham gia Channel.", sendername);
		SendIRCMessage(number, COLOR_GREEN, string);
	}
	return 1;
}

public ClearCK(ck)
{
    new string[MAX_PLAYER_NAME];
	format(string, sizeof(string), "No-one");
	strmid(CKInfo[ck][cSendername], string, 0, strlen(string), 255);
	strmid(CKInfo[ck][cGiveplayer], string, 0, strlen(string), 255);
	CKInfo[ck][cUsed] = 0;
	SaveCK();
	return 1;
}

public ClearMarriage(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "No-one");
		strmid(PlayerInfo[playerid][pMarriedTo], string, 0, strlen(string), 255);
		PlayerInfo[playerid][pMarried] = 0;
	}
	return 1;
}

public ClearPaper(paper)
{
    new string[MAX_PLAYER_NAME];
	format(string, sizeof(string), "None");
	PaperInfo[paper][PaperUsed] = 0;
	strmid(PaperInfo[paper][PaperMaker], string, 0, strlen(string), 255);
	strmid(PaperInfo[paper][PaperTitle], string, 0, strlen(string), 255);
	strmid(PaperInfo[paper][PaperText1], string, 0, strlen(string), 255);
	strmid(PaperInfo[paper][PaperText2], string, 0, strlen(string), 255);
	strmid(PaperInfo[paper][PaperText3], string, 0, strlen(string), 255);
	strmid(PaperInfo[paper][PaperText4], string, 0, strlen(string), 255);
	strmid(PaperInfo[paper][PaperText5], string, 0, strlen(string), 255);
	strmid(PaperInfo[paper][PaperText6], string, 0, strlen(string), 255);
	strmid(PaperInfo[paper][PaperText7], string, 0, strlen(string), 255);
	SavePapers();
	return 1;
}

public ClearFamily(family)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PlayerInfo[i][pFMember] == family)
	        {
	            SendClientMessage(i, COLOR_WHITE, "* Family ban dang tham gia da bi xoa boi Leader, ban bi da bi kick ra khoi Family");
	            PlayerInfo[i][pFMember] = 255;
	        }
	    }
	}
    new string[MAX_PLAYER_NAME];
	format(string, sizeof(string), "None");
	FamilyInfo[family][FamilyTaken] = 0;
	strmid(FamilyInfo[family][FamilyName], string, 0, strlen(string), 255);
	strmid(FamilyInfo[family][FamilyMOTD], string, 0, strlen(string), 255);
	strmid(FamilyInfo[family][FamilyLeader], string, 0, strlen(string), 255);
	format(string, sizeof(string), "0xFF000069");
	strmid(FamilyInfo[family][FamilyColor], string, 0, strlen(string), 255);
	FamilyInfo[family][FamilyMembers] = 0;
	FamilyInfo[family][FamilySpawn][0] = 0.0;
	FamilyInfo[family][FamilySpawn][1] = 0.0;
	FamilyInfo[family][FamilySpawn][2] = 0.0;
	FamilyInfo[family][FamilySpawn][3] = 0.0;
	FamilyInfo[family][FamilyInterior] = 0;
	SaveFamilies();
	return 1;
}

public ClearCrime(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "********");
		strmid(PlayerCrime[playerid][pBplayer], string, 0, strlen(string), 255);
		strmid(PlayerCrime[playerid][pVictim], string, 0, strlen(string), 255);
		strmid(PlayerCrime[playerid][pAccusing], string, 0, strlen(string), 255);
		strmid(PlayerCrime[playerid][pAccusedof], string, 0, strlen(string), 255);
	}
	return 1;
}

public FishCost(playerid, fish)
{
	if(IsPlayerConnected(playerid))
	{
		new cost = 0;
		switch (fish)
		{
		    case 1:
		    {
		        cost = 1;
		    }
		    case 2:
		    {
		        cost = 3;
		    }
		    case 3:
		    {
		        cost = 3;
		    }
		    case 5:
		    {
		        cost = 5;
		    }
		    case 6:
		    {
		        cost = 2;
		    }
		    case 8:
		    {
		        cost = 8;
		    }
		    case 9:
		    {
		        cost = 12;
		    }
		    case 11:
		    {
		        cost = 9;
		    }
		    case 12:
		    {
		        cost = 7;
		    }
		    case 14:
		    {
		        cost = 12;
		    }
		    case 15:
		    {
		        cost = 9;
		    }
		    case 16:
		    {
		        cost = 7;
		    }
		    case 17:
		    {
		        cost = 7;
		    }
		    case 18:
		    {
		        cost = 10;
		    }
		    case 19:
		    {
		        cost = 4;
		    }
		    case 21:
		    {
		        cost = 3;
		    }
		}
		return cost;
	}
	return 0;
}

public ClearFishes(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    Fishes[playerid][pFid1] = 0; Fishes[playerid][pFid2] = 0; Fishes[playerid][pFid3] = 0;
		Fishes[playerid][pFid4] = 0; Fishes[playerid][pFid5] = 0;
		Fishes[playerid][pWeight1] = 0; Fishes[playerid][pWeight2] = 0; Fishes[playerid][pWeight3] = 0;
		Fishes[playerid][pWeight4] = 0; Fishes[playerid][pWeight5] = 0;
		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "None");
		strmid(Fishes[playerid][pFish1], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish2], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish3], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish4], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish5], string, 0, strlen(string), 255);
	}
	return 1;
}

public ClearFishID(playerid, fish)
{
	if(IsPlayerConnected(playerid))
	{
		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "None");
		switch (fish)
		{
		    case 1:
		    {
		        strmid(Fishes[playerid][pFish1], string, 0, strlen(string), 255);
		        Fishes[playerid][pWeight1] = 0;
		        Fishes[playerid][pFid1] = 0;
		    }
		    case 2:
		    {
		        strmid(Fishes[playerid][pFish2], string, 0, strlen(string), 255);
		        Fishes[playerid][pWeight2] = 0;
		        Fishes[playerid][pFid2] = 0;
		    }
		    case 3:
		    {
		        strmid(Fishes[playerid][pFish3], string, 0, strlen(string), 255);
		        Fishes[playerid][pWeight3] = 0;
		        Fishes[playerid][pFid3] = 0;
		    }
		    case 4:
		    {
		        strmid(Fishes[playerid][pFish4], string, 0, strlen(string), 255);
		        Fishes[playerid][pWeight4] = 0;
		        Fishes[playerid][pFid4] = 0;
		    }
		    case 5:
		    {
		        strmid(Fishes[playerid][pFish5], string, 0, strlen(string), 255);
		        Fishes[playerid][pWeight5] = 0;
		        Fishes[playerid][pFid5] = 0;
		    }
		}
	}
	return 1;
}

public ClearCooking(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    Cooking[playerid][pCookID1] = 0; Cooking[playerid][pCookID2] = 0; Cooking[playerid][pCookID3] = 0;
		Cooking[playerid][pCookID4] = 0; Cooking[playerid][pCookID5] = 0;
		Cooking[playerid][pCWeight1] = 0; Cooking[playerid][pCWeight2] = 0; Cooking[playerid][pCWeight3] = 0;
		Cooking[playerid][pCWeight4] = 0; Cooking[playerid][pCWeight5] = 0;
		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "Nothing");
		strmid(Cooking[playerid][pCook1], string, 0, strlen(string), 255);
		strmid(Cooking[playerid][pCook2], string, 0, strlen(string), 255);
		strmid(Cooking[playerid][pCook3], string, 0, strlen(string), 255);
		strmid(Cooking[playerid][pCook4], string, 0, strlen(string), 255);
		strmid(Cooking[playerid][pCook5], string, 0, strlen(string), 255);
	}
	return 1;
}

public ClearCookingID(playerid, cook)
{
	if(IsPlayerConnected(playerid))
	{
		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "Nothing");
		switch (cook)
		{
		    case 1:
		    {
		        strmid(Cooking[playerid][pCook1], string, 0, strlen(string), 255);
		        Cooking[playerid][pCWeight1] = 0;
		        Cooking[playerid][pCookID1] = 0;
		    }
		    case 2:
		    {
		        strmid(Cooking[playerid][pCook2], string, 0, strlen(string), 255);
		        Cooking[playerid][pCWeight2] = 0;
		        Cooking[playerid][pCookID2] = 0;
		    }
		    case 3:
		    {
		        strmid(Cooking[playerid][pCook3], string, 0, strlen(string), 255);
		        Cooking[playerid][pCWeight3] = 0;
		        Cooking[playerid][pCookID3] = 0;
		    }
		    case 4:
		    {
		        strmid(Cooking[playerid][pCook4], string, 0, strlen(string), 255);
		        Cooking[playerid][pCWeight4] = 0;
		        Cooking[playerid][pCookID4] = 0;
		    }
		    case 5:
		    {
		        strmid(Cooking[playerid][pCook5], string, 0, strlen(string), 255);
		        Cooking[playerid][pCWeight5] = 0;
		        Cooking[playerid][pCookID5] = 0;
		    }
		}
	}
	return 1;
}

public ClearGroceries(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    Groceries[playerid][pChickens] = 0; Groceries[playerid][pChicken] = 0;
	    Groceries[playerid][pHamburgers] = 0; Groceries[playerid][pHamburger] = 0;
	    Groceries[playerid][pPizzas] = 0; Groceries[playerid][pPizza] = 0;
	}
	return 1;
}

public Lotto(number)
{
	new JackpotFallen = 0;
	new string[256];
	new winner[MAX_PLAYER_NAME];
	format(string, sizeof(string), "XSKT: Con so may man ngay hom nay la: %d.", number);
    OOCOff(COLOR_WHITE, string);
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pLottoNr] > 0)
		    {
			    if(PlayerInfo[i][pLottoNr] == number)
			    {
			        JackpotFallen = 1;
			        GetPlayerName(i, winner, sizeof(winner));
					format(string, sizeof(string), "XSKT: %s da trung giai doc dac co gia tri len toi $%d.", winner, Jackpot);
					OOCOff(COLOR_DBLUE, string);
					format(string, sizeof(string), "* Ban da trung giai doc dac co gia tri $%d.", Jackpot);
					SendClientMessage(i, COLOR_YELLOW, string);
					//ConsumingMoney[i] = 1;
					SafeGivePlayerMoney(i, Jackpot);
			    }
			    else
			    {
			        SendClientMessage(i, COLOR_WHITE, "* Ban da khong trung thuong lan nay, chuc may man lan sau.");
			    }
			}
			PlayerInfo[i][pLottoNr] = 0;
		}
	}
	if(JackpotFallen)
	{
	    new rand = random(125000); rand += 15789;
	    Jackpot = rand;
	    SaveStuff();
	    format(string, sizeof(string), "XSKT: Giai thuong bat dau lai tu $%d.", Jackpot);
		OOCOff(COLOR_WHITE, string);
	}
	else
	{
	    new rand = random(15000); rand += 2158;
	    Jackpot += rand;
	    SaveStuff();
	    format(string, sizeof(string), "XSKT: Giai thuong duoc nang len thanh $%d.", Jackpot);
		OOCOff(COLOR_DBLUE, string);
	}
	return 1;
}

public GateClose(playerid)
{
      MoveObject(pdgate1,1589.053344,-1638.123168,14.122960, 0.97);
      PlayerPlaySound(playerid, 1153, 1589.053344,-1638.123168,14.122960);
      return 1;
}

public GateClose2()
{
      MoveObject(armygate1,2720.3772, -2409.7523, 12.6, 2.5);
      MoveObject(armygate2,2720.3772, -2508.3069, 12.6, 2.5);
      return 1;
}

public GateClose3()
{
      MoveObject(fbigate, 1534.9020,-1451.5979,14.4882, 1.5);
      return 1;
}

public GateClose4()
{
      MoveObject(hspdgate, 1643.3379,-1714.9338,15.3067, 1.5);
      return 1;
}

public GateClose5()
{
      DestroyObject( pdgate3 );
      pdgate2 = CreateObject(968,1544.700317,-1630.735717,13.096980,-1.000000,-91.000000,269.972869);
      return 1;
}

public GateClose6()
{
      MoveObject(lucianogate, 1246.0033,-767.3727,91.1473, 1.5);
	  return 1;
}

//public GateClose7()
/*public GateClose7()
{
      MoveObject(iorgate, 2796.1454,-1600.2020,10.1297, 1.5);
	  return 1;
}*/

public elevator1(playerid)
{
      SetPlayerPos(playerid,1174.9591,-1374.8761,23.9736);
      return 1;
}

public elevator2(playerid)
{
      SetPlayerPos(playerid,1174.9100,-1361.7330,13.9876);
	  return 1;
}

public SetPlayerSpawn(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
	    if(PlayerInfo[playerid][pTut] == 0)
	    {
			gOoc[playerid] = 1; gNews[playerid] = 1; gFam[playerid] = 1;
			SetPlayerInterior(playerid, 3);
			PlayerInfo[playerid][pInt] = 3;
			SetPlayerPos(playerid, 330.6825,163.6688,1014.1875);
			SetPlayerFacingAngle(playerid, 280);
			TogglePlayerControllable(playerid, 0);
			RegistrationStep[playerid] = 1;
			SendClientMessage(playerid, COLOR_YELLOW, "Chao mung ban den voi may chu Los Angeles Roleplay. Truoc tien ban can tra loi mot vai cau hoi");
			SendClientMessage(playerid, COLOR_LIGHTRED, "Cau hoi dau tien: Ban la 'Nam' hay 'Nu'? (Go cau tra loi).");
			return 1;
	    }
	    if(AdminSpec[playerid] == 1)
		{
		    return 1;
		}
		new rand;
		new house = PlayerInfo[playerid][pPhousekey];
		if(PlayerPaintballing[playerid] != 0)
		{
		    SafeResetPlayerWeapons(playerid);
      		SafeGivePlayerWeapon(playerid, 29, 999);
		    rand = random(sizeof(PaintballSpawns));
			SetPlayerPos(playerid, PaintballSpawns[rand][0], PaintballSpawns[rand][1], PaintballSpawns[rand][2]);
		    return 1;
		}
		if(PlayerInfo[playerid][pJailed] == 1)
		{
		    SetPlayerInterior(playerid, 6);
		    PlayerInfo[playerid][pInt] = 6;
			SetPlayerPos(playerid,264.6288,77.5742,1001.0391);
			SendClientMessage(playerid, COLOR_LIGHTRED, "Chua hoan thanh an phat, Tro ve nha tu.");
			return 1;
		}
		if(PlayerInfo[playerid][pJailed] == 2)
		{
		    SetPlayerInterior(playerid, 0);
		    PlayerInfo[playerid][pInt] = 0;
			SetPlayerPos(playerid,268.5777,1857.9351,9.8133);
			SetPlayerWorldBounds(playerid, 337.5694,101.5826,1940.9759,1798.7453); //285.3481,96.9720,1940.9755,1799.0811
			return 1;
		}
		if(MedicBill[playerid] == 1 && PlayerInfo[playerid][pJailed] == 0 && PlayerPaintballing[playerid] == 0)
		{
		    if(FirstSpawn[playerid] != 1)
		    {
		    	/*new string[256];
		    	new cut = deathcost; //PlayerInfo[playerid][pLevel]*deathcost;
				SafeGivePlayerMoney(playerid, -cut);
				format(string, sizeof(string), "DOC: Your Medical Bill comes to $%d, Have a nice day.", cut);
				SendClientMessage(playerid, TEAM_CYAN_COLOR, string);
				MedicBill[playerid] = 0;
				MedicTime[playerid] = 0;
				NeedMedicTime[playerid] = 0;*/
				PlayerInfo[playerid][pDeaths] += 1;
				SetPlayerHealth(playerid, 25.0);
		    	SetPlayerInterior(playerid, 3);
		    	PlayerInfo[playerid][pInt] = 3;
	        	rand = random(sizeof(gMedicSpawns));
				SetPlayerPos(playerid, gMedicSpawns[rand][0], gMedicSpawns[rand][1], gMedicSpawns[rand][2]); // Warp the player
				SetPlayerFacingAngle(playerid, 0);
	        	TogglePlayerControllable(playerid, 0);
	        	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Bay gio ban can nghi ngoi ...", 30000, 3);
	        	JustDied[playerid] = 1;
	        	MedicTime[playerid] = 1;
	        	ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
	        	if(PlayerInfo[playerid][pDonateRank] > 0)
	        	{
	            	NeedMedicTime[playerid] = 30;
	        	}
	        	else
	        	{
	        		NeedMedicTime[playerid] = 40;
				}
	        	PlayerPlaySound(playerid, 1062, 0.0, 0.0, 0.0);
		    	return 1;
			}
		}
		if(JustDied[playerid] == 1)
		{
		    if(GetPlayerVirtualWorld(playerid) != 0 || PlayerInfo[playerid][pVirWorld] != 0)
		    {
		        SetPlayerVirtualWorld(playerid, 0);
		        PlayerInfo[playerid][pVirWorld] = 0;
		    }
		    SetPlayerPos(playerid, 1182.5638,-1323.5256,13.5790);
		    SetPlayerFacingAngle(playerid, 270.0);
		    SetPlayerInterior(playerid,0);
		    PlayerInfo[playerid][pInt] = 0;
		    return 1;
		}
		if(PlayerInfo[playerid][pCrashed] == 1)
		{
		    if(TutTime[playerid] == 0 && PlayerInfo[playerid][pTut] == 1 && RegistrationStep[playerid] == 0 && AfterTutorial[playerid] == 0 && FirstSpawn[playerid] == 1)
		    {
		        SetPlayerVirtualWorld(playerid,PlayerInfo[playerid][pVirWorld]);
		        SetPlayerInterior(playerid,PlayerInfo[playerid][pInt]);
		    	SetPlayerPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z] + 1);
		    	//SendClientMessage(playerid, COLOR_WHITE, "Crashed, returning where you been.");
		    	//GameTextForPlayer(playerid, "~p~Crashed~n~~w~returning where you been", 5000, 1);
		    	return 1;
			}
		}
		if(house !=255)
		{
		    if(SpawnChange[playerid]) //If 1, then you get to your house, else spawn somewhere else
		    {
				SetPlayerToTeamColor(playerid);
				SetPlayerInterior(playerid,HouseInfo[house][hInt]);
				SetPlayerVirtualWorld(playerid,HouseInfo[house][hWorld]);
				SetPlayerPos(playerid, HouseInfo[house][hExitx], HouseInfo[house][hExity],HouseInfo[house][hExitz]); // Warp the player
				PlayerInfo[playerid][pLocal] = house;
				PlayerInfo2[HouseEntered][playerid] = house;
				PlayerInfo[playerid][pInt] = HouseInfo[house][hInt];
				return 1;
			}
		}
		if(PlayerInfo[playerid][pLeader] == 7)//Mayor spawn
		{
		    SetPlayerToTeamColor(playerid);
		    SetPlayerInterior(playerid, 3);
		    SetPlayerPos(playerid, 356.2998,151.9914,1025.7891);
		    PlayerInfo[playerid][pInt] = 3;
			PlayerInfo[playerid][pLocal] = 241;
		    return 1;
		}
		if (PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pLeader] == 1)//Police Force spawn
		{
			SetPlayerToTeamColor(playerid);
			SetPlayerInterior(playerid,6);
		    rand = random(sizeof(gCopPlayerSpawns));
			SetPlayerPos(playerid, gCopPlayerSpawns[rand][0], gCopPlayerSpawns[rand][1], gCopPlayerSpawns[rand][2]); // Warp the player
			SetPlayerFacingAngle(playerid, 270.0);
			PlayerInfo[playerid][pInt] = 6;
			return 1;
	    }
	    if (PlayerInfo[playerid][pMember] == 2 || PlayerInfo[playerid][pLeader] == 2)//FBI spawn
		{
			SetPlayerToTeamColor(playerid);
			SetPlayerInterior(playerid,3);
			SetPlayerPos(playerid, 299.7097,183.1322,1007.1719);
			SetPlayerFacingAngle(playerid, 90);
			PlayerInfo[playerid][pInt] = 3;
			return 1;
	    }
		if (PlayerInfo[playerid][pMember] == 3 || PlayerInfo[playerid][pLeader] == 3)//National Guard spawn
		{
		    SetPlayerToTeamColor(playerid);
		    SetPlayerInterior(playerid, 0);
		    SetPlayerPos(playerid, 2731.5229,-2451.3643,17.5937);
		    PlayerInfo[playerid][pInt] = 0;
		    return 1;
		}
		if (PlayerInfo[playerid][pMember] == 4 || PlayerInfo[playerid][pLeader] == 4)//Fire/Ambulance spawn
		{
		    SetPlayerToTeamColor(playerid);
		    SetPlayerPos(playerid, 1180.2388,-1331.6196,1006.4028);
			SetPlayerInterior(playerid,6);
			SetPlayerFacingAngle(playerid, 0);
			PlayerInfo[playerid][pInt] = 6;
		    return 1;
		}
		if (PlayerInfo[playerid][pMember] == 5 || PlayerInfo[playerid][pLeader] == 5)//Surenos spawn
		{
		    SetPlayerToTeamColor(playerid);
		    SetPlayerInterior(playerid, 5);
		    SetPlayerPos(playerid, 2345.6570,-1185.5266,1027.9766);
		    PlayerInfo[playerid][pInt] = 5;
		    return 1;
		}
		if (PlayerInfo[playerid][pMember] == 6 || PlayerInfo[playerid][pLeader] == 6)//La Famiglia Sinatra spawn
		{
		    SetPlayerToTeamColor(playerid);
		    SetPlayerInterior(playerid, 5);
		    SetPlayerPos(playerid, 1265.4475,-794.9257,1084.0078);
		    PlayerInfo[playerid][pInt] = 5;
		    return 1;
		}
	    if (PlayerInfo[playerid][pMember] == 8 || PlayerInfo[playerid][pLeader] == 8) //Hitman spawn
	    {
	        SetPlayerToTeamColor(playerid);
			SetPlayerPos(playerid, 1102.7017,-299.0774,73.9922);
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
	        return 1;
	    }
	    if (PlayerInfo[playerid][pMember] == 9 || PlayerInfo[playerid][pLeader] == 9) //News spawn
	    {
	        SetPlayerToTeamColor(playerid);
	        SetPlayerInterior(playerid,3);
			SetPlayerPos(playerid, 355.7899,204.0173,1008.3828);
			PlayerInfo[playerid][pInt] = 3;
			SafeGivePlayerWeapon(playerid, 43, 20);
	        return 1;
	    }
	    if (PlayerInfo[playerid][pMember] == 10 || PlayerInfo[playerid][pLeader] == 10) //Taxi Cab Company spawn
	    {
	        SetPlayerToTeamColor(playerid);
			SetPlayerPos(playerid, 1754.99,-1894.19,13.55);
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
	        return 1;
	    }
	    /*if (PlayerInfo[playerid][pMember] == 14 || PlayerInfo[playerid][pLeader] == 14)//Yamaguchi spawn
		{
		    SetPlayerToTeamColor(playerid);
		    SetPlayerInterior(playerid, 1);
		    SetPlayerPos(playerid, -779.6406,501.2036,1371.7422);
		    PlayerInfo[playerid][pInt] = 1;
		    return 1;
		}
		*/
		if (PlayerInfo[playerid][pMember] == 15 || PlayerInfo[playerid][pLeader] == 15)//47th Street Saints Families spawn
		{
		    SetPlayerToTeamColor(playerid);
		    SetPlayerInterior(playerid, 3);
		    SetPlayerPos(playerid, 2495.2605,-1703.7449,1018.3438);
		    PlayerInfo[playerid][pInt] = 3;
		    return 1;
		}
		if (PlayerInfo[playerid][pMember] == 16 || PlayerInfo[playerid][pLeader] == 16)//East Beach Bloods spawn
		{
		    SetPlayerToTeamColor(playerid);
		    SetPlayerInterior(playerid, 2);
		    SetPlayerPos(playerid, 455.8776,1413.6802,1084.3080);
		    PlayerInfo[playerid][pInt] = 2;
		    return 1;
		}
	    if(IsAnInstructor(playerid) || PlayerInfo[playerid][pMember] == 11 || PlayerInfo[playerid][pLeader] == 11) //Driving/Flying School spawn
	    {
		    SetPlayerToTeamColor(playerid);
		    SetPlayerInterior(playerid,3);
			SetPlayerPos(playerid, 1494.4991,1308.9163,1093.2845);
			SetPlayerFacingAngle(playerid, 180);
			PlayerInfo[playerid][pInt] = 3;
	        return 1;
	    }
	    if ((gTeam[playerid]) == 1)
	    {
			SetPlayerToTeamColor(playerid);
			rand = random(sizeof(gMedPlayerSpawns));
			SetPlayerPos(playerid, gMedPlayerSpawns[rand][0], gMedPlayerSpawns[rand][1], gMedPlayerSpawns[rand][2]); // Warp the player
			SetPlayerFacingAngle(playerid, 270.0);
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			return 1;
		}
		/*if(PlayerInfo[playerid][pFMember] != 255)
		{
		    new family = PlayerInfo[playerid][pFMember];
		    SetPlayerToTeamColor(playerid);
		    SetPlayerInterior(playerid, FamilyInfo[family][FamilyInterior]);
		    SetPlayerPos(playerid, FamilyInfo[family][FamilySpawn][0],FamilyInfo[family][FamilySpawn][1],FamilyInfo[family][FamilySpawn][2]);
		    SetPlayerFacingAngle(playerid, FamilyInfo[family][FamilySpawn][3]);
		    return 1;
		}*/
	    else
	    {
			SetPlayerToTeamColor(playerid);

			if (GetPVarInt(playerid, "FirstSpawn") == 1)
			{
				SetPlayerPos(playerid, 1612.3240, -2330.1670, 13.5469);
				SetPlayerFacingAngle(playerid, 0);
				SetPlayerInterior(playerid,0);
				PlayerInfo[playerid][pInt] = 0;
				SetPlayerFacingAngle(playerid, 0);
			}
			else
			{
				SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVirWorld]);
				SetPlayerInterior(playerid, PlayerInfo[playerid][pInt]);
				SetPlayerPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z] + 1);
				SetPlayerFacingAngle(playerid, 0);
			}
			//SetPlayerPos(playerid, 1612.3240, -2330.1670, 13.5469);
			//SetPlayerFacingAngle(playerid, 0);
			//SetPlayerInterior(playerid,0);
			//PlayerInfo[playerid][pInt] = 0;
			return 1;
		}
	}
	return 1;
}

public CKLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\n",string);
	new File:hFile;
	hFile = fopen("ck.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}

public PayLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\n",string);
	new File:hFile;
	hFile = fopen("pay.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}

public KickLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\n",string);
	new File:hFile;
	hFile = fopen("kick.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}

public BanLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\n",string);
	new File:hFile;
	hFile = fopen("ban.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}

public RefreshMenuHeader(playerid,Menu:menu,text[])
{
	SetMenuColumnHeader(menu,0,text);
	ShowMenuForPlayer(menu,playerid);
}

public SetAllPlayerCheckpoint(Float:allx, Float:ally, Float:allz, Float:radi, num)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			SetPlayerCheckpoint(i,allx,ally,allz, radi);
			if (num != 255)
			{
				gPlayerCheckpointStatus[i] = num;
			}
		}
	}

}

public SetAllCopCheckpoint(Float:allx, Float:ally, Float:allz, Float:radi)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(gTeam[i] == 2)
			{
				SetPlayerCheckpoint(i,allx,ally,allz, radi);
			}
		}
	}
	return 1;
}

public HireCost(carid)
{
	switch (carid)
	{
		case 69:
		{
			return 90000; //bullit
		}
		case 70:
		{
			return 130000; //infurnus
		}
		case 71:
		{
			return 100000; //turismo
		}
		case 72:
		{
			return 80000;
		}
		case 73:
		{
			return 70000;
		}
		case 74:
		{
			return 60000;
		}
	}
	return 0;
}

public CarCheck()
{
	new string[256];
	for(new j = 0; j<MAX_PLAYERS; j++)
	{
	    if(IsPlayerConnected(j))
	    {
	        /*SetVehicleParamsForPlayer(99, j, 0, 0);
	        SetVehicleParamsForPlayer(100, j, 0, 0);
	        SetVehicleParamsForPlayer(101, j, 0, 0);
	        SetVehicleParamsForPlayer(102, j, 0, 0);
	        SetVehicleParamsForPlayer(103, j, 0, 0);
	        SetVehicleParamsForPlayer(104, j, 0, 0);
	        SetVehicleParamsForPlayer(105, j, 0, 0);
	        SetVehicleParamsForPlayer(106, j, 0, 0);
	        SetVehicleParamsForPlayer(107, j, 0, 0);
	        SetVehicleParamsForPlayer(108, j, 0, 0);
	        SetVehicleParamsForPlayer(109, j, 0, 0);*/
		    new Float:health;
		    GetPlayerHealth(j, health);
			if(STDPlayer[j]==1)
			{
			    GetPlayerHealth(j, health);
			    SetPlayerHealth(j, health - 5.0);
			    SendClientMessage(j, COLOR_WHITE, "* Mat 4 mau do STD .");
			}
			else if(STDPlayer[j]==2)
			{
			    GetPlayerHealth(j, health);
			    SetPlayerHealth(j, health - 12.0);
			    SendClientMessage(j, COLOR_WHITE, "* Mat 8 mau do STD.");
			}
			else if(STDPlayer[j]==3)
			{
			    GetPlayerHealth(j, health);
			    SetPlayerHealth(j, health - 20.0);
			    SendClientMessage(j, COLOR_WHITE, "* Mat 12 mau do STD.");
			}

			if(GetPlayerMoney(j) < 0)
			{
			    if(MoneyMessage[j]==0)
			    {
				    format(string, sizeof(string), "You are in debt, you have till next Time Check to get: $%d or you go to jail.", GetPlayerMoney(j));
					SendClientMessage(j, COLOR_LIGHTRED, string);
					MoneyMessage[j] = 1;
				}
			}
			else
			{
			    MoneyMessage[j] = 0;
			}
		}
	}
	for(new c = 1; c < 254; c++)
	{
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if (PlayerInfo[i][pJob] == 5)
				{
					SetVehicleParamsForPlayer(c, i, 0, 0);
				}
			}
		}
		if (gLastDriver[c] == 301)
		{
//			CarRespawn(c);
		}
		if (gLastDriver[c] >= 300)
		{
			gLastDriver[c]++;
		}
		//foundowner = -1;
	}
	return 1;
}

public CarInit()
{
	for(new c = 1; c < 254; c++)
	{
 		gLastDriver[c] = 299;
	}
	gLastDriver[301]=255;
	return 1;
}

//public CarTow(carid)
/*public CarTow(carid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerInVehicle(i, carid) || HireCar[i] == carid)
			{
				gLastDriver[carid] = 255;
				return 0;
			}
		}
	}
	SetVehiclePos(carid,HouseCarSpawns[carid-1][0], HouseCarSpawns[carid-1][1], HouseCarSpawns[carid-1][2]);
	SetVehicleZAngle(carid, HouseCarSpawns[carid-1][3]);
	return 1;
}

public CarRespawn(carid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerInVehicle(i, carid) || HireCar[i] == carid)
			{
				gLastDriver[carid] = 255;
				return 0;
			}
		}
	}
	SetVehicleToRespawn(carid);
	gLastDriver[carid] = 299;
	return 1;
}*/

public LockCar(carid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			SetVehicleParamsForPlayer(carid,i,0,1);
		}
	}
}

public UnLockCar(carid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(!IsAPlane(carid))
			{
				SetVehicleParamsForPlayer(carid,i,0,0);
			}
		}
	}
}

public InitLockDoors(playerid)
{
    if(IsPlayerConnected(playerid))
	{
		new c;
		while (c < 254)
		{
			c++;
			if (gCarLock[c] == 1)
			{
				SetVehicleParamsForPlayer(c,playerid,0,1);
			}
		}
	}
	return 1;
}

public SetupPlayerForClassSelection(playerid)
{
	/*switch (gTeam[playerid])
	{
		case TEAM_BLUE:
		{
			SetPlayerInterior(playerid,5);
			SetPlayerPos(playerid,323.4,305.6,999.1);
			SetPlayerFacingAngle(playerid, 90.0);
			SetPlayerCameraPos(playerid,323.4-1.5-1.0,305.6,999.1+0.7);
			SetPlayerCameraLookAt(playerid,323.4-1.0,305.6,999.1+0.7);

		}
		case TEAM_ADMIN:
		{
		    SetPlayerInterior(playerid,3);
			SetPlayerPos(playerid,-2654.4,1424.2,912.4);
			SetPlayerFacingAngle(playerid, 90.0);
			SetPlayerCameraPos(playerid,-2654.4-1.5,1424.2,912.4+0.7);
			SetPlayerCameraLookAt(playerid,-2654.4,1424.2,912.4+0.7);
		}
		default:
		{
		    SetPlayerInterior(playerid,3);
			SetPlayerPos(playerid,361.8270,174.0347,1008.3893);
			SetPlayerFacingAngle(playerid,90);
		    SetPlayerCameraPos(playerid, 361.7270,169.0347,1008.3893);
		    SetPlayerCameraLookAt(playerid,361.8270,174.0347,1008.3893);
		}
	}*/
}

public SetPlayerTeamFromClass(playerid,classid)
{
 	/*if (classid >= 1 && classid <= 14)
	{
		gTeam[playerid] = 11; //admin
		PlayerInfo[playerid][pTeam] = 11;
	}
	else
	{
	    gTeam[playerid] = 3;
	    PlayerInfo[playerid][pTeam] = 3;
	}*/
}

public SetPlayerCriminal(playerid,declare,reason[])
{//example: SetPlayerCriminal(playerid,255, "Stealing A Police Vehicle");
	if(IsPlayerConnected(playerid))
	{
	    PlayerInfo[playerid][pCrimes] += 1;
	    new points = WantedPoints[playerid];
		new turned[MAX_PLAYER_NAME];
		new turner[MAX_PLAYER_NAME];
		new turnmes[128];
		new wantedmes[128];
		new wlevel;
		strmid(PlayerCrime[playerid][pAccusedof], reason, 0, strlen(reason), 255);
		GetPlayerName(playerid, turned, sizeof(turned));
		if (declare == 255)
		{
			format(turner, sizeof(turner), "Unknown");
			strmid(PlayerCrime[playerid][pVictim], turner, 0, strlen(turner), 255);
		}
		else
		{
		    if(IsPlayerConnected(declare))
		    {
				GetPlayerName(declare, turner, sizeof(turner));
				strmid(PlayerCrime[playerid][pVictim], turner, 0, strlen(turner), 255);
				strmid(PlayerCrime[declare][pBplayer], turned, 0, strlen(turned), 255);
				strmid(PlayerCrime[declare][pAccusing], reason, 0, strlen(reason), 255);
			}
		}
		format(turnmes, sizeof(turnmes), "You've commited a crime: %s. Reporter: %s.",reason,turner);
		SendClientMessage(playerid, COLOR_DARKNICERED, turnmes);
		if(points > 0)
		{
		    new yesno;
			if(points == 3) { if(WantedLevel[playerid] != 1) { WantedLevel[playerid] = 1; wlevel = 1; yesno = 1; } }
			else if(points >= 4 && points <= 5) { if(WantedLevel[playerid] != 2) { WantedLevel[playerid] = 2; wlevel = 2; yesno = 1; } }
			else if(points >= 6 && points <= 7) { if(WantedLevel[playerid] != 3) { WantedLevel[playerid] = 3; wlevel = 3; yesno = 1; } }
			else if(points >= 8 && points <= 9) { if(WantedLevel[playerid] != 4) { WantedLevel[playerid] = 4; wlevel = 4; yesno = 1; } }
			else if(points >= 10 && points <= 11) { if(WantedLevel[playerid] != 5) { WantedLevel[playerid] = 5; wlevel = 5; yesno = 1; } }
			else if(points >= 12 && points <= 13) { if(WantedLevel[playerid] != 6) { WantedLevel[playerid] = 6; wlevel = 6; yesno = 1; } }
			else if(points >= 14) { if(WantedLevel[playerid] != 10) { WantedLevel[playerid] = 10; wlevel = 10; yesno = 1; } }
			if(WantedLevel[playerid] >= 1) { if(gTeam[playerid] == 3) { gTeam[playerid] = 4; } }
			if(yesno)
			{
				format(wantedmes, sizeof(wantedmes), "Current Wanted Level: %d", wlevel);
				SendClientMessage(playerid, COLOR_YELLOW, wantedmes);
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
					    if(PlayerInfo[i][pMember] == 1||PlayerInfo[i][pLeader] == 1)
					    {
							format(cbjstore, sizeof(turnmes), "HQ: All Units APB: Reporter: %s",turner);
							SendClientMessage(i, TEAM_BLUE_COLOR, cbjstore);
							format(cbjstore, sizeof(turnmes), "HQ: Crime: %s, Suspect: %s",reason,turned);
							SendClientMessage(i, TEAM_BLUE_COLOR, cbjstore);
						}
					}
				}
			}
		}
	}//not connected
}

public SetPlayerCriminalEx(playerid,declare,reason[])
{//example: SetPlayerCriminal(playerid,255, "Stealing A Police Vehicle");
	if(IsPlayerConnected(playerid))
	{
	    PlayerInfo[playerid][pCrimes] += 1;
	    new points = WantedPoints[playerid];
		new turned[MAX_PLAYER_NAME];
		new turner[MAX_PLAYER_NAME];
		new turnmes[128];
		new wantedmes[128];
		new wlevel;
		strmid(PlayerCrime[playerid][pAccusedof], reason, 0, strlen(reason), 255);
		GetPlayerName(playerid, turned, sizeof(turned));
		if (declare == 255)
		{
			format(turner, sizeof(turner), "Unknown");
			strmid(PlayerCrime[playerid][pVictim], turner, 0, strlen(turner), 255);
		}
		else
		{
		    if(IsPlayerConnected(declare))
		    {
				GetPlayerName(declare, turner, sizeof(turner));
				strmid(PlayerCrime[playerid][pVictim], turner, 0, strlen(turner), 255);
				strmid(PlayerCrime[declare][pBplayer], turned, 0, strlen(turned), 255);
				strmid(PlayerCrime[declare][pAccusing], reason, 0, strlen(reason), 255);
			}
		}
		format(turnmes, sizeof(turnmes), "You've commited a crime: %s. Reporter: %s.",reason,turner);
		//SendClientMessage(playerid, COLOR_DARKNICERED, turnmes);
		if(points > 0)
		{
		    new yesno;
			if(points == 3) { if(WantedLevel[playerid] != 1) { WantedLevel[playerid] = 1; wlevel = 1; yesno = 1; } }
			else if(points >= 4 && points <= 5) { if(WantedLevel[playerid] != 2) { WantedLevel[playerid] = 2; wlevel = 2; yesno = 1; } }
			else if(points >= 6 && points <= 7) { if(WantedLevel[playerid] != 3) { WantedLevel[playerid] = 3; wlevel = 3; yesno = 1; } }
			else if(points >= 8 && points <= 9) { if(WantedLevel[playerid] != 4) { WantedLevel[playerid] = 4; wlevel = 4; yesno = 1; } }
			else if(points >= 10 && points <= 11) { if(WantedLevel[playerid] != 5) { WantedLevel[playerid] = 5; wlevel = 5; yesno = 1; } }
			else if(points >= 12 && points <= 13) { if(WantedLevel[playerid] != 6) { WantedLevel[playerid] = 6; wlevel = 6; yesno = 1; } }
			else if(points >= 14) { if(WantedLevel[playerid] != 10) { WantedLevel[playerid] = 10; wlevel = 10; yesno = 1; } }
			if(WantedLevel[playerid] >= 1) { if(gTeam[playerid] == 3) { gTeam[playerid] = 4; } }
			if(yesno)
			{
				format(wantedmes, sizeof(wantedmes), "Current Wanted Level: %d", wlevel);
				SendClientMessage(playerid, COLOR_YELLOW, wantedmes);
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
					    if(PlayerInfo[i][pMember] == 1||PlayerInfo[i][pLeader] == 1)
					    {
							format(cbjstore, sizeof(turnmes), "HQ: All Units APB: Reporter: %s",turner);
							SendClientMessage(i, TEAM_BLUE_COLOR, cbjstore);
							format(cbjstore, sizeof(turnmes), "HQ: Crime: %s, Suspect: %s",reason,turned);
							SendClientMessage(i, TEAM_BLUE_COLOR, cbjstore);
						}
					}
				}
			}
		}
	}//not connected
}

public SetPlayerFree(playerid,declare,reason[])
{
	if(IsPlayerConnected(playerid))
	{
		ClearCrime(playerid);
		new turned[MAX_PLAYER_NAME];
		new turner[MAX_PLAYER_NAME];
		new turnmes[128];
		new crbjstore[128];
		if (declare == 255)
		{
			format(turner, sizeof(turner), "911");
		}
		else
		{
		    if(IsPlayerConnected(declare))
		    {
				GetPlayerName(declare, turner, sizeof(turner));
			}
		}
		GetPlayerName(playerid, turned, sizeof(turned));
		format(turnmes, sizeof(turnmes), "SMS: %s, Because you %s, you are no longer a Criminal, Sender: MOLE (555)",turned,reason);
		RingTone[playerid] = 20;
		SendClientMessage(playerid, COLOR_YELLOW, turnmes);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
			    if(PlayerInfo[i][pMember] == 1||PlayerInfo[i][pLeader] == 1)
			    {
					format(crbjstore, sizeof(crbjstore), "HQ: All Units Officer %s Has Completed Assignment",turner);
					SendClientMessage(i, COLOR_DBLUE, crbjstore);
					format(crbjstore, sizeof(crbjstore), "HQ: %s Has Been Processed, %s",turned,reason);
					SendClientMessage(i, COLOR_DBLUE, crbjstore);
				}
			}
		}
	}
}

public RingToner()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
			if(RingTone[i] != 6 && RingTone[i] != 0 && RingTone[i] < 11)
			{
				RingTone[i] = RingTone[i] -1;
				PlayerPlaySound(i, 1138, 0.0, 0.0, 0.0);
			}
			if(RingTone[i] == 6)
			{
				RingTone[i] = RingTone[i] -1;
			}
			if(RingTone[i] == 20)
			{
				RingTone[i] = RingTone[i] -1;
				PlayerPlaySound(i, 1139, 0.0, 0.0, 0.0);
			}
		}
	}
	SetTimer("RingTonerRev", 1000, 0);
	return 1;
}

public RingTonerRev()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
			if(RingTone[i] != 5 && RingTone[i] != 0 && RingTone[i] < 10)
			{
				RingTone[i] = RingTone[i] -1;
				PlayerPlaySound(i, 1137, 0.0, 0.0, 0.0);
			}
			if(RingTone[i] == 5)
			{
				RingTone[i] = RingTone[i] -1;
			}
			if(RingTone[i] == 19)
			{
				PlayerPlaySound(i, 1139, 0.0, 0.0, 0.0);
				RingTone[i] = 0;
			}
		}
	}
	SetTimer("RingToner", 1000, 0);
	return 1;
}

public GlobalHackCheck()
{
	/*
	 *               DUCK anticheat v1.0
	 *              by Luk0r & Alex_Raven
	 *
	 *  This function is called every second the check each
	 *  player's money/weapons to ensure they're not hacking
	 *
	 */

	new curHour, curMinute, curSecond;
	new string[256], banip[16], plname[64];
	new weaponid, ammo;
	//new hacking;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i) && PlayerInfo[i][pAdmin] < 1)
	    {
			gettime(curHour, curMinute, curSecond);
			if (ScriptMoneyUpdated[i]+2 < curSecond)
			{
				new plactualmoney = GetPlayerMoney(i);
				if (plactualmoney > ScriptMoney[i] && plactualmoney-999 > ScriptMoney[i])
				{
					// Probably using a money hack, let's freeze them, lock their account and kick them.
					GetPlayerName(i, plname, sizeof(plname));
					TogglePlayerControllable(i, 0);
/*
					format(string, sizeof(string), "AdmCmd: %s was banned by DUCK, reason: money cheat", plname);
					SendClientMessageToAll(COLOR_LIGHTRED, string);
*/
					PlayerInfo[i][pLocked] = 1;
					SavePlayer(i);
					GetPlayerIp(i, banip, sizeof(banip));
					new spawnedamount = plactualmoney-ScriptMoney[i];
					format(string, sizeof(string), "AdmCmd: %s was locked by DUCK, reason: money cheat ($%d)", plname, spawnedamount);
					BanLog(string);
					Kick(i);
					ScriptMoney[i] = 0;
					ScriptMoneyUpdated[i] = 0;
					SendClientMessageToAll(COLOR_LIGHTRED, string);
				}
				else
				{
					ScriptMoney[i] = plactualmoney;
					ScriptMoneyUpdated[i] = 0;
				}
			}
/*			gettime(curHour, curMinute, curSecond);
			if (ScriptWeaponsUpdated[i]+3 < curSecond)
			{
				hacking = 0;
				for (new c=0; c<13; c++)
				{
					GetPlayerWeaponData(i, c, weaponid, ammo);
					if (weaponid != 0 && ammo != 0)
					{
						if (ScriptWeapons[i][c] != weaponid)
						{
							hacking = weaponid;
						}
					}
				}
				if (hacking != 0)
				{
					// Probably using a weapon hack, let's freeze them, lock their account and kick them.
					TogglePlayerControllable(i, 0);
					GetPlayerName(i, plname, sizeof(plname));
					format(string, sizeof(string), "AdmCmd: %s was banned by DUCK, reason: weapon hack", plname);
					SendClientMessageToAll(COLOR_LIGHTRED, string);
					BanLog(string);
					PlayerInfo[i][pLocked] = 1;
					SavePlayer(i);
					GetPlayerIp(i, banip, sizeof(banip));
					BanAdd(4, PlayerInfo[i][pSQLID], banip, hacking);
					//format(string, sizeof(string), "Anticheat: %s [SQL: %d] has just been locked and kicked for weapon hacking. Please check the account.", plname, PlayerInfo[i][pSQLID]);
					Kick(i);
					for (new c=0; c<13; c++) ScriptWeapons[i][c] = 0;
					ScriptWeaponsUpdated[i] = 0;
					//ABroadCast(COLOR_LIGHTRED,string,1);
				}
			}*/
/*
			for (new n=0; n<12; n++)
			{
				GetPlayerWeaponData(i, n, weaponid, ammo);
				if (ammo > MAX_AMMO && weaponid != 0)
			    {
				    GetPlayerName(i, plname, sizeof(plname));
    				format(string, sizeof(string), "AdmCmd: %s was banned by DUCK, reason: weapon hack", plname);
    				SendClientMessageToAll(COLOR_LIGHTRED, string);
    				BanLog(string);
					PlayerInfo[i][pLocked] = 1;
					SavePlayer(i);
					Kick(i);
			    }

			    if (weaponid == 38)
			    {
				    GetPlayerName(i, plname, sizeof(plname));
    				format(string, sizeof(string), "AdmCmd: %s was banned by DUCK, reason: minigun invasion", plname);
    				SendClientMessageToAll(COLOR_LIGHTRED, string);
    				BanLog(string);
//					PlayerInfo[i][pLocked] = 1;
//					SavePlayer(i);
					Ban(i);
			    }
			}
*/
			GetPlayerWeaponData(i, 7, weaponid, ammo);
			new pSpecialAction = GetPlayerSpecialAction(i);
			if (weaponid > 1 || pSpecialAction == SPECIAL_ACTION_USEJETPACK)
			{
				// Illegal weapon
				TogglePlayerControllable(i, 0);
				SendClientMessage(i, COLOR_LIGHTRED, "Anticheat: You have been banned due to suspected cheating.");
				SendClientMessage(i, COLOR_LIGHTRED, "Anticheat: Please contact an admin on ventrilo or on the forum immediately if you feel this is in error.");
				SendClientMessage(i, COLOR_RED, "DUCK Anticheat 1.5 by Luk0r (Edited by Ellis/Scorcher)");
				//PlayerInfo[i][pLocked] = 1;
				SavePlayer(i);
				//GetPlayerIp(i, banip, sizeof(banip));
				//BanAdd(4, PlayerInfo[i][pSQLID], banip, 38);
				GetPlayerName(i, plname, sizeof(plname));
				format(string, sizeof(string), "AdmCmd: %s was banned by DUCK, reason: weapon hack", plname);
				Ban(i);
				SendClientMessageToAll(COLOR_LIGHTRED, string);
			}
		}
	}
}

public OtherTimer()
{
    new Float:maxspeed = 175.0;
    new plname[MAX_PLAYER_NAME];
	new string[256];
	new Float:oldposx, Float:oldposy, Float:oldposz;
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if (GetPlayerState(i) == 1) CheckForWalkingTeleport(i); // IF THE PLAYER IS IN A TELEPORT ZONE, TELEPORT THEM
	        new vehicleid = GetPlayerVehicleID(i);
            if(SafeTime[i] > 0)
			{
				SafeTime[i]--;
			}
			if(SafeTime[i] == 1)
			{
				if(gPlayerAccount[i] == 1 && gPlayerLogged[i] == 0)
				{
					SendClientMessage(i, COLOR_WHITE, "Meo: You can now login by typing /login <password>");
				}
			}
		    if(GetPlayerState(i) == 2)
		    {
				GetPlayerPos(i, TelePos[i][3], TelePos[i][4], TelePos[i][5]);
				if(TelePos[i][5] > 550.0)
				{
					TelePos[i][0] = 0.0;
					TelePos[i][1] = 0.0;
				}
				if(TelePos[i][0] != 0.0)
				{
					new Float:xdist = TelePos[i][3]-TelePos[i][0];
					new Float:ydist = TelePos[i][4]-TelePos[i][1];
					new Float:sqxdist = xdist*xdist;
					new Float:sqydist = ydist*ydist;
					new Float:distance = (sqxdist+sqydist)/31;
					if ((BusrouteEast[i][0] == 0 && BusrouteWest[i][0] == 0))
					{
						if(gSpeedo[i] == 2)
						{
							if(distance <10)
							{
								format(string, 256, "~n~~n~~n~~n~~n~~n~~n~~g~mph :   ~w~%.0f",distance);
							}
							if(distance > 10 && distance < 100)
							{
								format(string, 256, "~n~~n~~n~~n~~n~~n~~n~~g~mph :  ~w~%.0f",distance);
							}
							if(distance > 100)
							{
								format(string, 256, "~n~~n~~n~~n~~n~~n~~n~~g~mph : ~w~%.0f",distance);
							}
							GameTextForPlayer(i, string, 2000, 5);
						}
						if(distance > maxspeed && PlayerInfo[i][pAdmin] < 1)
						{
							new tmpcar = GetPlayerVehicleID(i);
							if(!IsAPlane(tmpcar))
							{
								GetPlayerName(i, plname, sizeof(plname));
								format(string, 256, "AdmWarning: [%d]%s %.0f mph",i,plname,distance);
								ABroadCast(COLOR_YELLOW,string,1);
							}
						}
					}
				}
				if(TelePos[i][5] < 550.0 && TelePos[i][3] != 0.0)
				{
					TelePos[i][0] = TelePos[i][3];
					TelePos[i][1] = TelePos[i][4];
				}
			}
		    if(PlayerInfo[i][pLocal] != 255 && PlayerInfo[i][pInt] != 0)
			{
				new house = PlayerInfo[i][pLocal];
				GetPlayerPos(i, oldposx, oldposy, oldposz);
				if(oldposz != 0.0)
				{
					if(oldposz < 600.0)
					{
						/*if(house > 10000)
						{
							new tmpcar = GetPlayerVehicleID(i);
							if (!PlayerToPoint(6, i,1040.6,-1021.0,31.7) && house == 10001 ||!PlayerToPoint(6, i,-2720.5,217.5,4.1) && house == 10002 ||!PlayerToPoint(6, i,2644.6,-2044.9,13.3) && house == 10003)
							{
								if (GetPlayerState(i) == 2)
								{
									SetVehiclePos(tmpcar, HouseCarSpawns[tmpcar-1][0], HouseCarSpawns[tmpcar-1][1], HouseCarSpawns[tmpcar-1][2]);
									SetVehicleZAngle(tmpcar, HouseCarSpawns[tmpcar-1][3]);
								}
								else
								{
									SetPlayerPos(i, HouseCarSpawns[tmpcar-1][0], HouseCarSpawns[tmpcar-1][1], HouseCarSpawns[tmpcar-1][2]);
								}
								new oldcash = gSpentCash[i];
								new Total = GetPlayerMoney(i) - oldcash;
								printf("Total %d = GetPlayerMoney(playerid) %d - oldcash %d",Total,GetPlayerMoney(i),oldcash);
								new name[MAX_PLAYER_NAME];
								GetPlayerName(i, name, sizeof(name));
								format(string,128,"<< %s has left the homemodshop with $%d >>",name,Total);
								PayLog(string);
								gSpentCash[i] = 0;
								TelePos[i][0] = 0.0;
								TelePos[i][1] = 0.0;
								PlayerInfo[i][pLocal] = 255;
								SetPlayerInterior(i,0);
								PlayerInfo[i][pInt] = 0;
								Spectate[i] = 255;
							}
						}*/
						if(house == 242)
						{
						    SetPlayerInterior(i,0);
							SetPlayerPos(i,-2518.5967,-623.2701,132.7679);
							PlayerInfo[i][pInt] = 0;
							PlayerInfo[i][pLocal] = 255;
						}
						/*if(house >= 99 && house != 10000)
						{
							SetPlayerPos(i, BizzInfo[house-99][bEntranceX], BizzInfo[house-99][bEntranceY],BizzInfo[house-99][bEntranceZ]); // Warp the player
							PlayerInfo[i][pLocal] = 255;
							SetPlayerInterior(i,0);
							PlayerInfo[i][pInt] = 0;
						}*/
						else if(house < 99 && house != 10000)
						{
							SetPlayerPos(i, HouseInfo[house][hEntrancex], HouseInfo[house][hEntrancey],HouseInfo[house][hEntrancez]); // Warp the player
							PlayerInfo[i][pLocal] = 255;
							SetPlayerInterior(i,0);
							PlayerInfo[i][pInt] = 0;
						}
					}
				}
			}
		    if(CellTime[i] > 0)
			{
				if (CellTime[i] == cchargetime)
				{
					CellTime[i] = 1;
					if(Mobile[Mobile[i]] == i)
					{
						//PlayerInfo2[CallCost][i] = CallCost[i]+callcost;
						PlayerInfo2[CallCost][i] = callcost;
					}
				}
				CellTime[i] = CellTime[i] +1;
				if (Mobile[Mobile[i]] == 255 && CellTime[i] == 5)
				{
				    if(IsPlayerConnected(Mobile[i]))
				    {
						new called[MAX_PLAYER_NAME];
						GetPlayerName(Mobile[i], called, sizeof(called));
						format(string, sizeof(string), "* %s's phone rings.", called);
						RingTone[Mobile[i]] = 10;
						ProxDetector(30.0, Mobile[i], string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
				}
			}
			if(CellTime[i] == 0 && PlayerInfo2[CallCost][i] > 0)
			{
				format(string, sizeof(string), "~w~The call cost~n~~r~$%d",PlayerInfo2[CallCost][i]);
				//SafeGivePlayerMoney(i, -= PlayerInfo2[CallCost][i];);
				CellTime[i] -= PlayerInfo2[CallCost][i];
				SBizzInfo[2][sbTill] += PlayerInfo2[CallCost][i];
				ExtortionSBiz(2, PlayerInfo2[CallCost][i]);
				GameTextForPlayer(i, string, 5000, 1);
				PlayerInfo2[CallCost][i] = 0;
			}
			if(TransportTime[i] > 0)
			{//Taxi driver and passenger only
			    if(TransportTime[i] >= 16)
				{
					TransportTime[i] = 1;
					if(TransportDriver[i] < 999)
					{
						if(IsPlayerConnected(TransportDriver[i]))
						{
	      					TransportCost[i] += TransportValue[TransportDriver[i]];
						    TransportCost[TransportDriver[i]] = TransportCost[i];
						}
					}
				}
			    TransportTime[i] += 1;
			    format(string, sizeof(string), "~r~%d ~w~: ~g~$%d",TransportTime[i],TransportCost[i]);
			    GameTextForPlayer(i, string, 15000, 6);
			}
			if (BusrouteEast[i][0] != 0 || BusrouteWest[i][0] != 0)
			{
				if (!IsPlayerInAnyVehicle(i) || !IsABus(GetPlayerVehicleID(i)))
				if (vehicleid != 0)
				{
					if (!IsABus(vehicleid))
					{
						if (BusrouteEast[i][0] != 0) BusrouteEnd(i, BusrouteEast[i][1]);
						else if (BusrouteWest[i][0] != 0) BusrouteEnd(i, BusrouteWest[i][1]);
					}
				}
				else
				{
					if (BusrouteEast[i][0] != 0) BusrouteEnd(i, BusrouteEast[i][1]);
					else if (BusrouteWest[i][0] != 0) BusrouteEnd(i, BusrouteWest[i][1]);
				}
			}
			if (IsABus(vehicleid) && GetPlayerState(i) == 2 && PlayerInfo[i][pJob] != 14)
			{
				SetVehicleToRespawn(vehicleid);
			}
		}
	}
	return 1;
}

public SetPlayerUnjail()
{
//	new plname[MAX_PLAYER_NAME];
	new string[256];
	if(PaintballPlayers >= 2 && PaintballRound != 1 && StartingPaintballRound != 1)
	{
		StartingPaintballRound = 1;
	   	SetTimer("PreparePaintball", 15000, 0);
	}
	if(KartingPlayers >= 2 && KartingRound != 1 && StartingKartRound != 1)
	{
	    StartingKartRound = 1;
	    SetTimer("PrepareKarting", 15000, 0);
	}
	if(KartingRound != 0 && KartingPlayers < 2)
	{
	    StartingKartRound = 0;
	    KartingRound = 0;
	    EndingKartRound = 1;
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
			new newcar = GetPlayerVehicleID(i);
			new level = PlayerInfo[i][pLevel];
			if(level >= 0 && level <= 2) { PlayerInfo[i][pPayCheck] += 1; }
			else if(level >= 3 && level <= 4) { PlayerInfo[i][pPayCheck] += 2; }
			else if(level >= 5 && level <= 6) { PlayerInfo[i][pPayCheck] += 3; }
			else if(level >= 7 && level <= 8) { PlayerInfo[i][pPayCheck] += 4; }
			else if(level >= 9 && level <= 10) { PlayerInfo[i][pPayCheck] += 5; }
			else if(level >= 11 && level <= 12) { PlayerInfo[i][pPayCheck] += 6; }
			else if(level >= 13 && level <= 14) { PlayerInfo[i][pPayCheck] += 7; }
			else if(level >= 15 && level <= 16) { PlayerInfo[i][pPayCheck] += 8; }
			else if(level >= 17 && level <= 18) { PlayerInfo[i][pPayCheck] += 9; }
			else if(level >= 19 && level <= 20) { PlayerInfo[i][pPayCheck] += 10; }
			else if(level >= 21) { PlayerInfo[i][pPayCheck] += 11; }
		    if(PlayerInfo[i][pJailed] > 0)
		    {
				if(PlayerInfo[i][pJailTime] > 0 && WantLawyer[i] == 0)
				{
					PlayerInfo[i][pJailTime]--;
				}
				if(PlayerInfo[i][pJailTime] <= 0 && WantLawyer[i] == 0)
				{
				    PlayerInfo[i][pJailTime] = 0;
					if(PlayerInfo[i][pJailed] == 1)
					{
						SetPlayerInterior(i, 6);
						PlayerInfo[i][pInt] = 6;
						SetPlayerPos(i,246.8439,70.0776,1003.6406);
					}
					else if(PlayerInfo[i][pJailed] == 2)
					{
					    SetPlayerWorldBounds(i,20000.0000,-20000.0000,20000.0000,-20000.0000); //Reset world to player
					    SetPlayerInterior(i, 0);
					    PlayerInfo[i][pInt] = 0;
					    SetPlayerPos(i, 90.2101,1920.4854,17.9422);
					}
					PlayerInfo[i][pJailed] = 0;
					SendClientMessage(i, COLOR_GRAD1,"Warden: You've been released from jail.");
					SendClientMessage(i, COLOR_GRAD1,"Warden: Think about the time, before you do the crime.");
					format(string, sizeof(string), "~g~Freedom~n~~w~Try to be a better citizen");
					GameTextForPlayer(i, string, 5000, 1);
					if(gTeam[i] == 4) { gTeam[i] = 3; }
					ClearCrime(i);
					SetPlayerToTeamColor(i);
				}
			}
			/*if(GetPlayerMoney(i) - CurrentMoney[i] >= 20000 && PlayerInfo[i][pAdmin] < 1)
		    {
		        if(ConsumingMoney[i])
		        {
                    CurrentMoney[i] = GetPlayerMoney(i);
					ConsumingMoney[i] = 0;
		        }
		        else
		        {
			        GetPlayerName(i, plname, sizeof(plname));
			        format(string, 256, "AdmWarning: [%d]%s just spawned above $20000 in one second (moneycheat), use /check on him.",i,plname);
					ABroadCast(COLOR_YELLOW,string,1);
					PayLog(string);
			        CurrentMoney[i] = GetPlayerMoney(i);
			        TogglePlayerControllable(i, 0);
	            	SendClientMessage(i, COLOR_YELLOW, "Frozen for money cheat detection.");
		        }
		    }
		    else
		    {
		        CurrentMoney[i] = GetPlayerMoney(i);
		    }*/
		    if(IsABoat(newcar))
			{
			    if(PlayerInfo[i][pBoatLic] < 1 && GetPlayerState(i) == 2)
				{
				    RemovePlayerFromVehicle(i);
				}
			}
			else if(IsAPlane(newcar))
			{
			    if(PlayerInfo[i][pFlyLic] < 1 && GetPlayerState(i) == 2)
				{
				    if(TakingLesson[i] == 1) { }
				}
			}
			else
			{
				if(PlayerInfo[i][pCarLic] < 1 && IsPlayerInAnyVehicle(i) && GetPlayerState(i) == 2)
				{
					if(TakingLesson[i] == 1) { }
				}
			}//Done with car check
		    if(UsedFind[i] >= 1)
		    {
		        UsedFind[i] += 1;
				if(UsedFind[i] >= 120)
				{
				    UsedFind[i] = 0;
				}
		    }
   			if(MedicTime[i] > 0)
			{
			    if(MedicTime[i] == 3)
			    {
			        SetPlayerInterior(i, 3);
			        PlayerInfo[i][pInt] = 3;
			        new Float:X, Float:Y, Float:Z;
			        GetPlayerPos(i, X,Y,Z);
			        SetPlayerCameraPos(i, X - 3, Y, Z);
			        SetPlayerCameraLookAt(i,X,Y,Z);
			    }
			    MedicTime[i] ++;
			    if(MedicTime[i] >= NeedMedicTime[i])
			    {
					new cut = deathcost; //PlayerInfo[playerid][pLevel]*deathcost;
					//SafeGivePlayerMoney(i, -cut);
					format(string, sizeof(string), "Bac si: Hoa don dieu tri cua ban la $%d, Chuc mot ngay tot lanh.", cut);
					SendClientMessage(i, TEAM_CYAN_COLOR, string);
					TogglePlayerControllable(i, 1);
			        MedicBill[i] = 0;
			        MedicTime[i] = 0;
			        NeedMedicTime[i] = 0;
			        PlayerInfo[i][pDeaths] += 1;
			        PlayerFixRadio(i);
			        ClearAnimations(i);
			        SetPlayerSpawn(i);
					SetCameraBehindPlayer(i);
					SafeResetPlayerWeapons(i);
			    }
			}
			if(WantLawyer[i] >= 1)
			{
			    CallLawyer[i] = 111;
			    if(WantLawyer[i] == 1)
				{
				    SendClientMessage(i, COLOR_YELLOW2, "Do you want a Lawyer? (Type yes or no)");
				}
				WantLawyer[i] ++;
				if(WantLawyer[i] == 8)
				{
				    SendClientMessage(i, COLOR_YELLOW2, "Do you want a Lawyer? (Type yes or no)");
				}
	            if(WantLawyer[i] == 15)
				{
				    SendClientMessage(i, COLOR_YELLOW2, "Do you want a Lawyer? (Type yes or no)");
				}
				if(WantLawyer[i] == 20)
				{
				    SendClientMessage(i, COLOR_YELLOW2, "There is no Lawyer available to you anymore, Jail Time started.");
				    WantLawyer[i] = 0;
				    CallLawyer[i] = 0;
				}
			}
			if(TutTime[i] >= 1)
			{
			    TutTime[i] += 1;
                if(TutTime[i] == 3)
			    {
			        ClearChatbox(i, 10);
			        SendClientMessage(i, COLOR_WHITE, "Vay ban la nguoi moi ? Chung toi se chi cho ban mot vai noi va cho ban mot vai huong dan, goi y.");
			        SendClientMessage(i, COLOR_WHITE, "Neu ban khong biet cach choi Roleplay, moi ban ra khoi sever.");
			        SendClientMessage(i, COLOR_WHITE, " ");
			        SetPlayerCameraPos(i, 2247.0215,-1655.0173,17.2856);
					SetPlayerCameraLookAt(i, 2244.6536,-1663.9304,15.4766);
					SetPlayerInterior(i, 0);
					SetPlayerVirtualWorld(i, 99);
					SetPlayerPos(i, 2256.3555,-1646.6377,15.4959);
			        SendClientMessage(i, COLOR_YELLOW, ":: CUA HANG QUAN AO ::");
			        SendClientMessage(i, COLOR_WHITE, " ");
			        SendClientMessage(i, COLOR_YELLOW2, "Truoc het, ban can phai co quan ao. Ban co the mua quan ao tai cac cua hang quan ao.");
			        SendClientMessage(i, COLOR_YELLOW2, "Khi ban o trong cua hang quan ao, go /clothes va go ( next ) de tim kiem trang phuc ma ban thich.");
			    }
			    else if(TutTime[i] == 16)
			    {
			        ClearChatbox(i, 10);
			        SetPlayerPos(i, 2089.6624,-1901.7891,13.5469);
			        SetPlayerCameraPos(i, 2070.8093,-1914.6747,18.5469);
					SetPlayerCameraLookAt(i, 2055.2405,-1906.4608,13.5469);
					SetPlayerInterior(i, 0);
			        SendClientMessage(i, COLOR_YELLOW, ":: TRUONG DAO TAO LAI XE ::");
			        SendClientMessage(i, COLOR_WHITE, " ");
			        SendClientMessage(i, COLOR_YELLOW2, "Ban van chua co bang lai xe? That xau ho cho ban !");
			        SendClientMessage(i, COLOR_YELLOW2, "Ban can phai vuot qua bai kiem tra lai xe de lay bang lai.");
			        SendClientMessage(i, COLOR_YELLOW2, "Ban co the xem danh sach cac bang cap bang cach go /licensers.");
			    }
			    else if(TutTime[i] == 32)
			    {
			        ClearChatbox(i, 10);
			        SetPlayerPos(i, 1514.3059,-1667.8116,14.0469);
			        SetPlayerCameraPos(i, 1535.9584,-1676.1428,18.3828);
					SetPlayerCameraLookAt(i, 1553.7861,-1676.4270,16.1953);
					SetPlayerInterior(i, 0);
			        SendClientMessage(i, COLOR_YELLOW, ":: SO CANH SAT LOS ANGELES ::");
			        SendClientMessage(i, COLOR_WHITE, " ");
			        SendClientMessage(i, COLOR_YELLOW2, "So cach sat Los Angeles va FBI luon o trong thanh pho de dam bao an toan cho ban.");
			        SendClientMessage(i, COLOR_YELLOW2, "Nhung nguoi pham toi se bi xu ly nhanh chong va manh tay neu can thiet.");
			        SendClientMessage(i, COLOR_YELLOW2, "De goi canh sat, goi vao duong day nong ( go /call 911 ).");
			    }
			    else if(TutTime[i] == 54)
			    {
			        ClearChatbox(i, 10);
			        SetPlayerPos(i, 1221.7010,-1328.6449,13.4821);
			        SetPlayerCameraPos(i, 1204.3781,-1313.3323,16.3984);
					SetPlayerCameraLookAt(i, 1174.7167,-1323.4485,14.5938);
					SetPlayerInterior(i, 0);
			        SendClientMessage(i, COLOR_YELLOW, ":: BENH VIEN TRUNG UONG THANH PHO ::");
			        SendClientMessage(i, COLOR_WHITE, " ");
			        SendClientMessage(i, COLOR_YELLOW2, "Cam thay khong khoe? Ban can den gap bac si cua Los Angeles.");
			        SendClientMessage(i, COLOR_YELLOW2, "De goi cho nhan vien y te, goi vao duong day nong ( go /call 911 ).");
			        SendClientMessage(i, COLOR_YELLOW2, "Ban se duoc hoi sinh o day sau khi chet");
			    }
			    else if(TutTime[i] == 76)
			    {
			        ClearChatbox(i, 10);
			        SetPlayerPos(i, 1786.1758,-1258.4976,13.6417);
			        SetPlayerCameraPos(i, 1779.4259,-1275.1025,15.6328);
					SetPlayerCameraLookAt(i, 1785.7263,-1296.0200,13.4213);
					SetPlayerInterior(i, 0);
			        SendClientMessage(i, COLOR_YELLOW, ":: ABC STUDIO ::");
			        SendClientMessage(i, COLOR_WHITE, " ");
			        SendClientMessage(i, COLOR_YELLOW2, "Muon thong bao mot so tin tuc moi? Hay den gap phong vien cua ABC Studio va yeu cau ho lam viec do.");
			        SendClientMessage(i, COLOR_YELLOW2, "Ban cung co the dang tai quang cao cua ban len cac to bao dia phuong.");
			    }
			    else if(TutTime[i] == 98)
			    {
			        ClearChatbox(i, 10);
			        SetPlayerPos(i, 1475.7020,-1050.9489,23.8246);
			        SetPlayerCameraPos(i, 1458.3872,-1042.2423,24.8281);
					SetPlayerCameraLookAt(i, 1458.5930,-1019.9205,24.5264);
					SetPlayerInterior(i, 0);
			        SendClientMessage(i, COLOR_YELLOW, ":: NGAN HANG QUOC GIA ::");
			        SendClientMessage(i, COLOR_WHITE, " ");
			        SendClientMessage(i, COLOR_YELLOW2, "Ban khong the giu het tien trong nguoi, ai do se co gang an cap no.");
			        SendClientMessage(i, COLOR_YELLOW2, "Ban co the go /deposit, hoac /withdraw tien cua ban tai ngan hang.");
			        SendClientMessage(i, COLOR_YELLOW2, "Tien tro cap cua ban ( Payday ) se duoc chuyen vao tai khoan ngan hang cua ban.");
			    }
			    else if(TutTime[i] == 110)
			    {
			        ClearChatbox(i, 10);
			        SetPlayerInterior(i, 3);
			        SetPlayerPos(i, 330.6825,163.6688,1014.1875);
			        SetCameraBehindPlayer(i);
			        SetPlayerVirtualWorld(i, 0);
			        SendClientMessage(i, COLOR_YELLOW, ":: KET THUC PHAN HUONG DAN ::");
			        SendClientMessage(i, COLOR_WHITE, " ");
			        SendClientMessage(i, COLOR_YELLOW2, "Con rat nhieu noi khac tai Los Angeles, nhung ban can phai tu minh kham pha.");
			        SendClientMessage(i, COLOR_YELLOW2, "Dung co quen luat Role-Play nhe, boi vi pham luat (NON-RPing) co the bi canh cao va banned!");
			        SendClientMessage(i, COLOR_YELLOW2, "Loi chao than ai va quyet thang tu: Team admin Les Angeles Roleplay.");
			    }
			    else if(TutTime[i] == 119)
			    {
			        ClearChatbox(i, 10);
			        SendClientMessage(i, COLOR_YELLOW2, "Chao mung ban den voi Los Angeles.");
			        SendClientMessage(i, COLOR_GRAD1, "Meo: De goi taxi hoac bus go /call 444 hoac /call 222");
			        SendClientMessage(i, COLOR_GRAD1, "Meo: De thay doi trang phuc cua ban, ban phai den cua hang quan ao");
					SendClientMessage(i, COLOR_GRAD1, " ");
			        TutTime[i] = 0; PlayerInfo[i][pTut] = 1;
					gOoc[i] = 0; gNews[i] = 0; gFam[i] = 0;
					TogglePlayerControllable(i, 1);
					MedicBill[i] = 0;
					AfterTutorial[i] = 1;
					SetPVarInt(i, "FirstSpawn", 1);
					SetTimerEx("UnsetAfterTutorial", 2500, false, "i", i);
					SetTimerEx("UnsetFirstSpawn", 5000, false, "i", i);
					SetPlayerSpawn(i);
			    }
			}
			if(PlayerTazeTime[i] >= 1)
			{
			    PlayerTazeTime[i] += 1;
			    if(PlayerTazeTime[i] == 15)
			    {
                    PlayerTazeTime[i] = 0;
			    }
			    else
			    {
			        new Float:angle;
					GetPlayerFacingAngle(i, angle);
					SetPlayerFacingAngle(i, angle + 90);
			    }
			}
			if(PlayerDrunk[i] >= 5)
			{
			    PlayerDrunkTime[i] += 1;
			    if(PlayerDrunkTime[i] == 8)
			    {
			        PlayerDrunkTime[i] = 0;
			        new Float:angle;
					GetPlayerFacingAngle(i, angle);
					if(IsPlayerInAnyVehicle(i))
					{
					    if(GetPlayerState(i) == 2)
					    {
					    	SetVehicleZAngle(GetPlayerVehicleID(i), angle + 25);
						}
					}
					else
					{
					    ApplyAnimation(i,"PED", "WALK_DRUNK",4.0,0,1,0,0,0);
					}
			    }
			}
			if(PlayerStoned[i] >= 2)
			{
		        PlayerStoned[i] += 0;
			    if(PlayerStoned[i] == 0)
			    {
			        PlayerStoned[i] = 2;
			        new Float:angle;
					GetPlayerFacingAngle(i, angle);
					if(IsPlayerInAnyVehicle(i))
					{
					    if(GetPlayerState(i) == 2)
					    {
					    	SetVehicleZAngle(GetPlayerVehicleID(i), angle + 0);
						}
					}
					else
					{
					    SetPlayerFacingAngle(i, angle + 0);
					}
			    }
			}
			if(PlayerInfo[i][pCarTime] > 0)
			{
			    if(PlayerInfo[i][pCarTime] <= 0)
			    {
			        PlayerInfo[i][pCarTime] = 0;
			    }
			    else
			    {
			        PlayerInfo[i][pCarTime] -= 1;
			    }
			}
			if(BoxWaitTime[i] > 0)
			{
			    if(BoxWaitTime[i] >= BoxDelay)
				{
				    BoxDelay = 0;
					BoxWaitTime[i] = 0;
					PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
					GameTextForPlayer(i, "~g~Match Started", 5000, 1);
					TogglePlayerControllable(i, 1);
					RoundStarted = 1;
				}
			    else
				{
				    format(string, sizeof(string), "%d", BoxDelay - BoxWaitTime[i]);
					GameTextForPlayer(i, string, 1500, 6);
					BoxWaitTime[i] += 1;
				}
			}
			if(RoundStarted > 0)
			{
			    if(PlayerBoxing[i] > 0)
			    {
			        new trigger = 0;
			        new Lost = 0;
		        	new Float:angle;
		            new Float:health;
					GetPlayerHealth(i, health);
		            if(health < 12)
					{
					    if(i == Boxer1) { Lost = 1; trigger = 1; }
			            else if(i == Boxer2) { Lost = 2; trigger = 1; }
					}
			        if(health < 28) { GetPlayerFacingAngle(i, angle); SetPlayerFacingAngle(i, angle + 85); }
			        if(trigger)
			        {
			            new winner[MAX_PLAYER_NAME];
			            new loser[MAX_PLAYER_NAME];
			            new titel[MAX_PLAYER_NAME];
			            if(Lost == 1)
			            {
			                if(IsPlayerConnected(Boxer1) && IsPlayerConnected(Boxer2))
			                {
					        	SetPlayerPos(Boxer1, 765.8433,3.2924,1000.7186); SetPlayerPos(Boxer2, 765.8433,3.2924,1000.7186);
					        	SetPlayerInterior(Boxer1, 5); SetPlayerInterior(Boxer2, 5);
					        	PlayerInfo[Boxer1][pInt] = 5; PlayerInfo[Boxer2][pInt] = 5;
			                	GetPlayerName(Boxer1, loser, sizeof(loser));
			                	GetPlayerName(Boxer2, winner, sizeof(winner));
		                		if(PlayerInfo[Boxer1][pJob] == 12) { PlayerInfo[Boxer1][pLoses] += 1; }
								if(PlayerInfo[Boxer2][pJob] == 12) { PlayerInfo[Boxer2][pWins] += 1; }
			                	if(TBoxer < 255)
			                	{
			                	    if(IsPlayerConnected(TBoxer))
			                	    {
				                	    if(TBoxer != Boxer2)
				                	    {
				                	        if(PlayerInfo[Boxer2][pJob] == 12)
				                	        {
				                	            TBoxer = Boxer2;
				                	            GetPlayerName(TBoxer, titel, sizeof(titel));
					                	        new nstring[MAX_PLAYER_NAME];
												format(nstring, sizeof(nstring), "%s", titel);
												strmid(Titel[TitelName], nstring, 0, strlen(nstring), 255);
					                	        Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
					                	        Titel[TitelLoses] = PlayerInfo[TBoxer][pLoses];
					                	        SaveBoxer();
							                	format(string, sizeof(string), "Boxing News: %s Da thang tran dau tranh dai vo dich hang nang %s Bay gio tro thanh nha vo dich moi.",  titel, loser);
												OOCOff(COLOR_WHITE,string);
				                	        }
				                	        else
				                	        {
				                	            SendClientMessage(Boxer2, COLOR_WHITE, "*Ban co the tro thanh nha vo dich neu ban lam nghe boxing !");
				                	        }
										}
										else
										{
										    GetPlayerName(TBoxer, titel, sizeof(titel));
										    format(string, sizeof(string), "Boxing News: Tran dau boxing tranh dai vo dich %s Da gianh chien thang %s.",  titel, loser);
											OOCOff(COLOR_WHITE,string);
											Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
				                	        Titel[TitelLoses] = PlayerInfo[Boxer2][pLoses];
				                	        SaveBoxer();
										}
									}
								}//TBoxer
								format(string, sizeof(string), "* Ban da thua tran dau %s.", winner);
								SendClientMessage(Boxer1, COLOR_WHITE, string);
								GameTextForPlayer(Boxer1, "~r~You lost", 3500, 1);
								format(string, sizeof(string), "* Ban da thang tran dau %s.", loser);
								SendClientMessage(Boxer2, COLOR_WHITE, string);
								GameTextForPlayer(Boxer2, "~r~You won", 3500, 1);
								if(GetPlayerHealth(Boxer1, health) < 20)
								{
								    SendClientMessage(Boxer1, COLOR_WHITE, "* Ban cam thay kiet suc sau tran dau, hay di an gi do.");
								    SetPlayerHealth(Boxer1, 30.0);
								}
								else
								{
								    SendClientMessage(Boxer1, COLOR_WHITE, "*Ban cam thay van khoe sau khi xong tran dau, hay nghi ngoi de tro lai.");
								    SetPlayerHealth(Boxer1, 50.0);
								}
								if(GetPlayerHealth(Boxer2, health) < 20)
								{
								    SendClientMessage(Boxer2, COLOR_WHITE, "* Ban cam thay kiet suc sau tran dau, hay di an gi do.");
							    	SetPlayerHealth(Boxer2, 30.0);
								}
								else
								{
								    SendClientMessage(Boxer2, COLOR_WHITE, "* Ban cam thay van khoe sau khi xong tran dau, hay nghi ngoi de tro lai.");
								    SetPlayerHealth(Boxer2, 50.0);
								}
                                GameTextForPlayer(Boxer1, "~g~Tran dau ket thuc", 5000, 1); GameTextForPlayer(Boxer2, "~g~Tran dau ket thuc", 5000, 1);
								if(PlayerInfo[Boxer2][pJob] == 12) { PlayerInfo[Boxer2][pBoxSkill] += 1; }
								PlayerBoxing[Boxer1] = 0;
								PlayerBoxing[Boxer2] = 0;
							}
			            }
			            else if(Lost == 2)
			            {
			                if(IsPlayerConnected(Boxer1) && IsPlayerConnected(Boxer2))
			                {
					        	SetPlayerPos(Boxer1, 765.8433,3.2924,1000.7186); SetPlayerPos(Boxer2, 765.8433,3.2924,1000.7186);
					        	SetPlayerInterior(Boxer1, 5); SetPlayerInterior(Boxer2, 5);
					        	PlayerInfo[Boxer1][pInt] = 5; PlayerInfo[Boxer2][pInt] = 5;
			                	GetPlayerName(Boxer1, winner, sizeof(winner));
			                	GetPlayerName(Boxer2, loser, sizeof(loser));
		                		if(PlayerInfo[Boxer2][pJob] == 12) { PlayerInfo[Boxer2][pLoses] += 1; }
								if(PlayerInfo[Boxer1][pJob] == 12) { PlayerInfo[Boxer1][pWins] += 1; }
			                	if(TBoxer < 255)
			                	{
			                	    if(IsPlayerConnected(TBoxer))
			                	    {
				                	    if(TBoxer != Boxer1)
				                	    {
				                	        if(PlayerInfo[Boxer1][pJob] == 12)
				                	        {
					                	        TBoxer = Boxer1;
					                	        GetPlayerName(TBoxer, titel, sizeof(titel));
					                	        new nstring[MAX_PLAYER_NAME];
												format(nstring, sizeof(nstring), "%s", titel);
												strmid(Titel[TitelName], nstring, 0, strlen(nstring), 255);
					                	        Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
					                	        Titel[TitelLoses] = PlayerInfo[TBoxer][pLoses];
					                	        SaveBoxer();
							                	format(string, sizeof(string), "Boxing News: %s Da thang tran dau tranh dai vo dich hang nang %s Bay gio tro thanh nha vo dich moi.",  titel, loser);
												OOCOff(COLOR_WHITE,string);
											}
				                	        else
				                	        {
				                	            SendClientMessage(Boxer1, COLOR_WHITE, "* Ban co the tro thanh nha vo dich neu ban lam nghe boxing !");
				                	        }
										}
										else
										{
										    GetPlayerName(TBoxer, titel, sizeof(titel));
										    format(string, sizeof(string), "Boxing News: Tran dau boxing tranh dai vo dich %s Da gianh chien thang %s.",  titel, loser);
											OOCOff(COLOR_WHITE,string);
											Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
				                	        Titel[TitelLoses] = PlayerInfo[Boxer1][pLoses];
				                	        SaveBoxer();
										}
									}
								}//TBoxer
								format(string, sizeof(string), "* Ban da thua tran dau %s.", winner);
								SendClientMessage(Boxer2, COLOR_WHITE, string);
								GameTextForPlayer(Boxer2, "~r~You lost", 3500, 1);
								format(string, sizeof(string), "* Ban da thang tran dau %s.", loser);
								SendClientMessage(Boxer1, COLOR_WHITE, string);
								GameTextForPlayer(Boxer1, "~g~You won", 3500, 1);
								if(GetPlayerHealth(Boxer1, health) < 20)
								{
								    SendClientMessage(Boxer1, COLOR_WHITE, "*  Ban cam thay kiet suc sau tran dau, hay di an gi do.");
								    SetPlayerHealth(Boxer1, 30.0);
								}
								else
								{
								    SendClientMessage(Boxer1, COLOR_WHITE, "* Ban cam thay van khoe sau khi xong tran dau, hay nghi ngoi de tro lai.");
								    SetPlayerHealth(Boxer1, 50.0);
								}
								if(GetPlayerHealth(Boxer2, health) < 20)
								{
								    SendClientMessage(Boxer2, COLOR_WHITE, "*  Ban cam thay kiet suc sau tran dau, hay di an gi do.");
							    	SetPlayerHealth(Boxer2, 30.0);
								}
								else
								{
								    SendClientMessage(Boxer2, COLOR_WHITE, "* Ban cam thay van khoe sau khi xong tran dau, hay nghi ngoi de tro lai.");
								    SetPlayerHealth(Boxer2, 50.0);
								}
                                GameTextForPlayer(Boxer1, "~g~Tran dau ket thuc", 5000, 1); GameTextForPlayer(Boxer2, "~g~Tran dau ket thuc", 5000, 1);
								if(PlayerInfo[Boxer1][pJob] == 12) { PlayerInfo[Boxer1][pBoxSkill] += 1; }
								PlayerBoxing[Boxer1] = 0;
								PlayerBoxing[Boxer2] = 0;
							}
			            }
			            InRing = 0;
			            RoundStarted = 0;
			            Boxer1 = 255;
			            Boxer2 = 255;
			            TBoxer = 255;
			            trigger = 0;
			        }
			    }
			}
			if(StartingPaintballRound == 1 && AnnouncedPaintballRound == 0)
			{
			    AnnouncedPaintballRound = 1;
			    if(PlayerPaintballing[i] != 0)
			    {
			        SendClientMessage(i, COLOR_YELLOW, "Tran dau se duoc thong bao trong 15s nua (De co nhieu nguoi choi vao).");
			    }
			}
			if(StartingKartRound == 1 && AnnouncedKartRound == 0)
			{
			    AnnouncedKartRound = 1;
			    if(PlayerKarting[i] != 0 && PlayerInKart[i] != 0)
			    {
			        SendClientMessage(i, COLOR_YELLOW, "Dua kart se duoc thong bao trong 15s nua (De nhan nhieu nguoi dua).");
			    }
			}
			if(EndingKartRound == 1)
			{
			    if(PlayerKarting[i] != 0 && PlayerInKart[i] != 0)
			    {
			        DisablePlayerCheckpoint(i);
			        CP[i] = 0;
			    }
			}
			if(FindTime[i] > 0)
			{
			    if(FindTime[i] == FindTimePoints[i]) { FindTime[i] = 0; FindTimePoints[i] = 0; DisablePlayerCheckpoint(i); PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0); GameTextForPlayer(i, "~r~RedMarker gone", 2500, 1); }
			    else
				{
				    format(string, sizeof(string), "%d", FindTimePoints[i] - FindTime[i]);
					GameTextForPlayer(i, string, 1500, 6);
					FindTime[i] += 1;
				}
			}
			if(TaxiCallTime[i] > 0)
			{
			    if(TaxiAccepted[i] < 999)
			    {
				    if(IsPlayerConnected(TaxiAccepted[i]))
				    {
				        new Float:X,Float:Y,Float:Z;
						GetPlayerPos(TaxiAccepted[i], X, Y, Z);
						SetPlayerCheckpoint(i, X, Y, Z, 5);
				    }
				}
			}
			if(BusCallTime[i] > 0)
			{
			    if(BusAccepted[i] < 999)
			    {
				    if(IsPlayerConnected(BusAccepted[i]))
				    {
				        new Float:X,Float:Y,Float:Z;
						GetPlayerPos(BusAccepted[i], X, Y, Z);
						SetPlayerCheckpoint(i, X, Y, Z, 5);
				    }
				}
			}
			if(MedicCallTime[i] > 0)
			{
			    if(MedicCallTime[i] == 90) { MedicCallTime[i] = 0; DisablePlayerCheckpoint(i); PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0); GameTextForPlayer(i, "~r~RedMarker gone", 2500, 1); }
			    else
				{
				    format(string, sizeof(string), "%d", 90 - MedicCallTime[i]);
					GameTextForPlayer(i, string, 1500, 6);
					MedicCallTime[i] += 1;
				}
			}
			if(MechanicCallTime[i] > 0)
			{
			    if(MechanicCallTime[i] == 30) { MechanicCallTime[i] = 0; DisablePlayerCheckpoint(i); PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0); GameTextForPlayer(i, "~r~RedMarker gone", 2500, 1); }
			    else
				{
				    format(string, sizeof(string), "%d", 30 - MechanicCallTime[i]);
					GameTextForPlayer(i, string, 1500, 6);
					MechanicCallTime[i] += 1;
				}
			}
			if(PizzaCallTime[i] > 0)
   			{
       			if(PizzaCallTime[i] == 90) { PizzaCallTime[i] = 0; DisablePlayerCheckpoint(i); PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0); GameTextForPlayer(i, "~r~RedMarker gone", 2500, 1); }
       			else
    			{
        			format(string, sizeof(string), "%d", 90 - PizzaCallTime[i]);
     				GameTextForPlayer(i, string, 1500, 6);
     				PizzaCallTime[i] += 1;
    			}
   			}
			if(Robbed[i] == 1)
			{
			    if(RobbedTime[i] <= 0)
			    {
			        RobbedTime[i] = 0;
					Robbed[i] = 0;
			    }
			    else
			    {
			        RobbedTime[i] -= 1;
			    }
			}
			if(PlayerCuffed[i] == 1)
			{
			    if(PlayerCuffedTime[i] <= 0)
			    {
			        TogglePlayerControllable(i, 1);
			        PlayerCuffed[i] = 0;
			        PlayerCuffedTime[i] = 0;
			        PlayerTazeTime[i] = 1;
			    }
			    else
			    {
			        PlayerCuffedTime[i] -= 1;
			    }
			}
			if(PlayerCuffed[i] == 2)
			{
			    if(PlayerCuffedTime[i] <= 0)
			    {
			        GameTextForPlayer(i, "~r~Ban da hoan thanh nghia vu, bay gio ban duoc tu do", 2500, 3);
			        TogglePlayerControllable(i, 1);
			        PlayerCuffed[i] = 0;
			        PlayerCuffedTime[i] = 0;
			    }
			    else
			    {
			        PlayerCuffedTime[i] -= 1;
			    }
			}
			if(IsSmoking[i] > 0)
			{
			    if(IsSmoking[i] == 1)
			    {
			        new sendername[MAX_PLAYER_NAME];
			        GetPlayerName(i, sendername, sizeof(sendername));
				    if(PlayerInfo[i][pSex] == 1) { format(string, sizeof(string), "* %s finishes his cigarette.", sendername); }
					else { format(string, sizeof(string), "* %s finishes her cigarette.", sendername); }
				    ProxDetector(30.0, i, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    new Float:PlayerHealth;
				    GetPlayerHealth(i, PlayerHealth);
				    SetPlayerHealth(i, PlayerHealth+7);
				    if(UsingSmokeAnim[i] == 1)
				    {
				        UsingSmokeAnim[i] = 0;
				        ClearAnimations(i);
				    }
			    }
			    if(IsSmoking[i] == 51)
			    {
			        new sendername[MAX_PLAYER_NAME];
			        GetPlayerName(i, sendername, sizeof(sendername));
			        if(PlayerInfo[i][pSex] == 1) { format(string, sizeof(string), "* %s vut dieu thuoc.", sendername); }
					else { format(string, sizeof(string), "* %s flicks from her cigarette.", sendername); }
			        ProxDetector(30.0, i, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			        new Float:PlayerHealth;
			        GetPlayerHealth(i, PlayerHealth);
				    SetPlayerHealth(i, PlayerHealth+7);
			    }
			    if(IsSmoking[i] == 31)
			    {
			        new sendername[MAX_PLAYER_NAME];
			        GetPlayerName(i, sendername, sizeof(sendername));
			        if(PlayerInfo[i][pSex] == 1) { format(string, sizeof(string), "* %s vut dieu thuoc.", sendername); }
					else { format(string, sizeof(string), "* %s flicks from her cigarette.", sendername); }
			        ProxDetector(30.0, i, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			        new Float:PlayerHealth;
			        GetPlayerHealth(i, PlayerHealth);
				    SetPlayerHealth(i, PlayerHealth+7);
			    }
			    if(IsSmoking[i] == 11)
			    {
			        new sendername[MAX_PLAYER_NAME];
			        GetPlayerName(i, sendername, sizeof(sendername));
			        if(PlayerInfo[i][pSex] == 1) { format(string, sizeof(string), "* %s vut dieu thuoc.", sendername); }
					else { format(string, sizeof(string), "* %s flicks from her cigarette.", sendername); }
			        ProxDetector(30.0, i, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			        new Float:PlayerHealth;
			        GetPlayerHealth(i, PlayerHealth);
				    SetPlayerHealth(i, PlayerHealth+7);
			    }
			    IsSmoking[i] -= 1;
			}
			if(PlayerToPoint(20, i,2015.4500,1017.0900,996.8750))
			{//Four Dragons
			    GameTextForPlayer(i, "~r~Closed", 5000, 1);
			    SetPlayerInterior(i, 0);
			    PlayerInfo[i][pInt] = 0;
			    SetPlayerPos(i,1022.599975,-1123.699951,23.799999);
			}
			else if(PlayerToPoint(20, i,2233.9099,1710.7300,1011.2987))
			{//Caligula
			    GameTextForPlayer(i, "~r~Closed", 5000, 1);
			    SetPlayerInterior(i, 0);
			    PlayerInfo[i][pInt] = 0;
			    SetPlayerPos(i,1022.599975,-1123.699951,23.799999);
			}
			else if(PlayerToPoint(10, i,2265.7900,1619.5800,1090.4453))
			{//Caligula Roof 1
			    GameTextForPlayer(i, "~r~Closed", 5000, 1);
			    SetPlayerInterior(i, 0);
			    PlayerInfo[i][pInt] = 0;
			    SetPlayerPos(i,1022.599975,-1123.699951,23.799999);
			}
			else if(PlayerToPoint(10, i,2265.7800,1675.9301,1090.4453))
			{//Caligula Roof 2
			    GameTextForPlayer(i, "~r~Closed", 5000, 1);
			    SetPlayerInterior(i, 0);
			    PlayerInfo[i][pInt] = 0;
			    SetPlayerPos(i,1022.599975,-1123.699951,23.799999);
			}
			else if(PlayerToPoint(20, i,1133.0699,-9.5731,1000.6797))
			{//West Casino place
			    GameTextForPlayer(i, "~r~Closed", 5000, 1);
			    SetPlayerInterior(i, 0);
			    PlayerInfo[i][pInt] = 0;
			    SetPlayerPos(i,1022.599975,-1123.699951,23.799999);
			}
			else if(PlayerToPoint(20, i,292.0274,-36.0291,1001.5156))
			{//Ammunation 1
			    GameTextForPlayer(i, "~r~Jailed for going to ammunation", 5000, 1);
			    SetPlayerInterior(i, 6);
			    PlayerInfo[i][pInt] = 6;
				SetPlayerPos(i,264.6288,77.5742,1001.0391);
				PlayerInfo[i][pJailTime] = 300;
				PlayerInfo[i][pJailed] = 1;
			}
			else if(PlayerToPoint(20, i,308.2740,-141.2833,999.6016))
			{//Ammunation 2
			    GameTextForPlayer(i, "~r~Jailed for going to ammunation", 5000, 1);
			    SetPlayerInterior(i, 6);
			    PlayerInfo[i][pInt] = 6;
				SetPlayerPos(i,264.6288,77.5742,1001.0391);
				PlayerInfo[i][pJailTime] = 300;
				PlayerInfo[i][pJailed] = 1;
			}
			else if(PlayerToPoint(20, i,294.3212,-108.7869,1001.5156))
			{//Ammunation 3 (small one's)
			    GameTextForPlayer(i, "~r~Jailed for going to ammunation", 5000, 1);
			    SetPlayerInterior(i, 6);
			    PlayerInfo[i][pInt] = 6;
				SetPlayerPos(i,264.6288,77.5742,1001.0391);
				PlayerInfo[i][pJailTime] = 300;
				PlayerInfo[i][pJailed] = 1;
			}
			else if(PlayerToPoint(20, i,288.8592,-80.4535,1001.5156))
			{//Ammunation 4 (small one's)
			    GameTextForPlayer(i, "~r~Jailed for going to ammunation", 5000, 1);
			    SetPlayerInterior(i, 6);
			    PlayerInfo[i][pInt] = 6;
				SetPlayerPos(i,264.6288,77.5742,1001.0391);
				PlayerInfo[i][pJailTime] = 300;
				PlayerInfo[i][pJailed] = 1;
			}
			else if(PlayerToPoint(20, i,316.9583,-165.4707,999.6010))
			{//Ammunation 5 (Unprotected)
			    GameTextForPlayer(i, "~r~Jailed for going to ammunation", 5000, 1);
			    SetPlayerInterior(i, 6);
			    PlayerInfo[i][pInt] = 6;
				SetPlayerPos(i,264.6288,77.5742,1001.0391);
				PlayerInfo[i][pJailTime] = 300;
				PlayerInfo[i][pJailed] = 1;
			}
		}
	}
}

public CheckGas()
{
	new string[256];
	for(new i=0;i<MAX_PLAYERS;i++)
	{
    	if(IsPlayerConnected(i))
       	{
       	    if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
       	    {
	       		new vehicle = GetPlayerVehicleID(i);
	        	if(Gas[vehicle] >= 1)
		   		{
		   		    if(Gas[vehicle] <= 10)
				    {
			   			PlayerPlaySound(i, 1085, 0.0, 0.0, 0.0);
			   			if(gGas[i] == 0) {
			   				GameTextForPlayer(i,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~Fuel is low",5000,3);
						}
				    }
		   		    if(gGas[i] == 1) {
		   		    if(IsAPlane(vehicle) || IsABoat(vehicle) || IsABike(vehicle) || IsAHarvest(vehicle) || IsADrugHarvest(vehicle) || IsASweeper(vehicle))
		   		    {
		      			format(string, sizeof(string), "~b~~n~~n~~n~~n~~n~~n~~n~~n~~n~Fuel:~w~ N/A");
					}
					else
					{
                        format(string, sizeof(string), "~b~~n~~n~~n~~n~~n~~n~~n~~n~~n~Fuel:~w~ %d%",Gas[vehicle]);
					}
		      		GameTextForPlayer(i,string,20500,3); }
					if(IsAPlane(vehicle) || IsABoat(vehicle) || IsABike(vehicle) || IsAHarvest(vehicle) || IsADrugHarvest(vehicle) || IsASweeper(vehicle) || engineOn[vehicle] == 0) { Gas[vehicle]++; }
	              	Gas[vehicle]--;
		   		}
	   			else
	           	{
	              	NoFuel[i] = 1;
	              	TogglePlayerControllable(i, 0);
		        	GameTextForPlayer(i,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~No fuel in Vehicle",1500,3);
				}
			}
    	}
	}
	return 1;
}

public Fillup()
{
	for(new i=0; i<MAX_PLAYERS; i++)
   	{
	   	if(IsPlayerConnected(i))
	   	{
		    new VID;
		    new FillUp;
		    new string[256];
		    VID = GetPlayerVehicleID(i);
		    FillUp = GasMax - Gas[VID];
			if(Refueling[i] == 1)
		    {
		        if(IsACopCar(VID) || IsAnFbiCar(VID) || IsAnAmbulance(VID) || IsNgCar(VID) || IsAGovernmentCar(VID) || IsAHspdCar(VID))
		        {
		            Gas[VID] += FillUp;
		            FillUp = FillUp * SBizzInfo[3][sbEntranceCost];
		            format(string,sizeof(string),"* Vehicle filled up, for: $%d.",FillUp);
	    			SendClientMessage(i,COLOR_WHITE,string);
	    			GameTextForPlayer(i, "~w~Government has paid for a gas.", 5000, 1);
					SBizzInfo[3][sbTill] += FillUp;
					ExtortionSBiz(3, FillUp);
					Refueling[i] = 0;
					TogglePlayerControllable(i, 1);
		        }
		        else
		        {
					if(GetPlayerMoney(i) >= FillUp+4)
					{
						Gas[VID] += FillUp;
						FillUp = FillUp * SBizzInfo[3][sbEntranceCost];
				    	format(string,sizeof(string),"* Vehicle filled up, for: $%d.",FillUp);
				    	SendClientMessage(i,COLOR_WHITE,string);
						SafeGivePlayerMoney(i, - FillUp);
						SBizzInfo[3][sbTill] += FillUp;
						ExtortionSBiz(3, FillUp);
						Refueling[i] = 0;
						TogglePlayerControllable(i, 1);
					}
			   		else
			   		{
			   	    	format(string,sizeof(string),"* Not enough Money to refill, it costs $%d to fill your Vehicle.",FillUp);
				    	SendClientMessage(i,COLOR_WHITE,string);
				    	TogglePlayerControllable(i, 1);
			   		}
				}
		 	}
		}
	}
	return 1;
}

public StoppedVehicle()
{
	new Float:x,Float:y,Float:z;
	new Float:distance,value;
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerInAnyVehicle(i))
			{
				new VID;
				VID = GetPlayerVehicleID(i);
				GetPlayerPos(i, x, y, z);
				distance = floatsqroot(floatpower(floatabs(floatsub(x,SavePlayerPos[i][LastX])),2)+floatpower(floatabs(floatsub(y,SavePlayerPos[i][LastY])),2)+floatpower(floatabs(floatsub(z,SavePlayerPos[i][LastZ])),2));
				value = floatround(distance * 3600);
				if(UpdateSeconds > 1)
				{
					value = floatround(value / UpdateSeconds);
				}
				if(SpeedMode)
				{
	            }
				if(value == 0)
				{
					Gas[VID]++;
				}
				SavePlayerPos[i][LastX] = x;
				SavePlayerPos[i][LastY] = y;
				SavePlayerPos[i][LastZ] = z;
			}
		}
	}
	return 1;
}

public SetPlayerWeapons(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    SafeResetPlayerWeapons(playerid);
	    if(PlayerInfo[playerid][pJailed] < 1)
	    {
			if(gTeam[playerid] == 2 || IsACop(playerid))
			{
				SafeGivePlayerWeapon(playerid, 41, 500); //spray
				if(OnDuty[playerid] == 1 || PlayerInfo[playerid][pMember] == 2)//Cops & FBI/ATF
				{
				    SafeGivePlayerWeapon(playerid, 41, 500); //spray
					SafeGivePlayerWeapon(playerid, 24, 200);
					SafeGivePlayerWeapon(playerid, 3, 1);
					if(PlayerInfo[playerid][pChar] == 285)//SWAT
					{
					    SafeGivePlayerWeapon(playerid, 24, 200);
					    SafeGivePlayerWeapon(playerid, 29, 450);
						SafeGivePlayerWeapon(playerid, 31, 600);
					}
					else if(PlayerInfo[playerid][pChar] == 287)//Army
					{
					    SafeGivePlayerWeapon(playerid, 24, 200);
					    SafeGivePlayerWeapon(playerid, 29, 450);
					    SafeGivePlayerWeapon(playerid, 31, 500);
					}
				}
				if(PlayerInfo[playerid][pMember] == 3 || PlayerInfo[playerid][pLeader] == 3)//National Guard
				{
				    SafeGivePlayerWeapon(playerid, 24, 200);
				    SafeGivePlayerWeapon(playerid, 31, 600);
				    SafeGivePlayerWeapon(playerid, 29, 600);
				}
			}
			if(gTeam[playerid] >= 3)
			{
				SafeGivePlayerWeapon(playerid, 0, 0);
			}
			if(PlayerInfo[playerid][pDonateRank] > 0)
			{
				if (PlayerInfo[playerid][pGun][0] > 0)
				{
					SafeGivePlayerWeapon(playerid, PlayerInfo[playerid][pGun][0], PlayerInfo[playerid][pAmmo][0]);
					PlayerInfo[playerid][pGun][0] = 0; PlayerInfo[playerid][pAmmo][0] = 0;
				}
				if (PlayerInfo[playerid][pGun][1] > 0)
				{
					SafeGivePlayerWeapon(playerid, PlayerInfo[playerid][pGun][1], PlayerInfo[playerid][pAmmo][1]);
					PlayerInfo[playerid][pGun][1] = 0; PlayerInfo[playerid][pAmmo][1] = 0;
				}
				if (PlayerInfo[playerid][pGun][2] > 0)
				{
					SafeGivePlayerWeapon(playerid, PlayerInfo[playerid][pGun][2], PlayerInfo[playerid][pAmmo][2]);
					PlayerInfo[playerid][pGun][2] = 0; PlayerInfo[playerid][pAmmo][2] = 0;
				}
				if (PlayerInfo[playerid][pGun][3] > 0)
				{
					SafeGivePlayerWeapon(playerid, PlayerInfo[playerid][pGun][3], PlayerInfo[playerid][pAmmo][3]);
					PlayerInfo[playerid][pGun][3] = 0; PlayerInfo[playerid][pAmmo][3] = 0;
				}
			}
			else
			{
			    if (PlayerInfo[playerid][pGun][0] > 0)
				{
					SafeGivePlayerWeapon(playerid, PlayerInfo[playerid][pGun][0], PlayerInfo[playerid][pAmmo][0]);
					PlayerInfo[playerid][pGun][0] = 0; PlayerInfo[playerid][pAmmo][0] = 0;
				}
				if (PlayerInfo[playerid][pGun][1] > 0)
				{
					SafeGivePlayerWeapon(playerid, PlayerInfo[playerid][pGun][1], PlayerInfo[playerid][pAmmo][1]);
					PlayerInfo[playerid][pGun][1] = 0; PlayerInfo[playerid][pAmmo][1] = 0;
				}
			}
		}
	}
}

public PrintSBizInfo(playerid,targetid)
{
	if(IsPlayerConnected(playerid))
	{
		new coordsstring[256];
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
		format(coordsstring, sizeof(coordsstring),"*** %s ***",SBizzInfo[targetid][sbMessage]);
		SendClientMessage(playerid, COLOR_WHITE,coordsstring);
		format(coordsstring, sizeof(coordsstring), "Locked: %d EntryFee: $%d Till: $%d", SBizzInfo[targetid][sbLocked], SBizzInfo[targetid][sbEntranceCost], SBizzInfo[targetid][sbTill]);
		SendClientMessage(playerid, COLOR_GRAD1,coordsstring);
		format(coordsstring, sizeof(coordsstring), "Products: %d/%d Extortion By: %s", SBizzInfo[targetid][sbProducts],SBizzInfo[targetid][sbMaxProducts],SBizzInfo[targetid][sbExtortion]);
		SendClientMessage(playerid, COLOR_GRAD2,coordsstring);
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	}
}

public PrintBizInfo(playerid,targetid)
{
    if(IsPlayerConnected(playerid))
	{
		new coordsstring[256];
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
		format(coordsstring, sizeof(coordsstring),"*** %s ***",BizzInfo[targetid][bMessage]);
		SendClientMessage(playerid, COLOR_WHITE,coordsstring);
		format(coordsstring, sizeof(coordsstring), "Locked: %d EntryFee: $%d Till: $%d", BizzInfo[targetid][bLocked], BizzInfo[targetid][bEntranceCost], BizzInfo[targetid][bTill]);
		SendClientMessage(playerid, COLOR_GRAD1,coordsstring);
		format(coordsstring, sizeof(coordsstring), "Products: %d/%d Extortion By: %s", BizzInfo[targetid][bProducts],BizzInfo[targetid][bMaxProducts],BizzInfo[targetid][bExtortion]);
		SendClientMessage(playerid, COLOR_GRAD2,coordsstring);
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	}
}

public ShowStats(playerid,targetid)
{
    if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new cash =  GetPlayerMoney(targetid);
		new atext[20];
		if(PlayerInfo[targetid][pSex] == 1) { atext = "Nam"; }
		else if(PlayerInfo[targetid][pSex] == 2) { atext = "Nu"; }
  		new otext[20];
		if(PlayerInfo[targetid][pOrigin] == 1) { otext = "Bac"; }
		else if(PlayerInfo[targetid][pOrigin] == 2) { otext = "Trung"; }
		else if(PlayerInfo[targetid][pOrigin] == 3) { otext = "Nam"; }
		new ttext[20];
		if(PlayerInfo[targetid][pMember] == 4 || PlayerInfo[targetid][pLeader] == 4) { ttext = "Medic"; }
		else if(gTeam[targetid] == 3 || gTeam[targetid] == 4) { ttext = "Civilian"; }
		else if(PlayerInfo[targetid][pMember] == 1 || PlayerInfo[targetid][pLeader] == 1) { ttext = "Police Department"; }
		else if(PlayerInfo[targetid][pMember] == 2 || PlayerInfo[targetid][pLeader] == 2) { ttext = "FBI Agent"; }
		else if(PlayerInfo[targetid][pMember] == 3 || PlayerInfo[targetid][pLeader] == 3) { ttext = "National Guard"; }
		else if(PlayerInfo[targetid][pMember] == 4 || PlayerInfo[targetid][pLeader] == 4) { ttext = "Firemen/Paramedic"; }
		else if(PlayerInfo[targetid][pMember] == 5 || PlayerInfo[targetid][pLeader] == 5) { ttext = "Surenos"; }
		else if(PlayerInfo[targetid][pMember] == 6 || PlayerInfo[targetid][pLeader] == 6) { ttext = "La Famiglia Sinatra"; }
		else if(PlayerInfo[targetid][pMember] == 7 || PlayerInfo[targetid][pLeader] == 7) { ttext = "Government"; }
		else if(PlayerInfo[targetid][pMember] == 8 || PlayerInfo[targetid][pLeader] == 8) { ttext = "Hitman"; }
		else if(PlayerInfo[targetid][pMember] == 9 || PlayerInfo[targetid][pLeader] == 9) { ttext = "News Reporter"; }
		else if(PlayerInfo[targetid][pMember] == 10 || PlayerInfo[targetid][pLeader] == 10) { ttext = "Taxi"; }
		else if(PlayerInfo[targetid][pMember] == 11 || PlayerInfo[targetid][pLeader] == 11) { ttext = "School Instructor"; }
		//else if(PlayerInfo[targetid][pMember] == 14 || PlayerInfo[targetid][pLeader] == 14) { ttext = "Yamaguchi"; }
		else if(PlayerInfo[targetid][pMember] == 15 || PlayerInfo[targetid][pLeader] == 15) { ttext = "47th Street Saints"; }
		else if(PlayerInfo[targetid][pMember] == 16 || PlayerInfo[targetid][pLeader] == 16) { ttext = "East Beach Bloods"; }
		new dtext[20];
		if(STDPlayer[targetid] == 1) { dtext = "Chlamydia"; }
		else if(STDPlayer[targetid] == 2) { dtext = "Gonorrhea"; }
		else if(STDPlayer[targetid] == 3) { dtext = "Syphilis"; }
		else { dtext = "None"; }
	    new ftext[30];
	    if(PlayerInfo[targetid][pMember] == 1 || PlayerInfo[targetid][pLeader] == 1)
		{ ftext = "Los Angeles Police Department"; }
        else if(PlayerInfo[targetid][pMember] == 4 || PlayerInfo[targetid][pLeader] == 4)
		{ ftext = "Firemen/Paramedics"; }
  		else if(PlayerInfo[targetid][pMember] == 5 || PlayerInfo[targetid][pLeader] == 5)
		{ ftext = "Los Sure񯳠13"; }
		else if(PlayerInfo[targetid][pMember] == 6 || PlayerInfo[targetid][pLeader] == 6)
		{ ftext = "La Famiglia Sinatra"; }
		else if(PlayerInfo[targetid][pMember] == 11 || PlayerInfo[targetid][pLeader] == 11)
		{ ftext = "License Faction"; }
		//else if(PlayerInfo[targetid][pMember] == 14 || PlayerInfo[targetid][pLeader] == 14)
		//{ ftext = "Yamaguchi"; }
		else if(PlayerInfo[targetid][pMember] == 15 || PlayerInfo[targetid][pLeader] == 15)
		{ ftext = "47th Street Saints"; }
		else if(PlayerInfo[targetid][pMember] == 16 || PlayerInfo[targetid][pLeader] == 16)
		{ ftext = "East Beach Bloods"; }
		else
		{ ftext = "None"; }
		new f2text[20];
	    if(PlayerInfo[targetid][pFMember] < 255) { f2text = FamilyInfo[PlayerInfo[targetid][pFMember]][FamilyName]; }
		else { f2text = "None"; }
	    new rtext[64];
	    if(gTeam[targetid] == 5 || PlayerInfo[targetid][pFMember] < 255)//The 2 Organisations
	    {
        	if(PlayerInfo[targetid][pRank] == 1) { rtext = "Outsider"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Associate"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Soldier"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Capo"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "Underboss"; }
  			else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Godfather"; }
			else { rtext = "Outsider"; }
		}
		else if(PlayerInfo[targetid][pMember] == 1 || PlayerInfo[targetid][pLeader] == 1)//PD Ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Cadet"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Police Officer"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Corporal"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Sergeant"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "Lieutenant"; }
	        else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Captain"; }
	        else if(PlayerInfo[targetid][pRank] == 7) { rtext = "Deputy Chief"; }
	        else if(PlayerInfo[targetid][pRank] == 8) { rtext = "Chief"; }
			else { rtext = "Cadet"; }
		}
		else if(PlayerInfo[targetid][pMember] == 2 || PlayerInfo[targetid][pLeader] == 2)//FBI Ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Professional Staff"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Special Agent Trainee"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Special Agent"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Special Agent in Charge"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "Assistant Director in Charge"; }
		    else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Director"; }
			else { rtext = "Intern"; }
		}
		else if(PlayerInfo[targetid][pMember] == 3 || PlayerInfo[targetid][pLeader] == 3)//NG Ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Private"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Sergeant"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Major"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Captain"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "Lieutenant"; }
		    else if(PlayerInfo[targetid][pRank] == 6) { rtext = "General"; }
			else { rtext = "Private"; }
		}
		else if(PlayerInfo[targetid][pMember] == 5 || PlayerInfo[targetid][pLeader] == 5)//Surenos Ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Forastero"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Asociado"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Miembro"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Proscrito"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "Mano Derecha"; }
  			else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Corona"; }
			else { rtext = "Guero"; }
		}
		else if(PlayerInfo[targetid][pMember] == 6 || PlayerInfo[targetid][pLeader] == 6)//Surenos Ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Outsider"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Giovane D'honore"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Piciotto"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Sgarrista"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "Capo Regime"; }
  			else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Consiglieri"; }
  			else if(PlayerInfo[targetid][pRank] == 7) { rtext = "Capo Bastone"; }
  			else if(PlayerInfo[targetid][pRank] == 8) { rtext = "Capo Crimini"; }
			else { rtext = "Outsider"; }
		}
		else if(PlayerInfo[targetid][pMember] == 7)//Mayor ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Mayor's driver"; }
		    else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Mayor's bodyguard"; }
		    else { rtext = "None"; }
		}
		else if(PlayerInfo[targetid][pMember] == 8 || PlayerInfo[targetid][pLeader] == 8)//Hitman Ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Freelancer"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Marksman"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Agent"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Special Agent"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "Vice-Director"; }
		    else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Director"; }
			else { rtext = "Freelancer"; }
		}
		else if(PlayerInfo[targetid][pMember] == 9 || PlayerInfo[targetid][pLeader] == 9)//NR Ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Intern Worker"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Journalist"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Head Journalist"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Company Secretary"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "ABC Manager"; }
		    else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Network Producer"; }
			else { rtext = "Intern Worker"; }
		}
		else if(PlayerInfo[targetid][pMember] == 10 || PlayerInfo[targetid][pLeader] == 10)//Taxi Company Ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Trainee"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Taxi Rookie"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Cabbie"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Dispatcher"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "Shift Supervisor"; }
		    else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Taxi Company Owner"; }
			else { rtext = "Trainee"; }
		}
		else if(IsAnInstructor(targetid))//Driving/Flying School Ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Trainee"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Instructor"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Senior Instructor"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Manager"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "Under Boss"; }
		    else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Boss"; }
			else { rtext = "Trainee"; }
		}
		/*
		else if(PlayerInfo[targetid][pMember] == 14 || PlayerInfo[targetid][pLeader] == 14)//Yamaguchi ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Gaij in"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Wakashu"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Shatei"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Capo"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "Don's right hand"; }
  			else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Don"; }
			else { rtext = "Gaij in"; }
		}
		*/
		else if(PlayerInfo[targetid][pMember] == 15 || PlayerInfo[targetid][pLeader] == 15)//47th Street Saints Families gang Ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Outsider"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Gangsta"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Thug"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Soulja"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "O.G"; }
			else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Senior O.G"; }
  			else if(PlayerInfo[targetid][pRank] == 7) { rtext = "Top O.G"; }
			else { rtext = "Outsider"; }
		}
		else if(PlayerInfo[targetid][pMember] == 16 || PlayerInfo[targetid][pLeader] == 16)//East Beach Bloods Ranks
		{
		    if(PlayerInfo[targetid][pRank] == 1) { rtext = "Dumb Hoe"; }
			else if(PlayerInfo[targetid][pRank] == 2) { rtext = "Outsider"; }
			else if(PlayerInfo[targetid][pRank] == 3) { rtext = "Soulja"; }
			else if(PlayerInfo[targetid][pRank] == 4) { rtext = "Blood Pusher"; }
			else if(PlayerInfo[targetid][pRank] == 5) { rtext = "Blood Runner"; }
			else if(PlayerInfo[targetid][pRank] == 6) { rtext = "Thug"; }
		    else if(PlayerInfo[targetid][pRank] == 7) { rtext = "O.G"; }
		    else if(PlayerInfo[targetid][pRank] == 8) { rtext = "Double O.G"; }
		    else if(PlayerInfo[targetid][pRank] == 9) { rtext = "Kingpin"; }
			else { rtext = "Dumb Hoe"; }
		}
		else
		{
		    rtext = "None";
		}
        new jtext[20];
        if(PlayerInfo[targetid][pJob] == 1) { jtext = "Tham tu"; }
        else if(PlayerInfo[targetid][pJob] == 2) { jtext = "Luat su"; }
        else if(PlayerInfo[targetid][pJob] == 3) { jtext = "Whore"; }
        else if(PlayerInfo[targetid][pJob] == 4) { jtext = "Drugs Dealer"; }
        else if(PlayerInfo[targetid][pJob] == 5) { jtext = "Car Jacker"; }
        else if(PlayerInfo[targetid][pJob] == 6) { jtext = "News Reporter"; }
        else if(PlayerInfo[targetid][pJob] == 7) { jtext = "Car Mechanic"; }
        else if(PlayerInfo[targetid][pJob] == 8) { jtext = "Bodyguard"; }
        else if(PlayerInfo[targetid][pJob] == 9) { jtext = "Arms Dealer"; }
        else if(PlayerInfo[targetid][pJob] == 10) { jtext = "Car Dealer"; }
		else if(PlayerInfo[targetid][pJob] == 12) { jtext = "Boxer"; }
        else if(PlayerInfo[targetid][pJob] == 14) { jtext = "Bus Driver"; }
        else if(PlayerInfo[targetid][pJob] == 15) { jtext = "Paper Boy"; }
        else if(PlayerInfo[targetid][pJob] == 16) { jtext = "Trucker"; }
        else if(PlayerInfo[targetid][pJob] == 17) { jtext = "Pizza Boy"; }
        else if(PlayerInfo[targetid][pJob] == 18) { jtext = "Farmer"; }
        else if(PlayerInfo[targetid][pJob] == 19) { jtext = "Illegal Farmer"; }
        else if(PlayerInfo[targetid][pJob] == 20) { jtext = "Drugs Smuggler"; }
        else if(PlayerInfo[targetid][pJob] == 21) { jtext = "Street sweeper"; }
        //else if(PlayerInfo[targetid][pJob] == 22) { jtext = "Materials smuggler"; }
        //else if(PlayerInfo[targetid][pJob] == 23) { jtext = "Gun maker"; }
        else { jtext = "None"; }
		new drank[20];
		if(PlayerInfo[targetid][pDonateRank] == 1) { drank = "Bronze donater"; }
		else if(PlayerInfo[targetid][pDonateRank] >= 2) { drank = "Golden donater"; }
		else { drank = "None"; }
		/*new married[20];
		strmid(married, PlayerInfo[targetid][pMarriedTo], 0, strlen(PlayerInfo[targetid][pMarriedTo]), 255);*/
		new age = PlayerInfo[targetid][pAge];
		new ptime = PlayerInfo[targetid][pConnectTime];
		//new lotto = PlayerInfo[targetid][pLottoNr];
		//new deaths = PlayerInfo[targetid][pDeaths];
		//new fishes = PlayerInfo[targetid][pFishes];
		new bigfish = PlayerInfo[targetid][pBiggestFish];
		//new crimes = PlayerInfo[targetid][pCrimes];
		new arrests = PlayerInfo[targetid][pArrested];
		//new warrests = PlayerInfo[targetid][pWantedDeaths];
		new drugs = PlayerInfo[targetid][pDrugs];
		new mats = PlayerInfo[targetid][pMats];
		//new wanted = WantedLevel[targetid];
		new level = PlayerInfo[targetid][pLevel];
		new exp = PlayerInfo[targetid][pExp];
		//new kills = PlayerInfo[targetid][pKills];
		new pnumber = PlayerInfo[targetid][pPnumber];
		new account = PlayerInfo[targetid][pAccount];
		new nxtlevel = PlayerInfo[targetid][pLevel]+1;
		new expamount = nxtlevel*levelexp;
		//new costlevel = nxtlevel*levelcost;//10k for testing purposes
		new housekey = PlayerInfo[targetid][pPhousekey];
		new bizkey = PlayerInfo[targetid][pPbiskey];
		new carkey = PlayerInfo[targetid][pPcarkey][0];
		new carkey2 = PlayerInfo[targetid][pPcarkey][1];
		new carkey3 = PlayerInfo[targetid][pPcarkey][2];
		new intir = PlayerInfo[targetid][pInt];
		new virworld = PlayerInfo[targetid][pVirWorld];
		new local = PlayerInfo[targetid][pLocal];
		//new Float:shealth = PlayerInfo[targetid][pSHealth];
		new Float:health;
		new name[MAX_PLAYER_NAME];
		GetPlayerName(targetid, name, sizeof(name));
		GetPlayerHealth(targetid,health);
		new Float:px,Float:py,Float:pz;
		GetPlayerPos(targetid, px, py, pz);
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring),"____________________| %s |____________________",name);
		SendClientMessage(playerid, COLOR_GREEN,coordsstring);
		format(coordsstring, sizeof(coordsstring), "Level:[%d] Gioi tinh:[%s] Tuoi:[%d] Tien:[$%d] Tai khoan:[$%d] Ph:[%d] DonateRank:[%s]", level,atext,age,cash,account,pnumber,drank);
		SendClientMessage(playerid, COLOR_GRAD1,coordsstring);
		format(coordsstring, sizeof(coordsstring), "Gio choi:[%d] BiggestFish:[%d] Thoi gian trong tu:[%d] Nghe nghiep:[%s] Exp:[%d/%d]", ptime,bigfish,arrests,jtext,exp,expamount);
		SendClientMessage(playerid, COLOR_GRAD3,coordsstring);
		format(coordsstring, sizeof(coordsstring), "Drugs:[%d] Materials:[%d] Team:[%s] To chuc:[%s] Rank:[%s]",drugs,mats,ttext,ftext,rtext);
		SendClientMessage(playerid, COLOR_GRAD5,coordsstring);
		if (PlayerInfo[targetid][pPcarkey][0] != 999)
		{
		    format(coordsstring, sizeof(coordsstring), "1| VehModel:[%s] VehValue:[%d] VehColor1:[%d] VehColor2:[%d] VehLocked:[%d]", CarInfo[carkey][cDescription], CarInfo[carkey][cValue], CarInfo[carkey][cColorOne], CarInfo[carkey][cColorTwo], CarInfo[carkey][cLock]);
		    SendClientMessage(playerid, COLOR_GRAD5,coordsstring);
		}
		if (PlayerInfo[targetid][pPcarkey][1] != 999)
		{
		    format(coordsstring, sizeof(coordsstring), "2| VehModel:[%s] VehValue:[%d] VehColor1:[%d] VehColor2:[%d] VehLocked:[%d]", CarInfo[carkey2][cDescription], CarInfo[carkey2][cValue], CarInfo[carkey2][cColorOne], CarInfo[carkey2][cColorTwo], CarInfo[carkey2][cLock]);
		    SendClientMessage(playerid, COLOR_GRAD5,coordsstring);
		}
		if (PlayerInfo[targetid][pPcarkey][2] != 999)
		{
		    format(coordsstring, sizeof(coordsstring), "3| VehModel:[%s] VehValue:[%d] VehColor1:[%d] VehColor2:[%d] VehLocked:[%d]", CarInfo[carkey3][cDescription], CarInfo[carkey3][cValue], CarInfo[carkey3][cColorOne], CarInfo[carkey3][cColorTwo], CarInfo[carkey3][cLock]);
		    SendClientMessage(playerid, COLOR_GRAD5,coordsstring);
		}
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			format(coordsstring, sizeof(coordsstring), "House key [%d] Business key [%d] Veh1 [%d] Veh2 [%d] Veh3 [%d] HireKey [%d] int:[%d] virworld:[%d] local[%d]", housekey,bizkey,carkey,carkey2,carkey3,HireCar[targetid],intir,virworld,local);
			SendClientMessage(playerid, COLOR_GRAD6,coordsstring);
		}
		SendClientMessage(playerid, COLOR_GREEN,"___________________________________________________________");
	}
}

public SetPlayerToTeamColor(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    SetPlayerColor(playerid,TEAM_HIT_COLOR); // white
	    /* if (PlayerInfo[playerid][pMember] == 5 || PlayerInfo[playerid][pLeader] == 5)
        SetPlayerColor(playerid,COLOR_DBLUE);
        if (PlayerInfo[playerid][pMember] == 6 || PlayerInfo[playerid][pLeader] == 6)
        SetPlayerColor(playerid,COLOR_BLACK);
        if (PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pMember] == 2 || PlayerInfo[playerid][pMember] == 3 || PlayerInfo[playerid][pLeader] == 3 || PlayerInfo[playerid][pLeader] == 2 || PlayerInfo[playerid][pLeader] == 1)
        SetPlayerColor(playerid,cop_color);
        if (PlayerInfo[playerid][pMember] == 14 || PlayerInfo[playerid][pLeader] == 14)
        SetPlayerColor(playerid,COLOR_DARKNICERED);
        if (PlayerInfo[playerid][pMember] == 15 || PlayerInfo[playerid][pLeader] == 15)
        SetPlayerColor(playerid,COLOR_GROVE); */
	}
}

// GameModeInitExitFunc()
/*public GameModeInitExitFunc()
{
	new string[128];
	format(string, sizeof(string), "Traveling...");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			DisablePlayerCheckpoint(i);
			gPlayerCheckpointStatus[i] = CHECKPOINT_NONE;
			GameTextForPlayer(i, string, 4000, 5);
			SetPlayerCameraPos(i,1460.0, -1324.0, 287.2);
			SetPlayerCameraLookAt(i,1374.5, -1291.1, 239.0);
			SavePlayer(i);
			gPlayerLogged[i] = 0;
		}
	}
	SetTimer("GameModeExitFunc", 4000, 0);
	return 1;
}*/

public GameModeExitFunc()
{
	KillTimer(synctimer);
	KillTimer(hackchecktimer);
	KillTimer(newmistimer);
	KillTimer(unjailtimer);
	KillTimer(othtimer);
	KillTimer(cartimer);
	KillTimer(accountstimer);
	KillTimer(checkgastimer);
	KillTimer(idletimer);
	KillTimer(pickuptimer);
	KillTimer(productiontimer);
	KillTimer(spectatetimer);
	KillTimer(stoppedvehtimer);
	KillTimer(turftimer);
	KillTimer(checkcarhealthtimer);
	KillTimer(burgertimer);
	KillTimer(chickentimer);
	KillTimer(tracetimer);
	//KillTimer(updateplayerpos);
	DestroyMenu(Guide);
	DestroyMenu(JobLocations);
	DestroyMenu(JobLocations2);
	GameModeExit();
}

public SyncUp()
{
	SyncTime();
	DollahScoreUpdate();
}

public SyncTime()
{
	//new string[64];
	new tmphour;
	new tmpminute;
	new tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	FixHour(tmphour);
	tmphour = shifthour;
	if ((tmphour > ghour) || (tmphour == 0 && ghour == 23))
	{
		/*format(string, sizeof(string), "SERVER: The time is now %d:00 hours",tmphour);
		BroadCast(COLOR_WHITE,string);*/
		ghour = tmphour;
		PayDay();
		if (realtime)
		{
			SetWorldTime(tmphour);
		}
	}
}

public IsPlayerInTurf(playerid, turfid)
{
	if(IsPlayerConnected(playerid))
	{
		if(turfid == -1)
		{
			return 0;
		}
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid,x,y,z);
		if(x >= TurfInfo[turfid][zMinX] && x < TurfInfo[turfid][zMaxX] && y >= TurfInfo[turfid][zMinY] && y < TurfInfo[turfid][zMaxY])
		{
	 		return 1;
		}
	}
	return 0;
}

public GetClosestPlayer(p1)
{
	new x,Float:dis,Float:dis2,player;
	player = -1;
	dis = 99999.99;
	for (x=0;x<MAX_PLAYERS;x++)
	{
		if(IsPlayerConnected(x))
		{
			if(x != p1)
			{
				dis2 = GetDistanceBetweenPlayers(x,p1);
				if(dis2 < dis && dis2 != -1.00)
				{
					dis = dis2;
					player = x;
				}
			}
		}
	}
	return player;
}

public Production()
{
	new string[256];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pFishes] >= 5) { if(FishCount[i] >= 3) { PlayerInfo[i][pFishes] = 0; } else { FishCount[i] += 1; } }
		    if(PlayerDrunk[i] > 0) { PlayerDrunk[i] = 0; PlayerDrunkTime[i] = 0; GameTextForPlayer(i, "~p~Drunk effect~n~~w~Gone", 3500, 1); }
		    if(PlayerInfo[i][pPayDay] < 6) { PlayerInfo[i][pPayDay] += 1; } //+ 5 min to PayDay anti-abuse
		    for(new k = 0; k < MAX_PLAYERS; k++)
			{
				if(IsPlayerConnected(k))
				{
				    if(gTeam[k] == 2 && CrimInRange(80.0, i,k))
				    {
					}
					else
					{
					    WantedPoints[i] -= 3;
					    if(WantedPoints[i] < 0) { WantedPoints[i] = 0; }
					    new points = WantedPoints[i];
					    new wlevel;
					    if(points > 0)
						{
						    new yesno;
							if(points == 3) { if(WantedLevel[i] != 1) { WantedLevel[i] = 1; wlevel = 1; yesno = 1; } }
							else if(points >= 4 && points <= 5) { if(WantedLevel[i] != 2) { WantedLevel[i] = 2; wlevel = 2; yesno = 1; } }
							else if(points >= 6 && points <= 7) { if(WantedLevel[i] != 3) { WantedLevel[i] = 3; wlevel = 3; yesno = 1; } }
							else if(points >= 8 && points <= 9) { if(WantedLevel[i] != 4) { WantedLevel[i] = 4; wlevel = 4; yesno = 1; } }
							else if(points >= 10 && points <= 11) { if(WantedLevel[i] != 5) { WantedLevel[i] = 5; wlevel = 5; yesno = 1; } }
							else if(points >= 12 && points <= 13) { if(WantedLevel[i] != 6) { WantedLevel[i] = 6; wlevel = 6; yesno = 1; } }
							else if(points >= 14) { if(WantedLevel[i] != 10) { WantedLevel[i] = 10; wlevel = 10; yesno = 1; } }
							else if(points <= 0) { if(WantedLevel[i] != 0) { ClearCrime(i); WantedLevel[i] = 0; wlevel = 0; yesno = 1;} }
							if(yesno)
							{
								format(string, sizeof(string), "Current Wanted Level: %d", wlevel);
								SendClientMessage(i, COLOR_YELLOW, string);
							}
						}
					}
				}
			}
		}
	}
}

public DateProp(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));
	new curdate = getdate();
	for(new h = 0; h < sizeof(HouseInfo); h++)
	{
		if (strcmp(playername, HouseInfo[h][hOwner], true) == 0)
		{
			HouseInfo[h][hDate] = curdate;
			OnPropUpdate();
		}
	}
	return 1;
}

public Checkprop()
{
	new olddate;
	new string[256];
	new curdate = getdate();
	for(new h = 0; h < sizeof(HouseInfo); h++)
	{
		if(HouseInfo[h][hOwned] == 1 && HouseInfo[h][hDate] > 9)
		{
			olddate = HouseInfo[h][hDate];
			if(curdate-olddate >= 5)
			{
				HouseInfo[h][hHel] = 0;
				HouseInfo[h][hArm] = 0;
				HouseInfo[h][hHealthx] = 0;
				HouseInfo[h][hHealthy] = 0;
				HouseInfo[h][hHealthz] = 0;
				HouseInfo[h][hArmourx] = 0;
				HouseInfo[h][hArmoury] = 0;
				HouseInfo[h][hArmourz] = 0;
				HouseInfo[h][hLock] = 1;
				HouseInfo[h][hOwned] = 0;
				HouseInfo[h][hVec] = 418;
				HouseInfo[h][hVcol1] = -1;
				HouseInfo[h][hVcol2] = -1;
				strmid(HouseInfo[h][hOwner], "The State", 0, strlen("The State"), 255);
				format(string, sizeof(string), "REAL ESTATE: A House is available at a value of $%d",HouseInfo[h][hValue]);
				SendClientMessageToAll(TEAM_BALLAS_COLOR, string);
				OnPropUpdate();
			}
		}
	}
	return 1;
}

public PayDay()
{
	new string[128];
	new account,interest;
	new rent = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pLevel] > 0)
		    {
			    if(MoneyMessage[i]==1)
				{
				    SendClientMessage(i, COLOR_LIGHTRED, "You failed to pay your debt, Jail time.");
				    GameTextForPlayer(i, "~r~Busted!", 2000, 1);
				    SetPlayerInterior(i, 6);
				    PlayerInfo[i][pInt] = 6;
			   		SetPlayerPos(i, 264.6288,77.5742,1001.0391);
		            PlayerInfo[i][pJailed] = 1;
		            SafeResetPlayerWeapons(i);
		            SafeResetPlayerMoney(i);
					WantedPoints[i] = 0;
					PlayerInfo[i][pJailTime] = 240;
					format(string, sizeof(string), "You are jailed for %d seconds.   Bail: Unable", PlayerInfo[i][pJailTime]);
					SendClientMessage(i, COLOR_WHITE, string);
				}
				new playername2[MAX_PLAYER_NAME];
				GetPlayerName(i, playername2, sizeof(playername2));
				account = PlayerInfo[i][pAccount];
				new key = PlayerInfo[i][pPhousekey];
				if(key != 255)
				{
					rent = HouseInfo[key][hRent];
					if(strcmp(playername2, HouseInfo[key][hOwner], true) == 0)
					{
						rent = 0;
					}
					else if(rent > GetPlayerMoney(i))
					{
						PlayerInfo[i][pPhousekey] = 255;
						SendClientMessage(i, COLOR_WHITE, "You have been evicted.");
						rent = 0;
					}
					HouseInfo[key][hTakings] = HouseInfo[key][hTakings]+rent;
				}
				new tmpintrate;
				if (key != 255 && strcmp(playername2, HouseInfo[key][hOwner], true) == 0)
				{
				    if(PlayerInfo[i][pDonateRank] > 0) { tmpintrate = intrate+4; }
					else { tmpintrate = intrate+2; }//HouseInfo[key][hLevel]
				}
				else
				{
				    if(PlayerInfo[i][pDonateRank] > 0) { tmpintrate = 3; }
					else { tmpintrate = 1; }
				}
				if(PlayerInfo[i][pPayDay] >= 5)
				{
				    Tax += TaxValue;//Should work for every player online
				    PlayerInfo[i][pAccount] -= TaxValue;
					new checks = PlayerInfo[i][pPayCheck] / 5;
					if(PlayerInfo[i][pDonateRank] > 0)
					{
					    new bonus = PlayerInfo[i][pPayCheck] / 10;
					    checks += bonus;
					}
				    new ebill = (PlayerInfo[i][pAccount]/10000)*(PlayerInfo[i][pLevel]);
				    //ConsumingMoney[i] = 1;
				    //SafeGivePlayerMoney(i, checks);
				    account += checks;
				    if(PlayerInfo[i][pAccount] > 0)
				    {
				    	PlayerInfo[i][pAccount] -= ebill;
				    	SBizzInfo[4][sbTill] += ebill;
					}
					else
					{
					    ebill = 0;
					}
					interest = (PlayerInfo[i][pAccount]/1000)*(tmpintrate);
					PlayerInfo[i][pExp]++;
					PlayerPlayMusic(i);
					PlayerInfo[i][pAccount] = account+interest;
					SendClientMessage(i, COLOR_GREEN, "|___ BANK STATMENT ___|");
					format(string, sizeof(string), "  Paycheck: $%d   Tax Money: -$%d", checks, TaxValue);
					SendClientMessage(i, COLOR_WHITE, string);
					if(PlayerInfo[i][pPhousekey] != 255 || PlayerInfo[i][pPbiskey] != 255)
					{
					    format(string, sizeof(string), "  Electricity Bill: -$%d", ebill);
						SendClientMessage(i, COLOR_GRAD1, string);
					}
					format(string, sizeof(string), "  Balance: $%d", account - checks);
					SendClientMessage(i, COLOR_WHITE, string);
					format(string, sizeof(string), "  Interest Rate: 0.%d percent",tmpintrate);
					SendClientMessage(i, COLOR_GRAD2, string);
					format(string, sizeof(string), "  Interest Gained $%d", interest);
					SendClientMessage(i, COLOR_GRAD3, string);
					SendClientMessage(i, COLOR_GREEN, "|--------------------------------------|");
					format(string, sizeof(string), "  New Balance: $%d", PlayerInfo[i][pAccount]);
					SendClientMessage(i, COLOR_GRAD5, string);
					format(string, sizeof(string), "  Rent: -$%d", rent);
					SendClientMessage(i, COLOR_GRAD5, string);
					format(string, sizeof(string), "~y~PayDay~n~~w~Check paid into your account");
					GameTextForPlayer(i, string, 5000, 1);
					rent = 0;
					PlayerInfo[i][pPayDay] = 0;
					PlayerInfo[i][pPayCheck] = 0;
					PlayerInfo[i][pConnectTime] += 1;
					if(FarmerVar[i] == 0)
					{
						FarmerPickup[i][0] = 0;
					}
					if(DrugFarmerVar[i] == 0)
					{
						DrugFarmerPickup[i][0] = 0;
					}
					if(SmugglerWork[i] == 0)
					{
						PayDaySecure[i] = 0;
					}
					if(PlayerInfo[i][pDonateRank] > 0)
					{
					    PlayerInfo[i][pPayDayHad] += 1;
					    if(PlayerInfo[i][pPayDayHad] >= 5)
					    {
					        PlayerInfo[i][pExp]++;
					        PlayerInfo[i][pPayDayHad] = 0;
					    }
					}
				}
				else
				{
				    SendClientMessage(i, COLOR_WHITE, "*Ban khong choi du lau de nhan payday.");
				}
			}
		}
	}
	SaveAccounts();
	Checkprop();
	return 1;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}

stock ini_GetKey( line[] )
{
	new keyRes[256];
	keyRes[0] = 0;
    if ( strfind( line , "=" , true ) == -1 ) return keyRes;
    strmid( keyRes , line , 0 , strfind( line , "=" , true ) , sizeof( keyRes) );
    return keyRes;
}

stock ini_GetValue( line[] )
{
	new valRes[256];
	valRes[0]=0;
	if ( strfind( line , "=" , true ) == -1 ) return valRes;
	strmid( valRes , line , strfind( line , "=" , true )+1 , strlen( line ) , sizeof( valRes ) );
	return valRes;
}

public OnPropUpdate()
{
	new idx;
	new File: file2;
	while (idx < sizeof(HouseInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%f,%f,%f,%f,%f,%f,%d,%d,%d,%d,%d,%d,%s,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",
		HouseInfo[idx][hEntrancex],
		HouseInfo[idx][hEntrancey],
		HouseInfo[idx][hEntrancez],
		HouseInfo[idx][hExitx],
		HouseInfo[idx][hExity],
		HouseInfo[idx][hExitz],
		HouseInfo[idx][hHealthx],
		HouseInfo[idx][hHealthy],
		HouseInfo[idx][hHealthz],
		HouseInfo[idx][hArmourx],
		HouseInfo[idx][hArmoury],
		HouseInfo[idx][hArmourz],
		HouseInfo[idx][hOwner],
		HouseInfo[idx][hDiscription],
		HouseInfo[idx][hValue],
		HouseInfo[idx][hHel],
		HouseInfo[idx][hArm],
		HouseInfo[idx][hInt],
		HouseInfo[idx][hLock],
		HouseInfo[idx][hOwned],
		HouseInfo[idx][hRooms],
		HouseInfo[idx][hRent],
		HouseInfo[idx][hRentabil],
		HouseInfo[idx][hTakings],
		HouseInfo[idx][hVec],
		HouseInfo[idx][hVcol1],
		HouseInfo[idx][hVcol2],
		HouseInfo[idx][hDate],
		HouseInfo[idx][hLevel],
		HouseInfo[idx][hWorld]);

		HouseInfo[idx][hWorld] = idx;
		if(idx == 0)
		{
			file2 = fopen("property.cfg", io_write);
		}
		else
		{
			file2 = fopen("property.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	idx = 0;
	while (idx < sizeof(BizzInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%d|%s|%s|%s|%f|%f|%f|%f|%f|%f|%d|%d|%d|%d|%d|%d|%d|%d|%d\n",
		BizzInfo[idx][bOwned],
		BizzInfo[idx][bOwner],
		BizzInfo[idx][bMessage],
		BizzInfo[idx][bExtortion],
		BizzInfo[idx][bEntranceX],
		BizzInfo[idx][bEntranceY],
		BizzInfo[idx][bEntranceZ],
		BizzInfo[idx][bExitX],
		BizzInfo[idx][bExitY],
		BizzInfo[idx][bExitZ],
		BizzInfo[idx][bLevelNeeded],
		BizzInfo[idx][bBuyPrice],
		BizzInfo[idx][bEntranceCost],
		BizzInfo[idx][bTill],
		BizzInfo[idx][bLocked],
		BizzInfo[idx][bInterior],
		BizzInfo[idx][bProducts],
		BizzInfo[idx][bMaxProducts],
		BizzInfo[idx][bPriceProd]);
		if(idx == 0)
		{
			file2 = fopen("bizz.cfg", io_write);
		}
		else
		{
			file2 = fopen("bizz.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	idx = 0;
	while (idx < sizeof(SBizzInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%d|%s|%s|%s|%f|%f|%f|%d|%d|%d|%d|%d|%d|%d|%d|%d\n",
		SBizzInfo[idx][sbOwned],
		SBizzInfo[idx][sbOwner],
		SBizzInfo[idx][sbMessage],
		SBizzInfo[idx][sbExtortion],
		SBizzInfo[idx][sbEntranceX],
		SBizzInfo[idx][sbEntranceY],
		SBizzInfo[idx][sbEntranceZ],
		SBizzInfo[idx][sbLevelNeeded],
		SBizzInfo[idx][sbBuyPrice],
		SBizzInfo[idx][sbEntranceCost],
		SBizzInfo[idx][sbTill],
		SBizzInfo[idx][sbLocked],
		SBizzInfo[idx][sbInterior],
		SBizzInfo[idx][sbProducts],
		SBizzInfo[idx][sbMaxProducts],
		SBizzInfo[idx][sbPriceProd]);
		if(idx == 0)
		{
			file2 = fopen("sbizz.cfg", io_write);
		}
		else
		{
			file2 = fopen("sbizz.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	idx = 184;
 	while (idx < sizeof(CarInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%d,%f,%f,%f,%f,%d,%d,%s,%s,%d,%s,%d,%d\n",
		CarInfo[idx][cModel],//
		CarInfo[idx][cLocationx],//
		CarInfo[idx][cLocationy],//
		CarInfo[idx][cLocationz],//
		CarInfo[idx][cAngle],//
		CarInfo[idx][cColorOne],//
		CarInfo[idx][cColorTwo],//
		CarInfo[idx][cOwner],//
		CarInfo[idx][cDescription],//
		CarInfo[idx][cValue],//
		CarInfo[idx][cLicense],//
		CarInfo[idx][cOwned],//
		CarInfo[idx][cLock]);
		if(idx == 184)
		{
			file2 = fopen("cars.cfg", io_write);
		}
		else
		{
			file2 = fopen("cars.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}

public BroadCast(color,const string[])
{
	SendClientMessageToAll(color, string);
	return 1;
}

public ABroadCast(color,const string[],level)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if (PlayerInfo[i][pAdmin] >= level)
			{
				SendClientMessage(i, color, string);
				printf("%s", string);
			}
		}
	}
	return 1;
}

public CBroadCast(color, const string[], level)
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			if (PlayerInfo[i][pHelper] >= level)
			{
				SendClientMessage(i, color, string);
				printf("%s", string);
			}
		}
	}
	return 1;
}


public OOCOff(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(!gOoc[i])
		    {
				SendClientMessage(i, color, string);
			}
		}
	}
}

public OOCNews(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(!gNews[i])
		    {
				SendClientMessage(i, color, string);
			}
		}
	}
}

public SendTeamMessage(team, color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(gTeam[i] == team)
		    {
				SendClientMessage(i, color, string);
			}
		}
	}
}

public SendRadioMessage(member, color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pMember] == member || PlayerInfo[i][pLeader] == member)
		    {
				SendClientMessage(i, color, string);
			}
		}
	}
}

public SendJobMessage(job, color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pJob] == job)
		    {
				SendClientMessage(i, color, string);
			}
		}
	}
}

public SendNewFamilyMessage(family, color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pFMember] == family)
		    {
                if(!gFam[i])
                {
					SendClientMessage(i, color, string);
				}
			}
		}
	}
}

public SendFamilyMessage(family, color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pMember] == family || PlayerInfo[i][pLeader] == family)
		    {
                if(!gFam[i])
                {
					SendClientMessage(i, color, string);
				}
			}
		}
	}
}

public SendIRCMessage(channel, color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayersChannel[i] == channel)
		    {
				SendClientMessage(i, color, string);
			}
		}
	}
}

public SendTeamBeepMessage(team, color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(gTeam[i] == team)
		    {
				SendClientMessage(i, color, string);
				RingTone[i] = 20;
			}
		}
	}
}

public SendEnemyMessage(color, string[])
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			if (gTeam[i] >= 3)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
}

//public AddCar(carcoords)
/*public AddCar(carcoords)
{
	new randcol = random(126);
	new randcol2 = 1;
	if (rccounter == 14)
	{
		rccounter = 0;
	}
	AddStaticVehicleEx(carselect[rccounter], CarSpawns[carcoords][pos_x], CarSpawns[carcoords][pos_y], CarSpawns[carcoords][pos_z], CarSpawns[carcoords][z_angle], randcol, randcol2, 60000);
	rccounter++;
	return 1;
}*/

public PlayerPlayMusic(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		SetTimer("StopMusic", 5000, 0);
		PlayerPlaySound(playerid, 1068, 0.0, 0.0, 0.0);
	}
}

public StopMusic()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			PlayerPlaySound(i, 1069, 0.0, 0.0, 0.0);
		}
	}
}

public PlayerFixRadio(playerid)
{
    if(IsPlayerConnected(playerid))
	{
	    SetTimer("PlayerFixRadio2", 1000, 0);
		PlayerPlaySound(playerid, 1068, 0.0, 0.0, 0.0);
		Fixr[playerid] = 1;
	}
}

public PlayerFixRadio2()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(Fixr[i])
			{
				PlayerPlaySound(i, 1069, 0.0, 0.0, 0.0);
				Fixr[i] = 0;
			}
		}
	}
}

public HouseLevel(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new h = PlayerInfo[playerid][pPhousekey];
		if(h == 255) { return 0; }
		if(h <= 4) { return 1; }
		if(h >= 5 && h <= 9)  { return 2; }
		if(h >= 10 && h <= 18) { return 3; }
		if(h >= 19 && h <= 22) { return 4; }
		if(h >= 23 && h <= 25) { return 5; }
		if(h == 26) { return 6; }
		if(h == 27) { return 7; }
		if(h >= 28 && h <= 31) { return 7; }
	}
	return 0;

}

public CHouseLevel(houseid)
{
	if(houseid <= 4) { return 3; }
	if(houseid >= 29 && houseid <= 30) { return 4; }
	if(houseid >= 5 && houseid <= 9) { return 5; }
	if(houseid >= 10 && houseid <= 18 || houseid == 28) { return 7; }
	if(houseid >= 19 && houseid <= 22) { return 8; }
	if(houseid >= 23 && houseid <= 25) { return 9; }
	if(houseid == 26) { return 10; }
	if(houseid == 27) { return 11; }
	if(houseid >= 28 && houseid <= 31) { return 12; }
	return 0;
}

public ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		//radi = 2.0; //Trigger Radius
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i) && (GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)))
			{
				if(!BigEar[i])
				{
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
					{
						SendClientMessage(i, col1, string);
					}
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
					{
						SendClientMessage(i, col2, string);
					}
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
					{
						SendClientMessage(i, col3, string);
					}
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
					{
						SendClientMessage(i, col4, string);
					}
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
					{
						SendClientMessage(i, col5, string);
					}
				}
				else
				{
					SendClientMessage(i, col1, string);
				}
			}
		}
	}//not connected
	return 1;
}

public CrimInRange(Float:radi, playerid,copid)
{
	if(IsPlayerConnected(playerid)&&IsPlayerConnected(copid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		GetPlayerPos(copid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

public ProxDetectorS(Float:radi, playerid, targetid)
{
    if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		//radi = 2.0; //Trigger Radius
		GetPlayerPos(targetid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

public PlayerToPointStripped(Float:radi, playerid, Float:x, Float:y, Float:z, Float:curx, Float:cury, Float:curz)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:tempposx, Float:tempposy, Float:tempposz;
		tempposx = (curx -x);
		tempposy = (cury -y);
		tempposz = (curz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) return 1;
	}
	return 0;
}

public CustomPickups()
{
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new string[128];
	NameTimer();
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			GetPlayerPos(i, oldposx, oldposy, oldposz);
			new tmpcar = GetPlayerVehicleID(i);
			if(oldposx!=0.0 && oldposy!=0.0 && oldposz!=0.0)
			{
				for(new h = 0; h < sizeof(SBizzInfo); h++)
				{
					if(IsATruck(tmpcar) && PlayerToPoint(10.0, i, SBizzInfo[h][sbEntranceX], SBizzInfo[h][sbEntranceY], SBizzInfo[h][sbEntranceZ]))
					{
						format(string, sizeof(string), "~w~%s~n~~r~Products Required~w~: %d~n~~y~Price per Product: ~w~: $%d~n~~g~Funds: ~w~: $%d",SBizzInfo[h][sbMessage],(SBizzInfo[h][sbMaxProducts]-SBizzInfo[h][sbProducts]),SBizzInfo[h][sbPriceProd],SBizzInfo[h][sbTill]);
						GameTextForPlayer(i, string, 5000, 3);
						return 1;
					}
					if(PlayerToPoint(2.0, i, SBizzInfo[h][sbEntranceX], SBizzInfo[h][sbEntranceY], SBizzInfo[h][sbEntranceZ]))
					{
						if(SBizzInfo[h][sbOwned] == 1)
						{
							format(string, sizeof(string), "~w~%s~w~~n~Owner : %s~n~Extortion by : %s~n~Entrance Fee : ~g~$%d ~n~~w~to enter type /enter",SBizzInfo[h][sbMessage],SBizzInfo[h][sbOwner],SBizzInfo[h][sbExtortion],SBizzInfo[h][sbEntranceCost]);
						}
						else
						{
							format(string, sizeof(string), "~w~%s~w~~n~This Business is for sale~n~Cost: ~g~$%d ~w~Level : %d ~n~to buy this Business type /buybiz",SBizzInfo[h][sbMessage],SBizzInfo[h][sbBuyPrice],SBizzInfo[h][sbLevelNeeded]);
						}
						GameTextForPlayer(i, string, 5000, 3);
						return 1;
					}
				}
				for(new h = 0; h < sizeof(HouseInfo); h++)
				{
					if(PlayerToPoint(2.0, i, HouseInfo[h][hEntrancex], HouseInfo[h][hEntrancey], HouseInfo[h][hEntrancez]))
					{
						if(HouseInfo[h][hOwned] == 1)
						{
							if(HouseInfo[h][hRentabil] == 0)
							{
								format(string, sizeof(string), "~w~This House is owned by~n~%s~n~Level : %d",HouseInfo[h][hOwner],HouseInfo[h][hLevel]);
							}
							else
							{
								format(string, sizeof(string), "~w~This House is owned by~n~%s~n~Rent: $%d Level : %d~n~Type /rentroom to rent a room",HouseInfo[h][hOwner],HouseInfo[h][hRent],HouseInfo[h][hLevel]);
							}
							GameTextForPlayer(i, string, 5000, 3);
							return 1;
						}
						else
						{
							format(string, sizeof(string), "~w~This House is for sale~n~Discription: %s ~n~Cost: ~g~$%d~n~~w~ Level : %d~n~to buy this house type /buyhouse",HouseInfo[h][hDiscription],HouseInfo[h][hValue],HouseInfo[h][hLevel]);
						}
						GameTextForPlayer(i, string, 5000, 3);
						return 1;
					}
				}
				for(new h = 0; h < sizeof(BizzInfo); h++)
				{
					if(IsATruck(tmpcar) && PlayerToPoint(10.0, i, BizzInfo[h][bEntranceX], BizzInfo[h][bEntranceY], BizzInfo[h][bEntranceZ]))
					{
						format(string, sizeof(string), "~w~%s~n~~r~Products Required~w~: %d~n~~y~Price per Product: ~w~: $%d~n~~g~Funds: ~w~: $%d",BizzInfo[h][bMessage],(BizzInfo[h][bMaxProducts]-BizzInfo[h][bProducts]),BizzInfo[h][bPriceProd],BizzInfo[h][bTill]);
						GameTextForPlayer(i, string, 5000, 3);
						return 1;
					}
					if(PlayerToPoint(2.0, i, BizzInfo[h][bEntranceX], BizzInfo[h][bEntranceY], BizzInfo[h][bEntranceZ]))
					{
						if(BizzInfo[h][bOwned] == 1)
						{
							format(string, sizeof(string), "~w~%s~w~~n~Owner : %s~n~Extortion by : %s~n~Entrance Fee : ~g~$%d ~n~~w~to enter type /enter",BizzInfo[h][bMessage],BizzInfo[h][bOwner],BizzInfo[h][bExtortion],BizzInfo[h][bEntranceCost]);
						}
						else
						{
							format(string, sizeof(string), "~w~%s~w~~n~This Business is for sale~n~Cost: ~g~$%d ~w~Level : %d ~n~to buy this Business type /buybiz",BizzInfo[h][bMessage],BizzInfo[h][bBuyPrice],BizzInfo[h][bLevelNeeded]);
						}
						GameTextForPlayer(i, string, 5000, 3);
						return 1;
					}
				}
			}//custompickups end
			if (PlayerToPoint(2.0, i, 2029.5945,-1404.6426,17.2512))
			{// Hospital near speedway
				GameTextForPlayer(i, "~w~Type /healme to cure yourself", 5000, 5);
			}
			else if (PlayerToPoint(1.0, i, 349.5560,161.6693,1019.9912))
			{// All Saints hospital
				GameTextForPlayer(i, "~w~Type /healme to cure yourself", 5000, 5);
			}
			else if (PlayerToPoint(2.0, i, 1043.4530,-1028.0344,32.1016))
			{//Fernandez tuning start
				GameTextForPlayer(i, "~w~This mod shop belongs to Charles Luciano ~n~~r~ If you want to access it ~n~~y~ /call 961415", 5000, 3);
			}
			else if (PlayerToPoint(2.0, i, 1488.6949,-1721.7136,8.2067))
			{
			    GameTextForPlayer(i, "~w~Black ~r~Market", 5000, 3);
			}
			/*else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,359.5408,206.7693,1008.3828))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Detective~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}*/
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,347.7374,193.7241,1014.1875))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Lawyer~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,1215.1304,-11.8431,1000.9219))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Whore~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}
			/*else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,1109.3318,-1796.3042,16.5938))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Car Jacker~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}*/
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,1793.02,-1296.56,13.44))
			{
			    if(PlayerInfo[i][pMember] == 9 || PlayerInfo[i][pLeader] == 9) { GameTextForPlayer(i, "~w~Type ~r~/paper ~w~to create a newspaper",5000,3); }
			    else if(PlayerInfo[i][pJob] == 15) { GameTextForPlayer(i, "~w~Type ~r~/papers ~w~to see all the made newspapers",5000, 3); }
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,2077.52,-2013.56,13.54))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Car Mechanic~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,2226.1716,-1718.1792,13.5165))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Bodyguard~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}
			/*else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,594.2437,-1249.4027,18.2232))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Car Dealer~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}*/
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,766.0804,14.5133,1000.7004))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Boxer~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,1154.2208,-1770.8203,16.5992))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Bus Driver~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,2439.7710,-2120.9285,13.5469))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Trucker~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,2101.7620,-1812.5922,13.5547))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Pizza Boy~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,-382.6660,-1426.5121,26.2410))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Farmer~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}
			/*else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,1784.58,-1297.52,13.37))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Paper Boy~y~ here ~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}*/
			/*else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,213.8549,-230.5761,1.7786))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Materials smuggler~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}*/
			/*else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,2146.3523,-2267.7498,14.2344))
			{
			    GameTextForPlayer(i, "~y~You can get ~r~Materials~y~ from your packages here ~n~~w~Type /materials deliver", 5000, 3);
			}*/
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,2072.5486,-1582.8029,13.4741))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Drugs Dealer~y~~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,1611.5129,-1893.6997,13.5469))
			{
			    if(PlayerInfo[i][pJob] > 0 || PlayerInfo[i][pMember] > 0) {}
			    else { GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become a ~r~Street Sweeper~n~~w~Type /takejob if you wish to become one", 5000, 3); }
			}
			else if (PlayerToPoint(2.0, i,379.1396,-114.2661,1001.4922))
   			{// Pizza Pickup
        		if (PlayerInfo[i][pJob] != 17)
    			{
    			    SendClientMessage(i, COLOR_GREY, "Ban khong phai la nhan vien cua Pizza stack");
     				return 1;
    			}
    			if (sPizza[i] != 1)
    			{
     				SendClientMessage(i, COLOR_WHITE, "Ban da lay banh pizza, cho don dat hang");
       				sPizza[i] = 1;
      			}
   			}
			else if (PlayerToPoint(2.0, i,1174.9100,-1365.7330,13.9876))
			{
			    if(PlayerInfo[i][pMember] == 4 || PlayerInfo[i][pLeader] == 4) { SetTimerEx("elevator1", 1000, false, "i", i); }
			    else { GameTextForPlayer(i, "~r~You can not use an elevator", 5000, 3); }
			}
			else if (PlayerToPoint(2.0, i,1174.9591,-1369.8761,23.9736))
			{
			    if(PlayerInfo[i][pMember] == 4 || PlayerInfo[i][pLeader] == 4) { SetTimerEx("elevator2", 1000, false, "i", i); }
			    else { GameTextForPlayer(i, "~r~You can not use an elevator", 5000, 3); }
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,1381.0413,-1088.8511,27.3906))
			{
			    GameTextForPlayer(i, "~g~Welcome,~n~~y~Use /mission to take on a Mission", 5000, 3);
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,1600.8793,-2333.3535,13.5390))
			{
			    GameTextForPlayer(i, "~y~You found a guide book~n~ Type ~r~/guide ~y~to read it", 5000, 3);
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,359.6820,207.0294,1008.3828))
			{
			    GameTextForPlayer(i, "~w~Advertisment business~n~Owner: ABC Studio~n~Post your ~g~/ad~w~ here", 5000, 3);
			}
			else if (PlayerToPoint(3.0, i,-38.8664,56.3031,3.1172))
			{
			    if(PlayerInfo[i][pMember] == 6 || PlayerInfo[i][pLeader] == 6 || PlayerInfo[i][pJob] == 19)
			    {
			    	format(string, sizeof(string), "~r~Drugs ammount: %d", drugsys[DrugAmmount]);
					GameTextForPlayer(i, string, 5000, 3);
				}
				else if(PlayerInfo[i][pMember] == 16 || PlayerInfo[i][pLeader] == 16 || PlayerInfo[i][pJob] == 20)
				{
					format(string, sizeof(string), "~w~Drugs Farm~n~Farm Owner: La Famiglia Sinatra~n~Drugs ammount:~r~ %d~n~~w~You can /smuggledrugs here", drugsys[DrugAmmount]);
					GameTextForPlayer(i, string, 5000, 3);
				}
				else
				{
				    GameTextForPlayer(i, "~r~Staff only!", 5000, 3);
				}
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i,2022.1492,-1108.7837,26.2031))
			{
				if(PlayerInfo[i][pMember] == 16 || PlayerInfo[i][pLeader] == 16)
				{
					GameTextForPlayer(i, "~g~Welcome,~n~~y~you can become ~r~Drugs Smuggler~n~~w~Type /takejob if you wish to become one", 5000, 3);
				}
				else
				{
				    GameTextForPlayer(i, "~r~Staff only", 5000, 3);
				}
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(1.0, i,242.7591,66.4315,1003.6406))
			{
			    if(PlayerInfo[i][pMember] == 1 || PlayerInfo[i][pLeader] == 1)
			    {
			        GameTextForPlayer(i, "~g~Police Department elevator~n~~w~Type ~r~/pdup ~w~to go up~n~Type ~r~/pddown ~w~to go down", 5000, 3);
			    }
			    else
			    {
			        GameTextForPlayer(i, "~r~Staff only!", 5000, 3);
			    }
			}
			else if (GetPlayerState(i) == 2 && PlayerToPoint(3, i,2073.2979,-1831.1228,13.5469) || GetPlayerState(i) == 2 && PlayerToPoint(3, i,1024.9756,-1030.7930,32.0257) || GetPlayerState(i) == 2 && PlayerToPoint(3, i,488.3819,-1733.0563,11.1752) || GetPlayerState(i) == 2 && PlayerToPoint(3, i,719.8940,-464.8272,16.3359))
			{
			    format(string, sizeof(string), "~y~Pay ~r~& ~g~Spray~w~~n~Owner : %s~n~Entrance Fee : ~g~$%d ~w~~n~to enter type /enter",SBizzInfo[5][sbOwner],SBizzInfo[5][sbEntranceCost]);
				GameTextForPlayer(i, string, 5000, 3);
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(1.5, i, 248.4994,-33.1366,1.5781))
			{
				GameTextForPlayer(i, "~w~Materials factory~n~You can ~r~/smugglemats ~w~here", 5000, 3);
			    /*if(PlayerInfo[i][pJob] == 22)
			    {
			        GameTextForPlayer(i, "~w~Materials factory~n~You can ~r~/smugglemats ~w~here", 5000, 3);
			    }*/
			   /* else
			    {
			        GameTextForPlayer(i, "~r~Staff only !", 5000, 3);
			    }*/
			}
			else if (GetPlayerState(i) == 1 && PlayerToPoint(1.0, i, 2230.3579,-2286.2107,14.3751))
			{
			    /*if(PlayerInfo[i][pJob] == 22)
			    {
			        format(string, sizeof(string), "~w~Materials Bank~n~Materials ammount: ~r~%d", matssys[MatsAmmount]);
			        GameTextForPlayer(i, string, 5000, 3);
			    }*/
			    /*if(PlayerInfo[i][pJob] == 23)
			    {
			        format(string, sizeof(string), "~w~Materials Bank~n~Materials ammount: ~r~%d ~n~~w~You can ~g~/buymats ~w~here", matssys[MatsAmmount]);
			        GameTextForPlayer(i, string, 5000, 3);
			    }*/
			    /*else
			    {
			        GameTextForPlayer(i, "~r~Staff only !", 5000, 3);
			    }*/
				format(string, sizeof(string), "~w~Materials Bank~n~Materials ammount: ~r~%d ~n~~w~You can ~g~/buymats ~w~here", matssys[MatsAmmount]);
				GameTextForPlayer(i, string, 5000, 3);
			}
			else if(PlayerToPoint(2.0, i,1073.0619,-344.5148,73.9922))
			{
			    if(OrderReady[i] > 0)
			    {
			        switch (OrderReady[i])
			        {
			            case 1:
			            {
			                SafeGivePlayerWeapon(i, 24, 50); SafeGivePlayerWeapon(i, 29, 500); SafeGivePlayerWeapon(i, 25, 50); SafeGivePlayerWeapon(i, 4, 1);
			                SafeGivePlayerMoney(i, - 5000);
			                SendClientMessage(i, COLOR_WHITE, "* You picked up your Ordered Package.");
			            }
			            case 2:
			            {
			                SafeGivePlayerWeapon(i, 24, 50); SafeGivePlayerWeapon(i, 29, 500); SafeGivePlayerWeapon(i, 25, 50); SafeGivePlayerWeapon(i, 31, 500); SafeGivePlayerWeapon(i, 4, 1);
			                SafeGivePlayerMoney(i, - 6000);
			                SendClientMessage(i, COLOR_WHITE, "* You picked up your Ordered Package.");
			            }
			            case 3:
			            {
			                SafeGivePlayerWeapon(i, 24, 50); SafeGivePlayerWeapon(i, 29, 500); SafeGivePlayerWeapon(i, 25, 50); SafeGivePlayerWeapon(i, 30, 500); SafeGivePlayerWeapon(i, 4, 1);
			                SafeGivePlayerMoney(i, - 6000);
			                SendClientMessage(i, COLOR_WHITE, "* You picked up your Ordered Package.");
			            }
			            case 4:
			            {
			                SafeGivePlayerWeapon(i, 24, 50); SafeGivePlayerWeapon(i, 29, 500); SafeGivePlayerWeapon(i, 25, 50); SafeGivePlayerWeapon(i, 31, 500); SafeGivePlayerWeapon(i, 4, 1); SafeGivePlayerWeapon(i, 34, 20);
			                SafeGivePlayerMoney(i, - 8000);
			                SendClientMessage(i, COLOR_WHITE, "* You picked up your Ordered Package.");
			            }
			            case 5:
			            {
			                SafeGivePlayerWeapon(i, 24, 50); SafeGivePlayerWeapon(i, 29, 500); SafeGivePlayerWeapon(i, 25, 50); SafeGivePlayerWeapon(i, 30, 500); SafeGivePlayerWeapon(i, 4, 1); SafeGivePlayerWeapon(i, 34, 20);
			                SafeGivePlayerMoney(i, - 8000);
			                SendClientMessage(i, COLOR_WHITE, "* You picked up your Ordered Package.");
			            }
			            case 6:
			            {
			                SafeGivePlayerWeapon(i, 24, 50); SafeGivePlayerWeapon(i, 29, 500); SafeGivePlayerWeapon(i, 25, 50); SafeGivePlayerWeapon(i, 31, 500); SafeGivePlayerWeapon(i, 4, 1); SafeGivePlayerWeapon(i, 34, 20);
							SafeGivePlayerMoney(i, - 8500);
							SendClientMessage(i, COLOR_WHITE, "* You picked up your Ordered Package.");
			            }
			            case 7:
			            {
			                SafeGivePlayerWeapon(i, 24, 50); SafeGivePlayerWeapon(i, 29, 500); SafeGivePlayerWeapon(i, 25, 50); SafeGivePlayerWeapon(i, 30, 500); SafeGivePlayerWeapon(i, 4, 1); SafeGivePlayerWeapon(i, 34, 20);
			                SafeGivePlayerMoney(i, - 8500);
			                SendClientMessage(i, COLOR_WHITE, "* You picked up your Ordered Package.");
			            }
			        }
			        OrderReady[i] = 0;
			    }
			}//Hitman delivery stuff
			else if(PlayerOnMission[i] > 0 && PlayMission[kToggle] == 0)
			{
			    if(MissionCheckpoint[i] == 1 && PlayerToPoint(10.0, i,PlayMission[kCP1][0],PlayMission[kCP1][1],PlayMission[kCP1][2]))
				{
				    RingTone[i] = 20;
				    format(string, sizeof(string), "%s", PlayMission[kGText1]);
					GameTextForPlayer(i, string, 8000, 3);
					format(string, sizeof(string), "%s", PlayMission[kText4]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					format(string, sizeof(string), "%s", PlayMission[kText5]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					format(string, sizeof(string), "%s", PlayMission[kText6]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					MissionCheckpoint[i] = 2;
				}
				else if(MissionCheckpoint[i] == 2 && PlayerToPoint(10.0, i,PlayMission[kCP2][0],PlayMission[kCP2][1],PlayMission[kCP2][2]))
				{
				    RingTone[i] = 20;
				    format(string, sizeof(string), "%s", PlayMission[kGText2]);
					GameTextForPlayer(i, string, 8000, 3);
					format(string, sizeof(string), "%s", PlayMission[kText7]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					format(string, sizeof(string), "%s", PlayMission[kText8]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					format(string, sizeof(string), "%s", PlayMission[kText9]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					MissionCheckpoint[i] = 3;
				}
				else if(MissionCheckpoint[i] == 3 && PlayerToPoint(10.0, i,PlayMission[kCP3][0],PlayMission[kCP3][1],PlayMission[kCP3][2]))
				{
				    RingTone[i] = 20;
				    format(string, sizeof(string), "%s", PlayMission[kGText3]);
					GameTextForPlayer(i, string, 8000, 3);
					format(string, sizeof(string), "%s", PlayMission[kText10]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					format(string, sizeof(string), "%s", PlayMission[kText11]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					format(string, sizeof(string), "%s", PlayMission[kText12]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					MissionCheckpoint[i] = 4;
				}
				else if(MissionCheckpoint[i] == 4 && PlayerToPoint(10.0, i,PlayMission[kCP4][0],PlayMission[kCP4][1],PlayMission[kCP4][2]))
				{
				    RingTone[i] = 20;
				    format(string, sizeof(string), "%s", PlayMission[kGText4]);
					GameTextForPlayer(i, string, 8000, 3);
					format(string, sizeof(string), "%s", PlayMission[kText13]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					format(string, sizeof(string), "%s", PlayMission[kText14]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					format(string, sizeof(string), "%s", PlayMission[kText15]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					MissionCheckpoint[i] = 5;
				}
				else if(MissionCheckpoint[i] == 5 && PlayerToPoint(10.0, i,PlayMission[kCP5][0],PlayMission[kCP5][1],PlayMission[kCP5][2]))
				{
				    RingTone[i] = 20;
				    format(string, sizeof(string), "%s", PlayMission[kGText5]);
					GameTextForPlayer(i, string, 8000, 3);
					format(string, sizeof(string), "%s", PlayMission[kText16]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					format(string, sizeof(string), "%s", PlayMission[kText17]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					format(string, sizeof(string), "%s", PlayMission[kText18]);
					SendClientMessage(i, COLOR_YELLOW2, string);
					MissionCheckpoint[i] = 6;
				}
				else if(MissionCheckpoint[i] == 6 && PlayerToPoint(10.0, i,PlayMission[kCP6][0],PlayMission[kCP6][1],PlayMission[kCP6][2]))
				{
				    RingTone[i] = 20;
				    format(string, sizeof(string), "%s", PlayMission[kGText6]);
					GameTextForPlayer(i, string, 8000, 3);
					format(string, sizeof(string), "..:: Mission Passed : %s | Reward received: $%d ::..", PlayMission[kTitle], PlayMission[kReward]);
					SendClientMessage(i, COLOR_GREEN, string);
					SafeGivePlayerMoney(i, PlayMission[kReward]);
					PlayerInfo[i][pMissionNr] = PlayerOnMission[i];
					MissionCheckpoint[i] = 0;
					PlayerOnMission[i] = 0;
				}
			}
		}
	}
	return 1;
}

public IdleKick()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pAdmin] < 1)
		    {
				GetPlayerPos(i, PlayerPos[i][0], PlayerPos[i][1], PlayerPos[i][2]);
				if(PlayerPos[i][0] == PlayerPos[i][3] && PlayerPos[i][1] == PlayerPos[i][4] && PlayerPos[i][2] == PlayerPos[i][5])
				{
					new plname[64];
					new string[128];
					GetPlayerName(i, plname, sizeof(plname));
					format(string, sizeof(string), "AdmCmd: %s da bi kick boi Nick_Dep_Trai, Ly do: AFK", plname);
					SendClientMessageToAll(COLOR_LIGHTRED, string);
					Kick(i);
				}
				PlayerPos[i][3] = PlayerPos[i][0];
				PlayerPos[i][4] = PlayerPos[i][1];
				PlayerPos[i][5] = PlayerPos[i][2];
			}
		}
	}
}

public SetCamBack(playerid)
{
    if(IsPlayerConnected(playerid))
    {
		new Float:plocx,Float:plocy,Float:plocz;
		GetPlayerPos(playerid, plocx, plocy, plocz);
		SetPlayerPos(playerid, -1863.15, -21.6598, 1060.15); // Warp the player
		SetPlayerInterior(playerid,14);
	}
}

public FixHour(hour)
{
	hour = timeshift+hour;
	if (hour < 0)
	{
		hour = hour+24;
	}
	else if (hour > 23)
	{
		hour = hour-24;
	}
	shifthour = hour;
	return 1;
}

public AddsOn()
{
	adds=1;
	return 1;
}

public BackupClear(playerid, calledbytimer)
{
	if(IsPlayerConnected(playerid))
	{
		if(PlayerInfo[playerid][pMember] == 1||PlayerInfo[playerid][pLeader] == 1)
		{
			if (PlayerInfo[playerid][pRequestingBackup] == 1)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						if(PlayerInfo[i][pMember] == 1||PlayerInfo[i][pLeader] == 1)
						{
							SetPlayerMarkerForPlayer(i, playerid, TEAM_HIT_COLOR);
						}
					}
				}
				if (calledbytimer != 1)
				{
					SendClientMessage(playerid, TEAM_BLUE_COLOR, "Yeu cau backup cua ban da bi xoa.");
				}
				else
				{
					SendClientMessage(playerid, TEAM_BLUE_COLOR, "Yeu cau backup cua ban da bi xoa mot cach tu dong.");
				}
				PlayerInfo[playerid][pRequestingBackup] = 0;
			}
			else
			{
				if (calledbytimer != 1)
				{
					SendClientMessage(playerid, COLOR_DARKNICERED, "Ban khong co yeu cau backup nao!");
				}
			}
		}
		else
		{
			if (calledbytimer != 1)
			{
				SendClientMessage(playerid, COLOR_GREY, "Ban khong phai la canh sat!");
			}
		}
	}
	return 1;
}

public ResetRoadblockTimer()
{
	roadblocktimer = 0;
	return 1;
}

public RemoveRoadblock(playerid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pMember] == 1 || PlayerInfo[i][pLeader] == 1)
			{
				DisablePlayerCheckpoint(i);
			}
		}
	}
	DestroyObject(PlayerInfo[playerid][pRoadblock]);
	PlayerInfo[playerid][pRoadblock] = 0;
	return 1;
}

public IsPlayerInArea(playerid, Float:minx, Float:maxx, Float:miny, Float:maxy)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if (x > minx && x < maxx && y > miny && y < maxy) return 1;
    return 0;
}

public AdvertiseToPlayersAtBusStop(Float:stopX, Float:stopY, Float:stopZ, eastorwest)
{
	for (new i; i<=MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i) && BusrouteWest[i][0] == 0 && BusrouteEast[i][0] == 0)
		{
			if (PlayerToPoint(100, i, stopX, stopY, stopZ))
			{
				SendClientMessage(i, TEAM_AZTECAS_COLOR, "Mot xe bus dang o diem dung gan do. Cac tuyen duong nhu sau:");
				if (eastorwest == 0) SendBusRoute(i, 0);
				else SendBusRoute(i, 1);
				SendClientMessage(i, TEAM_AZTECAS_COLOR, "Ban co muon duoc hien thi diem dung nay? (yes/no)");
				BusShowLocation[i][0] = 1;
				BusShowLocation[i][1] = stopX;
				BusShowLocation[i][2] = stopY;
				BusShowLocation[i][3] = stopZ;
			}
		}
	}
	return 1;
}

public SendBusRoute(playerid, eastorwest)
{
	if (eastorwest == 0)
	{
		// East
		SendClientMessage(playerid, COLOR_LIGHT_BLUE, "Bus Station >> Airport >> Willowfield Factory >> Loco >>");
		SendClientMessage(playerid, COLOR_LIGHT_BLUE, "6 Street Plaza >> 10 Green Bottles >> Pigpen >> Golden Palm >>");
		SendClientMessage(playerid, COLOR_LIGHT_BLUE, "Jefferson Motel >> Glen Park >> Back to Bus stop <<");
	}
	else
	{
		// West
		SendClientMessage(playerid, COLOR_LIGHT_BLUE, "Bus Station >> Alhambra >> Glen Park >> Vinewood Burger >>");
		SendClientMessage(playerid, COLOR_LIGHT_BLUE, "Vice Theater >> Bank >> Rodeo >> Sana Maria Beach >> Verona Beach >>");
		SendClientMessage(playerid, COLOR_LIGHT_BLUE, "Pershing Square >> Back to Bus stop <<");
	}
	return 1;
}

public IsInBusrouteZone(playerid)
{
	if (IsPlayerInArea(playerid, 1722.3599, 2901.8652, -2694.5417, -904.3515)) return 0; // east
	else if (IsPlayerInArea(playerid, 127.4722, 1722.3599, -2694.5417, -904.3515)) return 1; // west
	return 1;
}

public BusrouteEnd(playerid, vehicleid)
{
	if (BusrouteEast[playerid][0] != 0 || BusrouteWest[playerid][0] != 0)
	{
		SendClientMessage(playerid, COLOR_BLUE, "Bus route ended.");
		GameTextForPlayer(playerid, "~r~Bus Route Ended", 5000, 3);
		PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
	}
	DisablePlayerCheckpoint(playerid);
	if (vehicleid != 0) SetVehicleToRespawn(vehicleid);
	BusrouteEast[playerid][0] = 0;
	BusrouteEast[playerid][1] = 0;
	//BusrouteEast[playerid][2] = 0;
	BusrouteWest[playerid][0] = 0;
	BusrouteWest[playerid][1] = 0;
	//BusrouteWest[playerid][2] = 0;
	return 1;
}

public CheckForWalkingTeleport(playerid) // only put teleports ON FOOT here, use another function for vehicle ones - luk0r
{
	/*
	 *  HOW TO USE THIS FUNCTION:
	 *
	 *  Just use your normal PlayerToPoint functions but make them use PlayerToPointStripped instead.
	 *  Use the arguments cx,cy,cz at the end of each call (look at the others for an example).
	 *
	 */
	new Float:cx, Float:cy, Float:cz;
	GetPlayerPos(playerid, cx, cy, cz);

	if(PlayerToPointStripped(1, playerid,1554.9537,-1675.6584,16.1953, cx,cy,cz))
	{//LSPD Entrance
		GameTextForPlayer(playerid, "~w~Police Department", 5000, 1);
		SetPlayerInterior(playerid, 6);
		SetPlayerPos(playerid,246.7079,66.2239,1003.6406);
		PlayerInfo[playerid][pInt] = 6;
	}
	else if(PlayerToPointStripped(1, playerid,246.5325,62.4251,1003.6406, cx,cy,cz))
	{//LSPD Exit
		GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,1552.3231,-1674.6780,16.1953);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1.0, playerid,488.2531,-82.7632,998.7578, cx,cy,cz))
	{
		//Misty/10 Green Toilets
		SetPlayerPos(playerid,2277.5942,-1139.8883,1050.8984);
		GameTextForPlayer(playerid, "~w~Restroom", 5000, 3);
		SetPlayerInterior(playerid,11);
		PlayerInfo[playerid][pInt] = 11;
	}
	else if (PlayerToPointStripped(2.0, playerid,2280.0476,-1139.5413,1050.8984, cx,cy,cz))
	{
		//Misty/10 Green Toilets
		SetPlayerPos(playerid,490.9059,-81.4256,998.7578);
		GameTextForPlayer(playerid, "~w~Ten Green Bottles", 5000, 3);
		SetPlayerInterior(playerid,11);
		PlayerInfo[playerid][pInt] = 11;
	}
	else if(PlayerToPointStripped(1, playerid,1352.1194,-1759.2534,13.5078, cx,cy,cz))
	{//24/7 near PD Entrance
		GameTextForPlayer(playerid, "~w~24/7", 5000, 1);
		SetPlayerInterior(playerid, 6);
		SetPlayerPos(playerid,-26.6916,-55.7149,1003.5469);
		PlayerInfo[playerid][pInt] = 6;
	}
	else if(PlayerToPointStripped(1, playerid,-27.3919,-58.2529,1003.5469, cx,cy,cz))
	{//24/7 near PD Exit
		GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,1352.3282,-1755.4298,13.3542);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if(PlayerToPointStripped(1, playerid,1833.6124,-1842.4968,13.5781, cx,cy,cz))
	{//24/7 near 8-ball entrance
		GameTextForPlayer(playerid, "~w~24/7", 5000, 1);
		SetPlayerInterior(playerid, 18);
		SetPlayerPos(playerid,-30.9467,-89.6096,1003.5469);
		PlayerInfo[playerid][pInt] = 18;
	}
	else if(PlayerToPointStripped(1, playerid,-30.9299,-92.0114,1003.5469, cx,cy,cz))
	{//24/7 near 8-ball exit
		if(GetPlayerVirtualWorld(playerid) == 0)
		{
			GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid,1831.5413,-1843.3785,13.5781);
			PlayerInfo[playerid][pInt] = 0;
		}
		else if(GetPlayerVirtualWorld(playerid) == 2)
		{
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVirWorld] = 0;
			GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid,1315.7769,-901.4099,39.5781);
			PlayerInfo[playerid][pInt] = 0;
		}
	}
	else if(PlayerToPointStripped(1, playerid,1315.4581,-897.6843,39.5781, cx,cy,cz))
	{//24/7 vinewood
		SetPlayerVirtualWorld(playerid, 2);
		PlayerInfo[playerid][pVirWorld] = 2;
		GameTextForPlayer(playerid, "~w~24/7", 5000, 1);
		SetPlayerInterior(playerid, 18);
		SetPlayerPos(playerid,-30.9467,-89.6096,1003.5469);
		PlayerInfo[playerid][pInt] = 18;
	}
	else if(PlayerToPointStripped(1, playerid,1836.4064,-1682.4403,13.3493, cx,cy,cz))
	{//Alhambra Entrance
		GameTextForPlayer(playerid, "~w~Alhambra", 5000, 1);
		SetPlayerInterior(playerid, 17);
		SetPlayerPos(playerid,493.3891,-22.7212,1000.6797);
		PlayerInfo[playerid][pInt] = 17;
	}
	else if(PlayerToPointStripped(1, playerid,493.4393,-24.9169,1000.6719, cx,cy,cz))
	{//Alhambra Exit
		GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,1834.4000,-1681.7500,13.4331);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if(PlayerToPointStripped(1, playerid,2310.0183,-1643.4669,14.8270, cx,cy,cz))
	{//10 green
		GameTextForPlayer(playerid, "~w~Ten Green Bottles", 5000, 1);
		SetPlayerInterior(playerid, 11);
		SetPlayerPos(playerid,502.0531,-70.2137,998.7578);
		PlayerInfo[playerid][pInt] = 11;
	}
	else if(PlayerToPointStripped(1, playerid,501.8708,-67.5820,998.7578, cx,cy,cz))
	{//Some teleports are fucked up but they are working
		GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,2307.0027,-1645.2213,14.6882);
		OnPlayerExitFood(playerid); // ?
		PlayerInfo[playerid][pInt] = 0;
	}
	else if(PlayerToPointStripped(1, playerid,2244.3423,-1665.5542,15.4766, cx,cy,cz))
	{//Binco next to 10 green
		GameTextForPlayer(playerid, "~w~Binco", 5000, 1);
		SendClientMessage(playerid, COLOR_WHITE, "Meo: Type /clothes to change your outfit");
		SetPlayerInterior(playerid, 15);
		SetPlayerPos(playerid,207.7336,-108.6231,1005.1328);
		PlayerInfo[playerid][pInt] = 15;
	}
	else if(PlayerToPointStripped(1, playerid,207.7662,-111.2663,1005.1328, cx,cy,cz))
	{//Some teleports are fucked up but they are working
		GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,2245.2778,-1661.1738,15.4690);
		OnPlayerExitFood(playerid); // ?
		PlayerInfo[playerid][pInt] = 0;
	}
	else if(PlayerToPointStripped(1, playerid,2229.9011,-1721.2582,13.5613, cx,cy,cz))
	{//Ganton Gym
		GameTextForPlayer(playerid, "~w~Gym", 5000, 1);
		SetPlayerInterior(playerid, 5);
		SetPlayerPos(playerid,771.9399,-2.2574,1000.7292);
		PlayerInfo[playerid][pInt] = 5;
	}
	else if(PlayerToPointStripped(1, playerid,772.3594,-5.5157,1000.7286, cx,cy,cz))
	{//Some teleports are fucked up but they are working
		GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,2225.6699,-1725.3134,13.5586);
		OnPlayerExitFood(playerid); // ?
		PlayerInfo[playerid][pInt] = 0;
	}
	else if(PlayerToPointStripped(1, playerid,2421.4998,-1219.2438,25.5617, cx,cy,cz))
	{//Pigpen
		GameTextForPlayer(playerid, "~w~The Pig Pen", 5000, 1);
		SetPlayerInterior(playerid, 2);
		SetPlayerPos(playerid,1205.0803,-9.9519,1000.9219);
		PlayerInfo[playerid][pInt] = 2;
	}
	else if(PlayerToPointStripped(1, playerid,1204.8462,-13.8521,1000.9219, cx,cy,cz))
	{//Some teleports are fucked up but they are working
		GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,2419.5559,-1226.5612,24.9379);
		OnPlayerExitFood(playerid); // ?
		PlayerInfo[playerid][pInt] = 0;
	}
    else if(PlayerToPointStripped(1, playerid,2419.9941,-1509.5865,24.0000, cx,cy,cz))
	{//Cluckin Bell near pigpen
		OnPlayerEnterFood(playerid, 1);
	}
	else if(PlayerToPointStripped(1, playerid,364.0594,-11.7518,1001.8516, cx,cy,cz))
	{//Some teleports are fucked up but they are working
		if(GetPlayerVirtualWorld(playerid) == 0)
		{
			GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid,2423.8145,-1510.2896,23.9922);
			PlayerInfo[playerid][pInt] = 0;
		}//cluckin bell near 10 green
		else if(GetPlayerVirtualWorld(playerid) == 2)
		{
			GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid,2398.5508,-1894.6324,13.3828);
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVirWorld] = 0;
			PlayerInfo[playerid][pInt] = 0;
		}//cluckin bell marina
		else if(GetPlayerVirtualWorld(playerid) == 1)
		{
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVirWorld] = 0;
			GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid,923.8998,-1352.9694,13.3768);
			PlayerInfo[playerid][pInt] = 0;
		}
		OnPlayerExitFood(playerid); // ?
		return 1;
	}
	else if(PlayerToPointStripped(1, playerid,2398.6240,-1899.2014,13.5469, cx,cy,cz))
	{//Cluckin Bell near 10 green
		SetPlayerVirtualWorld(playerid, 2);
		PlayerInfo[playerid][pVirWorld] = 2;
		OnPlayerEnterFood(playerid, 1);
	}
	else if(PlayerToPointStripped(1, playerid,810.4849,-1616.2451,13.5469, cx,cy,cz))
	{//Marina Burger shot
		OnPlayerEnterFood(playerid, 2);
	}
	else if(PlayerToPointStripped(1, playerid,362.8835,-75.1787,1001.5078, cx,cy,cz))
	{//Some teleports are fucked up but they are working
		if(GetPlayerVirtualWorld(playerid) == 0)
		{
			GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid,815.5034,-1616.7700,13.7521);
			PlayerInfo[playerid][pInt] = 0;
		}
		else if(GetPlayerVirtualWorld(playerid) == 1)// vinewood burger shot
		{
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVirWorld] = 0;
			GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid,1200.8680,-921.9525,43.0104);
			PlayerInfo[playerid][pInt] = 0;
		}
		OnPlayerExitFood(playerid);
		return 1;
	}
	else if(PlayerToPointStripped(1, playerid,928.9110,-1352.9958,13.3438, cx,cy,cz))
	{//Marina Cluckin bell
		SetPlayerVirtualWorld(playerid, 1);
		PlayerInfo[playerid][pVirWorld] = 1;
		OnPlayerEnterFood(playerid, 1);
	}
	else if(PlayerToPointStripped(1, playerid,1199.2477,-918.1447,43.1233, cx,cy,cz))
	{//Vinewood Burger shot
		SetPlayerVirtualWorld(playerid, 1);
		PlayerInfo[playerid][pVirWorld] = 1;
		OnPlayerEnterFood(playerid, 2);
	}
	else if(PlayerToPointStripped(1, playerid,1000.5861,-919.8832,42.3281, cx,cy,cz))
	{//24/7 gas station
		GameTextForPlayer(playerid, "~w~24/7", 5000, 1);
		SetPlayerInterior(playerid, 4);
		SetPlayerPos(playerid,-28.2619,-26.2015,1003.5573);
		PlayerInfo[playerid][pInt] = 4;
	}
	else if(PlayerToPointStripped(1, playerid,-28.0241,-31.7674,1003.5573, cx,cy,cz))
	{//Some teleports are fucked up but they are working
		GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,994.6481,-920.7285,42.1797);
		OnPlayerExitFood(playerid); // ?
		PlayerInfo[playerid][pInt] = 0;
	}
	else if(PlayerToPointStripped(1, playerid,227.5614,-7.3146,1002.2109, cx,cy,cz))
	{//Some teleports are fucked up but they are working
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVirWorld] = 0;
		GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,454.5949,-1500.6449,30.8821);
		OnPlayerExitFood(playerid); // ?
		PlayerInfo[playerid][pInt] = 0;
	}
	else if(PlayerToPointStripped(1, playerid,2105.4858,-1806.4725,13.5547, cx,cy,cz))
	{//Pizzaboy
		OnPlayerEnterFood(playerid, 3);
	}
	else if(PlayerToPointStripped(1, playerid,203.5140,-202.2578,1.5781, cx,cy,cz))
	{//Pizzaboy
	    SetPlayerVirtualWorld(playerid, 2);
	    PlayerInfo[playerid][pVirWorld] = 2;
		OnPlayerEnterFood(playerid, 3);
	}
	else if(PlayerToPointStripped(1, playerid,372.3847,-133.5248,1001.4922, cx,cy,cz))
	{//Some teleports are fucked up but they are working
	    if(GetPlayerVirtualWorld(playerid) == 2)
	    {
	        GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
	        SetPlayerInterior(playerid, 0);
	        SetPlayerPos(playerid,203.2209,-204.6613,1.5781);
	        OnPlayerExitFood(playerid); // ?
	        PlayerInfo[playerid][pInt] = 0;
	        SetPlayerVirtualWorld(playerid, 0);
	        PlayerInfo[playerid][pVirWorld] = 0;
	    }
	    else
	    {
			GameTextForPlayer(playerid, "~w~Los Angeles", 5000, 1);
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid,2099.9783,-1806.4928,13.5547);
			OnPlayerExitFood(playerid); // ?
			PlayerInfo[playerid][pInt] = 0;
		}
	}
	else if(PlayerToPointStripped(1, playerid,2105.4858,-1806.4725,13.5547, cx,cy,cz))
	{//Pizzaboy
		OnPlayerEnterFood(playerid, 3);
	}
	else if (PlayerToPointStripped(2.0, playerid,-2441.9749,754.0135,35.1786, cx,cy,cz))
	{
		//24-7
		SetPlayerPos(playerid, -25.1326,-139.0670,1003.5469);
		GameTextForPlayer(playerid, "~w~Welcome to the ~r~24-7",5000,3);
		SetPlayerInterior(playerid,16);
		PlayerInfo[playerid][pInt] = 16;
	}
	else if (PlayerToPointStripped(2.0, playerid,-25.1326,-141.0670,1003.5469, cx,cy,cz))
	{
		//24-7
		SetPlayerPos(playerid, -2441.9749,752.0135,35.1786);
		GameTextForPlayer(playerid, "~r~San Fierro",5000,3);
		SetPlayerInterior(playerid,0);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1, playerid,1298.7075,-798.5981,84.1406, cx,cy,cz))
	{
		//Madd dog crip enter
  		SetPlayerPos(playerid, 1254.3436,-789.3809,1084.0078);
		GameTextForPlayer(playerid, "~w~La Famiglia Sinatra HQ",5000,1);
		SetPlayerInterior(playerid,5);
		PlayerInfo[playerid][pInt] = 5;
	}
	else if (PlayerToPointStripped(1, playerid,1252.5208,-789.2282,1084.0078, cx,cy,cz))
	{
		//Madd dog crip exit
		SetPlayerPos(playerid, 1298.6263,-801.5491,84.1406);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1, playerid,1518.5179,-1452.9224,14.2031, cx,cy,cz))
	{
		//FBI Enter
		SetPlayerPos(playerid, 288.7287,168.5377,1007.1719);
		GameTextForPlayer(playerid, "~w~FBI Department",5000,1);
		SetPlayerInterior(playerid,3);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 3;
	}
	else if (PlayerToPointStripped(1, playerid,288.7287,167.0377,1007.1719, cx,cy,cz))
	{
		//FBI Exit
		SetPlayerPos(playerid, 1518.4724,-1450.2354,13.5469);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1, playerid,238.3001,138.9406,1003.0234, cx,cy,cz))
	{
		//FBI Exit
		SetPlayerPos(playerid, 1518.4724,-1450.2354,13.5469);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1, playerid,1173.2563,-1323.3102,15.3943, cx,cy,cz))
	{
		//Hospital enter
		SetPlayerPos(playerid, 1172.1720,-1332.8326,1006.4028);
		GameTextForPlayer(playerid, "~w~All Saints Hospital",5000,1);
		SetPlayerInterior(playerid,6);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 6;
	}
	else if (PlayerToPointStripped(1, playerid,1172.1730,-1333.9272,1006.4965, cx,cy,cz))
	{
		//Hospital exit
		SetPlayerPos(playerid, 1174.2563,-1323.3102,15.3943);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 270);
		PlayerInfo[playerid][pInt] = 0;
	}
	/*else if (PlayerToPointStripped(1, playerid,1038.0298,-1339.9967,13.7361, cx,cy,cz))
	{
		//Jim's sticky ring
		SetPlayerPos(playerid, 377.5237,-191.6597,1000.6328);
		GameTextForPlayer(playerid, "~w~Jim's sticky ring",5000,1);
		SetPlayerInterior(playerid,17);
		SetPlayerFacingAngle(playerid, 320);
		PlayerInfo[playerid][pInt] = 17;
	}
	else if (PlayerToPointStripped(1, playerid,377.1724,-193.3045,1000.6328, cx,cy,cz))
	{
		//Jim's sticky ring
		SetPlayerPos(playerid, 1038.5148,-1338.0944,13.7266);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
	}*/
	else if (PlayerToPointStripped(1, playerid,1038.0298,-1339.9967,13.7361, cx,cy,cz))
	{
		//Jim's sticky ring
		OnPlayerEnterFood(playerid, 4);
	}
	else if (PlayerToPointStripped(1, playerid,377.1724,-193.3045,1000.6328, cx,cy,cz))
	{
		//Jim's sticky ring
		SetPlayerPos(playerid, 1038.5148,-1338.0944,13.7266);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		OnPlayerExitFood(playerid);
	}
	else if (PlayerToPointStripped(1, playerid,2495.3481,-1691.1355,14.7656, cx,cy,cz))
	{
		//47th Street Saints  gang hq
		if(PlayerInfo[playerid][pMember] == 15 || PlayerInfo[playerid][pLeader] == 15)
		{
			SetPlayerPos(playerid, 2496.0061,-1693.5201,1014.7422);
			GameTextForPlayer(playerid, "~w~47th Street Saints HQ",5000,1);
			SetPlayerInterior(playerid,3);
			SetPlayerFacingAngle(playerid, 181);
			PlayerInfo[playerid][pInt] = 3;
		}
		else if(hqlock[iolock] == 0)
		{
		    SetPlayerPos(playerid, 2496.0061,-1693.5201,1014.7422);
			GameTextForPlayer(playerid, "~w~47th Street Saints HQ",5000,1);
			SetPlayerInterior(playerid,3);
			SetPlayerFacingAngle(playerid, 181);
			PlayerInfo[playerid][pInt] = 3;
		}
		else
		{
		    GameTextForPlayer(playerid, "~r~Locked",5000,1);
		}
	}
	else if (PlayerToPointStripped(1, playerid,2496.0039,-1692.2004,1014.7422, cx,cy,cz))
	{
		//47th Street Saints gang hq
		SetPlayerPos(playerid, 2495.3718,-1688.8561,14.0673);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 1);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1, playerid,2495.9866,-1692.0835,1014.7422, cx,cy,cz))
	{
		//Easy Side Bloods  gang hq
		if(PlayerInfo[playerid][pMember] == 16 || PlayerInfo[playerid][pLeader] == 16)
		{
			SetPlayerPos(playerid, 446.9658,1399.1479,1084.3047);
			GameTextForPlayer(playerid, "~w~Easy Side Bloods HQ",5000,1);
			SetPlayerInterior(playerid,2);
			SetPlayerFacingAngle(playerid, 1);
			PlayerInfo[playerid][pInt] = 2;
		}
		else if(hqlock[iolock] == 0)
		{
		    SetPlayerPos(playerid, 318.4700,1117.5127,1083.8828);
			GameTextForPlayer(playerid, "~w~Easy Side Bloods HQ",5000,1);
			SetPlayerInterior(playerid,2);
			SetPlayerFacingAngle(playerid, 0);
			PlayerInfo[playerid][pInt] = 2;
		}
		else
		{
		    GameTextForPlayer(playerid, "~r~Locked",5000,1);
		}
	}
	else if (PlayerToPointStripped(1, playerid,447.0208,1397.4796,1084.3047, cx,cy,cz))
	{
		//East Side Bloods gang hq
		SetPlayerPos(playerid, 2501.8979,-1495.7324,24.0000);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 179);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1, playerid,1828.1594,-1980.4380,13.5469, cx,cy,cz))
	{
		//Surenos HQ
		if(PlayerInfo[playerid][pMember] == 5 || PlayerInfo[playerid][pLeader] == 5)
		{
			SetPlayerPos(playerid, 2352.1885,-1180.9219,1027.9766);
			GameTextForPlayer(playerid, "~w~Los Surenos 13 HQ",5000,1);
			SetPlayerInterior(playerid,5);
			SetPlayerFacingAngle(playerid, 90);
			PlayerInfo[playerid][pInt] = 5;
		}
		else if(hqlock[surlock] == 0)
		{
		    SetPlayerPos(playerid, 1237.8329,-833.3148,1084.0078);
			GameTextForPlayer(playerid, "~w~Los Surenos 13 HQ",5000,1);
			SetPlayerInterior(playerid,5);
			SetPlayerFacingAngle(playerid, 90);
			PlayerInfo[playerid][pInt] = 5;
		}
		else
		{
		    GameTextForPlayer(playerid, "~r~Locked",5000,1);
		}
	}
	else if (PlayerToPointStripped(1, playerid,2352.9187,-1180.9679,1027.9766, cx,cy,cz))
	{
		//Surenos HQ
		SetPlayerPos(playerid, 1828.1904,-1981.0223,13.5469);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 179);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1, playerid,1481.0206,-1771.1138,18.7958, cx,cy,cz))
	{
		//City hall
		SetPlayerPos(playerid, 386.2978,173.8582,1008.3828);
		GameTextForPlayer(playerid, "~w~City Hall",5000,1);
		SetPlayerInterior(playerid,3);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 3;
	}
	else if (PlayerToPointStripped(1, playerid,390.0630,173.5741,1008.3828, cx,cy,cz))
	{
		//City hall
		SetPlayerPos(playerid, 1481.0206,-1769.5138,18.7958);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1, playerid,1784.58,-1297.52,13.37, cx,cy,cz))
	{
		//ABC studio
		SetPlayerPos(playerid, 366.5081,193.1942,1008.3828);
		GameTextForPlayer(playerid, "~w~ABC studio",5000,1);
		SetPlayerInterior(playerid,3);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 3;
	}
	else if (PlayerToPointStripped(1, playerid,366.3892,190.9860,1008.3828, cx,cy,cz))
	{
		//ABC studio
		SetPlayerPos(playerid, 1784.3687,-1294.7397,13.4606);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1, playerid,1752.8452,-1894.1328,13.5573, cx,cy,cz))
	{
		//LA Yellow Cab Co.
		SetPlayerPos(playerid, 371.8502,182.0368,1014.1875);
		GameTextForPlayer(playerid, "~w~LA Yellow Cab Co.",5000,1);
		SetPlayerInterior(playerid,3);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 3;
	}
	else if (PlayerToPointStripped(1, playerid,371.4523,180.2195,1014.1875, cx,cy,cz))
	{
		//LA Yellow Cab Co.
		SetPlayerPos(playerid, 1755.7578,-1894.1992,13.5566);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
	}
	/*else if (PlayerToPointStripped(1, playerid,2770.6973,-1628.4293,12.1775, cx,cy,cz))
	{
		//Institute of Race HQ
		if(PlayerInfo[playerid][pMember] == 16 || PlayerInfo[playerid][pLeader] == 16)
		{
			SetPlayerPos(playerid, 2464.8335,-1698.4218,1013.5078);
			GameTextForPlayer(playerid, "~w~Institute of Race HQ",5000,1);
			SetPlayerInterior(playerid,2);
			SetPlayerFacingAngle(playerid, 90);
			PlayerInfo[playerid][pInt] = 2;
		}
		else if(hqlock[iolock] == 0)
		{
		    SetPlayerPos(playerid, 2464.8335,-1698.4218,1013.5078);
			GameTextForPlayer(playerid, "~w~Institute of Race HQ",5000,1);
			SetPlayerInterior(playerid,2);
			SetPlayerFacingAngle(playerid, 90);
			PlayerInfo[playerid][pInt] = 2;
		}
		else
		{
		    GameTextForPlayer(playerid, "~r~Locked",5000,1);
		}
	}
	else if (PlayerToPointStripped(1.5, playerid,2468.7039,-1698.3466,1013.5078, cx,cy,cz))
	{
		//Institute of Race HQ
		SetPlayerPos(playerid, 2772.6973,-1628.4293,12.1775);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
	}*/
	else if (PlayerToPointStripped(1, playerid,2045.3928,-1908.0372,13.5469, cx,cy,cz))
	{
		//DMW
		SetPlayerPos(playerid, 1494.6207,1305.2336,1093.2891);
		GameTextForPlayer(playerid, "~w~License center",5000,1);
		SetPlayerInterior(playerid,3);
		SetPlayerFacingAngle(playerid, 0);
		PlayerInfo[playerid][pInt] = 3;
	}
	else if (PlayerToPointStripped(1, playerid,1494.2778,1303.7288,1093.2891, cx,cy,cz))
	{
		//DMW Exit
		SetPlayerPos(playerid, 2046.8928,-1908.0372,13.5469);
		GameTextForPlayer(playerid, "~w~Los Angeles",5000,1);
		SetPlayerInterior(playerid,0);
		SetPlayerFacingAngle(playerid, 280);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1, playerid,1524.5724,-1677.8043,6.2188, cx,cy,cz))
	{
	    //PD Elevator
	    SetPlayerPos(playerid, 244.0099,66.4152,1003.6406);
	    GameTextForPlayer(playerid, "~w~Police Department",5000,1);
	    SetPlayerInterior(playerid,6);
	    SetPlayerFacingAngle(playerid, 270);
		PlayerInfo[playerid][pInt] = 6;
	}
	else if (PlayerToPointStripped(1, playerid,1557.7257,-1675.2711,28.3955, cx,cy,cz))
	{
	    //PD Elevator
	    SetPlayerPos(playerid, 244.0099,66.4152,1003.6406);
	    GameTextForPlayer(playerid, "~w~Police Department",5000,1);
	    SetPlayerInterior(playerid,6);
	    SetPlayerFacingAngle(playerid, 270);
		PlayerInfo[playerid][pInt] = 6;
	}
	else if (PlayerToPointStripped(1.5, playerid,1570.3828,-1333.8882,16.4844, cx,cy,cz))
	{
	    //Next to PD building
	    SetPlayerPos(playerid, 1545.0068,-1366.5094,327.2868);
	    GameTextForPlayer(playerid, "~w~Roof of News building",5000,1);
	    SetPlayerInterior(playerid,0);
		PlayerInfo[playerid][pInt] = 0;
	}
	else if (PlayerToPointStripped(1.5, playerid,1548.8167,-1366.2247,326.2109, cx,cy,cz))
	{
	    //Next to PD building
	    SetPlayerPos(playerid, 1572.1115,-1332.5288,16.4844);
	    GameTextForPlayer(playerid, "~w~News building",5000,1);
	    SetPlayerInterior(playerid,0);
		PlayerInfo[playerid][pInt] = 0;
	}
	return 1;
}

public CreateFoodMenus() // by Luk0r (Donut part by Ellis)
{
	// Burger Shot
	burgermenu = CreateMenu("Burger Shot", 2, 200.0, 100.0, 150.0, 150.0);
	AddMenuItem(burgermenu,0,"Meals");
	AddMenuItem(burgermenu,0,"Sharp Shooter");
	AddMenuItem(burgermenu,0,"Cheeseburger");
	AddMenuItem(burgermenu,0,"Double Patty Sandwich");
	AddMenuItem(burgermenu,0,"Beefy Salad");
	AddMenuItem(burgermenu,0," ");
	AddMenuItem(burgermenu,0,"Drinks");
	AddMenuItem(burgermenu,0,"Bottle of Water");
	AddMenuItem(burgermenu,0,"Sprunk");
	AddMenuItem(burgermenu,0," ");
	AddMenuItem(burgermenu,0,"Leave");
	AddMenuItem(burgermenu,1," ");
	AddMenuItem(burgermenu,1,"$2"); // Sharp Shooter
	AddMenuItem(burgermenu,1,"$4"); // Cheeseburger
	AddMenuItem(burgermenu,1,"$5"); // DP Sandwich
	AddMenuItem(burgermenu,1,"$3"); // Beefy Salad
	AddMenuItem(burgermenu,1," ");
	AddMenuItem(burgermenu,1," ");
	AddMenuItem(burgermenu,1,"$1"); // Water
	AddMenuItem(burgermenu,1,"$1"); // Sprunk
	AddMenuItem(burgermenu,1," ");
	AddMenuItem(burgermenu,1," ");
	DisableMenuRow(burgermenu, 0);
	DisableMenuRow(burgermenu, 5);
	DisableMenuRow(burgermenu, 6);
	DisableMenuRow(burgermenu, 9);

	// Cluckin Bell
	chickenmenu = CreateMenu("Cluckin' Bell", 2, 200.0, 100.0, 150.0, 150.0);
	AddMenuItem(chickenmenu,0,"Meals");
	AddMenuItem(chickenmenu,0,"Little Clucker");
	AddMenuItem(chickenmenu,0,"Chicken Nuggets");
	AddMenuItem(chickenmenu,0,"Chicken Sandwich");
	AddMenuItem(chickenmenu,0,"Chicken Salad");
	AddMenuItem(chickenmenu,0," ");
	AddMenuItem(chickenmenu,0,"Drinks");
	AddMenuItem(chickenmenu,0,"Bottle of Water");
	AddMenuItem(chickenmenu,0,"Sprunk");
	AddMenuItem(chickenmenu,0," ");
	AddMenuItem(chickenmenu,0,"Leave");
	AddMenuItem(chickenmenu,1," ");
	AddMenuItem(chickenmenu,1,"$2"); // Little Clucker
	AddMenuItem(chickenmenu,1,"$4"); // Nuggets
	AddMenuItem(chickenmenu,1,"$5"); // C Sandwich
	AddMenuItem(chickenmenu,1,"$3"); // Salad
	AddMenuItem(chickenmenu,1," ");
	AddMenuItem(chickenmenu,1," ");
	AddMenuItem(chickenmenu,1,"$1"); // Water
	AddMenuItem(chickenmenu,1,"$1"); // Sprunk
	AddMenuItem(chickenmenu,1," ");
	AddMenuItem(chickenmenu,1," ");
	DisableMenuRow(chickenmenu, 0);
	DisableMenuRow(chickenmenu, 5);
	DisableMenuRow(chickenmenu, 6);
	DisableMenuRow(chickenmenu, 9);

	// Pizza Stack
	pizzamenu = CreateMenu("Well Stacked Pizza", 2, 200.0, 100.0, 150.0, 150.0);
	AddMenuItem(pizzamenu,0,"Meals");
	AddMenuItem(pizzamenu,0,"Little Sicilian");
	AddMenuItem(pizzamenu,0,"Personal Pan Pizza");
	AddMenuItem(pizzamenu,0,"Sheet Pizza");
	AddMenuItem(pizzamenu,0,"Pepperoni Salad");
	AddMenuItem(pizzamenu,0," ");
	AddMenuItem(pizzamenu,0,"Drinks");
	AddMenuItem(pizzamenu,0,"Bottle of Water");
	AddMenuItem(pizzamenu,0,"Sprunk");
	AddMenuItem(pizzamenu,0," ");
	AddMenuItem(pizzamenu,0,"Leave");
	AddMenuItem(pizzamenu,1," ");
	AddMenuItem(pizzamenu,1,"$2"); // Sicilian
	AddMenuItem(pizzamenu,1,"$4"); // Personal Pan
	AddMenuItem(pizzamenu,1,"$5"); // Sheet
	AddMenuItem(pizzamenu,1,"$3"); // Salad
	AddMenuItem(pizzamenu,1," ");
	AddMenuItem(pizzamenu,1," ");
	AddMenuItem(pizzamenu,1,"$1"); // Water
	AddMenuItem(pizzamenu,1,"$1"); // Sprunk
	AddMenuItem(pizzamenu,1," ");
	AddMenuItem(pizzamenu,1," ");
	DisableMenuRow(pizzamenu, 0);
	DisableMenuRow(pizzamenu, 5);
	DisableMenuRow(pizzamenu, 6);
	DisableMenuRow(pizzamenu, 9);

	// Jim's sticky ring
	donutshop = CreateMenu("Jim's sticky ring", 2, 200.0, 100.0, 150.0, 150.0);
	AddMenuItem(donutshop,0,"Donuts");
	AddMenuItem(donutshop,0,"Little Donut");
	AddMenuItem(donutshop,0,"Regular Donut");
	AddMenuItem(donutshop,0,"Chief Donut");
	AddMenuItem(donutshop,0,"Extra large Donut");
	AddMenuItem(donutshop,0," ");
	AddMenuItem(donutshop,0,"Drinks");
	AddMenuItem(donutshop,0,"Bottle of Water");
	AddMenuItem(donutshop,0,"Sprunk");
	AddMenuItem(donutshop,0," ");
	AddMenuItem(donutshop,0,"Leave");
	AddMenuItem(donutshop,1," ");
	AddMenuItem(donutshop,1,"$2"); // Little Donut
	AddMenuItem(donutshop,1,"$4"); // Regular Donut
	AddMenuItem(donutshop,1,"$5"); // Chief Donut
	AddMenuItem(donutshop,1,"$4"); // Extra large Donut
	AddMenuItem(donutshop,1," ");
	AddMenuItem(donutshop,1," ");
	AddMenuItem(donutshop,1,"$1"); // Water
	AddMenuItem(donutshop,1,"$1"); // Sprunk
	AddMenuItem(donutshop,1," ");
	AddMenuItem(donutshop,1," ");
	DisableMenuRow(donutshop, 0);
	DisableMenuRow(donutshop, 5);
	DisableMenuRow(donutshop, 6);
	DisableMenuRow(donutshop, 9);
}

public ClearChatbox(playerid, lines)
{
	if (IsPlayerConnected(playerid))
	{
		for(new i=0; i<lines; i++)
		{
			SendClientMessage(playerid, COLOR_GREY, " ");
		}
	}
	return 1;
}

public CreateGuideMenus()
{
	Guide = CreateMenu("Huong dan", 1, 50.0, 180.0, 200.0, 200.0);
	AddMenuItem(Guide, 0, "Luat RP");
	AddMenuItem(Guide, 0, "Tim viec lam");
	AddMenuItem(Guide, 0, "Dia diem")
	AddMenuItem(Guide, 0, "- Thoat -");

	Place = CreateMenu("Dia diem", 1, 50.0, 180.0, 200.0, 200.0);
	AddMenuItem(Place, 0, "Trung tam giay phep");
	AddMenuItem(Place, 0, "Noi thue xe");
	AddMenuItem(Place, 0, "Cua hang quan ao");
	AddMenuItem(Place, 0, "Lay vat lieu");
	AddMenuItem(Place, 0, "Lay hat giong");
	AddMenuItem(Place, 0, "Che sung");
	AddMenuItem(Place, 0, "Tru so LSPD");
	AddMenuItem(Place, 0, "City hall");
	AddMenuItem(Place, 0, "<- Sau");
	AddMenuItem(Place, 0, "- Thoat -");

	JobLocations = CreateMenu("Tim viec lam", 1, 50.0, 180.0, 200.0, 200.0);
	AddMenuItem(JobLocations, 0, "Luat su");
	AddMenuItem(JobLocations, 0, "Gai diem");
	AddMenuItem(JobLocations, 0, "Tho sua xe");
	AddMenuItem(JobLocations, 0, "Ve si");
	AddMenuItem(JobLocations, 0, "Vo si");
	AddMenuItem(JobLocations, 0, "Lai xe bus");
	AddMenuItem(JobLocations, 0, "Trucker");
	AddMenuItem(JobLocations, 0, "Giao pizza");
	AddMenuItem(JobLocations, 0, "Toi ->");
	AddMenuItem(JobLocations, 0, "- Thoat -");

	JobLocations2 = CreateMenu("Tim viec lam", 1, 50.0, 180.0, 200.0, 200.0);
	AddMenuItem(JobLocations2, 0, "Nong dan");
	AddMenuItem(JobLocations2, 0, "Don rac");
	AddMenuItem(JobLocations2, 0, "Tho vu khi");
	AddMenuItem(JobLocations2, 0, "Nguoi buon thuoc");
	AddMenuItem(JobLocations2, 0, "<- Lui");
	AddMenuItem(JobLocations2, 0, "- Thoat -");
}

public Startup(playerid, vehicleid)
{
    new pveh = GetVehicleModel(GetPlayerVehicleID(playerid));
    new newcar = GetPlayerVehicleID(playerid);
	if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER || engineOn[vehicleid])
	{
		//I do nothing!
	}
	else if(IsPlayerInAnyVehicle(playerid) && !engineOn[vehicleid] && !vehicleEntered[playerid][vehicleid] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && pveh != 510 && pveh != 462 && newcar != 59 && newcar != 60 && !IsAPlane(newcar) && !IsAHarvest(newcar) && !IsADrugHarvest(newcar) && !IsASweeper(newcar))
	{
		SendClientMessage(playerid, COLOR_LIGHT_BLUE, "Chu y! go /engine hoac nhan SHIFT de khoi dong xe!");
		TogglePlayerControllable(playerid, false);
		vehicleEntered[playerid][vehicleid] = true;
	}
	else if(IsPlayerInAnyVehicle(playerid) && !engineOn[vehicleid] && vehicleEntered[playerid][vehicleid] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && pveh != 510 && pveh != 462 && newcar != 59 && newcar != 60 && !IsAPlane(newcar) && !IsAHarvest(newcar) && !IsADrugHarvest(newcar) && !IsASweeper(newcar))
	{
		SendClientMessage(playerid, COLOR_LIGHT_BLUE, "Chu y! go /engine hoac nhan SHIFT de khoi dong xe!");
		TogglePlayerControllable(playerid, false);
	}
}

public engine2(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    TogglePlayerControllable(playerid, 1);
	}
}

public busroutestoptimer(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    new newcar = GetPlayerVehicleID(playerid);
	    if(IsABus(newcar))
	    {
	        TogglePlayerControllable(playerid, 1);
	        SendClientMessage(playerid, TEAM_AZTECAS_COLOR, "You can go now!");
	    }
	}
}

stock strvalEx( const string[] ) // fix for strval-bug with > 50 letters.
{
	// written by mabako in less than a minute :X
	if( strlen( string ) >= 50 ) return 0; // It will just return 0 if the string is too long
	return strval(string);
}

public NameTimer()
{
	for(new i = 0;i < MAX_PLAYERS;i++)
 	{
	 	if(IsPlayerConnected(i))
 		{
 			for(new q = 0;q < MAX_PLAYERS;q++)
 			{
				if(IsPlayerConnected(q))
				{
 					new Float:p1x;
					new Float:p1y;
					new Float:p1z;
					new Float:p2x;
					new Float:p2y;
					new Float:p2z;
					if(IsPlayerConnected(i) && IsPlayerConnected(q))
					{
						GetPlayerPos(i,p1x,p1y,p1z);
    					GetPlayerPos(q,p2x,p2y,p2z);
						if(GetPointDistanceToPointExMorph(p1x,p1y,p1z,p2x,p2y,p2z) < pdistance)
						{
							if(PlayerInfo[q][pMaskuse] != 1)
	    					{
								ShowPlayerNameTagForPlayer(i,q,1);
							}
	    				}
						else
						{
							ShowPlayerNameTagForPlayer(i,q,0);
						}
                    }
                }
            }
        }
	}
}

public CheckCarHealth()
{
    new string[256];
    new sendername[MAX_PLAYER_NAME];
    for (new i=0; i < MAX_PLAYERS; i++)
    {
        if (IsPlayerConnected(i) && IsPlayerInAnyVehicle(i) && GetPlayerState(i) == PLAYER_STATE_DRIVER)
        {
             new Float:health;
             GetVehicleHealth(GetPlayerVehicleID(i),health);
             new newcar = GetPlayerVehicleID(i);
             if (health <= 500 && !IsABoat(newcar) && !IsABike(newcar) && !IsAPlane(newcar) && !IsAHarvest(newcar) && !IsADrugHarvest(newcar) && !IsASweeper(newcar))
             {
                 if(engineOn[GetPlayerVehicleID(i)] == 1)
                 {
                    if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
                    {
                    	TogglePlayerControllable(i, 0);
                 		SendClientMessage(i, COLOR_LIGHT_BLUE, "Xe cua ban da bi hong, khoi dong dong co len hoac goi tho sua xe! (/exit de ra khoi xe)");
                 		engineOn[GetPlayerVehicleID(i)] = false;
                 		GetPlayerName(i, sendername, sizeof(sendername));
                 		format(string, sizeof(string), "* Dong co xe bi hong (( %s ))", sendername);
						ProxDetector(30.0, i, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
				 }
             }
         }
    }
}

public StartingTheVehicle(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            new RandomStart;
    		new string[256];
    		new sendername[MAX_PLAYER_NAME];
            RandomStart = random(4);
            switch(RandomStart)
            {
                case 0,1,2:
                {
                    engineOn[GetPlayerVehicleID(playerid)] = true;
                    TogglePlayerControllable(playerid, true);
                    GetPlayerName(playerid, sendername, sizeof(sendername));
                    format(string, sizeof(string), "* Dong co duoc khoi dong (( %s )).", sendername);
                    ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                    gEngine[playerid] = 0;
                }
                case 3:
                {
                    GetPlayerName(playerid, sendername, sizeof(sendername));
                    format(string, sizeof(string), "* Dong co khong duoc khoi dong (( %s )).", sendername);
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					gEngine[playerid] = 0;
                }
            }
        }
		else
		{
		    gEngine[playerid] = 0;
		}
    }
    return 1;
}

public FarmerExit(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsAHarvest(vehicleid))
	    {
	        return 1;
	    }
	    if(FarmerVar[playerid] == 0)
	    {
	        return 1;
	    }
	    if(FarmerPickup[playerid][0] >= 1 && FarmerPickup[playerid][0] <= 22)
		{
			FarmerPickup[playerid][0]--;
		}
    	DisablePlayerCheckpoint(playerid);
    	FarmerVar[playerid] = 0;
	}
	return 1;
}

public DrugFarmerExit(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsADrugHarvest(vehicleid))
	    {
	        return 1;
	    }
	    if(DrugFarmerVar[playerid] == 0)
	    {
	        return 1;
	    }
	    if(DrugFarmerPickup[playerid][0] >= 1 && DrugFarmerPickup[playerid][0] <= 37)
		{
			DrugFarmerPickup[playerid][0]--;
		}
    	DisablePlayerCheckpoint(playerid);
    	DrugFarmerVar[playerid] = 0;
	}
	return 1;
}

public LoadingDrugsForSmugglers(playerid)
{
    new idcar = GetPlayerVehicleID(playerid);
	if(IsPlayerConnected(playerid))
	{
	    if(PlayerInfo[playerid][pJob] != 20)
     	{
      		SendClientMessage(playerid, COLOR_GREY, "Ban khong phai la ke buon lau thuoc.");
        	return 1;
		}
		if(!PlayerToPoint(7.0,playerid,-38.8664,56.3031,3.1172))
		{
		    SendClientMessage(playerid, COLOR_GREY, "Ban khong o trong vuon trong thuoc.");
		    return 1;
		}
		if(GetPlayerMoney(playerid) < 299)
		{
		    SendClientMessage(playerid, COLOR_GREY, "Mang it nhat 300$ khi ban la ke buon lau thuoc.");
		    return 1;
		}
		if(IsASmuggleCar(idcar))
		{
		    if(drugsys[DrugAmmount] == 0)
		    {
		        SendClientMessage(playerid, COLOR_GREY, "Khong co thuoc trong vuon.");
		        TogglePlayerControllable(playerid, true);
		        return 1;
		    }
		    if(drugsys[DrugAmmount] == 1)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Chat 1 grams thuoc... (cho 25$)");
		        SmuggledDrugs[playerid] = 1;
		        drugsys[DrugAmmount]--;
		        SafeGivePlayerMoney(playerid, -25);
		    }
		    if(drugsys[DrugAmmount] == 2)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Chat 2 grams thuoc... (cho 50$)");
		        SmuggledDrugs[playerid] = 2;
		        drugsys[DrugAmmount] -= 2;
		        SafeGivePlayerMoney(playerid, -50);
		    }
		    if(drugsys[DrugAmmount] == 3)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Chat 3 grams thuoc... (cho 75$)");
		        SmuggledDrugs[playerid] = 3;
		        drugsys[DrugAmmount] -= 3;
		        SafeGivePlayerMoney(playerid, -75);
		    }
		    if(drugsys[DrugAmmount] == 4)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Chat 4 grams thuoc... (cho 100$)");
		        SmuggledDrugs[playerid] = 4;
		        drugsys[DrugAmmount] -= 4;
		        SafeGivePlayerMoney(playerid, -100);
		    }
		    if(drugsys[DrugAmmount] == 5)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Chat 5 grams thuoc... (cho 125$)");
		        SmuggledDrugs[playerid] = 5;
		        drugsys[DrugAmmount] -= 5;
		        SafeGivePlayerMoney(playerid, -125);
		    }
		    if(drugsys[DrugAmmount] == 6)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Chat 6 grams thuoc... (cho 150$)");
		        SmuggledDrugs[playerid] = 6;
		        drugsys[DrugAmmount] -= 6;
		        SafeGivePlayerMoney(playerid, -150);
		    }
		    if(drugsys[DrugAmmount] == 7)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Chat 7 grams thuoc... (cho 175$)");
		        SmuggledDrugs[playerid] = 7;
		        drugsys[DrugAmmount] -= 7;
		        SafeGivePlayerMoney(playerid, -175);
		    }
		    if(drugsys[DrugAmmount] == 8)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Chat 8 grams thuoc... (for 200$)");
		        SmuggledDrugs[playerid] = 8;
		        drugsys[DrugAmmount] -= 8;
		        SafeGivePlayerMoney(playerid, -200);
		    }
		    if(drugsys[DrugAmmount] == 9)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Chat 9 grams thuoc... (cho 225$)");
		        SmuggledDrugs[playerid] = 9;
		        drugsys[DrugAmmount] -= 9;
		        SafeGivePlayerMoney(playerid, -225);
		    }
		    if(drugsys[DrugAmmount] >= 10)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Chat 10 grams thuoc... (cho 250$)");
		        SmuggledDrugs[playerid] = 10;
		        drugsys[DrugAmmount] -= 10;
		        SafeGivePlayerMoney(playerid, -250);
		    }
		    SetPlayerCheckpoint(playerid, 1135.2180,-1325.2274,13.6277, 5.0);
		    SendClientMessage(playerid, COLOR_YELLOW, "Xe duoc chat hang thanh cong.");
		    SendClientMessage(playerid, COLOR_YELLOW, "Nhanh len! Van chuyen thuoc den noi ban (red marker).");
		    SendClientMessage(playerid, COLOR_YELLOW, "Truoc khi canh sat dieu tra.");
		    SaveDrugSystem();
		    SetPlayerCriminal(playerid,255, "Drugs smuggling");
		    TogglePlayerControllable(playerid, true);
		}
	}
	return 1;
}

public SmugglerExit(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsASmuggleCar(vehicleid))
	    {
	        return 1;
	    }
	    if(SmugglerWork[playerid] == 0)
	    {
	        return 1;
	    }
    	DisablePlayerCheckpoint(playerid);
    	SmugglerWork[playerid] = 0;
	}
	return 1;
}

public SafeGivePlayerMoney(plyid, amounttogive)
{
	new curHour, curMinute, curSecond;
	gettime(curHour, curMinute, curSecond);
	ScriptMoneyUpdated[plyid] = curSecond;
	if (amounttogive < 0)
	{
		GivePlayerMoney(plyid, amounttogive);
		ScriptMoney[plyid] = (ScriptMoney[plyid] + amounttogive);
	}
	else
	{
		ScriptMoney[plyid] = (ScriptMoney[plyid] + amounttogive);
		GivePlayerMoney(plyid, amounttogive);
	}
	return 1;
}

public SafeResetPlayerMoney(plyid)
{
	new curHour, curMinute, curSecond;
	gettime(curHour, curMinute, curSecond);
	ScriptMoneyUpdated[plyid] = curSecond;
	ResetPlayerMoney(plyid);
	ScriptMoney[plyid] = 0;
	return 1;
}

public SafeGivePlayerWeapon(plyid, weaponid, ammo)
{
/*	new curHour, curMinute, curSecond;
	gettime(curHour, curMinute, curSecond);
	ScriptWeaponsUpdated[plyid] = curSecond;*/
	GivePlayerWeapon(plyid, weaponid, ammo);
	//UpdateWeaponSlots(plyid);
	return 1;
}

public SafeResetPlayerWeapons(plyid)
{
/*	new curHour, curMinute, curSecond;
	gettime(curHour, curMinute, curSecond);
	ScriptWeaponsUpdated[plyid] = curSecond;*/
	ResetPlayerWeapons(plyid);
	//UpdateWeaponSlots(plyid);
	return 1;
}

public UpdateWeaponSlots(plyid)
{
	new weaponid, ammo;
	for (new i=0; i<13; i++)
	{
		GetPlayerWeaponData(plyid, i, weaponid, ammo);
		ScriptWeapons[plyid][i] = weaponid;
	}
	return 1;
}

//*public BanAdd(bantype, sqlplayerid, ip[], hackamount)
/*public BanAdd(bantype, sqlplayerid, ip[], hackamount)
{
	new query[128];
	format(query, sizeof(query), "INSERT INTO bans (type,player,ip,time,amount) VALUES ('%d',%d,'%s',UNIX_TIMESTAMP(),%d)", bantype,sqlplayerid,ip,hackamount);
	samp_mysql_query(query);
	return 1;
}*/

public UnsetFirstSpawn(playerid)
{
	FirstSpawn[playerid] = 0;
}

public ClearKnock(playerid)
{
	TogglePlayerControllable(playerid, 1);
	ClearAnimations(playerid);
	KnockedDown[playerid] = 0;
}

public DrugEffectGone(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(UsingDrugs[playerid] == 1)
	    {
	    	SetPlayerWeather(playerid, DefaultWeather);
	    	GameTextForPlayer(playerid, "~w~Drug effect ~p~gone", 3000, 1);
	    	ClearAnimations(playerid);
	    	SetTimerEx("UsingDrugsUnset", 25000, false, "i", playerid);
		}
	}
	return 1;
}

public UsingDrugsUnset(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    UsingDrugs[playerid] = 0;
	}
	return 1;
}

//public UpdatePlayerPosition(playerid)
/*public UpdatePlayerPosition(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(gPlayerLogged[playerid])
	    {
	    	new Float:x, Float:y, Float:z;
     		GetPlayerPos(playerid,x,y,z);
			PlayerInfo[playerid][pPos_x] = x;
			PlayerInfo[playerid][pPos_y] = y;
			PlayerInfo[playerid][pPos_z] = z;
			MySQLCheckConnection();
			new query[MAX_STRING];
			format(query, MAX_STRING, "UPDATE players SET ");
			MySQLUpdatePlayerFlo(query, PlayerInfo[playerid][pSQLID], "Pos_x", PlayerInfo[playerid][pPos_x]);
			MySQLUpdatePlayerFlo(query, PlayerInfo[playerid][pSQLID], "Pos_y", PlayerInfo[playerid][pPos_y]);
			MySQLUpdatePlayerFlo(query, PlayerInfo[playerid][pSQLID], "Pos_z", PlayerInfo[playerid][pPos_z]);
			MySQLUpdatePlayerInt(query, PlayerInfo[playerid][pSQLID], "Inte", PlayerInfo[playerid][pInt]);
			MySQLUpdatePlayerInt(query, PlayerInfo[playerid][pSQLID], "VirWorld", PlayerInfo[playerid][pVirWorld]);
			MySQLUpdatePlayerInt(query, PlayerInfo[playerid][pSQLID], "Crashed", PlayerInfo[playerid][pCrashed]);
			MySQLUpdateFinish(query, PlayerInfo[playerid][pSQLID]);
		}
	}
	return 1;
}*/

public UnsetAfterTutorial(playerid)
{
	if(IsPlayerConnected(playerid))
	{
        AfterTutorial[playerid] = 0;
	}
	return 1;
}

public AfterSpray1(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
    		new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, 2076.5461,-1832.5647,13.5545);
		}
	}
	return 1;
}

public AfterSpray2(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(GetPlayerState(playerid) == 2)
	    {
    		new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, 1025.4225,-1033.1587,31.8380);
		}
	}
	return 1;
}

public AfterSpray3(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(GetPlayerState(playerid) == 2)
	    {
    		new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, 488.3767,-1731.1235,11.2469);
		}
	}
	return 1;
}

public AfterSpray4(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(GetPlayerState(playerid) == 2)
	    {
    		new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, 720.2908,-467.6113,16.3437);
		}
	}
	return 1;
}

public UnsetCrash(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    PlayerInfo[playerid][pCrashed] = 0;
	}
	return 1;
}

public backtoclothes(playerid)
{
	if(IsPlayerConnected(playerid))
	{
 		SetPlayerPos(playerid, ChangePos[playerid][0],ChangePos[playerid][1],ChangePos[playerid][2]);
   		SetPlayerInterior(playerid,ChangePos2[playerid][0]);
	}
	return 1;
}

public RemovePlayerWeapon(playerid, weaponid)
{
	new plyWeapons[12] = 0;
	new plyAmmo[12] = 0;
	for(new slot = 0; slot != 12; slot++)
	{
		new wep, ammo;
		GetPlayerWeaponData(playerid, slot, wep, ammo);

		if(wep != weaponid && ammo != 0)
		{
			GetPlayerWeaponData(playerid, slot, plyWeapons[slot], plyAmmo[slot]);
		}
	}

	SafeResetPlayerWeapons(playerid);
	for(new slot = 0; slot != 12; slot++)
	{
	    if(plyAmmo[slot] != 0)
	    {
			SafeGivePlayerWeapon(playerid, plyWeapons[slot], plyAmmo[slot]);
		}
	}
	return 1;
}

stock CheckPlayerDistanceToVehicle(Float:radi, playerid, vehicleid)
{
	if(IsPlayerConnected(playerid))
	{
	    new Float:PX,Float:PY,Float:PZ,Float:X,Float:Y,Float:Z;
	    GetPlayerPos(playerid,PX,PY,PZ);
	    GetVehiclePos(vehicleid, X,Y,Z);
	    new Float:Distance = (X-PX)*(X-PX)+(Y-PY)*(Y-PY)+(Z-PZ)*(Z-PZ);
	    if(Distance <= radi*radi)
	    {
	        return 1;
	    }
	}
	return 0;
}

public UpdateBurgerPositions()
{
	for(new i = 0; i < MAX_PLAYERS; i ++)
	{
	    if(IsMenuShowed[i] == 0)
	    {
			for(new j = 0; j < sizeof(BurgerDriveIn); j ++)
			{
			    new Float:dist;
			    dist = GetDistance(i, BurgerDriveIn[j][0], BurgerDriveIn[j][1]);
			    if(dist < 5)
			    {
			        GameTextForPlayer(i, "~n~~n~~n~~w~Welcome to the ~r~Burger King~w~, please select your meal", 2000, 3);
			        TogglePlayerControllable(i, 0);
			        SetTimerEx("ShowMenuBurger", 2000, 0, "i", i);
			    }
			}
		}
	}
}

public ShowMenuBurger(i)
{
    BurgerShot = CreateMenu("Burger Shot", 2, 125, 150, 300);
	AddMenuItem(BurgerShot, 0, "Baby Burger");
	AddMenuItem(BurgerShot, 1, "$3");
	AddMenuItem(BurgerShot, 0, "Double Cheese");
	AddMenuItem(BurgerShot, 1, "$6");
	AddMenuItem(BurgerShot, 0, "Triple Whopper");
	AddMenuItem(BurgerShot, 1, "$9");
	AddMenuItem(BurgerShot, 0, "- Exit -");
	ShowMenuForPlayer(BurgerShot, i);
	IsMenuShowed[i] = 1;
}

public UpdateChickenPositions()
{
    for(new i = 0; i < MAX_PLAYERS; i ++)
	{
	    if(IsMenuShowed[i] == 0)
	    {
			for(new j = 0; j < sizeof(ChickenDriveIn); j ++)
			{
			    new Float:dist;
			    dist = GetDistance(i, ChickenDriveIn[j][0], ChickenDriveIn[j][1]);
			    if(dist < 5)
			    {
			        GameTextForPlayer(i, "~n~~n~~n~~w~Welcome to the ~r~Cluckin' Bell~w~, please select your meal", 2000, 3);
			        TogglePlayerControllable(i, 0);
			        SetTimerEx("ShowMenuChicken", 2000, 0, "i", i);
				}
			}
		}
	}
}

public ShowMenuChicken(i)
{
    CluckinBell = CreateMenu("Cluckin' Bell", 2, 125, 150, 300);
	AddMenuItem(CluckinBell, 0, "Chicken Nuggets");
	AddMenuItem(CluckinBell, 1, "$3");
	AddMenuItem(CluckinBell, 0, "Chicken Wing");
	AddMenuItem(CluckinBell, 1, "$6");
	AddMenuItem(CluckinBell, 0, "Crisp Chicken");
	AddMenuItem(CluckinBell, 1, "$9");
	AddMenuItem(CluckinBell, 0, "- Exit -");
	ShowMenuForPlayer(CluckinBell, i);
	IsMenuShowed[i] = 1;
}

public CanDriveThruAgain(playerid)
{
	IsMenuShowed[playerid] = 0;
}

public Float:GetDistance(playerid, Float:x, Float:y)
{
	new Float:x2, Float:y2, Float:z2;
	GetPlayerPos(playerid, x2, y2, z2);
	x = x - x2;
	y = y - y2;
	return floatsqroot(x*x+y*y);
}

public TraceLastCall()
{
	pdtrace = 0;
	pdtrace_x = 0;
	pdtrace_y = 0;
	pdtrace_z = 0;
	emdtrace = 0;
	emdtrace_x = 0;
	emdtrace_y = 0;
	emdtrace_z = 0;
}

public ReportReset(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(JustReported[playerid] == 1)
	    {
			JustReported[playerid] = 0;
	    }
	}
}

public ReduceTimer(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(ReduceTime[playerid] == 1)
	    {
			ReduceTime[playerid] = 0;
	    }
	}
}

public SendAdminMessage(color, string[])
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			if (PlayerInfo[i][pAdmin] >= 1)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
}

#include <ProjectInc\ben>
#include <ProjectInc\geek>

#include <ProjectInc\ontimer>
