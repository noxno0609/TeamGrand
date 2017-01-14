CREATE TABLE car
(
ID int(11) PRIMARY KEY AUTO_INCREMENT,
Model int(11) NOT NULL,
Locationx float(11) NOT NULL,
Locationy float(11) NOT NULL,
Locationz float(11) NOT NULL,
Angle float(11) NOT NULL,
ColorOne  int(11) NOT NULL,
ColorTwo  int(11) NOT NULL,
Owner varchar(255) NOT NULL,
Description varchar(255) NOT NULL,
Value  int(11) NOT NULL,
License  int(11) NOT NULL,
cOwned  int(11) NOT NULL,
`Lock`  int(11) NOT NULL
)
