import mx.utils.*;

class PopupMessage extends MovieClip
{
	public var onClose:Function;
	
	private var btn_Accept:ExamButton;
	private var txt_Content:TextField;
	
	public function set text( str_Text:String ):Void
	{
		txt_Content.htmlText = str_Text;
	}
	
	public function PopupMessage()
	{
		txt_Content.autoSize = true;
		btn_Accept.onRelease = Delegate.create(this, close);
		_global.gInterface.initializeTextField(txt_Content);
	}
	
	public function close():Void
	{
		onClose();
		this.removeMovieClip();
	}
}