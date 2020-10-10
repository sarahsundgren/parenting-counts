///////////////////////////////////////////////////////////////////////////////////////////////////
// MULTI-LEVEL BOTTOM MENU FUNCTIONALITY
// 
// Note: The current menu functionality supports up to 3 menu levels, which can be set via the
//		 CONFIG.XML document.
//
// MENU ELEMENTS
//
// mc_L1Template												// The first-level menu selection movieclip/template to clone
// mc_L2Template												// The second-level menu selection movieclip/template to clone
// mc_L3Template												// The third-level menu selection movieclip/template to clone
///////////////////////////////////////////////////////////////////////////////////////////////////

var X_6ITEMS:    Number = 57;
var X_5ITEMS:    Number = 137;
var X_4ITEMS:    Number = 205;

var m_bSyncSecondToLastPhoto:Boolean = false;

gBottomMenu.$getL1AnchorCoords = function(Void): Object
{
	if ($getMenuNodes().xtc_getChildCount() == 5)
		return {x:X_5ITEMS};
	else if ($getMenuNodes().xtc_getChildCount() == 4)
		return {x:X_4ITEMS};
	else
		return {x:X_6ITEMS};
}
	
///////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////

gBottomMenu.$onSelectionInit = function(ref_xtcSelection): Void
{
	var mcImageMask:   MovieClip = gBottomMenu.attachMovie("mc_Mask", "mc_ImageMask" + String(ref_xtcSelection.xtc_getID()), gBottomMenu.getNextHighestDepth(), {_x:gBottomMenu.MASK_X, _y:gBottomMenu.MASK_Y, _visible:false});
	var mcHotspotMask: MovieClip = gBottomMenu.attachMovie("mc_Mask", "mc_HotspotMask" + String(ref_xtcSelection.xtc_getID()), gBottomMenu.getNextHighestDepth(), {_x:gBottomMenu.MASK_X, _y:gBottomMenu.MASK_Y, _visible:false});

	if (ref_xtcSelection.xtc_getID() == $getMenuNodes().xtc_getChildCount())
		ref_xtcSelection.m_mcIcon.gotoAndStop("_conclusion");
	else if ((m_bSyncSecondToLastPhoto) && (ref_xtcSelection.xtc_getID() == $getMenuNodes().xtc_getChildCount() - 1))
		ref_xtcSelection.m_mcIcon.gotoAndStop("_pre_conclusion");
	else
		ref_xtcSelection.m_mcIcon.gotoAndStop(ref_xtcSelection.xtc_getID());
	ref_xtcSelection.m_mcIcon.setMask(mcImageMask);
	ref_xtcSelection.m_btnHotSpot.setMask(mcHotspotMask);
	ref_xtcSelection.m_btnHotSpot2.onRollOver = ref_xtcSelection.m_btnHotSpot.onRollOver;
	ref_xtcSelection.m_btnHotSpot2.onRollOut  = ref_xtcSelection.m_btnHotSpot.onRollOut;
	ref_xtcSelection.m_btnHotSpot2.onRelease  = ref_xtcSelection.m_btnHotSpot.onRelease;
	
	switch($getMenuNodes().xtc_getChildCount())
	{		
		case 4:
			if (ref_xtcSelection.xtc_getID() == 1)
				ref_xtcSelection.m_txtTitle._y = 79;
			else if (ref_xtcSelection.xtc_getID() == 2)
				ref_xtcSelection.m_txtTitle._y = 75;
			else if (ref_xtcSelection.xtc_getID() == 3)
				ref_xtcSelection.m_txtTitle._y = 73;
			else if (ref_xtcSelection.xtc_getID() == 4)
				ref_xtcSelection.m_txtTitle._y = 80;
			
			if (ref_xtcSelection.xtc_getID() == 1)
				ref_xtcSelection.m_mcStatus._y = 75;
			else if (ref_xtcSelection.xtc_getID() == 2)
				ref_xtcSelection.m_mcStatus._y = 69;
			else if (ref_xtcSelection.xtc_getID() == 3)
				ref_xtcSelection.m_mcStatus._y = 66;
			else if (ref_xtcSelection.xtc_getID() == 4)
				ref_xtcSelection.m_mcStatus._y = 71;
			break;
		case 5:
			if (ref_xtcSelection.xtc_getID() == 1)
				ref_xtcSelection.m_txtTitle._y = 88;
			else if (ref_xtcSelection.xtc_getID() == 2)
				ref_xtcSelection.m_txtTitle._y = 81;
			else if (ref_xtcSelection.xtc_getID() == 3)
				ref_xtcSelection.m_txtTitle._y = 79;
			else if (ref_xtcSelection.xtc_getID() == 4)
				ref_xtcSelection.m_txtTitle._y = 80;
			else if (ref_xtcSelection.xtc_getID() == 5)
				ref_xtcSelection.m_txtTitle._y = 84;
			
			if (ref_xtcSelection.xtc_getID() == 1)
				ref_xtcSelection.m_mcStatus._y = 81;
			else if (ref_xtcSelection.xtc_getID() == 2)
				ref_xtcSelection.m_mcStatus._y = 72;
			else if (ref_xtcSelection.xtc_getID() == 3)
				ref_xtcSelection.m_mcStatus._y = 67;
			else if (ref_xtcSelection.xtc_getID() == 4)
				ref_xtcSelection.m_mcStatus._y = 68;
			else if (ref_xtcSelection.xtc_getID() == 5)
				ref_xtcSelection.m_mcStatus._y = 74;
			break;
		default:
			if (ref_xtcSelection.xtc_getID() == 1)
				ref_xtcSelection.m_txtTitle._y = 92;
			else if (ref_xtcSelection.xtc_getID() == 2)
				ref_xtcSelection.m_txtTitle._y = 82;
			else if (ref_xtcSelection.xtc_getID() == 3)
				ref_xtcSelection.m_txtTitle._y = 78;
			else if (ref_xtcSelection.xtc_getID() == 4)
				ref_xtcSelection.m_txtTitle._y = 76;
			else if (ref_xtcSelection.xtc_getID() == 5)
				ref_xtcSelection.m_txtTitle._y = 79;
			else if (ref_xtcSelection.xtc_getID() == 6)
				ref_xtcSelection.m_txtTitle._y = 88;
			
			if (ref_xtcSelection.xtc_getID() == 1)
				ref_xtcSelection.m_mcStatus._y = 90;
			else if (ref_xtcSelection.xtc_getID() == 2)
				ref_xtcSelection.m_mcStatus._y = 77;
			else if (ref_xtcSelection.xtc_getID() == 3)
				ref_xtcSelection.m_mcStatus._y = 69;
			else if (ref_xtcSelection.xtc_getID() == 4)
				ref_xtcSelection.m_mcStatus._y = 67;
			else if (ref_xtcSelection.xtc_getID() == 5)
				ref_xtcSelection.m_mcStatus._y = 70;
			else if (ref_xtcSelection.xtc_getID() == 6)
				ref_xtcSelection.m_mcStatus._y = 78;
			break;
	}	
	
	var fmtText:TextFormat = ref_xtcSelection.m_txtTitle.getTextFormat();
	if (ref_xtcSelection.m_txtTitle._height > 35)
		fmtText.leading = -1;
	else
		fmtText.leading = 1;
	
	ref_xtcSelection.m_txtTitle.setNewTextFormat(fmtText);
	ref_xtcSelection.m_txtTitle.setTextFormat(fmtText);
	ref_xtcSelection.m_btnHotSpot2._height = ref_xtcSelection.m_txtTitle._y + ref_xtcSelection.m_txtTitle._height - ref_xtcSelection.m_btnHotSpot2._y - 4; 
}