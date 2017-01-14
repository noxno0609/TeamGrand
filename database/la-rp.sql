/*
Navicat MySQL Data Transfer

Source Server         : MySQL
Source Server Version : 50716
Source Host           : localhost:3306
Source Database       : la-rp

Target Server Type    : MYSQL
Target Server Version : 50716
File Encoding         : 65001

Date: 2017-01-14 21:49:14
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `biz`
-- ----------------------------
DROP TABLE IF EXISTS `biz`;
CREATE TABLE `biz` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Owner` int(11) NOT NULL,
  `Message` varchar(255) NOT NULL,
  `Extortion` varchar(255) NOT NULL,
  `EntranceX` float NOT NULL,
  `EntranceY` float NOT NULL,
  `EntranceZ` float NOT NULL,
  `ExitX` float NOT NULL,
  `ExitY` float NOT NULL,
  `ExitZ` float NOT NULL,
  `LevelNeeded` int(11) NOT NULL,
  `BuyPrice` int(11) NOT NULL,
  `EntranceCost` int(11) NOT NULL,
  `Till` int(11) NOT NULL,
  `Locked` int(11) NOT NULL,
  `Interior` int(11) NOT NULL,
  `Products` int(11) NOT NULL,
  `MaxProducts` int(11) NOT NULL,
  `PriceProd` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of biz
-- ----------------------------

-- ----------------------------
-- Table structure for `boxer`
-- ----------------------------
DROP TABLE IF EXISTS `boxer`;
CREATE TABLE `boxer` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TitelWins` int(11) NOT NULL,
  `TitelName` varchar(255) NOT NULL,
  `TitelLoses` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of boxer
-- ----------------------------

-- ----------------------------
-- Table structure for `car`
-- ----------------------------
DROP TABLE IF EXISTS `car`;
CREATE TABLE `car` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Model` int(11) NOT NULL,
  `Locationx` float NOT NULL,
  `Locationy` float NOT NULL,
  `Locationz` float NOT NULL,
  `Angle` float NOT NULL,
  `ColorOne` int(11) NOT NULL,
  `ColorTwo` int(11) NOT NULL,
  `Owner` varchar(255) NOT NULL,
  `Description` varchar(255) NOT NULL,
  `Value` int(11) NOT NULL,
  `License` int(11) NOT NULL,
  `cOwned` int(11) NOT NULL,
  `Lock` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of car
-- ----------------------------

-- ----------------------------
-- Table structure for `cartrunk`
-- ----------------------------
DROP TABLE IF EXISTS `cartrunk`;
CREATE TABLE `cartrunk` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `VehID` int(11) NOT NULL,
  `Trunk1` int(11) NOT NULL,
  `TrunkAmmo1` int(11) NOT NULL,
  `Trunk2` int(11) NOT NULL,
  `TrunkAmmo2` int(11) NOT NULL,
  `Trunk3` int(11) NOT NULL,
  `TrunkAmmo3` int(11) NOT NULL,
  `Trunk4` int(11) NOT NULL,
  `TrunkAmmo4` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of cartrunk
-- ----------------------------

-- ----------------------------
-- Table structure for `channel`
-- ----------------------------
DROP TABLE IF EXISTS `channel`;
CREATE TABLE `channel` (
  `Admin` varchar(255) NOT NULL,
  `MOTD` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `NeedPass` int(11) NOT NULL,
  `Lock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of channel
-- ----------------------------

-- ----------------------------
-- Table structure for `ck`
-- ----------------------------
DROP TABLE IF EXISTS `ck`;
CREATE TABLE `ck` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Sendername` varchar(255) NOT NULL,
  `Giveplayer` varchar(255) NOT NULL,
  `Used` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of ck
-- ----------------------------

-- ----------------------------
-- Table structure for `factory`
-- ----------------------------
DROP TABLE IF EXISTS `factory`;
CREATE TABLE `factory` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DrugAmount` int(11) NOT NULL,
  `MatAmount` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of factory
-- ----------------------------

-- ----------------------------
-- Table structure for `family`
-- ----------------------------
DROP TABLE IF EXISTS `family`;
CREATE TABLE `family` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Taken` int(11) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `MOTD` varchar(255) NOT NULL,
  `Color` varchar(255) NOT NULL,
  `Leader` varchar(255) NOT NULL,
  `Members` int(11) NOT NULL,
  `SpawnX` float NOT NULL,
  `SpawnY` float NOT NULL,
  `SpawnZ` float NOT NULL,
  `SpawnAngle` float NOT NULL,
  `Interior` float NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of family
-- ----------------------------

-- ----------------------------
-- Table structure for `house`
-- ----------------------------
DROP TABLE IF EXISTS `house`;
CREATE TABLE `house` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Entrance` float NOT NULL,
  `Entrancey` float NOT NULL,
  `Entrancez` float NOT NULL,
  `Exitx` float NOT NULL,
  `Exity` float NOT NULL,
  `Exitz` float NOT NULL,
  `HealthUpgrade` int(11) NOT NULL,
  `ArmourUpgrade` int(11) NOT NULL,
  `Owner` varchar(30) NOT NULL,
  `Discription` varchar(80) NOT NULL,
  `Value` int(11) NOT NULL,
  `Hel` int(11) NOT NULL,
  `Arm` int(11) NOT NULL,
  `Int` int(11) NOT NULL,
  `Lock` int(11) NOT NULL,
  `Owned` int(11) NOT NULL,
  `Rooms` int(11) NOT NULL,
  `Rent` int(11) NOT NULL,
  `Rentabil` int(11) NOT NULL,
  `Takings` int(11) NOT NULL,
  `Vec` int(11) NOT NULL,
  `Vcol1` int(11) NOT NULL,
  `Vcol2` int(11) NOT NULL,
  `Date` int(11) NOT NULL,
  `Level` int(11) NOT NULL,
  `World` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of house
-- ----------------------------

-- ----------------------------
-- Table structure for `stuff`
-- ----------------------------
DROP TABLE IF EXISTS `stuff`;
CREATE TABLE `stuff` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Jackpot` int(11) NOT NULL,
  `Tax` int(11) NOT NULL,
  `TaxValue` int(11) NOT NULL,
  `Security` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of stuff
-- ----------------------------

-- ----------------------------
-- Table structure for `turf`
-- ----------------------------
DROP TABLE IF EXISTS `turf`;
CREATE TABLE `turf` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Owner` varchar(255) NOT NULL,
  `Color` varchar(255) NOT NULL,
  `MinX` float NOT NULL,
  `MinY` float NOT NULL,
  `MaxX` float NOT NULL,
  `MaxY` float NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of turf
-- ----------------------------

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Password` varchar(255) NOT NULL,
  `Level` int(11) NOT NULL,
  `AdminLevel` int(11) NOT NULL,
  `DonateRank` int(11) NOT NULL,
  `UpgradePoints` int(11) NOT NULL,
  `ConnectedTime` int(11) NOT NULL,
  `Registered` int(11) NOT NULL,
  `Sex` int(11) NOT NULL,
  `Age` int(11) NOT NULL,
  `Origin` int(11) NOT NULL,
  `CK` int(11) NOT NULL,
  `Muted` int(11) NOT NULL,
  `Respect` int(11) NOT NULL,
  `Money` int(11) NOT NULL,
  `Bank` int(11) NOT NULL,
  `Crimes` int(11) NOT NULL,
  `Kills` int(11) NOT NULL,
  `Deaths` int(11) NOT NULL,
  `Arrested` int(11) NOT NULL,
  `WantedDeaths` int(11) NOT NULL,
  `Phonebook` int(11) NOT NULL,
  `LottoNr` int(11) NOT NULL,
  `Fishes` int(11) NOT NULL,
  `BiggestFish` int(11) NOT NULL,
  `Job` int(11) NOT NULL,
  `Paycheck` int(11) NOT NULL,
  `HeadValue` int(11) NOT NULL,
  `Jailed` int(11) NOT NULL,
  `JailTime` int(11) NOT NULL,
  `Materials` int(11) NOT NULL,
  `Drugs` int(11) NOT NULL,
  `Leader` int(11) NOT NULL,
  `Member` int(11) NOT NULL,
  `FMember` int(11) NOT NULL,
  `Rank` int(11) NOT NULL,
  `Char` int(11) NOT NULL,
  `ContractTime` int(11) NOT NULL,
  `DetSkill` int(11) NOT NULL,
  `SexSkill` int(11) NOT NULL,
  `BoxSkill` int(11) NOT NULL,
  `LawSkill` int(11) NOT NULL,
  `MechSkill` int(11) NOT NULL,
  `JackSkill` int(11) NOT NULL,
  `CarSkill` int(11) NOT NULL,
  `NewsSkill` int(11) NOT NULL,
  `DrugsSkill` int(11) NOT NULL,
  `CookSkill` int(11) NOT NULL,
  `FishSkill` int(11) NOT NULL,
  `pSHealth` float NOT NULL,
  `pHealth` float NOT NULL,
  `Int` int(11) NOT NULL,
  `Local` int(11) NOT NULL,
  `Team` int(11) NOT NULL,
  `Model` int(11) NOT NULL,
  `PhoneNr` int(11) NOT NULL,
  `Car` int(11) NOT NULL,
  `Car2` int(11) NOT NULL,
  `Car3` int(11) NOT NULL,
  `House` int(11) NOT NULL,
  `Biz` int(11) NOT NULL,
  `Pos_x` float NOT NULL,
  `Pos_y` float NOT NULL,
  `Pos_z` float NOT NULL,
  `CarLic` int(11) NOT NULL,
  `FlyLic` int(11) NOT NULL,
  `BoatLic` int(11) NOT NULL,
  `FishLic` int(11) NOT NULL,
  `GunLic` int(11) NOT NULL,
  `Gun1` int(11) NOT NULL,
  `Gun2` int(11) NOT NULL,
  `Gun3` int(11) NOT NULL,
  `Gun4` int(11) NOT NULL,
  `Ammo1` int(11) NOT NULL,
  `Ammo2` int(11) NOT NULL,
  `Ammo3` int(11) NOT NULL,
  `Ammo4` int(11) NOT NULL,
  `CarTime` int(11) NOT NULL,
  `PayDay` int(11) NOT NULL,
  `PayDayHad` int(11) NOT NULL,
  `Watch` int(11) NOT NULL,
  `Crashed` int(11) NOT NULL,
  `Wins` int(11) NOT NULL,
  `Loses` int(11) NOT NULL,
  `AlcoholPerk` int(11) NOT NULL,
  `DrugPerk` int(11) NOT NULL,
  `MiserPerk` int(11) NOT NULL,
  `PainPerk` int(11) NOT NULL,
  `TraderPerk` int(11) NOT NULL,
  `Tutorial` int(11) NOT NULL,
  `Mission` int(11) NOT NULL,
  `Warnings` int(11) NOT NULL,
  `VirWorld` int(11) NOT NULL,
  `Fuel` float NOT NULL,
  `Married` int(11) NOT NULL,
  `MarriedTo` varchar(255) NOT NULL,
  `FishTool` int(11) NOT NULL,
  `Note1` int(11) NOT NULL,
  `Notes` int(11) NOT NULL,
  `Note2` varchar(255) NOT NULL,
  `Note2s` int(11) NOT NULL,
  `Note3` varchar(255) NOT NULL,
  `Note3s` int(11) NOT NULL,
  `Note4` varchar(255) NOT NULL,
  `Note4s` int(11) NOT NULL,
  `Note5` varchar(255) NOT NULL,
  `Note5s` int(11) NOT NULL,
  `InvWeapon` int(11) NOT NULL,
  `InvAmmo` int(11) NOT NULL,
  `Lighter` int(11) NOT NULL,
  `Cigarettes` int(11) NOT NULL,
  `Locked` int(11) NOT NULL,
  `HouseEntered` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
