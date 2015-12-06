//==============================================================================
// AoMod AI
// AoModAIProgr.xs
// This is a modification of Georg Kalus' extension of the default aomx ai file
// by Loki_GdD
//
// Handles progression.
//==============================================================================


//==============================================================================
void initProgress()
{
    aiEcho("Progress Init.");
}

//==============================================================================
int chooseMinorGod(int age = -1, int mythUnitPref = -1, int godPowerPref = -1)
{
    aiEcho("chooseMinorGod:");
    
    //So, I know there are only 2 choices in minor god selection.
    int minorGodA=kbTechTreeGetMinorGodChoices(0, age);
    int minorGodB=kbTechTreeGetMinorGodChoices(1, age);
    int finalChoice=-1;

    //Look at the myth units.
    if (mythUnitPref != -1)
    {   
        if ( cvMapSubType == NOMADMAP || cvMapSubType == WATERNOMADMAP || cvMapSubType == VINLANDSAGAMAP )
            int currentChoice=minorGodA;
        for (a=0; < 2)
        {
            if (a == 1)
                currentChoice=minorGodB;

            //Get the list of myth units that minorGodA gives us.
            int totalMythUnits=kbTechTreeGetMinorGodMythUnitTotal( currentChoice );
            for (i=0; < totalMythUnits)
            {
                //Get the myth protounit ID.
                int mythUnitProtoID=kbTechTreeGetMinorGodMythUnitByIndex( currentChoice, i );
         
                if (mythUnitPref == mythUnitProtoID)
                {
                    finalChoice=currentChoice;
                    break;
                }
            }

            //Kick out because we have made our choice.
            if (finalChoice != -1)
                break;
        }
    }

    //Look at the god power if we haven't made our finalChoice yet.
    if ((godPowerPref != -1) && (finalChoice == -1))
    {
        //Get the god power tech ids from the minor god tech.
        int godPowerTechIDA=kbTechTreeGetGPTechID(minorGodA);
        int godPowerTechIDB=kbTechTreeGetGPTechID(minorGodB);
      
        //Choose minor god.
        if (godPowerTechIDA == godPowerPref)
            finalChoice=minorGodA;
        else if (godPowerTechIDB == godPowerPref)
            finalChoice=minorGodB;
    }

    //So, no prefs were set, just pick one.
    if (finalChoice == -1)
    {
        //Choose minor god.
        if (minorGodA != -1)
            finalChoice=minorGodA;
        else if (minorGodB != -1)
            finalChoice=minorGodB;
    }

    //Return the final minor god choice. Note final Choice can still be invalid.
    return(finalChoice);
}

//==============================================================================
void progressAge2Handler(int age=1)
{
    aiEcho("Progress Age "+age+".");
    xsEnableRule("age2Progress");
	xsEnableRule("repairTitanGate");
	
	// The Greeks are working as intended, so we're skipping that.
	
    if (cMyCulture == cCultureEgyptian)
    {
    xsEnableRule("buildMonuments");
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
	
}
//==============================================================================
void progressAge3Handler(int age=2)
{
    aiEcho("Progress Age "+age+".");
    xsEnableRule("age3Progress");
    if (cMyCulture == cCultureEgyptian)
        xsEnableRule("buildMonuments");
}

//==============================================================================
void progressAge4Handler(int age=3)
{
    aiEcho("Progress Age "+age+".");
    if (cMyCulture == cCultureEgyptian)
        xsEnableRule("buildMonuments");
}

//==============================================================================
rule unPauseAge2
    minInterval 91 //starts in cAge1
    inactive
{
    aiEcho("unPauseAge2:");

    if (gAge2ProgressionPlanID == -1)
    {
        //aiEcho("Age 2 Progression Plan id("+gAge2ProgressionPlanID+") is invalid.");
        xsDisableSelf();
        return;
    }

    aiPlanSetVariableBool(gAge2ProgressionPlanID, cProgressionPlanPaused, false);
    aiPlanSetVariableBool(gAge2ProgressionPlanID, cProgressionPlanPaused, 0, false);
    aiPlanSetVariableBool(gAge2ProgressionPlanID, cProgressionPlanAdvanceOneStep, 0, false);
    xsDisableSelf();
}

//==============================================================================
rule age1Progress
    minInterval 10 //starts in cAge1
    inactive
{
    aiEcho("age1Progress:");

    if (gAge2MinorGod == -1)
        gAge2MinorGod=chooseMinorGod(cAge2, -1, -1);

    gAge2ProgressionPlanID=aiPlanCreate("Age 2", cPlanProgression);
    if ((gAge2ProgressionPlanID >= 0) && (gAge2MinorGod != -1))
    { 
        aiPlanSetVariableInt(gAge2ProgressionPlanID, cProgressionPlanGoalTechID, 0, gAge2MinorGod);
        aiPlanSetDesiredPriority(gAge2ProgressionPlanID, 100);
        aiPlanSetEscrowID(gAge2ProgressionPlanID, cEconomyEscrowID);
        aiPlanSetBaseID(gAge2ProgressionPlanID, kbBaseGetMainID(cMyID));
        //Start paused!!
        aiPlanSetVariableBool(gAge2ProgressionPlanID, cProgressionPlanPaused, 0, true);
        aiPlanSetVariableBool(gAge2ProgressionPlanID, cProgressionPlanAdvanceOneStep, 0, true);
        aiPlanSetActive(gAge2ProgressionPlanID);
        //Unpause after a brief amount of time.
        if ( (cvMapSubType != NOMADMAP) && (cvMapSubType != WATERNOMADMAP) && (cvMapSubType != VINLANDSAGAMAP) )
            xsEnableRule("unPauseAge2");
        //If we have a lot of resources, assume we want to go up fast.
        if (kbResourceGet(cResourceWood) >= 1000)
            xsSetRuleMinInterval("unPauseAge2", 5);
    }
    xsDisableSelf();
}

//==============================================================================
rule age2Progress
    minInterval 10 //starts in cAge2
    inactive
{
    aiEcho("age2Progress:");

    if (gAge3MinorGod == -1)
        gAge3MinorGod=chooseMinorGod(cAge3, -1, -1);

    gAge3ProgressionPlanID=aiPlanCreate("Age 3", cPlanProgression);
    if ((gAge3ProgressionPlanID >= 0) && (gAge3MinorGod != -1))
    { 
        aiPlanSetVariableInt(gAge3ProgressionPlanID, cProgressionPlanGoalTechID, 0, gAge3MinorGod);
        aiPlanSetDesiredPriority(gAge3ProgressionPlanID, 100);
        aiPlanSetEscrowID(gAge3ProgressionPlanID, cEconomyEscrowID);
        aiPlanSetBaseID(gAge3ProgressionPlanID, kbBaseGetMainID(cMyID));
        aiPlanSetActive(gAge3ProgressionPlanID);
    }
   
    xsDisableSelf();
}

//==============================================================================
rule age3Progress
    minInterval 10 //starts in cAge3
    inactive
{
    aiEcho("age3Progress:");

    if (gAge4MinorGod == -1)
        gAge4MinorGod=chooseMinorGod(cAge4, -1, -1);

    gAge4ProgressionPlanID=aiPlanCreate("Age 4", cPlanProgression);
    if ((gAge4ProgressionPlanID >= 0) && (gAge4MinorGod != -1))
    { 
        aiPlanSetVariableInt(gAge4ProgressionPlanID, cProgressionPlanGoalTechID, 0, gAge4MinorGod);
        aiPlanSetDesiredPriority(gAge4ProgressionPlanID, 100);
        aiPlanSetEscrowID(gAge4ProgressionPlanID, cEconomyEscrowID);
        aiPlanSetBaseID(gAge4ProgressionPlanID, kbBaseGetMainID(cMyID));
        aiPlanSetActive(gAge4ProgressionPlanID);
    }
   
    xsDisableSelf();
}
