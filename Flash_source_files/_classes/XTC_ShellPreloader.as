///////////////////////////////////////////////////////////////////////////////////////////////////
/*  
	Class: XTC_ShellPreloader
	   
	Author   - Allen Communication Learning Services  	
	Version  - 3.2
	File	 - _classes\XTC_ShellPreloader.as
	
	Base eXtensible Template Class for the shell preloader component.  Extended at runtime to 
	<XTC_ShellPreloaderEx>.
*/
///////////////////////////////////////////////////////////////////////////////////////////////////

class XTC_ShellPreloader extends XTC_RuntimeExtensibleClass{
	static  var MAMBA_CLASS:		  	Boolean = true;						// Indicates a mamba class
	
		// General properties
	private var p_strClassID:			String = "XTC_ShellPreloader";		// Class ID

		// Class properties
	static  var s_arrExtendObjs:		Array = new Array();
	

	///////////////////////////////////////////////////////////////////////////////////////////////
	//	Group: Constructor
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/*
		Constructor:  XTC_ShellPreloader
		
		Initializes the object and automatically extends to the core <XTC_ShellPreloaderEx> class.
		
		See Also:
			<XTC_RuntimeExtensibleClass.pxtc_extendClass>
	*/	
	function XTC_ShellPreloader()
	{	
		this._visible = false;
		
			// Extend the class (if the extension already exists)
		pxtc_autoExtend(_global.XTC_ShellPreloader, _global.XTC_ShellPreloaderEx);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	Group: Transformation Methods
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/*
		Function: xtc_extendClass
		
		Extend this class to the core <XTC_ShellPreloaderEx> class.
	*/	
	public function xtc_extendClass(Void): Void
	{	
		pxtc_extendClass(_global.XTC_ShellPreloader, _global.XTC_ShellPreloaderEx);				
	}
}