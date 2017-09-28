//AoModAITechs.xs
//This file contains all tech rules
//by Loki_GdD

//==============================================================================
rule getOmniscience
    minInterval 24 //starts in cAge4
    inactive
{
    if (ShowAiEcho == true) aiEcho("getOmniscience:");
    //If we can afford it twice over, then get it.
    float goldCost=kbTechCostPerResource(cTechOmniscience, cResourceGold) * 2.0;
    float currentGold=kbResourceGet(cResourceGold);
    if (goldCost>currentGold)
        return;

    //Get Omniscience
    int voePID=aiPlanCreate("GetOmniscience", cPlanProgression);
    if (voePID != 0)
    {
        aiPlanSetVariableInt(voePID, cProgressionPlanGoalTechID, 0, cTechOmniscience);
        aiPlanSetDesiredPriority(voePID, 25);
        aiPlanSetEscrowID(voePID, cMilitaryEscrowID);
        aiPlanSetActive(voePID);
    }
    xsDisableSelf();
}

//==============================================================================
rule getMasons
    minInterval 131 //starts in cAge2
    inactive
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechMasons;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        xsEnableRule("getArchitects");
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getMasons:");

    float woodSupply = kbResourceGet(cResourceWood);
    float foodSupply = kbResourceGet(cResourceFood);
    float goldSupply = kbResourceGet(cResourceGold);
        
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if (((foodSupply > 560) && (goldSupply > 350) && (kbGetAge() == cAge2))
             || ((foodSupply > 700) && (goldSupply > 700) && (kbGetAge() == cAge3)))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true));
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
            }
        }
        return;
    }
    
    if (kbGetTechStatus(cTechWatchTower) < cTechStatusResearching)
        return;
    
    if ((xsGetTime() < 25*60*1000) && (kbGetAge() < cAge3))
        return;
    
    if ((foodSupply < 400) || (woodSupply < 600))
        return;
            
    if ((foodSupply > 560) && (foodSupply < 850) && (goldSupply > 200) && (kbGetAge() == cAge2))
        return;
    
    if ((foodSupply > 700) && (goldSupply > 700) && (kbGetAge() == cAge3))
        return;
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int masonsID=aiPlanCreate("getMasons", cPlanProgression);
        if (masonsID != -1)
        {
            aiPlanSetVariableInt(masonsID, cProgressionPlanGoalTechID, 0, techID);
            aiPlanSetDesiredPriority(masonsID, 40);      
            aiPlanSetEscrowID(masonsID, cMilitaryEscrowID);
            aiPlanSetActive(masonsID);
            if (ShowAiEcho == true) aiEcho("getting masons upgrade");
        }
    }
}

//==============================================================================
rule getArchitects
    minInterval 131 //starts in cAge3, activated in getMasons
    inactive
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechArchitects;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getArchitects:");

    if (kbGetAge() < cAge3)
        return;
    
    float woodSupply = kbResourceGet(cResourceWood);
    float foodSupply = kbResourceGet(cResourceFood);
    float goldSupply = kbResourceGet(cResourceGold);
        
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if ((foodSupply > 700) && (goldSupply > 700) && (kbGetAge() == cAge3))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true));
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
            }
        }
        return;
    }
        
    if (kbGetTechStatus(cTechWatchTower) < cTechStatusResearching)
        return;
    
    if (kbGetAge() == cAge3)
    {
        if ((foodSupply < 1500) || (woodSupply < 1100) || (goldSupply > 1000))
            return;
    }
    else
    {
        if ((foodSupply < 400) || (woodSupply < 500))
        return;
        
    }

    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int architectsID=aiPlanCreate("getArchitects", cPlanProgression);
        if (architectsID != -1)
        {
            aiPlanSetVariableInt(architectsID, cProgressionPlanGoalTechID, 0, techID);      
            aiPlanSetDesiredPriority(architectsID, 80);      
            aiPlanSetEscrowID(architectsID, cMilitaryEscrowID);
            aiPlanSetActive(architectsID);
            if (ShowAiEcho == true) aiEcho("getting architects upgrade");
        }
    }
}

//==============================================================================
rule getFortifiedTownCenter
    inactive
    minInterval 41 //starts in cAge3
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechFortifyTownCenter;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getFortifiedTownCenter:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
        return;
        
    //Get FTC if we already have 2 settlements, or immediately if no unclaimed settlements, or DM
    if (aiGetGameMode() != cGameModeDeathmatch)    // If not DM
    {
        if (kbUnitCount(0, cUnitTypeAbstractSettlement) > 0)
        {
            if (kbUnitCount(cMyID, cUnitTypeAbstractSettlement) < 2)
                return;     // Quit if settlements remain and we don't yet have 2
        }
    }
    
    // We're in DM, or we have 2 settlements, or we don't see any unclaimed settlements
    int numFortresses = kbUnitCount(cMyID, cUnitTypeAbstractFortress, cUnitStateAliveOrBuilding);
    int numMarkets = kbUnitCount(cMyID, cUnitTypeMarket, cUnitStateAliveOrBuilding);
    if ((numFortresses < 1) || (numMarkets < 1))
        return;

    int planID=aiPlanCreate("GetFTCUpgrade", cPlanProgression);
    if (planID >= 0)
    { 
        aiPlanSetVariableInt(planID, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(planID, 100);
        aiPlanSetEscrowID(planID, cMilitaryEscrowID);
        aiPlanSetActive(planID);
        if (ShowAiEcho == true) aiEcho("getting FortifiedTownCenter");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getEnclosedDeck
    minInterval 32 //starts in cAge2
    inactive
{
    int techID = cTechEnclosedDeck;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getEnclosedDeck:");
        

    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
        return;
    
    static int ruleStartTime = -1;
    
    if (ruleStartTime == -1)
        ruleStartTime = xsGetTime();
        
    if ((kbGetTechStatus(cTechWatchTower) < cTechStatusResearching) && (xsGetTime() - ruleStartTime < 5*60*1000))
        return;
    
    float woodSupply = kbResourceGet(cResourceWood);
    float foodSupply = kbResourceGet(cResourceFood);
    float goldSupply = kbResourceGet(cResourceGold);
    
        
    if ((foodSupply > 560) && (goldSupply > 350) && (kbGetAge() == cAge2) || (foodSupply < 400) || (woodSupply < 400))
        return;

    int enclosedDeckID=aiPlanCreate("getEnclosedDeck", cPlanProgression);
    if (enclosedDeckID != 0)
    {
        aiPlanSetVariableInt(enclosedDeckID, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(enclosedDeckID, 60);      
        aiPlanSetEscrowID(enclosedDeckID, cEconomyEscrowID);
        aiPlanSetActive(enclosedDeckID);
        if (ShowAiEcho == true) aiEcho("getting enclosed deck upgrade");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getPurseSeine
    minInterval 30 //starts in cAge2
    inactive
{
    int techID = cTechPurseSeine;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getPurseSeine:");
    

    
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
        return;
    
    static int ruleStartTime = -1;
    
    if (ruleStartTime == -1)
        ruleStartTime = xsGetTime();
        
    if ((kbGetTechStatus(cTechWatchTower) < cTechStatusResearching) && (xsGetTime() - ruleStartTime < 5*60*1000))
        return;
    
    float foodSupply = kbResourceGet(cResourceFood);
    float woodSupply = kbResourceGet(cResourceWood);
    float goldSupply = kbResourceGet(cResourceGold);
    
    if ((goldSupply < 300) || (woodSupply < 300))
        return;
        
    if ((foodSupply > 560) && (goldSupply > 350) && (kbGetAge() == cAge2))
        return;

    int purseSeineID=aiPlanCreate("getPurseSeine", cPlanProgression);
    if (purseSeineID != 0)
    {
        aiPlanSetVariableInt(purseSeineID, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(purseSeineID, 45);      
        aiPlanSetEscrowID(purseSeineID, cEconomyEscrowID);
        aiPlanSetActive(purseSeineID);
        if (ShowAiEcho == true) aiEcho("getting purse Seine upgrade");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getSaltAmphora
    minInterval 30 //starts in cAge3
    inactive
{
    int techID = cTechSaltAmphora;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getSaltAmphora:");
    
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
        return;
    
    float foodSupply = kbResourceGet(cResourceFood);
    float woodSupply = kbResourceGet(cResourceWood);
    float goldSupply = kbResourceGet(cResourceGold);
    if ((goldSupply < 500) || (woodSupply < 300))
        return;

    if ((foodSupply > 700) && (goldSupply > 700) && (kbGetAge() == cAge3))
        return;

    int saltAmphoraID=aiPlanCreate("getSaltAmphora", cPlanProgression);
    if (saltAmphoraID != 0)
    {
        aiPlanSetVariableInt(saltAmphoraID, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(saltAmphoraID, 80);      
        aiPlanSetEscrowID(saltAmphoraID, cEconomyEscrowID);
        aiPlanSetActive(saltAmphoraID);
        if (ShowAiEcho == true) aiEcho("getting salt amphora");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getHusbandry
    minInterval 173 //starts in cAge1, gets set to 23
    inactive
{
    int techID = cTechHusbandry;
    if ((kbGetTechStatus(techID) > cTechStatusResearching) || (cMyCulture == cCultureAtlantean))
    {
        xsDisableSelf();
        return;
    }
    
    static bool update = false;
    if (update == false)
    {
        xsSetRuleMinIntervalSelf(23);
        update = true;
    }
    
    if (ShowAiEcho == true) aiEcho("getHusbandry:");      
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true));
            aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
        }
        return;
    }
    
    int buildingType = cUnitTypeGranary;
    if (cMyCulture == cCultureNorse)
        buildingType = cUnitTypeOxCart;
    else if (cMyCulture == cCultureChinese)
        buildingType = cUnitTypeStoragePit;			
        
    int numResearchBuildings = kbUnitCount(cMyID, buildingType, cUnitStateAlive);
    if (numResearchBuildings < 1)
        return;
    
    int numTemples = kbUnitCount(cMyID, cUnitTypeTemple, cUnitStateAliveOrBuilding);
    if ((numTemples < 1) || ((cMyCulture == cCultureAtlantean) && (kbGetAge() < cAge2)))
        return;
    int numHerdables = kbUnitCount(cMyID, cUnitTypeHerdable);     
    float goldSupply = kbResourceGet(cResourceGold);
    float woodSupply = kbResourceGet(cResourceWood);
    if ((woodSupply < 200) || (goldSupply < 110) || (kbGetTechStatus(cTechPickaxe) < cTechStatusResearching) || (kbGetTechStatus(cTechHandAxe) < cTechStatusResearching))
        return;
       
    if ((gHuntersExist == true) && (kbGetTechStatus(cTechHuntingDogs) < cTechStatusResearching))
        return;
    
    //Make plan to get husbandry
    int husbandryPlanID=aiPlanCreate("getHusbandry", cPlanProgression);
    if (husbandryPlanID != 0)
    {
        aiPlanSetVariableInt(husbandryPlanID, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(husbandryPlanID, 99);
        aiPlanSetEscrowID(husbandryPlanID, cEconomyEscrowID);
        aiPlanSetActive(husbandryPlanID);
        if (ShowAiEcho == true) aiEcho("getting husbandry");
        xsSetRuleMinIntervalSelf(173);
        update = false;
    }
}

//==============================================================================
rule getPickaxe
    minInterval 25 //starts in cAge1, gets set to 15
    inactive
    group age1EconUpgrades
{
    int techID = cTechPickaxe;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    static bool update = false;
    if (update == false)
    {
        xsSetRuleMinIntervalSelf(15);
        update = true;
    }
    
    if (ShowAiEcho == true) aiEcho("getPickaxe:");        
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true));
            aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
        }
        return;
    }
    
    int buildingType = cUnitTypeGranary;
    if (cMyCulture == cCultureAtlantean)
        buildingType = cUnitTypeGuild;
    else if (cMyCulture == cCultureNorse)
        buildingType = cUnitTypeOxCart;
    else if (cMyCulture == cCultureChinese)
        buildingType = cUnitTypeStoragePit;		
        
    int numResearchBuildings = kbUnitCount(cMyID, buildingType, cUnitStateAlive);
    if (numResearchBuildings < 1)
        return;
    
    int numTemples = kbUnitCount(cMyID, cUnitTypeTemple, cUnitStateAliveOrBuilding);
    if (numTemples < 1)
        return;
    
    float woodSupply = kbResourceGet(cResourceWood);
    float foodSupply = kbResourceGet(cResourceFood);
    if (kbGetAge() < cAge2)
    {    
        if (kbGetTechStatus(gAge2MinorGod) < cTechStatusResearching)
            return;
    }

    
    //get Pickaxe.
    int pickAxePlanID=aiPlanCreate("getPickAxe", cPlanProgression);
    if (pickAxePlanID != 0)
    {
        aiPlanSetVariableInt(pickAxePlanID, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(pickAxePlanID, 95);
        aiPlanSetEscrowID(pickAxePlanID, cEconomyEscrowID);
        aiPlanSetActive(pickAxePlanID);
        if (ShowAiEcho == true) aiEcho("getting pickaxe");
        xsSetRuleMinIntervalSelf(15);
        update = false;
    }
}

//==============================================================================
rule getHandaxe
    minInterval 25 //starts in cAge1, gets set to 15
    inactive
    group age1EconUpgrades
{    
    int techID = cTechHandAxe;
    if (kbGetTechStatus(cTechHandAxe) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    static bool update = false;
    if (update == false)
    {
        xsSetRuleMinIntervalSelf(15);
        update = true;
    }
    
    if (ShowAiEcho == true) aiEcho("getHandaxe:");
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true));
            aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
        }
        return;
    }
    
    int buildingType = cUnitTypeGranary;
    if (cMyCulture == cCultureAtlantean)
        buildingType = cUnitTypeGuild;
    else if (cMyCulture == cCultureNorse)
        buildingType = cUnitTypeOxCart;
    else if (cMyCulture == cCultureChinese)
        buildingType = cUnitTypeStoragePit;			
        
    int numResearchBuildings = kbUnitCount(cMyID, buildingType, cUnitStateAlive);
    if (numResearchBuildings < 1)
        return;
    
    int numTemples = kbUnitCount(cMyID, cUnitTypeTemple, cUnitStateAliveOrBuilding);
    if (numTemples < 1)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
    
    if (kbGetAge() < cAge2)
    {
        if (kbGetTechStatus(gAge2MinorGod) < cTechStatusResearching)
            return;
    }
    
    //get Handaxe.
    int handAxePlanID=aiPlanCreate("getHandAxe", cPlanProgression);
    if (handAxePlanID != 0)
    {
        aiPlanSetVariableInt(handAxePlanID, cProgressionPlanGoalTechID, 0, cTechHandAxe);
        aiPlanSetDesiredPriority(handAxePlanID, 95);
        aiPlanSetEscrowID(handAxePlanID, cEconomyEscrowID);
        aiPlanSetActive(handAxePlanID);
        if (ShowAiEcho == true) aiEcho("getting handaxe");
        xsSetRuleMinIntervalSelf(15);
        update = false;
    }
}
   
//==============================================================================
rule getHuntingDogs
    minInterval 167 //starts in cAge1, gets set to 11
    inactive
{
    int techID = cTechHuntingDogs;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    static bool update = false;
    if (update == false)
    {
        xsSetRuleMinIntervalSelf(11);
        update = true;
    }
    
     
    if (ShowAiEcho == true) aiEcho("getHuntingDogs:");
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true));
            aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
        }
        return;
    }
    
    int buildingType = cUnitTypeGranary;
    if (cMyCulture == cCultureAtlantean)
        buildingType = cUnitTypeGuild;
    else if (cMyCulture == cCultureNorse)
        buildingType = cUnitTypeOxCart;
    else if (cMyCulture == cCultureChinese)
        buildingType = cUnitTypeStoragePit;			
        
    int numResearchBuildings = kbUnitCount(cMyID, buildingType, cUnitStateAlive);
    if (numResearchBuildings < 1)
        return;
    
    int numTemples = kbUnitCount(cMyID, cUnitTypeTemple, cUnitStateAliveOrBuilding);
    if (numTemples < 1)
        return;
        
    float goldSupply = kbResourceGet(cResourceGold);
    float woodSupply = kbResourceGet(cResourceWood);
    if ((woodSupply < 100) || (goldSupply < 100))
        return;
    
    int count = 0;
    int mainBaseID = kbBaseGetMainID(cMyID);
    int numAggressivePlans = aiGetResourceBreakdownNumberPlans(cResourceFood, cAIResourceSubTypeHuntAggressive, mainBaseID);
    if (ShowAiEcho == true) aiEcho("numAggressivePlans: "+numAggressivePlans);
    if (numAggressivePlans > 0)
        count = numAggressivePlans;
    
    if (count < 1)  //we have no hunters
    {
        gHuntersExist = false;
        return;
    }
    
    gHuntersExist = true;

    //get Hunting dogs.
    int huntingDogsPlanID=aiPlanCreate("getHuntingDogs", cPlanProgression);
    if (huntingDogsPlanID != 0)
    {
        aiPlanSetVariableInt(huntingDogsPlanID, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(huntingDogsPlanID, 100);
        aiPlanSetEscrowID(huntingDogsPlanID, cEconomyEscrowID);
        aiPlanSetActive(huntingDogsPlanID);
        if (ShowAiEcho == true) aiEcho("getting hunting dogs");
        xsSetRuleMinIntervalSelf(167);
        update = false;
    }
}

//==============================================================================
// getNextGathererUpgrade
//
// sets up a progression plan to research the next upgrade that benefits the given
// resource.
//==============================================================================
rule getNextGathererUpgrade
   minInterval 16
   inactive
{
	int gathererTypeID=kbTechTreeGetUnitIDTypeByFunctionIndex(cUnitFunctionGatherer,0);
	int prio = 25;
	if ((gathererTypeID < 0) || (kbUnitCount(cMyID,cUnitTypeLogicalTypeBuildingsThatTrainMilitary, cUnitStateAliveOrBuilding) < 2))
	  return();
	
	for (i=0; < 3)
   {
	  int affectedUnitType=-1;
	  if (i == cResourceGold)
		 affectedUnitType=cUnitTypeGold;
	  else if (i == cResourceWood)
		 affectedUnitType=cUnitTypeWood;
	  else
	  {
		 //If we're not farming yet, don't get anything.
		 if (gFarming != true)
			continue;
		 if (kbUnitCount(cMyID, cUnitTypeFarm, cUnitStateAlive) >= 0)   // Farms always first
			affectedUnitType=cUnitTypeFarm;
	  }

	  //Get the building that we drop this resource off at.
	   int dropSiteFilterID=kbTechTreeGetDropsiteUnitIDByResource(i, 0);
	  if (cMyCulture == cCultureAtlantean)
		 dropSiteFilterID = cUnitTypeGuild;  // All econ techs at guild
	   if (dropSiteFilterID < 0)
		   continue;

	  //Don't do anything until you have a dropsite.
	  if (findUnit(dropSiteFilterID) == -1)
		 continue;

	  //Get the cheapest thing.
	   int upgradeTechID=kbTechTreeGetCheapestUnitUpgrade(gathererTypeID, cUpgradeTypeWorkRate, -1, dropSiteFilterID, false, affectedUnitType);
	   if (upgradeTechID < 0)
		   continue;
	   //Dont make another plan if we already have one.
	  if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, upgradeTechID) != -1)
		 continue;
       
	  //Make plan to get this upgrade.
	   int planID=aiPlanCreate("GathererUpgrade: " +kbGetTechName(upgradeTechID), cPlanProgression);
	   if (planID < 0)
		   continue;

	   aiPlanSetVariableInt(planID, cProgressionPlanGoalTechID, 0, upgradeTechID);
	   if (affectedUnitType == cUnitTypeFarm)
	   prio = 95;
	   aiPlanSetDesiredPriority(planID, prio);
	   aiPlanSetEscrowID(planID, cEconomyEscrowID);
	   aiPlanSetActive(planID);
   }
}
//==============================================================================
rule getAmbassadors
    inactive
    minInterval 60 //starts in cAge3
{
    if (IhaveAllies == false)
	return;
	
    int techID = cTechAmbassadors;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getAmbassadors:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    if (kbUnitCount(cMyID, cUnitTypeMarket, cUnitStateAliveOrBuilding) < 1)
        return;
        
    float goldSupply = kbResourceGet(cResourceGold);
    if ((goldSupply < 500) || (kbGetAge() < cAge4))
        return;
    
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("Ambassadors", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 10);
        aiPlanSetEscrowID(x, cEconomyEscrowID);
        aiPlanSetActive(x);
        xsSetRuleMinIntervalSelf(60);
        if (ShowAiEcho == true) aiEcho("Getting Ambassadors");
    }
}
//==============================================================================
rule getTaxCollectors
    inactive
    minInterval 47 //starts in cAge3
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechTaxCollectors;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }

    if (ShowAiEcho == true) aiEcho("getTaxCollectors:");

    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
        
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if ((foodSupply > 700) && (goldSupply > 700) && (kbGetAge() == cAge3))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
                xsSetRuleMinIntervalSelf(47);
            }
        }
        return;
    }
    
    if (kbUnitCount(cMyID, cUnitTypeMarket, cUnitStateAliveOrBuilding) < 1)
        return;
        
    if ((goldSupply < 600) || (foodSupply < 600))
        return;
        
    if ((foodSupply > 700) && (goldSupply > 700) && (kbGetAge() == cAge3))
        return;
    
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("TaxCollectors", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 50);
        aiPlanSetEscrowID(x, cEconomyEscrowID);
        aiPlanSetActive(x);
        xsSetRuleMinIntervalSelf(11);
        if (ShowAiEcho == true) aiEcho("Getting TaxCollectors");
    }
}



//==============================================================================
rule getHeroicFleet
    inactive
    minInterval 300 //starts in cAge2
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechHeroicFleet;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getHeroicFleet:");
        

    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("HeroicFleet", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 50);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        xsSetRuleMinIntervalSelf(307);
        if (ShowAiEcho == true) aiEcho("Getting HeroicFleet");
    }
}

//==============================================================================
rule getCrenellations
    inactive
    minInterval 79 //starts in cAge2
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechCrenellations;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }

    if (ShowAiEcho == true) aiEcho("getCrenellations:");

    float goldSupply = kbResourceGet(cResourceGold);
    float woodSupply = kbResourceGet(cResourceWood);
    float foodSupply = kbResourceGet(cResourceFood);
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetAge() == cAge2))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
                xsSetRuleMinIntervalSelf(79);
            }
        }
        return;
    }
    
    if ((cMyCulture != cCultureEgyptian) && (kbGetTechStatus(cTechWatchTower) < cTechStatusResearching))
        return;
    
    if ((woodSupply < 300) || (foodSupply < 300))
        return;
        
    if ((foodSupply > 560) && (goldSupply > 350) && (kbGetAge() == cAge2))
        return;
    
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("Crenellations", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 70);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        xsSetRuleMinIntervalSelf(11);
        if (ShowAiEcho == true) aiEcho("Getting crenellations");
    }
}

//==============================================================================
rule getSignalFires
    inactive
    minInterval 107 //starts in cAge2
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechSignalFires;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsEnableRule("getCarrierPigeons");
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getSignalFires:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    if ((cMyCulture != cCultureEgyptian) && (kbGetTechStatus(cTechWatchTower) < cTechStatusResearching))
        return;
        
    float woodSupply = kbResourceGet(cResourceWood);
    if (woodSupply < 500)
        return;
    
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("SignalFires", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 10);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting signal fires");
    }
}

//==============================================================================
rule getBoilingOil
    inactive
    minInterval 79 //starts in cAge3
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechBoilingOil;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getBoilingOil:");
 
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    int numFortresses = kbUnitCount(cMyID, cUnitTypeAbstractFortress, cUnitStateAliveOrBuilding);
	int numTowers = kbUnitCount(cMyID, cUnitTypeTower, cUnitStateAliveOrBuilding);
	int Sbuildings = numFortresses + numTowers;
    int numMarkets = kbUnitCount(cMyID, cUnitTypeMarket, cUnitStateAliveOrBuilding);
    if ((Sbuildings < 1) || (numMarkets < 1))
        return;
        
    float woodSupply = kbResourceGet(cResourceWood);
    float foodSupply = kbResourceGet(cResourceFood);
    float goldSupply = kbResourceGet(cResourceGold);
    if ((woodSupply < 450) || (foodSupply < 200))
        return;

    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("BoilingOil", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 70);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        xsSetRuleMinIntervalSelf(307);
        if (ShowAiEcho == true) aiEcho("Getting boiling oil");
    }
}

//==============================================================================
rule getCarrierPigeons
    inactive
    minInterval 107 //starts in cAge2 activated in getSignalFires
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechCarrierPigeons;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getCarrierPigeons:");
  
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    int numFortresses = kbUnitCount(cMyID, cUnitTypeAbstractFortress, cUnitStateAliveOrBuilding);
    int numMarkets = kbUnitCount(cMyID, cUnitTypeMarket, cUnitStateAliveOrBuilding);
    if ((numFortresses < 1) || (numMarkets < 1))
        return;

    float woodSupply = kbResourceGet(cResourceWood);
    if (woodSupply < 800)
        return;
    
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("CarrierPigeons", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 10);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting carrier pigeons");
    }
}

//==============================================================================
rule getWatchTower
    inactive
    minInterval 10 //starts in cAge2
{
    int techID = cTechWatchTower;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getWatchTower:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("WatchTower", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 100);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        xsSetRuleMinIntervalSelf(307);
        if (ShowAiEcho == true) aiEcho("Getting Watch Tower");
    }
}

//==============================================================================
rule getGuardTower
    inactive
    minInterval 43 //starts in cAge3
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechGuardTower;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        if (cMyCulture == cCultureEgyptian)
            xsEnableRule("getBallistaTower");
        xsDisableSelf();
        return;
    }

    if (ShowAiEcho == true) aiEcho("getGuardTower:");

    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
    float woodSupply = kbResourceGet(cResourceWood);
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if ((foodSupply > 700) && (goldSupply > 700) && (kbGetAge() == cAge3))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
                xsSetRuleMinIntervalSelf(43);
            }
        }
        return;
    }
    
    int numFortresses = kbUnitCount(cMyID, cUnitTypeAbstractFortress, cUnitStateAliveOrBuilding);
    int numMarkets = kbUnitCount(cMyID, cUnitTypeMarket, cUnitStateAliveOrBuilding);
    if ((numFortresses < 1) || (numMarkets < 1))
        return;
    
    if ((goldSupply < 400) || (woodSupply < 400))
        return;
        
    if ((foodSupply > 700) && (goldSupply > 700) && (kbGetAge() == cAge3))
        return;
        
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("GuardTower", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 99);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting Guard Tower");
    }
}

//==============================================================================
rule getBallistaTower
    inactive
    minInterval 47 //starts in cAge3 activated in getGuardTower
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechBallistaTower;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getBallistaTower:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    float foodSupply = kbResourceGet(cResourceFood);
    float woodSupply = kbResourceGet(cResourceWood);
    if ((woodSupply < 800) || (foodSupply < 500))
        return;
        
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("Ballista Tower", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 80);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        xsSetRuleMinIntervalSelf(307);
        if (ShowAiEcho == true) aiEcho("Getting Ballista Tower");
    }
}

//==============================================================================
rule getStoneWall
    inactive
    minInterval 37 //starts in cAge2
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechStoneWall;
	if (cMyCulture == cCultureChinese)
	techID = cTechStoneWallChinese;
    
	if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        if (cMyCulture == cCultureAtlantean)
            xsEnableRule("getBronzeWall");
        else if ((cMyCulture == cCultureEgyptian) || (cMyCulture == cCultureGreek) || (cMyCulture == cCultureChinese))
            xsEnableRule("getFortifiedWall");
        xsDisableSelf();
        return;
    }

    if (ShowAiEcho == true) aiEcho("getStoneWall:");

    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
        
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
                xsSetRuleMinIntervalSelf(37);
            }
        }
        return;
    }
    
    if ((kbGetTechStatus(cTechWatchTower) < cTechStatusResearching) && (gTransportMap == false))
        return;
       
    if (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching)
    {
        if ((goldSupply < 400) || (foodSupply < 400))
            return;
        
        if ((foodSupply > 560) && (goldSupply > 350))
            return;
    }
    
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("StoneWall", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 98);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting Stone Wall");
    }
}

//==============================================================================
rule getFortifiedWall
    inactive
    minInterval 37 //starts in cAge2 activated in getStoneWall
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechFortifiedWall;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        if (cMyCulture == cCultureEgyptian)
            xsEnableRule("getCitadelWall");
        if (cMyCulture == cCultureChinese)
            xsEnableRule("getGreatWall");			
			
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getFortifiedWall:");

    if (kbGetTechStatus(cTechStoneWall) < cTechStatusResearching)
    {
        return;
    }

    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    int numFortresses = kbUnitCount(cMyID, cUnitTypeAbstractFortress, cUnitStateAliveOrBuilding);
    if (numFortresses < 1)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);    
    if ((goldSupply < 600) || (foodSupply < 750))
        return;
        
    if ((kbGetAge() == cAge3) && (goldSupply > 700) && (foodSupply > 700))
        return;

    static int count = 0;        
    if (count < 1)
    {
        count = count + 1;
        return;
    }

    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("FortifiedWall", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 90);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting Fortified Wall");
    }
}

//==============================================================================
rule getCitadelWall
    inactive
    minInterval 37 //starts in cAge2 activated in getFortifiedWall
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechCitadelWall;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getCitadelWall:");

    if (kbGetTechStatus(cTechFortifiedWall) < cTechStatusResearching)
    {
        return;
    }
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
    if ((goldSupply < 750) || (foodSupply < 1080))
        return;
        
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("CitadelWall", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 80);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting Citadel Wall");
    }
}

//==============================================================================
rule getBronzeWall
    inactive
    minInterval 37 //starts in cAge2 activated in getStoneWall
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechBronzeWall;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsEnableRule("getIronWall");
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getBronzeWall:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
    if ((goldSupply < 450) || (foodSupply < 600))
        return;
        
    if (((foodSupply > 750) || (goldSupply > 500)) && (kbGetAge() == cAge2))
        return;
    else if ((foodSupply > 700) && (goldSupply > 700) && (kbGetAge() == cAge3))
        return;

    static int count = 0;        
    if (count < 1)
    {
        count = count + 1;
        return;
    }
   
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("BronzeWall", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 95);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting Bronze Wall");
    }
}

//==============================================================================
rule getIronWall
    inactive
    minInterval 37 //starts in cAge2 activated in getBronzeWall
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechIronWall;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsEnableRule("getOreichalkosWall");
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getIronWall:");

    if (kbGetTechStatus(cTechBronzeWall) < cTechStatusResearching)
    {
        return;
    }
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    int numFortresses = kbUnitCount(cMyID, cUnitTypeAbstractFortress, cUnitStateAliveOrBuilding);
    if (numFortresses < 1)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
    if ((goldSupply < 675) || (foodSupply < 900))
        return;

    static int count = 0;        
    if (count < 1)
    {
        count = count + 1;
        return;
    }
        
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("IronWall", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 90);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting IronWall");
    }
}

//==============================================================================
rule getOreichalkosWall
    inactive
    minInterval 37 //starts in cAge2 activated in getIronWall
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechOreichalkosWall;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getOreichalkosWall:");

    if (kbGetTechStatus(cTechIronWall) < cTechStatusResearching)
    {
        return;
    }
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
    if ((goldSupply < 900) || (foodSupply < 1275))
        return;
        
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("OreichalkosWall", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 80);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        xsSetRuleMinIntervalSelf(307);
        if (ShowAiEcho == true) aiEcho("Getting OreichalkosWall");
    }
}

//==============================================================================
rule getHandsOfThePharaoh
    inactive
    minInterval 30 //starts in cAge1
{
    int techID = cTechHandsofthePharaoh;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getHandsOfThePharaoh:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("HandsOfThePharaoh", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 100);
        aiPlanSetEscrowID(x, cEconomyEscrowID);
        aiPlanSetActive(x);
        xsSetRuleMinIntervalSelf(307);
        if (ShowAiEcho == true) aiEcho("Getting HandsOfThePharaoh");
    }
}

//==============================================================================
rule getAxeOfMuspell
    inactive
    minInterval 43 //starts in cAge3
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechAxeofMuspell;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getAxeOfMuspell:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float woodSupply = kbResourceGet(cResourceWood);
    float foodSupply = kbResourceGet(cResourceFood);
    if ((goldSupply < 375) || (woodSupply < 150))
        return;
    
    if ((foodSupply > 700) && (goldSupply > 700) && (kbGetAge() == cAge3))
        return;
        
    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("AxeOfMuspell", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 50);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        xsSetRuleMinIntervalSelf(307);
        if (ShowAiEcho == true) aiEcho("Getting AxeOfMuspell");
    }
}

//==============================================================================
rule getBeastSlayer
    inactive
    minInterval 41 //starts in cAge4
{
    int techID = cTechBeastSlayer;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getBeastSlayer:");

    float foodSupply = kbResourceGet(cResourceFood);
    float woodSupply = kbResourceGet(cResourceWood);
    float goldSupply = kbResourceGet(cResourceGold);
    float favorSupply = kbResourceGet(cResourceFavor);
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
    {
        if ((kbGetTechStatus(cTechSecretsoftheTitans) < cTechStatusResearching) && (TitanAvailable == true))
        {
            if ((favorSupply > 15) && (goldSupply > 500) && (foodSupply > 500) && (woodSupply > 500))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
                xsSetRuleMinIntervalSelf(41);
            }
        }
        return;
    }
    
    if ((gAge4MinorGod == cTechAge4Hephaestus) && (kbGetTechStatus(cTechForgeofOlympus) <= cTechStatusResearching))
        return;
    
    int specialUnitID = -1;
    if (cMyCiv == cCivZeus)
        specialUnitID = cUnitTypeMyrmidon;
    else if (cMyCiv == cCivHades)
        specialUnitID = cUnitTypeCrossbowman;
    else if (cMyCiv == cCivPoseidon)
        specialUnitID = cUnitTypeHetairoi;
    
    int numSpecialUnits = kbUnitCount(cMyID, specialUnitID, cUnitStateAlive);
    if (numSpecialUnits < 4)
        return;

    if ((kbGetTechStatus(cTechSecretsoftheTitans) < cTechStatusResearching) && (TitanAvailable == true))
    {
        if ((goldSupply < 600) || (foodSupply < 500) || (favorSupply < 25))
            return;
        
        if ((favorSupply < 65) && (goldSupply > 650) && (foodSupply > 650) && (woodSupply > 700))
            return;
    }

    if (kbGetTechStatus(techID) == cTechStatusAvailable)
    {
        int x = aiPlanCreate("BeastSlayer", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 70);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting BeastSlayer");
        xsSetRuleMinIntervalSelf(11);
    }
}

//==============================================================================
rule getMediumInfantry
    inactive
    minInterval 13 //starts in cAge2
    group mediumGreek
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechMediumInfantry;
	if (cMyCulture == cCultureChinese)
	techID = cTechMediumBarracks;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }

    if (ShowAiEcho == true) aiEcho("getMediumInfantry:");
           

    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);    
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true));
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
                xsSetRuleMinIntervalSelf(13);
            }
        }
        return;
    }
    if ((kbGetTechStatus(cTechWatchTower) < cTechStatusResearching) && (gTransportMap == false))
        return;

    int numInfantry = kbUnitCount(cMyID, cUnitTypeAbstractInfantry, cUnitStateAlive);
    if ((numInfantry < 5) && (kbGetAge() < cAge3))
        return;
    
    if (kbGetTechStatus(gAge4MinorGod) < cTechStatusResearching)
    {
        if (numInfantry < 9)
        {
            if ((goldSupply < 300) || (foodSupply < 300))
                return;
        
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
                return;
        }
    }
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("MediumInfantry", cPlanProgression);
        aiPlanSetVariableInt(x, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 100);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting MediumInfantry");
        xsSetRuleMinIntervalSelf(11);
    }
}

//==============================================================================
rule getMediumCavalry
    inactive
    minInterval 12 //starts in cAge2
    group mediumGreek
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechMediumCavalry;
	if (cMyCulture == cCultureChinese)
	techID = cTechMediumStable;	
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }

    if (ShowAiEcho == true) aiEcho("getMediumCavalry:");

    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);    
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true));
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
                xsSetRuleMinIntervalSelf(12);
            }
        }
        return;
    }
    
    if ((kbGetTechStatus(cTechWatchTower) < cTechStatusResearching) && (gTransportMap == false))
        return;
        
    int numCavalry = kbUnitCount(cMyID, cUnitTypeAbstractCavalry, cUnitStateAlive);
    if ((numCavalry < 5) && (kbGetAge() < cAge3))
        return;
    
    if (kbGetTechStatus(gAge4MinorGod) < cTechStatusResearching)
    {
        if (numCavalry < 9)
        {
            if ((goldSupply < 200) || (foodSupply < 400))
                return;
        
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
                return;
        }
    }
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("MediumCavalry", cPlanProgression);
        aiPlanSetVariableInt(x, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 100);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting MediumCavalry");
        xsSetRuleMinIntervalSelf(11);
    }
}

//==============================================================================
rule getMediumArchers
    inactive
    minInterval 11 //starts in cAge2
    group mediumGreek
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechMediumArchers;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getMediumArchers:");    

    float foodSupply = kbResourceGet(cResourceFood);
    float goldSupply = kbResourceGet(cResourceGold);
    float woodSupply = kbResourceGet(cResourceWood);
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
                xsSetRuleMinIntervalSelf(11);
            }
        }
        return;
    }
    
    if ((kbGetTechStatus(cTechWatchTower) < cTechStatusResearching) && (gTransportMap == false))
        return;
    
    int numArchers = kbUnitCount(cMyID, cUnitTypeAbstractArcher, cUnitStateAlive);
    if ((numArchers < 5) && (kbGetAge() < cAge3))
        return;
    
    if (kbGetTechStatus(gAge4MinorGod) < cTechStatusResearching)
    {
        if (numArchers < 9)
        {
            if ((goldSupply < 300) || (woodSupply < 300))
                return;
        
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
                return;
        }
    }
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("MediumArchers", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 100);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting MediumArchers");
        xsSetRuleMinIntervalSelf(11);
    }
}

//==============================================================================
rule getChampionInfantry
    inactive
    minInterval 18 //starts in cAge4
    group championGreek
{
    int techID = cTechChampionInfantry;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getChampionInfantry:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
        return;
    
    int numberOfInfantry = kbUnitCount(cMyID, cUnitTypeAbstractInfantry, cUnitStateAlive);
    if (numberOfInfantry < 5)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
    if ((goldSupply < 500) || (foodSupply < 600))
        return;
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("ChampionInfantry", cPlanProgression);
        aiPlanSetVariableInt(x, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 98);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting ChampionInfantry");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getChampionCavalry
    inactive
    minInterval 16 //starts in cAge4
    group championGreek
{
    int techID = cTechChampionCavalry;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getChampionCavalry:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
        return;
    
    int numberOfCavalry = kbUnitCount(cMyID, cUnitTypeAbstractCavalry, cUnitStateAlive);
    if (numberOfCavalry < 5)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
    if ((goldSupply < 300) || (foodSupply < 800))
        return;
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("ChampionCavalry", cPlanProgression);
        aiPlanSetVariableInt(x, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 98);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting ChampionCavalry");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getChampionArchers
    inactive
    minInterval 15 //starts in cAge4
    group championGreek
{
    int techID = cTechChampionArchers;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getChampionArchers:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;

    int numberOfArchers = kbUnitCount(cMyID, cUnitTypeAbstractArcher, cUnitStateAlive);
    if (numberOfArchers < 5)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float woodSupply = kbResourceGet(cResourceWood);
    if ((goldSupply < 500) || (woodSupply < 600))
        return;
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("ChampionArchers", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 98);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting ChampionArchers");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getDraftHorses
    inactive
    minInterval 20 //starts in cAge3
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechDraftHorses;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getDraftHorses:");

    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
        return;
    
    int numSiegeWeapons = kbUnitCount(cMyID, cUnitTypeAbstractSiegeWeapon, cUnitStateAlive);
    if (numSiegeWeapons < 2)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
    if ((goldSupply < 400) || (foodSupply < 600))
        return;
        
    if ((foodSupply > 700) && (goldSupply > 700) && (kbGetAge() == cAge3))
        return;

    static int count = 0;
    if (count < 1)
    {
        count = count + 1;
        return;
    }
        
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("DraftHorses", cPlanProgression);
        aiPlanSetVariableInt(x, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 50);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting DraftHorses");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getEngineers
    inactive
    minInterval 20 //starts in cAge4
{
    int techID = cTechEngineers;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }
    
    if (ShowAiEcho == true) aiEcho("getEngineers:");
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
        return;
    
    int numSiegeWeapons = kbUnitCount(cMyID, cUnitTypeAbstractSiegeWeapon, cUnitStateAlive);
    if (numSiegeWeapons < 2)
        return;
    
    float goldSupply = kbResourceGet(cResourceGold);
    float foodSupply = kbResourceGet(cResourceFood);
    if ((goldSupply < 1000) || (foodSupply < 600))
        return;
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("Engineers", cPlanProgression);
        aiPlanSetVariableInt(x, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 50);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting Engineers");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getCoinage
    inactive
    minInterval 20 //starts in cAge4
{
    int techID = cTechCoinage;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }

    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int tradeUpgradePlanID=aiPlanCreate("coinageUpgrade", cPlanResearch);
        if (tradeUpgradePlanID != 0)
        {
            aiPlanSetVariableInt(tradeUpgradePlanID, cResearchPlanTechID, 0, techID);
            aiPlanSetDesiredPriority(tradeUpgradePlanID, 100);      // Do it ASAP!
            aiPlanSetEscrowID(tradeUpgradePlanID, cEconomyEscrowID);
            aiPlanSetActive(tradeUpgradePlanID);
            if (ShowAiEcho == true) aiEcho("Getting coinage upgrade.");
            xsSetRuleMinIntervalSelf(307);
        }
    }
}

//==============================================================================
rule researchCopperShields
    minInterval 14 //starts in cAge2
    inactive
    group ArmoryAge2
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    if ((cMyCulture != cCultureEgyptian) && (kbGetTechStatus(cTechWatchTower) < cTechStatusResearching) && (gTransportMap == false))
        return;
    
    int techID = cTechCopperShields;
	if (cMyCiv == cCivThor)
	techID = cTechCopperShieldsThor;
	
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }

    if (ShowAiEcho == true) aiEcho("researchCopperShields:");

    float foodSupply = kbResourceGet(cResourceFood);
    float goldSupply = kbResourceGet(cResourceGold);
    float woodSupply = kbResourceGet(cResourceWood);
            
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
                xsSetRuleMinIntervalSelf(14);
            }
        }
        return;
    }
    
    int numHumanSoldiers = kbUnitCount(cMyID, cUnitTypeHumanSoldier, cUnitStateAlive);
    int numHeroes = kbUnitCount(cMyID, cUnitTypeHero, cUnitStateAlive);
    int numMilitaryShips = kbUnitCount(cMyID, cUnitTypeLogicalTypeShipNotFishinghip, cUnitStateAlive);
    if (numHumanSoldiers + numHeroes + numMilitaryShips < 13)
        return;
    
    if (kbGetTechStatus(gAge4MinorGod) < cTechStatusResearching)
    {
        if (numHumanSoldiers + numHeroes + numMilitaryShips < 21)
        {
            if ((goldSupply < 300) || (woodSupply < 300))
                return;
        
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
                return;
        }
    }

    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("researchCopperShields", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 99);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("researching CopperShields");
        xsSetRuleMinIntervalSelf(11);
    }
}

//==============================================================================
rule researchCopperMail
    minInterval 15 //starts in cAge2
    inactive
    group ArmoryAge2
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    if ((cMyCulture != cCultureEgyptian) && (kbGetTechStatus(cTechWatchTower) < cTechStatusResearching) && (gTransportMap == false))
        return;

    if (ShowAiEcho == true) aiEcho("researchCopperMail:");

    int techID = cTechCopperMail;
	if (cMyCiv == cCivThor)
	techID = cTechCopperMailThor;	
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }

    float foodSupply = kbResourceGet(cResourceFood);
    float goldSupply = kbResourceGet(cResourceGold);

    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
                xsSetRuleMinIntervalSelf(15);
            }
        }
        return;
    }
    
    int numHumanSoldiers = kbUnitCount(cMyID, cUnitTypeHumanSoldier, cUnitStateAlive);
    int numHeroes = kbUnitCount(cMyID, cUnitTypeHero, cUnitStateAlive);
    int numMilitaryShips = kbUnitCount(cMyID, cUnitTypeLogicalTypeShipNotFishinghip, cUnitStateAlive);
    if (numHumanSoldiers + numHeroes + numMilitaryShips < 13)
        return;
    
    if (kbGetTechStatus(gAge4MinorGod) < cTechStatusResearching)
    {
        if (numHumanSoldiers + numHeroes + numMilitaryShips < 21)
        {
            if ((goldSupply < 300) || (foodSupply < 300))
                return;
        
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
                return;
        }
    }
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("researchCopperMail", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 99);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("researching CopperMail");
        xsSetRuleMinIntervalSelf(11);
    }
}

//==============================================================================
rule researchCopperWeapons
    minInterval 16 //starts in cAge2
    inactive
    group ArmoryAge2
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    if ((cMyCulture != cCultureEgyptian) && (kbGetTechStatus(cTechWatchTower) < cTechStatusResearching) && (gTransportMap == false))
        return;

    if (ShowAiEcho == true) aiEcho("researchCopperWeapons:");

    int techID = cTechCopperWeapons;
	if (cMyCiv == cCivThor)
	techID = cTechCopperWeaponsThor;	
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }

    float foodSupply = kbResourceGet(cResourceFood);
    float goldSupply = kbResourceGet(cResourceGold);
    float woodSupply = kbResourceGet(cResourceWood);  
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
    {
        if (kbGetTechStatus(techID) < cTechStatusResearching)
        {
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
            {
                aiPlanDestroy(aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true));
                xsSetRuleMinIntervalSelf(16);
            }
        }
        return;
    }
    
    int numHumanSoldiers = kbUnitCount(cMyID, cUnitTypeHumanSoldier, cUnitStateAlive);
    int numHeroes = kbUnitCount(cMyID, cUnitTypeHero, cUnitStateAlive);
    int numMilitaryShips = kbUnitCount(cMyID, cUnitTypeLogicalTypeShipNotFishinghip, cUnitStateAlive);
    int numBuildingsThatShoot = kbUnitCount(cMyID, cUnitTypeBuildingsThatShoot, cUnitStateAlive);
    if (numHumanSoldiers + numHeroes + numMilitaryShips + numBuildingsThatShoot < 15)
        return;
    
    if (kbGetTechStatus(gAge4MinorGod) < cTechStatusResearching)
    {
        if (numHumanSoldiers + numHeroes + numMilitaryShips + numBuildingsThatShoot < 31)
        {
            if ((goldSupply < 400) || (foodSupply < 400))
                return;
        
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
                return;
        }
    }
    
    static int count = 0;        
    if (count < 1)
    {
        count = count + 1;
        return;
    }

    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("researchCopperWeapons", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 99);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("researching CopperWeapons");
        xsSetRuleMinIntervalSelf(11);
    }
}
//==============================================================================
rule getMediumAxemen
    inactive
    minInterval 13 //starts in cAge2
    group mediumEgyptian
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechMediumAxemen;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }

    if (ShowAiEcho == true) aiEcho("getMediumAxemen:");
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;

    int numAxemen = kbUnitCount(cMyID, cUnitTypeAxeman, cUnitStateAlive);
    if ((numAxemen < 6) && (kbGetAge() < cAge3))
        return;  
    
    if (kbGetTechStatus(gAge4MinorGod) < cTechStatusResearching)
    {
        if (numAxemen < 9)
        {
            float goldSupply = kbResourceGet(cResourceGold);
            float foodSupply = kbResourceGet(cResourceFood);
            if ((goldSupply < 200) || (foodSupply < 200))
                return;
        
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
                return;
        }
    }
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("MediumAxemen", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 100);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting MediumAxemen");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getMediumSpearmen
    inactive
    minInterval 12 //starts in cAge2
    group mediumEgyptian
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechMediumSpearmen;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }

    if (ShowAiEcho == true) aiEcho("getMediumSpearmen:");
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;

    int numSpearmen = kbUnitCount(cMyID, cUnitTypeSpearman, cUnitStateAlive);
    if ((numSpearmen < 6) && (kbGetAge() < cAge3))
        return;
    
    if (kbGetTechStatus(gAge4MinorGod) < cTechStatusResearching)
    {
        if (numSpearmen < 9)
        {
            float goldSupply = kbResourceGet(cResourceGold);
            float foodSupply = kbResourceGet(cResourceFood);
            if ((goldSupply < 200) || (foodSupply < 200))
                return;
        
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
                return;
        }
    }
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("MediumSpearmen", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 100);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting MediumSpearmen");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getMediumSlingers
    inactive
    minInterval 11 //starts in cAge2
    group mediumEgyptian
{
    if (gAgeFaster == true && kbGetAge() < AgeFasterStop)
        return;
    int techID = cTechMediumSlingers;
    if (kbGetTechStatus(techID) > cTechStatusResearching)
    {
        xsDisableSelf();
        return;
    }

    if (ShowAiEcho == true) aiEcho("getMediumSlingers:");
    
    if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, techID, true) >= 0)
        return;

    int numSlingers = kbUnitCount(cMyID, cUnitTypeSlinger, cUnitStateAlive);
    if ((numSlingers < 6) && (kbGetAge() < cAge3))
        return;
    
    if (kbGetTechStatus(gAge4MinorGod) < cTechStatusResearching)
    {
        if (numSlingers < 9)
        {
            float foodSupply = kbResourceGet(cResourceFood);
            float goldSupply = kbResourceGet(cResourceGold);
            float woodSupply = kbResourceGet(cResourceWood);
            if ((goldSupply < 200) || (woodSupply < 200))
                return;
        
            if ((foodSupply > 560) && (goldSupply > 350) && (kbGetTechStatus(gAge3MinorGod) < cTechStatusResearching))
                return;
        }
    }
    
    if (kbGetTechStatus(techID) < cTechStatusResearching)
    {
        int x = aiPlanCreate("MediumSlingers", cPlanResearch);
        aiPlanSetVariableInt(x, cResearchPlanTechID, 0, techID);
        aiPlanSetDesiredPriority(x, 100);
        aiPlanSetEscrowID(x, cMilitaryEscrowID);
        aiPlanSetActive(x);
        if (ShowAiEcho == true) aiEcho("Getting MediumSlingers");
        xsSetRuleMinIntervalSelf(307);
    }
}

//==============================================================================
rule getSecretsOfTheTitan
    minInterval 17 //starts in cAge4
    inactive
{

    if (ShowAiEcho == true) aiEcho("getSecretsOfTheTitan:");
    if (TitanAvailable == false)
    {
        xsDisableSelf();
        return;
    }	
    
    if ((gAge4MinorGod == cTechAge4Hephaestus) && (kbGetTechStatus(cTechForgeofOlympus) < cTechStatusResearching))
        return;
    
    int techID = cTechSecretsoftheTitans;
    if (aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, techID, true) >= 0)
    {
        xsDisableSelf();
        return;
    }
    
    // Make a progression to get Titan
    int titanPID = aiPlanCreate("GetSecretsOfTheTitan", cPlanProgression);
    if (titanPID != 0)
    {
        aiPlanSetVariableInt(titanPID, cProgressionPlanGoalTechID, 0, techID);
        aiPlanSetDesiredPriority(titanPID, 100);
        aiPlanSetEscrowID(titanPID, cMilitaryEscrowID);
        aiPlanSetActive(titanPID);
        if (ShowAiEcho == true) aiEcho("getting secrets of the titans");
        xsDisableSelf();
    }
}
