stock GiveJobReward(playerid, rtype, extramoney = 0)
{
	new money = 0;
	new leveljob = GetLevelJob(playerid, rtype);
	switch (rtype)
	{
		case TRUCK:
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
		case MECHANIC:
		{
			money = 12500 + GetLevelJob(playerid, MECHANIC)*2500;
			SafeGivePlayerMoney(playerid, money, 2, false);
			new str[128];
			format(str, sizeof(str), "Tien luong: %s$", AddCommas(money));
			SCM(playerid, COLOR_YELLOW, str);
			SCM(playerid, COLOR_GREEN, "Tien luong se duoc chuyen vao tai khoan ngan hang.");
		}
		case PIZZA:
		{
			money = 15 + (GetLevelJob(PlayerInfo[playerid][pPizzaSkill], PIZZA) * 2);
			new gia = floatround(money*PizzaDistance[playerid], floatround_round);
			if (gia > 40000) gia = 40000;
			SafeGivePlayerMoney(playerid, gia);
			new str[128];
			format(str, sizeof(str), "Tien luong: %s$", AddCommas(gia));
			SCM(playerid, COLOR_YELLOW, str);
		}
	}
	return 1;
}

stock GetLevelJob(playerid, rtype)
{
	switch (rtype)
	{
		case TRUCK:
		{
			if (PlayerInfo[playerid][pTruckSkill] <= 50) return 1;
			else if (PlayerInfo[playerid][pTruckSkill] <= 100) return 2;
			else if (PlayerInfo[playerid][pTruckSkill] <= 300) return 3;
			else if (PlayerInfo[playerid][pTruckSkill] <= 500) return 4;
			else if (PlayerInfo[playerid][pTruckSkill] <= 1000) return 5;
		}
		case MECHANIC:
		{
			if (PlayerInfo[playerid][pMechSkill] <= 50) return 1;
			else if (PlayerInfo[playerid][pMechSkill] <= 100) return 2;
			else if (PlayerInfo[playerid][pMechSkill] <= 300) return 3;
			else if (PlayerInfo[playerid][pMechSkill] <= 500) return 4;
			else if (PlayerInfo[playerid][pMechSkill] <= 1000) return 5;
		}
		case PIZZA:
		{
			if (PlayerInfo[playerid][pPizzaSkill] <= 50) return 1;
			else if (PlayerInfo[playerid][pPizzaSkill] <= 100) return 2;
			else if (PlayerInfo[playerid][pPizzaSkill] <= 300) return 3;
			else if (PlayerInfo[playerid][pPizzaSkill] <= 500) return 4;
			else if (PlayerInfo[playerid][pPizzaSkill] <= 1000) return 5;
		}
		case PLANT:
		{
			if (PlayerInfo[playerid][pPlantSkill] <= 50) return 1;
			else if (PlayerInfo[playerid][pPlantSkill] <= 100) return 2;
			else if (PlayerInfo[playerid][pPlantSkill] <= 300) return 3;
			else if (PlayerInfo[playerid][pPlantSkill] <= 500) return 4;
			else if (PlayerInfo[playerid][pPlantSkill] <= 1000) return 5;
		}
	}
	return -1;
}

stock UpgradeFamily(fid)
{
	FamilyInfo[fid][fLevel]++;
	FamilyInfo[fid][fMoney] -= FamilyInfo[fid][fLimit][FMONEY];
	FamilyInfo[fid][fDrugs] -= FamilyInfo[fid][fLimit][FDRUGS];
	FamilyInfo[fid][fMats] -= FamilyInfo[fid][fLimit][FMATS];

	FamilyInfo[fid][fLimit][FMONEY] = FamilyInfo[fid][fLimit][FMONEY] * 2;
	FamilyInfo[fid][fLimit][FMATS] = FamilyInfo[fid][fLimit][FMATS] * 2;
	FamilyInfo[fid][fLimit][FDRUGS] = FamilyInfo[fid][fLimit][FDRUGS] * 2;

	FamilyInfo[fid][fLimit][FWEAPONS] = FamilyInfo[fid][fLimit][FWEAPONS] * 2;
	FamilyInfo[fid][fLimit][FVEHICLES] += 1;
	FamilyInfo[fid][fLimit][FMEMBERS] += 5;

	SaveFamilies();
	return 1;
}
stock GetFamilyUpgradeCondition(fid)
{
	new str[128];
	format(str, sizeof(str), "Tien: %s$/%s$ \n", AddCommas(FamilyInfo[fid][fMoney]), AddCommas(FamilyInfo[fid][fLimit][FMONEY]));
	format(str, sizeof(str), "%s Thuoc: %d/%d \n", str, FamilyInfo[fid][fDrugs], FamilyInfo[fid][fLimit][FDRUGS]);
	format(str, sizeof(str), "%s Vat Lieu: %d/%d \n", str, FamilyInfo[fid][fMats], FamilyInfo[fid][fLimit][FMATS]);
	format(str, sizeof(str), "%s Thanh Vien: %d/%d \n", str, CountFamilyMember(fid), FamilyInfo[fid][fLimit][FMEMBERS]);
	format(str, sizeof(str), "%s Xe: %d/%d \n", str, CountFamilyVehicle(fid), FamilyInfo[fid][fLimit][FVEHICLES]);
	format(str, sizeof(str), "%s Vu Khi: %d/%d", str, CountFamilySafeWeapon(fid), FamilyInfo[fid][fLimit][FWEAPONS]);
	return str;
}
stock IsFamilyCanUpgrade(fid)
{
	new money = FamilyInfo[fid][fMoney], drugs = FamilyInfo[fid][fDrugs], mats = FamilyInfo[fid][fMats],
		weapons = CountFamilySafeWeapon(fid), players = CountFamilyMember(fid),
		vehicles = CountFamilyVehicle(fid);

	if (money < FamilyInfo[fid][fLimit][FMONEY]) return 0;
	if (mats < FamilyInfo[fid][fLimit][FMATS]) return 0;
	if (drugs < FamilyInfo[fid][fLimit][FDRUGS]) return 0;
	if (weapons < FamilyInfo[fid][fLimit][FWEAPONS]) return 0;
	if (players < FamilyInfo[fid][fLimit][FMEMBERS]) return 0;
	if (vehicles < FamilyInfo[fid][fLimit][FVEHICLES]) return 0;
	return 1;
}

stock CountFamilyVehicle(fid)
{
	new count = 0;
	foreach(new vid : Vehicle)
	{
		if (IsAFamilyCar(vid))
		{
			new vfid = GetFamilyVehicleLeader(vid);
			if (vfid == fid) count++;
		}
	}
	return count;
}


stock CountFamilyMember(fid)
{
	new sql[50];
	format(sql, sizeof(sql), "SELECT * FROM user WHERE FMember = %d", FamilyInfo[fid][fID]);
	mysql_query(conn, sql);
	new result;
	cache_get_row_count(result);
	return result;
}
