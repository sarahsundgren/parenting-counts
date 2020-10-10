///////////////////////////////////////////////////////////////////////////////////////////////////
// CUSTOM SHELL FUNCTIONALITY
//
// @author    Allen Communication Learning Services
// @version   3.2
// @comments  The ActionScript within this document comprises customizations to the core
//			  shell functionality. Core variables and functions are prefixed with '$'.
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Load a new page
**/
gShell.$loadPage = function(xnodePage, bForward:Boolean): Boolean
{
	gShell.m_arrPageNoteIDs = new Array();
	if (m_bHelpHighlighted)
		gShell.highlightHelpBtn(false);
	if (m_bExitHighlighted)
		gShell.highlightExitBtn(false);
	if (m_bPauseHighlighted)
		gShell.highlightPauseBtn(false);
	if (m_bNotesHighlighted)
		gShell.highlightNotesBtn(false);
	if (m_bToolsHighlighted)
		gShell.highlightToolsBtn(false);
	if (m_bResourcesHighlighted)
		gShell.highlightResourcesBtn(false);
	return gShell.$core_loadPage(xnodePage, bForward);
}

/**
* Notification received when the current page has loaded.
*
* @param   ref_xtcMovie   handle to the page movie (class)
* @param   bCustomMovie	  true if loading a custom movie; false if a template
**/	
gShell.$onPageLoaded = function(ref_xtcMovie:MovieClip, bCustomMovie:Boolean): Void
{
	gShell.$core_onPageLoaded(ref_xtcMovie, bCustomMovie);	
	var nDepth: Number = gShell.$getAnchorPageNode().xtc_getDepth();
	
	if ((gShell.$getCurrentPageNode().xtc_isContained()) || (nDepth <= 3))
	{		
		gLeftMenu.destroyCustomMenu();
		m_xtcLeftMenuNode = null;
	}
	if ((gShell.$getCurrentPageNode().xtc_isContained()) || (nDepth < 2))
	{
		gRightMenu.$show(false);
		gBottomMenu.destroyCustomMenu();
		m_xtcBottomMenuNode = null;		
	}
	else
	{
		if (m_nOldPageZOrder)
			gShell.swapPageAndMenus(false);
		if (!gRightMenu.$isVisible())
			gRightMenu.$show(true);		
	}
	
	if (gShell.$getCurrentPageNode().xtc_isContained())
		return;
	
	if (nDepth >= 2)
	{
		var xtcNewBottomMenuNode /*XTC_CourseNode*/ = gShell.$getAnchorPageNode().xtc_getParent(-(gShell.$getAnchorPageNode().xtc_getDepth() - 1));
		if (xtcNewBottomMenuNode != m_xtcBottomMenuNode)
		{
			gRightMenu.$show(true);
			m_xtcBottomMenuNode = xtcNewBottomMenuNode;
			gBottomMenu.createCustomMenu(m_xtcBottomMenuNode);
		}
		else
			gBottomMenu.$onUpdate();
	}
	
	if (nDepth >= 4)
	{
		var xtcNewLeftMenuNode /*XTC_CourseNode*/ = nDepth == 5 ? gShell.$getAnchorPageNode().xtc_getParent(-3) : gShell.$getAnchorPageNode().xtc_getParent(-2);
		if (xtcNewLeftMenuNode != m_xtcLeftMenuNode)
		{
			m_xtcLeftMenuNode = xtcNewLeftMenuNode;
			gLeftMenu.createCustomMenu(m_xtcLeftMenuNode);
		}
		else
		{
			gLeftMenu.$onUpdate();
			if (!gLeftMenu.$isVisible())
				gLeftMenu.$show(true);
		}
	}
}

/**
* Notification received when the current page is complete.
*
* @param  ref_mcMovie    handle to the page movie
**/		
gShell.$onPageComplete = function(ref_mcMovie:MovieClip): Void
{
	gShell.$core_onPageComplete(ref_mcMovie);
	
	gLeftMenu.$onUpdate();
	gBottomMenu.$onUpdate();
}