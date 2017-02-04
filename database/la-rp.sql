/*
Navicat MySQL Data Transfer

Source Server         : MySQL
Source Server Version : 50716
Source Host           : localhost:3306
Source Database       : la-rp

Target Server Type    : MYSQL
Target Server Version : 50716
File Encoding         : 65001

Date: 2017-02-04 13:47:40
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `biz`
-- ----------------------------
DROP TABLE IF EXISTS `biz`;
CREATE TABLE `biz` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Owned` int(11) NOT NULL DEFAULT '0',
  `Owner` varchar(255) NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of biz
-- ----------------------------
INSERT INTO `biz` VALUES ('1', '0', 'The State', '~w~Gun Shop 1', 'No-one', '1791.21', '-1164.63', '23.8281', '2170.28', '1618.82', '999.977', '5', '5000000', '0', '0', '1', '1', '100', '500', '100');
INSERT INTO `biz` VALUES ('2', '0', 'The State', '~w~Gun Shop 2', 'No-one', '-2288.07', '-79.3344', '35.3203', '459.679', '-88.6443', '999.555', '5', '5000000', '0', '0', '1', '4', '100', '500', '100');
INSERT INTO `biz` VALUES ('3', '0', 'The State', '~w~Restaurant', 'No-one', '1498.36', '-1583.03', '13.5469', '-794.936', '490.632', '1376.2', '5', '5000000', '50', '325000', '1', '1', '148', '500', '100');
INSERT INTO `biz` VALUES ('4', '0', 'The State', '~w~Police Armoury', 'No-one', '1568.63', '-1690.54', '5.8906', '246.376', '109.246', '1003.22', '5', '5000000', '0', '0', '1', '10', '500', '500', '100');
INSERT INTO `biz` VALUES ('5', '0', 'The State', '~w~City Bank', 'No-one', '1462.4', '-1012.39', '26.8438', '2305.69', '-16.0881', '26.7496', '5', '5000000', '0', '0', '0', '0', '99995', '100000', '1');
INSERT INTO `biz` VALUES ('6', '0', 'The State', '~w~The Welcome Pump bar', 'No-one', '681.531', '-473.627', '16.5363', '-227.028', '1401.23', '27.7656', '5', '250000', '0', '0', '0', '18', '499', '500', '100');

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
-- Table structure for `sbiz`
-- ----------------------------
DROP TABLE IF EXISTS `sbiz`;
CREATE TABLE `sbiz` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Owned` int(11) NOT NULL DEFAULT '0',
  `Owner` varchar(255) NOT NULL,
  `Message` varchar(255) NOT NULL,
  `Extortion` varchar(255) NOT NULL,
  `EntranceX` float NOT NULL,
  `EntranceY` float NOT NULL,
  `EntranceZ` float NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbiz
-- ----------------------------
INSERT INTO `sbiz` VALUES ('1', '0', 'The State', '~w~Bikes renting', 'No-one', '562.405', '-1290', '17.2482', '5', '500000', '5', '95', '0', '0', '47', '100', '99999');
INSERT INTO `sbiz` VALUES ('2', '0', 'The State', '~w~Wang Cars', 'No-one', '1206.09', '-1750.66', '13.5938', '5', '700000', '30', '150', '1', '0', '47', '100', '100');
INSERT INTO `sbiz` VALUES ('3', '0', 'The State', '~w~Phone Company', 'No-one', '1327.85', '-1558.01', '13.5469', '5', '500000', '0', '0', '1', '0', '100', '100', '100');
INSERT INTO `sbiz` VALUES ('4', '0', 'The State', '~w~Gas Company', 'No-one', '-33.7243', '-1127.63', '1.0781', '5', '500000', '1', '8546', '1', '0', '100', '100', '100');
INSERT INTO `sbiz` VALUES ('5', '0', 'The State', '~w~Electricity Company', 'No-one', '-2521.01', '-623.331', '132.769', '5', '700000', '0', '128628', '1', '0', '100', '100', '100');
INSERT INTO `sbiz` VALUES ('6', '0', 'The State', '~w~Pay & Spray', 'No-one', '1636.69', '-1521.82', '13.5987', '5', '750000', '1', '1', '1', '0', '91', '100', '100');
INSERT INTO `sbiz` VALUES ('7', '0', 'The State', '~w~House Upgrade', 'No-one', '2350', '-1411.8', '23.9923', '5', '2000000', '0', '2301500', '1', '0', '55', '100', '100');
INSERT INTO `sbiz` VALUES ('8', '0', 'The State', '~w~CNN Studio', 'No-one', '844.656', '-1045.56', '25.4301', '5', '2000000', '0', '25385', '1', '0', '100', '100', '100');
INSERT INTO `sbiz` VALUES ('9', '1', 'No-one', 'Un Named', 'No-one', '2510.6', '-1468.2', '24.0239', '5', '700000', '0', '250', '1', '0', '97', '100', '100');
INSERT INTO `sbiz` VALUES ('10', '0', 'The State', '~w~General Store', 'No-one', '1205.97', '-1459.67', '13.386', '5', '500000', '0', '369350', '1', '0', '100', '100', '100');
INSERT INTO `sbiz` VALUES ('11', '0', 'The State', '~w~Paintball Arena', 'No-one', '1310.13', '-1367.81', '13.5408', '5', '750000', '0', '0', '0', '0', '98', '100', '100');
INSERT INTO `sbiz` VALUES ('12', '0', 'The State', '~w~Kart Track', 'No-one', '2281.91', '-2364.28', '13.5938', '5', '750000', '0', '0', '1', '0', '94', '100', '100');
INSERT INTO `sbiz` VALUES ('13', '0', 'The State', '~w~Kart Track', 'No-one', '2281.91', '-2364.28', '13.5938', '5', '750000', '0', '0', '1', '0', '100', '100', '100');

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
  `Name` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Level` int(11) DEFAULT '1',
  `AdminLevel` int(11) DEFAULT '0',
  `HelperLevel` int(11) DEFAULT '0',
  `DonateRank` int(11) DEFAULT '0',
  `UpgradePoints` int(11) DEFAULT '0',
  `ConnectedTime` int(11) DEFAULT '0',
  `Registered` int(11) DEFAULT '0',
  `Sex` int(11) DEFAULT '0',
  `Age` int(11) DEFAULT '0',
  `Origin` int(11) DEFAULT '0',
  `CK` int(11) DEFAULT '0',
  `Muted` int(11) DEFAULT '0',
  `Respect` int(11) DEFAULT '0',
  `Money` int(11) DEFAULT '0',
  `Bank` int(11) DEFAULT '0',
  `Crimes` int(11) DEFAULT '0',
  `Kills` int(11) DEFAULT '0',
  `Deaths` int(11) DEFAULT '0',
  `Arrested` int(11) DEFAULT '0',
  `WantedDeaths` int(11) DEFAULT '0',
  `Phonebook` int(11) DEFAULT '0',
  `LottoNr` int(11) DEFAULT '0',
  `Fishes` int(11) DEFAULT '0',
  `BiggestFish` int(11) DEFAULT '0',
  `Job` int(11) DEFAULT '0',
  `Paycheck` int(11) DEFAULT '0',
  `HeadValue` int(11) DEFAULT '0',
  `Jailed` int(11) DEFAULT '0',
  `JailTime` int(11) DEFAULT '0',
  `Materials` int(11) DEFAULT '0',
  `Drugs` int(11) DEFAULT '0',
  `Leader` int(11) DEFAULT '0',
  `Member` int(11) DEFAULT '0',
  `FMember` int(11) DEFAULT '0',
  `Rank` int(11) DEFAULT '0',
  `Char` int(11) DEFAULT '0',
  `ContractTime` int(11) DEFAULT '0',
  `DetSkill` int(11) DEFAULT '0',
  `SexSkill` int(11) DEFAULT '0',
  `BoxSkill` int(11) DEFAULT '0',
  `LawSkill` int(11) DEFAULT '0',
  `MechSkill` int(11) DEFAULT '0',
  `JackSkill` int(11) DEFAULT '0',
  `CarSkill` int(11) DEFAULT '0',
  `NewsSkill` int(11) DEFAULT '0',
  `DrugsSkill` int(11) DEFAULT '0',
  `CookSkill` int(11) DEFAULT '0',
  `FishSkill` int(11) DEFAULT '0',
  `pSHealth` float DEFAULT '0',
  `pHealth` float DEFAULT '100',
  `Int` int(11) DEFAULT '0',
  `Local` int(11) DEFAULT '0',
  `Team` int(11) DEFAULT '0',
  `Model` int(11) DEFAULT '0',
  `PhoneNr` int(11) DEFAULT '0',
  `Car` int(11) DEFAULT '0',
  `Car2` int(11) DEFAULT '0',
  `Car3` int(11) DEFAULT '0',
  `House` int(11) DEFAULT '0',
  `Biz` int(11) DEFAULT '0',
  `Pos_x` float DEFAULT '0',
  `Pos_y` float DEFAULT '0',
  `Pos_z` float DEFAULT '0',
  `CarLic` int(11) DEFAULT '0',
  `FlyLic` int(11) DEFAULT '0',
  `BoatLic` int(11) DEFAULT '0',
  `FishLic` int(11) DEFAULT '0',
  `GunLic` int(11) DEFAULT '0',
  `Gun1` int(11) DEFAULT '0',
  `Gun2` int(11) DEFAULT '0',
  `Gun3` int(11) DEFAULT '0',
  `Gun4` int(11) DEFAULT '0',
  `Ammo1` int(11) DEFAULT '0',
  `Ammo2` int(11) DEFAULT '0',
  `Ammo3` int(11) DEFAULT '0',
  `Ammo4` int(11) DEFAULT '0',
  `CarTime` int(11) DEFAULT '0',
  `PayDay` int(11) DEFAULT '0',
  `PayDayHad` int(11) DEFAULT '0',
  `Watch` int(11) DEFAULT '0',
  `Crashed` int(11) DEFAULT '0',
  `Wins` int(11) DEFAULT '0',
  `Loses` int(11) DEFAULT '0',
  `AlcoholPerk` int(11) DEFAULT '0',
  `DrugPerk` int(11) DEFAULT '0',
  `MiserPerk` int(11) DEFAULT '0',
  `PainPerk` int(11) DEFAULT '0',
  `TraderPerk` int(11) DEFAULT '0',
  `Tutorial` int(11) DEFAULT '0',
  `Mission` int(11) DEFAULT '0',
  `Warnings` int(11) DEFAULT '0',
  `VirWorld` int(11) DEFAULT '0',
  `Fuel` float DEFAULT '0',
  `Married` int(11) DEFAULT '0',
  `MarriedTo` varchar(255) DEFAULT NULL,
  `FishTool` int(11) DEFAULT '0',
  `Note1` varchar(255) DEFAULT NULL,
  `Note1s` int(11) DEFAULT '0',
  `Note2` varchar(255) DEFAULT NULL,
  `Note2s` int(11) DEFAULT '0',
  `Note3` varchar(255) DEFAULT NULL,
  `Note3s` int(11) DEFAULT '0',
  `Note4` varchar(255) DEFAULT NULL,
  `Note4s` int(11) DEFAULT '0',
  `Note5` varchar(255) DEFAULT NULL,
  `Note5s` int(11) DEFAULT '0',
  `InvWeapon` int(11) DEFAULT '0',
  `InvAmmo` int(11) DEFAULT '0',
  `Lighter` int(11) DEFAULT '0',
  `Cigarettes` int(11) DEFAULT '0',
  `Locked` int(11) DEFAULT '0',
  `HouseEntered` int(11) DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
