//File: AoModAiExtra.xs
//By Retherichus
//I'm so happy that you made it this far! this is where you'll find some of the code I've added to the Ai.
//I do plan on putting every change into this file eventually... 
//but that ain't so easy, so there's still some code lurking around in the other files.
//Feel free to copy/borrow my stuff for your own projects if you like, though some credit would be appreciated!
//Oh.. and suggestions are very welcome too.
//
//Now.. if you're just looking to enable/disable stuff, skip to "PART 2". (:


//==============================================================================
//PART 1 Int & Handler
//Below, you'll find the external calls and Plan handlers. 
//you don't really want to touch this.. and if you do, you'll break stuff.
//==============================================================================
extern int fCitadelPlanID = -1;
extern int gShiftingSandPlanID= -1;
mutable void retreatHandler(int planID=-1) {}
mutable void relicHandler(int relicID=-1) {}
mutable void wonderDeathHandler(int playerID=-1) { }
extern bool gHuntingDogsASAP = false;     // Will automatically be called upon if there is huntable nearby the MB.
extern int gGardenBuildLimit = 0;
extern int gLandScoutSpecialUlfsark = -1;
extern bool IsRunTradeUnits1 = false;
extern bool IsRunTradeUnits2 = false;
extern bool IsRunHuntingDogs = false;
extern int gDefendPlentyVault = -1;
extern int gHeavyGPTech=-1;
extern int gHeavyGPPlan=-1;
extern int gDefendPlentyVaultWater=-1;
extern int WallAllyPlanID=-1;
extern bool KOTHStopRefill = false;
extern vector KOTHGlobal = cInvalidVector;
extern bool IhaveAllies = false;
extern bool mRusher = false;
extern bool BeenmRusher = false;
extern int MoreFarms = 26;
extern bool TitanAvailable = false;
extern int KOTHBASE = -1;
extern bool KothDefPlanActive = false;
extern bool WaitForDock = false;
extern int mChineseImmortal = -1;
extern int eChineseHero = -1;
extern int cMonkMaintain = -1;
extern const int cGaiaID = 0;
extern int StuckTransformID = 0;
extern bool HasHumanAlly = false;
extern int MyFortress = cUnitTypeAbstractFortress;
extern int aGoalID = 0;

//////////////// aiEchoDEBUG ////////////////

extern bool ShowAiEcho = false; // All aiEcho, see specific below to override.
extern bool ShowAiEcoEcho = false;  // Eco
extern bool ShowAiGenEcho = false;  // General
extern bool ShowAiMilEcho = false;  // Military
extern bool ShowAiDefEcho = false;  // Defense
extern bool ShowAiTestEcho = false; // Testing 

//////////////// END OF aiEchoDEBUG ///////////

//==============================================================================
//PART 2 Bools & Stuff you can change!
//Below, you'll find a few things I've set up,
//you can turn these on/off as you please, by setting the final value to "true" (on) or "false" (off).
//There's also a small description on all of them, to make it a little easier to understand what happens when you set it to true.
//==============================================================================
extern bool mCanIDefendAllies = true;     // Allows the AI to defend his allies.
extern bool gWallsInDM = true;            // This allows the Ai to build walls in the gametype ''Deathmatch''.
extern bool gAgeFaster = false;            // This will lower/halt most non economical upgrades until Mythic Age, this will allow the Ai to age up faster.
extern int AgeFasterStop = cAge3;         // Age to stop gAgeFaster if enabled. "cAge1" Archaic, "cAge2" Classical, "cAge3" Heroic, "cAge4" Mythic.
extern bool gAgeReduceMil = false;         // This will lower the amount of military units the AI will train until Mythic Age, this will also help the AI to advance a little bit faster, more configs below.
extern bool RethEcoGoals = true;          // Similar to gSuperboom, this will take care of the resources the Ai will try to maintain in Age 2-4, see more below.
extern bool bWallUp = true;              // This ensures that the Ai will build walls, regardless of personality.
extern bool OneMBDefPlanOnly = true;      // Only allow one active "idle defense plan for Mainbase (6 units, 12 if set to false)"

extern bool gHuntEarly = true;            // This will make villagers hunt aggressive animals way earlier, though this can be a little bit dangerous! (Damn you Elephants!) 
extern bool CanIChat = true;              // This will allow the Ai to send chat messages, such as asking for help if it's in danger.
extern bool gEarlyMonuments = false;       // This allows the Ai to build Monuments in Archaic Age. Egyptian only.
extern bool bHouseBunkering = true;       // Makes the Ai bunker up towers with Houses.
extern bool bWonderDefense = true;         // Builds towers/fortresses around friendly wonders.
extern bool bWallAllyMB = true;          // Walls up TC for human allies, only the team captain can do this and Mainbases are skipped.
extern bool bWallCleanup = true;          // Prevents the AI from building small wall pieces inside of gates and/or deletes them if one were to slip through the check.
extern bool CheatResources = false;        // For those who finds titan (difficulty) to be just 	too easy, enable this and you'll have the AI cheat in some resources as it ages up.
extern bool mPopLandAttack = true;         //Dynamically scales the min total pop needed before it can attack, 6 pop slots per TC after 4 and beyond.
extern bool UseStandardPop = false;         //Forces the AI to use the UpID's way of deciding when it is okay to make an attack -
                                            // - automatically enabled if a modded protox is detected. Unit Range is from 20-100 and changes constantly. 1 unit = 3 pop!

//For gAgeReduceMil when true.
extern int eMaxMilPop = 15;               // Max military pop cap during Classical Age, the lower it is, the faster it'll advance, but leaving it defenseless can be just as bad!
extern int eHMaxMilPop = 25;              // Heroic age.


//STINNERV Stuff, or rather what's left of it.
extern int gTitanTradeCarts = 15;         // Max trade carts for Titan (+5)
extern int mGoldBeforeTrade = 6500;       //Excess gold to other resources, (All modes).
extern bool DisallowPullBack = false;  // set true to make the AI no longer retreat(All modes).
extern int ModdedTCTimer = 25;
// End of STINNERV

// For RethEcoGoals, AoModAi do normally calculate the resources it needs, though.. we want it to keep some extra resources at all times, 
// so, let's make it a little bit more ''static'' by setting resource goals a little closer to what Admiral Ai use.
// Do note that anything you put in here will be added on top of the default goals, some values may appear to be very low but it really isn't.
//==============================================================================
//Greek
//==============================================================================
//Age 2 (Classical Age)
extern int RethLGFAge2 = 600;             // Food
extern int RethLGGAge2 = 400;              // Gold
extern int RethLGWAge2 = 400;              // Wood

//Age 3 (Heroic Age)

extern int RethLGFAge3 = 700;              // Food
extern int RethLGGAge3 = 500;              // Gold
extern int RethLGWAge3 = 500;              // Wood

//Age 4 (Mythic Age)

extern int RethLGFAge4 = 1000;              // Food
extern int RethLGGAge4 = 800;              // Gold
extern int RethLGWAge4 = 800;              // Wood


//==============================================================================
//Egyptian
//==============================================================================

//Age 2 (Classical Age)
extern int RethLEFAge2 = 650;              // Food
extern int RethLEGAge2 = 550;              // Gold
extern int RethLEWAge2 = 300;              // Wood

//Age 3 (Heroic Age)

extern int RethLEFAge3 = 700;              // Food
extern int RethLEGAge3 = 600;              // Gold
extern int RethLEWAge3 = 350;              // Wood

//Age 4 (Mythic Age)

extern int RethLEFAge4 = 1000;              // Food
extern int RethLEGAge4 = 800;              // Gold
extern int RethLEWAge4 = 600;              // Wood

//==============================================================================
//Norse
//==============================================================================

//Age 2 (Classical Age)
extern int RethLNFAge2 = 600;             // Food
extern int RethLNGAge2 = 400;              // Gold
extern int RethLNWAge2 = 400;              // Wood

//Age 3 (Heroic Age)

extern int RethLNFAge3 = 700;              // Food
extern int RethLNGAge3 = 500;              // Gold
extern int RethLNWAge3 = 500;              // Wood

//Age 4 (Mythic Age)

extern int RethLNFAge4 = 1000;              // Food
extern int RethLNGAge4 = 800;              // Gold
extern int RethLNWAge4 = 800;              // Wood

//==============================================================================
//Atlantean
//==============================================================================

//Age 2 (Classical Age)
extern int RethLAFAge2 = 600;              // Food
extern int RethLAGAge2 = 400;              // Gold
extern int RethLAWAge2 = 400;              // Wood

//Age 3 (Heroic Age)

extern int RethLAFAge3 = 700;              // Food
extern int RethLAGAge3 = 500;              // Gold
extern int RethLAWAge3 = 500;              // Wood

//Age 4 (Mythic Age)

extern int RethLAFAge4 = 1000;              // Food
extern int RethLAGAge4 = 800;              // Gold
extern int RethLAWAge4 = 800;              // Wood


//==============================================================================
//Chinese
//==============================================================================

//Age 2 (Classical Age)
extern int RethLCFAge2 = 600;              // Food
extern int RethLCGAge2 = 400;              // Gold
extern int RethLCWAge2 = 400;              // Wood

//Age 3 (Heroic Age)

extern int RethLCFAge3 = 700;              // Food
extern int RethLCGAge3 = 500;              // Gold
extern int RethLCWAge3 = 500;              // Wood

//Age 4 (Mythic Age)

extern int RethLCFAge4 = 1000;              // Food
extern int RethLCGAge4 = 800;              // Gold
extern int RethLCWAge4 = 800;              // Wood

//==============================================================================
//PART 3 Overrides & Rules
//From here and below, you'll find my custom rules, 
//as well with some ''Handlers/Overrides'' if we could call it that.
//==============================================================================



//==============================================================================
// Void initRethlAge 1-4
//==============================================================================
void initRethlAge1(void)  // Am I doing this right??
{
	
	aiSetRelicEventHandler("relicHandler");
	aiSetWonderDeathEventHandler("wonderDeathHandler");
	if (cMyCulture == cCultureAtlantean)
    aiSetMinNumberNeedForGatheringAggressvies(2);
	else
	aiSetMinNumberNeedForGatheringAggressvies(7);
	
	if (cMyCulture == cCultureEgyptian && gEarlyMonuments == true)
    xsEnableRule("buildMonuments");
	if (cvMapSubType == VINLANDSAGAMAP)
	{
		cvOkToBuildWalls = false;
		bWallUp = false;
	}
	  // Check with allies and enable donations
       xsEnableRule("MonitorAllies");

	   // Don't build transport ships on these maps!
	   if ((cRandomMapName == "highland") || ((cRandomMapName == "Sacred Pond") || (cRandomMapName == "Sacred Pond 1.0") 
	   || (cRandomMapName == "Sacred Pond 1-0") || (cRandomMapName == "nomad") || (cRandomMapName == "Deep Jungle") 
	   || (cRandomMapName == "Mediterranean") || (cRandomMapName == "mediterranean")))
	   {
	   gTransportMap=false;
	   if (ShowAiEcho == true) aiEcho("Not going to waste pop slots on Transport ships.");
	   }

	   if (cMyCulture == cCultureChinese)
	   {
	   if (cRandomMapName == "vinlandsaga" || cRandomMapName == "team migration")
	   {
	   int areaID=kbAreaGetClosetArea(kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID)), cAreaTypeWater);
	   aiUnitCreateCheat(cMyID, cUnitTypeTransportShipChinese, kbAreaGetCenter(areaID), "Spawn missing boat", 1);
	   xsEnableRule("StartingBoatFailsafe");
	   }
	   }
	   if ((kbGetTechStatus(cTechSecretsoftheTitans) > cTechStatusUnobtainable) && (kbGetTechStatus(cTechSecretsoftheTitans) < cTechStatusActive))
       TitanAvailable = true;
	   
	    int houseProtoID = cUnitTypeHouse;
        if (cMyCulture == cCultureAtlantean)
        houseProtoID = cUnitTypeManor;
		int CheckUnitPop = kbGetPopSlots(cMyID, cUnitTypeHoplite);  // <3 Loggy <3
		int maxHouses = kbGetBuildLimit(cMyID, houseProtoID);
	   	if ((maxHouses == -1) || (CheckUnitPop != 2))
		{
		UseStandardPop = true;
		aiEcho("Warning:  Modded Protox file detected, results may vary.");
		}
		if (cMyCulture == cCultureEgyptian)
		MyFortress = cUnitTypeMigdolStronghold;
        if (cMyCulture == cCultureGreek)
        MyFortress = cUnitTypeFortress;
        if (cMyCulture == cCultureNorse)
        MyFortress = cUnitTypeHillFort;
        if (cMyCulture == cCultureAtlantean)
        MyFortress = cUnitTypePalace;	
        if (cMyCulture == cCultureChinese)
        MyFortress = cUnitTypeCastle;
}

//==============================================================================
void initRethlAge2(void)
{
	// The Greeks are working as intended, so we're skipping that.
    
	if (cMyCiv == cCivHades)
    {   	
	xsEnableRuleGroup("HateScriptsH");
    }   

    if (cMyCiv == cCivIsis)
    {   	
	xsEnableRule("getFloodOfTheNile");
    }
    if (cMyCiv == cCivRa)		
	{	 
	xsEnableRule("getSkinOfTheRhino");
    }    
	if (cMyCiv == cCivSet)
    {	
	xsEnableRule("getFeral");
    }
	if (cMyCiv == cCivThor)
    {	 
	xsEnableRule("getPigSticker");
    }
	if (cMyCiv == cCivOdin)		
	{	
	xsEnableRule("getLoneWanderer");
	aiPlanDestroy(gLandExplorePlanID);
    }
	if (cMyCiv == cCivLoki)
    {
	xsEnableRule("getEyesInTheForest");
    }
	if (cMyCiv == cCivGaia)
    {	
	xsEnableRule("getChannels");
    }
	if (cMyCiv == cCivKronos)
    {	
	xsEnableRule("getFocus");
    }
	
	if (cMyCulture == cCultureChinese)
	{
	xsEnableRule("getEarthenWall");
    xsEnableRule("buildGarden");
	xsEnableRule("ChooseGardenResource");
	if (cMyCiv == cCivNuwa)
    {	
	xsEnableRule("getAcupuncture");	
	xsEnableRule("sendIdleTradeUnitsToRandomBase");
	xsEnableRule("tradeWithCaravans");
	xsEnableRule("maintainTradeUnits");
    }
	if (cMyCiv == cCivFuxi)
	xsEnableRule("getDomestication");	
	if (cMyCiv == cCivShennong)
	xsEnableRule("getWheelbarrow");
    }	
	
	if ((cRandomMapName == "highland") || (cRandomMapName == "nomad"))
	{
	gWaterMap=true;
	xsEnableRule("fishing");
	if (ShowAiEcho == true) aiEcho("Fishing enabled for Nomad and Highland map");
	}
	
	if (cRandomMapName == "valley of kings")
	xsEnableRule("BanditMigdolRemoval");
	

	//  Enable Dock defense. 
    xsEnableRule("DockDefenseMonitor");
    //HateScripts
    xsEnableRuleGroup("HateScripts");
	
	if ((bWallAllyMB == true) && (HasHumanAlly == true))
	xsEnableRule("WallAllyMB");
	
	if (bWallCleanup == true)
	xsEnableRuleGroup("WallCleanup");
	
    //Try to transport stranded Units.
	if (gTransportMap == true)
	xsEnableRule("TransportBuggedUnits");
	
	// Up Immortal count for chinese
	if (cMyCulture == cCultureChinese)
	aiPlanSetVariableInt(mChineseImmortal, cTrainPlanNumberToMaintain, 0, 6);
	// Other mil units to maintain
	xsEnableRule("maintainMilitaryTroops");
}	

//==============================================================================
// RULE ActivateRethOverridesAge 1-4
//==============================================================================
rule ActivateRethOverridesAge1
   minInterval 2
   active
   runImmediately
{
		if (gHuntingDogsASAP == true)
		xsEnableRule("HuntingDogsAsap");
		
		//Adds 0.1 (not even 1!) of all resources to fix a critical "startup-inventory" bug that can potentially block the AI from making vills until the first villager have returned any resource.
		aiResourceCheat(cMyID, cResourceFood, 0.1); 
		aiResourceCheat(cMyID, cResourceWood, 0.1);
		aiResourceCheat(cMyID, cResourceGold, 0.1);
		
		if ((gBuildWallsAtMainBase == true) && (mRusher == false) && (cvOkToBuildWalls == true))
            xsEnableRule("mainBaseAreaWallTeam1");
			
		xsDisableSelf();	   
    }

	
rule ActivateRethOverridesAge2
   minInterval 30
   active
{
    if (kbGetAge() > cAge1)
    {
		initRethlAge2();
		
		//CHINESE MINOR GOD SPECIFIC
        if (cMyCulture == cCultureChinese && kbGetTechStatus(cTechAge2Change) == cTechStatusActive)
        xsEnableRuleGroup("Change");
        if (cMyCulture == cCultureChinese && kbGetTechStatus(cTechAge2Huangdi) == cTechStatusActive)
        xsEnableRuleGroup("Huangdi");
        if (cMyCulture == cCultureChinese && kbGetTechStatus(cTechAge2Sunwukong) == cTechStatusActive)
        xsEnableRuleGroup("Sunwukong");
		
		//EGYPTIAN MINOR GOD SPECIFIC
        if (cMyCulture == cCultureEgyptian && kbGetTechStatus(cTechAge2Bast) == cTechStatusActive)
        xsEnableRuleGroup("Bast");
        if (cMyCulture == cCultureEgyptian && kbGetTechStatus(cTechAge2Ptah) == cTechStatusActive)
        xsEnableRuleGroup("Ptah");
        if (cMyCulture == cCultureEgyptian && kbGetTechStatus(cTechAge2Anubis) == cTechStatusActive)
        xsEnableRuleGroup("Anubis");
		
		//Norse MINOR GOD SPECIFIC
        if (cMyCulture == cCultureNorse && kbGetTechStatus(cTechAge2Forseti) == cTechStatusActive)
        xsEnableRuleGroup("Forseti");
        if (cMyCulture == cCultureNorse && kbGetTechStatus(cTechAge2Freyja) == cTechStatusActive)
        xsEnableRuleGroup("Freyja");
        if (cMyCulture == cCultureNorse && kbGetTechStatus(cTechAge2Heimdall) == cTechStatusActive)
        xsEnableRuleGroup("Heimdall");
		
		//Atlantean MINOR GOD SPECIFIC
        if (cMyCulture == cCultureAtlantean && kbGetTechStatus(cTechAge2Leto) == cTechStatusActive)
        xsEnableRuleGroup("Leto");
        if (cMyCulture == cCultureAtlantean && kbGetTechStatus(cTechAge2Prometheus) == cTechStatusActive)
        xsEnableRuleGroup("Prometheus");
        if (cMyCulture == cCultureAtlantean && kbGetTechStatus(cTechAge2Okeanus) == cTechStatusActive)
	    xsEnableRuleGroup("Oceanus");

	    if (CheatResources == true)
	    {
        aiResourceCheat(cMyID, cResourceFood, 300);
	    aiResourceCheat(cMyID, cResourceWood, 250);
	    aiResourceCheat(cMyID, cResourceGold, 300);
	    }
		
		xsEnableRule("activateObeliskClearingPlan"); // this also looks for villagers, don't get confused by the name.
		
		xsDisableSelf();    
           
    }
}

rule ActivateRethOverridesAge3
   minInterval 30
   active
{
    if (kbGetAge() > cAge2)
    {
        //CHINESE MINOR GOD SPECIFIC
		if (cMyCulture == cCultureChinese && kbGetTechStatus(cTechAge3Dabogong) == cTechStatusActive)
		{
        xsEnableRuleGroup("Dabogong");
		aiPlanSetVariableInt(cMonkMaintain, cTrainPlanNumberToMaintain, 0, 5);
		}
        if (cMyCulture == cCultureChinese && kbGetTechStatus(cTechAge3Hebo) == cTechStatusActive)
        xsEnableRuleGroup("Hebo");
        if (cMyCulture == cCultureChinese && kbGetTechStatus(cTechAge3Zhongkui) == cTechStatusActive)
        xsEnableRuleGroup("Zhongkui");
		
        //EGYPTIAN MINOR GOD SPECIFIC
		if (cMyCulture == cCultureEgyptian && kbGetTechStatus(cTechAge3Nephthys) == cTechStatusActive)
        xsEnableRuleGroup("Nephthys");
        if (cMyCulture == cCultureEgyptian && kbGetTechStatus(cTechAge3Sekhmet) == cTechStatusActive)
        xsEnableRuleGroup("Sekhmet");
        if (cMyCulture == cCultureEgyptian && kbGetTechStatus(cTechAge3Hathor) == cTechStatusActive)
		xsEnableRuleGroup("Hathor");

		
		//Norse MINOR GOD SPECIFIC
        if (cMyCulture == cCultureNorse && kbGetTechStatus(cTechAge3Skadi) == cTechStatusActive)
        xsEnableRuleGroup("Skadi");
        if (cMyCulture == cCultureNorse && kbGetTechStatus(cTechAge3Njord) == cTechStatusActive)
        xsEnableRuleGroup("Njord");
        if (cMyCulture == cCultureNorse && kbGetTechStatus(cTechAge3Bragi) == cTechStatusActive)
        xsEnableRuleGroup("Bragi");
		
		//Atlantean MINOR GOD SPECIFIC
        if (cMyCulture == cCultureAtlantean && kbGetTechStatus(cTechAge3Rheia) == cTechStatusActive)
        xsEnableRuleGroup("Rheia");
        if (cMyCulture == cCultureAtlantean && kbGetTechStatus(cTechAge3Theia) == cTechStatusActive)
		xsEnableRuleGroup("Theia");

        
        if (cMyCulture == cCultureAtlantean && kbGetTechStatus(cTechAge3Hyperion) == cTechStatusActive)
        xsEnableRuleGroup("Hyperion");		
		
        xsEnableRuleGroup("ArmoryAge2");
		
		if (cMyCiv == cCivPoseidon)
		xsEnableRule("buildManyBuildings");
		
	    if (CheatResources == true)
	    {
        aiResourceCheat(cMyID, cResourceFood, 600);
	    aiResourceCheat(cMyID, cResourceWood, 500);
	    aiResourceCheat(cMyID, cResourceGold, 600);
	    }		
		
		mRusher = false;
	    if (cMyCulture == cCultureChinese)
	    {
	    aiPlanSetVariableInt(eChineseHero, cTrainPlanNumberToMaintain, 0, 0);
	    aiPlanDestroy(eChineseHero);
	    }
	    
		if (cMyCiv == cCivRa)
	    {
			CPlanID=aiPlanCreate("Market Priest Empower", cPlanEmpower);
            if (CPlanID >= 0)
            {
                aiPlanSetEconomy(CPlanID, true);
                aiPlanAddUnitType(CPlanID, cUnitTypePriest, 0, 1, 1);
                aiPlanSetVariableInt(CPlanID, cEmpowerPlanTargetTypeID, 0, cUnitTypeMarket);
				aiPlanSetDesiredPriority(CPlanID, 69);							
				aiPlanSetActive(CPlanID);
            }
        }		
		
	    if (cMyCulture == cCultureEgyptian)
        xsEnableRule("rebuildSiegeCamp");
        
		if (aiGetWorldDifficulty() != cDifficultyEasy)
		{
		int MyCata = -1;
		if (cMyCulture == cCultureGreek)
		MyCata = cUnitTypePetrobolos;
		if (cMyCulture == cCultureEgyptian)
		MyCata = cUnitTypeCatapult;
		if (cMyCulture == cCultureNorse)
		MyCata = cUnitTypeBallista;
		if (cMyCulture == cCultureAtlantean)
		MyCata = cUnitTypeOnager;
		if (cMyCulture == cCultureChinese)
		MyCata = cUnitTypeSittingTiger;
		if (MyCata != -1)
        createSimpleMaintainPlan(MyCata, 4, false, kbBaseGetMainID(cMyID));
        xsEnableRule("buildForwardFortress");		
		}
		xsDisableSelf();  
    }
}

rule ActivateRethOverridesAge4
   minInterval 15
   active
{
    if (kbGetAge() > cAge3)
    {
	
        //CHINESE MINOR GOD SPECIFIC	
	    if (cMyCulture == cCultureChinese && kbGetTechStatus(cTechAge4Aokuang) == cTechStatusActive)
        xsEnableRuleGroup("Aokuang");
        if (cMyCulture == cCultureChinese && kbGetTechStatus(cTechAge4Xiwangmu) == cTechStatusActive)
        xsEnableRuleGroup("Xiwangmu");
        if (cMyCulture == cCultureChinese && kbGetTechStatus(cTechAge4Chongli) == cTechStatusActive)
		xsEnableRuleGroup("Chongli");
		
        //Egyptian MINOR GOD SPECIFIC	
	    if (cMyCulture == cCultureEgyptian && kbGetTechStatus(cTechAge4Horus) == cTechStatusActive)
        xsEnableRuleGroup("Horus");
        if (cMyCulture == cCultureEgyptian && kbGetTechStatus(cTechAge4Osiris) == cTechStatusActive)
		{
		xsEnableRuleGroup("Osiris");
	    eOsiris=aiPlanCreate("Son of Osiris Empower", cPlanEmpower);
        if (eOsiris >= 0)
        {
            aiPlanSetEconomy(eOsiris, true);
            aiPlanAddUnitType(eOsiris, cUnitTypePharaohofOsiris, 1, 1, 1);
            aiPlanSetVariableInt(eOsiris, cEmpowerPlanTargetTypeID, 0, cUnitTypeAbstractSettlement);
            aiPlanSetDesiredPriority(eOsiris, 91);
			aiPlanSetActive(eOsiris);
        }
	    Pempowermarket=aiPlanCreate("Pharaoh Secondary Empower", cPlanEmpower);
        if (Pempowermarket >= 0)
        {
            aiPlanSetEconomy(Pempowermarket, true);
            aiPlanAddUnitType(Pempowermarket, cUnitTypePharaohSecondary, 1, 1, 1);
            aiPlanSetVariableInt(Pempowermarket, cEmpowerPlanTargetTypeID, 0, cUnitTypeMarket);
			aiPlanSetDesiredPriority(Pempowermarket, 90);
			aiPlanSetActive(Pempowermarket);
        }		
		}
		
        if (cMyCulture == cCultureEgyptian && kbGetTechStatus(cTechAge4Thoth) == cTechStatusActive)
		{
		xsEnableRuleGroup("Thoth");
		int PhoenixReborn = createSimpleMaintainPlan(cUnitTypePhoenixFromEgg, 3, false);
		aiPlanSetVariableBool(PhoenixReborn, cTrainPlanUseMultipleBuildings, 0, true);
		aiPlanSetVariableInt(PhoenixReborn, cTrainPlanBuildFromType, 0, cUnitTypePhoenixEgg); 
		}
	
		
		//Norse MINOR GOD SPECIFIC
        if (cMyCulture == cCultureNorse && kbGetTechStatus(cTechAge4Tyr) == cTechStatusActive)
        xsEnableRuleGroup("Tyr");
        if (cMyCulture == cCultureNorse && kbGetTechStatus(cTechAge4Baldr) == cTechStatusActive)
        xsEnableRuleGroup("Baldr");
        if (cMyCulture == cCultureNorse && kbGetTechStatus(cTechAge4Hel) == cTechStatusActive)
        xsEnableRuleGroup("Hel");
		
		//Atlantean MINOR GOD SPECIFIC
        if (cMyCulture == cCultureAtlantean && kbGetTechStatus(cTechAge4Atlas) == cTechStatusActive)
        xsEnableRuleGroup("Atlas");
        if (cMyCulture == cCultureAtlantean && kbGetTechStatus(cTechAge4Helios) == cTechStatusActive)
        xsEnableRuleGroup("Helios");
        if (cMyCulture == cCultureAtlantean && kbGetTechStatus(cTechAge4Hekate) == cTechStatusActive)
        xsEnableRuleGroup("Hekate");				
		
    
	    if (kbGetTechStatus(cTechSecretsoftheTitans) > cTechStatusObtainable)
	    xsEnableRule("repairTitanGate");
		if (aiGetWorldDifficulty() > cDifficultyModerate && (aiGetGameMode() != cGameModeDeathmatch))
		xsEnableRule("randomUpgrader");
		
	    if (CheatResources == true)
	    {
        aiResourceCheat(cMyID, cResourceFood, 800);
	    aiResourceCheat(cMyID, cResourceWood, 800);
	    aiResourceCheat(cMyID, cResourceGold, 900);
	    }		
        if (cMyCulture == cCultureEgyptian && kbGetTechStatus(cTechAge2Bast) == cTechStatusActive) // Sphinx maintain, because they're just that good.
		createSimpleMaintainPlan(cUnitTypeSphinx, 2, false, kbBaseGetMainID(cMyID));
		// Unit picker
		
		if (cMyCiv == cCivZeus)
		kbUnitPickSetPreferenceFactor(gLateUPID, cUnitTypeMyrmidon, 0.5+aiRandInt(3));
		if (cMyCulture == cCultureChinese)
		{
		kbUnitPickSetPreferenceFactor(gLateUPID, cUnitTypeScoutChinese, 0.1);
		if (cMyCiv == cCivShennong)
		kbUnitPickSetPreferenceFactor(gLateUPID, cUnitTypeFireLanceShennong, 0.9);
		else kbUnitPickSetPreferenceFactor(gLateUPID, cUnitTypeFireLance, 0.8);
		}
		if (cMyCulture == cCultureNorse)
		{
		kbUnitPickSetPreferenceFactor(gLateUPID, cUnitTypeJarl, 0.7+aiRandInt(2));
		kbUnitPickSetPreferenceFactor(gLateUPID, cUnitTypeHuskarl, 0.5+aiRandInt(2));
		kbUnitPickSetPreferenceFactor(gLateUPID, cUnitTypeAbstractArcher, 0.2+aiRandInt(4)); // Ok to Bogsveigir now
		}
		if (cMyCulture == cCultureAtlantean)
		{
		kbUnitPickSetPreferenceFactor(gLateUPID, cUnitTypeTridentSoldier, 0.6+aiRandInt(3));
		kbUnitPickSetPreferenceFactor(gLateUPID, cUnitTypeArcherAtlantean, 0.7+aiRandInt(3));
		kbUnitPickSetPreferenceFactor(gLateUPID, cUnitTypeRoyalGuard, 0.5+aiRandInt(5));
		}		
		//
		
		xsDisableSelf();  
    }
}	  
//==============================================================================
// wonder death handler
//==============================================================================
void wonderDeathHandler(int playerID = -1)
{
   if (playerID == cMyID)
   {
      aiCommsSendStatement(aiGetMostHatedPlayerID(), cAICommPromptAIWonderDestroyed, -1);
      return;
   }
   if (playerID == aiGetMostHatedPlayerID())
      aiCommsSendStatement(playerID, cAICommPromptPlayerWonderDestroyed, -1);
}
//==============================================================================
// relic handler
//==============================================================================
void relicHandler(int relicID = -1)
{
   if (aiRandInt(30) != 0)
      return;

   for (i=1; < cNumberPlayers)
   {
      if (i == cMyID)
         continue;

      //Only a 33% chance for either of these chats
      if (kbIsPlayerAlly(i) == true)
      {
         if (relicID != -1)
         {
            //We don't need to know where you picked up that damn relic
			
            aiCommsSendStatement(i, cAICommPromptTakingAllyRelic, -1);
         }
         else 
            aiCommsSendStatement(i, cAICommPromptTakingAllyRelic, -1);
      }
      else 
         aiCommsSendStatement(i, cAICommPromptTakingEnemyRelic, -1);
   }
}

//==============================================================================
// RULE HuntingDogsAsap
//==============================================================================
rule HuntingDogsAsap
   minInterval 4
   inactive
{
   
   int HuntingDogsUpgBuilding = cUnitTypeGranary;
   if (cMyCulture == cCultureChinese)
   HuntingDogsUpgBuilding = cUnitTypeStoragePit;
   if (cMyCulture == cCultureAtlantean)
   HuntingDogsUpgBuilding = cUnitTypeGuild;
   
   
   if ((WaitForDock == true) && (kbGetAge() < cAge2) || (cMyCulture == cCultureAtlantean) && (kbUnitCount(cMyID, cUnitTypeManor, cUnitStateAlive) < 1))
   return;

      if (cMyCulture != cCultureAtlantean && cMyCulture != cCultureNorse && kbUnitCount(cMyID, HuntingDogsUpgBuilding, cUnitStateAlive) < 1)
	  return;
   
   if (gHuntingDogsASAP == true && aiPlanGetIDByTypeAndVariableType(cPlanProgression, cProgressionPlanGoalTechID, cTechHuntingDogs) < 0)
   {
	   //Hunting dogs.
	   int huntingDogsPlanID=aiPlanCreate("getHuntingDogs", cPlanProgression);
	   if (huntingDogsPlanID != 0)
	   {
	   	   aiPlanSetVariableInt(huntingDogsPlanID, cProgressionPlanGoalTechID, 0, cTechHuntingDogs);
		   aiPlanSetDesiredPriority(huntingDogsPlanID, 25);
		   aiPlanSetEscrowID(huntingDogsPlanID, cEconomyEscrowID);
		   aiPlanSetActive(huntingDogsPlanID);
		   xsDisableSelf();
	   }
   } 
}   
  
//==============================================================================
// RULE ALLYCatchUp
//==============================================================================
rule ALLYCatchUp   // a reverse-tweaked updatePlayerToAttack rule to find allies and boost their eco.
   minInterval 45
   maxInterval 80
   inactive
   Group Donations
{
  if  (aiGetGameMode() != cGameModeConquest && aiGetGameMode() != cGameModeSupremacy)
  {
        xsDisableSelf();
        return;    
    }
	xsSetRuleMinIntervalSelf(40+aiRandInt(18));
    static int lastTargetPlayerIDSaveTime = -1;
    static int lastTargetPlayerID = -1;
    static bool increaseStartIndex = false;
    int Tcs = kbUnitCount(cMyID, cUnitTypeAbstractSettlement, cUnitStateAlive);
    if ((Tcs < 1) || (kbGetAge() < cAge2) || (xsGetTime() < 8*60*1000))
    return;
    
    static int startIndex = -1;
    if (increaseStartIndex == true)
    {
        if (startIndex >= cNumberPlayers - 1)
            startIndex = 0;
        else
            startIndex = startIndex + 1;
        increaseStartIndex = false;
    }
    
    if ((startIndex < 0) || (xsGetTime() > lastTargetPlayerIDSaveTime + (1)*1*1000))
    {
        startIndex = aiRandInt(cNumberPlayers);
    }

    int comparePlayerID = -1;
    for (i = 0; < cNumberPlayers)
    {
        //If we're past the end of our players, go back to the start.
        int actualIndex = i + startIndex;
        if (actualIndex >= cNumberPlayers)
            actualIndex = actualIndex - cNumberPlayers;
        if ((actualIndex <= 0) || (actualIndex == cMyID))
            continue;
        if ((kbIsPlayerAlly(actualIndex) == true) && 
		(kbIsPlayerResigned(actualIndex) == false) && 
		(kbHasPlayerLost(actualIndex) == false))
        {
            comparePlayerID = actualIndex;
            if (actualIndex == lastTargetPlayerID)
            {
                increaseStartIndex = true;
                continue;
            }
            break;
        }
    }
    int actualPlayerID = comparePlayerID;
    if (actualPlayerID != lastTargetPlayerID)
    {
        lastTargetPlayerID = actualPlayerID;
        lastTargetPlayerIDSaveTime = xsGetTime();
    }

    if (actualPlayerID != -1)
    {
	    int iTcs = kbUnitCount(actualPlayerID, cUnitTypeAbstractSettlement, cUnitStateAlive);
		int iMarkets = kbUnitCount(actualPlayerID, cUnitTypeMarket, cUnitStateAlive);
	   	int houseProtoID = cUnitTypeHouse;
        if (kbGetCultureForPlayer(actualPlayerID) == cCultureAtlantean)
        houseProtoID = cUnitTypeManor;
	    int iHouses = kbUnitCount(actualPlayerID, houseProtoID, cUnitStateAlive);
		int Combined = iHouses + iTcs;
		if (Combined < 1)
		return;
	   
	    float foodSupply = kbResourceGet(cResourceFood);
        float goldSupply = kbResourceGet(cResourceGold);
	    float woodSupply = kbResourceGet(cResourceWood);
	   
		   if ((kbGetAgeForPlayer(actualPlayerID) < 2) && (iTcs >= 1) && (kbGetAge() > cAge3) && (foodSupply > 1000) && (goldSupply > 800))
		   {
	       aiTribute(actualPlayerID, cResourceFood, 800);
		   aiTribute(actualPlayerID, cResourceGold, 600);
		   xsSetRuleMinIntervalSelf(60);
		   if (ShowAiEcho == true) aiEcho("Tributing 800 food and 600 gold to one of my allies!"); // Take a break too.
		   return;
		   }
		   if ((kbGetAgeForPlayer(actualPlayerID) < 3) && (kbGetAgeForPlayer(actualPlayerID) == 2) && (iTcs >= 1) && (iMarkets >= 1) && (kbGetAge() > cAge3) && (foodSupply > 1500) && (goldSupply > 1500))
		   {
	       aiTribute(actualPlayerID, cResourceFood, 1000);
		   aiTribute(actualPlayerID, cResourceGold, 1000);
		   if (ShowAiEcho == true) aiEcho("Tributing 1000 food and 1000 gold to one of my allies!"); // Take a longer break too.
		   xsSetRuleMinIntervalSelf(75);
		   return;
		   }
		   else
		   {
           int donateFAmount = 100;
		   int donateWAmount = 100;
		   int donateGAmount = 100;
		   int fAmount = 1600;
		   int wAmount = 1750;
		   int gAmount = 2000;
		   int VillagerScore = kbUnitCount(actualPlayerID, cUnitTypeAbstractVillager, cUnitStateAlive);
		   
		   if (kbGetCultureForPlayer(actualPlayerID) == cCultureAtlantean)
		   VillagerScore = VillagerScore * 3;
		   
		   if (aiGetWorldDifficulty() > cDifficultyHard)
		   {
		   if (foodSupply > 5000)
		   donateFAmount = 1000;
		   if (woodSupply > 3500)
		   donateWAmount = 750;
		   if (goldSupply > 5000)
		   donateGAmount = 1000;	   
		   }
		   if (foodSupply > fAmount)
		   aiTribute(actualPlayerID, cResourceFood, donateFAmount);
		   if (woodSupply > wAmount)
		   aiTribute(actualPlayerID, cResourceWood, donateWAmount);
		   if (goldSupply > gAmount)
		   aiTribute(actualPlayerID, cResourceGold, donateGAmount);
		   if (ShowAiEcho == true) aiEcho("Tributing some spare resources to one of my allies!");
		   
		   if ((VillagerScore <= 6) && (foodSupply > 350) && (kbGetAge() > cAge2)) // Ally appears to be dying, try to save it!
		   {
		     if (kbGetCultureForPlayer(actualPlayerID) == cCultureAtlantean)
		     {
		      aiTribute(actualPlayerID, cResourceFood, 125);
		      if (woodSupply > 125)
		      aiTribute(actualPlayerID, cResourceWood, 25);
		     }
		   else 
		   aiTribute(actualPlayerID, cResourceFood, 100);
		   }
		   }
    }
}
 //==============================================================================
// RULE introChat
//==============================================================================
rule introChat
   minInterval 10
   active
{
   if (aiGetWorldDifficulty() != cDifficultyEasy)
   {
      for (i=1; < cNumberPlayers)
      {
         if (i == cMyID)
            continue;
         if (kbIsPlayerAlly(i) == true)
            continue;
         if (kbIsPlayerHuman(i) == true)
            aiCommsSendStatement(i, cAICommPromptIntro, -1); 
      }
   }
   xsDisableSelf();
}

//==============================================================================
// RULE myAgeTracker
//==============================================================================
rule myAgeTracker
   minInterval 60
   active
{
   static bool bMessage=false;
   static int messageAge=-1;

   //Disable this in deathmatch.
   if (aiGetGameMode() == cGameModeDeathmatch)
   {
      xsDisableSelf();
      return;
   }

   //Only the captain does this.
   if (aiGetCaptainPlayerID(cMyID) != cMyID)
      return;

   //Are we greater age than our most hated enemy?
   int myAge=kbGetAge();
   int hatedPlayerAge=kbGetAgeForPlayer(aiGetMostHatedPlayerID());

   //Reset the message counter if we have changed ages.
   if (bMessage == true)
   {
      if (messageAge == myAge)
         return;
      bMessage=false;
   }

   //Make a message??
   if ((myAge > hatedPlayerAge) && (bMessage == false))
   {
      bMessage=true;
      messageAge=myAge;
      aiCommsSendStatement(aiGetMostHatedPlayerID(), cAICommPromptAIWinningAgeRace, -1);
   }
   if ((hatedPlayerAge > myAge) && (bMessage == false))
   {
      bMessage=true;
      messageAge=myAge;
      aiCommsSendStatement(aiGetMostHatedPlayerID(), cAICommPromptAILosingAgeRace, -1);
   }

   //Stop when we reach the finish line.
   if (myAge == cAge4)
      xsDisableSelf();
}

//==============================================================================
// RULE Helpme
//==============================================================================
rule Helpme
   minInterval 23
   inactive
{
   static bool messageSent=false;
   //Set our min interval back to 23 if it has been changed.
   if (messageSent == true)
   {
      xsSetRuleMinIntervalSelf(23);
      messageSent=false;
   }

   //Get our main base.
   int mainBaseID=kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
      return;

   //Get the time under attack.
   int secondsUnderAttack=kbBaseGetTimeUnderAttack(cMyID, mainBaseID);
   if (secondsUnderAttack < 42)
         return;

   vector location=kbBaseGetLastKnownDamageLocation(cMyID, kbBaseGetMainID(cMyID));
   for (i=1; < cNumberPlayers)
   {
      if (i == cMyID)
         continue;
      if(kbIsPlayerAlly(i) == true)
         if( CanIChat == true ) aiCommsSendStatementWithVector(i, cAICommPromptHelpHere, -1, location);
   } 
   
   //Keep the books
   messageSent=true;
   xsSetRuleMinIntervalSelf(600);  
}

//==============================================================================
// IHateSiege
//==============================================================================
rule IHateSiege
   minInterval 5
   inactive
   group HateScripts
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;

   if (aiGetWorldDifficulty() == cDifficultyEasy)
   {
	xsDisableSelf();
	return;
   }

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
		kbUnitQuerySetUnitType(unitQueryID, cUnitTypeLogicalTypeLandMilitary);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
			kbUnitQuerySetMaximumDistance(unitQueryID, 30);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeAbstractSiegeWeapon);
	    kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 32);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   
	    int NoArcherPlease = kbUnitQueryGetResult(unitQueryID, i);
        if (kbUnitIsType(NoArcherPlease, cUnitTypeAbstractSiegeWeapon) || 
		(kbUnitIsType(NoArcherPlease, cUnitTypeAbstractArcher) && (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0),cUnitTypeFireLance) != true)) ||
		(kbUnitIsType(NoArcherPlease, cUnitTypeAbstractArcher) && (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0),cUnitTypeFireLanceShennong) != true)) ||
		(kbUnitIsType(NoArcherPlease, cUnitTypeAbstractInfantry) && (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0),cUnitTypeFireLance) == true)) ||
		(kbUnitIsType(NoArcherPlease, cUnitTypeAbstractInfantry) && (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0),cUnitTypeFireLanceShennong) == true)) ||
		(kbUnitIsType(NoArcherPlease, cUnitTypeAbstractInfantry) && (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0),cUnitTypeChieroballista) == true)) ||
		(kbUnitIsType(NoArcherPlease, cUnitTypeHeroChineseMonk)) || (kbUnitIsType(NoArcherPlease, cUnitTypeHeroRagnorok)) || (kbUnitIsType(NoArcherPlease, cUnitTypePriest))
		|| (kbUnitIsType(NoArcherPlease, cUnitTypeAbstractPharaoh)) || (kbUnitIsType(NoArcherPlease, cUnitTypeMythUnit)))
            continue;
		
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		vector Location = kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i));
		int NumBSelf = getNumUnits(cUnitTypeBuilding, cUnitStateAlive, -1, cMyID, Location, 36.0);
		int NumBAllies = getNumUnitsByRel(cUnitTypeBuilding, cUnitStateAlive, -1, cPlayerRelationAlly, Location, 36.0, true);
		int Combined = NumBSelf + NumBAllies;
		if ((Combined > 0) && (equal(Location, cInvalidVector) == false))
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}

//==============================================================================
// tacticalHeroAttackMyth
//==============================================================================
rule tacticalHeroAttackMyth
   minInterval 5
   inactive
   group HateScripts
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;
   static bool RunOnlyOnce = false;
   
   if (aiGetWorldDifficulty() == cDifficultyEasy)
   {
	xsDisableSelf();
	return;
   }
   
   if (kbUnitCount(cMyID, cUnitTypeHero) < 1)
   return;
   
   		if (cMyCulture == cCultureGreek && RunOnlyOnce == false)
		{
		static int Hero1ID = -1;
		static int Hero2ID = -1;
		static int Hero3ID = -1;
		static int Hero4ID = -1;
		if (cMyCiv == cCivZeus)
        {
            Hero1ID = cUnitTypeHeroGreekJason;
            Hero2ID = cUnitTypeHeroGreekOdysseus;
            Hero3ID = cUnitTypeHeroGreekHeracles;
            Hero4ID = cUnitTypeHeroGreekBellerophon;			
        }
        else if (cMyCiv == cCivPoseidon)
        {
            Hero1ID = cUnitTypeHeroGreekTheseus;
            Hero2ID = cUnitTypeHeroGreekHippolyta;
            Hero3ID = cUnitTypeHeroGreekAtalanta;
            Hero4ID = cUnitTypeHeroGreekPolyphemus;			
        }
        else if (cMyCiv == cCivHades)
        {
            Hero1ID = cUnitTypeHeroGreekAjax;
            Hero2ID = cUnitTypeHeroGreekChiron;
            Hero3ID = cUnitTypeHeroGreekAchilles;
            Hero4ID = cUnitTypeHeroGreekPerseus;			
        }
		if (ShowAiEcho == true || ShowAiTestEcho == true) aiEcho("Heroes set");
		RunOnlyOnce = true;
		}

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Hero Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
		if (cMyCulture == cCultureChinese)
		kbUnitQuerySetUnitType(unitQueryID, cUnitTypeHeroChineseImmortal);
		else kbUnitQuerySetUnitType(unitQueryID, cUnitTypeHero);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeMythUnit);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 24);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   
	    if (cMyCulture != cCultureEgyptian)
		{
	    int NoMeleeHeroPlease = kbUnitQueryGetResult(unitQueryID, i);
	   	int NoFlyingPlease = kbUnitQueryGetResult(enemyQueryID, 0);
		if ((kbUnitIsType(NoFlyingPlease, cUnitTypePegasus) || kbUnitIsType(NoFlyingPlease, cUnitTypeRoc) || kbUnitIsType(NoFlyingPlease, cUnitTypeFlyingMedic) || 
		kbUnitIsType(NoFlyingPlease, cUnitTypeStymphalianBird) || kbUnitIsType(NoFlyingPlease, cUnitTypePhoenix) || kbUnitIsType(NoFlyingPlease, cUnitTypeVermilionBird) || kbUnitIsType(NoFlyingPlease, cUnitTypeEarthDragon) ||
		kbUnitIsType(NoFlyingPlease, cUnitTypeRaven)))
		{
            if (cMyCulture == cCultureGreek) 
		    {
		    if (kbUnitIsType(NoMeleeHeroPlease, Hero1ID) || kbUnitIsType(NoMeleeHeroPlease, Hero3ID) || kbUnitIsType(NoMeleeHeroPlease, Hero4ID))    
			continue;
			}
            if (cMyCulture == cCultureNorse) 
		    {
		    if (kbUnitIsType(NoMeleeHeroPlease, cUnitTypeHeroNorse) || kbUnitIsType(NoMeleeHeroPlease, cUnitTypeHeroRagnorok))    
			continue;
		    }	
            if (cMyCulture == cCultureAtlantean) 
		    {
		    if (kbUnitIsType(NoMeleeHeroPlease, cUnitTypeSwordsmanHero) || kbUnitIsType(NoMeleeHeroPlease, cUnitTypeTridentSoldierHero) || 
		    kbUnitIsType(NoMeleeHeroPlease, cUnitTypeRoyalGuardHero) || kbUnitIsType(NoMeleeHeroPlease, cUnitTypeMacemanHero) || kbUnitIsType(NoMeleeHeroPlease, cUnitTypeLancerHero))    
			continue;
		    }
	
	   }
	   if ((kbUnitIsType(NoMeleeHeroPlease, cUnitTypeHeroChineseMonk)) || (kbUnitIsType(NoMeleeHeroPlease, cUnitTypeHeroRagnorok)))   
	   continue;	   
	   }

	   
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}   

//==============================================================================
// IHateMonks
//==============================================================================
rule IHateMonks
   minInterval 6
   inactive
   group HateScripts
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;

   if (aiGetWorldDifficulty() == cDifficultyEasy)
   {
	xsDisableSelf();
	return;
   }

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
		kbUnitQuerySetUnitType(unitQueryID, cUnitTypeAbstractArcher);
		kbUnitQuerySetMaximumDistance(unitQueryID, 20);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeHeroChineseMonk);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 20);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}
//==============================================================================
// IHateBuildingsHadesSpecial
//==============================================================================
rule IHateBuildingsHadesSpecial
   minInterval 5
   inactive
   group HateScriptsH
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;

   if ((aiGetWorldDifficulty() == cDifficultyEasy) || (cMyCiv != cCivHades))
   {
	xsDisableSelf();
	return;
   }
   
   if (kbUnitCount(cMyID, cUnitTypeCrossbowman) < 1)
   return;
   
   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypeCrossbowman);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeLogicalTypeBuildingsNotWalls);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAny);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 34);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   
        if ((kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeSettlement) == true) || (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeAbstractFarm) == true) 
		|| (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeHealingSpringObject) == true) || (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypePlentyVault) == true)
		|| (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeHesperidesTree) == true))
            continue;
	   
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}

//==============================================================================
// BanditMigdolRemoval // Valley of Kings special
//==============================================================================
rule BanditMigdolRemoval
   minInterval 8
   inactive
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;

   if (cRandomMapName != "valley of kings")
   {
	xsDisableSelf();
	return;
   }

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypeLogicalTypeLandMilitary);
			kbUnitQuerySetMaximumDistance(unitQueryID, 30);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 8)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeBanditMigdol);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 30);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   vector Location = kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i));
	   int NumSelf = getNumUnits(cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive, -1, cMyID, Location, 40.0);
	   
	   if ((numberFoundTemp > 0) && (NumSelf > 10) && (equal(Location, cInvalidVector) == false))	   
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}
rule AntiInf
minInterval 5
inactive 
group HateScripts
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;

   if (aiGetWorldDifficulty() == cDifficultyEasy)
   {
	xsDisableSelf();
	return;
   }

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
		if (cMyCulture == cCultureGreek)
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypeToxotes);
        if (cMyCulture == cCultureEgyptian)
		    kbUnitQuerySetUnitType(unitQueryID, cUnitTypeChariotArcher);
        if (cMyCulture == cCultureNorse)
		    kbUnitQuerySetUnitType(unitQueryID, cUnitTypeThrowingAxeman);
        if (cMyCulture == cCultureAtlantean)
		    kbUnitQuerySetUnitType(unitQueryID, cUnitTypeArcherAtlantean);
        if (cMyCulture == cCultureChinese)
            kbUnitQuerySetUnitType(unitQueryID, cUnitTypeChuKoNu);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeAbstractInfantry);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		if (cMyCulture == cCultureNorse)
		kbUnitQuerySetMaximumDistance(enemyQueryID, 12);
		else kbUnitQuerySetMaximumDistance(enemyQueryID, 20);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   
       if ((kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeHuskarl) == true) || (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeTridentSoldier) == true))
            continue;
			
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}

rule AntiArch
minInterval 5  
inactive
group HateScripts 
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;

   if (aiGetWorldDifficulty() == cDifficultyEasy)
   {
	xsDisableSelf();
	return;
   }

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
		if (cMyCulture == cCultureGreek)
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypePeltast);
        if (cMyCulture == cCultureEgyptian)
		    kbUnitQuerySetUnitType(unitQueryID, cUnitTypeSlinger);
        if (cMyCulture == cCultureNorse)
		    kbUnitQuerySetUnitType(unitQueryID, cUnitTypeBogsveigir);
        if (cMyCulture == cCultureAtlantean)
		    kbUnitQuerySetUnitType(unitQueryID, cUnitTypeJavelinCavalry);
        if (cMyCulture == cCultureChinese)
            kbUnitQuerySetUnitType(unitQueryID, cUnitTypeMountedArcher);		
		
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);		
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		if (cMyCulture == cCultureChinese)
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeAbstractCavalry);
        else if (cMyCulture == cCultureNorse)	
        kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeLogicalTypeIdleCivilian);		
		else kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeAbstractArcher);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
	    kbUnitQuerySetMaximumDistance(enemyQueryID, 18);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   
        if (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeShip) == true)
         continue;
			
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}
//==============================================================================
// IHateVillagers
//==============================================================================
rule IHateVillagers
   minInterval 5
   inactive
   group HateScripts
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;

   if (aiGetWorldDifficulty() == cDifficultyEasy)
   {
	xsDisableSelf();
	return;
   }

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Unit Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
		kbUnitQuerySetUnitType(unitQueryID, cUnitTypeAbstractArcher);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeLogicalTypeIdleCivilian); // also caravans 
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 20);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}

//==============================================================================
// IHateUnderworldPassages
//==============================================================================
rule IHateUnderworldPassages
   minInterval 10
   inactive
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;


   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypeLogicalTypeLandMilitary);
			kbUnitQuerySetMaximumDistance(unitQueryID, 20);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeTunnel);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 20);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}

//==============================================================================
// IHateBuildingsBeheAndScarab
//==============================================================================
rule IHateBuildingsBeheAndScarab
   minInterval 12
   inactive
   group Sekhmet
   group Rheia
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;
   static int MythUnit=-1;
   

   if ((aiGetWorldDifficulty() == cDifficultyEasy) || (cMyCulture != cCultureAtlantean) && (cMyCulture != cCultureEgyptian))
   {
	xsDisableSelf();
	return;
   }
   if (cMyCulture == cCultureAtlantean)
   MythUnit = cUnitTypeBehemoth;
   else MythUnit = cUnitTypeScarab;
   
   if (kbUnitCount(cMyID, MythUnit) < 1)
   {
	xsSetRuleMinIntervalSelf(65);
	return;
   }   
    xsSetRuleMinIntervalSelf(12);
   

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
			if (cMyCulture == cCultureEgyptian)
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypeScarab);
			if (cMyCulture == cCultureAtlantean)
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypeBehemoth);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeLogicalTypeBuildingsNotWalls);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 26);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   
        if ((kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeSettlement) == true) || (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeAbstractFarm) == true) 
		|| (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeHealingSpringObject) == true) || (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypePlentyVault) == true)
		|| (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeHesperidesTree) == true))
            continue;
	   
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}

//==============================================================================
// IHateGates 
//==============================================================================
rule IHateGates
   minInterval 5
   inactive
   group HateScripts
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;

   if (aiGetWorldDifficulty() == cDifficultyEasy)
   {
	xsDisableSelf();
	return;
   }
   
   if (kbUnitCount(cMyID, cUnitTypeAbstractSiegeWeapon) < 1)
   return;

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypeAbstractSiegeWeapon);			
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeGate);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 30);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   
			
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}

//==============================================================================
// IHateBuildingsSiege
//==============================================================================
rule IHateBuildingsSiege
   minInterval 5
   inactive
   group HateScripts
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;

   if (aiGetWorldDifficulty() == cDifficultyEasy)
   {
	xsDisableSelf();
	return;
   }
  
   if (kbUnitCount(cMyID, cUnitTypeAbstractSiegeWeapon) < 1)
   return;
   
   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
        kbUnitQuerySetUnitType(unitQueryID, cUnitTypeAbstractSiegeWeapon);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeLogicalTypeBuildingsNotWalls);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 34);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   
        if ((kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeSettlement) == true) || (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeAbstractFarm) == true) 
		|| (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeHealingSpringObject) == true) || (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypePlentyVault) == true)
		|| (kbUnitIsType(kbUnitQueryGetResult(enemyQueryID, 0), cUnitTypeHesperidesTree) == true))
            continue;
			
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}
//==============================================================================
// IHateGatesMeleeSiege // for Ram and Siphon 
//==============================================================================
rule IHateGatesMeleeSiege
   minInterval 5
   inactive
   group HateScripts
{
   static int unitQueryID=-1;
   static int enemyQueryID=-1;

   if ((aiGetWorldDifficulty() == cDifficultyEasy) || (cMyCulture != cCultureAtlantean) && (cMyCulture != cCultureNorse))
   {
	xsDisableSelf();
	return;
   }
   
   if (kbUnitCount(cMyID, cUnitTypeAbstractSiegeWeapon) < 1)
   return;
   
   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
		if (cMyCulture == cCultureNorse)
		kbUnitQuerySetUnitType(unitQueryID, cUnitTypePortableRam);	
		else if (cMyCulture == cCultureAtlantean)
		kbUnitQuerySetUnitType(unitQueryID, cUnitTypeFireSiphon);				
	   kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

   if (siegeFound < 1)
	return;

   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationEnemy);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeGate);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAlive);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 10);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   
			
	   if (numberFoundTemp > 0)
	   {
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitWork(kbUnitQueryGetResult(unitQueryID, i), enemyUnitIDTemp);
	   }
   }
}

//==============================================================================
// MonitorAllies
//==============================================================================
rule MonitorAllies
minInterval 1  
inactive
{
   xsSetRuleMinIntervalSelf(181);
   static bool checkTeamStatus=true;
   if (checkTeamStatus == true)
   {
      for (i=1; < cNumberPlayers)
      {
         if (i == cMyID)
            continue;
         if (kbIsPlayerMutualAlly(i) == true && kbIsPlayerResigned(i) == false && kbIsPlayerValid(i) == true && kbHasPlayerLost(i) == false)
		 {
         xsEnableRuleGroup("Donations");
		 xsEnableRule("defendAlliedBase");
		 xsEnableRule("Helpme");
		 IhaveAllies = true;
		 if ((kbIsPlayerHuman(i) == true) && (kbIsPlayerMutualAlly(i) == true))
		 HasHumanAlly = true;
		 return;
		 }
		 else
		 {
		  xsDisableRuleGroup("Donations"); 
		  xsDisableRule("defendAlliedBase");
		  xsDisableRule("Helpme");
		  IhaveAllies = false;
		 }
	}
}
}

// KOTH COMPLEX both Land and Water
//==============================================================================
// ClaimKoth
// @param where: the position of the Vault to claim
// @param baseID: the base to get the units from. If left unspecified, the
//                funct will try to find units
//==============================================================================
void ClaimKoth(vector where=cInvalidVector, int baseToUseID=-1)
{
    if (ShowAiEcho == true) aiEcho("claimSettlement:");    
	
    int baseID=-1;
    int startAreaID=-1;
	int startAreaID2=-1;
    static vector KOTHPlace = cInvalidVector;
    KOTHPlace = kbUnitGetPosition(gKOTHPlentyUnitID);	
	int NumSelf = getNumUnits(cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive, -1, cMyID, KOTHPlace, 25.0);
    
    int transportPUID=kbTechTreeGetUnitIDTypeByFunctionIndex(cUnitFunctionWaterTransport, 0);

    int BoatToUse=kbUnitCount(cMyID, transportPUID, cUnitStateAlive);
	
    if (BoatToUse <= 0)
    {
    xsEnableRule("KOTHMonitor");
	if (ShowAiEcho == true) aiEcho("No ships, destroying plans!");
	DestroyTransportPlan = true;
	return;
    }
	
	
	int IdleTransportPlans = aiGetNumberIdlePlans(cPlanTransport);
	if (IdleTransportPlans >= 1)
	{
	DestroyHTransportPlan = true;
	xsEnableRule("KOTHMonitor");
    }

    // user specified a base, use it!
    if ( baseToUseID != -1 )
    {
        baseID = baseToUseID;
    }
    
    

    if ( baseID == -1 ) // no base found, use mainbase!
    {
        baseID = kbBaseGetMainID(cMyID);
    }

    vector baseLoc = kbBaseGetLocation(cMyID, baseID); 
    startAreaID = kbAreaGetIDByPosition(baseLoc);
	int ActiveTransportPlans = aiPlanGetNumber(cPlanTransport, -1, true);
	//aiEcho("ActiveTransportPlans:  "+ActiveTransportPlans+" ");
    if (ActiveTransportPlans >= 1)
	{
     if (ShowAiEcho == true) aiEcho("I have 1 active transport plan, returning.");
	 return;
    }

	if (KoTHOkNow == true)
    {
	baseID = KOTHBASE;
    KOTHTHomeTransportPlan=createTransportPlan("GO HOME AGAIN", kbAreaGetIDByPosition(where), startAreaID, false, transportPUID, 97, baseID);
	aiPlanAddUnitType(KOTHTHomeTransportPlan, cUnitTypeHumanSoldier, 3, 6, 10);
    KoTHOkNow = false;
	if (ShowAiEcho == true) aiEcho("GO HOME TRIGGERED");
    return;													  
    }
    else 
	{
    KOTHTransportPlan=createTransportPlan("TRANSPORT TO KOTH VAULT", startAreaID, kbAreaGetIDByPosition(where), false, transportPUID, 80, baseID);
	
	
	if (kbGetTechStatus(cTechEnclosedDeck) == cTechStatusActive)
    aiPlanAddUnitType(KOTHTransportPlan, cUnitTypeHumanSoldier, 10, 20, 20);
	else aiPlanAddUnitType(KOTHTransportPlan, cUnitTypeHumanSoldier, 5, 10, 10);
	
	
	if (ShowAiEcho == true) aiEcho("GO TO VAULT TRIGGERED");
	}
}

//==============================================================================
rule GetKOTHVault
    minInterval 1 //starts in cAge3
    inactive
{
    if (ShowAiEcho == true) aiEcho("FindVault:");
    static bool GetKothVRun = false;
    static vector KOTHPlace = cInvalidVector;
	if (GetKothVRun == false)
	{
    //Find other islands area group.
	    int gTCUnitID = -1;
	    int TCunitQueryID = kbUnitQueryCreate("findPlentyVault");
        kbUnitQuerySetPlayerRelation(TCunitQueryID, cPlayerRelationAny);
        kbUnitQuerySetUnitType(TCunitQueryID, cUnitTypePlentyVaultKOTH);
        kbUnitQuerySetState(TCunitQueryID, cUnitStateAny);
        kbUnitQueryResetResults(TCunitQueryID);
        int numberFound = kbUnitQueryExecute(TCunitQueryID);
        gKOTHPlentyUnitID = kbUnitQueryGetResult(TCunitQueryID, 0);
		
		KOTHPlace = kbUnitGetPosition(gKOTHPlentyUnitID);
		GetKothVRun = true;
		}
		
    //Create transport plan to get units to the other island
	vector there = KOTHPlace;
    ClaimKoth(there);
	xsDisableSelf();
}

//==============================================================================
rule getKingOfTheHillVault
minInterval 10
inactive
{
               static bool LandActive = false;
			   static bool LandNeedReCalculation = false;
               static bool WaterVersion = false; 
               if (WaterVersion == true)
               xsSetRuleMinIntervalSelf(30+aiRandInt(12));
			   else
			   xsSetRuleMinIntervalSelf(20+aiRandInt(12));
			   
               static vector KOTHPlace = cInvalidVector;
               KOTHPlace = kbUnitGetPosition(gKOTHPlentyUnitID);
			   KOTHGlobal = kbUnitGetPosition(gKOTHPlentyUnitID);
               int NumEnemy = getNumUnitsByRel(cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive, -1, cPlayerRelationEnemy, KOTHPlace, 30.0, true);
               int NumSelf = getNumUnits(cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive, -1, cMyID, KOTHPlace, 20.0);

			   if (WaterVersion == false)
			   {
			   int numfish = kbUnitCount(0, cUnitTypeFish, cUnitStateAlive);
			   if (numfish > 1)
			   {
			   WaterVersion = true;
			   if (ShowAiEcho == true) aiEcho("Water version of KOTH detected.");
			   DestroyKOTHLandPlan = true;  // never again!
			   vector KOTHPOS=kbUnitGetPosition(gKOTHPlentyUnitID);
               KOTHBASE = kbBaseCreate(cMyID, "KOTH BASE", KOTHPOS, 5.0);
			   xsEnableRule("KOTHMonitor");
			   xsEnableRule("getEnclosedDeck");
			   return;
               } 
               }			   
                int numAvailableUnits = kbUnitCount(cMyID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive);
				if (WaterVersion == true)
				numAvailableUnits = kbUnitCount(cMyID, cUnitTypeHumanSoldier, cUnitStateAlive);
				
				if (WaterVersion == true)
				numAvailableUnits = numAvailableUnits-NumSelf;
				else numAvailableUnits = numAvailableUnits;
                
				if (WaterVersion == true)
				{
				if (numAvailableUnits < 6 && kbGetPop() <= 39 || kbGetAge() < cAge2)
                return;
				}
				
				if (WaterVersion == false)
				{
				if ((numAvailableUnits < 7 && kbGetPop() <= 39) || (kbGetAge() < cAge2) || (numAvailableUnits < 11 && (xsGetTime() > 17*60*1000)))
                return;
				}	  
					if (LandNeedReCalculation == true && WaterVersion == false)
					{
					
			        if (LandActive == false)
					{
					    gDefendPlentyVault = aiPlanCreate("KOTH VAULT DEFEND", cPlanDefend);         // Uses "enemy" plan for allies, too.
                
                        aiPlanAddUnitType(gDefendPlentyVault, cUnitTypeLogicalTypeLandMilitary, numAvailableUnits * 0.7, numAvailableUnits * 0.8, numAvailableUnits * 0.85);    // Most mil units.

                        aiPlanSetDesiredPriority(gDefendPlentyVault, 70);                       // prio
                        aiPlanSetVariableVector(gDefendPlentyVault, cDefendPlanDefendPoint, 0, KOTHPlace);
                        aiPlanSetVariableFloat(gDefendPlentyVault, cDefendPlanEngageRange, 0, 30.0);
                        aiPlanSetVariableBool(gDefendPlentyVault, cDefendPlanPatrol, 0, false);

                        aiPlanSetVariableFloat(gDefendPlentyVault, cDefendPlanGatherDistance, 0, 10.0);
                        aiPlanSetInitialPosition(gDefendPlentyVault, KOTHPlace);
                        aiPlanSetUnitStance(gDefendPlentyVault, cUnitStanceDefensive);

                        aiPlanSetVariableInt(gDefendPlentyVault, cDefendPlanRefreshFrequency, 0, 10);

                        aiPlanSetNumberVariableValues(gDefendPlentyVault, cDefendPlanAttackTypeID, 2, true);
                        aiPlanSetVariableInt(gDefendPlentyVault, cDefendPlanAttackTypeID, 0, cUnitTypeMilitary);
                        aiPlanSetVariableInt(gDefendPlentyVault, cDefendPlanAttackTypeID, 1, cUnitTypeMilitaryBuilding);
                        keepUnitsWithinRange(gDefendPlentyVault, KOTHPlace);
                        aiPlanSetNoMoreUnits(gDefendPlentyVault, false);
                        aiPlanSetActive(gDefendPlentyVault);
						KOTHStopRefill = true;
						xsEnableRule("KOTHMonitor"); // lock the first wave
                        LandNeedReCalculation = false;
						
						LandActive = true; // active, will add more units below.
						return;
						}
						aiPlanSetNoMoreUnits(gDefendPlentyVault, false);
						aiPlanAddUnitType(gDefendPlentyVault, cUnitTypeLogicalTypeLandMilitary, numAvailableUnits * 0.8, numAvailableUnits * 0.85, numAvailableUnits * 0.9);    // Most mil units.
						LandNeedReCalculation = false;
						KOTHStopRefill = true;
						xsEnableRule("KOTHMonitor");
						keepUnitsWithinRange(gDefendPlentyVault, KOTHPlace);
						return;
						}
			   
			   

               
			   if (NumEnemy + 15 > NumSelf && WaterVersion == false)
		       {
			   LandNeedReCalculation = true;
			   xsSetRuleMinIntervalSelf(2);
			   //aiPlanDestroy(gDefendPlentyVault);  // restarting plan
			   return;
				}
				
				if (WaterVersion == false)
				return;
				 
				 if (NumSelf > NumEnemy + 14 && WaterVersion == true)
				 SendBackCount = SendBackCount+1;
				 
				 if (SendBackCount > 6)
				 {
				 xsEnableRule("GetKOTHVault");
				 KoTHOkNow = true;
				 SendBackCount = 0;
                 return;				 
				 }
				 	 
				 
                 if (14 > NumSelf && WaterVersion == true)
                 {
	             xsEnableRule("GetKOTHVault");
				 LandNeedReCalculation = false;
				 if (KothDefPlanActive == false)
				 xsEnableRule("GatherAroundKOTH");
				 return;
	             }
}

//==============================================================================	  
rule GatherAroundKOTH  // launches a defend plan on the island.
   minInterval 22
   inactive
{
   static vector KOTHPlace = cInvalidVector;
   KOTHPlace = kbUnitGetPosition(gKOTHPlentyUnitID);
   static bool PlanActive = false;   

	   
		if (PlanActive == false)
		{
		if (ShowAiEcho == true) aiEcho("I was here!");
		gDefendPlentyVaultWater = aiPlanCreate("KOTH WATER VAULT DEFEND", cPlanDefend);
		
        aiPlanSetDesiredPriority(gDefendPlentyVaultWater, 90);                       // prio
        aiPlanSetVariableVector(gDefendPlentyVaultWater, cDefendPlanDefendPoint, 0, KOTHPlace);
        aiPlanSetVariableFloat(gDefendPlentyVaultWater, cDefendPlanEngageRange, 0, 25.0);
        aiPlanSetVariableBool(gDefendPlentyVaultWater, cDefendPlanPatrol, 0, false);

        aiPlanSetVariableFloat(gDefendPlentyVaultWater, cDefendPlanGatherDistance, 0, 12.0);
        aiPlanSetInitialPosition(gDefendPlentyVaultWater, KOTHPlace);
        aiPlanSetUnitStance(gDefendPlentyVaultWater, cUnitStanceDefensive);

        aiPlanSetVariableInt(gDefendPlentyVaultWater, cDefendPlanRefreshFrequency, 0, 10);

        aiPlanSetNumberVariableValues(gDefendPlentyVaultWater, cDefendPlanAttackTypeID, 2, true);
        aiPlanSetVariableInt(gDefendPlentyVaultWater, cDefendPlanAttackTypeID, 0, cUnitTypeMilitary);
        aiPlanSetVariableInt(gDefendPlentyVaultWater, cDefendPlanAttackTypeID, 1, cUnitTypeMilitaryBuilding);
        keepUnitsWithinRange(gDefendPlentyVaultWater, KOTHPlace);
        aiPlanAddUnitType(gDefendPlentyVaultWater, cUnitTypeHumanSoldier, 0, 0, 200);
        aiPlanSetActive(gDefendPlentyVaultWater);
		PlanActive = true;
		}
		if (PlanActive == true)
		{
        KothDefPlanActive = true;
		xsDisableSelf();
		}
}

//==============================================================================
rule KOTHMonitor
minInterval 2
inactive
{
    xsSetRuleMinIntervalSelf(2);
	
    if (KOTHStopRefill == true)
	{
	 xsSetRuleMinIntervalSelf(5); // give some extra time to fetch units.
	 aiPlanSetNoMoreUnits(gDefendPlentyVault, true);	 
	 xsDisableSelf();
	 keepUnitsWithinRange(gDefendPlentyVault, KOTHGlobal);
	 KOTHStopRefill = false;
	 return;
	}
    	
    if (DestroyTransportPlan == true)
	{
	aiPlanDestroyByName("TRANSPORT TO KOTH VAULT");
	aiPlanDestroyByName("GO HOME AGAIN");
    aiPlanDestroy(KOTHTransportPlan);
    DestroyTransportPlan = false;	
	}
	else if (DestroyHTransportPlan == true)
	{
	aiPlanDestroyByName("GO HOME AGAIN");	
	aiPlanDestroy(KOTHTHomeTransportPlan);
	aiPlanDestroyByName("TRANSPORT TO KOTH VAULT");  // just destroy both, as they seem to get stuck.
	aiPlanDestroy(KOTHTransportPlan);
	DestroyHTransportPlan = false;
	}
	else if (DestroyKOTHLandPlan == true)
	{
	aiPlanDestroyByName("KOTH VAULT DEFEND");	
	aiPlanDestroy(gDefendPlentyVault);
	DestroyKOTHLandPlan = false;
	}
    xsDisableSelf();
	
}
// KOTH COMPLEX END
//==============================================================================
rule StartingBoatFailsafe  // for vinlandsaga and team migration where ships may fail to spawn, will also scout the mainland.
minInterval 5
inactive
{
 vector HomeBase = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
 int boats = kbUnitCount(cMyID, cUnitTypeTransport, cUnitStateAlive);
 static int TransportUnit=-1;
 static bool CheckCenter = false;
 static bool Spawned = false;
 if ((boats <= 0) && (Spawned == false))
 {
 aiUnitCreateCheat(cMyID, cUnitTypeRoc, HomeBase, "Spawn backup roc", 1);
 Spawned = true;
 return;
 }
 if ((CheckCenter == false) && (boats >= 1))
 {
 int transportPUID=cUnitTypeTransport;
 vector nearCenter = kbGetMapCenter();
        TransportUnit = findUnit(transportPUID);
        nearCenter = kbGetMapCenter();
        nearCenter = (nearCenter + kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID))) / 2.0;
        nearCenter = (nearCenter + kbGetMapCenter()) / 2.0;   
        aiTaskUnitMove(TransportUnit, nearCenter);
		CheckCenter = true;
		}	
 
 xsDisableSelf();
 
}

//==============================================================================
rule RemoveWConnectors
minInterval 5
group WallCleanup
inactive
{

   static int unitQueryID=-1;
   static int enemyQueryID=-1;
   xsSetRuleMinIntervalSelf(5);

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypeGate);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
			kbUnitQuerySetAscendingSort(unitQueryID, false);
			kbUnitQuerySetMaximumDistance(unitQueryID, 0);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

	if (siegeFound < 1)
	return;
   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationSelf);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeWallConnector);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAliveOrBuilding);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 4);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   if (numberFoundTemp >= 1)
	   {
	    xsSetRuleMinIntervalSelf(2);
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitDelete(enemyUnitIDTemp);
		if (ShowAiEcho == true || ShowAiTestEcho == true) aiEcho("I deleted cUnitTypeWallConnector");
	   }
   }
}

//==============================================================================
rule RemoveWMedium
minInterval 20
group WallCleanup
inactive
{

   static int unitQueryID=-1;
   static int enemyQueryID=-1;
   xsSetRuleMinIntervalSelf(12);

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypeGate);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
			kbUnitQuerySetAscendingSort(unitQueryID, false);
			kbUnitQuerySetMaximumDistance(unitQueryID, 0);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

	if (siegeFound < 1)
	return;
   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationSelf);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeWallMedium);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAliveOrBuilding);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 4);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   if (numberFoundTemp >= 1)
	   {
	    xsSetRuleMinIntervalSelf(2);
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitDelete(enemyUnitIDTemp);
		if (ShowAiEcho == true) aiEcho("Removing a piece of cUnitTypeWallMedium");
	   }
   }
}
//==============================================================================
rule RemoveWShort
minInterval 20
group WallCleanup
inactive
{

   static int unitQueryID=-1;
   static int enemyQueryID=-1;
   xsSetRuleMinIntervalSelf(12);

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypeGate);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
			kbUnitQuerySetAscendingSort(unitQueryID, false);
			kbUnitQuerySetMaximumDistance(unitQueryID, 0);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

	if (siegeFound < 1)
	return;
   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationSelf);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeWallShort);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAliveOrBuilding);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 4);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   if (numberFoundTemp >= 1)
	   {
	    xsSetRuleMinIntervalSelf(2);
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitDelete(enemyUnitIDTemp);
		if (ShowAiEcho == true || ShowAiTestEcho == true) aiEcho("Removing a piece of cUnitTypeWallShort");
	   }
   }
}
//==============================================================================
rule RemoveWLong  
minInterval 20
group WallCleanup
inactive
{

   static int unitQueryID=-1;
   static int enemyQueryID=-1;
   xsSetRuleMinIntervalSelf(12);

   //If we don't have the query yet, create one.
   if (unitQueryID < 0)
   unitQueryID=kbUnitQueryCreate("My Siege Query");
   
   //Define a query to get all matching units
   if (unitQueryID != -1)
   {
		kbUnitQuerySetPlayerID(unitQueryID, cMyID);
			kbUnitQuerySetUnitType(unitQueryID, cUnitTypeGate);
	        kbUnitQuerySetState(unitQueryID, cUnitStateAlive);
			kbUnitQuerySetAscendingSort(unitQueryID, false);
			kbUnitQuerySetMaximumDistance(unitQueryID, 0);
   }

   kbUnitQueryResetResults(unitQueryID);
   int siegeFound=kbUnitQueryExecute(unitQueryID);

	if (siegeFound < 1)
	return;
   //If we don't have the query yet, create one.
   if (enemyQueryID < 0)
   enemyQueryID=kbUnitQueryCreate("Target Enemy Query");
   
   //Define a query to get all matching units
   if (enemyQueryID != -1)
   {
		kbUnitQuerySetPlayerRelation(enemyQueryID, cPlayerRelationSelf);
		kbUnitQuerySetUnitType(enemyQueryID, cUnitTypeWallLong);
	        kbUnitQuerySetState(enemyQueryID, cUnitStateAliveOrBuilding);
		kbUnitQuerySetSeeableOnly(enemyQueryID, true);
		kbUnitQuerySetAscendingSort(enemyQueryID, true);
		kbUnitQuerySetMaximumDistance(enemyQueryID, 4);
   }

   int numberFoundTemp = 0;
   int enemyUnitIDTemp = 0;

   for (i=0; < siegeFound)
   {
	   kbUnitQuerySetPosition(enemyQueryID, kbUnitGetPosition(kbUnitQueryGetResult(unitQueryID, i)));
	   kbUnitQueryResetResults(enemyQueryID);
	   numberFoundTemp=kbUnitQueryExecute(enemyQueryID);
	   if (numberFoundTemp >= 1)
	   {
	    xsSetRuleMinIntervalSelf(2);
		enemyUnitIDTemp = kbUnitQueryGetResult(enemyQueryID, 0);
		aiTaskUnitDelete(enemyUnitIDTemp);
		if (ShowAiEcho == true || ShowAiTestEcho == true) aiEcho("Removing a piece of cUnitTypeWallLong");
	   }
   }
}

//==============================================================================
rule TransportBuggedUnits  
minInterval 10
inactive
{
static int TransportAttPlanID = -1;
int IdleMil = aiNumberUnassignedUnits(cUnitTypeLogicalTypeLandMilitary);
static int attackPlanStartTime = -1;
static int targetSettlementID = -1;
int AttackPlayer = aiGetMostHatedPlayerID();
xsSetRuleMinIntervalSelf(30);
static vector attPlanPosition = cInvalidVector;
bool Filled = false;


    int activeAttPlans = aiPlanGetNumber(cPlanAttack, -1, true );  // Attack plans, any state, active only
	if (activeAttPlans > 0)
    {
        for (i = 0; < activeAttPlans)
        {
            int attackPlanID = aiPlanGetIDByIndex(cPlanAttack, -1, true, i);
            if (ShowAiEcho == true) aiEcho("attackPlanID: "+attackPlanID);
            if (attackPlanID == -1)
                continue;
		   if (attackPlanID == TransportAttPlanID)	
		   {
           int planState = aiPlanGetState(TransportAttPlanID);
		   int transportPUID=kbTechTreeGetUnitIDTypeByFunctionIndex(cUnitFunctionWaterTransport, 0);
           attPlanPosition = aiPlanGetLocation(TransportAttPlanID);
           int numMilUnitsNearAttPlan = getNumUnits(cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive, -1, cMyID, attPlanPosition);
           int numInPlan = aiPlanGetNumberUnits(TransportAttPlanID, cUnitTypeLogicalTypeLandMilitary);
		   int numTransport = kbUnitCount(cMyID, transportPUID, cUnitStateAlive);
           if (numMilUnitsNearAttPlan >= 20)
           numMilUnitsNearAttPlan = 20;
           if (numInPlan > 1)
		   {
		   aiPlanSetVariableInt(gMaintainWaterXPortPlanID, cTrainPlanNumberToMaintain, 0, 3);
		   aiPlanSetVariableInt(gMaintainWaterXPortPlanID, cTrainPlanFrequency, 0, 15);
           Filled = true;
           } 
		   
           if (Filled == false)
		   {
		   aiPlanSetInitialPosition(TransportAttPlanID, attPlanPosition);
           aiPlanAddUnitType(TransportAttPlanID, cUnitTypeLogicalTypeLandMilitary, 0, 0, numMilUnitsNearAttPlan);
           }		   
           if (ShowAiEcho == true) aiEcho("planState: "+planState);		   
		   
           if ((numInPlan < 1) || (xsGetTime() > attackPlanStartTime + 30*60*1000) || (planState == cPlanStateNone) && (xsGetTime() > attackPlanStartTime + 5*60*1000) ||
           (planState == cPlanStateGather) && (xsGetTime() > attackPlanStartTime + 5*60*1000) 
		   || ((aiPlanGetState(attackPlanID) == cPlanStateTransport) && (numTransport < 1) (aiPlanGetVariableInt(attackPlanID, cAttackPlanNumberAttacks, 0) > 0)))
           {
           aiPlanDestroy(TransportAttPlanID);
           if (ShowAiEcho == true) aiEcho("Deleted");
           xsSetRuleMinIntervalSelf(5);
           }
           return;		   
	    }
	 }
  }
    if (IdleMil < 5)
	{
	aiPlanSetVariableInt(gMaintainWaterXPortPlanID, cTrainPlanNumberToMaintain, 0, 2);
    return;	
    }	
    TransportAttPlanID = aiPlanCreate("Transport bugged units", cPlanAttack);
    if (TransportAttPlanID < 0)
    return; 
        
    if (ShowAiEcho == true) aiEcho(""+TransportAttPlanID+"");
	
    TransportAttPlanID = TransportAttPlanID;
	targetSettlementID = getMainBaseUnitIDForPlayer(AttackPlayer);
	if (targetSettlementID == -1)
	targetSettlementID = findUnit(cUnitTypeUnit, cUnitStateAlive, -1, AttackPlayer); 
	vector targetSettlementPos = kbUnitGetPosition(targetSettlementID); // uses main TC
    vector RandUnit = kbUnitGetPosition(findUnit(cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive, -1, AttackPlayer));
	vector RandBuilding = kbUnitGetPosition(findUnit(cUnitTypeLogicalTypeBuildingsNotWalls, cUnitStateAlive, -1, AttackPlayer));
    vector RandVillager = kbUnitGetPosition(findUnit(cUnitTypeAbstractVillager, cUnitStateAlive, -1, AttackPlayer));	
	aiPlanSetNumberVariableValues(TransportAttPlanID, cAttackPlanTargetAreaGroups, 5, true);   
	aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanTargetAreaGroups, 0, kbAreaGroupGetIDByPosition(attPlanPosition));
	aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanTargetAreaGroups, 1, kbAreaGroupGetIDByPosition(targetSettlementPos));
    aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanTargetAreaGroups, 2, kbAreaGroupGetIDByPosition(RandUnit));
    aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanTargetAreaGroups, 3, kbAreaGroupGetIDByPosition(RandBuilding));
	aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanTargetAreaGroups, 4, kbAreaGroupGetIDByPosition(RandVillager));	
	aiPlanAddUnitType(TransportAttPlanID, cUnitTypeHumanSoldier, 0, 0, 1);
	attPlanPosition = aiPlanGetLocation(TransportAttPlanID);
    
	aiPlanSetInitialPosition(TransportAttPlanID, attPlanPosition);
    aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanPlayerID, 0, AttackPlayer);
	aiPlanSetInitialPosition(TransportAttPlanID, attPlanPosition);
    aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanBaseAttackMode, 0, cAttackPlanBaseAttackModeWeakest);
    aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanAttackRoutePattern, 0, cAttackPlanAttackRoutePatternBest);
    aiPlanSetUnitStance(TransportAttPlanID, cUnitStanceDefensive);
    aiPlanSetDesiredPriority(TransportAttPlanID, 1);
    aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanPlayerID, 0, AttackPlayer);
    aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanRetreatMode, 0, cAttackPlanRetreatModeNone);
    aiPlanSetNumberVariableValues(TransportAttPlanID, cAttackPlanTargetTypeID, 4, true); 
    aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanTargetTypeID, 0, cUnitTypeAbstractVillager);
    aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanTargetTypeID, 1, cUnitTypeUnit);
    aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanTargetTypeID, 2, cUnitTypeBuilding);
	aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanTargetTypeID, 3, cUnitTypeAbstractTradeUnit);
    aiPlanSetVariableInt(TransportAttPlanID, cAttackPlanRefreshFrequency, 0, 12);
	
    aiPlanSetActive(TransportAttPlanID);
    attackPlanStartTime = xsGetTime();
 
    xsSetRuleMinIntervalSelf(5);
}

//==============================================================================
rule StuckNorseTransform  
minInterval 3
inactive
{
      if (kbUnitIsType(StuckTransformID, cUnitTypeUlfsark))
      {
	  vector currentPosition = kbUnitGetPosition(StuckTransformID);	  
	  aiUnitCreateCheat(cMyID, cUnitTypeUlfsark, currentPosition, "Replacing Stuck Ulfsark", 1);
	  aiTaskUnitDelete(StuckTransformID);
      }
	  StuckTransformID = 0;	  
      xsDisableSelf();	  
}

//==============================================================================
rule FishBoatMonitor  
minInterval 10
inactive
{
      int Ship = kbTechTreeGetUnitIDTypeByFunctionIndex(cUnitFunctionFish,0);
      int IdleFishingShips = getNumUnits(Ship, cUnitStateAlive, cActionIdle, cMyID);
      int Training = aiPlanGetVariableInt(gFishPlanID, cFishPlanNumberInTraining, 0);
      if ((kbResourceGet(cResourceWood) < 150) && (kbGetAge() == cAge1) || (kbResourceGet(cResourceWood) < 75) && (kbGetAge() > cAge1) || (IdleFishingShips >= 3))
	  {
	  if (Training == 0)
      aiPlanSetVariableBool(gFishPlanID, cFishPlanAutoTrainBoats, 0, false);
	  }
	  else aiPlanSetVariableBool(gFishPlanID, cFishPlanAutoTrainBoats, 0, true);
}
//Testing ground

rule TEST  
minInterval 1
inactive
{
}