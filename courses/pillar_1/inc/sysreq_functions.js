///////////////////////////////////////////////////////////////////////////////////////////////////
// System Requirement Validation functions
// 
// @author   Allen Communication Learning Services
// @version  3.2
// 
// DO NOT MODIFY THIS DOCUMENT
///////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////
// CONSTANTS
///////////////////////////////////////////////////////////////////////////////////////////////////

var BROWSER	  = 0;						// ID of the System Requirements browser object 
var FLASH	  = 1;						// ID of the System Requirements Flash Player object
var ACROBAT	  = 2;						// ID of the System Requirements Acrobat Reader object 
var SCREENRES = 3;						// ID of the System Requirements Screen Res object 
var POPUPS 	  = 4;						// ID of the System Requirements Popups object

var OPERA	  = 0;						// ID of the Opera (browser) object
var NETSCAPE  = 1;						// ID of the Netscape (browser) object
var FIREFOX	  = 2;						// ID of the Firefox (browser) object
var IE		  = 3;						// ID of the Internet Explorer (browser) object 
var CHROME	  = 4;						// ID of the Chrome (browser) object 
var SAFARI	  = 5;						// ID of the Safari (browser) object 

var NO_LIMIT  = null;					// Indicates any version/value in sys reqs check

										// Messages
var MSG_VALID					= "This computer meets the minimum requirements.";
var ERRORMSG_INVALID			= "This computer does <B>NOT</B> meet the minimum requirements!";
var ERRORMSG_BROWSER_INVALID	= "<LI><I>The current browser is not supported.</I></LI>";
var ERRORMSG_FLASH_INVALID		= "<LI><I><A href='http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash&ogn=EN_US-gntray_dl_getflashplayer'>Adobe Flash Player</A> needs to be installed/updated.</I></LI>";
var ERRORMSG_ACROBAT_INVALID	= "<LI><I><A href='http://get.adobe.com/reader'>Adobe Acrobat Reader</A> needs to be installed/updated.</I></LI>";
var ERRORMSG_SCREENRES_INVALID	= "<LI><I>Your screen resolution is too low.</I></LI>";
var ERRORMSG_POPUPS_INVALID		= "<LI><I><b>Enable popups</b> for this site.</I></LI>";
var ERRORMSG_ERROR_HELP			= "Please contact your IT department for support.";

var HEADING_SYSREQ				= "System Requirements";
var HEADING_APPLICATION			= "Application/Setting";
var HEADING_CURRENTVER			= "Current";
var HEADING_REQUIREDVER			= "Required";
var HEADING_STATUS				= "Status";
var HEADING_FLASH				= "Flash Player";
var HEADING_ACROBAT				= "Adobe Acrobat";
var HEADING_SCREENRES			= "Screen Resolution";

var STATUS_ENABLED				= "Enabled";
var STATUS_NOTENABLED			= "Not enabled";
var STATUS_REQUIRED				= "Required";
var STATUS_NOTREQUIRED			= "Not required";
var STATUS_NOTINSTALLED			= "Not installed";


///////////////////////////////////////////////////////////////////////////////////////////////////
// CORE VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////////////

var $m_bValid_SysReqs			= false;					// Is everything valid?
var $m_bSysReqsChecked			= false;					// Have the system requirements been checked?
var $m_strProtocol 				= top.window.document.location.protocol == "https:" ? "https:" : "http:";	// Protocol to use for communcation

		/* Client System Specs */
var $m_arrClientSys				= new Array();
	$m_arrClientSys[BROWSER]	= {m_nID:null, m_strName:"Unknown Browser", m_nVer:null, m_strVer:"N/A", m_strReqVer:null, m_bValid:false, m_bSupported:false};
	$m_arrClientSys[FLASH]		= {m_strVer:"N/A", m_nVer:null, m_bValid:false};
	$m_arrClientSys[ACROBAT]	= {m_strVer:"N/A", m_nVer:null, m_bValid:false};
	$m_arrClientSys[SCREENRES]	= {m_nWidth:0, m_nHeight:0, m_bValid:false};
	$m_arrClientSys[POPUPS]		= {m_bEnabled:false, m_bValid:false};


///////////////////////////////////////////////////////////////////////////////////////////////////
// CUSTOMIZABLE VARIABLES/CONSTANTS
///////////////////////////////////////////////////////////////////////////////////////////////////

var $m_bValidateSysReqs				 = true;			// Validate system requirements?

	/* System Requirements */
var $m_arrSysReqs					 = new Array();
	$m_arrSysReqs[BROWSER]			 = new Array();
	$m_arrSysReqs[BROWSER][IE]		 = {m_strName:"Internet Explorer",	m_bSupported:true,  m_nMinVer:6, m_nMaxVer:NO_LIMIT, m_strVerRange:null, m_strKey:"msie"};
	$m_arrSysReqs[BROWSER][FIREFOX]	 = {m_strName:"Firefox",			m_bSupported:false, m_nMinVer:2, m_nMaxVer:NO_LIMIT, m_strVerRange:null, m_strKey:"firefox"};
	$m_arrSysReqs[BROWSER][NETSCAPE] = {m_strName:"Netscape Navigator",	m_bSupported:false, m_nMinVer:8, m_nMaxVer:NO_LIMIT, m_strVerRange:null, m_strKey:"navigator"};
	$m_arrSysReqs[BROWSER][SAFARI]	 = {m_strName:"Safari",				m_bSupported:false, m_nMinVer:3, m_nMaxVer:NO_LIMIT, m_strVerRange:null, m_strKey:"safari", m_strAltKey:"version"};
	$m_arrSysReqs[BROWSER][OPERA]	 = {m_strName:"Opera",				m_bSupported:false, m_nMinVer:9, m_nMaxVer:NO_LIMIT, m_strVerRange:null, m_strKey:"opera", m_strAltKey:"version"};
	$m_arrSysReqs[BROWSER][CHROME]	 = {m_strName:"Chrome",				m_bSupported:false, m_nMinVer:4, m_nMaxVer:NO_LIMIT, m_strVerRange:null, m_strKey:"chrome"};
	$m_arrSysReqs[FLASH]			 = {m_strName:"Flash Player",		m_nMinVer:8, m_nMaxVer:NO_LIMIT, m_strVerRange:null, m_bRequired:true};
	$m_arrSysReqs[ACROBAT]			 = {m_strName:"Acrobat Reader",		m_nMinVer:4, m_nMaxVer:NO_LIMIT, m_strVerRange:null, m_bRequired:false};
	$m_arrSysReqs[SCREENRES]		 = {m_strName:"Screen Resolution",	m_nMinWidth:800, m_nMinHeight:600, m_bRequired:true};
	$m_arrSysReqs[POPUPS]		 	 = {m_bRequired:false};

	$m_arrSysReqs[BROWSER].m_bRequired = true;

		// Update protocol-sensitive messages
if ($m_strProtocol == "https:")
{
	ERRORMSG_FLASH_INVALID   = ERRORMSG_FLASH_INVALID.replace("http:", "https:");
	ERRORMSG_ACROBAT_INVALID = ERRORMSG_ACROBAT_INVALID.replace("http:", "https:");
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// CORE FUNCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////


/**
* Begin the version detection process
*
* @return	true if the client environment is valid; false otherwise
**/
function $core_SYSREQ_validate()
{
	if ($m_bSysReqsChecked)         // Only check the requirements once
		return;

		// Update browser settings
	for (var inBrowser = 0; inBrowser < $m_arrSysReqs[BROWSER].length; inBrowser++)
	{
		var objBrowser = $m_arrSysReqs[BROWSER][inBrowser];

			// List the min/max range
		objBrowser.m_strVerRange = objBrowser.m_nMinVer;
		if (!objBrowser.m_nMaxVer)
			objBrowser.m_strVerRange += "+";
		else if (objBrowser.m_nMaxVer > objBrowser.m_nMinVer)
			objBrowser.m_strVerRange += " - " + objBrowser.m_nMaxVer;
	}

		// Update the Flash min/max range
	$m_arrSysReqs[FLASH].m_strVerRange = $m_arrSysReqs[FLASH].m_nMinVer;
	if ($m_arrSysReqs[FLASH].m_nMaxVer > $m_arrSysReqs[FLASH].m_nMinVer)
		$m_arrSysReqs[FLASH].m_strVerRange += " - " + $m_arrSysReqs[FLASH].m_nMaxVer;
	else if (!objBrowser.m_nMaxVer)
		$m_arrSysReqs[FLASH].m_strVerRange += "+";

		// Update the Acrobat min/max range
	$m_arrSysReqs[ACROBAT].m_strVerRange = $m_arrSysReqs[ACROBAT].m_nMinVer;
	if ($m_arrSysReqs[ACROBAT].m_nMaxVer > $m_arrSysReqs[ACROBAT].m_nMinVer)
		$m_arrSysReqs[ACROBAT].m_strVerRange += " - " + $m_arrSysReqs[ACROBAT].m_nMaxVer;
	else if (!objBrowser.m_nMaxVer)
		$m_arrSysReqs[ACROBAT].m_strVerRange += "+";

		// Validate each sys req
	$m_arrClientSys[BROWSER].m_bValid	= $SYSREQ_isValidBrowser();
	$m_arrClientSys[FLASH].m_bValid		= $SYSREQ_isValidFlashPlayer();
	$m_arrClientSys[ACROBAT].m_bValid	= $SYSREQ_isValidAcrobatReader();
	$m_arrClientSys[SCREENRES].m_bValid	= $SYSREQ_isValidScreenRes();
	$m_arrClientSys[POPUPS].m_bValid	= $SYSREQ_isValidPopups();

		// All specs must be valid
	$m_bValid_SysReqs = (($m_arrClientSys[BROWSER].m_bValid) && ($m_arrClientSys[FLASH].m_bValid) && ($m_arrClientSys[ACROBAT].m_bValid) && ($m_arrClientSys[SCREENRES].m_bValid) && ($m_arrClientSys[POPUPS].m_bValid));

	$m_bSysReqsChecked = true;
	return $m_bValid_SysReqs;
}
	// Assign default/overridable function
$SYSREQ_validate = $core_SYSREQ_validate;


/**
* Ensure validation has occurred
**/
function $core_SYSREQ_ensureValidation()
{
	if (!$m_bSysReqsChecked)
		$SYSREQ_validate();
}
	// Assign default/overridable function
$SYSREQ_ensureValidation = $core_SYSREQ_ensureValidation;

///////////////////////////////////////////////////////////////////////////////////////////////////
// FORMATTING FUNCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Write the appropriate HTML code for the "System Requirements" heading.
**/
function $core_SYSREQ_writeSysReqHeading()
{
	document.writeln(HEADING_SYSREQ);
}
	// Assign default/overridable function
$SYSREQ_writeSysReqHeading = $core_SYSREQ_writeSysReqHeading;

/**
* Write the appropriate HTML code for the "Application/Setting" heading.
**/
function $core_SYSREQ_writeApplicationHeading()
{
	document.writeln(HEADING_APPLICATION);
}
	// Assign default/overridable function
$SYSREQ_writeApplicationHeading = $core_SYSREQ_writeApplicationHeading;

/**
* Write the appropriate HTML code for the "Current" version heading.
**/
function $core_SYSREQ_writeCurrentVerHeading()
{
	document.writeln(HEADING_CURRENTVER);
}
	// Assign default/overridable function
$SYSREQ_writeCurrentVerHeading = $core_SYSREQ_writeCurrentVerHeading;

/**
* Write the appropriate HTML code for the "Required" version heading.
**/
function $core_SYSREQ_writeRequiredVerHeading()
{
	document.writeln(HEADING_REQUIREDVER);
}
	// Assign default/overridable function
$SYSREQ_writeRequiredVerHeading = $core_SYSREQ_writeRequiredVerHeading;

/**
* Write the appropriate HTML code for the "Status" heading.
**/
function $core_SYSREQ_writeStatusHeading()
{
	document.writeln(HEADING_STATUS);
}
	// Assign default/overridable function
$SYSREQ_writeStatusHeading = $core_SYSREQ_writeStatusHeading;

/**
* Write the appropriate HTML code for the "Flash Player" heading.
**/
function $core_SYSREQ_writeFlashID()
{
	document.writeln(HEADING_FLASH);
}
	// Assign default/overridable function
$SYSREQ_writeFlashID = $core_SYSREQ_writeFlashID;

/**
* Write the appropriate HTML code for the "Adobe Acrobat" heading.
**/
function $core_SYSREQ_writeAcrobatID()
{
	document.writeln(HEADING_ACROBAT);
}
	// Assign default/overridable function
$SYSREQ_writeAcrobatID = $core_SYSREQ_writeAcrobatID;


/**
* Write the appropriate HTML code for the "Screen Resolution" heading.
**/
function $core_SYSREQ_writeScreenResID()
{
	document.writeln(HEADING_SCREENRES);
}
	// Assign default/overridable function
$SYSREQ_writeScreenResID = $core_SYSREQ_writeScreenResID;

///////////////////////////////////////////////////////////////////////////////////////////////////
// BROWSER VALIDATION FUNCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Check the browser requirements
*	IE: 		mozilla/4.0 (compatible; msie 7.0; windows nt 5.1; .net clr 1.1.4322; .net clr 2.0.50727; infopath.1)
*	Firefox: 	mozilla/5.0 (windows; u; windows nt 5.1; en-us; rv:1.8.1.12) gecko/20080201 firefox/2.0.0.12
*	Opera:	opera/9.25 (windows nt 5.1; u; en)
*	Netscape:	mozilla/5.0 (windows; u; windows nt 5.1; en-us; rv:1.8.1.11pre) gecko/20071206 firefox/2.0.0.11 navigator/9.0.0.5
*	Safari: 	mozilla/5.0 (windows; u; windows nt 5.1; en-us) applewebkit/523.15 (khtml, like gecko) version/3.0 safari/523.15
*	Chrome:	mozilla/5.0 (windows; u; windows nt 5.1; en-us) applewebkit/523.0 (khtml, like gecko) chrome/3.0.195.25 safari/532.0
* @return	true if the browser is valid; false otherwise
**/
function $core_SYSREQ_isValidBrowser()
{
		// If this check isn't required skip it
	if (!$m_arrSysReqs[BROWSER].m_bRequired)
		return true;

	var strNavAgent = navigator.userAgent.toLowerCase();
	
		// Check all known browsers
	for (var inBrowser = 0; inBrowser < $m_arrSysReqs[BROWSER].length; inBrowser++)
	{
		var objBrowser = $m_arrSysReqs[BROWSER][inBrowser];

			// If a matching key...
		if (strNavAgent.indexOf(objBrowser.m_strKey) != -1)
		{
			var nVerStart;
			
				// Check alt key first
			if ((typeof(objBrowser.m_strAltKey) != "undefined") && (strNavAgent.indexOf(objBrowser.m_strAltKey) != -1))
				nVerStart = strNavAgent.indexOf(objBrowser.m_strAltKey) + objBrowser.m_strAltKey.length + 1;
			else
				nVerStart = strNavAgent.indexOf(objBrowser.m_strKey) + objBrowser.m_strKey.length + 1;
			var nVerEnd   = 0;
			
			for (var inChar = nVerStart; inChar < strNavAgent.length; inChar++)
			{
				if ((strNavAgent.charAt(inChar) == ',') || (strNavAgent.charAt(inChar) == ';') || 
				(strNavAgent.charAt(inChar) == ' ') || (strNavAgent.charAt(inChar) == '/'))
				{
					nVerEnd = inChar;
					break;
				}
			}
			if (nVerEnd <= 0)
				nVerEnd = strNavAgent.length;
							
				// Capture the info
			$m_arrClientSys[BROWSER].m_nID		  = inBrowser;
			$m_arrClientSys[BROWSER].m_strName	  = objBrowser.m_strName;
			$m_arrClientSys[BROWSER].m_bSupported = objBrowser.m_bSupported;
			$m_arrClientSys[BROWSER].m_strVer	  = strNavAgent.substring(nVerStart, nVerEnd);
			$m_arrClientSys[BROWSER].m_nVer		  = parseInt($m_arrClientSys[BROWSER].m_strVer);
			$m_arrClientSys[BROWSER].m_strReqVer  = objBrowser.m_strVerRange;

				// See if valid
			if ((objBrowser.m_bSupported) && ($m_arrClientSys[BROWSER].m_nVer >= objBrowser.m_nMinVer) && 
			(objBrowser.m_nMaxVer == null || $m_arrClientSys[BROWSER].m_nVer <= objBrowser.m_nMaxVer))
				return true;

			break;
		}
	}
}
	// Assign default/overridable function
$SYSREQ_isValidBrowser = $core_SYSREQ_isValidBrowser;


/**
* Write the appropriate HTML code for the browser ID
**/
function $core_SYSREQ_writeBrowserID()
{
	$SYSREQ_ensureValidation();    
	document.writeln($m_arrClientSys[BROWSER].m_strName);
}
	// Assign default/overridable function
$SYSREQ_writeBrowserID = $core_SYSREQ_writeBrowserID;


/**
* Write the appropriate HTML code for the browser version
**/
function $core_SYSREQ_writeBrowserVer()
{
	$SYSREQ_ensureValidation();
	document.writeln($m_arrClientSys[BROWSER].m_strVer);
}
	// Assign default/overridable function
$SYSREQ_writeBrowserVer = $core_SYSREQ_writeBrowserVer;


/**
* Write the appropriate HTML code for the required browser version
**/
function $core_SYSREQ_writeBrowserReqVer()
{
	$SYSREQ_ensureValidation();

		// If the wrong browser is being used...
	if (!$m_arrClientSys[BROWSER].m_bSupported)
	{
		var strSupported = "";
		for (var inBrowser = 0; inBrowser < $m_arrSysReqs[BROWSER].length; inBrowser++)
		{
			var objBrowser = $m_arrSysReqs[BROWSER][inBrowser];

			if (objBrowser.m_bSupported)
				strSupported += objBrowser.m_strName + " " + objBrowser.m_strVerRange + "<BR>";
		}
		document.writeln("<FONT color='red'>" +strSupported+ "</FONT>");
	}
	else
	{
		if ($m_arrClientSys[BROWSER].m_bValid)
			document.writeln($m_arrClientSys[BROWSER].m_strReqVer);
		else
			document.writeln("<FONT color='red'>" +$m_arrClientSys[BROWSER].m_strReqVer+ "</FONT>");
	}
}
	// Assign default/overridable function
$SYSREQ_writeBrowserReqVer = $core_SYSREQ_writeBrowserReqVer;


/**
* Write the appropriate HTML code for the browser validation (checkmark/x)
**/
function $core_SYSREQ_writeBrowserStatus()
{
	$SYSREQ_ensureValidation();
	$SYSREQ_writeValidationMark($m_arrClientSys[BROWSER].m_bValid);
}
	// Assign default/overridable function
$SYSREQ_writeBrowserStatus = $core_SYSREQ_writeBrowserStatus;

///////////////////////////////////////////////////////////////////////////////////////////////////
// FLASH VALIDATION FUNCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Check the Flash player requirements
*
* @return	true if the Flash player is valid; false otherwise
**/
function $core_SYSREQ_isValidFlashPlayer()
{
		// If this check isn't required skip it
	if (!$m_arrSysReqs[FLASH].m_bRequired)
		return true;

		// Get the flash version
	if ($m_arrClientSys[BROWSER].m_nID != IE)
	{
		var objPlugin = (navigator.mimeTypes &&
						navigator.mimeTypes["application/x-shockwave-flash"] &&
						navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin) ?
						navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin : 0;
		if (objPlugin)
		{
			var nDot	  = objPlugin.description.indexOf(".");
			var nMajorVer = parseInt(objPlugin.description.substring(nDot - 2));
			var nMinorVer = parseInt(objPlugin.description.substring(nDot + 1));
			
			$m_arrClientSys[FLASH].m_nVer = nMajorVer;
			if ((nMinorVer) && (!isNaN(nMinorVer)))
				$m_arrClientSys[FLASH].m_nVer += (nMinorVer / 10);
		}
	}
	else
	{
			// This script will test up to the following version.
		var nMaxVersions = 20;

			// Check ActiveX-style plug-ins
		if (window.ActiveXObject)
		{
			var nVersion = null;
			var nMinorVersion = null;

			try{
				var objFlash = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
				if (objFlash)
				{
					var strVer = objFlash.GetVariable("$version").replace(/\D+/g, ",").match(/^,?(.+),?$/)[1];
					nVersion = parseInt(strVer.split(',').shift());
					nMinorVersion = parseInt(strVer.split(',')[1]);
					if ((nMinorVersion) && (!isNaN(nMinorVersion)))
						nVersion += (nMinorVersion / 10);
					if ((nVersion) && (nVersion > 2))
						$m_arrClientSys[FLASH].m_nVer = nVersion;
					else
						nVersion = null;
				}
			}catch(e){	nVersion = null;	}

			if (!nVersion)
			{
				for (inVer = 20; inVer >= 3; inVer--)
				{
					try{
						var objFlash = eval("new ActiveXObject('ShockwaveFlash.ShockwaveFlash." + inVer + "');");
						if (objFlash)
						{
							$m_arrClientSys[FLASH].m_nVer = inVer;
							break;
						}
					}
					catch(e){}
				}
			}
		}
	}

	if (($m_arrClientSys[FLASH].m_nVer) && ($m_arrClientSys[FLASH].m_nVer > 1))
		$m_arrClientSys[FLASH].m_strVer = "" + $m_arrClientSys[FLASH].m_nVer;

		// Validate the Flash Player requirements
	if (($m_arrClientSys[FLASH].m_nVer >= $m_arrSysReqs[FLASH].m_nMinVer) && 
	($m_arrSysReqs[FLASH].m_nMaxVer == null || $m_arrClientSys[FLASH].m_nVer <= $m_arrSysReqs[FLASH].m_nMaxVer))
		return true;
	else
		return false;
}
	// Assign default/overridable function
$SYSREQ_isValidFlashPlayer = $core_SYSREQ_isValidFlashPlayer;


/**
* Write the appropriate HTML code for the Flash version
**/
function $core_SYSREQ_writeFlashVer()
{
	$SYSREQ_ensureValidation();

	if ($m_arrClientSys[FLASH].m_nVer == 0)
		document.writeln("<FONT color='red'>" + STATUS_NOTINSTALLED + "</FONT>");
	else
		document.writeln($m_arrClientSys[FLASH].m_strVer);
}
	// Assign default/overridable function
$SYSREQ_writeFlashVer = $core_SYSREQ_writeFlashVer;


/**
* Write the appropriate HTML code for the required Flash version
**/
function $core_SYSREQ_writeFlashReqVer()
{
	$SYSREQ_ensureValidation();

	if ($m_arrClientSys[FLASH].m_bValid)
		document.writeln($m_arrSysReqs[FLASH].m_strVerRange);
	else
		document.writeln("<FONT color='red'>" +$m_arrSysReqs[FLASH].m_strVerRange+ "</FONT>");
}
	// Assign default/overridable function
$SYSREQ_writeFlashReqVer = $core_SYSREQ_writeFlashReqVer;


/**
* Write the appropriate HTML code for the Flash validation (checkmark/x)
**/
function $core_SYSREQ_writeFlashStatus()
{
	$SYSREQ_ensureValidation();
	$SYSREQ_writeValidationMark($m_arrClientSys[FLASH].m_bValid);
}
	// Assign default/overridable function
$SYSREQ_writeFlashStatus = $core_SYSREQ_writeFlashStatus;

///////////////////////////////////////////////////////////////////////////////////////////////////
// ACROBAT VALIDATION FUNCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////
	
/**
* Check the acrobat requirements
*
* @return	true if the Acrobat reader is valid; false otherwise
**/
function $core_SYSREQ_isValidAcrobatReader()
{
		// If this check isn't required skip it
	if (!$m_arrSysReqs[ACROBAT].m_bRequired)
		return true;

		// Get the Acrobat version
	if ($m_arrClientSys[BROWSER].m_nID != IE)
	{
		var objPlugin = (navigator.mimeTypes &&
						navigator.mimeTypes["application/pdf"] &&
						navigator.mimeTypes["application/pdf"].enabledPlugin) ?
						navigator.mimeTypes["application/pdf"].enabledPlugin : 0;
		if (objPlugin)
		{
			if (objPlugin.description.indexOf("Adobe Acrobat") >= 0)
				$m_arrClientSys[ACROBAT].m_nVer = parseFloat(objPlugin.description.split('Version ')[1]);

				// If the user has Adobe Acrobat Reader 8 or later,
				// we can not get the version number in a non IE browser,
				// if this course requires above version 8
				// we must assume it's okay
			else if (objPlugin.description.indexOf("Adobe PDF") >= 0)
				$m_arrClientSys[ACROBAT].m_nVer = Math.max(8, $m_arrSysReqs[ACROBAT].m_nMinVer);
		}
	}
	else if (window.ActiveXObject)
	{
		var objReader = null;   

		try {   
				// AcroPDF.PDF is used by version 7 and later   
			objReader = new ActiveXObject('AcroPDF.PDF');   
		}
		catch(e){}   

		if (!objReader)
		{   
			try {   
					// PDF.PdfCtrl is used by version 6 and earlier   
				objReader = new ActiveXObject('PDF.PdfCtrl');   
			}
			catch(e){}   
		}   
		if (objReader)
		{   
			var arrVersion = objReader.GetVersions().split(',')[0].split('='); 

			$m_arrClientSys[ACROBAT].m_nVer = parseFloat(arrVersion[1]);
		}
	}

	if (($m_arrClientSys[ACROBAT].m_nVer) && ($m_arrClientSys[ACROBAT].m_nVer > 1))
		$m_arrClientSys[ACROBAT].m_strVer = "" + $m_arrClientSys[ACROBAT].m_nVer;

		// Validate the Acrobat Reader requirements
	if (($m_arrSysReqs[ACROBAT].m_nMinVer == null || $m_arrClientSys[ACROBAT].m_nVer >= $m_arrSysReqs[ACROBAT].m_nMinVer) && 
	($m_arrSysReqs[ACROBAT].m_nMaxVer == null || $m_arrClientSys[ACROBAT].m_nVer <= $m_arrSysReqs[ACROBAT].m_nMaxVer))
		return true;
	else
		return false;
}
	// Assign default/overridable function
$SYSREQ_isValidAcrobatReader = $core_SYSREQ_isValidAcrobatReader;


/**
* Write the appropriate HTML code for the Acrobat version
**/
function $core_SYSREQ_writeAcrobatVer()
{
	$SYSREQ_ensureValidation();

	if ($m_arrClientSys[ACROBAT].m_nVer == 0)
		document.writeln("<FONT color='red'>" + STATUS_NOTINSTALLED + "</FONT>");
	else
		document.writeln($m_arrClientSys[ACROBAT].m_strVer);
}
	// Assign default/overridable function
$SYSREQ_writeAcrobatVer = $core_SYSREQ_writeAcrobatVer;


/**
* Write the appropriate HTML code for the required Acrobat version
**/
function $core_SYSREQ_writeAcrobatReqVer()
{
	$SYSREQ_ensureValidation();

	if ($m_arrClientSys[ACROBAT].m_bValid)
		document.writeln($m_arrSysReqs[ACROBAT].m_strVerRange);
	else
		document.writeln("<FONT color='red'>" +$m_arrSysReqs[ACROBAT].m_strVerRange+ "</FONT>");
}
	// Assign default/overridable function
$SYSREQ_writeAcrobatReqVer = $core_SYSREQ_writeAcrobatReqVer;


/**
* Write the appropriate HTML code for the Acrobat validation (checkmark/x)
**/
function $core_SYSREQ_writeAcrobatStatus()
{
	$SYSREQ_ensureValidation();
	$SYSREQ_writeValidationMark($m_arrClientSys[ACROBAT].m_bValid);
}
	// Assign default/overridable function
$SYSREQ_writeAcrobatStatus = $core_SYSREQ_writeAcrobatStatus;

///////////////////////////////////////////////////////////////////////////////////////////////////
// SCREEN RESOLUTION VALIDATION FUNCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Check the screen resolution requirements
*
* @return	true if the screen resolution is valid; false otherwise
**/
function $core_SYSREQ_isValidScreenRes()
{
		// If this check isn't required skip it
	if (!$m_arrSysReqs[SCREENRES].m_bRequired)
		return true;

	if ((screen.deviceXDPI) && (typeof screen.deviceXDPI != "undefined"))
	{
		$m_arrClientSys[SCREENRES].m_nWidth  = screen.width * screen.deviceXDPI / screen.logicalXDPI;
		$m_arrClientSys[SCREENRES].m_nHeight = screen.height * screen.deviceYDPI / screen.logicalYDPI;
	}
	else if ((screen.width) && (typeof screen.width != "undefined"))
	{
		$m_arrClientSys[SCREENRES].m_nWidth  = screen.width;
		$m_arrClientSys[SCREENRES].m_nHeight = screen.height;
	}
		// If unable to detect resolution, ignore it
	else
		return true;

	return (($m_arrClientSys[SCREENRES].m_nWidth >= $m_arrSysReqs[SCREENRES].m_nMinWidth) && ($m_arrClientSys[SCREENRES].m_nHeight >= $m_arrSysReqs[SCREENRES].m_nMinHeight))
}
	// Assign default/overridable function
$SYSREQ_isValidScreenRes = $core_SYSREQ_isValidScreenRes;


/**
* Write the appropriate HTML code for the screen resolution
**/
function $core_SYSREQ_writeScreenRes()
{
	$SYSREQ_ensureValidation();
	if ((!$m_arrClientSys[SCREENRES].m_nWidth) || (isNaN($m_arrClientSys[SCREENRES].m_nWidth)))
		document.writeln("N/A");
	else
		document.writeln($m_arrClientSys[SCREENRES].m_nWidth + "x" + $m_arrClientSys[SCREENRES].m_nHeight);	
}
	// Assign default/overridable function
$SYSREQ_writeScreenRes = $core_SYSREQ_writeScreenRes;


/**
* Write the appropriate HTML code for the required screen resolution
**/
function $core_SYSREQ_writeScreenReqRes()
{
	$SYSREQ_ensureValidation();

	if ($m_arrClientSys[SCREENRES].m_bValid)
		document.writeln($m_arrSysReqs[SCREENRES].m_nMinWidth + "x" + $m_arrSysReqs[SCREENRES].m_nMinHeight + "+");
	else
		document.writeln("<FONT color='red'>" +$m_arrSysReqs[SCREENRES].m_nMinWidth + "x" + $m_arrSysReqs[SCREENRES].m_nMinHeight + "+</FONT>");
}
	// Assign default/overridable function
$SYSREQ_writeScreenReqRes = $core_SYSREQ_writeScreenReqRes;


/**
* Write the appropriate HTML code for the browser validation (checkmark/x)
**/
function $core_SYSREQ_writeScreenResStatus()
{
	$SYSREQ_ensureValidation();
	$SYSREQ_writeValidationMark($m_arrClientSys[SCREENRES].m_bValid);
}
	// Assign default/overridable function
$SYSREQ_writeScreenResStatus = $core_SYSREQ_writeScreenResStatus;


///////////////////////////////////////////////////////////////////////////////////////////////////
// POPUP VALIDATION FUNCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Check for a popup blocker
*
* @return	true if popups are working; false otherwise
**/
function $core_SYSREQ_isValidPopups()
{
		// If this check isn't required skip it
	if (!$m_arrSysReqs[POPUPS].m_bRequired)
		return true;

	try
	{
		m_hwndPopup = window.open( "", "PopupTest", "width=50,height=50,status,scrollbars,resizable,screenX=20,screenY=40,left=20,top=40");
		if ((typeof m_hwndPopup != "undefined") && (m_hwndPopup != null))
		{
			m_hwndPopup.close();
			$m_arrClientSys[POPUPS].m_bEnabled = true;

			return true;
		}
	}
	catch(e)
	{
		$m_arrClientSys[POPUPS].m_bEnabled = false;
		
		if ($m_arrSysReqs[POPUPS].m_bRequired && !$m_arrClientSys[POPUPS].m_bEnabled)
			return false;
		else 
			return true;
	}
	return false;
}
	// Assign default/overridable function
$SYSREQ_isValidPopups = $core_SYSREQ_isValidPopups;

/**
* Write the appropriate HTML code for the Popup version
**/
function $core_SYSREQ_writePopupsEnabled()
{
	$SYSREQ_ensureValidation();

	if (!$m_arrClientSys[POPUPS].m_bEnabled)
		document.writeln(STATUS_NOTENABLED);
	else
		document.writeln(STATUS_ENABLED);
}
	// Assign default/overridable function
$SYSREQ_writePopupsEnabled = $core_SYSREQ_writePopupsEnabled;


/**
* Write the appropriate HTML code for the required Popup version
**/
function $core_SYSREQ_writePopupsRequired()
{
	$SYSREQ_ensureValidation();

	if ($m_arrSysReqs[POPUPS].m_bRequired && !$m_arrClientSys[POPUPS].m_bEnabled)
		document.writeln("<FONT color='red'>" + STATUS_REQUIRED + "</FONT>");
	else if ($m_arrSysReqs[POPUPS].m_bRequired)
		document.writeln(STATUS_REQUIRED);
	else
		document.writeln(STATUS_NOTREQUIRED);
}
	// Assign default/overridable function
$SYSREQ_writePopupsRequired = $core_SYSREQ_writePopupsRequired;


/**
* Write the appropriate HTML code for the Popup validation (checkmark/x)
**/
function $core_SYSREQ_writePopupsStatus()
{
	$SYSREQ_ensureValidation();

	if ($m_arrSysReqs[POPUPS].m_bRequired && !$m_arrClientSys[POPUPS].m_bEnabled)
		$SYSREQ_writeValidationMark(false);
	else 
		$SYSREQ_writeValidationMark(true);
}
	// Assign default/overridable function
$SYSREQ_writePopupsStatus = $core_SYSREQ_writePopupsStatus;



///////////////////////////////////////////////////////////////////////////////////////////////////
// OVERALL VALIDATION FUNCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Write the appropriate HTML code for validation (checkmark/x)
*
* @param bValid  true if a checkmark should be written; false otherwise
**/
function $core_SYSREQ_writeValidationMark(bValid)
{
	if (bValid)
		document.writeln("<IMG class='vMark' src='inc/graphics/checkmark.gif'>");
	else
		document.writeln("<IMG class='vMark' src='inc/graphics/cross.gif'>");
}
	// Assign default/overridable function
$SYSREQ_writeValidationMark = $core_SYSREQ_writeValidationMark;


/**
* Write the appropriate HTML code for the overal validation/summary status
**/
function $core_SYSREQ_writeOverallStatus()
{
	if ($m_bValid_SysReqs)
		document.writeln(MSG_VALID);
	else
		document.writeln(ERRORMSG_INVALID);
}
	// Assign default/overridable function
$SYSREQ_writeOverallStatus = $core_SYSREQ_writeOverallStatus;


/**
* Write the appropriate HTML code for the error messages (if necessary)
**/
function $core_SYSREQ_writeErrors()
{
	$SYSREQ_ensureValidation();
	if ($m_bValid_SysReqs)
		return;

	if (!$m_arrClientSys[BROWSER].m_bValid)
		document.writeln(ERRORMSG_BROWSER_INVALID);

	if (!$m_arrClientSys[FLASH].m_bValid)
		document.writeln(ERRORMSG_FLASH_INVALID);

	if (!$m_arrClientSys[ACROBAT].m_bValid)
		document.writeln(ERRORMSG_ACROBAT_INVALID);

	if (!$m_arrClientSys[SCREENRES].m_bValid)
		document.writeln(ERRORMSG_SCREENRES_INVALID);

	if (!$m_arrClientSys[POPUPS].m_bValid)
		document.writeln(ERRORMSG_POPUPS_INVALID);
}
	// Assign default/overridable function
$SYSREQ_writeErrors = $core_SYSREQ_writeErrors;


/**
* Write the appropriate HTML code for the error/IT help (if necessary)
**/
function $core_SYSREQ_writeErrorHelp()
{
	$SYSREQ_ensureValidation();
	if ($m_bValid_SysReqs)
		return;

	document.writeln(ERRORMSG_ERROR_HELP);
}
	// Assign default/overridable function
$SYSREQ_writeErrorHelp = $core_SYSREQ_writeErrorHelp;