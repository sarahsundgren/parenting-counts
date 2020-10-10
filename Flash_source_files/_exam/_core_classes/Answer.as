class Answer extends Object
{		
	private var $xml_Data:_XMLNode;
	private var $xml_Feedback:_XMLNode;
	private var $str_Text:String;
	private var $qst_Parent:Question;
	private var $b_Correct:Boolean;
	
	public function get feedback():_XMLNode
	{
		return $xml_Feedback;
	}
	
	public function get question():Question
	{
		return $qst_Parent;
	}
	
	public function get isCorrect():Boolean
	{
		return $b_Correct;
	}
	
	public function get text():String
	{
		return $str_Text;
	}
	
	public function Answer( qst_Parent:Question, xml_Data:_XMLNode )
	{
		$xml_Data = xml_Data;
		$qst_Parent = qst_Parent;
		
		$b_Correct		= xml_Data.xtc_getBooleanAttribute("correct");
		$str_Text		= xml_Data.xtc_getValue("text");
		$xml_Feedback	= xml_Data.xtc_findChild("feedback");
		
		if ($xml_Feedback.xtc_getValue() == null)
			$xml_Feedback = null;
	}
	
	public function checkMatch( str_Compare:String, b_CaseSensitive:Boolean ):Boolean
	{
		if (b_CaseSensitive)
			return $str_Text == str_Compare;
		else
			return $str_Text.toLowerCase() == str_Compare.toLowerCase();
	}
	
	public function grade():Boolean
	{
		return $b_Correct;
	}
}