class QuestionMC extends QuestionWithFeedback
{		
	private var $arr_OrderedOptions:Array;
	private var $arr_Options:Array;
	private var $b_MultiSelect:Boolean;
	private var $b_Complete:Boolean;
	private var $arr_OptionKeys:Array;
	
	public function get SCORMType():String
	{
		return "choice";
	}
	
	public function get currentResponse():String
	{
		var str_Response:String = "";
		
		for (var i:Number = 0; i < $arr_OrderedOptions.length; i ++)
		{
			if ($arr_OrderedOptions[i].isSelected)
			{
				if (str_Response != "")
					str_Response += ",";
					
				str_Response += String.fromCharCode(97 + $arr_OrderedOptions[i].index);
			}
		}
		
		return str_Response;
	}
	
	public function get correctResponse():String
	{
		var xml_Options	:_XMLNode	= $xml_Data.xtc_findNode("foils");
		var arr_Options	:Array	  	= xml_Options.xtc_findChildren("foil");
		var str_Response:String		= "";
		
		for (var i:Number = 0; i < arr_Options.length; i ++)
		{
			if (arr_Options[i].xtc_getBooleanAttribute("correct"))
			{
				if (str_Response != "")
					str_Response += ",";
					
				str_Response += String.fromCharCode(97 + i);
			}
		}

		return str_Response;
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
	
	public function get randomizeOptions():Boolean
	{
		return $xml_Data.xtc_getBooleanAttribute("random", "foils");
	}
	
	public function QuestionMC( qp_Engine:QuestionPool, xml_Data:_XMLNode, xml_Config:_XMLNode, str_Response:String )
	{
		super(qp_Engine, xml_Data, xml_Config, str_Response);
	}
	
	private function build( mc_ContentArea:MovieClip ):Void
	{
		super.build(mc_ContentArea);
		
		var xml_Options:_XMLNode	= $xml_Data.xtc_findNode("foils");
		var arr_Options:Array		= xml_Options.xtc_findChildren("foil");
		var n_OptionSpacing:Number	= $xml_Data.xtc_getNumericAttribute("spacing", "foils");

		if (n_OptionSpacing == null)
			n_OptionSpacing = 0;
		
		if (randomizeOptions)
			$arr_OptionKeys = ExamEngine.randomizeArray(arr_Options);
		
		if (questionArea.verticalOptionSpacing != null)
			n_OptionSpacing += questionArea.verticalOptionSpacing;

		var n_Correct:Number	= 0;
		var n_CurrentY:Number	= answerStartY;
		$arr_Options			= new Array();
		$arr_OrderedOptions		= new Array();
		
		for (var i:Number = 0; i < arr_Options.length; i ++)
		{
			if (arr_Options[i].xtc_getBooleanAttribute("correct"))
				n_Correct ++;
		}
		
		$b_MultiSelect = n_Correct > 1;
		
		for (var i:Number = 0; i < arr_Options.length; i ++)
		{
			var n_Index:Number		= $arr_OptionKeys == null ? i : $arr_OptionKeys[i].index;
			
			var strOptionStyle:String = arr_Options[i].xtc_getAttribute("style");
			
			if ((strOptionStyle == null) || (strOptionStyle == ""))
				strOptionStyle = "OPTION";
			
			var mc_Option:Option	= Option($mc_Display.attachMovie("comp_Option", "mc_Option" + i, $mc_Display.getNextHighestDepth(), {$str_Style: strOptionStyle}));
			mc_Option._x			= $n_StemX;
			mc_Option._y			= n_CurrentY;
			mc_Option.width			= $n_StemWidth;
			mc_Option.xml			= arr_Options[i];
			mc_Option.text			= arr_Options[i].xtc_getValue("text");
			mc_Option.index			= n_Index;
			mc_Option.feedback		= arr_Options[i].xtc_findChild("feedback");
			mc_Option.isCorrect		= arr_Options[i].xtc_getBooleanAttribute("correct");
			mc_Option.isRadio		= !$b_MultiSelect;
			mc_Option.question		= this;
			mc_Option.onRelease		= onOptionClick;
			
			n_CurrentY += mc_Option._height + n_OptionSpacing;
			
			$arr_Options.push(mc_Option);
			$arr_OrderedOptions[n_Index] = mc_Option;
		}
		
		loadComplete();
	}
	
	public function destroy():Void
	{
		super.destroy();
		$arr_Options		= null;
		$arr_OrderedOptions	= null;
		$arr_OptionKeys		= null;
	}
	
	public function grade():Number
	{
		var str_Response		:String	= response;
		var str_Correct			:String	= correctResponse;
		var n_Points			:Number	= super.grade();
		var xml_Feedback		:_XMLNode;

		$b_Correct	= str_Response == str_Correct;
		$b_Complete = $b_Correct || attemptsRemaining <= 0;

		if ($b_Complete)
		{
			enabled = false;
			
			for (var i:Number = 0; i < $arr_Options.length; i ++)
				$arr_Options[i].showGradeMark();
				
			if ($b_Correct)
			{
				n_Points += pointValue;
				xml_Feedback = $xml_FeedbackCorrect;
			}
			else
				xml_Feedback = $xml_FeedbackIncorrect;
		}
		else
			xml_Feedback = $xml_FeedbackInitialIncorrect;
		
			// If this is single select and the selected option has feedback, it should be used
		if (!$b_MultiSelect)
		{
			var mc_SelectedOption:Option;
			
			for (var i:Number = 0; i < $arr_Options.length; i ++)
			{
				if ($arr_Options[i].isSelected)
					mc_SelectedOption = $arr_Options[i];
			}
			
			if (mc_SelectedOption.feedback != null)
				xml_Feedback = mc_SelectedOption.feedback;
		}
		
		var mc_LastOption:MovieClip = $arr_Options[$arr_Options.length - 1];
		showFeedback(xml_Feedback, mc_LastOption._y + mc_LastOption._height);
		
		return n_Points;
	}
	
	private function onOptionClick():Void
	{
		var opt_Item:Option = Option(this);
		var qst_This:QuestionMC = QuestionMC(opt_Item.question);
		
		if (qst_This.$b_MultiSelect)
			opt_Item.isSelected = !opt_Item.isSelected;
		else
		{
			var arr_Options:Array = qst_This.$arr_Options;
			
			for (var i:Number = 0; i < arr_Options.length; i ++)
				arr_Options[i].isSelected = false;
			
			opt_Item.isSelected = true;
		}
		
		qst_This.$fn_Change();
	}
	
	public function selectCorrectAnswers():Void
	{
		for (var i:Number = 0; i < $arr_Options.length; i ++)
		{
			if ($arr_Options[i].isCorrect != $arr_Options[i].isSelected)
				$arr_Options[i].onRelease();
		}
	}
	
	public function selectIncorrectAnswers():Void
	{
		for (var i:Number = 0; i < $arr_Options.length; i ++)
		{
			if ($arr_Options[i].isCorrect == $arr_Options[i].isSelected)
				$arr_Options[i].onRelease();
		}
	}
}