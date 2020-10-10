class QuestionWithFeedback extends Question
{		
	private var $mc_Feedback:TextBox;
	private var $n_FeedbackSpacing:Number;
	
	private var $xml_FeedbackCorrect:			_XMLNode;
	private var $xml_FeedbackInitialIncorrect:	_XMLNode;
	private var $xml_FeedbackIncorrect:			_XMLNode;
	
	public function get feedback():Boolean
	{
		return true;
	}
	
	public function QuestionWithFeedback( qp_Engine:QuestionPool, xml_Data:_XMLNode, xml_Config:_XMLNode, str_Response:String )
	{
		super(qp_Engine, xml_Data, xml_Config, str_Response);
		
		var xml_Feedback:_XMLNode = $xml_Data.xtc_findChild("feedback");
		
		$xml_FeedbackCorrect			= xml_Feedback.xtc_findChild("correct");
		$xml_FeedbackInitialIncorrect	= xml_Feedback.xtc_findChild("initial_incorrect");
		$xml_FeedbackIncorrect			= xml_Feedback.xtc_findChild("final_incorrect");
		
		$n_FeedbackSpacing = xml_Feedback.xtc_getNumericAttribute("spacing");
		
		if ($n_FeedbackSpacing == null)
			$n_FeedbackSpacing = 0;
			
		if (questionArea.feedbackSpacing != null)
			$n_FeedbackSpacing += questionArea.feedbackSpacing;
	}
	
	private function showFeedback( xml_Feedback:_XMLNode, n_Y:Number ):Void
	{
		$mc_Feedback.removeMovieClip();
		
		if (xml_Feedback != null)
		{
			var strFeedbackStyle:String = xml_Feedback.xtc_getAttribute("style");
			
			//if ((strFeedbackStyle == null) || (strFeedbackStyle == ""))
//				strFeedbackStyle = isCorrect ? "CORRECT_FEEDBACK" : "INCORRECT_FEEDBACK";
			
			var str_Feedback:String = xml_Feedback.xtc_getValue();
			
			if (str_Feedback == null)
				str_Feedback = "";
			
			if (isCorrect)
				$mc_Feedback	= TextBox($mc_Display.attachMovie("comp_CorrectFeedback", "mc_Feedback", $mc_Display.getNextHighestDepth(), {$str_Style: strFeedbackStyle}));
			else
				$mc_Feedback	= TextBox($mc_Display.attachMovie("comp_IncorrectFeedback", "mc_Feedback", $mc_Display.getNextHighestDepth(), {$str_Style: strFeedbackStyle}));
				
			if ($mc_Feedback == null)
				$mc_Feedback	= TextBox($mc_Display.attachMovie("comp_Feedback", "mc_Feedback", $mc_Display.getNextHighestDepth(), {$str_Style: strFeedbackStyle}));
				
			$mc_Feedback._x		= $n_StemX;
			$mc_Feedback._y		= n_Y + $n_FeedbackSpacing;
			$mc_Feedback.width	= $n_StemWidth;
			$mc_Feedback.text	= str_Feedback;
			
			if (isCorrect)
				_global.gShell.$findTextStyle("CORRECT_FEEDBACK").xtc_applyPrimitiveStyle($mc_Feedback.xtc_getBaseObject());
			else
				_global.gShell.$findTextStyle("INCORRECT_FEEDBACK").xtc_applyPrimitiveStyle($mc_Feedback.xtc_getBaseObject());
			
			if (xml_Feedback.xtc_getAttribute("audio") != null)
				Audio.play(xml_Feedback.xtc_getAttribute("audio"));
		}
	}
}