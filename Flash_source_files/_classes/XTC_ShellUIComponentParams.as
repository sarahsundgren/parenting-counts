///////////////////////////////////////////////////////////////////////////////////////////////////
// eXtensible Template Class for a shell popup/resource component (movieclip)
// 
// @author   Allen Communication Learning Services
// @version  3.2
// 
// The XTC_ShellUIComponentParams class extends the MovieClip class and is used to 
// manage shell "popup" components.  This class is linked to a Flash component within the shell and 
// instantiated as a "movie clip" within the timeline.  Component parameters are then used to 
// customize each object.
///////////////////////////////////////////////////////////////////////////////////////////////////

[InspectableList("p_strID", "p_urlFile", "p_urlXML", "p_bAutoInit", "p_bReplayOnShow", "m_nPercentToLoad", "p_bInitiallyVisible", "p_bExclusive", "p_bImpactsMedia", "p_bClickBlocker", "p_bHideOnNavigate", "p_bShowLoadMsg", "p_strLoadPriority", "p_strOnLoadInitFn", "p_strOnLoadErrorFn", "p_strIsVisibleFn", "p_strSetVisibilityFn"}]
class XTC_ShellUIComponentParams extends MovieClip{
	static  var MAMBA_CLASS:		  	Boolean = true;							// Indicates a mamba class
	
		// General properties
	private var p_strClassID:			String = "XTC_ShellUIComponentParams";	// Class ID
	
		// Component params									 
 	[Inspectable(name= " *ID" defaultValue="" type=String)]
	private var p_strID:				String;									// Common ID
					 
 	[Inspectable(name= " *External file" defaultValue="" type=String)]
	private var p_urlFile:				String;									// External file to load
	
 	[Inspectable(name= " *XML file" defaultValue="" type=String)]
	private var p_urlXML:				String;									// External xml file to load
		
 	[Inspectable(name= " Auto-init" defaultValue="true" type=Boolean)]
	private var p_bAutoInit:			Boolean = true;							// Should the component initialize automatically, as soon as the clip loads (true) or should it wait for notification (false)?
	
	[Inspectable(name= " Initially visible" defaultValue="false" type=Boolean)]						 
	private var p_bInitiallyVisible:	Boolean = true;							// Should the component initially be visible?
	
	[Inspectable(name= " Replay when shown" defaultValue="false" type=Boolean)]						 
	private var p_bReplayOnShow:		Boolean = false;							// Should the component replay when shown?
	
	[Inspectable(name=" Pre-load percentage" defaultValue=0)]	
	public  var m_nPercentToLoad: 	  	Number;									// Property for specifying the amount to Load before playing	

	[Inspectable(name= "Delegate: xtc_onLoadInit" defaultValue="" type=String)]
	private var p_strOnLoadInitFn:		String;									// Name of the (optional) load event handler
	
	[Inspectable(name= "Delegate: xtc_onLoadError" defaultValue="" type=String)]
	private var p_strOnLoadErrorFn:		String;									// Name of the (optional) load error handler
	
 	[Inspectable(name= " Impacts media" defaultValue="false" type=Boolean)]						 
	private var p_bImpactsMedia:		Boolean;								// Does this component impact media (i.e., should it pause media when loaded?)
	
	[Inspectable(name= " Show Click Blocker" defaultValue="true" type=Boolean)]						 
	private var p_bClickBlocker:		Boolean;								// Does this component impact media (i.e., should it pause media when loaded?)
	
	[Inspectable(name= " Hide on navigate" defaultValue="false" type=Boolean)]						 
	private var p_bHideOnNavigate:		Boolean;								// Should the component hide during navigation?
	
	[Inspectable(name= " Exclusive" defaultValue="false" type=Boolean)]						 
	private var p_bExclusive:			Boolean;								// Should the component hide other components when visible?

 	[Inspectable(name= " Show loading message" defaultValue="false" type=Boolean)]						 
	private var p_bShowLoadMsg:			Boolean;								// Should the component show the loading message when downloading?
	
 	[Inspectable(name= " Load priority" defaultValue="ON FIRST USE" enumeration="ON SHELL INIT,ON FIRST USE")]
	private var p_strLoadPriority:		String;									// Should the component load upon instantiation, when the shell initializes, or when first used?
	
	[Inspectable(name= "Delegate: xtc_isVisible" defaultValue="" type=String)]						 
	private var p_strIsVisibleFn:		String;									// Name of the (optional) visibility getter function
	
	[Inspectable(name= "Delegate: xtc_setVisibility" defaultValue="" type=String)]						 
	private var p_strSetVisibilityFn:	String;									// Name of the (optional) visibility setter function
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	CONSTRUCTION / INITIALIZATION
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	* Constructor (no params)
	**/	
	function XTC_ShellUIComponentParams()		
	{	
		this._visible = false;
	}	
}