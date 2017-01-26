task ServerBeat[1000]()
{
	foreach(Player, playerid)
	{
		if (OnDuty[playerid] == 1 && (PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pLeader] == 1) && WearTazer[playerid] != 1)
		{
			Tazering[playerid] = 0;
			SetPlayerAttachedObject(playerid, 5, 18642, 1, -0.197000, -0.071000, -0.109999, 2.399994, 80.400001, 18.399993, 1.000000, 1.000000, 1.000000, 0, 0);
			WearTazer[playerid] = 1;
		}
		else if (OnDuty[playerid] == 0 && PlayerInfo[playerid][pMember] != 1 && PlayerInfo[playerid][pLeader] != 1 && WearTazer[playerid] == 1)
		{
			Tazering[playerid] = 0;
			RemovePlayerAttachedObject(playerid, 5);
			WearTazer[playerid] = 0;
		}
		if (Tazering[playerid] == 1) SetPlayerArmedWeapon(playerid, 0);

		if (Tazered[playerid] > 0 && --Tazered[playerid] == 0)
		{
			TogglePlayerControllable(playerid, 1);
			ClearAnimations(playerid);
		}
	}
	//printf("Called every second, but not at the same time as RepeatingFunction2.");
}