///////////////////////////////////////////////////////////////////////////////////////////////////
// CUSTOM SHELL FUNCTIONALITY
//
// @author    Allen Communication Learning Services
// @version   3.2
// @comments  The ActionScript within this document comprises customizations to the core
//			  shell functionality. Core variables and functions are prefixed with '$'.
///////////////////////////////////////////////////////////////////////////////////////////////////


/**
* Notification received when the current page has loaded.
*
* @param   ref_xtcMovie   handle to the page movie (class)
* @param   bCustomMovie	  true if loading a custom movie; false if a template
**/	
gShell.$onPageLoaded = function(ref_xtcMovie:MovieClip, bCustomMovie:Boolean): Void
{
	gShell.$core_onPageLoaded(ref_xtcMovie, bCustomMovie);	
}

/**
* Notification received when the current page is complete.
*
* @param  ref_mcMovie    handle to the page movie
**/		
gShell.$onPageComplete = function(ref_mcMovie:MovieClip): Void
{
	gShell.$core_onPageComplete(ref_mcMovie);
}