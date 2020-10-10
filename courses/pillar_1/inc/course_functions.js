///////////////////////////////////////////////////////////////////////////////////////////////////
// Standard course functions 
// 
// @author   Allen Communication Learning Services
// @version  3.2
// 
// DO NOT MODIFY THIS DOCUMENT
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
// CONSTANTS
///////////////////////////////////////////////////////////////////////////////////////////////////

var _ACLS_DOCUMENT_			= true;						// Reserved flag that should be in any page that opens or contains the course

var DATATYPE_UNAVAILABLE	= null;						// Data-tracking types
var DATATYPE_NONE			= "NONE";
var DATATYPE_SCORM			= "SCORM";
var DATATYPE_DBASE			= "DBASE";
var DATATYPE_AICC			= "AICC";
var DATATYPE_COOKIES		= "COOKIES";

var ERROR_NONE				= 0;						// Error values
var ERROR_GENERALEXCEPTION	= 101; 
var ERROR_INVALIDARG		= 201;
var ERROR_NOTINITIALIZED	= 301;
var ERROR_NOTIMPLEMENTED	= 401;

var EVENT_RIGHTCLICK		= 2;						// Indicates a right-click event

var DISABLED				= 0;						// Setting flags
var ENABLED					= 1;
var MAXIMIZED				= 2;
var LEVEL1					= 1;
var LEVEL2					= 2;

var IGNORE					= 0;						// Alert types
var ALERT					= 1;
var PROMPT					= 2;
var EXIT					= 3;

														// Messages
var WARNINGMSG_EXIT			= "To save your data you must use the Exit button in the course.\n\nClick the Cancel button below to return to the course and save your data using the Exit button. Click OK if you would like to Exit the course without saving your data.";
var ERRORMSG_LMSINIT		= "LMS communication failure. Your data will not be saved for this session!";
var ERRORMSG_LMSINITEXIT	= "LMS communication failure. The current session cannot continue!\n\nClick OK to exit.";
var ERRORMSG_LMSINITPROMPT	= "LMS communication failure. Your data will not be saved for this session.\n\nClick OK if you would like to continue without data tracking.\nClick Cancel to exit.";
var ERRORMSG_LMSSAVE		= "LMS communication failure: %LMSFUNCTION%.\nYour data could not be saved!";
var ERRORMSG_LMSSAVEEXIT	= "LMS communication failure: %LMSFUNCTION%.\nYour data could not be saved!  The current session cannot continue.\n\nClick OK to exit.";
var ERRORMSG_LMSCOMM		= "LMS communication failure: %LMSFUNCTION%.";
var ERRORMSG_LMSEXITED		= "LMS communication failure: %LMSFUNCTION%.\n\nLMSFinish() has already been called.";
var SAVEMSG_EXIT			= "Your data has been saved.";

///////////////////////////////////////////////////////////////////////////////////////////////////
// CORE VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////////////

var $m_strProtocol 			= top.window.document.location.protocol == "https:" ? "https:" : "file:///";	// Protocol to use for communcation
var $m_strFlashID			= "objFlash";				// The Flash movie to load (default to "flash/shell.swf" or "flash_7/shell.swf" when loading)
var $m_strFlashSrc			= null;						// The Flash movie to load (default to "flash/shell.swf" or "flash_7/shell.swf" when loading)
var $m_nFlashVer			= 8;						// Required Flash version (default to 8)
var $m_nFlashWidth			= "100%";					// The width of the Flash movie (default to 100%--generally do not need to override this)
var $m_nFlashHeight			= "100%";					// The height of the Flash movie (default to 100%--generally do not need to override this)
var $m_strFlashScale		= "noscale";				// Flash scaling setting
var $m_strFlashWMode		= "opaque";					// Flash window mode
var $m_strFlashBgColor		= "#FFFFFF";				// Flash background color
var $m_bBlockRightclicks	= true;						// Block right clicks?
var $m_strFlashVars			= "";						// The FlashVars data to load into the Flash movie (individual FlashVar parameters--not the entire string--should be "escaped" to prevent invalid characters)
var $m_bASCommunication		= false;					// Is direct (ExternalInterface) ActionScript communication supported?
var $m_bDebug				= false;					// Enable debug messages? (default to off)
var $m_objFlash				= null;						// Handle to the Flash object
var $m_divFlash				= null;						// Handle to the Flash div layer (intercepts right clicks)
var $m_wndSCORM				= null;						// Handle to the SCORM container/window
var $m_apiSCORM				= null;						// Handle to the SCORM API object
var $m_bSCORMFound			= false;					// Has the SCORM API object been found?
var $m_bSCORMSaved			= false;					// Has data been saved to the SCORM LMS?
var $m_nSCORMInitFailAction	= EXIT;						// How to deal with SCORM initialization failures (ALERT, PROMPT, EXIT -- EXIT recommended)
var $m_nSCORMLostAPIAction	= ALERT;					// How to deal with SCORM API connectivity issues (IGNORE, ALERT, EXIT -- ALERT recommended)
var $m_bNoAllenCommData		= true;						// Disable data tracking when run from an allencomm.com server (for review/testing)
var $m_apiSumTotal			= null;						// Handle to the SumTotal Extended API
var $m_bSumTotalLMS			= false;					// Is the SumTotal LMS in use?
var $m_objData				= null;						// Collection of data to commit to the LMS (serves as a cache to prevent excessive LMS communication)
var $m_objDebugData			= null;						// Handle to a debug/testing object (containing values to pass into the course)
var $m_strDataMethod		= DATATYPE_UNAVAILABLE;		// The initialized data type/method
var $m_nStartTime			= null;						// Session start time (SCORM)
var $m_bDataIOTerminated	= false;					// Was the data connection terminated?
var $m_bCloseLauncher		= false;					// Should the launching window be closed?
var $m_bCloseLauncherOnExit = true;						// Should the launching window be closed when exiting?
var $m_bUnloading			= false;					// Is the window unloading?
var $m_bWindowClosing		= false;					// Is the window closing?
var $m_bWarnOnExit			= false;					// Should the user be warned if exiting via the browser instead of the course shell?
var $m_bConfirmSaveOnExit	= false;					// Should the user be told their data has saved when exiting?
var $m_bLockSize			= false;					// Should the window size be locked?
var $m_nLockWidth			= null;						// Locked window width
var $m_nLockHeight			= null;						// Locked window height
var $m_3rdPartyEmbedded		= false;					// 3rd party embedded?
var $m_bInMamba				= false;					// Are we launching from within Mamba?
var $m_bInCourseEXE			= false;					// Are we launching from within Mamba IE Container?
var $m_strDataTrackingMode	= null;						// What type of datatracking should be used when running online?
var $m_nCourseEXEClose		= DISABLED;					// Should the Mamba IE container have a close button?
var $m_nCourseEXEResize		= DISABLED;					// Should the Mamba IE container allow resizing?
var $m_nCourseEXEDebug		= DISABLED;					// Should the Mamba IE container show debug messages?
var $m_nCourseEXEWidth		= 1014;						// The width of the Flash movie (default to 100%--generally do not need to override this)
var $m_nCourseEXEHeight		= 658;						// The height of the Flash movie (default to 100%--generally do not need to override this)


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// COURSE & WINDOW API
//
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
// COURSE - INITIALIZATION
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Pre-initialize the HTML
**/
function $core_preInit()
{
		// If the window was opened through our popup launcher and it didn't open correctly, close the window down before it initializes
	if (($isValidOpener(top.window.opener)) && (typeof(top.window.opener.$m_bLauncher) != "undefined"))
	{
		if ((top.window.opener.$m_nLaunchMode == top.window.opener.LAUNCH_POPUP) && (top.window.outerWidth === 0) && (top.window.outerHeight === 0))
		{
			top.window.close();
			return;
		}
	}
	
	try{
		if (window.external.$isIEContainer())
		{
			window.external.$setLaunchParams($m_nCourseEXEClose, $m_nCourseEXEResize, $m_nCourseEXEDebug, $m_nCourseEXEWidth, $m_nCourseEXEHeight);
			$m_bInCourseEXE = true;
		}
	}catch(err)
	{
		$m_bInCourseEXE = false;
	}
	if ($getURLParam("_MAMBA_ENV_") == "true")
		$m_bInMamba = true;

		// Hide the opener's message
	try{
		if ((top.window.opener) && (top.window.opener.document.getElementById("infoPopupBlocker")))
			top.window.opener.document.getElementById("infoPopupBlocker").style.visibility = "hidden";
	}catch(err){}
		// Show the "no close" message
	try{
		if ((top.window.opener) && (top.window.opener.document.getElementById("infoNoClose")) && (!$m_bCloseLauncher))
			top.window.opener.document.getElementById("infoNoClose").style.visibility = "visible";
	}catch(err){}

		// Close the launching window
	if ($m_bCloseLauncher)
	{
		try{
			if (($isValidOpener(top.window.opener)) && (typeof(top.window.opener.$m_bLauncher) != "undefined"))
			{
				if ((top.window.opener.$m_nLaunchMode == top.window.opener.LAUNCH_POPUP) && (!$m_bInMamba))
				{
					top.window.opener.top.open('','_self','');
					top.window.opener.top.close();
				}
			}
		}catch(err){}
	}
	window.focus();

		// check for third-party embedding
	$m_3rdPartyEmbedded = true;
	if (top._ACLS_DOCUMENT_)
		$m_3rdPartyEmbedded = false;
	else
	{
		try{
			if ($isValidOpener(top.window.opener))
			{
				if (top.window.opener.top._ACLS_DOCUMENT_)
					$m_3rdPartyEmbedded = false;
			}
		}catch(err){} 
	}

		// For direct Flash communication off for Flash 7
	if ($m_nFlashVer == 7)
		$m_bASCommunication = false;

		// Get passed params
	if ($getURLParam("$m_bLockSize") == "true")
		$m_bLockSize = true;

	var strDataTrackingMode = $getURLParam("$m_strDataTrackingMode");

	if (strDataTrackingMode)
		$m_strDataTrackingMode = strDataTrackingMode;
}
	// Assign default/overridable function
$preInit = $core_preInit;


/**
* Event handler triggered when the window has loaded
**/
function $core_onLoad()
{
		// Deal with right-click issues
	if ($m_bBlockRightclicks)
	{
		document.oncontextmenu = $onContextMenu
		if (window.addEventListener)
			window.addEventListener("mousedown", $onAltBrowserMouseDown, true);
	}

	if ($m_bLockSize)
		$getLockSize();
	window.focus();

	if ($m_objFlash)
		$m_objFlash.focus();
}
	// Assign default/overridable function
$onLoad = $core_onLoad;



///////////////////////////////////////////////////////////////////////////////////////////////////
// COURSE - EXITING
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Exit the course (Can be called by Flash)
**/
function $core_exitCourse()
{
		// If SumTotal LMS, trigger its exit routine
	if ($m_bSumTotalLMS)
		$SCORM_exitSumTotalLMS();

	$requestExit = null;
	if ((!$m_bWindowClosing) && ((!$m_bInMamba) || ($isValidOpener(top.window.opener))))
		top.window.close();
}
	// Assign default/overridable function
$exitCourse = $core_exitCourse;



/**
* Request the shell to exit (sent via IE Container)
**/
function $core_requestExit()
{
	$callASFunction("$requestExit");
}
	// Assign default/overridable function
$requestExit = $core_requestExit;


/**
* Event handler triggered when the window is about to unload
*
* @return	the warning prompt (WARNINGMSG_EXIT), if appropriate
**/
function $core_onBeforeUnload()
{
		// Terminate the data connection
	if ($m_strDataMethod == DATATYPE_SCORM || $m_strDataMethod == DATATYPE_COOKIES)
	{
		if (!$m_bDataIOTerminated)
		{
				// Flag that the window is in the proccess of closing
			$m_bWindowClosing = true;
				
				// If a flash shell is in use, have it exit (which will trigger the final SCORM save/finish)
			if ($m_objFlash)
			{
				if ($m_bASCommunication)
					$callASFunction("$exit");
				else
					$callASFunction("$onUnload");
			}
				// If flash not present, or not able to directly communicate, then commit and terminate SCORM 
			if (($m_strDataMethod == DATATYPE_SCORM) && ((!$m_objFlash) || (!$m_bASCommunication)))
			{
					// Capture the session time, then commit and terminate
				$SCORM_setValue("cmi.core.session_time");
				$SCORM_commitData();
				$SCORM_finish();
			}
		}
			// Show save confirmation alert
		if (($m_bConfirmSaveOnExit) && (($m_bSCORMSaved) || ($m_strDataMethod == DATATYPE_COOKIES)))
			alert(SAVEMSG_EXIT);
	}
		// Otherwise, confirm exit
	else if ((!$m_bDataIOTerminated) && ($m_bWarnOnExit))
		return WARNINGMSG_EXIT;
}
	// Assign default/overridable function
$onBeforeUnload = $core_onBeforeUnload;


/**
* Event handler triggered when the window is unloading
**/
function $core_onUnload()
{
	if (!$m_bUnloading)
	{
		$m_bUnloading = true;
			// Show save confirmation alert
		if (($m_bConfirmSaveOnExit) && ($m_strDataMethod) && ($m_strDataMethod != DATATYPE_SCORM))
			alert(SAVEMSG_EXIT);

			// If SumTotal LMS, trigger its exit routine
		if ($m_bSumTotalLMS)
			$SCORM_exitSumTotalLMS();
			// Close the opener (if ours)
		else if (($m_bCloseLauncherOnExit) && (!$m_bInMamba))
		{
			if ($isValidOpener(top.window.opener))
			{
				top.window.opener.top.open('','_self','');
				top.window.opener.top.close();
			}
		}
	}
}
	// Assign default/overridable function
$onUnload = $core_onUnload;


///////////////////////////////////////////////////////////////////////////////////////////////////
// COURSE - WINDOW MANAGEMENT
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Get the client area
*
* @return	array containing the client area [width, height]
**/
function $core_getClientSize()
{
	var nWidth;;
	var nHeight;

		// all except Explorer
	if (window.innerHeight)
	{
		nWidth	= window.innerWidth;
		nHeight	= window.innerHeight;
	}
		// Explorer 6 Strict Mode
	else if ((document.documentElement) & (document.documentElement.clientWidth || document.documentElement.clientHeight))
	{
		nWidth	= document.documentElement.clientWidth;
		nHeight	= document.documentElement.clientHeight;
	}
		// other Explorers
	else if (document.body) 
	{
		nWidth	= document.body.clientWidth;
		nHeight	= document.body.clientHeight;
	}
	return [nWidth, nHeight];
}
	// Assign default/overridable function
$getClientSize = $core_getClientSize;


/**
* Determine the locked size of the window
**/
function $core_getLockSize()
{
	if ($getURLParam("$m_nLockWidth"))
	{
		$m_nLockWidth	= parseInt($getURLParam("$m_nLockWidth"));
		$m_nLockHeight	= parseInt($getURLParam("$m_nLockHeight"));
	}
	else
	{
		var arrSize	= $getClientSize();
		var nWidth	= arrSize[0];
		var nHeight	= arrSize[1];

		try{
			window.resizeTo(arrSize[0], arrSize[1]);
			arrSize = $getClientSize();
			var nDiffW	= nWidth  - arrSize[0];
			var nDiffH	= nHeight - arrSize[1];
			window.resizeBy(nDiffW, nDiffH);

			$m_nLockWidth	= nWidth;
			$m_nLockHeight	= nHeight;
		}
		catch(err){
			$m_bLockSize = false;
		}
	}
}
	// Assign default/overridable function
$getLockSize = $core_getLockSize;


/**
* Event handler triggered when the window has resized
**/
function $onResize(objEvent)
{
	if (($m_nLockWidth) && ($m_bLockSize))
	{
		try{
			window.resizeTo($m_nLockWidth, $m_nLockHeight);
		}
		catch(err){
			setTimeout("$onResize()", 100);
		}
	}
}

/**
* Open a popup window
*
* @param hwndPopup		handle to an existing popup window (to prevent multiple popups)
* @param strName		unique name of the popup window
* @param strURL		path/URL of the HTML page to open
* @param nWidth		width of the popup window
* @param nHeight		height of the popup window
* @param strScrollbars	scrollbar options
**/
function $core_openPopup(hwndPopup, strName, strURL, nWidth, nHeight, strScrollbars, nX, nY)
{
	if (!strURL)
		return;

	if (hwndPopup)
	{
		try{
			hwndPopup.focus();
		}catch(e){
			hwndPopup = null;
		}
	}

	if (!hwndPopup || hwndPopup.closed)
	{
		var nWinHeight	= document.body.clientHeight;
		var nWinWidth	= document.body.clientWidth;
		if (nWinHeight < 100)
			nWinHeight = document.documentElement.clientHeight;
		if (nWinWidth < 100)
			nWinWidth = document.documentElement.clientWidth;

		var nWinLeft = typeof(window.screenLeft) != "undefined" ? window.screenLeft : window.screenX;
		var nWinTop  = typeof(window.screenTop) != "undefined" ? window.screenTop : window.screenY;
		var nLeft	 = typeof(nX) != "undefined" ? nX : (nWinLeft + (nWinWidth/2)) - (nWidth / 2);
		var nTop	 = typeof(nY) != "undefined" ? nY : (nWinTop + (nWinHeight/2)) - (nHeight / 2);
		var options	 = 'toolbar=no,location=no,status=no,menubar=no,resizable=no,' + strScrollbars + ',width=' + nWidth + 'px,height=' + nHeight + 'px,left=' + nLeft + 'px,top=' + nTop + "px";

		hwndPopup = window.open(strURL, strName, options);
		hwndPopup.focus();
	}
	return hwndPopup;
}
	// Assign default/overridable function
$openPopup = $core_openPopup;

/**
* Determine if the specified opener is valid (exceptions might occur)
*
* @param	hOpener	handle to the opener
* @return		true if valid; false otherwise
**/
function $core_isValidOpener(hOpener)
{
	try{
		var strOpenerType = typeof(hOpener);
		if ((strOpenerType != "undefined") && (strOpenerType != "string") && (strOpenerType != null) && (hOpener != null) && (!hOpener.closed))
			return true;
	}catch(err)	{	}
	return false;
}
	// Assign default/overridable function
$isValidOpener = $core_isValidOpener;


///////////////////////////////////////////////////////////////////////////////////////////////////
// COURSE - EMAIL
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Send a properly encoded email (using MailTo)
*
* @param	strTo		the email recipient
* @param	strTo		CC email recipient
* @param	strSubject	the subject text
* @param	strBody	the body text
**/
function $core_sendEncodedMail(strTo, strCC, strSubject, strBody)
{
	var strEmail 	 = "mailto:";
	var strDelimeter = "?"

	if (strTo)
		strEmail += encodeURIComponent(strTo);
	if (strCC)
	{
		strEmail += strDelimeter + "cc=" + encodeURIComponent(strCC);
		strDelimeter = "&";
	}
	if (strSubject)
	{
		strEmail += strDelimeter + "subject=" + encodeURIComponent(strSubject);
		strDelimeter = "&";
	}
	if (strBody)
		strEmail += strDelimeter + "body=" + encodeURIComponent(strBody);

	var hwndPopup = window.open(strEmail, null, 'toolbar=no,location=no,status=no,menubar=no,resizable=no,scrollbars=off,width=5px,height=5px');
	if (hwndPopup)
		hwndPopup.close();
	
}
	// Assign default/overridable function
$sendEncodedMail = $core_sendEncodedMail;

///////////////////////////////////////////////////////////////////////////////////////////////////
// COURSE - MISC
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Search for params from the url
*
* @param	strID		the name/id of the url paramater to retrieve
* @param	strSearch	url search parameters (optional--uses top.window.location.search as default)
* @return		the parameter value
**/
function $core_getURLParam(strID, strSearch)
{
	var strValue = null;

	if (!strSearch)
	{
		try{
			strSearch = top.window.location.search;

				// If the top search location is different than the window search
				// we are in a frame set and need to combine the search strings
			if (window.location.search != top.window.location.search)
			{
				var strFrameSearch = window.location.search;

				if (strFrameSearch.charAt(0) == "?") 
					strFrameSearch = "&" + strFrameSearch.substring(1, strFrameSearch.length);

				strSearch += strFrameSearch;
			}
			
		}catch(err)
		{
			strSearch = window.location.search;
		}
	}
	strSearch += "&";

	if (strSearch.charAt(0) == "?") 
		strSearch = "&" + strSearch.substring(1, strSearch.length);

	var strSearchID = "&" + strID + "=";
	var inStart = strSearch.indexOf(strSearchID);
	var inEnd;

	if (inStart < 0)
		inStart = strSearch.toUpperCase().indexOf(strSearchID.toUpperCase());

	if (inStart != -1)
	{
		inStart += strSearchID.length;
		inEnd = strSearch.indexOf("&", inStart);
		strValue = unescape(strSearch.substring(inStart, inEnd));
	}
	return strValue;
}
	// Assign default/overridable function
$getURLParam = $core_getURLParam;



///////////////////////////////////////////////////////////////////////////////////////////////////
//
// COMMON DATA MANAGEMENT API
//
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
// DATA - INITIALIZATION
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Initialize the data tracking (Can be called by Flash)
*
* @param	strType	the data type to initialize (DATATYPE_SCORM, DATATYPE_AICC)
**/
function $core_dataIO_initialize(strType)
{
	if ($m_bDebug) alert("DEBUG: initialize data tracking: " + strType);

	$m_strDataMethod = strType;
	switch(strType)
	{
		case DATATYPE_SCORM:
			return setTimeout("$SCORM_initialize();", 50);
		case DATATYPE_AICC:
			return setTimeout("$AICC_initialize();", 50);
		case DATATYPE_DBASE:
			return setTimeout("$DBASE_initialize();", 50);
		case DATATYPE_COOKIES:
			return setTimeout("$COOKIES_initialize();", 50);
		default:
			return setTimeout("$CUSTOM_initialize();", 50);
	}
}
	// Assign default/overridable function
$dataIO_initialize = $core_dataIO_initialize;


///////////////////////////////////////////////////////////////////////////////////////////////////
// DATA - EVENT HANDLERS
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Event handler triggered when the course fails to communicate with the LMS (Can be called by Flash)
*
* @param	strError	 the error text to display
**/
function $core_dataIO_onError(strError)
{
	if ((strError) && (strError.length > 0))
		alert(strError);
}
	// Assign default/overridable function
$dataIO_onError = $core_dataIO_onError;


/**
* Event handler triggered when the course fails to initialize communication with the LMS (Can be called by Flash)
**/
function $core_dataIO_onInitError()
{
	if ($m_strDataMethod == DATATYPE_SCORM)
	{
			// If data-tracking could not initialize, then reset the appropriate vars 
		$m_strDataMethod		= DATATYPE_UNAVAILABLE;
		$m_bWarnOnExit			= false;
		$m_bConfirmSaveOnExit	= false;

		if ($m_nSCORMInitFailAction == EXIT)
		{
			$dataIO_onError(ERRORMSG_LMSINITEXIT);
			$exitCourse();
		}
		else if ($m_nSCORMInitFailAction == PROMPT)
		{
			$dataIO_onError();
			if (confirm(ERRORMSG_LMSINITPROMPT))
				$exitCourse();
		}
		else
			$dataIO_onError(ERRORMSG_LMSINIT);
	}
	else
	{
		$m_strDataMethod		= DATATYPE_UNAVAILABLE;
		$m_bWarnOnExit			= false;
		$m_bConfirmSaveOnExit	= false;
			// Report the error
		$dataIO_onError(ERRORMSG_LMSINIT);
	}
}
	// Assign default/overridable function
$dataIO_onInitError = $core_dataIO_onInitError;


/**
* Event handler triggered when the course has loaded the data (Can be called by Flash)
*
* @param	strASCallback	the ActionScript callback function to use (for indirect JS->AS communication)
**/
function $core_dataIO_onPreloadComplete(strASCallback)
{
	if ($m_bDebug) alert("DEBUG: data preloaded.");

	if ((strASCallback) && (!$m_bASCommunication))
		setTimeout("$callASFunction(\"" + strASCallback + "\");", 50);
}
	// Assign default/overridable function
$dataIO_onPreloadComplete = $core_dataIO_onPreloadComplete;


/**
* Event handler triggered when the course has loaded the data (Can be called by Flash)
**/
function $core_dataIO_onLoadComplete()					{	 if ($m_bDebug)	alert("DEBUG: data loaded.");	}
	// Assign default/overridable function
$dataIO_onLoadComplete = $core_dataIO_onLoadComplete;


/**
* Event handler triggered when the course terminates its connection with the LMS (Can be called by Flash)
**/
function $core_dataIO_onExitConnection()				{	$m_bDataIOTerminated = true;	}
	// Assign default/overridable function
$dataIO_onExitConnection = $core_dataIO_onExitConnection;


///////////////////////////////////////////////////////////////////////////////////////////////////
// DATA - FLASH VARS
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Add a name/value pair to the Flash Vars to pass into the course when it initializes
*
* @param strID		name/id of the data element
* @param vValue	data value to assign (String or Number)
**/
function $core_setCourseInitVar(strID, vValue)
{
	if ((vValue != null) && (typeof(vValue) != "undefined"))
		$m_strFlashVars += "&" + strID + "=" + vValue;
}
	// Assign default/overridable function
$setCourseInitVar = $core_setCourseInitVar;


///////////////////////////////////////////////////////////////////////////////////////////////////
// DATA - DEBUG
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Toggle the debug messages
* 
* @param	bDebug	true to enable debugging; false otherwise
**/
function $core_enableDebug(bDebug)		{	$m_bDebug = bDebug;	}
	// Assign default/overridable function
$enableDebug = $core_enableDebug;


/**
* Set a debug/testing value to pass into the course when it initializes
*
* @param strID		name/id of the data element
* @param vValue	data value to assign (String or Number)
**/
function $core_setDebugData(strID, vValue)
{
	if (!$m_objDebugData)
		$m_objDebugData = new Object();

	$m_objDebugData[strID] = vValue; 
		// Pass it in as a Flash var as well
	$setCourseInitVar(strID, vValue);
}
	// Assign default/overridable function
$setDebugData = $core_setDebugData;


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// DBASE API
//
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
// DBASE - INITIALIZATION
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Prepare to initialize communication with the IE container app
**/
function $core_DBASE_initialize() 
{
	$callASFunction("$preloadData");
} 
	// Assign default/overridable function
$DBASE_initialize = $core_DBASE_initialize;


///////////////////////////////////////////////////////////////////////////////////////////////////
// COOKIES - INITIALIZATION
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Prepare to initialize communication with the Flash Cookies
**/
function $core_COOKIES_initialize() 
{
	$callASFunction("$preloadData");
} 
	// Assign default/overridable function
$COOKIES_initialize = $core_COOKIES_initialize;


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// AICC API
//
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
// AICC - INITIALIZATION
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Prepare to initialize communication with LMS by retrieving URL params and passing them to Flash
**/
function $core_AICC_initialize() 
{
	var urlAICC	= $getURLParam("aicc_url");
	var strSID	= unescape($getURLParam("aicc_sid"));
 
		// Check for testing/debug data
	if ($m_objDebugData)
	{
		if ($m_objDebugData["aicc_url"])
			urlAICC	= $m_objDebugData["aicc_url"];
		if ($m_objDebugData["aicc_url"])
			strSID	= $m_objDebugData["aicc_sid"];
	}

		// Pass in the vars
	$callASFunction("$setDataValue", "aicc_url", urlAICC);
	$callASFunction("$setDataValue", "aicc_sid", strSID);
	$callASFunction("$preloadData");

	$m_bWarnOnExit = true;
} 
	// Assign default/overridable function
$AICC_initialize = $core_AICC_initialize;


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// SCORM API
//
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
// SCORM - INITIALIZATION
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Initialize communication with LMS
**/
function $core_SCORM_initialize() 
{ 
	if ($m_bDebug) alert("DEBUG: initializing SCORM LMS connection");

	$SCORM_getAPIHandle(); 
	$m_bWarnOnExit = false;		// SCORM saves in onBeforeUnload, so an exit confirmation is not permitted

	try{
		if ($m_apiSCORM)
		{
				// Call the LMSInitialize function that should be implemented by the API
			var nResult = $m_apiSCORM.LMSInitialize("");

				// If LMSInitialize did not complete successfully.
			if ((nResult.toString() != "1") && (nResult.toString() != "true"))
			{
				if ($m_bDebug) alert("DEBUG: SCORM LMS initialization failed.");
					// If an error was encountered, then invalidate the handle
				var nError = $SCORM_errorHandler("LMSInitialize()");
				if (nError != ERROR_NONE)
				{
					$m_apiSCORM = null;
					if ($m_bSCORMExitOnInitFail)
						$exitCourse();
				}
			}
			else if ($m_bDebug) alert("DEBUG: SCORM LMS initialization succeeded.");

				// Start the session time
			$SCORM_startSessionTime();
		}

		if ($m_apiSCORM)
			$callASFunction("$preloadData");
		else
			$callASFunction("$onDataError");
	}
	catch(err){
		if ($m_bDebug) alert("DEBUG: SCORM initialization failed (exception thrown)!");
		$callASFunction("$onDataError");
	}
} 
	// Assign default/overridable function
$SCORM_initialize = $core_SCORM_initialize;


///////////////////////////////////////////////////////////////////////////////////////////////////
// SCORM - TERMINATE LMS COMMUNICATION
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Close communication with LMS (Can be called by Flash)
**/
function $core_SCORM_finish()
{
	$SCORM_getAPIHandle();

	if ($m_apiSCORM) 
	{
		$m_apiSCORM.LMSFinish("");
		if ($m_bDebug) alert("DEBUG: terminating LMS connection.");
	}

	$dataIO_onExitConnection();
} 
	// Assign default/overridable function
$SCORM_finish = $core_SCORM_finish;


/**
* Exit the SumTotal LMS
**/
function $core_SCORM_exitSumTotalLMS()
{
	if (($m_bSumTotalLMS) && ($m_apiSumTotal))
	{
		if ($m_bDebug) alert("DEBUG: exiting SumTotal LMS connection.");

		try{
			$m_apiSumTotal.SetNavCommand("exit");
		}catch(err){	}
		$m_apiSumTotal = null;
	}
}
	// Assign default/overridable function
$SCORM_exitSumTotalLMS = $core_SCORM_exitSumTotalLMS;


///////////////////////////////////////////////////////////////////////////////////////////////////
// SCORM - SESSION TIME (HANDLED HERE INSTEAD OF WITHIN FLASH)
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Start the session timer
**/
function $core_SCORM_startSessionTime()			{	$m_nStartTime = new Date().getTime();	}
	// Assign default/overridable function
$SCORM_startSessionTime = $core_SCORM_startSessionTime;


/**
* Get the elapsed session time
**/
function $core_SCORM_getSessionTime()
{
	if ($m_nStartTime == null)
		return null;

		// Calculate the Time Spent in the Course
	var nEndTime	 = new Date().getTime();
	var nSessionTime = nEndTime - $m_nStartTime;
	var nHours		 = Math.min(Math.floor(nSessionTime / 1000 / 60 / 60), 99);
	var nMinutes	 = Math.floor(nSessionTime / 1000 /60 - (60 * nHours));
	var nSeconds	 = Math.round(nSessionTime / 1000 - (60 * 60 * nHours) - (60 * nMinutes));
		// Ensure compliance
	if (nSeconds >= 60)
	{
		nSeconds = 0;
		nMinutes++;
	}
	if (nMinutes >= 60)
	{
		nMinutes = 0;
		nHours++;
	}
	if (nHours > 99)
		nHours = 99;

	return ((nHours < 10) ? "0" : "") + nHours + ":" + ((nMinutes < 10) ? "0" : "") + nMinutes + ":" + ((nSeconds < 10) ? "0" : "") + nSeconds;
}
	// Assign default/overridable function
$SCORM_getSessionTime = $core_SCORM_getSessionTime;


///////////////////////////////////////////////////////////////////////////////////////////////////
// SCORM - LMS I/O
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Get the value of a data element from the LMS (Can be called by Flash)
*
* @param	strASCallback	the ActionScript callback function to use (for indirect JS->AS communication)
* @param	strID			 the cmi data model defined category or element (e.g. cmi.core.student_id)
* @return			 the value presently assigned by the LMS to the cmi data model or element
**/
function $core_SCORM_getValue(strASCallback, strID)
{
	var vValue	= null;
	var vReturn	= null;

	$SCORM_getAPIHandle();			// Re-aquire the API handle, in case the opener was closed
	if ($m_apiSCORM)
		vValue = $m_apiSCORM.LMSGetValue(strID);

		// Check for errors
	nError = $SCORM_errorHandler("LMSGetValue(" + strID + ")");

		// If an error was encountered, then return null, 
	if ((nError != ERROR_NONE) || (vValue == null) || (typeof(vValue) == "null") || (vValue == ""))
		vReturn = null;
	else
		vReturn = vValue.toString();

	if ($m_bDebug) alert("DEBUG: $core_SCORM_getValue(" + strID + ") = " + vReturn);

		// If no direct AS communication, must send the value back to flash
	if (!$m_bASCommunication)
		$callASFunction(strASCallback, vReturn, strID);

	if ((vReturn == null) || (typeof(vReturn) == "undefined"))
		return null;
	else
		return String(vReturn);
}
	// Assign default/overridable function
$SCORM_getValue = $core_SCORM_getValue;


/**
* Set the value of a data element (Can be called by Flash)
*
* @param	strID		 the cmi data model defined category or element (e.g. cmi.core.student_id)
* @param	vValue	 the new value to assign (String or Number)
**/
function $core_SCORM_setValue(strID, vValue)
{
		// Use JavaScript value if "session time"
	if (strID == "cmi.core.session_time")
		vValue = $SCORM_getSessionTime();
		
		// Allocate space if a new value
	if (!$m_objData)
		$m_objData = new Object();
	if (!$m_objData[strID])
	{
		$m_objData[strID] = new Object();
		$m_objData[strID].m_vValue	= null;
		$m_objData[strID].m_bCommit	= false;
	}

		// Capture the value (if new) and flag it for the next commit routine
	if ($m_objData[strID].m_vValue != vValue)
	{
		$m_objData[strID].m_vValue	= vValue;
		$m_objData[strID].m_bCommit	= true;
	}

	if ($m_bDebug) alert("DEBUG: $core_SCORM_setValue(" + strID + ", " + vValue + ")");	
}
	// Assign default/overridable function
$SCORM_setValue = $core_SCORM_setValue;


/**
* Set the value of a data element (Should not be called by Flash)
*
* @param	strID		the cmi data model defined category or element (e.g. cmi.core.student_id)
* @param	vValue	the value to set (String or Number)
* @return		true if the value was set; false otherwise
**/
function $core_SCORM_setLMSValue(strID, vValue)
{
	if ($m_apiSCORM)
	{
		if ($m_bDebug) alert("DEBUG: $core_SCORM_setLMSValue(" + strID + ", " + vValue + ")");

		$m_apiSCORM.LMSSetValue(strID, vValue);

			// Check for errors (if no errors, then clear commit flag)
		var nError = $SCORM_errorHandler("LMSSetValue(" + strID + ", " + vValue + ")", true);
		if (nError == ERROR_NONE)
			return true;
	}
	return false;
}
	// Assign default/overridable function
$SCORM_setLMSValue = $core_SCORM_setLMSValue;


/**
* Commit data to the LMS (Can be called by Flash)
*
* @param	bSkipResponse	true if the commit should execute without waiting for a response (useful for avoiding Flash script timeout problems); false otherwise
**/
function $core_SCORM_commitData(bSkipResponse)
{
		// If the function should terminate immediately and call commit in a separate process...
	if (bSkipResponse)
		return setTimeout("$SCORM_commitData();", 100);

	$SCORM_getAPIHandle();			// Re-aquire the API handle, in case the opener was closed
	if ($m_apiSCORM)
	{
			// Ensure all values are sent to the LMS
		for (var strID in $m_objData)
		{	
			if ($m_objData[strID].m_bCommit)
			{
				if ($SCORM_setLMSValue(strID, $m_objData[strID].m_vValue))
					$m_objData[strID].m_bCommit = false;
			}
		}
			// Commit
		$m_apiSCORM.LMSCommit("");
		if ($m_bDebug) alert("DEBUG: committing LMS data.");
	}
		// Check for errors
	var nError = $SCORM_errorHandler("LMSCommit()", true);
	if (nError == ERROR_NONE)
		$m_bSCORMSaved = true;
	else
		$m_bSCORMSaved = false;
	if ((!$m_apiSCORM) && ($m_nSCORMLostAPIAction == EXIT))
	{
		$m_nSCORMLostAPIAction = IGNORE;		// Prevents duplicate errors
		$exitCourse();
	}
} 
	// Assign default/overridable function
$SCORM_commitData = $core_SCORM_commitData;


///////////////////////////////////////////////////////////////////////////////////////////////////
// SCORM - ERROR HANDLERS
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Get the last error from the LMS
*
* @return	the error code (integer format) that was set by the last LMS function call
**/
function $core_SCORM_getLastError() 
{
	if ($m_apiSCORM)
		return $m_apiSCORM.LMSGetLastError();
	else
		return ERROR_GENERALEXCEPTION;
} 
	// Assign default/overridable function
$SCORM_getLastError = $core_SCORM_getLastError;


/**
** Get the last error string
*
* @param	nErrorCode	error Code (integer format)
* @return		the textual description that corresponds to the input error code 
**/
function $core_SCORM_getErrorString(nErrorCode) 
{
	if ($m_apiSCORM)
		return $m_apiSCORM.LMSGetErrorString(nErrorCode).toString();
	else
		return "";
} 
	// Assign default/overridable function
$SCORM_getErrorString = $core_SCORM_getErrorString;


/**
** Get diagnostic information from the LMS
*
* @param	nErrorCode		error Code (integer format), or null
* @return			the vendor specific textual description that corresponds to the error code 
**/
function $core_SCORM_getDiagnostic(nErrorCode) 
{
	if ($m_apiSCORM)
		return $m_apiSCORM.LMSGetDiagnostic(nErrorCode).toString();
	else
		return "";
} 
	// Assign default/overridable function
$SCORM_getDiagnostic = $core_SCORM_getDiagnostic;


/**
* Determine if an error was encountered by the previous API call and if so, display a 
* message to the user.  If the error code has associated text, it is displayed.
*
* @param	strLMSFunction	the calling function which triggered the error
* @param	bSaveInProgress	true if data is attempting to save; false if another type of LMS communication
* @return			the current value of the LMS Error Code
**/
function $core_SCORM_errorHandler(strLMSFunction, bSaveInProgress) 
{
	var strError = "";

	if ($m_apiSCORM)
	{
			// Check for errors caused by or from the LMS
		var nError = $SCORM_getLastError();

			// If an error was encountered, display the error description
		if (nError != ERROR_NONE)
		{
			strError  = $m_apiSCORM.LMSGetErrorString(nError);
			strError += "\n";
			strError += strLMSFunction + " was not successful.\n";

			if ($m_bDebug) strError += $SCORM_getDiagnostic(null);		// by passing null to LMSGetDiagnostic, we get any available diagnostics on the previous error.

			$dataIO_onError(strError);
		}
		return nError;
	}
	else 
	{
			// Only report individual errors if the API was acquired at one point)
		if ($m_bSCORMFound)
		{
			if ($m_bDataIOTerminated)
				strError = ERRORMSG_LMSEXITED;
			else if (bSaveInProgress)
			{
				if ($m_nSCORMLostAPIAction == EXIT)
					strError = ERRORMSG_LMSSAVEEXIT;
				else if ($m_nSCORMLostAPIAction == ALERT)
					strError = ERRORMSG_LMSSAVE;
				else
					strError = "";
			}
			else
				strError = ERRORMSG_LMSCOMM;

			strError = strError.replace("%LMSFUNCTION%", strLMSFunction);
			$dataIO_onError(strError);
		}
		return ERROR_GENERALEXCEPTION;
	}
}
	// Assign default/overridable function
$SCORM_errorHandler = $core_SCORM_errorHandler;


///////////////////////////////////////////////////////////////////////////////////////////////////
// SCORM - LMS API SEARCH
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Get the handle to the API object
*
* @return	the api handle
**/
function $core_SCORM_getAPIHandle() 
{
	$m_apiSCORM = $SCORM_getAPI();
	if ($m_apiSCORM)
		$m_bSCORMFound = true;
		
		// Check for SumTotal Extended API
	if (($m_apiSCORM) && ($m_bSumTotalLMS))
	{
		$m_apiSumTotal = $SCORM_getSumTotalAPI();
		if (!$m_apiSumTotal)
			$m_bSumTotalLMS = false;
	}
	else
		$m_bSumTotalLMS = false;
		
		// Report an error if invalid
	if (($m_apiSCORM == null) && ($m_bDebug))
		alert("DEBUG: Unable to locate the LMS's SCORM API Implementation.");

	return $m_apiSCORM;
}
	// Assign default/overridable function
$SCORM_getAPIHandle = $core_SCORM_getAPIHandle;


/**
* Find an object named API in the supported window hierarchy
*
* @param	hWindow	a handle to a window
* @param	strAPI	the type of API to find
* @return		a handle to the API object (if found)
**/
function $core_SCORM_findAPI(hWindow, strAPI) 
{
	if (strAPI == null)
		strAPI = "API";

	try{
		if (eval("hWindow." + strAPI) != null)
		{
			if ($m_bDebug) alert("DEBUG: found " + strAPI + " in " + hWindow.location.href);
			return eval("hWindow." + strAPI);
		}

		if (hWindow.length > 0)		// does the window have frames?
		{
			for (var i = 0; i < hWindow.length; i++)
			{
				var objAPI = $SCORM_findAPI(hWindow.frames[i], strAPI);
				if (objAPI != null)
					return objAPI;
			}
		}
	}catch(err)	{ }

	return null;
}
	// Assign default/overridable function
$SCORM_findAPI = $core_SCORM_findAPI;


/**
* Look for an object named API, first in the current window's hierarchy, then, if necessary, in 
* the opener window hierarchy (up to 3 levels)
*
* @param	strAPI	the type of API to find
* @return		a handle to the API object (if found)
**/
function $core_SCORM_getAPI(strAPI)
{
	var objAPI = null;			// Handle to the API object
	var wndAPI = null;			// Handle to the window that contains the API object

	if (strAPI == null)
		strAPI = "API";

	wndAPI = this.top;
	try{
		objAPI = $SCORM_findAPI(wndAPI, strAPI);
		
			// If no match, keep checking
		if (objAPI == null)
		{
				// Check the window's opener
			if ($isValidOpener(this.top.opener))
			{
				wndAPI = this.top.opener.top;
				objAPI = $SCORM_findAPI(wndAPI, strAPI);

					// If it failed, check the 2nd level opener
				if ((objAPI == null) && ($isValidOpener(this.top.opener.opener)))
				{
					wndAPI = this.top.opener.opener.top;
					objAPI = $SCORM_findAPI(wndAPI, strAPI);

						// If it failed, check the 3rd level opener opener
					if ((objAPI == null) && ($isValidOpener(this.top.opener.opener.opener)))
					{
						wndAPI = this.top.opener.opener.opener.top;
						objAPI = $SCORM_findAPI(wndAPI, strAPI);
					}
				}
			}
			else if ($m_bDebug) alert("DEBUG: This window does not have an opener.");
		}
	}catch(err)	{	}

	if (strAPI == "API")
	{
		if (!objAPI)
			$m_wndSCORM = null;
		else
			$m_wndSCORM = wndAPI;
	}

	return objAPI;
}
	// Assign default/overridable function
$SCORM_getAPI = $core_SCORM_getAPI;


/**
* Look for the SumTotal "Extended API" object.
*
* @return	a handle to the API object (if found)
**/
function $core_SCORM_getSumTotalAPI()
{
	var objAPI = $SCORM_findAPI($m_wndSCORM, "API_Extended");

	if (($m_bDebug) && ($m_wndSCORM) && (!objAPI))
		alert("DEBUG: couldn't find API_Extended in " + $m_wndSCORM.location.href);
	return objAPI;
}
	// Assign default/overridable function
$SCORM_getSumTotalAPI = $core_SCORM_getSumTotalAPI;


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// CUSTOM DATATRACKING API
//
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
// CUSTOM DATA - INITIALIZATION
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Prepare to initialize communication with LMS by retrieving URL params and passing them to Flash
**/
function $core_CUSTOM_initialize() 
{
	$callASFunction("$preloadData");
} 
	// Assign default/overridable function
$CUSTOM_initialize = $core_CUSTOM_initialize;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// FLASH MANAGEMENT API
//
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
// FLASH - INITIALIZATION
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Cotnext menu override
**/
function $core_onContextMenu()
{
	if (window.event.srcElement.id == $m_strFlashID) 
		return false; 
}
	// Assign default/overridable function
$onContextMenu = $core_onContextMenu;

/**
* Event handler for mouse-down events on the flash container div
*
* @param	divTarget	the div handle
**/
function $core_onFlashDivMouseDown(divTarget)
{
	if ((event.button == EVENT_RIGHTCLICK) && (window.event.srcElement.id == $m_strFlashID))
	{
			// Forward the click
		try{
			if ($m_objFlash.$onRightClick)
				$m_objFlash.$onRightClick();
		}catch(err){}
		divTarget.setCapture();
	}
}
	// Assign default/overridable function
$onFlashDivMouseDown = $core_onFlashDivMouseDown;

/**
* Event handler for mouse-up events on the flash container div
*
* @param	divTarget	the div handle
**/
function $core_onFlashDivMouseUp(divTarget)
{
	if ((event.button == EVENT_RIGHTCLICK) && (window.event.srcElement.id == $m_strFlashID))
		divTarget.releaseCapture();
}
	// Assign default/overridable function
$onFlashDivMouseUp = $core_onFlashDivMouseUp;

/**
* Event handler for other browsers (e.g., gecko) mouse events
**/
function $core_onAltBrowserMouseDown(objEvent)
{
	if ((objEvent.button == EVENT_RIGHTCLICK) && (objEvent.target.id == $m_strFlashID || objEvent.target.name == $m_strFlashID))
	{
			// Kill the event
		if (objEvent.stopPropagation)	objEvent.stopPropagation();
		if (objEvent.preventDefault)	objEvent.preventDefault();
		if (objEvent.preventCapture)	objEvent.preventCapture();
		if (objEvent.preventBubble)		objEvent.preventBubble();

			// Forward the click
		try{
			if ($m_objFlash.$onRightClick)
				$m_objFlash.$onRightClick();
		}catch(err){}
	}
}
	// Assign default/overridable function
$onAltBrowserMouseDown = $core_onAltBrowserMouseDown;

/**
* Load the flash object with the user-specified settings
**/
function $core_loadShell()
{
		// If Flash source not specified, go with defaults
	if (!$m_strFlashSrc)
	{
		if ($m_nFlashVer == 7)
			$m_strFlashSrc = "flash_7/shell.swf";
		else
			$m_strFlashSrc = "flash/shell.swf";
	}
		// Check for the SCORM testing suite
	if (document.location.href.indexOf("file:") >= 0)
	{
		var strPath = document.location.href.toLowerCase();
		if (strPath.indexOf("//allensharebdc/shares/courseware") > 0)
		{
			alert("Please launch the course from a mapped drive.");
			top.window.close();
			return false;
		}
		var bSCORMTestingSuite = false;
		try{
			if (top.location.href.indexOf("TestSuite") > 0)
				bSCORMTestingSuite = true;
			else if ((window.opener) && (window.opener.top.location.href.indexOf("TestSuite") > 0))
				bSCORMTestingSuite = true;
		}catch(err){	}

		if (bSCORMTestingSuite)
			$m_strFlashVars += "&_SCORM_TESTING_SUITE_=true";
	}
	if ($m_bNoAllenCommData)
	{
		$m_bWarnOnExit 		  = false;
		$m_bConfirmSaveOnExit = false;

		var nURLIndex	 = document.location.href.indexOf(".allencomm.com");
		var nParamsIndex = document.location.href.indexOf("?");
		if ((nURLIndex > 0) && (nParamsIndex < 0 || nURLIndex < nParamsIndex))
			$m_strDataTrackingMode = DATATYPE_NONE;
	}
		// Look for mamba preview flag
	if ($getURLParam("_MAMBA_BM_GUID_"))
		$m_strFlashVars += "&$ext_strBookmark=" + $getURLParam("_MAMBA_BM_GUID_");
	
	if ($m_strDataTrackingMode)
		$setCourseInitVar("$ext_strDataTrackingMode", $m_strDataTrackingMode);

		// Add browser/EXE flags
	if ($m_bInCourseEXE)
		$m_strFlashVars += "&_IE_CONTAINER_=true";
	if ($m_3rdPartyEmbedded)
		$m_strFlashVars += "&_3RDPARTY_EMBEDDED_=true";
	$m_strFlashVars += "&_BROWSER_LOADED_=true";
	
		// Note: Individual FlashVar settings should be "escaped" to prevent invalid characters
	var objFlashContainer = this;
	if ($m_bBlockRightclicks)
	{
		$m_divFlash = $generateRightClickContainer(this, $m_strFlashID + "Container");
		objFlashContainer = $m_divFlash;
	}
	$m_objFlash = $generateFlashObj(objFlashContainer, $m_strFlashID, 'src', $m_strFlashSrc, 'movie', $m_strFlashSrc, 'base', '.', 'scale', $m_strFlashScale, 'wmode', $m_strFlashWMode, 'bgcolor', $m_strFlashBgColor, 'width', $getFlashWidth(), 'height', $getFlashHeight(), 'FlashVars', $m_strFlashVars, 'SWLIVECONNECT', true, 'allowScriptAccess', 'always', 'allowFullScreen', 'true', 'quality','high', 'codebase', $m_strProtocol + '//download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=' + $m_nFlashVer + ',0,0,0', 'pluginspage', $m_strProtocol + '//www.macromedia.com/go/getflashplayer');
}
	// Assign default/overridable function
$loadShell = $core_loadShell;

/**
* Get the specified flash width while taking the current DIP into account
*
* @return  the specified flash width
**/
function $core_getFlashWidth()
{
	if (typeof($m_nFlashWidth) == "number" && screen.deviceXDPI != null && screen.deviceXDPI != screen.logicalXDPI)
		return $m_nFlashWidth * screen.logicalXDPI / screen.deviceXDPI;
	else
		return $m_nFlashWidth;
}
	// Assign default/overridable function
$getFlashWidth = $core_getFlashWidth;

/**
* Get the specified flash height while taking the current DIP into account
*
* @return  the specified flash height
**/
function $core_getFlashHeight()
{
	if (typeof($m_nFlashHeight) == "number" && screen.deviceXDPI != null && screen.deviceXDPI != screen.logicalXDPI)
		return $m_nFlashHeight * screen.logicalXDPI / screen.deviceXDPI;
	else
		return $m_nFlashHeight;
}
	// Assign default/overridable function
$getFlashHeight = $core_getFlashHeight;

/**
* Generate the HTML code for the Flash object using the specified settings
*
* @param	objOwner	handle to the element that will own the div container
* @param	strID		id of the layer
**/
function $core_generateRightClickContainer(objOwner, strID)	
{
	var strHTML = "<DIV id='" + strID + "'";

	if (!window.addEventListener)
		strHTML += " onmousedown='$onFlashDivMouseDown(this)' onmouseup='$onFlashDivMouseUp(this)'>";
	strHTML += "</DIV>";
	objOwner.document.write(strHTML);

		// Install right-click hooks
	if (objOwner.document[strID])
		return objOwner.document[strID];
	else
		return objOwner.document.getElementById(strID);
}
	// Assign default/overridable function
$generateRightClickContainer = $core_generateRightClickContainer;

/**
* Generate the HTML code for the Flash object using the specified settings
*
* @param	objContainer	handle to the container that will own the Flash object
* @param	strFlashID		the ID of the flash object to create
* @param	arguments		(multiple arguments containing the Flash settings)
**/
function $core_generateFlashObj(objContainer, strFlashID)
{
	var objFlashArgs = $formatFlashArgs(arguments, "movie", "clsid:d27cdb6e-ae6d-11cf-96b8-444553540000", "application/x-shockwave-flash");
	var strHTML = "<OBJECT id='" + strFlashID + "' ";

	for (var inAttr in objFlashArgs.objAttrs)
		strHTML += inAttr + "='" + objFlashArgs.objAttrs[inAttr] + "' ";
	strHTML += ">";
	for (var inParam in objFlashArgs.params)
		strHTML += "<PARAM name='" + inParam + "' value='" + objFlashArgs.params[inParam] + "'/>";
	strHTML += "<EMBED name='" + strFlashID + "' ";
	for (var inAttr in objFlashArgs.embedAttrs)
		strHTML += inAttr + "='" + objFlashArgs.embedAttrs[inAttr] + "' ";
	strHTML += " ></EMBED></OBJECT>";
	//prompt("blah", strHTML);
	if (objContainer.id)
	{
		objContainer.innerHTML = strHTML;
		var arrEmbed  = objContainer.getElementsByTagName("embed");
		var arrObject = objContainer.getElementsByTagName("object");

		if ((arrEmbed) && (arrEmbed.length > 0))
			return arrEmbed[0];
		else if ((arrObject) && (arrObject.length > 0))
			return arrObject[0];
		else 
			return document.getElementById(strFlashID);
	}
	else
	{
		objContainer.document.write(strHTML);
		if (objContainer.document[strFlashID])
			return objContainer.document[strFlashID];
		else
			return objContainer.document.getElementById(strFlashID);
	}
}
	// Assign default/overridable function
$generateFlashObj = $core_generateFlashObj;


/**
* Get the appropriately formatted flash arguments
*
* @param	arrArgs		the customized flash arguments
* @param	srcParamName	the source param name (src or movie)
* @param	strClassID		the object class ID
* @param	strMimeType	the mime type
* @return			the formatted args structure
**/
function $core_formatFlashArgs(arrArgs, srcParamName, strClassID, strMimeType)
{
	var objReturn = new Object();
	objReturn.embedAttrs = new Object();
	objReturn.params	 = new Object();
	objReturn.objAttrs	 = new Object();
	for (var inArg = 2; inArg < arrArgs.length; inArg = inArg + 2)
	{
		var strCurArg = arrArgs[inArg].toLowerCase(); 

		switch (strCurArg)
		{
			case "classid":
				break;
			case "pluginspage":
				objReturn.embedAttrs[arrArgs[inArg]] = arrArgs[inArg + 1];
				break;
			case "src":
			case "movie":
				objReturn.embedAttrs["src"] = arrArgs[inArg + 1];
				objReturn.params[srcParamName] = arrArgs[inArg + 1];
				break;
			case "onafterupdate":
			case "onbeforeupdate":
			case "onblur":
			case "oncellchange":
			case "onclick":
			case "ondblClick":
			case "ondrag":
			case "ondragend":
			case "ondragenter":
			case "ondragleave":
			case "ondragover":
			case "ondrop":
			case "onfinish":
			case "onfocus":
			case "onhelp":
			case "onmousedown":
			case "onmouseup":
			case "onmouseover":
			case "onmousemove":
			case "onmouseout":
			case "onkeypress":
			case "onkeydown":
			case "onkeyup":
			case "onload":
			case "onlosecapture":
			case "onpropertychange":
			case "onreadystatechange":
			case "onrowsdelete":
			case "onrowenter":
			case "onrowexit":
			case "onrowsinserted":
			case "onstart":
			case "onscroll":
			case "onbeforeeditfocus":
			case "onactivate":
			case "onbeforedeactivate":
			case "ondeactivate":
			case "type":
			case "codebase":
				objReturn.objAttrs[arrArgs[inArg]] = arrArgs[inArg + 1];
				break;
			case "width":
			case "height":
			case "align":
			case "vspace": 
			case "hspace":
			case "class":
			case "title":
			case "accesskey":
			case "name":
			case "id":
			case "tabindex":
				objReturn.embedAttrs[arrArgs[inArg]] = objReturn.objAttrs[arrArgs[inArg]] = arrArgs[inArg + 1];
				break;
			default:
				objReturn.embedAttrs[arrArgs[inArg]] = objReturn.params[arrArgs[inArg]] = arrArgs[inArg + 1];
		}
	}

	objReturn.objAttrs["classid"] = strClassID;
	if (strMimeType) 
		objReturn.embedAttrs["type"] = strMimeType;
	return objReturn;
}
	// Assign default/overridable function
$formatFlashArgs = $core_formatFlashArgs;


///////////////////////////////////////////////////////////////////////////////////////////////////
// FLASH - JAVASCRIPT/ACTIONSCRIPT COMMUNICATION
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Event handler triggered when Flash attempts to establish direct communication with JavaScript (via the ExternalInterface API)
*
* @return	true 
**/
function $core_validateAStoJSComm()
{
	try{
		$m_bASCommunication = $m_objFlash.$validateJStoASComm();
	}
	catch(err)
	{
		$m_bASCommunication = false;
	}

	if ($m_bDebug)
	{
		if ($m_bASCommunication)
			alert("DEBUG: validating Flash ExternalInterface.\nDirect JavaScript->ActionScript communication will be permitted.");
		else
			alert("DEBUG: Flash ExternalInterface could not validate!\nIndirect JavaScript->Actionscript communication will be used.");
	}
	return true;
}
	// Assign default/overridable function
$validateAStoJSComm = $core_validateAStoJSComm;


/**
* Event handler triggered when Flash attempts to call a JavaScript function
*
* @param strCommand	Command/JavaScript function to call
* @param strArgs	Arguments (as a dilimeted string)
**/
function objFlash_DoFSCommand(strCommand, strArgs)			{	$doFSCommand(strCommand, strArgs);	}


/**
* Handle FSCommand events from flash
*
* @param strCommand	Command/JavaScript function to call
* @param strArgs	Arguments (as a dilimeted string)
**/
function $core_doFSCommand(strCommand, strArgs)
{ 
	if (eval("typeof(" + strCommand + ")") != "undefined")
	{
		if ($m_bDebug) alert("DEBUG: attempting Flash->JavaScript doFSCommand:\r\n\r\n" + strCommand + "(" + strArgs + ")");

		var strCode = strCommand + "(";
		if (strArgs)
		{
			var arrArgs = strArgs.split("#,#");
			for (var inArg = 0; inArg < arrArgs.length; inArg++)
			{
				strCode += "\"" + arrArgs[inArg] + "\"";
				if (inArg < arrArgs.length - 1)
					strCode += ", ";
			}
		}
		strCode += ");";
		try{
			eval(strCode);
		}
		catch(err)
		{
			if ($m_bDebug) alert("DEBUG: Flash->JavaScript doFSCommand failed!");
		}
	}
}
	// Assign default/overridable function
$doFSCommand = $core_doFSCommand;

/**
* Call a Flash ActionScript function
*
* @param strFunction	the function to call (parameters are optional)
**/
function $core_callASFunction(strFunction)
{ 
	var strCode;

		// If Direct JS->AS communication...
	if ($m_bASCommunication)
	{
		strCode = "$m_objFlash." + strFunction + "(";
		for (var inArg = 1; inArg < arguments.length; inArg++)
		{
			if (typeof(arguments[inArg]) == "string")
				strCode += "\"" + arguments[inArg] + "\"";
			else
				strCode += arguments[inArg];
			if (inArg < arguments.length - 1)
				strCode += ",";
		}
		strCode += ");";

		if ($m_bDebug) alert("DEBUG: attempting JavaScript->Flash communication:\n\n" + strCode + "\n\n$m_objFlash = " + $m_objFlash);
		try{
			eval(strCode);
			return;
		}
		catch(err)
		{
			if ($m_bDebug)	alert("DEBUG: JavaScript->Flash communication failed!");
		}
	}
		// If Indirect JS->AS communication, or if Direct communication attempt failed...
	strCode = strFunction + "(";
	for (var inArg = 1; inArg < arguments.length; inArg++)
	{
		strCode += arguments[inArg];
		if (inArg < arguments.length - 1)
			strCode += ",";
	}
	strCode += ");";

		if ($m_bDebug) alert("DEBUG: attempting JavaScript->Flash communication:\n\n$m_objFlash.SetVariable(\"$event_onCallASFunction\", \"" + strCode + "\");\n\n$m_objFlash = " + $m_objFlash);
	try{
		$m_objFlash.SetVariable("$event_onCallASFunction", strCode);
	}
	catch(err)
	{ 
		if ($m_bDebug) alert("DEBUG: JavaScript->Flash communication failed!");
	}
}
	// Assign default/overridable function
$callASFunction = $core_callASFunction;

///////////////////////////////////////////////////////////////////////////////////////////////////
// FLASH - MISC 
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Dev function (not used outside of dev IDE)
**/
function LockFlashSize()	{	}