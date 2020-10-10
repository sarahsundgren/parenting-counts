class Option extends MovieClip
{		
	private var $xml_Data:_XMLNode;
	private var $n_Width:Number;
	private var $b_Correct:Boolean;
	private var $b_Radio:Boolean;
	private var $n_Index:Number;
	private var $b_Selected:Boolean;
	private var $qst_Parent:Question;
	private var $str_Style:String;
	private var txt_Content:TextField;
	private var $xml_Feedback:_XMLNode;
	private var mc_Selection:MovieClip;
	private var mc_Grade:MovieClip;
	
	public function set xml( xml_Content:_XMLNode ):Void
	{
		$xml_Data = xml_Content;
	}
	
	public function get xml():_XMLNode
	{
		return $xml_Data;
	}
	
	public function set feedback( xml_Feedback:_XMLNode ):Void
	{
		$xml_Feedback = xml_Feedback;
		
		if ($xml_Feedback.xtc_getValue() == null)
			$xml_Feedback = null;
	}
	
	public function get feedback():_XMLNode
	{
		return $xml_Feedback;
	}
	
	public function set text( str_Text:String ):Void
	{
		txt_Content.multiline = false;
		txt_Content.wordWrap = false;
		txt_Content.htmlText = str_Text;
		
		if (txt_Content._width > $n_Width - txt_Content._x)
		{
			txt_Content.multiline = true;
			txt_Content.wordWrap = true;
			
			txt_Content._width = $n_Width - txt_Content._x;
		}
	}
	
	public function set index( n_Index:Number ):Void
	{
		$n_Index = n_Index;
	}
	
	public function get index():Number
	{
		return $n_Index;
	}
	
	public function get question():Question
	{
		return $qst_Parent;
	}
	
	public function set question( qst_Parent:Question ):Void
	{
		$qst_Parent = qst_Parent;
	}
	
	public function get isSelected():Boolean
	{
		return $b_Selected;
	}
	
	public function set isSelected( b_Selected:Boolean ):Void
	{
		$b_Selected = b_Selected;
		
		if ($b_Selected)
			mc_Selection.gotoAndStop($b_Radio ? "_radio_checked" : "_cbox_checked");
		else
			mc_Selection.gotoAndStop($b_Radio ? "_radio_empty" : "_cbox_empty");
	}
	
	public function get isRadio():Boolean
	{
		return $b_Radio;
	}
	
	public function set isRadio( b_Radio:Boolean ):Void
	{
		$b_Radio = b_Radio;
		
		mc_Selection.gotoAndStop($b_Radio ? "_radio_empty" : "_cbox_empty");
	}
	
	public function get isCorrect():Boolean
	{
		return $b_Correct;
	}
	
	public function set isCorrect( b_Correct:Boolean ):Void
	{
		$b_Correct = b_Correct;
	}
	
	public function get text():String
	{
		return txt_Content.text;
	}
	
	public function set width( n_Width:Number ):Void
	{
		$n_Width = n_Width;
	}
	
	public function get width():Number
	{
		return $n_Width;
	}
	
	public function Option()
	{
		txt_Content.autoSize	= true;
		txt_Content.html		= true;
		$b_Selected				= false;
		_global.gInterface.initializeTextField(txt_Content, $str_Style);
	}
	
	public function grade():Boolean
	{
		return isCorrect == isSelected;
	}
	
	public function showGradeMark():Void
	{
		if ((isCorrect) && (isSelected))
			mc_Grade.gotoAndStop("_correct");
		//else if (isSelected)
			//mc_Grade.gotoAndStop("_incorrect");
	}
}