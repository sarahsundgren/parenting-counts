class TextBox extends MovieClip
{		
	private var $n_Width:Number;
	private var $str_Style:String;
	private var txt_Content:TextField;
	
	public function xtc_getBaseObject(Void): TextField
	{
		return txt_Content;
	}
	
	public function xtc_getInnerWidth(Void): Number
	{
		return txt_Content._width;
	}
	
	public function xtc_getInnerHeight(Void): Number
	{
		return txt_Content._height;
	}
	
	/**
	* Move the base object
	*
	* @param  nDeltaX  		 the number of horizontal pixels to shift
	* @param  nDeltaY  		 the number of vertical pixels to shift
	**/	
	public function xtc_shiftBaseObjectXY(nDeltaX:Number, nDeltaY:Number): Void
	{
			// Adjust X
		if (nDeltaX)
			xtc_getBaseObject()._x += nDeltaX;
			// Adjust Y
		if (nDeltaY)
			xtc_getBaseObject()._y += nDeltaY;
	}
	
	public function set text( str_Text:String ):Void
	{
		if (str_Text == null)
			str_Text = "";
			
			// These must be true when you set the text or it strips out paragraphs/list items
		txt_Content.multiline = true;
		txt_Content.wordWrap = true;
		txt_Content.htmlText = str_Text;
		txt_Content.multiline = false;
		txt_Content.wordWrap = false;
		
		if (txt_Content._width > $n_Width - txt_Content._x)
		{
			txt_Content.multiline = true;
			txt_Content.wordWrap = true;
			
			txt_Content._width = $n_Width - txt_Content._x;
		}
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
		if ($n_Width == null)
			return _width;
			
		return $n_Width;
	}
	
	public function TextBox()
	{
		txt_Content.autoSize = true;
		txt_Content.html = true;
		_global.gInterface.initializeTextField(txt_Content, $str_Style);
	}
}