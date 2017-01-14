CREATE TABLE family
(
ID int(11) PRIMARY KEY AUTO_INCREMENT,
Taken int(11) NOT NULL,
Name varchar(255) NOT NULL,
MOTD varchar(255) NOT NULL,
Color varchar(255) NOT NULL,
Leader varchar(255) NOT NULL,
Members int(11) NOT NULL,
SpawnX float(11) NOT NULL,
SpawnY float(11) NOT NULL,
SpawnZ float(11) NOT NULL,
SpawnAngle float(11) NOT NULL,
Interior float(11) NOT NULL
)
