class Target extends MovieClip
{		
	private var $xml_Data:_XMLNode;
	private var $n_Width:Number;
	private var $str_Style:String;
	private var $n_Index:Number;
	private var $qst_Parent:Question;
	private var txt_Content:TextField;
	private var $mc_Source:Source;
	private var mc_Target:MovieClip;
	
	public function set xml( xml_Content:_XMLNode ):Void
	{
		$xml_Data = xml_Content;
	}
	
	public function get xml():_XMLNode
	{
		return $xml_Data;
	}
	
	public function get targetArea():MovieClip
	{
		return mc_Target;
	}
	
	public function get source():Source
	{
		return $mc_Source;
	}
	
	public function set source( mc_Source:Source ):Void
	{
		$mc_Source = mc_Source;
	}
	
	public function get text():String
	{
		return txt_Content.text;
	}
	
	public function set text( str_Text:String ):Void
	{
		txt_Content.htmlText = str_Text;
	}
	
	public function get question():Question
	{
		return $qst_Parent;
	}
	
	public function set question( qst_Parent:Question ):Void
	{
		$qst_Parent = qst_Parent;
	}
	
	public function set width( n_Width:Number ):Void
	{
		$n_Width = n_Width;
		txt_Content._width	= $n_Width - txt_Content._x;
	}
	
	public function get width():Number
	{
		return $n_Width;
	}
	
	public function get height():Number
	{
		return _height;
	}
	
	public function set index( n_Index:Number ):Void
	{
		$n_Index = n_Index;
	}
	
	public function get index():Number
	{
		return $n_Index;
	}
	
	public function Target()
	{
		txt_Content.autoSize	= true;
		txt_Content.multiline	= true;
		txt_Content.wordWrap	= true;
		txt_Content.html		= true;
		_global.gInterface.initializeTextField(txt_Content, $str_Style);
	}
}