CREATE TABLE biz
(
`ID` int(11) PRIMARY KEY AUTO_INCREMENT,
Owner int(11) NOT NULL,
Message varchar(255)  NOT NULL,
Extortion varchar(255)  NOT NULL,
EntranceX float(11) NOT NULL,
EntranceY float(11) NOT NULL,
EntranceZ float(11) NOT NULL,
ExitX float(11) NOT NULL,
ExitY float(11) NOT NULL,
ExitZ float(11) NOT NULL,
LevelNeeded  int(11) NOT NULL,
BuyPrice int(11) NOT NULL,
EntranceCost int(11) NOT NULL,
Till  int(11) NOT NULL,
Locked int(11) NOT NULL,
Interior int(11) NOT NULL,
Products int(11) NOT NULL,
MaxProducts int(11) NOT NULL,
PriceProd int(11) NOT NULL
)
