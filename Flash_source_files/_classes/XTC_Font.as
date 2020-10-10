///////////////////////////////////////////////////////////////////////////////////////////////////
/*  
	Class: XTC_Font
	   
	Author   - Allen Communication Learning Services  	
	Version  - 3.2
	File	 - _classes\XTC_Font.as
	
	Base eXtensible Template Class for an embedded font.  Extended at runtime to <XTC_FontEx>.
*/
///////////////////////////////////////////////////////////////////////////////////////////////////

class XTC_Font extends XTC_RuntimeExtensibleClass{
	static  var MAMBA_CLASS:		    Boolean = true;						// Indicates a mamba class
		
		// General properties
	private var p_strClassID:			String = "XTC_Font";				// Class ID
	
		// Class properties
	static  var s_arrExtendObjs:		Array = new Array();				// List of objects to extend
	
		// Params
	private var p_mcOwner:				MovieClip = null;					// Owner
	public  var m_txtGlyphs:			TextField;							// The actual TextField object
			
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	Group: Constructor
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/*
		Constructor:  XTC_Font
		
		Initializes the object and automatically extends to the core <XTC_FontEx> class.
		
		See Also:
			<XTC_RuntimeExtensibleClass.pxtc_extendClass>
	*/	
	function XTC_Font(ref_txtGlyphs:TextField, ref_mcOwner:MovieClip)
	{	
		this._visible = false;
		
		if (ref_txtGlyphs)
			m_txtGlyphs = ref_txtGlyphs;
			
		if (ref_mcOwner)
			p_mcOwner = ref_mcOwner;
			
			// Extend the class (if the extension already exists)
		pxtc_autoExtend(_global.XTC_Font, _global.XTC_FontEx);
	}

	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	Group: Transformation Methods
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/*
		Function: xtc_extendClass
		
		Extend this class to the core <XTC_FontEx> class.
	*/	
	public function xtc_extendClass(Void): Void
	{	
		pxtc_extendClass(_global.XTC_Font, _global.XTC_FontEx);				
	}
}