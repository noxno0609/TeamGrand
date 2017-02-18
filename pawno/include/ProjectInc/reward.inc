stock GiveJobReward(playerid, rtype, extramoney = 0)
{
	new money = 0;
	new leveljob = GetLevelJob(playerid, rtype);
	switch (rtype)
	{
		case TRUCKREWARD:
		{
			money = 3000;
			SafeGivePlayerMoney(playerid, money*leveljob+extramoney+10000);
			new str[128];
			new weapon = 0, ammo = 1, weaponname[25];
			switch (leveljob)
			{
				case 1: { weapon = 8; ammo = 1; }
				case 2: { weapon = 22; ammo = 99999; }
				case 3: { weapon = 25; ammo = 99999; }
				case 4: { weapon = 29; ammo = 99999; }
				case 5: { weapon = 30; ammo = 99999; }
			}
			GetWeaponName(weapon, weaponname, sizeof(weaponname));
			format(str, sizeof(str), "Tra tien coc: 10,000$ | Tien luong: %s$ | Tien ban hang: %s$ | Thuong vu khi: %s", AddCommas(money), AddCommas(extramoney), weaponname);
			SafeGivePlayerWeapon(playerid, weapon, ammo);
			SCM(playerid, COLOR_YELLOW, str);
		}
	}
	return 1;
}

stock GetLevelJob(playerid, rtype)
{
	switch (rtype)
	{
		case TRUCKREWARD:
		{
			if (PlayerInfo[playerid][pTruckSkill] <= 50) return 1;
			else if (PlayerInfo[playerid][pTruckSkill] <= 100) return 2;
			else if (PlayerInfo[playerid][pTruckSkill] <= 300) return 3;
			else if (PlayerInfo[playerid][pTruckSkill] <= 500) return 4;
			else if (PlayerInfo[playerid][pTruckSkill] <= 1000) return 5;
		}
	}
	return -1;
}