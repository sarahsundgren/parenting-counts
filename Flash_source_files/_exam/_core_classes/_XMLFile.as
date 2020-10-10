///////////////////////////////////////////////////////////////////////////////////////////////////
// eXtensible Template Class for an XML File object
// 
// @author   Allen Communication Learning Services
// @version  3.0
// 
// The _XMLFile class extends the standard Flash XML class and serves as a basis for loading 
// and managing external XML files. 
//////////////////////////////////////////////////////////////////////////////////////////////////
import mx.utils.Delegate;

class _XMLFile extends XML{
		// General properties
	private var p_strClassID:		String = "_XMLFile";				// Class ID
	private var p_objParent;				  							// Handle to the parent object (XTC or MovieClip)
	
	public  var m_urlFile:			String;								// External XML file to load
	public  var idMap;													// "ID" mapping (used for rapid lookup)
	public  var m_xmlnData:			_XMLNode;						// XML node data

		// Callback functions
	public  var ext_fnOnLoad:		Function;							// External "on load" event handler

	///////////////////////////////////////////////////////////////////////////////////////////////
	//	CONSTRUCTION / INITIALIZATION
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	* Constructor
	*
	* @param  ref_objParent    handle to the parent object
	**/	
	function _XMLFile(ref_objParent)
	{	
		super();
		
		p_objParent = ref_objParent;

		m_urlFile = null;		
		this.ignoreWhite = true;
		this.onLoad = Delegate.create(this, this.xtc_onLoad);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////
	// EVENT HANDLERS
	///////////////////////////////////////////////////////////////////////////////////////////////////

	/*
	* Event handler called when the external XML data has loaded.
	*
	* @param  bSuccess  true if the XML was loaded; false otherwise
	**/		
	public function xtc_onLoad(bSuccess:Boolean): Void
	{
		if (bSuccess)
			m_xmlnData = xtc_getFirstNode();
		if (ext_fnOnLoad)
			ext_fnOnLoad(bSuccess);
		else if (!bSuccess)
			trace("XML load error (" + m_urlFile + ")!");
	}

	
	/*
	* Load the file into memory
	*
	* @param  urlFile		url of the XML file to load
	* @param  ref_fnOnLoad	"on load" event handler (optional)
	**/	
	public function xtc_loadFile(urlFile:String, ref_fnOnLoad:Function): Void
	{
		m_urlFile    = urlFile;
		if (p_objParent)
			ext_fnOnLoad = Delegate.create(p_objParent, ref_fnOnLoad);
		else
			ext_fnOnLoad = ref_fnOnLoad;
		this.load(m_urlFile);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////
	// DATA QUERYING
	///////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	* Obtain XML data (by Node name/type and ID)
	*
	* @param  strNodeName	name of the node to search for
	* @param  strID			ID attribute of the node to search for (optional)
	* @return				the node matching the search criteria
	**/			
	public function xtc_findNode(strNodeName:String, strID:String): _XMLNode
	{
		return m_xmlnData.xtc_findNode(strNodeName, strID);
	}
	
	
	/**
	* Obtain XML data by quick lookup within the idMap
	*
	* @param  strID	  ID attribute of the node to retrieve
	* @return		  the node matching the search criteria
	**/			
	public function xtc_findNodeByID(strID:String): _XMLNode
	{
		if (this.idMap[strID])
			return new _XMLNode(this.idMap[strID]);
		else if (this[strID])
			return new _XMLNode(this[strID]);
		else
			return null;
	}
	
	
	/**
	* Obtain XML data (by Node name/type and ID) but limit the search to the first child depth level
	*
	* @param  strNodeName	name of the node to search for
	* @param  strID			ID attribute of the node to search for (optional)
	* @return				one or more nodes matching the search criteria
	**/		
	public function xtc_findChildren(strNodeName:String, strID:String)
	{
		return m_xmlnData.xtc_findChildren(strNodeName, strID);
	}
	
	
	/**
	* Obtain XML data (by Node name/type and ID) but limit the search to the first child depth level
	*
	* @param  strNodeName	name of the node to search for
	* @param  strID			ID attribute of the node to search for (optional)
	* @return				one or more nodes matching the search criteria
	**/		
	public function xtc_findChild(strNodeName:String, strID:String): _XMLNode
	{
		return m_xmlnData.xtc_findChild(strNodeName, strID);
	}
		
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	PROPERTY-INTERACTION METHODS
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/*
	* Get the file name of the external XML file
	*
	* @return  the file url
	**/		
	public function xtc_getFile(Void): String				{	return m_urlFile;	}
	
	
	/*
	* Get the first XML node
	*
	* @return  the first XML node
	**/		
	public function xtc_getFirstNode(Void): _XMLNode		
	{	
		if (this.firstChild)		
			return new _XMLNode(this.firstChild);	
		else
			return null;
	}
	
							 
	/**
	* Get the class type of this object
	*
	* @return  the class ID
	**/
	public function xtc_getClassType(Void): String 			{ 	return p_strClassID; 	}	
}