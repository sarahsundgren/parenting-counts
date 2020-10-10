///////////////////////////////////////////////////////////////////////////////////////////////////
// eXtensible Template Class for a shell graphic (movieclip)
// 
// @author   Allen Communication Learning Services
// @version  3.2
// 
// The XTC_ShellUIGraphic class extends the XTC_RuntimeExtensibleClass class and is used to manage 
// shell graphics.  This class is linked to a Flash component within the shell and instantiated as 
// a "movie clip" within the timeline.  Component parameters are then used to customize each object.
///////////////////////////////////////////////////////////////////////////////////////////////////

[InspectableList("p_urlFile"}]
class XTC_ShellUIGraphic extends XTC_RuntimeExtensibleClass{
	static  var MAMBA_CLASS:		  	Boolean = true;						// Indicates a mamba class
	
		// General properties
	private var p_strClassID:			String = "XTC_ShellUIGraphic";		// Class ID
	
		// Class properties
	static  var s_arrExtendObjs:		Array = new Array();				// List of objects to extend
	
	[Inspectable(name= "File URL" defaultValue="" type=String)]
	private var p_urlFile:				String;								// URL of the media to load
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	CONSTRUCTION / INITIALIZATION
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	* Constructor (no params)
	**/	
	function XTC_ShellUIGraphic()
	{
			// Extend the class (if the extension already exists)
		pxtc_autoExtend(_global.XTC_ShellUIGraphic, _global.XTC_ShellUIGraphicEx);
	}	
	
	/**
	* Transform this class to another class
	**/
	public function xtc_extendClass(Void): Void
	{	
		pxtc_extendClass(_global.XTC_ShellUIGraphic, _global.XTC_ShellUIGraphicEx);				
	}
}