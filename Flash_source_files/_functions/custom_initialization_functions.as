///////////////////////////////////////////////////////////////////////////////////////////////////
// CUSTOM SHELL INITIALIZATION FUNCTIONALITY
//
// @author    Allen Communication Learning Services
// @version   3.2
// @comments  The ActionScript within this document comprises customizations to the core
//			  initialization functionality. Core variables and functions are prefixed with '$'.
///////////////////////////////////////////////////////////////////////////////////////////////////


/**
* Notification received when the interface is finished processing.
* OVERRIDE
**/	
gShell.$onProcessInterfaceComplete = function(Void): Void
{
		// Set 3D styles on the popups (if relevant)
	if ((gShell.$getShadowFilter()) && (!_root._DEV_MODE_))
	{
		if (gShell.mc_PrintMsg.m_bShadow)
			gShell.$getShadowFilter().xtc_applyPrimitiveFilter(gShell.mc_PrintMsg);
	}
	$core_onProcessInterfaceComplete();
}


/**
* Load custom data path
* OVERRIDE
**/
gShell.$processDataConfig = function(Void)
{
	var xcfgSettings = gShell.$core_processDataConfig();
	
	gShell.m_strCustomDataPath = xcfgSettings.xtc_getValue("customDataPath");	
	gShell.MAX_NOTES		   = xcfgSettings.xtc_getNumericValue("maxCustomNotes");	
	
	if ((!gShell.MAX_NOTES) || (gShell.MAX_NOTES > gShell.DEF_MAX_NOTES))
		gShell.MAX_NOTES = gShell.DEF_MAX_NOTES;
	
	return xcfgSettings;
}


/**
* Process data message config settings
* OVERRIDE
**/	
gShell.$processDataMessageConfig = function(Void)
{
	var xcfgSettings = gShell.$core_processDataMessageConfig();
	
	gShell.m_strAudienceDataError = xcfgSettings.xtc_getValue("audienceDataError");
	gShell.m_strNotesDataError    = xcfgSettings.xtc_getValue("notesDataError");

	return xcfgSettings;
}