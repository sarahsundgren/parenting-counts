///////////////////////////////////////////////////////////////////////////////////////////////////
/*  
	Class: XTC_RuntimeExtensibleClass
	   
	Author   - Allen Communication Learning Services  	
	Version  - 3.2
	File	 - _core classes\XTC_RuntimeExtensibleClass.as
	
	Base eXtensible Template Class managing class transformation/extension.
*/
///////////////////////////////////////////////////////////////////////////////////////////////////

class XTC_RuntimeExtensibleClass extends MovieClip{
	static  var MAMBA_CLASS:		  	Boolean = true;							// Indicates a mamba class
	
		// General properties
	private var p_strClassID:			String = "XTC_RuntimeExtensibleClass";	// Class ID
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	Group: Constructor
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/*
		Constructor:  XTC_RuntimeExtensibleClass
		
		Initializes the object.
	*/	
	function XTC_RuntimeExtensibleClass()		{	}
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	Group: Transformation Methods
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/*
		Function: pxtc_autoExtend
		
		Extend a class, if ready, otherwise queue the transformation until the extended class has loaded.
		
		Parameters:
			ref_xtcBaseClass   - Handle to the base class.
			ref_xtcExtendClass - Handle to the extended class.
			
		See Also:
			<pxtc_extendClass>, <xtc_isExtended>
	*/	
	private function pxtc_autoExtend(ref_xtcBaseClass, ref_xtcExtendClass): Void
	{		
			// Extend the class (if the extension already exists)
		if (ref_xtcExtendClass)
			pxtc_extendClass(ref_xtcBaseClass, ref_xtcExtendClass);
			// Otherwise, register the object as needing an extension (for when the extended class loads later
		else 
			ref_xtcBaseClass.s_arrExtendObjs.push(this);
	}
	
	/*
		Function: pxtc_extendClass
		
		Extend one class to another class.
		
		Parameters:
			ref_xtcBaseClass   - Handle to the base class.
			ref_xtcExtendClass - Handle to the extended class.
			
		See Also:
			<pxtc_autoExtend>, <xtc_isExtended>
	*/	
	private function pxtc_extendClass(ref_xtcBaseClass, ref_xtcExtendClass): Void
	{	
		var xtcObject = this;
		
			// Remove this item from the extension list
		for (var inExtend: Number = 0; inExtend < ref_xtcBaseClass.s_arrExtendObjs.length; inExtend++)
		{
			if (ref_xtcBaseClass.s_arrExtendObjs[inExtend] == xtcObject)
			{
				ref_xtcBaseClass.s_arrExtendObjs.splice(inExtend, 1);
				break;
			}
		}
			// Extend the class
		if (xtcObject.__proto__ != ref_xtcExtendClass.prototype)
		{
			xtcObject.__proto__ = ref_xtcExtendClass.prototype;
			xtcObject.xtc_onClassExtended();
		}
	}
		
	/*
		Function:  xtc_isExtended
		
		Determine if the instantiated object has been extended.
				
		Returns:
			true if extended; false if still the base class.
			
		See Also:
			<pxtc_autoExtend>, <pxtc_extendClass>
	*/	
	public function xtc_isExtended(Void): Boolean
	{	
		return false;			
	}
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	Group: General Methods
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/*
		Function:  xtc_getClassType
		
		Get the class name/ID.
				
		Returns:
			The class name/ID.
	*/	
	public function xtc_getClassType(Void): String 
	{ 	
		return p_strClassID; 	
	}
}