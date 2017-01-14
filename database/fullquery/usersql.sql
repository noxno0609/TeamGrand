CREATE TABLE user
(
ID int PRIMARY KEY AUTO_INCREMENT,
`Password` varchar(255) NOT NULL,
Level int(11) NOT NULL,
AdminLevel int(11) NOT NULL,
DonateRank int(11) NOT NULL,
UpgradePoints int(11) NOT NULL,
ConnectedTime int(11) NOT NULL,
Registered int(11) NOT NULL,
Sex int(11) NOT NULL,
Age int(11) NOT NULL,
Origin int(11) NOT NULL,
CK int(11) NOT NULL,
Muted int(11) NOT NULL,
Respect int(11) NOT NULL,
Money int(11) NOT NULL,
Bank int(11) NOT NULL,
Crimes int(11) NOT NULL,
Kills int(11) NOT NULL,
Deaths int(11) NOT NULL,
Arrested int(11) NOT NULL,
WantedDeaths int(11) NOT NULL,
Phonebook int(11) NOT NULL,
LottoNr int(11) NOT NULL,
Fishes int(11) NOT NULL,
BiggestFish int(11) NOT NULL,
Job int(11) NOT NULL,
Paycheck int(11) NOT NULL,
HeadValue int(11) NOT NULL,
Jailed int(11) NOT NULL,
JailTime int(11) NOT NULL,
Materials int(11) NOT NULL,
Drugs int(11) NOT NULL,
Leader int(11) NOT NULL,
Member int(11) NOT NULL,
FMember int(11) NOT NULL,
Rank int(11) NOT NULL,
`Char` int(11) NOT NULL,
ContractTime int(11) NOT NULL,
DetSkill int(11) NOT NULL,
SexSkill int(11) NOT NULL,
BoxSkill int(11) NOT NULL,
LawSkill int(11) NOT NULL,
MechSkill int(11) NOT NULL,
JackSkill int(11) NOT NULL,
CarSkill int(11) NOT NULL,
NewsSkill int(11) NOT NULL,
DrugsSkill int(11) NOT NULL,
CookSkill int(11) NOT NULL,
FishSkill int(11) NOT NULL,
pSHealth float NOT NULL,
pHealth float NOT NULL,
`Int` int(11) NOT NULL,
Local int(11) NOT NULL,
Team int(11) NOT NULL,
Model int(11) NOT NULL,
PhoneNr int(11) NOT NULL,
Car int(11) NOT NULL,
Car2 int(11) NOT NULL,
Car3 int(11) NOT NULL,
House int(11) NOT NULL,
Biz int(11) NOT NULL,
Pos_x float NOT NULL,
Pos_y float NOT NULL,
Pos_z float NOT NULL,
CarLic int(11) NOT NULL,
FlyLic int(11) NOT NULL,
BoatLic int(11) NOT NULL,
FishLic int(11) NOT NULL,
GunLic int(11) NOT NULL,
Gun1 int(11) NOT NULL,
Gun2 int(11) NOT NULL,
Gun3 int(11) NOT NULL,
Gun4 int(11) NOT NULL,
Ammo1 int(11) NOT NULL,
Ammo2 int(11) NOT NULL,
Ammo3 int(11) NOT NULL,
Ammo4 int(11) NOT NULL,
CarTime int(11) NOT NULL,
PayDay int(11) NOT NULL,
PayDayHad int(11) NOT NULL,
Watch int(11) NOT NULL,
Crashed int(11) NOT NULL,
Wins int(11) NOT NULL,
Loses int(11) NOT NULL,
AlcoholPerk int(11) NOT NULL,
DrugPerk int(11) NOT NULL,
MiserPerk int(11) NOT NULL,
PainPerk int(11) NOT NULL,
TraderPerk int(11) NOT NULL,
Tutorial int(11) NOT NULL,
Mission int(11) NOT NULL,
Warnings int(11) NOT NULL,
VirWorld int(11) NOT NULL,
Fuel float NOT NULL,
Married int(11) NOT NULL,
MarriedTo varchar(255) NOT NULL,
FishTool int(11) NOT NULL,
Note1 int(11) NOT NULL,
Notes int(11) NOT NULL,
Note2 varchar(255) NOT NULL,
Note2s int(11) NOT NULL,
Note3 varchar(255) NOT NULL,
Note3s int(11) NOT NULL,
Note4 varchar(255) NOT NULL,
Note4s int(11) NOT NULL,
Note5 varchar(255) NOT NULL,
Note5s  int(11) NOT NULL,
InvWeapon  int(11) NOT NULL,
InvAmmo  int(11) NOT NULL,
Lighter  int(11) NOT NULL,
Cigarettes  int(11) NOT NULL,
Locked  int(11) NOT NULL,
HouseEntered int(11) NOT NULL
)
