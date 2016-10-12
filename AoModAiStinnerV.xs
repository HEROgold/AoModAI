//File: StinnerV.xs


// This applies to Titan only, with some exceptions like PullBack etc.

extern int gTitanTradeCarts = 14;         // Max trade carts for Titan (+5)

extern int mGoldBeforeTrade = 6500;       //Excess gold to other resources, (All modes).

extern bool HardFocus = false;    // Please set this to true if you want the AI to focus the player with most units.

extern bool DisallowPullBack = false;  // set true to make the AI no longer retreat(All modes).
// TC stuff

extern int ModdedTCTimer = 25;
extern bool AllyTcLimit = false; // This enables the modified rule and disables the original one.
 


// RULES

// These will get automatically activated if on Titan mode.

//==============================================================================
// RULE DONATEMassiveFood
//==============================================================================
rule DONATEMASSFood
   minInterval 15
   maxInterval 40
   inactive
   group MassDonations
{
if ((aiGetGameMode() != cGameModeConquest && aiGetGameMode() != cGameModeSupremacy) || (aiGetWorldDifficulty() < cDifficultyNightmare))
  {
        xsDisableSelf();
        return;    
    }
   for (i = aiRandInt(12); <= cNumberPlayers)
   {
           if (i == cMyID)
         continue;
      
	       float foodSupply = kbResourceGet(cResourceFood);
	  	   if(kbIsPlayerAlly(i) == true && kbIsPlayerResigned(i) == false && kbHasPlayerLost(i) == false && foodSupply > 5000)
		   {
		             if (ShowAiEcho == true) aiEcho("Tributing 1000 food to one of my allies!");
	  aiTribute(i, cResourceFood, 1000);
	  }  	
 }
 }
 
 //==============================================================================
// RULE DONATEMassiveWood
//==============================================================================
rule DONATEMASSWood
   minInterval 15
   maxInterval 40
   inactive
   group MassDonations
{
if ((aiGetGameMode() != cGameModeConquest && aiGetGameMode() != cGameModeSupremacy) || (aiGetWorldDifficulty() < cDifficultyNightmare))
  {
        xsDisableSelf();
        return;    
    }
   for (i = aiRandInt(12); <= cNumberPlayers)
   {
           if (i == cMyID)
         continue;
      
	       float woodSupply = kbResourceGet(cResourceWood);
	  	   if(kbIsPlayerAlly(i) == true && kbIsPlayerResigned(i) == false && kbHasPlayerLost(i) == false && woodSupply > 3500)
		   {
		             if (ShowAiEcho == true) aiEcho("Tributing 750 wood to one of my allies!");
	  aiTribute(i, cResourceWood, 750);
	  return;
	  }  	
 }
 }
 
 //==============================================================================
// RULE DONATEMassiveGold
//==============================================================================
rule DONATEMASSGold
   minInterval 15
   maxInterval 40
   inactive
   group MassDonations
{
if ((aiGetGameMode() != cGameModeConquest && aiGetGameMode() != cGameModeSupremacy) || (aiGetWorldDifficulty() < cDifficultyNightmare))
  {
        xsDisableSelf();
        return;    
    }
   for (i = aiRandInt(12); <= cNumberPlayers)
   {
           if (i == cMyID)
         continue;
      
	       float goldSupply = kbResourceGet(cResourceGold);
	  	   if(kbIsPlayerAlly(i) == true && kbIsPlayerResigned(i) == false && kbHasPlayerLost(i) == false && goldSupply > 5000)
		   {
		             if (ShowAiEcho == true) aiEcho("Tributing 1000 gold to one of my allies!");
	  aiTribute(i, cResourceGold, 1000);
	  return;
	  }  	
 }
 }


 
/*     // DISABLED,  in order to enable all this: remove this line with SLASH STAR, and the one at the very bottom of this document as well. 
 
//==============================================================================
rule MBSecondaryWall
//    minInterval 21 //starts in cAge2
    minInterval 30 //starts in cAge4
    inactive
{
   if (aiGetWorldDifficulty() < cDifficultyNightmare)
  {
    xsDisableSelf();
	if (ShowAiEcho == true) aiEcho("I will not build a secondary MB wall on Hard or lower.");
	return; // Disable and go back.
  }  
   
   // Go back if we're not in Mythic Age
    if (kbGetAge() < cAge4)
	 return;    



	//If we're in Mythic age, we want to ensure that we can spare some gold before building this mess of a wall.

	float goldSupply = kbResourceGet(cResourceGold);

    //Make sure we have enough gold
	if (goldSupply < 350)
	   return;   
	
	if (ShowAiEcho == true) aiEcho("Secondary Wall plan launched");

    static bool alreadyStarted = false;
    int numHeroes = kbUnitCount(cMyID, cUnitTypeHero, cUnitStateAlive);
    if ((alreadyStarted == false) && (numHeroes < 1) && (xsGetTime() < 6.5*60*1000))
        return;
    

    //If we already have a build wall plan, don't make another one.
    int wallPlanID = aiPlanGetIDByTypeAndVariableType(cPlanBuildWall, cBuildWallPlanWallType, cBuildWallPlanWallTypeArea, true);
    int activeWallPlans = aiPlanGetNumber(cPlanBuildWall, -1, true);

    int mainBaseID=kbBaseGetMainID(cMyID);
    vector mainBaseLocation = kbBaseGetLocation(cMyID, mainBaseID);
	
    if (wallPlanID >= 0)
    {
        for (i = 0; < activeWallPlans)
        {
            int wallPlanIndexID = aiPlanGetIDByIndex(cPlanBuildWall, -1, true, i);
            if (wallPlanIndexID == gMBSecondaryWall)
            {
                static int SecondaryMainBaseWallStartTime = -1;
                if (SecondaryMainBaseWallStartTime < 0)
                    SecondaryMainBaseWallStartTime = xsGetTime();
                
                if ((goldSupply < 50) && (xsGetTime() > 19*60*1000))
                {
                    aiPlanDestroy(wallPlanIndexID);
                    SecondaryMainBaseWallStartTime = -1;
                    xsSetRuleMinIntervalSelf(23);
                    return;
                }
                
                //destroy the plan if it has been active for more than 12 minutes
                if (xsGetTime() > (SecondaryMainBaseWallStartTime + 12*60*1000))
                {
                    aiPlanDestroy(wallPlanIndexID);
                    SecondaryMainBaseWallStartTime = -1;
                    xsSetRuleMinIntervalSelf(61);
                    return;
                }

                //Get the enemies near my base
                int numEnemyUnitsNearBase = getNumUnits(cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive, -1, cPlayerRelationEnemy, mainBaseLocation, gSecondaryMainBaseAreaWallRadius);
				int myUnitsNearBase = getNumUnits(cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive, cMyID, cPlayerRelationSelf, mainBaseLocation, gSecondaryMainBaseAreaWallRadius);  
                int alliedUnitsNearBase = getNumUnits(cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive, cMyID, cPlayerRelationAlly, mainBaseLocation, gSecondaryMainBaseAreaWallRadius); 

                //Get the time under attack.
                int secondsUnderAttack = kbBaseGetTimeUnderAttack(cMyID, mainBaseID);
                if ((secondsUnderAttack > 25) && (xsGetTime() > 19*60*1000))
                {
                    //Destroy the plan if there are twice as many enemies as my units 
                    if ((numEnemyUnitsNearBase > 2 * (myUnitsNearBase + alliedUnitsNearBase)) && (numEnemyUnitsNearBase > 4))
                    {
                        aiPlanDestroy(wallPlanIndexID);
                        SecondaryMainBaseWallStartTime = -1;
                        xsSetRuleMinIntervalSelf(61);
                        return;
                    }
                }

                return;
            }
        }
    }
    
    if (alreadyStarted == false)
    {
        if (goldSupply < 100)
            return;
    }
    else
    {
        if (goldSupply < 150)
            return;
    }
    

    int builderType = cUnitTypeAbstractVillager;
    if (cMyCulture == cCultureNorse)
        builderType = cUnitTypeAbstractInfantry;
    
    int mainBaseAreaWallTeam1PlanID = aiPlanCreate("mainBaseAreaWallTeam1PlanID", cPlanBuildWall);
    if (mainBaseAreaWallTeam1PlanID != -1)
    {

        
        aiPlanSetNumberVariableValues(mainBaseAreaWallTeam1PlanID, cBuildWallPlanAreaIDs, 20, true);
        int numAreasAdded = 0;

        int mainArea = -1;
        vector mainCenter = kbBaseGetLocation(cMyID, mainBaseID);
        aiPlanSetInitialPosition(mainBaseAreaWallTeam1PlanID, mainCenter);
        
        float mainX = xsVectorGetX(mainCenter);
        float mainZ = xsVectorGetZ(mainCenter);
        mainArea = kbAreaGetIDByPosition(mainCenter);
        aiPlanSetVariableInt(mainBaseAreaWallTeam1PlanID, cBuildWallPlanAreaIDs, numAreasAdded, mainArea);
        numAreasAdded = numAreasAdded + 1;
        
        static bool firstRun = true;
        static int savedBackAreaID = -1;
        
        if (gResetWallPlans == true)
        {
            firstRun = true;
            gBackAreaLocation = cInvalidVector;
            gHouseAreaLocation = cInvalidVector;
            gBackAreaID = -1;
            gHouseAreaID = -1;
            gResetWallPlans = false;
            savedBackAreaID = -1;
        }
        
        if (firstRun == true)
        {
            //always include the backArea
            if (equal(gBackAreaLocation, cInvalidVector) == true)
            {
                vector backVector = kbBaseGetBackVector(cMyID, kbBaseGetMainID(cMyID));
                float bx = xsVectorGetX(backVector);
                float origbx = bx;
                float bz = xsVectorGetZ(backVector);
                float origbz = bz;
                bx = bx * 20.0;
                bz = bz * 20.0;

                for (m = 0; < 5)
                {
                    backVector = xsVectorSetX(backVector, bx);
                    backVector = xsVectorSetZ(backVector, bz);
                    backVector = xsVectorSetY(backVector, 0.0);

                    int areaGroup1 = kbAreaGroupGetIDByPosition(mainCenter);   // base area group
                    gBackAreaLocation = mainCenter + backVector;
                    int areaGroup2 = kbAreaGroupGetIDByPosition(gBackAreaLocation);   // back vector area group
                    if (areaGroup1 == areaGroup2)
                    {
                        gBackAreaID = kbAreaGetIDByPosition(gBackAreaLocation);
                        if ((gBackAreaID == mainArea) || (gBackAreaID == savedBackAreaID))
                        {
                            if (m < 4)
                            {
                                bx = bx * 1.1;
                                bz = bz * 1.1;
                                continue;
                            }
                            else
                            {
                                if (savedBackAreaID != -1)
                                {
                                    gBackAreaID = savedBackAreaID;
                                    break;
                                }
                                else
                                {
                                    gBackAreaID = -1;   //only add it if it's not the mainArea
                                    break;
                                }
                            }
                        }
                        else if (gBackAreaID == -1)
                        {
                            if (savedBackAreaID != -1)
                            {
                                gBackAreaID = savedBackAreaID;
                                break;
                            }
                            else
                            {
                                break;
                            }
                        }
                        else
                        {
                            if (kbAreaGetType(gBackAreaID) == cAreaTypeGold)
                            {
                                savedBackAreaID = gBackAreaID;
                                continue;
                            }
                            else
                            {
                                break;
                            }
                        }
                    }
                    else
                    {
                        break;
                    }
                }
            }
            
            //always include the houseArea
            if (equal(gHouseAreaLocation, cInvalidVector) == true)
            {
                bx = origbx * 30.0;
                bz = origbz * 30.0;

                for (n = 0; < 5)
                {
                    backVector = xsVectorSetX(backVector, bx);
                    backVector = xsVectorSetZ(backVector, bz);
                    backVector = xsVectorSetY(backVector, 0.0);

                    areaGroup1 = kbAreaGroupGetIDByPosition(mainCenter);   // base area group
                    gHouseAreaLocation = mainCenter + backVector;
                    areaGroup2 = kbAreaGroupGetIDByPosition(gHouseAreaLocation);   // house vector area group
                    if (areaGroup1 == areaGroup2)
                    {
                        gHouseAreaID = kbAreaGetIDByPosition(gHouseAreaLocation);
                        if ((gHouseAreaID == mainArea) || (gHouseAreaID == gBackAreaID))
                        {
                            if (n < 4)
                            {
                                bx = bx * 1.1;
                                bz = bz * 1.1;
                                continue;
                            }
                            else
                            {
                                gHouseAreaID = -1;   //only add it if it's not the mainArea or the gBackAreaID
                                break;
                            }
                        }
                        else if (gHouseAreaID == -1)
                        {
                            break;
                        }
                        else
                        {
                            break;
                        }
                    }
                    else
                    {
                        break;
                    }
                }
            }
            xsEnableRule("mainBaseAreaWallTeam2");
            firstRun = false;
        }

        
        int firstRingCount = -1;      // How many areas are in first ring around main?
        int firstRingIndex = -1;      // Which one are we on?
        int secondRingCount = -1;     // How many border areas does the current first ring area have?
        int secondRingIndex = -1;  
        int firstRingID = -1;         // Actual ID of current 1st ring area
        int secondRingID = -1;
        vector areaCenter = cInvalidVector;    // Center point of this area
        float areaX = 0.0;
        float dx = 0.0;
        float areaZ = 0.0;
        float dz = 0.0;
        int areaType = -1;
        bool needToSave = false;

        firstRingCount = kbAreaGetNumberBorderAreas(mainArea);
 
        for (firstRingIndex = 0; < firstRingCount)      // Check each border area of the main area
        {
            needToSave = true;            // We'll save this unless we have a problem
            firstRingID = kbAreaGetBorderAreaID(mainArea, firstRingIndex);
            if (firstRingID == -1)
                continue;
                
            areaCenter = kbAreaGetCenter(firstRingID);
            
            // Now, do the checks.
            areaX = xsVectorGetX(areaCenter);
            areaZ = xsVectorGetZ(areaCenter);
            dx = mainX - areaX;
            dz = mainZ - areaZ;
            if ((dx > gSecondaryMainBaseAreaWallRadius) || (dx < -1.0 * gSecondaryMainBaseAreaWallRadius)
             || (dz > gSecondaryMainBaseAreaWallRadius) || (dz < -1.0 * gSecondaryMainBaseAreaWallRadius))
            {
                needToSave = false;
            }
            
            areaType = kbAreaGetType(firstRingID);
            //increase the radius if it's a forest area
            if (areaType == cAreaTypeForest)
            {
                if ((dx > gSecondaryMainBaseAreaWallRadius * 1.2) || (dx < -1.0 * gSecondaryMainBaseAreaWallRadius * 1.2)
                 || (dz > gSecondaryMainBaseAreaWallRadius * 1.2) || (dz < -1.0 * gSecondaryMainBaseAreaWallRadius * 1.2))
                {
                    needToSave = false;
                }
                else
                {
                    needToSave = true;
                }
            }
            // Override if it's a special type
            else if (areaType == cAreaTypeGold)
            {
                needToSave = true;
            }
            else if (areaType == cAreaTypeSettlement)
            {
                needToSave = true;
            }
            else
            {
                // Override if it's the gBackAreaID or the gHouseAreaID
                if (gBackAreaID == firstRingID)
                {
                    needToSave = true;
                }
                else if (gHouseAreaID == firstRingID)
                {
                    needToSave = true;
                }
            }

            // Now, if we need to save it, zip through the list of saved areas and make sure it isn't there, then add it.
            if (needToSave == true)
            {
                bool found = false;
                for (j = 0; < numAreasAdded)
                {
                    if (aiPlanGetVariableInt(mainBaseAreaWallTeam1PlanID, cBuildWallPlanAreaIDs, j) == firstRingID)
                    {
                        found = true;     // It's in there, don't add it
                    }
                }
                if ((found == false) && (numAreasAdded < 20))  // add it
                {
                    aiPlanSetVariableInt(mainBaseAreaWallTeam1PlanID, cBuildWallPlanAreaIDs, numAreasAdded, firstRingID);
                    numAreasAdded = numAreasAdded + 1;
                    
                    // If we had to add it, check all its surrounding areas, too...if it turns out we need to.
                    secondRingCount = kbAreaGetNumberBorderAreas(firstRingID);     // How many does it touch?
                    for (secondRingIndex = 0; < secondRingCount)
                    {     
                        // Check each border area.  If it's gold or settlement and not already in list, add it.
                        secondRingID = kbAreaGetBorderAreaID(firstRingID, secondRingIndex);
                        if (secondRingID == -1)
                            continue;
                        
                        areaType = kbAreaGetType(secondRingID);
                        if ((areaType == cAreaTypeSettlement) || (areaType == cAreaTypeGold) || (areaType == cAreaTypeForest) || ((gHouseAreaID == secondRingID) && (gHouseAreaID != -1)))
                        {
                            bool skipme = false;       // Skip it if center is outside gSecondaryMainBaseAreaWallRadius * 1.4
                            areaX = xsVectorGetX(kbAreaGetCenter(secondRingID));
                            areaZ = xsVectorGetZ(kbAreaGetCenter(secondRingID));
                            dx = mainX - areaX;
                            dz = mainZ - areaZ;
                            
                            if (areaType == cAreaTypeForest)
                            {
                                if ((dx > gSecondaryMainBaseAreaWallRadius * 1.2) || (dx < -1.0 * gSecondaryMainBaseAreaWallRadius * 1.2)
                                 || (dz > gSecondaryMainBaseAreaWallRadius * 1.2) || (dz < -1.0 * gSecondaryMainBaseAreaWallRadius * 1.2))
                                {
                                    skipme = true;
                                }
                            }
                            else
                            {
                                if ((dx > gSecondaryMainBaseAreaWallRadius * 1.4) || (dx < -1.0 * gSecondaryMainBaseAreaWallRadius * 1.4)
                                 || (dz > gSecondaryMainBaseAreaWallRadius * 1.4) || (dz < -1.0 * gSecondaryMainBaseAreaWallRadius * 1.4))
                                {
                                    skipme = true;
                                }
                            }
                            
                            // add it if it's the gHouseAreaID and not already added
                            if (gHouseAreaID == secondRingID)
                            {
                                skipme = false;
                            }
                            
                            bool alreadyIn = false;

                            for (k = 0; < numAreasAdded)
                            {
                                if (aiPlanGetVariableInt(mainBaseAreaWallTeam1PlanID, cBuildWallPlanAreaIDs, k) == secondRingID)
                                {
                                    alreadyIn = true;     // It's in there, don't add it
                                }
                            }
                            
                            if ((alreadyIn == false) && (skipme == false) && (numAreasAdded < 20))  // add it
                            {
                                aiPlanSetVariableInt(mainBaseAreaWallTeam1PlanID, cBuildWallPlanAreaIDs, numAreasAdded, secondRingID);
                                numAreasAdded = numAreasAdded + 1;
                            }
                        }
                    }
                }
            }
        }

        // Set the true number of area variables, preserving existing values, then turn on the plan
        aiPlanSetNumberVariableValues(mainBaseAreaWallTeam1PlanID, cBuildWallPlanAreaIDs, numAreasAdded, false);

        aiPlanSetVariableInt(mainBaseAreaWallTeam1PlanID, cBuildWallPlanWallType, 0, cBuildWallPlanWallTypeArea);
        aiPlanAddUnitType(mainBaseAreaWallTeam1PlanID, builderType, 1, 1, 1);
        aiPlanSetVariableInt(mainBaseAreaWallTeam1PlanID, cBuildWallPlanNumberOfGates, 0, 50);
        aiPlanSetVariableFloat(mainBaseAreaWallTeam1PlanID, cBuildWallPlanEdgeOfMapBuffer, 0, 12.0);
        aiPlanSetBaseID(mainBaseAreaWallTeam1PlanID, mainBaseID);
        aiPlanSetEscrowID(mainBaseAreaWallTeam1PlanID, cMilitaryEscrowID);
        aiPlanSetDesiredPriority(mainBaseAreaWallTeam1PlanID, 100);
        aiPlanSetActive(mainBaseAreaWallTeam1PlanID, true);
        gMainBaseAreaWallTeam1PlanID = mainBaseAreaWallTeam1PlanID;
        xsSetRuleMinIntervalSelf(127);
        if (alreadyStarted == false)
            alreadyStarted = true;
    }
} 
 
 
// MODDED BUILD SETTLEMENTS
//==============================================================================
rule ModifiedbuildSettlements
    minInterval 15 //starts in cAge3
    inactive
{
    	if (xsGetTime() > ModdedTCTimer*60*1000)
        {
            AllyTcLimit = false;
			xsEnableRule("buildSettlements");
			xsDisableSelf();
            return;
        }
		
    if (ShowAiEcho == true) aiEcho("buildSettlements:");

    //Figure out if we have any active BuildSettlements.
    int numberBuildSettlementGoals=aiGoalGetNumber(cGoalPlanGoalTypeBuildSettlement, cPlanStateWorking, true);
    int numberSettlements = getNumUnits(cUnitTypeAbstractSettlement, cUnitStateAlive, -1, cMyID);

    int numberSettlementsPlanned = numberSettlements + numberBuildSettlementGoals;

    if (numberSettlementsPlanned >= cvMaxSettlements)
        return;        // Don't go over script limit

    if (numberBuildSettlementGoals > 1)	// Allow 2 in progress, no more
        return;
    if (findASettlement() == false)
        return;
    if (numberSettlements > 1)  // Test for all the normal reasons to not build a settlement, unless we have only one
    {
        int popCapBuffer = 50;
        if (numberSettlements == 3)
            popCapBuffer = 30;
        else if (numberSettlements == 4)
            popCapBuffer = 20;
        else if (numberSettlements > 4)
            popCapBuffer = 10;
        popCapBuffer = popCapBuffer + ((-1*cvRushBoomSlider)+1)*5 + 5;  // Add 5 for extreme rush, 15 for extreme boom
        int currentPopNeeds=kbGetPop();
        int adjustedPopCap=getSoftPopCap()-popCapBuffer;

        //Don't do this unless we need the pop
        if (currentPopNeeds < adjustedPopCap)
            return;
      

        //If we're on Easy and we have 3 settlements, go away.
        if ((aiGetWorldDifficulty() == cDifficultyEasy) && (numberSettlementsPlanned >= 3))
        {
            xsDisableSelf();
            return;
        }
    }


    //Don't get too many more than our human allies.
    int largestAllyCount=-1;
    for (i=1; < cNumberPlayers)
    {
        if (i == cMyID)
            continue;
        if (kbIsPlayerAlly(i) == true)
            continue;

        int count = getNumUnits(cUnitTypeAbstractSettlement, cUnitStateAliveOrBuilding, -1, i);
        if (count > largestAllyCount)
            largestAllyCount=count;
    }
    
    //Never have more than 1 more settlements than any ally.
    int difference=numberSettlementsPlanned-largestAllyCount;
    if ((difference > 1) && (largestAllyCount>=0))     // If ally exists and we have more than 2 more...quit
        return;

    //See if there is another human on my team.
    bool haveHumanTeammate=false;
    for (i=1; < cNumberPlayers)
    {
        if (i == cMyID)
            continue;
        //Find the human player
        if (kbIsPlayerAlly(i) != true)
            continue;

        //This player is a human ally and not resigned.
        if ((kbIsPlayerAlly(i) == true) && (kbIsPlayerResigned(i) == false))
        {
            haveHumanTeammate=true;
            break;
        }
    }
    
    if (haveHumanTeammate == true)
    {
        if (kbGetAge() == cAge3)
        {
            if (numberSettlementsPlanned > 4)
                return;
        }
        else if (kbGetAge() == cAge4)
        {
            if (numberSettlementsPlanned >= cvMaxSettlements)
                return;
        }
    }
    if (ShowAiEcho == true) aiEcho("Creating another settlement goal.");

    int numBuilders = 3;
    if (cMyCulture == cCultureAtlantean)
        numBuilders = 1;
        
    int builderType = cUnitTypeAbstractVillager;
    if (cMyCulture == cCultureNorse)
        builderType = cUnitTypeAbstractInfantry;
        
    //Else, do it.
    createBuildSettlementGoal("BuildSettlement", kbGetAge(), -1, kbBaseGetMainID(cMyID), numBuilders, builderType, true, 100);
} 
 

 
// ALTERNATE ATTACK GOAL
//==============================================================================
rule AttackStrongestPlayer   //Updates the player we should be attacking.
    minInterval 5 //starts in cAge1
    inactive
{
    
    static int lastTargetPlayerIDSaveTime = -1;
    static int lastTargetPlayerID = -1;
    static int randNum = 0;
    static bool increaseStartIndex = false;

    if (ShowAiEcho == true) aiEcho("updatePlayerToAttack:");
    //Determine a random start index for our hate loop.
    static int startIndex = -1;
    if (increaseStartIndex == true)
    {
        if (startIndex >= cNumberPlayers - 1)
            startIndex = 0;
        else
            startIndex = startIndex + 1;
        increaseStartIndex = false;
        if (ShowAiEcho == true) aiEcho("increasing startIndex. startIndex is now: "+startIndex);
    }

	
    if ((startIndex < 0) || (xsGetTime() > lastTargetPlayerIDSaveTime + (15)*60*1000))
    {
        startIndex = aiRandInt(cNumberPlayers);
        if (ShowAiEcho == true) aiEcho("getting new random startIndex. startIndex is now: "+startIndex);
    }

    //Find the "first" enemy player that's still in the game.  This will be the
    //script's recommendation for who we should attack.
    int comparePlayerID = -1;
    for (i = 0; < cNumberPlayers)
    {
        //If we're past the end of our players, go back to the start.
        int actualIndex = i + startIndex;
        if (actualIndex >= cNumberPlayers)
            actualIndex = actualIndex - cNumberPlayers;
        if (actualIndex <= 0)
            continue;
        if ((kbIsPlayerEnemy(actualIndex) == true) &&
            (kbIsPlayerResigned(actualIndex) == false) &&
            (kbHasPlayerLost(actualIndex) == false))
        {
            comparePlayerID = actualIndex;
            if ((actualIndex == lastTargetPlayerID) && (aiRandInt(4) < 1))
            {
                if (ShowAiEcho == true) aiEcho("actualIndex == lastTargetPlayerID, looking for other enemies");
                increaseStartIndex = true;
                continue;
            }
            break;
        }
    }

    //Pass the comparePlayerID into the AI to see what he thinks.  He'll take care
    //of modifying the player in the event of wonders, etc.
    int actualPlayerID = -1;
   
    if (cvPlayerToAttack == -1 )
        actualPlayerID = aiCalculateMostHatedPlayerID(comparePlayerID);
    else
        actualPlayerID = cvPlayerToAttack;
		
		if (HardFocus == true)
		{
		 if (cvPlayerToAttack == -1 )
        actualPlayerID = aiCalculateMostHatedPlayerID(HateChoice);
    else
        actualPlayerID = HateChoice;
		}
    
    if (actualPlayerID != lastTargetPlayerID)
    {
        lastTargetPlayerID = actualPlayerID;
        lastTargetPlayerIDSaveTime = xsGetTime();
        if (ShowAiEcho == true) aiEcho("lastTargetPlayerID: "+lastTargetPlayerID);
        if (ShowAiEcho == true) aiEcho("lastTargetPlayerIDSaveTime: "+lastTargetPlayerIDSaveTime);
        randNum = aiRandInt(5);
    }

	
    if (actualPlayerID != -1 && aiGetWorldDifficulty() < cDifficultyNightmare)
    {
        //Default us off.
        aiSetMostHatedPlayerID(actualPlayerID);
        if (ShowAiEcho == true) aiEcho("most hated playerID = "+actualPlayerID);
    }
	
    if (actualPlayerID != -1 && aiGetWorldDifficulty() > cDifficultyHard)
    {
        //Default us off.
        aiSetMostHatedPlayerID(HateChoice);
        if (ShowAiEcho == true) aiEcho("most hated playerID = "+actualPlayerID);
    }	
}
// END OF ALTERNATE ATTACK GOAL 
 
 //==============================================================================
// CountEnemyUnitsOnMap
//==============================================================================
rule CountEnemyUnitsOnMap
   minInterval 45
   inactive
{
   //Units
   static int unitQueryID1=-1;
   static int unitQueryID2=-1;
   static int unitQueryID3=-1;
   static int unitQueryID4=-1;
   static int unitQueryID5=-1;
   static int unitQueryID6=-1;
   static int unitQueryID7=-1;
   static int unitQueryID8=-1;
   static int unitQueryID9=-1;
   static int unitQueryID10=-1;
   static int unitQueryID11=-1;
   static int unitQueryID12=-1;
   
   // Buildings
   static int BuildingunitQueryID1=-1;
   static int BuildingunitQueryID2=-1;
   static int BuildingunitQueryID3=-1;
   static int BuildingunitQueryID4=-1;
   static int BuildingunitQueryID5=-1;
   static int BuildingunitQueryID6=-1;
   static int BuildingunitQueryID7=-1;
   static int BuildingunitQueryID8=-1;
   static int BuildingunitQueryID9=-1;
   static int BuildingunitQueryID10=-1;
   static int BuildingunitQueryID11=-1;
   static int BuildingunitQueryID12=-1;

  // kbLookAtAllUnitsOnMap(); // enable for testing all units, including non visible.

   if (aiGetWorldDifficulty() < cDifficultyNightmare)
   {
	xsDisableSelf();
	return;
   }


   //Units for Player 1
   if (unitQueryID1 < 0)
   unitQueryID1=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID1 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID1, 1);
		kbUnitQuerySetUnitType(unitQueryID1, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID1, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID1, true);
			
   }
if (kbIsPlayerEnemy(1) && kbIsPlayerValid(1))
{
   kbUnitQueryResetResults(unitQueryID1);
   int Units1=kbUnitQueryExecute(unitQueryID1);
  }

   //Units for Player 2
   if (unitQueryID2 < 0)
   unitQueryID2=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID2 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID2, 2);
		kbUnitQuerySetUnitType(unitQueryID2, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID2, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID2, true);
			
   }
if (kbIsPlayerEnemy(2) && kbIsPlayerValid(2))
{
   kbUnitQueryResetResults(unitQueryID2);
   int Units2=kbUnitQueryExecute(unitQueryID2);
  }

   //Units for Player 3
   if (unitQueryID3 < 0)
   unitQueryID3=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID3 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID3, 3);
		kbUnitQuerySetUnitType(unitQueryID3, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID3, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID3, true);
			
   }
if (kbIsPlayerEnemy(3) && kbIsPlayerValid(3))
   {
int Units3=kbUnitQueryExecute(unitQueryID3);
   kbUnitQueryResetResults(unitQueryID3);
  }
  
  
   //Units for Player 4
   if (unitQueryID4 < 0)
   unitQueryID4=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID4 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID4, 4);
		kbUnitQuerySetUnitType(unitQueryID4, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID4, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID4, true);
			
   }
if (kbIsPlayerEnemy(4) && kbIsPlayerValid(4))
   {
int Units4=kbUnitQueryExecute(unitQueryID4);
   kbUnitQueryResetResults(unitQueryID4);
  }
  
   //Units for Player 5
   if (unitQueryID5 < 0)
   unitQueryID5=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID5 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID5, 5);
		kbUnitQuerySetUnitType(unitQueryID5, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID5, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID5, true);
			
   }
if (kbIsPlayerEnemy(5) && kbIsPlayerValid(5))
   {
int Units5=kbUnitQueryExecute(unitQueryID5);
   kbUnitQueryResetResults(unitQueryID5);
  }
  
   //Units for Player 6
   if (unitQueryID6 < 0)
   unitQueryID6=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID6 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID6, 6);
		kbUnitQuerySetUnitType(unitQueryID6, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID6, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID6, true);
			
   }
if (kbIsPlayerEnemy(6) && kbIsPlayerValid(6))
   {
int Units6=kbUnitQueryExecute(unitQueryID6);
   kbUnitQueryResetResults(unitQueryID6);
  }
  
   //Units for Player 7
   if (unitQueryID7 < 0)
   unitQueryID7=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID7 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID7, 7);
		kbUnitQuerySetUnitType(unitQueryID7, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID7, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID7, true);
			
   }
if (kbIsPlayerEnemy(7) && kbIsPlayerValid(7))
   {
int Units7=kbUnitQueryExecute(unitQueryID7);
   kbUnitQueryResetResults(unitQueryID7);
  }
  
   //Units for Player 8
   if (unitQueryID8 < 0)
   unitQueryID8=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID8 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID8, 8);
		kbUnitQuerySetUnitType(unitQueryID8, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID8, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID8, true);
			
   }
if (kbIsPlayerEnemy(8) && kbIsPlayerValid(8))
   {
int Units8=kbUnitQueryExecute(unitQueryID8);
   kbUnitQueryResetResults(unitQueryID8);
  }
  
   //Units for Player 9
   if (unitQueryID9 < 0)
   unitQueryID9=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID9 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID9, 9);
		kbUnitQuerySetUnitType(unitQueryID9, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID9, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID9, true);
			
   }
if (kbIsPlayerEnemy(9) && kbIsPlayerValid(9))
   {
int Units9=kbUnitQueryExecute(unitQueryID9);
   kbUnitQueryResetResults(unitQueryID9);
  }
  
   //Units for Player 10
   if (unitQueryID10 < 0)
   unitQueryID10=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID10 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID10, 10);
		kbUnitQuerySetUnitType(unitQueryID10, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID10, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID10, true);
			
   }
if (kbIsPlayerEnemy(10) && kbIsPlayerValid(10))
   {
int Units10=kbUnitQueryExecute(unitQueryID10);
   kbUnitQueryResetResults(unitQueryID10);
  }
  
   //Units for Player 11
   if (unitQueryID11 < 0)
   unitQueryID11=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID11 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID11, 11);
		kbUnitQuerySetUnitType(unitQueryID11, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID11, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID11, true);
			
   }
if (kbIsPlayerEnemy(11) && kbIsPlayerValid(11))
   {
int Units11=kbUnitQueryExecute(unitQueryID11);
   kbUnitQueryResetResults(unitQueryID11);
  }
  
   //Units for Player 12
   if (unitQueryID12 < 0)
   unitQueryID12=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID12 != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID12, 12);
		kbUnitQuerySetUnitType(unitQueryID12, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID12, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(unitQueryID12, true);
			
   }
if (kbIsPlayerEnemy(12) && kbIsPlayerValid(12))
   {
int Units12=kbUnitQueryExecute(unitQueryID12);
   kbUnitQueryResetResults(unitQueryID12);
  }


  // Building queries.. yaay!
    //BuildingUnits for Player 1
   if (BuildingunitQueryID1 < 0)
   BuildingunitQueryID1=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID1 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID1, 1);
		kbUnitQuerySetUnitType(BuildingunitQueryID1, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID1, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID1, true);
			
   }
if (kbIsPlayerEnemy(1) && kbIsPlayerValid(1))
{
   kbUnitQueryResetResults(BuildingunitQueryID1);
   int BuildingUnits1=kbUnitQueryExecute(BuildingunitQueryID1);
  }

   //BuildingUnits for Player 2
   if (BuildingunitQueryID2 < 0)
   BuildingunitQueryID2=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID2 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID2, 2);
		kbUnitQuerySetUnitType(BuildingunitQueryID2, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID2, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID2, true);
			
   }
if (kbIsPlayerEnemy(2) && kbIsPlayerValid(2))
{
   kbUnitQueryResetResults(BuildingunitQueryID2);
   int BuildingUnits2=kbUnitQueryExecute(BuildingunitQueryID2);
  }

   //BuildingUnits for Player 3
   if (BuildingunitQueryID3 < 0)
   BuildingunitQueryID3=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID3 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID3, 3);
		kbUnitQuerySetUnitType(BuildingunitQueryID3, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID3, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID3, true);
			
   }
if (kbIsPlayerEnemy(3) && kbIsPlayerValid(3))
   {
int BuildingUnits3=kbUnitQueryExecute(BuildingunitQueryID3);
   kbUnitQueryResetResults(BuildingunitQueryID3);
  }
  
  
   //BuildingUnits for Player 4
   if (BuildingunitQueryID4 < 0)
   BuildingunitQueryID4=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID4 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID4, 4);
		kbUnitQuerySetUnitType(BuildingunitQueryID4, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID4, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID4, true);
			
   }
if (kbIsPlayerEnemy(4) && kbIsPlayerValid(4))
   {
int BuildingUnits4=kbUnitQueryExecute(BuildingunitQueryID4);
   kbUnitQueryResetResults(BuildingunitQueryID4);
  }
  
   //BuildingUnits for Player 5
   if (BuildingunitQueryID5 < 0)
   BuildingunitQueryID5=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID5 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID5, 5);
		kbUnitQuerySetUnitType(BuildingunitQueryID5, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID5, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID5, true);
			
   }
if (kbIsPlayerEnemy(5) && kbIsPlayerValid(5))
   {
int BuildingUnits5=kbUnitQueryExecute(BuildingunitQueryID5);
   kbUnitQueryResetResults(BuildingunitQueryID5);
  }
  
   //BuildingUnits for Player 6
   if (BuildingunitQueryID6 < 0)
   BuildingunitQueryID6=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID6 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID6, 6);
		kbUnitQuerySetUnitType(BuildingunitQueryID6, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID6, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID6, true);
			
   }
if (kbIsPlayerEnemy(6) && kbIsPlayerValid(6))
   {
int BuildingUnits6=kbUnitQueryExecute(BuildingunitQueryID6);
   kbUnitQueryResetResults(BuildingunitQueryID6);
  }
  
   //BuildingUnits for Player 7
   if (BuildingunitQueryID7 < 0)
   BuildingunitQueryID7=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID7 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID7, 7);
		kbUnitQuerySetUnitType(BuildingunitQueryID7, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID7, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID7, true);
			
   }
if (kbIsPlayerEnemy(7) && kbIsPlayerValid(7))
   {
int BuildingUnits7=kbUnitQueryExecute(BuildingunitQueryID7);
   kbUnitQueryResetResults(BuildingunitQueryID7);
  }
  
   //BuildingUnits for Player 8
   if (BuildingunitQueryID8 < 0)
   BuildingunitQueryID8=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID8 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID8, 8);
		kbUnitQuerySetUnitType(BuildingunitQueryID8, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID8, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID8, true);
			
   }
if (kbIsPlayerEnemy(8) && kbIsPlayerValid(8))
   {
int BuildingUnits8=kbUnitQueryExecute(BuildingunitQueryID8);
   kbUnitQueryResetResults(BuildingunitQueryID8);
  }
  
   //BuildingUnits for Player 9
   if (BuildingunitQueryID9 < 0)
   BuildingunitQueryID9=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID9 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID9, 9);
		kbUnitQuerySetUnitType(BuildingunitQueryID9, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID9, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID9, true);
			
   }
if (kbIsPlayerEnemy(9) && kbIsPlayerValid(9))
   {
int BuildingUnits9=kbUnitQueryExecute(BuildingunitQueryID9);
   kbUnitQueryResetResults(BuildingunitQueryID9);
  }
  
   //BuildingUnits for Player 10
   if (BuildingunitQueryID10 < 0)
   BuildingunitQueryID10=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID10 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID10, 10);
		kbUnitQuerySetUnitType(BuildingunitQueryID10, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID10, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID10, true);
			
   }
if (kbIsPlayerEnemy(10) && kbIsPlayerValid(10))
   {
int BuildingUnits10=kbUnitQueryExecute(BuildingunitQueryID10);
   kbUnitQueryResetResults(BuildingunitQueryID10);
  }
  
   //BuildingUnits for Player 11
   if (BuildingunitQueryID11 < 0)
   BuildingunitQueryID11=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID11 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID11, 11);
		kbUnitQuerySetUnitType(BuildingunitQueryID11, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID11, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID11, true);
			
   }
if (kbIsPlayerEnemy(11) && kbIsPlayerValid(11))
   {
int BuildingUnits11=kbUnitQueryExecute(BuildingunitQueryID11);
   kbUnitQueryResetResults(BuildingunitQueryID11);
  }
  
   //BuildingUnits for Player 12
   if (BuildingunitQueryID12 < 0)
   BuildingunitQueryID12=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching BuildingUnits
   if (BuildingunitQueryID12 != -1)
   {
		kbUnitQuerySetPlayerID(BuildingunitQueryID12, 12);
		kbUnitQuerySetUnitType(BuildingunitQueryID12, cUnitTypeBuilding);
	        kbUnitQuerySetState(BuildingunitQueryID12, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(BuildingunitQueryID12, true);
			
   }
if (kbIsPlayerEnemy(12) && kbIsPlayerValid(12))
   {
int BuildingUnits12=kbUnitQueryExecute(BuildingunitQueryID12);
   kbUnitQueryResetResults(BuildingunitQueryID12);
  }
 
 
 // Now to the hate and compare system...

 Int TotalUnits = -0;
 Int TotalBuildings = -0;
 int TotalUnits1 = Units1+BuildingUnits1;
 int TotalUnits2 = Units2+BuildingUnits2;
 int TotalUnits3 = Units3+BuildingUnits3;
 int TotalUnits4 = Units4+BuildingUnits4;
 int TotalUnits5 = Units5+BuildingUnits5;

 int TotalUnits6 = Units6+BuildingUnits6;
 int TotalUnits7 = Units7+BuildingUnits7;
 int TotalUnits8 = Units8+BuildingUnits8;
 int TotalUnits9 = Units9+BuildingUnits9;
 int TotalUnits10 = Units10+BuildingUnits10;
 int TotalUnits11 = Units11+BuildingUnits11;
 int TotalUnits12 = Units12+BuildingUnits12;
 
 if (TotalUnits1 > TotalUnits2 && TotalUnits1 > TotalUnits3 && TotalUnits1 > TotalUnits4 && TotalUnits1 > TotalUnits5 && TotalUnits1 > TotalUnits6 && TotalUnits1 > TotalUnits7 && TotalUnits1 > TotalUnits8 && TotalUnits1 > TotalUnits9 && TotalUnits1 > TotalUnits10 && TotalUnits1 > TotalUnits11 && TotalUnits1 > TotalUnits12)
    	{
		aiSetMostHatedPlayerID(1);
		HateChoice = 1;
		TotalUnits = Units1;
		TotalBuildings = BuildingUnits1;
   }
	
	else if (TotalUnits2 > TotalUnits1 && TotalUnits2 > TotalUnits3 && TotalUnits2 > TotalUnits4 && TotalUnits2 > TotalUnits5 && TotalUnits2 > TotalUnits6 && TotalUnits2 > TotalUnits7 && TotalUnits2 > TotalUnits8 && TotalUnits2 > TotalUnits9 && TotalUnits2 > TotalUnits10 && TotalUnits2 > TotalUnits11 && TotalUnits2 > TotalUnits12) 
    	{
		aiSetMostHatedPlayerID(2);
		HateChoice = 2;
		TotalUnits = Units2;
		TotalBuildings = BuildingUnits2;
   }
	
	else if (TotalUnits3 > TotalUnits1 && TotalUnits3 > TotalUnits2 && TotalUnits3 > TotalUnits4 && TotalUnits3 > TotalUnits5 && TotalUnits3 > TotalUnits6 && TotalUnits3 > TotalUnits7 && TotalUnits3 > TotalUnits8 && TotalUnits3 > TotalUnits9 && TotalUnits3 > TotalUnits10 && TotalUnits3 > TotalUnits11 && TotalUnits3 > TotalUnits12)
    	{
		aiSetMostHatedPlayerID(3);
		HateChoice = 3;
		TotalUnits = Units3;
		TotalBuildings = BuildingUnits3;
   }
	
	else if (TotalUnits4 > TotalUnits1 && TotalUnits4 > TotalUnits2 && TotalUnits4 > TotalUnits3 && TotalUnits4 > TotalUnits5 && TotalUnits4 > TotalUnits6 && TotalUnits4 > TotalUnits7 && TotalUnits4 > TotalUnits8 && TotalUnits4 > TotalUnits9 && TotalUnits4 > TotalUnits10 && TotalUnits4 > TotalUnits11 && TotalUnits4 > TotalUnits12)
    	{
		aiSetMostHatedPlayerID(4);
		HateChoice = 4;
		TotalUnits = Units4;
		TotalBuildings = BuildingUnits4;
   }	
	
	else if (TotalUnits5 > TotalUnits1 && TotalUnits5 > TotalUnits2 && TotalUnits5 > TotalUnits3 && TotalUnits5 > TotalUnits4 && TotalUnits5 > TotalUnits6 && TotalUnits5 > TotalUnits7 && TotalUnits5 > TotalUnits8 && TotalUnits5 > TotalUnits9 && TotalUnits5 > TotalUnits10 && TotalUnits5 > TotalUnits11 && TotalUnits5 > TotalUnits12)
    	{
		aiSetMostHatedPlayerID(5);
		HateChoice = 5;
		TotalUnits = Units5;
		TotalBuildings = BuildingUnits5;
   }
	
	else if (TotalUnits6 > TotalUnits1 && TotalUnits6 > TotalUnits2 && TotalUnits6 > TotalUnits3 && TotalUnits6 > TotalUnits4 && TotalUnits6 > TotalUnits5 && TotalUnits6 > TotalUnits7 && TotalUnits6 > TotalUnits8 && TotalUnits6 > TotalUnits9 && TotalUnits6 > TotalUnits10 && TotalUnits6 > TotalUnits11 && TotalUnits6 > TotalUnits12)
    	{
		aiSetMostHatedPlayerID(6);
		HateChoice = 6;
		TotalUnits = Units6;
		TotalBuildings = BuildingUnits6;
   }
    
	else if (TotalUnits7 > TotalUnits1 && TotalUnits7 > TotalUnits2 && TotalUnits7 > TotalUnits3 && TotalUnits7 > TotalUnits4 && TotalUnits7 > TotalUnits5 && TotalUnits7 > TotalUnits6 && TotalUnits7 > TotalUnits8 && TotalUnits7 > TotalUnits9 && TotalUnits7 > TotalUnits10 && TotalUnits7 > TotalUnits11 && TotalUnits7 > TotalUnits12)
    	{
		aiSetMostHatedPlayerID(7);
		HateChoice = 7;
		TotalUnits = Units7;
		TotalBuildings = BuildingUnits7;
   }
    
	else if (TotalUnits8 > TotalUnits1 && TotalUnits8 > TotalUnits2 && TotalUnits8 > TotalUnits3 && TotalUnits8 > TotalUnits4 && TotalUnits8 > TotalUnits5 && TotalUnits8 > TotalUnits6 && TotalUnits8 > TotalUnits7 && TotalUnits8 > TotalUnits9 && TotalUnits8 > TotalUnits10 && TotalUnits8 > TotalUnits11 && TotalUnits8 > TotalUnits12)
    	{
		aiSetMostHatedPlayerID(8);
		HateChoice = 8;
		TotalUnits = Units8;
		TotalBuildings = BuildingUnits8;
   }
    
	else if (TotalUnits9 > TotalUnits1 && TotalUnits9 > TotalUnits2 && TotalUnits9 > TotalUnits3 && TotalUnits9 > TotalUnits4 && TotalUnits9 > TotalUnits5 && TotalUnits9 > TotalUnits6 && TotalUnits9 > TotalUnits8 && TotalUnits9 > TotalUnits8 && TotalUnits9 > TotalUnits10 && TotalUnits9 > TotalUnits11 && TotalUnits9 > TotalUnits12)
    	{
		aiSetMostHatedPlayerID(9);
		HateChoice = 9;
		TotalUnits = Units9;
		TotalBuildings = BuildingUnits9;
   }
    
	else if (TotalUnits10 > TotalUnits1 && TotalUnits10 > TotalUnits2 && TotalUnits10 > TotalUnits3 && TotalUnits10 > TotalUnits4 && TotalUnits10 > TotalUnits5 && TotalUnits10 > TotalUnits6 && TotalUnits10 > TotalUnits8 && TotalUnits10 > TotalUnits8 && TotalUnits10 > TotalUnits9 && TotalUnits10 > TotalUnits11 && TotalUnits10 > TotalUnits12)
    	{
		aiSetMostHatedPlayerID(10);
		HateChoice = 10;
		TotalUnits = Units10;
		TotalBuildings = BuildingUnits10;
   }
    
	else if (TotalUnits11 > TotalUnits1 && TotalUnits11 > TotalUnits2 && TotalUnits11 > TotalUnits3 && TotalUnits11 > TotalUnits4 && TotalUnits11 > TotalUnits5 && TotalUnits11 > TotalUnits6 && TotalUnits11 > TotalUnits8 && TotalUnits11 > TotalUnits8 && TotalUnits11 > TotalUnits9 && TotalUnits11 > TotalUnits10 && TotalUnits11 > TotalUnits12)
    	{
		aiSetMostHatedPlayerID(11);
		HateChoice = 11;
		TotalUnits = Units11;
		TotalBuildings = BuildingUnits11;
   }
    
	else if (TotalUnits12 > TotalUnits1 && TotalUnits12 > TotalUnits2 && TotalUnits12 > TotalUnits3 && TotalUnits12 > TotalUnits4 && TotalUnits12 > TotalUnits5 && TotalUnits12 > TotalUnits6 && TotalUnits12 > TotalUnits8 && TotalUnits12 > TotalUnits8 && TotalUnits12 > TotalUnits9 && TotalUnits12 > TotalUnits10 && TotalUnits12 > TotalUnits11)
    	{
		aiSetMostHatedPlayerID(12);
		HateChoice = 12;
		TotalUnits = Units12;
		TotalBuildings = BuildingUnits12;
   }
	

	if (ShowAiEcho == true) aiEcho("Player: "+HateChoice+" has a total of "+TotalUnits+" units and "+TotalBuildings+" buildings that is visible to me.. MHP set!");
   xsEnableRule("LockOn");
   xsDisableSelf();
}

 //==============================================================================
// LockOn
//==============================================================================
rule LockOn
   minInterval 46
   inactive
{
int MHP = aiGetMostHatedPlayerID();
   static int MHPunitQueryID1=-1;
   static int MHPBuildingMHPunitQueryID1=-1;
   //Units for Player 1
   if (MHPunitQueryID1 < 0)
   MHPunitQueryID1=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (MHPunitQueryID1 != -1)
   {
		kbUnitQuerySetPlayerID(MHPunitQueryID1, MHP);
		kbUnitQuerySetUnitType(MHPunitQueryID1, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(MHPunitQueryID1, cUnitStateAlive);
			kbUnitQuerySetSeeableOnly(MHPunitQueryID1,true);
			
   }
if (kbIsPlayerEnemy(MHP) && kbIsPlayerValid(MHP))
{
   kbUnitQueryResetResults(MHPunitQueryID1);
   
   int MHPUnits1=kbUnitQueryExecute(MHPunitQueryID1);
  }
   int MHPTotalUnits1 = MHPUnits1;
   
   if (MHPTotalUnits1 > 30)
   if (ShowAiEcho == true) aiEcho("Locking on player "+MHP+"!");
   
   if (MHPTotalUnits1 < 30)
   {
   if (ShowAiEcho == true) aiEcho("Player "+MHP+" has less than 30 units or is an invalid target, I will try to find new hate target.");
   xsEnableRule("CountEnemyUnitsOnMap");
   xsDisableSelf();
   return;  
  }
  }
  
  */       //end SLASH STAR
  