import mx.utils.*;
import mx.containers.*;
import flash.external.*;
import TextField.*;

class ExamInterface extends Object
{		
	private static var DEPTH_BLOCKER					:Number = 100;
	private static var DEPTH_POPUP						:Number = 120;
	
	private static var BEHAVIOR_RESET					:String = "RESET_ATTEMPTS";
	private static var BEHAVIOR_LOCK					:String = "LOCK_ATTEMPTS";
	
	public static var DELIMITER_MAIN					:String = "|";
	public static var DELIMITER_SUB						:String = "~";
	
	public static var BOOKMARK_NONE						:String = "NONE";
	public static var BOOKMARK_SIMPLE					:String = "SIMPLE";
	public static var BOOKMARK_FULL						:String = "FULL";
	
	private var str_DefaultFont							:String;
	private var str_FontToLoad							:String;
	
	private var n_OriginalStageWidth					:Number;
	private var n_OriginalStageHeight					:Number;
	private var n_CurrentStageWidth						:Number;
	private var n_CurrentStageHeight					:Number;
		
	private var $pane_ContentArea						:ExpandablePane;
	private var $mc_Interval							:MovieClip;
	private var $mc_Container							:MovieClip;
	private var $xml_Interface							:_XMLFile;
	private var $xml_Data								:_XMLFile;
	private var $exam_Engine							:ExamEngine;
	private var $obj_InterfaceData						:Object;
	private var $n_TotalAttempts						:Number;
	private var $n_AttemptLimit							:Number;
	private var $edt_TimeStampStart						:ExamDate;
	private var $edt_TimeStampCurrent					:ExamDate;
	private var $tsp_Limit								:TimeSpan;
	private var $str_TimeSpanBehavior					:String;
	private var $str_DisplayLabel						:String;
	private var $str_BookmarkData						:String;
	private var $str_BookmarkLocation					:String;
	
		// Data Tracking Configuration Variables
	private var $b_SaveInteraction_id					:Boolean;			// Should we save the question interaction id?
	private var $b_SaveInteraction_objective			:Boolean;			// Should we save the question interaction objective?
	private var $b_SaveInteraction_time					:Boolean;			// Should we save the question interaction time?
	private var $b_SaveInteraction_type					:Boolean;			// Should we save the question interaction type?
	private var $b_SaveInteraction_correct_response		:Boolean;			// Should we save the question interaction correct_response?
	private var $b_SaveInteraction_weighting			:Boolean;			// Should we save the question interaction weighting?
	private var $b_SaveInteraction_student_response		:Boolean;			// Should we save the question interaction student_response?
	private var $b_SaveInteraction_result				:Boolean;			// Should we save the question interaction result?
	private var $b_SaveInteraction_latency				:Boolean;			// Should we save the question interaction latency?
	
	private var $str_SaveBookmark_type					:String;			// How much bookmark data should be saved?
	
	public function get examEngine():ExamEngine
	{
		return $exam_Engine;
	}
	
	public function get preloader():Preloader
	{
		return $mc_Container.mc_Preloader;
	}
	
	public function get submitButton():SubmitButton
	{
		return SubmitButton(ExamButton.getButton("btn_Submit"));
	}
	
	public function get beginButton():ExamButton
	{
		return ExamButton.getButton("btn_Begin");
	}
	
	public function get nextButton():ExamButton
	{
		return ExamButton.getButton("btn_Next");
	}
	
	public function get finishButton():ExamButton
	{
		return ExamButton.getButton("btn_Finish");
	}
	
	public function get debugCorrectButton():ExamButton
	{
		return ExamButton.getButton("btn_DebugCorrect");
	}
	
	public function get debugIncorrectButton():ExamButton
	{
		return ExamButton.getButton("btn_DebugIncorrect");
	}
	
	public function get introTextDisplay():TextDisplay
	{
		return TextDisplay.getTextDisplay("dsp_Intro");
	}
	
	public function get overLimit():Boolean
	{
		if ($n_AttemptLimit == null)
			return false;

		return $n_TotalAttempts >= $n_AttemptLimit;
	}
	
	public function get attemptsRemaining():Number
	{
		if ($n_AttemptLimit == null)
			return 1;

		return $n_AttemptLimit - $n_TotalAttempts;
	}
	
	public function get overTimeSpan():Boolean
	{
		if ($tsp_Limit == null || $str_TimeSpanBehavior != BEHAVIOR_LOCK)
			return false;
		
		var tsp_Total:TimeSpan = $edt_TimeStampCurrent.subtract($edt_TimeStampStart);
		
		return tsp_Total.isGreaterThan($tsp_Limit);
	}
	
	public function get scrollEnabled():Boolean
	{
		if ($pane_ContentArea.content == null)
			return false;
		
		return $pane_ContentArea.content._height > $pane_ContentArea.height;
	}
	
	public function ExamInterface( mc_Container:MovieClip )
	{
		n_OriginalStageWidth	= Stage.width;
		n_OriginalStageHeight	= Stage.height;
		n_CurrentStageWidth		= Stage.width;
		n_CurrentStageHeight	= Stage.height;
		
		$mc_Container			= mc_Container;
		$mc_Interval			= $mc_Container.createEmptyMovieClip("mc_Interval", $mc_Container.getNextHighestDepth());
		$obj_InterfaceData		= new Object();
		var str_SavedData		:String;
		
		Mouse.addListener(this);
		
		_global.gInterface = this;
		
				// If were inside of Mamba...
		if (_root._SHELL_LOADED_)
		{
			str_SavedData	= _global.gShell.$getPageData();
			
			var str_ContentURL:String = _global.gShell.$m_urlPageContent;
			
			if (str_ContentURL.indexOf(":") < 0)
				str_ContentURL = _global.gShell.$getRootURL() + str_ContentURL;
			
			_root._ext_urlExamDataXML = str_ContentURL;
			xmlInterfaceLoaded(true);
		}
		else
		{
			var url_Interface:String = _root._ext_urlExamInterfaceXML;
			
			if (url_Interface == undefined)
				url_Interface = "exam_interface.xml";
			
			$xml_Interface = new _XMLFile(this);
			$xml_Interface.xtc_loadFile(url_Interface, xmlInterfaceLoaded);
			
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("onResize", this, Delegate.create(this, onResize));
				ExternalInterface.addCallback("getLocationData", this, Delegate.create(this, getLocationData));
				ExternalInterface.addCallback("getResultData", this, Delegate.create(this, getResultData));
				ExternalInterface.addCallback("getPercentScore", this, Delegate.create(this, getPercentScore));
				ExternalInterface.addCallback("isPassed", this, Delegate.create(this, isPassed));
				ExternalInterface.addCallback("getQuestionData", this, Delegate.create(this, getQuestionData));
				ExternalInterface.addCallback("getDelimiterMain", this, Delegate.create(this, getDelimiterMain));
				ExternalInterface.addCallback("getDelimiterSub", this, Delegate.create(this, getDelimiterSub));
				ExternalInterface.call("flashLoaded");
				
				str_SavedData = ExternalInterface.call("getSavedResultData").toString();
			}
		}
		
		var arr_SavedData:Array = str_SavedData.split(DELIMITER_MAIN);
		
		$n_TotalAttempts = Number(arr_SavedData[0]);
		
		if (isNaN($n_TotalAttempts))
			$n_TotalAttempts = 0;
			
		if (arr_SavedData[1] != null)
			$edt_TimeStampStart = new ExamDate(arr_SavedData[1]);
		
		if (arr_SavedData[2] != null)
			$str_BookmarkData = arr_SavedData[2];
			
		ExamEngine.DELIMITER = DELIMITER_SUB;
	}
	
	public function alignToItem( obj_Align:Object, obj_Target:Object ):Void
	{
		var obj_TargetParent:Object = obj_Target._parent;
		
		obj_Align._x = obj_Target._x;
		obj_Align._y = obj_Target._y;
		
		while(obj_TargetParent != obj_Align._parent)
		{
			obj_Align._x += obj_TargetParent._x;
			obj_Align._y += obj_TargetParent._y;
			obj_TargetParent = obj_TargetParent._parent;
		}
	}
	
	public function initializeTextField( txt_Item:TextField, str_Style:String ):Void
	{
		var fmtDefault:TextFormat	= txt_Item.getTextFormat();
		fmtDefault.font				= str_DefaultFont;
		fmtDefault.bold				= txt_Item.htmlText.indexOf("<B>") >= 0;
		fmtDefault.italic			= txt_Item.htmlText.indexOf("<I>") >= 0;
		
			// Capture the properties of the current text field
		var objTextInit: Object 	= new Object();
		objTextInit.autoSize    	= txt_Item.autoSize;				
		objTextInit.html 	  	 	= txt_Item.html;
		objTextInit.multiline  	 	= txt_Item.multiline;
		objTextInit.wordWrap   	 	= txt_Item.wordWrap;
		objTextInit.selectable 	 	= txt_Item.selectable;
		objTextInit.antiAliasType 	= txt_Item.antiAliasType;
		objTextInit.textColor     	= txt_Item.textColor;
		objTextInit.background	 	= txt_Item.background;
		objTextInit.backgroundColor = txt_Item.backgroundColor;
		objTextInit.border	 		= txt_Item.border;
		objTextInit.borderColor	 	= txt_Item.borderColor;
		objTextInit._x				= txt_Item._x;
		objTextInit._y				= txt_Item._y;
		objTextInit._width			= txt_Item._width;
		objTextInit._height			= txt_Item._height;
		objTextInit._name	    	= txt_Item._name;				
		objTextInit._parent    		= txt_Item._parent;				
		objTextInit.type			= txt_Item.type;
		objTextInit.onChanged		= txt_Item.onChanged;
		
		txt_Item._visible	= false;
		txt_Item._width		= 1;
		txt_Item._height	= 1;
		txt_Item._name		= objTextInit._name + "_UNUSED";
		
			// Create the new text field
		var txt_NewItem:TextField = objTextInit._parent.createTextField(objTextInit._name, txt_Item.getDepth(), objTextInit._x, objTextInit._y, objTextInit._width, objTextInit._height);							
		
		txt_NewItem.type	   	   	= objTextInit.type;
		txt_NewItem.autoSize    	= objTextInit.autoSize;				
		txt_NewItem.html 	  	 	= objTextInit.html;
		txt_NewItem.multiline  	 	= objTextInit.multiline;
		txt_NewItem.wordWrap   	 	= objTextInit.wordWrap;
		txt_NewItem.selectable 	 	= objTextInit.selectable;
		txt_NewItem.antiAliasType 	= objTextInit.antiAliasType;
		txt_NewItem.textColor     	= objTextInit.textColor;
		txt_NewItem.background	 	= objTextInit.background;
		txt_NewItem.backgroundColor = objTextInit.backgroundColor;
		txt_NewItem.border	 		= objTextInit.border;
		txt_NewItem.borderColor	 	= objTextInit.borderColor;
		txt_NewItem.onChanged		= objTextInit.onChanged;
		txt_NewItem.embedFonts 	 	= true;
		txt_NewItem.antiAliasType	= "advanced";
		txt_NewItem.setNewTextFormat(fmtDefault);
		txt_NewItem._visible		= true;
		objTextInit._parent[objTextInit._name] = txt_NewItem;
		
		if (_root._SHELL_LOADED_)
		{
			var xtcTextStyle:Object = _global.gShell.$getTextStyleCollection(str_Style)["exam"];
			
			if (xtcTextStyle != null)
				xtcTextStyle.xtc_applyPrimitiveStyle(txt_NewItem);
		}
	}
	
	public function registerExternalFont( str_Font:String, mc_Font:MovieClip ):Void
	{
//flash.external.ExternalInterface.call("alert", "Font Loaded: " + str_Font + " --> " + mc_Font);
		str_DefaultFont = str_Font;
	}
	
	///////////////////////// Begin Javascript Access Functions /////////////////////////////////////
	
	private function onResize( n_Width:Number, n_Height:Number ):Void
	{
		if ($pane_ContentArea.originalWidth + n_Width - n_OriginalStageWidth < $pane_ContentArea.minWidth)
			n_Width = n_OriginalStageWidth + $pane_ContentArea.minWidth - $pane_ContentArea.originalWidth;
		
		if ($pane_ContentArea.originalHeight + n_Height - n_OriginalStageHeight < $pane_ContentArea.minHeight)
			n_Height = n_OriginalStageHeight + $pane_ContentArea.minHeight - $pane_ContentArea.originalHeight;
		
		n_CurrentStageWidth = n_Width;
		n_CurrentStageHeight = n_Height;
		
		$mc_Container.mc_Background._width = n_CurrentStageWidth;
		$mc_Container.mc_Background._height = n_CurrentStageHeight;
		$pane_ContentArea.expandTo($pane_ContentArea.originalWidth + n_CurrentStageWidth - n_OriginalStageWidth, $pane_ContentArea.originalHeight + n_CurrentStageHeight - n_OriginalStageHeight);
	}
	
	private function getResultData():String
	{
		var str_ResultData:String = $n_TotalAttempts + DELIMITER_MAIN + $edt_TimeStampStart.toString();
		
		if ($str_SaveBookmark_type != BOOKMARK_NONE)
			str_ResultData += DELIMITER_MAIN + $exam_Engine.getBookmark();
			
		return str_ResultData;
	}
	
	private function getLocationData():String
	{
		if ($str_SaveBookmark_type == BOOKMARK_NONE)
			return null
		else
			return $str_DisplayLabel;
	}
	
	private function getPercentScore():Number
	{
		return $exam_Engine.scorePercent;
	}
	
	private function isPassed():Boolean
	{
		return $exam_Engine.isPassed;
	}
	
	private function getInteractionData():Array
	{
		var arr_Data:Array = new Array();
		
		if (($b_SaveInteraction_id) || ($b_SaveInteraction_objective) || ($b_SaveInteraction_time) || ($b_SaveInteraction_type)
		($b_SaveInteraction_correct_response) || ($b_SaveInteraction_weighting) || ($b_SaveInteraction_student_response) || ($b_SaveInteraction_result) || ($b_SaveInteraction_latency))
		{
			for (var i:Number = 0; i < $exam_Engine.currentSubmitedQuestions.length; i ++)
			{
				var obj_Data:Object = new Object();
				var qst_Target:Question = $exam_Engine.currentSubmitedQuestions[i];
				
				if ($b_SaveInteraction_id)
					obj_Data.id = qst_Target.id;
				if ($b_SaveInteraction_objective)
					obj_Data.objective = qst_Target.objective;
				if ($b_SaveInteraction_time)
					obj_Data.time = qst_Target.startTime;
				if ($b_SaveInteraction_type)
					obj_Data.type = qst_Target.SCORMType;
				if ($b_SaveInteraction_correct_response)
					obj_Data.correct = qst_Target.correctResponse;
				if ($b_SaveInteraction_weighting)
					obj_Data.weighting = qst_Target.pointValue;
				if ($b_SaveInteraction_student_response)
					obj_Data.response = qst_Target.response;
				if ($b_SaveInteraction_result)
					obj_Data.result = qst_Target.SCORMResult;
				if ($b_SaveInteraction_latency)
					obj_Data.latency = qst_Target.latency;
					
				arr_Data.push(obj_Data);
			}
		}
		
		return arr_Data;
	}
	
	private function getQuestionData():String
	{
		var str_Data:String = "";
		var arr_Data:Array	= getInteractionData();
		
		for (var i:Number = 0; i < arr_Data.length; i ++)
		{
			if (str_Data != "")
				str_Data += DELIMITER_MAIN;
			
			str_Data += arr_Data[i].id;
			str_Data += DELIMITER_SUB;
			str_Data += arr_Data[i].objective;
			str_Data += DELIMITER_SUB;
			str_Data += arr_Data[i].time;
			str_Data += DELIMITER_SUB;
			str_Data += arr_Data[i].type;
			str_Data += DELIMITER_SUB;
			str_Data += arr_Data[i].correct;
			str_Data += DELIMITER_SUB;
			str_Data += arr_Data[i].weighting;
			str_Data += DELIMITER_SUB;
			str_Data += arr_Data[i].response;
			str_Data += DELIMITER_SUB;
			str_Data += arr_Data[i].result;
			str_Data += DELIMITER_SUB;
			str_Data += arr_Data[i].latency;
		}
		
		return str_Data;
	}
	
	private function getDelimiterMain():String
	{
		return DELIMITER_MAIN;
	}
	
	private function getDelimiterSub():String
	{
		return DELIMITER_SUB;
	}
	
	///////////////////////// End Javascript Access Functions ///////////////////////////////////////
	
	private function xmlInterfaceLoaded( b_Success:Boolean ):Void
	{
		if (b_Success)
		{
			var xml_InterfaceNode:_XMLNode = $xml_Interface.xtc_findNode("interface");
			buildInterfaceData(xml_InterfaceNode);
			
			var url_Data:String = _root._ext_urlExamDataXML;
			
			if (url_Data == undefined)
				url_Data = "exam_data.xml";
			
			$xml_Data = new _XMLFile(this);
			$xml_Data.xtc_loadFile(url_Data, xmlDataLoaded);
		}
	}
	
	private function buildInterfaceData( xml_InterfaceNode:_XMLNode ):Void
	{
		var arr_InterfaceNodes:Array	= xml_InterfaceNode.xtc_getChildren();
		var n_InterfaceVersion:Number	= xml_InterfaceNode.xtc_getNumericAttribute("version");		
		
		if (n_InterfaceVersion == null)
			n_InterfaceVersion = 1;
		
			// Starting in interface version 3 items are grouped into categories
			// So the content nodes are two levels deep
		if (n_InterfaceVersion >= 3)
		{
			for (var i:Number = 0; i < arr_InterfaceNodes.length; i ++)
				$obj_InterfaceData[arr_InterfaceNodes[i].xtc_getNodeName()] = mergeNodeData($obj_InterfaceData[arr_InterfaceNodes[i].xtc_getNodeName()], arr_InterfaceNodes[i]);
		}
			// Previous versions are only one level deep
			// So we'll need to manually create the categories and add each item to every category
		else
		{
			var arr_Categories:Array = ["images", "buttons", "styles", "text"];
			
			for (var i:Number = 0; i < arr_Categories.length; i ++)
			{
				if ($obj_InterfaceData[arr_Categories[i]] == null)
					$obj_InterfaceData[arr_Categories[i]] = {children: {}};
					
				for (var j:Number = 0; j < arr_InterfaceNodes.length; j ++)
					$obj_InterfaceData[arr_Categories[i]].children[arr_InterfaceNodes[j].xtc_getNodeName()] = mergeNodeData($obj_InterfaceData[arr_Categories[i]].children[arr_InterfaceNodes[j].xtc_getNodeName()], arr_InterfaceNodes[j]);
			}
		}
	}
	
	private function mergeNodeData( obj_CurrentData:Object, xml_NewData:_XMLNode ):Object
	{
		if (obj_CurrentData == null)
			obj_CurrentData = new Object();
		
		var arr_ChildNodes:Array	= xml_NewData.xtc_getChildren();
		var str_Value:String		= xml_NewData.xtc_getValue();
		var obj_Attributes:Object	= xml_NewData.xtc_getAttributes();
		
		if (xml_NewData != null)
			obj_CurrentData.xml	= xml_NewData;
		
		if (str_Value != null)
			obj_CurrentData.value = str_Value;
		
		for (var str_Prop:String in obj_Attributes)
			obj_CurrentData[str_Prop] = obj_Attributes[str_Prop];
		
		if (arr_ChildNodes.length > 0)
		{
			if (obj_CurrentData.children == null)
				obj_CurrentData.children = new Object();
			
			for (var i:Number = 0; i < arr_ChildNodes.length; i ++)
				obj_CurrentData.children[arr_ChildNodes[i].xtc_getNodeName()] = mergeNodeData(obj_CurrentData.children[arr_ChildNodes[i].xtc_getNodeName()], arr_ChildNodes[i]);
		}
		
		return obj_CurrentData;
	}
	
	private function xmlDataLoaded( b_Success:Boolean ):Void
	{
//flash.external.ExternalInterface.call("alert", "xml data loaded: " + b_Success + " --> " + $xml_Data.m_xmlnData.m_xmlnData);
		if (b_Success)
		{
			var xml_ConfigNode:_XMLNode			= $xml_Data.xtc_findNode("config");
			var xml_MediaNode:_XMLNode			= $xml_Data.xtc_findNode("media");
			var xml_InterfaceNode:_XMLNode		= $xml_Data.xtc_findNode("interface");
			var xml_DataTrackingNode:_XMLNode	= xml_ConfigNode.xtc_findChild("datatracking");
			var xml_BookmarkNode:_XMLNode		= xml_DataTrackingNode.xtc_findChild("bookmark");
			var xml_InteractionNode:_XMLNode	= xml_DataTrackingNode.xtc_findChild("interactions");
			buildInterfaceData(xml_InterfaceNode);
			
			Audio.url = xml_MediaNode.xtc_getAttribute("audio_folder");
			Image.url = xml_MediaNode.xtc_getAttribute("gfx_folder");
			
			if (Audio.url == "" || Audio.url == null)
				Audio.url = "";
			else
				Audio.url += "/";
			
			if (Image.url == "" || Image.url == null)
				Image.url = "";
			else
				Image.url += "/";
			
			$n_AttemptLimit			= xml_ConfigNode.xtc_getNumericAttribute("attempt_limit");
			$tsp_Limit				= new TimeSpan(xml_ConfigNode.xtc_getAttribute("time_span"));
			$str_TimeSpanBehavior	= xml_ConfigNode.xtc_getAttribute("time_span_behavior");
			
			$b_SaveInteraction_id					= getBooleanWithDefault(xml_InteractionNode.xtc_getAttribute("id"),					getBoolean(_root._ext_strInteraction_id));
			$b_SaveInteraction_objective			= getBooleanWithDefault(xml_InteractionNode.xtc_getAttribute("objective"),			getBoolean(_root._ext_strInteraction_objective));
			$b_SaveInteraction_time					= getBooleanWithDefault(xml_InteractionNode.xtc_getAttribute("time"),				getBoolean(_root._ext_strInteraction_time));
			$b_SaveInteraction_type					= getBooleanWithDefault(xml_InteractionNode.xtc_getAttribute("type"),				getBoolean(_root._ext_strInteraction_type));
			$b_SaveInteraction_correct_response		= getBooleanWithDefault(xml_InteractionNode.xtc_getAttribute("correct_response"),	getBoolean(_root._ext_strInteraction_correct_response));
			$b_SaveInteraction_weighting			= getBooleanWithDefault(xml_InteractionNode.xtc_getAttribute("weighting"),			getBoolean(_root._ext_strInteraction_weighting));
			$b_SaveInteraction_student_response		= getBooleanWithDefault(xml_InteractionNode.xtc_getAttribute("student_response"),	getBoolean(_root._ext_strInteraction_student_response));
			$b_SaveInteraction_result				= getBooleanWithDefault(xml_InteractionNode.xtc_getAttribute("result"),				getBoolean(_root._ext_strInteraction_result));
			$b_SaveInteraction_latency				= getBooleanWithDefault(xml_InteractionNode.xtc_getAttribute("latency"),			getBoolean(_root._ext_strInteraction_latency));
			
			$str_SaveBookmark_type					= xml_BookmarkNode.xtc_getAttribute("type");
			
			switch ($str_SaveBookmark_type)
			{
				case BOOKMARK_SIMPLE:
				case BOOKMARK_FULL:
						// If we're running inside of Mamba the bookmark will be appended to the custom page data
					if (_root._SHELL_LOADED_)
					{
						var arr_SavedData:Array = _global.gShell.$getPageData().split(DELIMITER_MAIN);
						$str_BookmarkLocation = arr_SavedData[arr_SavedData.length - 1];
					}
						// Otherwise we can grab it directly from the location field
					else
						$str_BookmarkLocation = ExternalInterface.call("getSavedLocationData").toString();
					break;
					// Bookmark type should default to NONE
				default:
					$str_SaveBookmark_type	= BOOKMARK_NONE;
					$str_BookmarkLocation	= null;
					$str_BookmarkData		= null;
					break;
			}

			if (_root._SHELL_LOADED_)
			{
				str_DefaultFont = _global.gShell.$getDefaultFont();
				$mc_Interval.onEnterFrame = Delegate.create(this, checkLoad);
			}
			else
			{
				str_FontToLoad = xml_ConfigNode.xtc_getAttribute("font");

				if (str_FontToLoad == null)
					str_FontToLoad = "standard";
				else
				{
					str_FontToLoad = str_FontToLoad.toLowerCase();
					str_FontToLoad = str_FontToLoad.split(" ").join("_");
				}
				
					// Preload glyphs first so we display a percentage loaded
				$mc_Container.mc_Font = $mc_Container.createEmptyMovieClip("mc_Font", 777);
				$mc_Container.mc_Font.loadMovie("../fonts/glyphs_" + str_FontToLoad + ".swf");
				
				setDisplayLabel("_interface");
				$mc_Interval.onEnterFrame = Delegate.create(this, checkGlyphLoad);
			}
		}
	}
	
	private function setDisplayLabel( str_Label:String ):Void
	{
		$mc_Container.gotoAndStop(str_Label);
		$str_DisplayLabel = str_Label;
	}
	
	private function isValidData( str_Data:String ):Boolean
	{
		if (str_Data == null)
			return false;
		else
		{
			switch (str_Data.toLowerCase())
			{
				case "":
				case "null":
				case "undefined":
					return false;
				default:
					return true;
			}
		}
	}
	
	private function getBoolean( str_Value:String ):Boolean
	{
		str_Value = str_Value.toLowerCase();
		
		return str_Value == "true" || str_Value == "on" || str_Value == "yes";
	}
	
	private function getBooleanWithDefault( str_Value:String, b_Default:Boolean ):Boolean
	{
		str_Value = str_Value.toLowerCase();
		
		if (str_Value == null || str_Value == "" || str_Value == "default")
			return b_Default;
		else
			return getBoolean(str_Value);
	}
	
	private function checkGlyphLoad():Void
	{
		var n_PercentLoaded:Number = $mc_Container.mc_Font.getBytesLoaded() / $mc_Container.mc_Font.getBytesTotal();
		$mc_Container.mc_Preloader.mc_Fill._width = n_PercentLoaded * $mc_Container.mc_Preloader.mc_Background._width;
		
		if (n_PercentLoaded >= 1 && $mc_Container.mc_Font.getBytesTotal() > 4)
		{
				// This should be blanked out, because we just preloaded the glyphs
				// We still need to load the font file correctly
			str_DefaultFont = null;
			
			$mc_Container.mc_Font.loadMovie("../fonts/font_" + str_FontToLoad + ".swf");
			$mc_Interval.onEnterFrame = Delegate.create(this, checkLoad);
		}
	}
	
	private function checkLoad():Void
	{
			// If the swf is fully loaded, and there are no image displays still loading, and the font has loaded
		if ($mc_Container.getBytesLoaded() >= $mc_Container.getBytesTotal() && !ImageDisplay.isDisplayLoading && str_DefaultFont != null)
		{
			delete $mc_Interval.onEnterFrame;
			
					// If were inside of Mamba...
			if (_root._SHELL_LOADED_)
			{
				_visible = true;
				_global.gShell.$onPageLoaded(this);
			}
			
			var objIntroduction:Object	= getInterfaceNode("introduction", "text");
			var objResume:Object 		= getInterfaceNode("resume", "text");
			
				// If there is a valid bookmark...
			if (isValidData($str_BookmarkLocation))
			{
				$exam_Engine = new ExamEngine(this, $xml_Data, $str_BookmarkData);
				
					// If there is no resume prompt or the exam is complete we should jump right into the exam
				if (objResume == null || $exam_Engine.isComplete)
					startExam();
					// Otherwise we should show the resume prompt
				else
					displayResume();
			}
			else if (objIntroduction != null)
				displayIntro();
			else
				startExam();
		}
	}
	
	public function getInterfaceNode( str_Name:String, str_Category:String ):Object
	{
		if ($obj_InterfaceData[str_Category].children[str_Name] != null)
			return $obj_InterfaceData[str_Category].children[str_Name];
		else
			return $obj_InterfaceData[str_Name];
	}
	
	private function displayIntro():Void
	{
		$pane_ContentArea.destroy();
		setDisplayLabel("_intro");
	}
	
	private function displayResume():Void
	{
		$pane_ContentArea.destroy();
		setDisplayLabel("_resume");
	}
	
	private function introPaneLoaded( $pane_Target:ExpandablePane ):Void
	{
		expandablePaneLoaded($pane_Target);
		
		if (introTextDisplay != null && introTextDisplay.totalPages > 1)
		{
			introTextDisplay.onPageChange = Delegate.create(this, onIntroPageChange);
			alignToItem(beginButton, introTextDisplay.nextButton);
		}
		else
			beginButton.isEnabled = true;
	}
	
	private function onIntroPageChange():Void
	{
		beginButton.isEnabled = introTextDisplay.currentPage >= introTextDisplay.totalPages;
	}
	
	private function startExam():Void
	{
		$pane_ContentArea.destroy();
		Audio.stop();
		
		$edt_TimeStampCurrent = new ExamDate();
		
			// If the exam hasn't been take before, this is the official start time
		if ($edt_TimeStampStart == null)
			$edt_TimeStampStart = new ExamDate();
		
			// Check to see if it's time to reset the attempts
		if ($tsp_Limit != null && $str_TimeSpanBehavior == BEHAVIOR_RESET)
		{
			var tsp_Total:TimeSpan = $edt_TimeStampCurrent.subtract($edt_TimeStampStart);
			
			if (tsp_Total.isGreaterThan($tsp_Limit))
			{
				$edt_TimeStampStart = new ExamDate();
				$n_TotalAttempts = 0;
			}
		}
		
		$exam_Engine = new ExamEngine(this, $xml_Data, $str_BookmarkData);
		
		if (isValidData($str_BookmarkLocation))
			setDisplayLabel($str_BookmarkLocation);
		else if (overLimit)
			setDisplayLabel("_over_attempts");
		else if (overTimeSpan)
			setDisplayLabel("_over_time_span");
		else
			setDisplayLabel("_questions");
	}
	
	private function displayResults():Void
	{
		$pane_ContentArea.destroy();
		Audio.stop();
		
		setDisplayLabel(getResultsLabel());
	}
	
	private function getResultsLabel():String
	{
		return $exam_Engine.isPassed ? "_passed" : "_failed";
	}
	
	public function expandablePaneLoaded( $pane_Target:ExpandablePane ):Void
	{
		$pane_ContentArea = $pane_Target;
		$pane_ContentArea.expandTo($pane_ContentArea.originalWidth + n_CurrentStageWidth - n_OriginalStageWidth, $pane_ContentArea.originalHeight + n_CurrentStageHeight - n_OriginalStageHeight);
		$pane_ContentArea._visible = true;
		redraw();
	}
	
	private function questionPaneLoaded( $pane_Target:ExpandablePane ):Void
	{
		expandablePaneLoaded($pane_Target);
		
		$pane_ContentArea._visible	= false;
		$exam_Engine.questionArea	= $pane_ContentArea.content.mc_QuestionArea;
		
		if ($exam_Engine.timeLimit != null && Timer.inUse)
		{
			Timer.timeLimit = $exam_Engine.timeLimit;
			Timer.start(Delegate.create(this, timerComplete));
		}
		
		$exam_Engine.onAnswerChanged		= Delegate.create(this, onAnswerChanged);
		$exam_Engine.onDisplayChanged		= Delegate.create(this, questionDisplayChanged);
		$exam_Engine.onDisplayLoadStart		= Delegate.create(this, questionLoadStart);
		$exam_Engine.onDisplayLoadComplete	= Delegate.create(this, questionLoadComplete);
		$exam_Engine.displayNextQuestion();
		PageCount.update();
		
		submitButton.isEnabled = submitButton.allowIncompleteSubmit != SubmitButton.INCOMPLETE_NO;
		
		if ($exam_Engine.debug)
		{
			debugCorrectButton.swapDepths($mc_Container.getNextHighestDepth());
			debugIncorrectButton.swapDepths($mc_Container.getNextHighestDepth());
			
			debugCorrectButton.isEnabled = true;
			debugIncorrectButton.isEnabled = true;
		}
	}
	
	private function timerComplete():Void
	{
		$exam_Engine.submit();
		onExamSubmit(true);
		displayResults();
	}
	
	private function printContentArea():Void
	{
		var print_Question:PrintDocument = new PrintDocument();
		print_Question.printScrollPane($pane_ContentArea);
	}
	
	private function submitQuestion():Void
	{
		var arr_Unanswered:Array = $exam_Engine.unansweredQuestions;
		
		if (arr_Unanswered.length > 0 && submitButton.allowIncompleteSubmit != SubmitButton.INCOMPLETE_YES)
		{
			var str_Message:String = getInterfaceNode("incomplete_submit", "text").value;
			str_Message = str_Message.split("{#INCOMPLETE}").join(arr_Unanswered[0].index + 1);
			showMessage(str_Message);
			scrollTo(arr_Unanswered[0].y);
		}
		else
		{
			Audio.stop();
			
			submitButton.isEnabled = submitButton.allowIncompleteSubmit != SubmitButton.INCOMPLETE_NO;
			$exam_Engine.submit();
			
			if ($exam_Engine.isComplete && Timer.inUse)
				Timer.stop();
			
			if ($exam_Engine.feedback)
			{
				if ($exam_Engine.isQuestionComplete)
				{
					if ($exam_Engine.isComplete)
					{
							// Even though we are going to show the feedback before we move onto the results page
							// The exam is complete and we need to make sure that if we exit now we are bookmarked to the results page
						$str_DisplayLabel = getResultsLabel();
						
						finishButton.isEnabled = true;
					}
					else
						nextButton.isEnabled = true;
					
					submitButton.isEnabled = false;
					debugCorrectButton.isEnabled = false;
					debugIncorrectButton.isEnabled = false;
				}
			}
			else
			{
				submitButton.isEnabled = false;
				debugCorrectButton.isEnabled = false;
				debugIncorrectButton.isEnabled = false;
				
				if ($exam_Engine.isComplete)
					displayResults();
				else
					nextQuestion();
			}
			
			onExamSubmit($exam_Engine.isComplete);
		}
	}
	
	private function onExamSubmit( b_ExamComplete:Boolean ):Void
	{
		if (b_ExamComplete)
			$n_TotalAttempts ++;

			// If we're running inside of Mamba we need to save the data in the Mamba page node
		if (_root._SHELL_LOADED_)
		{
				// If the exam is complete then set it complete in Mamba
			if (b_ExamComplete)
			{
				_global.gShell.$onCourseExamComplete($mc_Container, $exam_Engine.isPassed, $exam_Engine.scorePercent);
				
				if ($exam_Engine.isPassed)
				{
					_global.gShell.$onPageComplete(this);
					_global.gShell.$setCourseData(_global.gShell.$formatCourseData());
					_global.gShell.$commitData();
				}
			}
			
				// If a bookmark should be saved update the page data with the results and bookmark
			if ($str_SaveBookmark_type != BOOKMARK_NONE)
			{
				_global.gShell.$setPageData(getResultData() + DELIMITER_MAIN + getLocationData());
				_global.gShell.$setCourseData(_global.gShell.$formatCourseData());
				_global.gShell.$commitData();
			}
				// If no bookmarking but the exam is complete only update the page data with the results
			else if (b_ExamComplete)
			{
				_global.gShell.$setPageData(getResultData());
				_global.gShell.$setCourseData(_global.gShell.$formatCourseData());
				_global.gShell.$commitData();
			}
			
			saveInteractionsToMamba();
		}
		else
		{
			if (ExternalInterface.available)
				ExternalInterface.call("onExamSubmit", b_ExamComplete);
		}
	}
	
	private function saveInteractionsToMamba():Void
	{
		var arr_Interactions:Array	= getInteractionData();
		
		if (arr_Interactions.length > 0)
		{
			for (var i:Number = 0; i < arr_Interactions.length; i ++)
				_global.gShell.$appendQuestionData(arr_Interactions[i]);
			
			_global.gShell.$commitData();
		}
	}
	
	private function exit():Void
	{
		if (!_root._SHELL_LOADED_)
		{
			if (ExternalInterface.available)
				ExternalInterface.call("exit");
		}
	}
	
	private function showMessage( str_Message:String ):PopupMessage
	{
		var mc_ClickBlocker:ClickBlocker = ClickBlocker($mc_Container.attachMovie("comp_ClickBlocker", "mc_ClickBlocker", DEPTH_BLOCKER));
		mc_ClickBlocker._x = 0;
		mc_ClickBlocker._y = 0;
		mc_ClickBlocker._width = Stage.width;
		mc_ClickBlocker._height = Stage.height;
		
		var mc_PopupMessage:PopupMessage = PopupMessage($mc_Container.attachMovie("comp_PopupMessage", "mc_PopupMessage", DEPTH_POPUP));
		mc_PopupMessage._x = $pane_ContentArea._x + ($pane_ContentArea.width - mc_PopupMessage._width) / 2;
		mc_PopupMessage._y = $pane_ContentArea._y + ($pane_ContentArea.height - mc_PopupMessage._height) / 2;
		mc_PopupMessage.text = str_Message;
		
		var fn_OnPopupClose:Function = function():Void
		{
			mc_ClickBlocker.removeMovieClip();
		}
		
		mc_PopupMessage.onClose = Delegate.create(this, fn_OnPopupClose);
		
		return mc_PopupMessage;
	}
	
	private function nextQuestion():Void
	{
		Audio.stop();
		
		$pane_ContentArea._visible = false;
		submitButton.isEnabled = submitButton.allowIncompleteSubmit != SubmitButton.INCOMPLETE_NO;
		nextButton.isEnabled = false;
		$exam_Engine.displayNextQuestion();
		scrollToTop();
		
		if ($exam_Engine.debug)
		{
			debugCorrectButton.isEnabled = true;
			debugIncorrectButton.isEnabled = true;
		}
		PageCount.update();
		
		if (!_root._SHELL_LOADED_)
		{
			if (ExternalInterface.available)
				ExternalInterface.call("onExamNextQuestion");
		}
	}
	
	private function questionDisplayChanged():Void
	{
		$pane_ContentArea.content.mc_QuestionArea.onExpand();
		redraw();
		$pane_ContentArea._visible = true;
	}
	
	private function questionLoadStart():Void
	{
		if (Timer.inUse)
			Timer.pause();
	}
	
	private function questionLoadComplete():Void
	{	
		if (Timer.inUse)
			Timer.resume();
	}
	
	private function selectCorrectAnswers():Void
	{
		$exam_Engine.selectCorrectAnswers();
	}
	
	private function selectIncorrectAnswers():Void
	{
		$exam_Engine.selectIncorrectAnswers();
	}
	
	private function onAnswerChanged( b_FullyAnswered:Boolean ):Void
	{
		submitButton.isEnabled = b_FullyAnswered || submitButton.allowIncompleteSubmit != SubmitButton.INCOMPLETE_NO;
		
			// Make sure the scroll pane re-evaluates it's size, the submit button may be larger or smaller now
		if (submitButton._parent == $pane_ContentArea.content)
			redraw();
	}
	
	public function scrollToTop():Void
	{
		scrollTo(0);
	}
	
	public function scrollTo( n_Y:Number ):Void
	{
		if (scrollEnabled)
			$pane_ContentArea.vPosition = n_Y;
	}
	
	public function redraw():Void
	{
		$pane_ContentArea.invalidate();
	}
	
	private function onMouseWheel( n_Delta:Number ):Void
	{
		if (scrollEnabled)
			$pane_ContentArea.vPosition -= n_Delta * 5;
	}
	
	public function formatText( str_Text:String ):String
	{
		if ($exam_Engine != null)
			str_Text = $exam_Engine.replaceVariableTokens(str_Text);
		
		str_Text = str_Text.split("{#ATTEMPTSREMAINING}").join(attemptsRemaining.toString());
		
		return str_Text;
	}
}