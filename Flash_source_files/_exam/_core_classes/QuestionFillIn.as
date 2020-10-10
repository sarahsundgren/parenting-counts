import mx.utils.*;

class QuestionFillIn extends QuestionWithFeedback
{
	private var $b_Complete:Boolean;
	private var $b_CaseSensitive:Boolean;
	private var $b_MultiLine:Boolean;
	private var $arr_Answers:Array;
	private var $mc_Input:InputBox;
	
	public function get SCORMType():String
	{
		return "fill-in";
	}
	
	public function get currentResponse():String
	{
		return $mc_Input.text;
	}
	
	public function get correctResponse():String
	{
		var str_Response:String = "";
		
		for (var i:Number = 0; i < $arr_Answers.length; i ++)
		{
			if ($arr_Answers[i].isCorrect)
			{
				str_Response = $arr_Answers[i].text;
				break;
			}
		}
		
		return str_Response;
	}
	
	public function set enabled( b_Enabled:Boolean ):Void
	{
		super.enabled = b_Enabled;
		
		$mc_Input.enabled = b_Enabled;
	}
	
	public function get isAnswered():Boolean
	{
		return $mc_Input.text != "";
	}
	
	public function get isComplete():Boolean
	{
		return $b_Complete;
	}
	
	public function QuestionFillIn( qp_Engine:QuestionPool, xml_Data:_XMLNode, xml_Config:_XMLNode, str_Response:String )
	{
		super(qp_Engine, xml_Data, xml_Config, str_Response);
		
		$b_CaseSensitive	= xml_Data.xtc_getBooleanAttribute("case_sensitive", "type_settings");
		$b_MultiLine		= xml_Data.xtc_getBooleanAttribute("multiline", "type_settings");

			// If no attribute is defined, multiline should default to true
		if (xml_Data.xtc_getAttribute("multiline", "type_settings") == null)
			$b_MultiLine = true;

		var xml_Answers:_XMLNode	= $xml_Data.xtc_findNode("answers");
		var arr_Answers:Array		= xml_Answers.xtc_findChildren("answer");
		
		$arr_Answers = new Array();
		
		for (var i:Number = 0; i < arr_Answers.length; i ++)
			$arr_Answers.push(new Answer(this, arr_Answers[i]));
	}
	
	private function build( mc_ContentArea:MovieClip ):Void
	{
		super.build(mc_ContentArea);
		
		$mc_Input			= InputBox($mc_Display.attachMovie("comp_Input", "mc_Input", $mc_Display.getNextHighestDepth(), {$str_Style: "INPUT"}));
		$mc_Input._x		= $n_StemX;
		$mc_Input._y		= answerStartY;
		$mc_Input.width		= $n_StemWidth;
		$mc_Input.onChange	= Delegate.create(this, onInputChanged);
		$mc_Input.restrict	= "^" + ExamInterface.DELIMITER_MAIN + ExamInterface.DELIMITER_SUB;
		$mc_Input.multiline = $b_MultiLine;

		loadComplete();
	}
	
	public function destroy():Void
	{
		super.destroy();
		$mc_Input = null;
	}
	
	private function onInputChanged():Void
	{
		$fn_Change();
	}
	
	public function grade():Number
	{
		var str_Response:String	= response;
		var n_Points:Number		= super.grade();
		var obj_Match:Answer;
		var xml_Feedback:_XMLNode;

		for (var i:Number = 0; i < $arr_Answers.length; i ++)
		{
			if ($arr_Answers[i].checkMatch(str_Response, $b_CaseSensitive))
			{
				obj_Match = $arr_Answers[i];
				break;
			}
		}
		
		if (obj_Match != null)
			$b_Correct = obj_Match.grade();
		
		$b_Complete = $b_Correct || attemptsRemaining <= 0;
		
		if ($b_Complete)
		{
			enabled = false;
				
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
		
			// If there is feedback for this answer, it should be used
		if (obj_Match.feedback != null)
			xml_Feedback = obj_Match.feedback;
		
		showFeedback(xml_Feedback, $mc_Input._y + $mc_Input._height);

		return n_Points;
	}
	
	public function selectCorrectAnswers():Void
	{
		for (var i:Number = 0; i < $arr_Answers.length; i ++)
		{
			if ($arr_Answers[i].isCorrect)
			{
				$mc_Input.text = $arr_Answers[i].text;
				$fn_Change();
				break;
			}
		}
	}
	
	public function selectIncorrectAnswers():Void
	{
		$mc_Input.text = "This is incorrect.";
		$fn_Change();
	}
}