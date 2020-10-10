class ExternalFont extends MovieClip
{		
	public var m_txtGlyphs:TextField;
	
	public function ExternalFont()
	{
		_global.gInterface.registerExternalFont(m_txtGlyphs.getTextFormat().font, this);
		this._visible = false;
	}
}