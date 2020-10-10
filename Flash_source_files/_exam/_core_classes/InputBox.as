import mx.utils.*;

class InputBox extends MovieClip
{		
	private var $n_Width:Number;
	private var $str_Style:String;
	private var $fn_Change:Function;
	private var txt_Content:TextField;
	
	public function set enabled( b_Enabled:Boolean ):Void
	{
		super.enabled = b_Enabled;

		txt_Content.type = b_Enabled ? "input" : "dynamic";
	}
	
	public function set onChange( fn_Change:Function ):Void
	{
		$fn_Change = fn_Change;
	}
	
	public function set restrict( str_Restrict:String ):Void
	{
		txt_Content.restrict = str_Restrict;
	}
	
	public function get restrict():String
	{
		return txt_Content.restrict;
	}
	
	public function set text( str_Text:String ):Void
	{
		txt_Content.htmlText = str_Text;
	}
	
	public function get text():String
	{
		return txt_Content.text;
	}
	
	public function set width( n_Width:Number ):Void
	{
		txt_Content._width = n_Width - txt_Content._x;
	}
	
	public function get width():Number
	{
		return txt_Content._width + txt_Content._x;
	}
	
	public function get multiline():Boolean
	{
		return txt_Content.multiline;
	}
	
	public function set multiline( b_Value:Boolean ):Void
	{
		txt_Content.multiline	= b_Value;
		txt_Content.wordWrap	= b_Value;
		
			// If it should be a single line, force the height
		if (!b_Value)
			txt_Content._height = txt_Content.textHeight + 2;	// Add 2 pixels to create a gap below lowercase (pjq)
	}
	
	public function InputBox()
	{
		txt_Content.html		= true;
		txt_Content.multiline	= true;
		txt_Content.wordWrap	= true;
		txt_Content.onChanged	= Delegate.create(this, textChanged);

		_global.gInterface.initializeTextField(txt_Content, $str_Style);
	}
	
	private function textChanged():Void
	{
		$fn_Change();
	}
}