///////////////////////////////////////////////////////////////////////////////////////////////////
// eXtensible Template Class for a shell button (movieclip)
// 
// @author   Allen Communication Learning Services
// @version  3.2
// 
// The XTC_ShellButton class extends the XTC_RuntimeExtensibleClass class and is used to manage 
// shell buttons.  This class is linked to a Flash component within the shell and instantiated as 
// a "movie clip" within the timeline.  Component parameters are then used to customize each object.
///////////////////////////////////////////////////////////////////////////////////////////////////

[InspectableList("p_bInitiallyVisible", "p_strLinkedComponent", "p_bShowSelectedState", "p_bInitiallyEnabled", "p_strEnableFn", "p_bDisableOnNavigate", "p_nColorNormal", "p_nColorRollOver", "p_nColorDisabled", "p_strOnReleaseFn", "p_strOnRollOverFn", "p_strOnRollOutFn"}]
class XTC_ShellUIButton extends XTC_RuntimeExtensibleClass{
	static  var MAMBA_CLASS:		  	Boolean = true;						// Indicates a mamba class
	
		// General properties
	private var p_strClassID:			String = "XTC_ShellUIButton";		// Class ID
	
		// Class properties
	static  var s_arrExtendObjs:		Array = new Array();				// List of objects to extend
	
		// Component params	
  	[Inspectable(name= " *Linked component" defaultValue="" type=String)]
	private var p_strLinkedComponent:	String;								// Should the button be initially enabled?
					 
 	[Inspectable(name= " Enabled" defaultValue="true" type=Boolean)]
	private var p_bInitiallyEnabled:	Boolean;							// Should the button be initially enabled?
	
 	[Inspectable(name= " Visible" defaultValue="true" type=Boolean)]
	private var p_bInitiallyVisible:	Boolean;							// Should the button be initially visible?

 	[Inspectable(name= " Disable while navigating" defaultValue="true" type=Boolean)]
	private var p_bDisableOnNavigate:	Boolean;							// Should the button disable during navigation?
	
	[Inspectable(name= " Show selected state" defaultValue="false" type=Boolean)]
	private var p_bShowSelectedState:	Boolean;							// Should the selected state be used?
	
	[Inspectable(name= " Color: normal" defaultValue="" type=String)]
	private var p_nColorNormal:			Number;								// What is the "normal" color of this button?

	[Inspectable(name= " Color: roll-over" defaultValue="" type=String)]
	private var p_nColorRollOver:		Number;								// What is the "roll-over" color of this button?

	[Inspectable(name= " Color: disabled" defaultValue="" type=String)]
	private var p_nColorDisabled:		Number;								// What is the "disabled" color of this button?

	[Inspectable(name= "Delegate: xtc_enable" defaultValue="" type=String)]
	private var p_strEnableFn:			String;								// Name of the (optional) enable override (function)
	
	[Inspectable(name= "Delegate: xtc_onRelease" defaultValue="" type=String)]
	private var p_strOnReleaseFn:		String;								// Name of the (optional) onRelease event handler (function)
	
	[Inspectable(name= "Delegate: xtc_onRollOver" defaultValue="" type=String)]
	private var p_strOnRollOverFn:		String;								// Name of the (optional) onRollOver event handler (function)
	
	[Inspectable(name= "Delegate: xtc_onRollOut" defaultValue="" type=String)]
	private var p_strOnRollOutFn:		String;								// Name of the (optional) onRollOut event handler (function)
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	CONSTRUCTION / INITIALIZATION
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	* Constructor (no params)
	**/	
	function XTC_ShellUIButton()
	{	
			// Extend the class (if the extension already exists)
		pxtc_autoExtend(_global.XTC_ShellUIButton, _global.XTC_ShellUIButtonEx);
	}	
	
	/**
	* Transform this class to another class
	**/
	public function xtc_extendClass(Void): Void
	{	
		pxtc_extendClass(_global.XTC_ShellUIButton, _global.XTC_ShellUIButtonEx);				
	}
}