/*
Navicat MySQL Data Transfer

Source Server         : MySQL
Source Server Version : 50716
Source Host           : localhost:3306
Source Database       : la-rp

Target Server Type    : MYSQL
Target Server Version : 50716
File Encoding         : 65001

Date: 2017-02-04 22:26:16
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
  `Type` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of biz
-- ----------------------------
INSERT INTO `biz` VALUES ('1', '0', 'The State', '~w~City Bank', 'No-one', '1462.4', '-1012.39', '26.8438', '2305.69', '-16.0881', '26.7496', '5', '5000000', '0', '0', '0', '0', '0', '99995', '100000', '0');
INSERT INTO `biz` VALUES ('2', '0', 'The State', '~w~Gun Shop 2', 'No-one', '-2288.07', '-79.3344', '35.3203', '459.679', '-88.6443', '999.555', '5', '5000000', '0', '0', '1', '4', '100', '500', '100', '0');
INSERT INTO `biz` VALUES ('3', '0', 'The State', '~w~Restaurant', 'No-one', '1498.36', '-1583.03', '13.5469', '-794.936', '490.632', '1376.2', '5', '5000000', '50', '0', '1', '1', '148', '500', '100', '0');
INSERT INTO `biz` VALUES ('4', '0', 'The State', '~w~Police Armoury', 'No-one', '1568.63', '-1690.54', '5.8906', '246.376', '109.246', '1003.22', '5', '5000000', '0', '0', '1', '10', '500', '500', '100', '0');
INSERT INTO `biz` VALUES ('5', '0', 'The State', '~w~City Bank', 'No-one', '1462.4', '-1012.39', '26.8438', '2305.69', '-16.0881', '26.7496', '5', '5000000', '0', '0', '0', '0', '99995', '100000', '1', '0');
INSERT INTO `biz` VALUES ('6', '0', 'The State', '~w~The Welcome Pump bar', 'No-one', '681.531', '-473.627', '16.5363', '-227.028', '1401.23', '27.7656', '5', '250000', '0', '0', '0', '18', '499', '500', '100', '0');

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
  `Entrancex` float NOT NULL,
  `Entrancey` float NOT NULL,
  `Entrancez` float NOT NULL,
  `Exitx` float NOT NULL,
  `Exity` float NOT NULL,
  `Exitz` float NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of house
-- ----------------------------
INSERT INTO `house` VALUES ('1', '2457.29', '-1054.42', '59.7422', '1.2', '-3.4', '999.4', 'Ben_X', 'Trailer', '25000', '0', '0', '2', '1', '1', '0', '1', '1', '182', '418', '-1', '-1', '35', '3', '0');
INSERT INTO `house` VALUES ('2', '2066.6', '-1703.5', '14.1', '244.5', '305', '999.1', 'The State', ' Bedsit', '35000', '0', '0', '1', '1', '0', '1', '50', '1', '0', '418', '-1', '-1', '313', '3', '1');
INSERT INTO `house` VALUES ('3', '2129.69', '-1362.1', '25.8058', '267.1', '305', '999.1', 'The State', ' Bedsit', '75000', '0', '0', '2', '1', '0', '1', '2000', '1', '0', '418', '-1', '-1', '219', '3', '2');
INSERT INTO `house` VALUES ('4', '1111.5', '-974.7', '42.7', '301.3', '306.3', '1003.5', 'The State', ' Bedsit', '150000', '0', '0', '4', '1', '0', '1', '2000', '1', '0', '418', '-1', '-1', '219', '3', '3');
INSERT INTO `house` VALUES ('5', '2486.6', '-2020.5', '13.5', '344.3', '305.2', '999.1', 'The State', ' Bedsit', '70000', '0', '0', '6', '1', '0', '0', '500', '1', '0', '418', '-1', '-1', '219', '3', '4');
INSERT INTO `house` VALUES ('6', '2652.8', '-1991.1', '13.5', '446.1', '507.9', '1001.4', 'The State', '2 Room Apartment', '100000', '0', '0', '12', '1', '0', '1', '200', '1', '0', '418', '-1', '-1', '219', '5', '5');
INSERT INTO `house` VALUES ('7', '2389.38', '-1346.24', '25.077', '-42.4', '1408.2', '1084.4', 'The State', '3 Room Bungalow', '150000', '0', '0', '8', '1', '0', '1', '700', '1', '0', '418', '-1', '-1', '219', '5', '6');
INSERT INTO `house` VALUES ('8', '1905.9', '-1113.7', '26.6', '2464.1', '-1698.6', '1013.5', 'The State', '3 Room Bungalow', '200000', '0', '0', '2', '1', '0', '1', '200', '1', '0', '418', '-1', '-1', '219', '5', '7');
INSERT INTO `house` VALUES ('9', '836.3', '-894.3', '68.7', '386.1', '1471.8', '1080.1', 'The State', '3 Room Apartment', '450000', '0', '0', '15', '1', '0', '1', '200', '1', '0', '418', '-1', '-1', '219', '7', '8');
INSERT INTO `house` VALUES ('10', '2142.7', '-1605.5', '14.3', '221.6', '1143.6', '1082.6', 'The State', '3 Room Apartment', '250000', '0', '0', '4', '1', '0', '1', '500', '1', '0', '418', '-1', '-1', '313', '5', '9');
INSERT INTO `house` VALUES ('11', '768.1', '-1696.5', '5.1', '260.6', '1238.8', '1084.2', 'The State', '4 Room Apartment', '350000', '0', '0', '9', '1', '0', '0', '300', '1', '0', '418', '-1', '-1', '219', '7', '10');
INSERT INTO `house` VALUES ('12', '652.1', '-1619.9', '15', '261', '1286', '1080.2', 'The State', '4 Room House', '250000', '0', '0', '4', '1', '0', '0', '280', '1', '59560', '418', '-1', '-1', '219', '6', '11');
INSERT INTO `house` VALUES ('13', '2126.9', '-1320.5', '26.6243', '745.3', '1437.7', '1102.7', 'The State', '4 Room Apartment', '175000', '0', '0', '6', '1', '0', '0', '500', '1', '0', '418', '-1', '-1', '35', '6', '12');
INSERT INTO `house` VALUES ('14', '1981.5', '-1682.81', '17.0537', '376.3', '1417.2', '1081.3', 'The State', '4 Room Apartment', '250000', '0', '0', '15', '1', '0', '0', '500', '1', '27500', '418', '-1', '-1', '219', '7', '13');
INSERT INTO `house` VALUES ('15', '812.7', '-1456.6', '13.7', '27.1', '1341.1', '1084.3', 'The State', '4 Room House', '500000', '0', '0', '10', '1', '0', '0', '250', '1', '0', '418', '-1', '-1', '219', '8', '14');
INSERT INTO `house` VALUES ('16', '2434.9', '-1320.8', '24.8', '2526.4', '-1679', '1015.4', 'The State', '4 Room Bedsit', '125000', '0', '0', '1', '1', '0', '0', '500', '1', '11000', '418', '-1', '-1', '219', '4', '15');
INSERT INTO `house` VALUES ('17', '2847.8', '-1309.6', '14.7', '222.8', '1288.7', '1082.1', 'The State', '4 Room Apartment', '150000', '0', '0', '1', '1', '0', '0', '100', '1', '200', '418', '-1', '-1', '219', '6', '16');
INSERT INTO `house` VALUES ('18', '2486.58', '-1645.08', '14.0772', '23', '1405.6', '1084.4', 'The State', 'Orange Grove', '350000', '0', '0', '5', '1', '0', '0', '1000', '1', '0', '418', '-1', '-1', '219', '7', '17');
INSERT INTO `house` VALUES ('19', '2782.7', '-1306.3', '38.7542', '235.3', '1189.2', '1080.2', 'The State', '4 Room House', '350000', '0', '0', '3', '1', '0', '1', '2500', '1', '60000', '418', '-1', '-1', '219', '7', '18');
INSERT INTO `house` VALUES ('20', '2798', '-1245.77', '47.2113', '447', '1400.3', '1084.3', 'The State', '5 Room Apartment', '500000', '0', '0', '2', '1', '0', '0', '1000', '1', '213000', '418', '-1', '-1', '219', '9', '19');
INSERT INTO `house` VALUES ('21', '1496.9', '-689.1', '95.1', '234.2', '1064.9', '1084.2', 'The State', '5 Room House', '2000000', '0', '0', '6', '1', '0', '0', '1000', '1', '245900', '418', '-1', '-1', '35', '10', '20');
INSERT INTO `house` VALUES ('22', '1243', '-1100.9', '27.9', '327.9', '1478.3', '1084.4', 'The State', '5 Room Slum', '300000', '0', '0', '15', '1', '0', '0', '550', '1', '0', '418', '-1', '-1', '219', '6', '21');
INSERT INTO `house` VALUES ('23', '827.9', '-858.5', '70.3', '295.4', '1473.2', '1080.2', 'The State', '5 Room Apartment', '400000', '0', '0', '15', '1', '0', '0', '500', '1', '0', '418', '-1', '-1', '219', '8', '22');
INSERT INTO `house` VALUES ('24', '979.6', '-676', '121.9', '140.4', '1370.3', '1083.8', 'The State', '6 Room House', '3000000', '0', '0', '5', '1', '0', '0', '800', '1', '0', '418', '-1', '-1', '219', '10', '23');
INSERT INTO `house` VALUES ('25', '1111.5', '-741.9', '100.1', '489.7', '1402.5', '1080.2', 'The State', '6 Room Luxury', '1000000', '0', '0', '2', '1', '0', '0', '2', '0', '0', '418', '-1', '-1', '219', '2', '24');
INSERT INTO `house` VALUES ('26', '251.6', '-1220.9', '75.8', '83.3', '1324.7', '1083.8', 'The State', '6 Room House', '3000000', '0', '0', '9', '1', '0', '0', '474', '1', '0', '418', '-1', '-1', '219', '11', '25');
INSERT INTO `house` VALUES ('27', '1468.4', '-903.7', '54.8', '231.4', '1114.1', '1080.9', 'The State', '7 Room Luxury', '2000000', '0', '0', '5', '1', '0', '0', '850', '1', '6800', '418', '-1', '-1', '35', '9', '26');
INSERT INTO `house` VALUES ('28', '1421.8', '-884.6', '50.6', '225.6', '1023.5', '1084', 'The State', '8 Room Luxury', '2000000', '0', '0', '7', '1', '0', '0', '700', '1', '0', '418', '-1', '-1', '219', '9', '27');
INSERT INTO `house` VALUES ('29', '2147.34', '-1808.41', '16.1406', '-285.9', '1470.8', '1084.3', 'The State', 'Motel Complex', '1000000', '0', '0', '15', '1', '0', '0', '10000', '0', '0', '418', '-1', '-1', '23', '8', '28');
INSERT INTO `house` VALUES ('30', '300.232', '-1154.44', '81.3907', '-262.7', '1456.6', '1084.3', 'The State', 'Richman Mansion', '3000000', '0', '0', '4', '1', '0', '0', '1000', '1', '0', '418', '-1', '-1', '219', '10', '29');
INSERT INTO `house` VALUES ('31', '937.644', '-848.018', '93.6811', '-68.8', '1354.7', '1080.2', 'The State', 'Mulholland Heights', '250000', '0', '0', '6', '1', '0', '0', '1000', '0', '0', '418', '-1', '-1', '219', '6', '30');
INSERT INTO `house` VALUES ('32', '700.338', '-1060.16', '49.4217', '2254.3', '-1140', '1050.6', 'The State', '2 Room Luxury', '800000', '0', '0', '9', '1', '0', '0', '1000', '1', '0', '418', '-1', '-1', '219', '7', '31');
INSERT INTO `house` VALUES ('33', '1378.67', '-1753.24', '14.1406', '2261.3', '-1135.9', '1050.6', 'The State', '3 Room Luxury', '750000', '0', '0', '10', '1', '0', '0', '800', '1', '1600', '418', '-1', '-1', '35', '7', '32');
INSERT INTO `house` VALUES ('34', '219.416', '-1250.35', '78.3345', '2324.4', '-1147.5', '1050.7', 'The State', '8 Room Luxury', '3000000', '0', '0', '12', '1', '0', '0', '99999', '1', '502295', '418', '-1', '-1', '26', '11', '33');
INSERT INTO `house` VALUES ('35', '0', '-1250.35', '78.3345', '2324.4', '-1147.5', '1050.7', 'The State', '8 Room Luxury', '3000000', '0', '0', '12', '1', '0', '0', '900', '1', '0', '418', '-1', '-1', '219', '11', '34');
INSERT INTO `house` VALUES ('36', '0', '-1250.35', '78.3345', '2324.4', '-1147.5', '1050.7', 'The State', '8 Room Luxury', '3000000', '0', '0', '12', '1', '0', '0', '900', '1', '0', '418', '-1', '-1', '219', '11', '35');

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
  `Type` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbiz
-- ----------------------------
INSERT INTO `sbiz` VALUES ('1', '0', 'The State', '~w~Bikes renting', 'No-one', '562.405', '-1290', '17.2482', '5', '500000', '5', '95', '0', '0', '47', '100', '99999', '0');
INSERT INTO `sbiz` VALUES ('2', '0', 'The State', '~w~Wang Cars', 'No-one', '1206.09', '-1750.66', '13.5938', '5', '700000', '30', '0', '1', '0', '47', '100', '100', '0');
INSERT INTO `sbiz` VALUES ('3', '0', 'The State', '~w~Phone Company', 'No-one', '1327.85', '-1558.01', '13.5469', '5', '500000', '0', '0', '1', '0', '100', '100', '100', '0');
INSERT INTO `sbiz` VALUES ('4', '0', 'The State', '~w~Gas Company', 'No-one', '-33.7243', '-1127.63', '1.0781', '5', '500000', '1', '8546', '1', '0', '100', '100', '100', '0');
INSERT INTO `sbiz` VALUES ('5', '0', 'The State', '~w~Electricity Company', 'No-one', '-2521.01', '-623.331', '132.769', '5', '700000', '0', '128628', '1', '0', '99', '100', '100', '0');
INSERT INTO `sbiz` VALUES ('6', '0', 'The State', '~w~Pay & Spray', 'No-one', '1636.69', '-1521.82', '13.5987', '5', '750000', '1', '1', '1', '0', '91', '100', '100', '0');
INSERT INTO `sbiz` VALUES ('7', '0', 'The State', '~w~House Upgrade', 'No-one', '2350', '-1411.8', '23.9923', '5', '2000000', '0', '2301500', '1', '0', '55', '100', '100', '0');
INSERT INTO `sbiz` VALUES ('8', '0', 'The State', '~w~CNN Studio', 'No-one', '844.656', '-1045.56', '25.4301', '5', '2000000', '0', '25385', '1', '0', '100', '100', '100', '0');
INSERT INTO `sbiz` VALUES ('9', '1', 'The State', 'Un Named', 'No-one', '2510.6', '-1468.2', '24.0239', '5', '700000', '0', '250', '1', '0', '97', '100', '100', '0');
INSERT INTO `sbiz` VALUES ('10', '0', 'The State', '~w~General Store', 'No-one', '1205.97', '-1459.67', '13.386', '5', '500000', '0', '369350', '1', '0', '100', '100', '100', '0');
INSERT INTO `sbiz` VALUES ('11', '0', 'The State', '~w~Paintball Arena', 'No-one', '1310.13', '-1367.81', '13.5408', '5', '750000', '0', '0', '0', '0', '98', '100', '100', '0');
INSERT INTO `sbiz` VALUES ('12', '0', 'The State', '~w~Kart Track', 'No-one', '2281.91', '-2364.28', '13.5938', '5', '750000', '0', '0', '1', '0', '94', '100', '100', '0');

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
  `PlantSkill` int(11) DEFAULT '0',
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
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'Nick_Deptrai', '0938699420', '1', '1337', '0', '0', '0', '0', '1', '1', '18', '3', '0', '0', '0', '200', '0', '0', '0', '3', '0', '0', '0', '0', '0', '0', '0', '859', '0', '0', '0', '0', '0', '0', '0', '255', '0', '18', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '25', '0', '255', '3', '7', '164523', '999', '999', '999', '255', '255', '-413.265', '-1759.65', '5.85804', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', 'NULL', '0', 'NNNNNULL', '0', 'NNNNULL', '0', 'NNNULL', '0', 'NNULL', '0', 'NULL', '0', '0', '0', '0');
INSERT INTO `user` VALUES ('2', 'Ben_X', '0907861687', '500', '1337', '0', '0', '0', '0', '1', '1', '4', '3', '0', '0', '0', '29875300', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '12373', '0', '0', '0', '0', '0', '0', '0', '255', '0', '5', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '45', '0', '255', '3', '5', '476107', '999', '999', '999', '1', '255', '2532.61', '-1066.37', '73.2049', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '3', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', 'NULL', '0', 'NNNNNULL', '0', 'NNNNULL', '0', 'NNNULL', '0', 'NNULL', '0', 'NULL', '0', '0', '0', '0');
INSERT INTO `user` VALUES ('3', 'Andy_Tools', '123123', '8', '1337', '0', '0', '0', '0', '1', '1', '19', '1', '0', '0', '0', '1824990', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '748', '0', '0', '0', '0', '0', '0', '0', '255', '0', '12', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '50', '0', '255', '3', '12', '159098', '999', '999', '999', '13', '255', '1919.07', '-1523.47', '51.8278', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', 'NULL', '0', 'NNNNNULL', '0', 'NNNNULL', '0', 'NNNULL', '0', 'NNULL', '0', 'NULL', '0', '0', '0', '0');
INSERT INTO `user` VALUES ('4', 'Teddy_Boy', '123', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '100', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1612.32', '-2330.17', '13.5469', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', null, '0', null, '0', null, '0', null, '0', null, '0', null, '0', '0', '0', '0');
