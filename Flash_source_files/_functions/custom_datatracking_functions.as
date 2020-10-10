///////////////////////////////////////////////////////////////////////////////////////////////////
// DATATRACKING - CUSTOM FUNCTIONALITY
//
// @author    Allen Communication Learning Services
// @version   3.2
// @comments  The ActionScript within this document contains custom datatracking functions
///////////////////////////////////////////////////////////////////////////////////////////////////

var MAX_COMBINED_NOTES:		Number   = 15;
var DEF_MAX_NOTES:			Number   = 10;
var MAX_NOTES:				Number   = 10;

var m_arrAudienceData:   	Array    = new Array();
var m_arrNotes:			 	Array    = new Array();
var m_strCustomDataPath: 	String   = "";
var m_strAudienceDataError: String   = "";
var m_stNotesDataError: 	String   = "";
var m_lvAudienceResult:  	LoadVars = null;
var m_lvNotesResult:		LoadVars = null;
var m_bAudienceDataLoad: 	Boolean  = false;
var m_bAudienceDataLoaded: 	Boolean  = false;
var m_bNotesDataLoad: 		Boolean  = false;
var m_bNotesDataLoaded: 	Boolean  = false;
var m_bCustomDataOn:		Boolean  = false;
var m_bDelayNotesCommit:    Boolean  = false;
var m_bNotesChanged:        Boolean  = false;
var m_arrPageNoteIDs:		Array    = null;


///////////////////////////////////////////////////////////////////////////////////////////////////
//MISC
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Verify data load
**/
gShell.verifyInitialDataLoad = function(Void): Boolean
{
	if ((gShell.m_bNotesDataLoad) && (gShell.m_bAudienceDataLoad))
	{
		gShell.$core_beginIntroSequence();	
		return true;
	}
	else
		return false;
}

/**
* OVERRIDE
**/	
gShell.$beginIntroSequence = function(Void): Void
{
		// See if custom data tracking supported...
	if ((gShell.m_strCustomDataPath) && (gShell.m_strCustomDataPath.length > 2) && (gShell.$getDataTrackingMode() != gShell.DATATRACKING_NONE))
		gShell.m_bCustomDataOn = true;
	else
		gShell.m_bCustomDataOn = false;
		 
	if ((_root._IDE_LOADED_) || (!gShell.m_bCustomDataOn))
		gShell.$core_beginIntroSequence();
	else
	{
		gShell.loadNotesData();
		gShell.loadAudienceData();
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// NOTES DATA (COURSE SPECIFIC)
///////////////////////////////////////////////////////////////////////////////////////////////////

/*
* Find a note by GUID
*/
gShell.findNoteByGUID = function(strGUID:String): Number
{
	if ((!strGUID) || (strGUID.length == 0))
		return undefined;
		
	for (var inNote:Number = 0; inNote < gShell.m_arrNotes.length; inNote++)
	{
		if (gShell.m_arrNotes[inNote].m_strGUID == strGUID)
			return inNote;	
	}
	return undefined;
}

/*
* Find a note by GUID
*/
gShell.getNoteByGUID = function(strGUID:String): Object
{
	if ((!strGUID) || (strGUID.length == 0))
		return undefined;
		
	for (var inNote:Number = 0; inNote < gShell.m_arrNotes.length; inNote++)
	{
		if (gShell.m_arrNotes[inNote].m_strGUID == strGUID)
			return gShell.m_arrNotes[inNote];	
	}
	return undefined;
}

/**
* Determine the number of custom notes in use
**/
gShell.getCustomNoteCount = function(Void): Number
{
	var nNotes: Number = 0;
	for (var inNote:Number = 0; inNote < gShell.m_arrNotes.length; inNote++)
	{
		if ((!gShell.m_arrNotes[inNote].m_strGUID) || (gShell.m_arrNotes[inNote].m_strGUID.length == 0))
			nNotes++;	
	}
	return nNotes;
}

/**
* Load a page-level note into the specified object
**/
gShell.loadPageNote = function(strObjectID:String, bReload:Boolean): Void
{
	var strGUID: String = gShell.$getCurrentPageNode().xtc_getGUID();	
	var xtcText: Object = gPage.$findObject(strObjectID);
	var objNote: Object = gShell.getNoteByGUID(strGUID + "::" + strObjectID);
	
	if (gDebugger)	gDebugger.$postMessage("loadPageNote: " + strGUID + "::" + strObjectID + ":" + objNote.m_strNote);
	
	if ((xtcText) && (objNote))
		xtcText.xtc_setText(objNote.m_strNote);
		
	if (!bReload)
		gShell.m_arrPageNoteIDs.push({m_strGUID:strGUID + "::" + strObjectID, m_strObjectID:strObjectID});
}

/**
* Save a page-level note
**/
gShell.savePageNote = function(strObjectID:String): Void
{
	var strGUID:  String = gShell.$getCurrentPageNode().xtc_getGUID();	
	var xtcText:  Object = gPage.$findObject(strObjectID);

	if (gDebugger)	gDebugger.$postMessage("savePageNote: " + strGUID + "::" + strObjectID);

	if (xtcText)
	{
		var strTitle: String = xtcText.xtc_getConfigValue("noteTitle");
		if (!strTitle)
			strTitle = gShell.$getCurrentPageNode().xtc_getName();
		gShell.saveNote(strTitle, xtcText.xtc_getText(), undefined, strGUID + "::" + strObjectID);
	}
}

/**
* Save multiple page-level notes
**/
gShell.savePageNotes = function(strObject1:String, strObject2:String, strObject3:String): Void
{
	gShell.m_bDelayNotesCommit = true;
	gShell.savePageNote(strObject1);
	if (strObject2)
		gShell.savePageNote(strObject2);
	if (strObject3)
		gShell.savePageNote(strObject3);
	gShell.m_bDelayNotesCommit = false;
	if (gShell.m_bNotesChanged)
		gShell.commitNotesData();
}


/**
* Add a new note
**/
gShell.saveNote = function(strTitle:String, strNote:String, nNoteID:Number, strGUID:String): Object
{
	if ((strGUID) && (strGUID.length > 0))
		nNoteID = gShell.findNoteByGUID(strGUID);

	if ((strNote) && (strNote.length > 0))
	{
		var bDataChange: Boolean = false;
		var objNote: 	 Object  = nNoteID != undefined ? gShell.m_arrNotes[nNoteID] : null;
		
			// If no valid note, create one
		if (!objNote)
		{
			bDataChange = true;
			objNote = new Object();
			nNoteID = gShell.m_arrNotes.length;
						
				// Store GUID
			if ((strGUID) && (strGUID.length > 0))
				objNote.m_strGUID = strGUID;
			else
				objNote.m_strGUID = undefined;
		}
		if (!objNote)
			return null;
		if ((objNote.m_strTitle != strTitle) || (objNote.m_strNote != strNote))
			bDataChange = true;
			
			// Store title
		if ((strTitle) && (strTitle.length > 0))
			objNote.m_strTitle = strTitle;
		else
			objNote.m_strTitle = undefined;
			// Store note
		objNote.m_strNote = strNote;
				
			// Save the note
		gShell.m_arrNotes[nNoteID] = objNote;
		
		if (bDataChange)
		{
			gShell.m_bNotesChanged = true;
			if (!gShell.m_bDelayNotesCommit)
				gShell.commitNotesData();
				
				// If on the target page, update it
			for (var inPageNote:Number = 0; inPageNote < gShell.m_arrPageNoteIDs.length; inPageNote++)
			{
				if (objNote.m_strGUID == gShell.m_arrPageNoteIDs[inPageNote].m_strGUID)
				{
					gShell.loadPageNote(gShell.m_arrPageNoteIDs[inPageNote].m_strObjectID);
					break;
				}
			}
		}
		return objNote;
	}
		// Or, if blanked out an existing note, then delete it
	else if (nNoteID != undefined)
		gShell.deleteNote(nNoteID);
		
	return null;
}

/**
* Delete a new note
**/
gShell.deleteNote = function(nNoteID:Number): Void
{
	if (nNoteID != undefined)
	{
		delete gShell.m_arrNotes[nNoteID];
		gShell.m_arrNotes.splice(nNoteID, 1);
		gShell.commitNotesData();
	}
}


/**
* Commit the notes data
**/
gShell.commitNotesData = function(Void): Void
{
	gShell.m_bDelayNotesCommit = false;
	if ((!gShell.m_bCustomDataOn) || (!gShell.m_bNotesDataLoaded))
		return;
		
	var strData: String = "";
	for (var inNote:Number = 0; inNote < gShell.m_arrNotes.length; inNote++)
	{
		strData += "~|~";
		if ((gShell.m_arrNotes[inNote].m_strTitle) && (gShell.m_arrNotes[inNote].m_strTitle.length > 0))
			strData += gShell.m_arrNotes[inNote].m_strTitle;
		strData += "@^@";
		if ((gShell.m_arrNotes[inNote].m_strNote) && (gShell.m_arrNotes[inNote].m_strNote.length > 0))
			strData += gShell.m_arrNotes[inNote].m_strNote;
		strData += "@^@";
		if ((gShell.m_arrNotes[inNote].m_strGUID) && (gShell.m_arrNotes[inNote].m_strGUID.length > 0))
			strData += gShell.m_arrNotes[inNote].m_strGUID;
	}
	strData += "##END!";
		
	gShell.m_lvNotesResult		  = new LoadVars();
	gShell.m_lvNotesResult.onLoad = gShell.onNotesDataSaved;
	
	var lvSend:  LoadVars = new LoadVars();
	lvSend.operation = "save";
	lvSend.field	 = "result_custom3";
	lvSend.data		 = escape(strData);
	lvSend.sendAndLoad(gShell.m_strCustomDataPath, gShell.m_lvNotesResult, "POST");
}

gShell.onNotesDataSaved = function(bSuccess:Boolean): Void	{	}

/**
* Load the notes data
**/
gShell.loadNotesData = function(Void): Void
{
	var dteCurrent:Date	= new Date();
		
	gShell.m_lvNotesResult		  = new LoadVars();
	gShell.m_lvNotesResult.onLoad = gShell.onNotesDataLoaded;
	
	var lvSend: LoadVars = new LoadVars();
	lvSend.operation = "load";
	lvSend.field	 = "result_custom3";
	lvSend.noCache	 = dteCurrent.getTime();
	lvSend.sendAndLoad(gShell.m_strCustomDataPath, gShell.m_lvNotesResult, "POST");
}

/**
* Event handler triggered when the notes data loads
**/
gShell.onNotesDataLoaded = function(bSuccess:Boolean): Void
{
	gShell.m_arrNotes = new Array();
	if (bSuccess) 
	{
		var strData: String = unescape(unescape(gShell.m_lvNotesResult.toString()));
		var arrData: Array  = strData.split("##END!")[0].split("~|~");
		
		if ((arrData) && (arrData.length > 0))
		{
			for (var inNote:Number = 1; inNote < Math.min(gShell.MAX_COMBINED_NOTES + 1, arrData.length); inNote++)
			{
				var arrNote: Array = arrData[inNote].split("@^@");
			
				if ((arrNote) && (arrNote.length >= 3))
				{
					var objNote: Object = new Object();
					objNote.m_strTitle = arrNote[0];
					objNote.m_strNote  = arrNote[1];
					objNote.m_strGUID  = arrNote[2];
					gShell.m_arrNotes.push(objNote);
				}
			}
		}
		gShell.m_bNotesDataLoaded = true;
	}
	
	gShell.m_bNotesDataLoad = true;
	gShell.verifyInitialDataLoad();
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// AUDIENCE DATA (SHARED BETWEEN COURSES)
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Save audience data
**/
gShell.saveAudienceData = function(strData1:String, strData2:String, strData3:String, strData4:String): Void
{
	var bDataChange:Boolean = false;
	
	if (gShell.m_arrAudienceData[0] != strData1)
	{
		bDataChange = true;
		gShell.m_arrAudienceData[0] = strData1;
	}
	if (gShell.m_arrAudienceData[1] != strData2)
	{
		bDataChange = true;
		gShell.m_arrAudienceData[1] = strData2;
	}
	if (gShell.m_arrAudienceData[2] != strData3)
	{
		bDataChange = true;
		gShell.m_arrAudienceData[2] = strData3;
	}
	if (gShell.m_arrAudienceData[3] != strData4)
	{
		bDataChange = true;
		gShell.m_arrAudienceData[3] = strData4;
	}
	
	if (bDataChange)
		gShell.commitAudienceData();
}

/**
* Commit the global audience data
**/
gShell.commitAudienceData = function(Void): Void
{
	if ((!gShell.m_bCustomDataOn) || (!gShell.m_bAudienceDataLoaded))
		return;
		
	var lvSend: LoadVars = new LoadVars();
	lvSend.operation = "save";
	lvSend.field	 = "custom3";
	lvSend.data		 = escape("~|~" + gShell.m_arrAudienceData[0] + "~|~" + gShell.m_arrAudienceData[1] + "~|~" + gShell.m_arrAudienceData[2] + "~|~" + gShell.m_arrAudienceData[3] + "##END!");
	lvSend.sendAndLoad(m_strCustomDataPath, lvSend, "POST");
}

/**
* Load the global audience data
**/
gShell.loadAudienceData = function(Void): Void
{
	var dteCurrent:Date	= new Date();
		
	gShell.m_lvAudienceResult		 = new LoadVars();
	gShell.m_lvAudienceResult.onLoad = gShell.onAudienceDataLoaded;
	
	var lvSend: LoadVars = new LoadVars();
	lvSend.operation = "load";
	lvSend.field	 = "custom3";
	lvSend.noCache	 = dteCurrent.getTime();
	lvSend.sendAndLoad(gShell.m_strCustomDataPath, gShell.m_lvAudienceResult, "POST");
}

/**
* Event handler triggered when the global audience data loads
**/
gShell.onAudienceDataLoaded = function(bSuccess:Boolean): Void
{
	gShell.m_arrAudienceData = new Array();
	
	if (bSuccess) 
	{
		var strData: String = unescape(unescape(gShell.m_lvAudienceResult.toString()));
		var arrData: Array  = strData.split("##END!")[0].split("~|~");
		
		if ((arrData) && (arrData.length > 0))
		{
			for (var inData:Number = 0; inData < Math.min(4, arrData.length); inData++)
				gShell.m_arrAudienceData[inData] = arrData[inData + 1];
		}
		gShell.m_bAudienceDataLoaded = true;
	}
	
	gShell.m_bAudienceDataLoad = true;
	gShell.verifyInitialDataLoad();
}