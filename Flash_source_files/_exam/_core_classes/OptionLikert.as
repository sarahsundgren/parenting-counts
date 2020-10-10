class OptionLikert extends Option
{
	public function set text( str_Text:String ):Void
	{
		super.text = str_Text;
		
		mc_Selection._x	= (width - mc_Selection._width) / 2;
		txt_Content._x	= (width - txt_Content._width)  / 2;
	}
}