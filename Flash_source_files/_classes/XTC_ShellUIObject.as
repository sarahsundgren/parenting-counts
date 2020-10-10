///////////////////////////////////////////////////////////////////////////////////////////////////
// eXtensible Template Class for a shell object (movieclip)
// 
// @author   Allen Communication Learning Services
// @version  3.2
// 
// The XTC_ShellUIObject class extends the XTC_RuntimeExtensibleClass class and is used to manage 
// shell objects.  This class is linked to a Flash component within the shell and instantiated as 
// a "movie clip" within the timeline.  Component parameters are then used to customize each object.
///////////////////////////////////////////////////////////////////////////////////////////////////

class XTC_ShellUIObject extends XTC_RuntimeExtensibleClass{
	static  var MAMBA_CLASS:		  	Boolean = true;						// Indicates a mamba class
	
		// General properties
	private var p_strClassID:			String = "XTC_ShellUIObject";		// Class ID
	
	
		// Class properties
	static  var s_arrExtendObjs:		Array = new Array();				// List of objects to extend
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	CONSTRUCTION / INITIALIZATION
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	* Constructor (no params)
	**/	
	function XTC_ShellUIObject()
	{	
			// Extend the class (if the extension already exists)
		pxtc_autoExtend(_global.XTC_ShellUIObject, _global.XTC_ShellUIObjectEx);
	}	
	
	/**
	* Transform this class to another class
	**/
	public function xtc_extendClass(Void): Void
	{	
		pxtc_extendClass(_global.XTC_ShellUIObject, _global.XTC_ShellUIObjectEx);				
	}
}