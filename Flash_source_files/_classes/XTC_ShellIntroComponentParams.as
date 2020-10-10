///////////////////////////////////////////////////////////////////////////////////////////////////
// eXtensible Template Class for an intro/init-sequence shell component (movieclip)
// 
// @author   Allen Communication Learning Services
// @version  3.2
// 
// The XTC_ShellIntroComponentParams class extends the MovieClip class and is used to 
// manage shell  components used during the initialization/introductory sequence.  This class is 
// linked to a Flash component within the shell and instantiated as a "movie clip" within the 
// timeline.  Component parameters are then used to customize each object.
///////////////////////////////////////////////////////////////////////////////////////////////////

[InspectableList("p_strID", "p_urlFile", "p_urlXML", "p_bAutoInit", "m_nPercentToLoad", "p_bPausePreloader", "p_strOnLoadInitFn", "p_strOnLoadErrorFn", "p_strOnComplete"}]
class XTC_ShellIntroComponentParams extends MovieClip{
	static  var MAMBA_CLASS:		  	Boolean = true;								// Indicates a mamba class
	
		// General properties
	private var p_strClassID:			String = "XTC_ShellIntroComponentParams";	// Class ID
	
		// Component params									 
 	[Inspectable(name= " *ID" defaultValue="" type=String)]
	private var p_strID:				String;										// Common ID
					 
 	[Inspectable(name= " *External file" defaultValue="" type=String)]
	private var p_urlFile:				String;										// External file to load
	
	[Inspectable(name= " *XML file" defaultValue="" type=String)]
	private var p_urlXML:				String;									// External xml file to load
		
 	[Inspectable(name= " Auto-init" defaultValue="true" type=Boolean)]
	private var p_bAutoInit:			Boolean = true;								// Should the component initialize automatically, as soon as the clip loads (true) or should it wait for notification (false)?
	
	[Inspectable(name= " Initially visible" defaultValue="false" type=Boolean)]						 
	private var p_bInitiallyVisible:	Boolean = true;								// Should the component initially be visible?
	
	[Inspectable(name=" Pre-load percentage" defaultValue=0)]	
	public  var m_nPercentToLoad: 	  	Number;										// Property for specifying the amount to Load before playing	
	
	[Inspectable(name= " Pause preloader" defaultValue="false" type=Boolean)]
	private var p_bPausePreloader:		Boolean;									// Should the component pause the shell preloader while it's active (it will resume on completion)

	[Inspectable(name= "Delegate: xtc_onLoadInit" defaultValue="" type=String)]
	private var p_strOnLoadInitFn:		String;										// Name of the (optional) load event handler
	
	[Inspectable(name= "Delegate: xtc_onLoadError" defaultValue="" type=String)]
	private var p_strOnLoadErrorFn:		String;										// Name of the (optional) load error handler	

	[Inspectable(name= "Delegate: xtc_onComplete" defaultValue="" type=String)]
	private var p_strOnComplete:		String;										// Name of the (optional) completion handler
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	CONSTRUCTION / INITIALIZATION
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	* Constructor (no params)
	**/	
	function XTC_ShellIntroComponentParams()		
	{	
		this._visible = false;
	}	
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	PROPERTY INTERACTION
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	
	/**
	* Specity the associated file
	*
	* @param urlFile   file name/url
	**/
	public function xtc_setFile(urlFile:String): Void		{	p_urlFile = urlFile;	}
}