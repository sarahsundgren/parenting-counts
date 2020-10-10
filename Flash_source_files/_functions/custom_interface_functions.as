///////////////////////////////////////////////////////////////////////////////////////////////////
// CUSTOM INTERFACE FUNCTIONALITY
//
// @author    Allen Communication Learning Services
// @version   3.2
// @comments  The ActionScript within this document comprises customizations to the core
//			  interface functionality.  Core variables and functions are prefixed with '$'.
///////////////////////////////////////////////////////////////////////////////////////////////////
var m_nOldPageZOrder: 	 	 Number = null;
var m_bHelpHighlighted:  	 Boolean = false;
var m_bExitHighlighted:  	 Boolean = false;
var m_bPauseHighlighted: 	 Boolean = false;
var m_bNotesHighlighted: 	 Boolean = false;
var m_bToolsHighlighted: 	 Boolean = false;
var m_bResourcesHighlighted: Boolean = false;

gShell.highlightReplayBtn = function(bHighlight:Boolean): Void
{
	if (bHighlight)
		gShell.mc_ReplayBtn.xtc_onRollOver();	
	else
		gShell.mc_ReplayBtn.xtc_onRollOut();
}

gShell.highlightHelpBtn = function(bHighlight:Boolean): Void
{
	m_bHelpHighlighted = bHighlight;
	if (bHighlight)
		gShell.mc_HelpBtn.xtc_onRollOver();	
	else
		gShell.mc_HelpBtn.xtc_onRollOut();
}

gShell.highlightExitBtn = function(bHighlight:Boolean): Void
{
	m_bExitHighlighted = bHighlight;
	if (bHighlight)
		gShell.mc_ExitBtn.xtc_onRollOver();	
	else
		gShell.mc_ExitBtn.xtc_onRollOut();
}

gShell.highlightTranscriptBtn = function(bHighlight:Boolean): Void
{
	if (bHighlight)
	{
		if (gShell.mc_TranscriptOffBtn.xtc_isVisible())
			gShell.mc_TranscriptOffBtn.xtc_onRollOver();	
		else if (gShell.mc_TranscriptOnBtn.xtc_isVisible())
			gShell.mc_TranscriptOnBtn.xtc_onRollOver();	
	}
	else
	{
		if (gShell.mc_TranscriptOffBtn.xtc_isVisible())
			gShell.mc_TranscriptOffBtn.xtc_onRollOut();
		else if (gShell.mc_TranscriptOnBtn.xtc_isVisible())
			gShell.mc_TranscriptOnBtn.xtc_onRollOut();
	}
}

gShell.highlightPauseBtn = function(bHighlight:Boolean): Void
{
	m_bPauseHighlighted = bHighlight;

	if (bHighlight)
		gShell.mc_PauseBtn.xtc_onRollOver();		
	else
		gShell.mc_PauseBtn.xtc_onRollOut();
}

/**
* Enable/Disable the PLAY/PAUSE buttons.
**/	
gShell.$enablePlayPauseBtn = function(bEnable:Boolean): Void	
{ 	
	gShell.$core_enablePlayPauseBtn(bEnable);
	
	if (m_bPauseHighlighted)
		gShell.highlightPauseBtn(true);
}

gShell.highlightNotesBtn = function(bHighlight:Boolean): Void
{
	m_bNotesHighlighted = bHighlight;

	if (bHighlight)
		gRightMenu.mc_NotesBtn.gotoAndStop("_over");
	else
		gRightMenu.mc_NotesBtn.gotoAndStop("_up");
}

gShell.highlightToolsBtn = function(bHighlight:Boolean): Void
{
	m_bToolsHighlighted = bHighlight;

	if (bHighlight)
		gRightMenu.mc_ToolsBtn.gotoAndStop("_over");
	else
		gRightMenu.mc_ToolsBtn.gotoAndStop("_up");
}

gShell.highlightResourcesBtn = function(bHighlight:Boolean): Void
{
	m_bResourcesHighlighted = bHighlight;

	if (bHighlight)
		gRightMenu.mc_ResourcesBtn.gotoAndStop("_over");
	else
		gRightMenu.mc_ResourcesBtn.gotoAndStop("_up");
}

gShell.showWizard = function(bShow:Boolean): Void
{
	var xtcWizard: MovieClip = gShell.mc_Wizard;
	if (xtcWizard)
	{
		if (!bShow)
			gWizard.onHide();
		else
			gWizard.onShow();			
		gShell.$showComponent(xtcWizard, bShow);		
	}
}


gShell.showTools = function(bShow:Boolean): Void
{
	var xtcTools: MovieClip = gShell.mc_Tools;
	if (xtcTools)
		gShell.$showComponent(xtcTools, bShow);
}

gShell.showLeftMenu = function(bShow:Boolean): Void
{
	gLeftMenu.$show(bShow);
}


gShell.showRightMenu = function(bShow:Boolean): Void
{
	gRightMenu.$show(bShow);
}


gShell.swapPageAndMenus = function(bPageOnTop:Boolean): Void
{	
	if ((!m_nOldPageZOrder) && (bPageOnTop))
	{
		m_nOldPageZOrder = gPage.getDepth();
		gPage.swapDepths(gShell.mc_LeftMenu.getDepth() + 1);
	}
	else if ((m_nOldPageZOrder) && (!bPageOnTop))
	{
		gPage.swapDepths(m_nOldPageZOrder);
		m_nOldPageZOrder = null;
	}
}