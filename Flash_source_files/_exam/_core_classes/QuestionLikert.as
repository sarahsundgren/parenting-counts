class QuestionLikert extends Question
{		
	private var $arr_Options:Array;
	private var $b_Complete:Boolean;
	private var $mc_Line:MovieClip
	
	public function get SCORMType():String
	{
		return "likert";
	}
	
	public function get currentResponse():String
	{
		var str_Response:String = "";
		
		for (var i:Number = 0; i < $arr_Options.length; i ++)
		{
			if ($arr_Options[i].isSelected)
			{
				str_Response = i.toString();
				break;
			}
		}

		return str_Response;
	}
	
	public function get correctResponse():String
	{
		return "";
	}
	
	public function set enabled( b_Enabled:Boolean ):Void
	{
		super.enabled = b_Enabled;
		
		for (var i:Number = 0; i < $arr_Options.length; i ++)
			$arr_Options[i].enabled = b_Enabled;
	}
	
	public function get isAnswered():Boolean
	{
		for (var i:Number = 0; i < $arr_Options.length; i ++)
		{
			if ($arr_Options[i].isSelected)
				return true;
		}
		
		return false;
	}
	
	public function get isComplete():Boolean
	{
		return $b_Complete;
	}
	
	public function QuestionLikert( qp_Engine:QuestionPool, xml_Data:_XMLNode, xml_Config:_XMLNode, str_Response:String )
	{
		super(qp_Engine, xml_Data, xml_Config, str_Response);
	}
	
	private function build( mc_ContentArea:MovieClip ):Void
	{
		super.build(mc_ContentArea);
		
		var xml_Options:_XMLNode	= $xml_Data.xtc_findNode("options");
		var arr_Options:Array		= xml_Options.xtc_findChildren("option");
		var n_OptionSpacing:Number	= $xml_Data.xtc_getNumericAttribute("spacing", "options");

		if (n_OptionSpacing == null)
			n_OptionSpacing = 0;
		
		if (questionArea.verticalOptionSpacing != null)
			n_OptionSpacing += questionArea.horizontalOptionSpacing;

		var n_CurrentX:Number	= $n_StemX;
		$arr_Options			= new Array();
		
		var n_OptionWidth:Number	= ($n_StemWidth - n_OptionSpacing * (arr_Options.length - 1)) / arr_Options.length;
		$mc_Line					= $mc_Display.createEmptyMovieClip("mc_Line", $mc_Display.getNextHighestDepth());
		
		for (var i:Number = 0; i < arr_Options.length; i ++)
		{
			var strLikertStyle:String = arr_Options[i].xtc_getAttribute("style");
			
			if ((strLikertStyle == null) || (strLikertStyle == ""))
				strLikertStyle = "OPTION_LIKERT";
			
			var mc_Option:Option	= Option($mc_Display.attachMovie("comp_OptionLikert", "mc_Option" + i, $mc_Display.getNextHighestDepth(), {$str_Style: strLikertStyle}));
			mc_Option._x			= n_CurrentX;
			mc_Option._y			= answerStartY;
			mc_Option.width			= n_OptionWidth;
			mc_Option.xml			= arr_Options[i];
			mc_Option.text			= arr_Options[i].xtc_getValue();
			mc_Option.index			= i;
			mc_Option.isRadio		= true;
			mc_Option.question		= this;
			mc_Option.onRelease		= onOptionClick;
			
			n_CurrentX += mc_Option.width + n_OptionSpacing;
			
			$arr_Options.push(mc_Option);
		}
		
		var n_LastOption:Number = arr_Options.length - 1;
		var n_LineStartX:Number = $arr_Options[0]._x + $arr_Options[0].mc_Selection._x + $arr_Options[0].mc_Selection._width / 2;
		var n_LineStartY:Number = $arr_Options[0]._y + $arr_Options[0].mc_Selection._y + $arr_Options[0].mc_Selection._height / 2;
		var n_LineEndX:Number	= $arr_Options[n_LastOption]._x + $arr_Options[n_LastOption].mc_Selection._x + $arr_Options[n_LastOption].mc_Selection._width / 2;
		var n_LineEndY:Number	= $arr_Options[n_LastOption]._y + $arr_Options[n_LastOption].mc_Selection._y + $arr_Options[n_LastOption].mc_Selection._height / 2;
		
		$mc_Line.lineStyle(2, 0x000000, 100);
		$mc_Line.moveTo(n_LineStartX, n_LineStartY);
		$mc_Line.lineTo(n_LineEndX, n_LineEndY);
		
		loadComplete();
	}
	
	public function destroy():Void
	{
		super.destroy();
		$arr_Options	= null;
		$mc_Line		= null;
	}
	
	public function grade():Number
	{
		var str_Response:String	= response;
		var n_Points:Number		= super.grade();
		
		if (str_Response != null)
		{
			$b_Correct	= true;
			$b_Complete	= true;
			enabled		= false;
			n_Points	+= pointValue;
		}
		
		return n_Points;
	}
	
	private function onOptionClick():Void
	{
		var opt_Item:Option = Option(this);
		var qst_This:QuestionLikert = QuestionLikert(opt_Item.question);
		
		var arr_Options:Array = qst_This.$arr_Options;

		for (var i:Number = 0; i < arr_Options.length; i ++)
			arr_Options[i].isSelected = false;
		
		opt_Item.isSelected = true;
		qst_This.$fn_Change();
	}
	
	public function selectCorrectAnswers():Void
	{
		$arr_Options[0].onRelease();
	}
	
	public function selectIncorrectAnswers():Void
	{
		$arr_Options[0].onRelease();
	}
}