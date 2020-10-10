import mx.utils.*;
import flash.external.*;

class Question extends DynamicMC
{		
	public static var TYPE_MC:String		= "MC";
	public static var TYPE_TF:String		= "TRUE_FALSE";
	public static var TYPE_FILL_IN:String	= "FILL_IN";
	public static var TYPE_LIKERT:String	= "LIKERT";
	public static var TYPE_MATCHING:String	= "MATCHING";
	
	private static var $n_TotalQuestions:Number	= 0;
	
	private var $n_Index:Number;
	private var $n_GlobalIndex:Number;
	private var $n_GraphicSpacing;
	private var $n_DirectionSpacing;
	private var $xml_Data:_XMLNode;
	private var $fn_Loaded:Function;
	private var $fn_Change:Function;
	private var $mc_Stem:TextBox;
	private var $mc_Label:TextBox;
	private var $mc_Directions:TextBox;
	private var $n_PointValue:Number;
	private var $n_AttemptLimit:Number;
	private var $n_AttemptsUsed:Number;
	private var $b_Correct:Boolean;
	private var $b_Numbered:Boolean;
	private var $b_Loaded:Boolean;
	private var $n_StemX:Number;
	private var $n_StemWidth:Number;
	private var $dt_StartTime:Date;
	private var $dt_EndTime:Date;
	private var $qp_Engine:QuestionPool;
	private var $img_Stem:Image;
	private var $str_Response:String;
	
	public static function reset():Void
	{
		$n_TotalQuestions = 0;
	}
	
	public function get feedback():Boolean
	{
		return false;
	}
	
	public function get hasExternalMedia():Boolean
	{
		return $img_Stem != null;
	}
	
	public function get index():Number
	{
		return $n_Index;
	}
	
	public function get globalIndex():Number
	{
		return $n_GlobalIndex;
	}
	
	public function set numbered( b_Numbered:Boolean ):Void
	{
		$b_Numbered = b_Numbered;
	}
	
	public function get numbered():Boolean
	{
		return $b_Numbered;
	}
	
	public function get SCORMType():String
	{
		return "";
	}
	
	public function get SCORMResult():String
	{
		return $b_Correct ? "correct" : "wrong";
	}
	
	public function get startTime():String
	{
		var str_Hours:String	= Timer.formatNumber($dt_StartTime.getHours(), 2);
		var str_Minutes:String	= Timer.formatNumber($dt_StartTime.getMinutes(), 2);
		var str_Seconds:String	= Timer.formatNumber($dt_StartTime.getSeconds(), 2);
		
			// SCORM format for time stamp is "HH:MM:SS"
		return str_Hours + ":" + str_Minutes + ":" + str_Seconds;
	}
	
	public function get latency():String
	{
		var n_Milliseconds:Number = $dt_EndTime.getTime() - $dt_StartTime.getTime();
		
		var n_Hours:Number = Math.floor(n_Milliseconds / 3600000);
		n_Milliseconds %= 3600000;
		
		var n_Minutes:Number = Math.floor(n_Milliseconds / 60000);
		n_Milliseconds %= 60000;
		
		var n_Seconds:Number = Math.floor(n_Milliseconds / 1000);
		n_Milliseconds %= 1000;
		
		var str_Hours:String	= Timer.formatNumber(n_Hours, 4);
		var str_Minutes:String	= Timer.formatNumber(n_Minutes, 2);
		var str_Seconds:String	= Timer.formatNumber(n_Seconds, 2);
		
			// SCORM format for time duration is "HHHH:MM:SS"
		return str_Hours + ":" + str_Minutes + ":" + str_Seconds;
	}
	
	public function get id():String
	{
		return $xml_Data.xtc_getAttribute("id");
	}
	
	public function get objective():String
	{
		return $xml_Data.xtc_getAttribute("objective");
	}
	
	public function get stem():String
	{
		return $xml_Data.xtc_getValue("stem");
	}
	
	public function get currentResponse():String
	{
		return null;
	}
	
	public function get response():String
	{
			// Check to see if there is a more recent response, otherwise use what is stored
		var str_CurrentResponse:String = currentResponse;
//flash.external.ExternalInterface.call("alert", "get response:" + str_CurrentResponse + "-" + $str_Response);
		if (str_CurrentResponse != null && str_CurrentResponse != "")
			$str_Response = str_CurrentResponse;
			
		return $str_Response;
	}
	
	public function get correctResponse():String
	{
		return "";
	}
	
	public function get isCorrect():Boolean
	{
		return $b_Correct;
	}
	
	public function get answerStartY():Number
	{
		return $mc_Directions._y + $mc_Directions._height + $n_DirectionSpacing;
	}
	
	public function set onLoaded( fn_Loaded:Function ):Void
	{
		$fn_Loaded = fn_Loaded;
	}
	
	public function set onChange( fn_Change:Function ):Void
	{
		$fn_Change = fn_Change;
	}
	
	public function set xml( xml_Content:_XMLNode ):Void
	{
		$xml_Data = xml_Content;
	}
	
	public function get xml():_XMLNode
	{
		return $xml_Data;
	}
	
	public function get pointValue():Number
	{
		return $n_PointValue;
	}
	
	public function get isAnswered():Boolean
	{
		return true;
	}
	
	public function get isComplete():Boolean
	{
		return true;
	}
	
	public function get attemptsRemaining():Number
	{
		if ($n_AttemptLimit == ExamEngine.UNLIMITED)
			return 1;
			
		return $n_AttemptLimit - $n_AttemptsUsed;
	}
	
	public function get questionPool():QuestionPool
	{
		return $qp_Engine;
	}
	
	public function get examEngine():ExamEngine
	{
		return $qp_Engine.examEngine;
	}
	
	public function get questionArea():QuestionArea
	{
		return $qp_Engine.examEngine.questionArea;
	}
	
	public function Question( qp_Engine:QuestionPool, xml_Data:_XMLNode, xml_Config:_XMLNode, str_Response:String )
	{
		$n_Index = Question.$n_TotalQuestions;
		Question.$n_TotalQuestions ++;
		
		$qp_Engine		= qp_Engine;
		$xml_Data		= xml_Data;
		$str_Response	= str_Response;
		$n_AttemptsUsed = 0;
		
			// Store global index, (note: this attribute is dynamically added by the exam engin)
		$n_GlobalIndex	= $xml_Data.xtc_getNumericAttribute("global_index");
		$n_AttemptLimit	= $xml_Data.xtc_getNumericAttribute("attempts");
		$n_PointValue	= $xml_Data.xtc_getNumericAttribute("point_value");
		
		if ($n_AttemptLimit == null)
			$n_AttemptLimit = qp_Engine.questionAttempts;
		else if (isNaN($n_AttemptLimit))
			$n_AttemptLimit = ExamEngine.UNLIMITED;
		
			// If the Exam is set to not have feedback, there can only be one attempt
		if (!examEngine.feedbackOn)
			$n_AttemptLimit = 1;
		
		if ($n_PointValue == null)
			$n_PointValue = 1;
		
		$n_GraphicSpacing	= $xml_Data.xtc_getNumericAttribute("spacing", "graphic");
		$n_DirectionSpacing = $xml_Data.xtc_getNumericAttribute("spacing", "directions");
		
		if ($n_GraphicSpacing == null)
			$n_GraphicSpacing = 0;
		
		if ($n_DirectionSpacing == null)
			$n_DirectionSpacing = 0;
			
		if (questionArea.graphicSpacing != null)
			$n_GraphicSpacing += questionArea.graphicSpacing;
			
		if (questionArea.directionSpacing != null)
			$n_DirectionSpacing += questionArea.directionSpacing;
	}
	
	public function display( mc_ContentArea:MovieClip ):Void
	{
		super.display(mc_ContentArea);
		
		var url_Image:String = $xml_Data.xtc_getValue("graphic");
		
		if (url_Image == null)
			build();
		else
		{
			$img_Stem = new Image();
			$img_Stem.onLoad	= Delegate.create(this, onImageLoaded);
			$img_Stem.onError	= Delegate.create(this, onImageError);
			$img_Stem.display($mc_Display, url_Image);
		}
	}
	
	public function getBytesLoaded():Number
	{
		return $img_Stem.bytesLoaded;
	}
	
	public function getBytesTotal():Number
	{
		return $img_Stem.bytesTotal;
	}
	
	private function onImageLoaded():Void
	{
		build();
	}
	
	private function onImageError():Void
	{
		build();
	}
	
	private function build():Void
	{
		if ($b_Numbered)
		{
			$mc_Label		= TextBox($mc_Display.attachMovie("comp_QuestionNumber", "mc_Label", $mc_Display.getNextHighestDepth(), {$str_Style: "QUESTION_NUMBER"}));
			$mc_Label._x	= 0;
			$mc_Label._y	= 0;
			$mc_Label.text	= ($n_Index + 1) + ".";
			
				// Take into account the full width of the MovieClip
			$n_StemX = $mc_Label._width;
			
			if ($n_StemX == null)
				$n_StemX = 0;
		}
		else
			$n_StemX = 0;
		
		$n_StemWidth = $n_Width - $n_StemX;
		
		if ($img_Stem != null && $img_Stem.isLoaded)
		{
			$n_StemWidth -= $n_GraphicSpacing;
			
			if ($img_Stem.width > $n_StemWidth / 2)
			{
				$img_Stem.width		= $n_StemWidth / 2;
				$img_Stem.onRelease	= Delegate.create(this, enlargeImage);
			}
			
			$img_Stem.scaleY = $img_Stem.scaleX;
			
			$n_StemWidth -= $img_Stem.width;
			
			$img_Stem.x = $n_StemX + $n_StemWidth + $n_GraphicSpacing;
		}
		
		var strStemStyle:String = $xml_Data.xtc_getAttribute("style", "stem");
		
		if ((strStemStyle == null) || (strStemStyle == ""))
			strStemStyle = "STEM";
		
		$mc_Stem		= TextBox($mc_Display.attachMovie("comp_Stem", "mc_Stem", $mc_Display.getNextHighestDepth(), {$str_Style: strStemStyle}));
		$mc_Stem._x		= $n_StemX;
		$mc_Stem._y		= 0;
		$mc_Stem.width	= $n_StemWidth;
		$mc_Stem.text	= $xml_Data.xtc_getValue("stem");
		
		if ($xml_Data.xtc_getAttribute("audio", "stem") != null)
			Audio.play($xml_Data.xtc_getAttribute("audio", "stem"));
		
		var strStemDirections:String = $xml_Data.xtc_getAttribute("style", "directions");
		
		if ((strStemDirections == null) || (strStemDirections == ""))
			strStemDirections = "DIRECTIONS";
		
		$mc_Directions			= TextBox($mc_Display.attachMovie("comp_Directions", "mc_Directions", $mc_Display.getNextHighestDepth(), {$str_Style: strStemDirections}));
		$mc_Directions._x		= $n_StemX;
		$mc_Directions._y		= $mc_Stem._y + $mc_Stem._height + $n_DirectionSpacing;
		$mc_Directions.width	= $n_StemWidth;
		$mc_Directions.text		= $xml_Data.xtc_getValue("directions");
		
		$dt_StartTime = new Date();
	}
	
	private function enlargeImage():Void
	{
		var strImageURL:String = $img_Stem.imageURL;

			// If this image is using a relative path, it shouldn't go up one level
			// This is because the flash movie is loading the image from the /flash folder
			// However the index file will load the image relatvie to the root of the exam
			// Changes ../ to ./
		if (strImageURL.substr(0, 2) == "..")
			strImageURL = strImageURL.substr(1);

		ExternalInterface.call("openImage", strImageURL, $img_Stem.fullWidth, $img_Stem.fullHeight);
	}
	
	public function showPreviousResults():Void
	{
		
	}
	
	private function loadComplete():Void
	{
		var setLoadComplete:Function = function():Void
		{
			$b_Loaded = true;
			$fn_Loaded();
			$fn_Loaded = null;
		}
		
			// NOTE: This must be in a setTimeout to avoid an ActionScript Timeout
		_global.setTimeout(Delegate.create(this, setLoadComplete), 1);
	}
	
	public function grade():Number
	{
		$dt_EndTime = new Date();
		$n_AttemptsUsed ++;
		return 0;
	}
	
	public function selectCorrectAnswers():Void
	{

	}
	
	public function selectIncorrectAnswers():Void
	{

	}
	
	public static function createQuestion( qp_Engine:QuestionPool, xml_Data:_XMLNode, xml_Config:_XMLNode, str_Response:String ):Question
	{		
		switch(xml_Data.xtc_getValue("type_settings").toUpperCase())
		{
			case TYPE_MC:
				return new QuestionMC(qp_Engine, xml_Data, xml_Config, str_Response);
			case TYPE_TF:
				return new QuestionTF(qp_Engine, xml_Data, xml_Config, str_Response);
			case TYPE_FILL_IN:
				return new QuestionFillIn(qp_Engine, xml_Data, xml_Config, str_Response);
			case TYPE_LIKERT:
				return new QuestionLikert(qp_Engine, xml_Data, xml_Config, str_Response);
			case TYPE_MATCHING:
				return new QuestionMatching(qp_Engine, xml_Data, xml_Config, str_Response);
			default:
				return new Question(qp_Engine, xml_Data, xml_Config, str_Response);
		}
	}
	
	public static function tintClip( mc_Clip:Object, obj_Color:Object, n_Alpha:Number ):Color
	{
		var obj_Transformation:Object	= new Object();
		var n_Percent:Number			= 100 - n_Alpha;
		var n_Ratio:Number				= n_Alpha / 100;
		var obj_RGB:Object				= valueToRGB(obj_Color);
		
		obj_Transformation.ra = 
		obj_Transformation.ga = 
		obj_Transformation.ba = n_Percent;
		
		obj_Transformation.rb = obj_RGB.r * n_Ratio;
		obj_Transformation.gb = obj_RGB.g * n_Ratio;
		obj_Transformation.bb = obj_RGB.b * n_Ratio;
		
		mc_Clip._tint = new Color(mc_Clip);
		mc_Clip._tint.setTransform(obj_Transformation);
		
		return mc_Clip._tint;
	}
	
	private static function valueToRGB( obj_Color:Object ):Object
	{
		var obj_RGB:Object = new Object();
		var str_Hex:String;

		if (obj_Color instanceof Number)
		{
			str_Hex = obj_Color.toString(16);
			
			while (str_Hex.length < 6)
				str_Hex = "0" + str_Hex;
		}
		else
		{
			str_Hex = obj_Color.split("#")[1];
		}

		obj_RGB.r = parseInt(str_Hex.substring(0,2),16);
		obj_RGB.g = parseInt(str_Hex.substring(2,4),16);
		obj_RGB.b = parseInt(str_Hex.substring(4,6),16);
		
		return obj_RGB;
	}
}