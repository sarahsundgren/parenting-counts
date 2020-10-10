///////////////////////////////////////////////////////////////////////////////////////////////////
/*  
	Class: XTC_MenuNode
	   
	Author   - Allen Communication Learning Services  	
	Version  - 3.2
	File	 - _classes\XTC_MenuNode.as
	
	Base eXtensible Template Class for menu selection objects.  Extended at runtime to 
	<XTC_MenuNodeEx>.
*/
///////////////////////////////////////////////////////////////////////////////////////////////////

//[InspectableList("p_strDepth", "p_strChildTemplate", "p_strValidLinkedTypes", "p_nChildYMax", "p_nChildYMin", "p_strHotSpotSizeBehavior", "p_strSubmenuBehavior", "p_strRollOverBehavior", "p_strSpacingBehavior", "p_nSiblingSpacing", "p_strSiblingAlign", "p_nChildXShift", "p_nChildYShift", "p_strTextStyle", "p_strGfxStyle", "p_strVisualFX", "p_bNotifyInit", "p_bNotifyRollOver", "p_bNotifyRollOut", "p_bNotifyClick", "p_bNotifySubmenuToggle"}]
 
class XTC_MenuNode extends XTC_RuntimeExtensibleClass{
	static  var MAMBA_CLASS:		    Boolean = true;						// Indicates a mamba class
		
		// General properties
	private var p_strClassID:			String = "XTC_MenuNode";			// Class ID
	
		// Class properties
	static  var s_arrExtendObjs:		Array = new Array();				// List of objects to extend
			
		// Component params		
 	[Inspectable(name=" *Depth" defaultValue="LEVEL1" enumeration="LEVEL1,LEVEL2,LEVEL3")]	
	private var p_strDepth:				String;								// Node depth (LEVEL1, LEVEL2, or LEVEL3)
	
 	[Inspectable(name=" Child template" defaultValue="" type=String)]	
	private var p_strChildTemplate:		String;								// Name of the object to use as a template for creating children
	
	[Inspectable(name=" Supported node types" defaultValue="DEFAULT" enumeration="DEFAULT,PAGE,MODULE")]
	private var p_strValidLinkedTypes:	String;								// Node types supported (all, page-only, or module-only)
	
	[Inspectable(name=" Sibling spacing" defaultValue=0)]
	private var p_nSiblingSpacing:		Number;								// Property for specifying the pixel space between siblings in a sequence

	[Inspectable(name=" Sibling alignment" defaultValue="VERTICAL" enumeration="HORIZONTAL,VERTICAL")]
	private var p_strSiblingAlign:		String;								// Property for specifying the alignment of this object with its siblings

	[Inspectable(name=" Submenu X offset" defaultValue=0)]
	private var p_nChildXShift:			Number;								// Property for specifying the pixel shift between this node and it's submenu
	
	[Inspectable(name=" Submenu Y offset" defaultValue=0)]
	private var p_nChildYShift:			Number;								// Property for specifying the pixel shift between this node and it's submenu
	
	[Inspectable(name=" Submenu Y max" defaultValue=0)]
	private var p_nChildYMax:			Number;								// Property for specifying the maximum Y coordinate for the submenu
	
	[Inspectable(name=" Submenu Y min" defaultValue=0)]
	private var p_nChildYMin:			Number;								// Property for specifying the minimum Y coordinate for the submenu	

	[Inspectable(name=" Behavior: Spacing" defaultValue="DEFAULT" enumeration="DEFAULT,BY_TEXT_SIZE")]
	private var p_strSpacingBehavior:	String;								// Property for enabling/disabling the object's roll-over ability
	
	[Inspectable(name=" Behavior: Hot spot size" defaultValue="DEFAULT" enumeration="DEFAULT,MATCH_TEXT_SIZE")]
	private var p_strHotSpotSizeBehavior:String;								// Property for enabling/disabling the object's roll-over ability	
	
	[Inspectable(name=" Behavior: Submenu" defaultValue="DEFAULT" enumeration="DEFAULT,INSET,INSET_EXPANDABLE,POP_DOWN,POP_DOWN_RIGHT,POP_RIGHT_CENTER")]
	private var p_strSubmenuBehavior:	String;								// Property for specifying the alignment of this object with its siblings
	
	[Inspectable(name=" Behavior: Roll-over" defaultValue="DEFAULT" enumeration="DEFAULT,OFF,OPEN_SUBMENU")]
	private var p_strRollOverBehavior:	String;								// Property for enabling/disabling the object's roll-over ability
	
 	[Inspectable(name=" Style: text" defaultValue="MENU_TEXT" type=String)]
	private var p_strTextStyle:			String;								// Text style for this object and its cloned siblings
	
 	[Inspectable(name=" Style: graphic" defaultValue="MENU_BKG" type=String)]
	private var p_strGfxStyle:			String;								// Graphic style for this object and its cloned siblings
	
	[Inspectable(name=" Visual FX: show" defaultValue="MENU_FADEIN" type=String)]
	private var p_strVisualFX:			String;								// Visual FX for the this object and its cloned siblings
	
	[Inspectable(name= "$onSelectionInit" defaultValue=false)]
	private var p_bNotifyInit:			Boolean;							// Property controlling "initialization" notification events
		
	[Inspectable(name="$onSelectionRollOver" defaultValue=true)]
	private var p_bNotifyRollOver:		Boolean;							// Property for controlling "roll-over" notification events	

	[Inspectable(name="$onSelectionRollOut" defaultValue=true)]
	private var p_bNotifyRollOut:		Boolean;							// Property for controlling "roll-out" notification events	

	[Inspectable(name="$onSelectionClick" defaultValue=true)]
	private var p_bNotifyClick:			Boolean;							// Property for controlling "click" notification events	

	[Inspectable(name="$onSubmenuToggle" defaultValue=true)]
	private var p_bNotifySubmenuToggle:	Boolean;							// Property for controlling "submenu toggle" notification events	
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	Group: Constructor
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/*
		Constructor:  XTC_MenuNode
		
		Initializes the object and automatically extends to the core <XTC_MenuNodeEx> class.
		
		See Also:
			<XTC_RuntimeExtensibleClass.pxtc_extendClass>
	*/	
	function XTC_MenuNode()
	{	
		this._visible = false;
		
			// Extend the class (if the extension already exists)
		pxtc_autoExtend(_global.XTC_MenuNode, _global.XTC_MenuNodeEx);
	}

	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	Group: Transformation Methods
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/*
		Function: xtc_extendClass
		
		Extend this class to the core <XTC_MenuNodeEx> class.
	*/	
	public function xtc_extendClass(Void): Void
	{	
		pxtc_extendClass(_global.XTC_MenuNode, _global.XTC_MenuNodeEx);				
	}
}