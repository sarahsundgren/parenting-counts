///////////////////////////////////////////////////////////////////////////////////////////////////
// Standard index/launcher functions 
// 
// @author   Allen Communication Learning Services
// @version  3.2
// 
// DO NOT MODIFY THIS DOCUMENT
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
// CORE CONSTANTS
///////////////////////////////////////////////////////////////////////////////////////////////////

var _ACLS_DOCUMENT_   = true;						// Reserved flag that should be in any page that opens or contains the course

var LAUNCH_NORMAL	  = 0;							// Indicates that the course window should redirect normally (no resizing/moving)
var LAUNCH_RESIZE	  = 1;							// Indicates that the course window should redict and resize
var LAUNCH_LOCKEDSIZE = 2;							// Indicates that the course window should redict and resize (keeping the size locked)
var LAUNCH_POPUP	  = 3;							// Indicates that the course window should open in a new window (sized/positioned)

var TOOLBAR		= 0;								// ID of the toolbar window option
var LOCATION	= 1;								// ID of the location window option
var STATUS		= 2;								// ID of the status window option
var MENUBAR 	= 3;								// ID of the menu window option
var SCROLLBARS	= 4;								// ID of the scrollbars window option
var RESIZABLE	= 4;								// ID of the resizeable window option

													// Messages
var MSG_LOADING			= "Loading...";
var MSG_POPUPLAUNCH		= "If the course does not launch within 5 seconds you might have a popup blocker installed. Click <A href='javascript: void(0)' onclick='$launchCourse();'>here</A> to try again. If the link does not work, you will need to disable your popup blocker to view the course.";
var MSG_NOCLOSELAUNCH	= "DO NOT CLOSE this window until after closing the course window!<BR>The course will not track completion if this window is closed prematurely.";

///////////////////////////////////////////////////////////////////////////////////////////////////
// CORE VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////////////

var $m_bLauncher				= true;				// Identifies this window as a launching window
var $m_hwndCourse				= null;				// Handle to the course window
var $m_strParams				= "";				// URL params to pass at launch
var $m_nLaunchMode				= LAUNCH_POPUP;		// Open the course in a separate popup window, a resized window, or the default browser window
var $m_nBrowserWidth			= 792;				// The width of the course window
var $m_nBrowserHeight			= 515;				// The height of the course window
var $m_nCourseX					= null;				// X coordinate of the course window (if null, window will be centered)
var $m_nCourseY					= null;				// Y coordinate of the course window (if null, window will be centered)
var $m_urlCourse				= "course.htm";		// URL of the course HTML page to launch
var $m_strDataTrackingMode		= null;				// What type of datatracking should be used when running online?
var $m_arrPopupCfg				= new Array();		// Popup window options
	$m_arrPopupCfg[TOOLBAR]		= false;
	$m_arrPopupCfg[LOCATION]	= false;
	$m_arrPopupCfg[STATUS]		= false;
	$m_arrPopupCfg[MENUBAR]		= false;
	$m_arrPopupCfg[SCROLLBARS]	= false;
	$m_arrPopupCfg[RESIZABLE]	= false;

///////////////////////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Event handler triggered when the window has loaded
**/
function $core_onLoad()
{
		// Check the software specs (before the page loads)
	if ((typeof($m_bValidateSysReqs) != "undefined") && ($m_bValidateSysReqs == true))
		$SYSREQ_validate();

	try{
		if ((!window.opener) || (typeof(window.opener) == "undefined") || (typeof(window.opener) == "string"))
			window.opener = "fake opener";
	}catch(err){}
	
	if (typeof($m_nCourseWidth) != "undefined")
		$m_nBrowserWidth = $m_nCourseWidth;		// For backwards compatibility
	if (typeof($m_nCourseHeight) != "undefined")
		$m_nBrowserHeight = $m_nCourseHeight;	// For backwards compatibility

		// Center the window (if coordinates not already specified)
	if ($m_nLaunchMode != LAUNCH_NORMAL)
	{
		if ($m_nCourseX == null)
		{
			$m_nCourseX = (screen.width / 2) - ($getBrowserWidth() / 2) - 5;
			if ($m_nCourseX <= 3)
				$m_nCourseX = 0;
		}
		if ($m_nCourseY == null)
		{
			$m_nCourseY = (screen.height / 2) - ($getBrowserHeight() / 2) - 32;
			if ($m_nCourseY <= 3)
				$m_nCourseY = 0;
		}

		if ($m_nLaunchMode == LAUNCH_LOCKEDSIZE)
			$m_strParams += "&$m_bLockSize=true";
			
	}

	if ($m_strDataTrackingMode)
		$m_strParams += "&$m_strDataTrackingMode=" + $m_strDataTrackingMode;

		// Check for url params
	$m_urlCourse = (window.location.search.length > 1) ? $m_urlCourse + window.location.search + $m_strParams : $m_urlCourse + "?" + $m_strParams;

	if ((typeof($m_bValidateSysReqs) == "undefined") || (!$m_bValidateSysReqs) || ($m_bValid_SysReqs))
	{
		if (document.getElementById("IndexLayer"))
		{
			document.getElementById("IndexLayer").style.visibility = "visible";
			document.getElementById("IndexLayer").style.overflow = "auto";
			document.getElementById("IndexLayer").style.height = "auto";
		}
		$launchCourse();
	}
	else
	{
		if (!$m_arrSysReqs[BROWSER].m_bRequired && document.getElementById("SysReqBrowser"))
			document.getElementById("SysReqBrowser").style.display = "none";

		if (!$m_arrSysReqs[FLASH].m_bRequired && document.getElementById("SysReqFlash"))
			document.getElementById("SysReqFlash").style.display = "none";

		if (!$m_arrSysReqs[ACROBAT].m_bRequired && document.getElementById("SysReqAcrobat"))
			document.getElementById("SysReqAcrobat").style.display = "none";
		
		if (!$m_arrSysReqs[SCREENRES].m_bRequired && document.getElementById("SysReqScreenRes"))
			document.getElementById("SysReqScreenRes").style.display = "none";

		if (document.getElementById("SysReqLayer"))
		{
			document.getElementById("SysReqLayer").style.visibility = "visible";
			document.getElementById("SysReqLayer").style.overflow = "auto";
			document.getElementById("SysReqLayer").style.height = "auto";
		}
	}
}
	// Assign default/overridable function
$onLoad = $core_onLoad;


/**
* Launch the course
**/
function $core_launchCourse()
{
		// If opening a popup...
	if ($m_nLaunchMode == LAUNCH_POPUP)
	{
		if (document.getElementById("info"))
			document.getElementById("info").style.visibility = "visible";
		if (document.getElementById("infoPopupBlocker"))
			document.getElementById("infoPopupBlocker").style.visibility = "visible";
			// Determine window format
		var strOptions = "";

		strOptions += "toolbar=" + ($m_arrPopupCfg[TOOLBAR] ? "yes," : "no,");
		strOptions += "location=" + ($m_arrPopupCfg[LOCATION] ? "yes," : "no,");
		strOptions += "status=" + ($m_arrPopupCfg[STATUS] ? "yes," : "no,");
		strOptions += "menubar=" + ($m_arrPopupCfg[MENUBAR] ? "yes," : "no,");
		strOptions += "scrollbars=" + ($m_arrPopupCfg[SCROLLBARS] ? "yes," : "no,");
		strOptions += "resizable=" + ($m_arrPopupCfg[RESIZABLE] ? "yes," : "no,");

			// Open and focus the window
		$m_hwndCourse = window.open($m_urlCourse, "HWND" + new Date().getTime(), strOptions + ",width=" + $getBrowserWidth() + ",height=" + $getBrowserHeight() + ",left=" + $m_nCourseX + ",top=" + $m_nCourseY);	
		if ($m_hwndCourse)
			$m_hwndCourse.focus();
	}
		// Otherwise, redirect
	else
	{
		if (document.getElementById("loadingInfo"))
			document.getElementById("loadingInfo").style.visibility = "visible";
		setTimeout($redirect, 400);
	}
}
	// Assign default/overridable function
$launchCourse = $core_launchCourse;

/**
* Get the client area
*
* @return  array containing the client area [width, height]
**/
function $core_getClientSize()
{
	var nWidth;;
	var nHeight;

		// all except Explorer
	if (window.innerHeight)
	{
		nWidth  = top.window.innerWidth;
		nHeight = top.window.innerHeight;
	}
		// Explorer 6 Strict Mode
	else if ((document.documentElement) & (document.documentElement.clientWidth || document.documentElement.clientHeight))
	{
		nWidth  = top.document.documentElement.clientWidth;
		nHeight = top.document.documentElement.clientHeight;
	}
		// other Explorers
	else if (document.body) 
	{
		nWidth  = top.document.body.clientWidth;
		nHeight = top.document.body.clientHeight;
	}
	return [nWidth, nHeight];
}
	// Assign default/overridable function
$getClientSize = $core_getClientSize;

/**
* Get the specified browser width while taking the current DIP into account
*
* @return  the specified browser width
**/
function $core_getBrowserWidth()
{
	if (screen.deviceXDPI != null && screen.deviceXDPI != screen.logicalXDPI)
		return $m_nBrowserWidth * screen.logicalXDPI / screen.deviceXDPI;
	else
		return $m_nBrowserWidth;
}
	// Assign default/overridable function
$getBrowserWidth = $core_getBrowserWidth;

/**
* Get the specified browser height while taking the current DIP into account
*
* @return  the specified browser height
**/
function $core_getBrowserHeight()
{
	if (screen.deviceYDPI != null && screen.deviceYDPI != screen.logicalYDPI)
		return $m_nBrowserHeight * screen.logicalYDPI / screen.deviceYDPI;
	else
		return $m_nBrowserHeight;
}
	// Assign default/overridable function
$getBrowserHeight = $core_getBrowserHeight;

/**
* Resize/redirect the course (as opposed to launching a new window)
**/
function $core_redirect()
{
		// Re-position the window (if not a normal launch)
	if ($m_nLaunchMode != LAUNCH_NORMAL)
	{
		try{
			top.window.moveTo($m_nCourseX, $m_nCourseY);
		}catch(err){}
	}
	if (($m_nLaunchMode == LAUNCH_RESIZE) || ($m_nLaunchMode == LAUNCH_LOCKEDSIZE))
	{
		try{
			top.window.resizeTo($getBrowserWidth(), $getBrowserHeight());

			var arrSize = $getClientSize();
			var nDiffW  = $getBrowserWidth()  - arrSize[0];
			var nDiffH  = $getBrowserHeight() - arrSize[1];

			top.window.resizeBy(nDiffW, nDiffH);

				// Pass along the size in the URL params
			if ($m_nLaunchMode == LAUNCH_LOCKEDSIZE)
				$m_urlCourse += "&$m_nLockWidth=" + ($getBrowserWidth() + nDiffW) + "&$m_nLockHeight=" + ($getBrowserHeight() + nDiffH);
		}catch(err){}
	}
		// Re-direct
	document.location.href = $m_urlCourse;
}
	// Assign default/overridable function
$redirect = $core_redirect;


/**
* Write the "Loading" message
**/
function $core_writeLoadingMsg()
{
	document.writeln(MSG_LOADING);
}
	// Assign default/overridable function
$writeLoadingMsg = $core_writeLoadingMsg;

/**
* Write the "Popup blocker" message
**/
function $core_writePopupLaunchMsg()
{
	document.writeln(MSG_POPUPLAUNCH);
}
	// Assign default/overridable function
$writePopupLaunchMsg = $core_writePopupLaunchMsg;

/**
* Write the "Do not close widow" message
**/
function $core_writeNoCloseLaunchMsg()
{
	document.writeln(MSG_NOCLOSELAUNCH);
}
	// Assign default/overridable function
$writeNoCloseLaunchMsg = $core_writeNoCloseLaunchMsg;