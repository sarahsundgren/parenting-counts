///////////////////////////////////////////////////////////////////////////////////////////////////
// eXtensible Template Class for an XML Node object
// 
// @author   Allen Communication Learning Services
// @version  3.0
// 
// The XTC_Notes class extends the standard Flash Object class and serves as a basis for importing 
// and managing script notes as defined within the template's XML content (via <notes> nodes). 
// Script notes are intended for development and review purposes and are only instantiated if the
// course shell defines the _SCRIPT_REVIEW_ constant (which was left undefined in the final 
// version of the course).
//////////////////////////////////////////////////////////////////////////////////////////////////


class _XMLNode extends Object{
		// General properties
	private var p_strClassID:		String = "_XMLNode";				// Class ID
	public  var m_xmlnData:		    XMLNode;							// Handle to the XML node pertaining to this object
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	CONSTRUCTION / INITIALIZATION
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	* Constructor.
	*
	* @param  ref_xtcOwner		handle to the object that this node pertains to.
	* @param  ref_xmlNode		the XML data node that contains the notes content (colld be XMLNode, XML, or String)
	**/	
	function _XMLNode(ref_xmlNode)
	{				
		if (ref_xmlNode instanceof XMLNode)
	 		m_xmlnData = ref_xmlNode;
		else if (ref_xmlNode instanceof XML)
			m_xmlnData = ref_xmlNode.firstChild;
		else
			m_xmlnData = new XML(ref_xmlNode).firstChild;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////
	// DATA FILTERING
	///////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	* See if a value is null
	*
	* @param  strValue	the value to analyze
	* @return			null if nothing exists in the value; otherwise it returns the value.
	**/			
	public function xtc_checkXMLValue(strValue:String): String
	{
		if ((strValue.length < 1) || (strValue == undefined))
			return null;
		else
			return strValue;		
	}

	public function xtc_equals(xmlNode:_XMLNode): Boolean
	{
		return xmlNode.m_xmlnData == m_xmlnData;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////
	// DATA QUERYING
	///////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	* Obtain XML data (by Node name/type and ID)
	*
	* @param  strNodeName	name of the node to search for
	* @param  strID			ID attribute of the node to search for
	* @param  nLimit		Limitation on how many similar nodes to retrieve
	* @param  nSearchLimit	Indication of how many nodes deep to search
	* @return				one or more nodes matching the search criteria
	**/	
	public function xtc_getNodeList(strNodeName:String, strID:String, nLimit:Number, nSearchLimit:Number)
	{
			//Loop through XML to find specified node
		var nLevel:		  Number = 0;
		var arrNodes:	  Array  = new Array();
		var arrNodeMatch: Array  = new Array();
		
		if ((m_xmlnData.nodeName == strNodeName) || (strNodeName == null))
			arrNodes[nLevel] = m_xmlnData;
		else
			arrNodes[nLevel] = m_xmlnData.firstChild;
		var strName: String = arrNodes[nLevel].nodeName;
		if (strNodeName == null)
			strNodeName = strName;	
		
		var arrNodeTree: Array  = strNodeName.split(".");
		var nNodeDepth:	 Number = 0;
		var nMaxDepth:	 Number = arrNodeTree.length - 1;
		var arrID:		 Array  = strID.split(".");
		var objNode:	 XMLNode;
	
		while(arrNodes[nLevel] != null)
		{	
			objNode = arrNodes[nLevel];
				
				// If a match...
			if ((strName == arrNodeTree[nNodeDepth]) && (strID == null || objNode.attributes.id == strID || 
			(arrID.length > 1 && arrNodes[nLevel-1].attributes.id == arrID[0] && objNode.attributes.id == arrID[1])))
			{
				if ((nNodeDepth >= nMaxDepth) || (nSearchLimit != null && nNodeDepth >= nSearchLimit))
				{
						// Add this node to the list
					arrNodeMatch.push(new _XMLNode(objNode));
					if ((nLimit) && (arrNodeMatch.length == nLimit))
					{
						if (nLimit == 1)
							return arrNodeMatch[0];
						else
							return arrNodeMatch;
					}
				}
				else
					nNodeDepth++;
			}	
				// Or, if it has children, move inside (but not if the depth limit is exceeded)
			if ((arrNodes[nLevel].childNodes.length >= 1) && (nSearchLimit == null || nLevel < nSearchLimit))
			{
				nLevel++;
				arrNodes[nLevel] = arrNodes[nLevel-1].firstChild;
				strName = arrNodes[nLevel].nodeName;
			}			
			else
			{
				while((nLevel > 0) && (arrNodes[nLevel].nextSibling == null))
					nLevel--;
					
				if (nLevel < 0)
					break;
				else
				{
					arrNodes[nLevel] = arrNodes[nLevel].nextSibling;
					strName = arrNodes[nLevel].nodeName;
				}
			}
		}
		
		if (arrNodeMatch.length > 0)	
			return arrNodeMatch;
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
		return xtc_getNodeList(strNodeName, strID, null, 0);
	}
	
	public function xtc_getChildren()
	{
		var arr_Children:Array = new Array();
		
			// Only return the childen nodes if there are more than one,
			// or if there is only one that isn't just text
		if (m_xmlnData.childNodes.length > 1 || (m_xmlnData.childNodes.length > 0 && m_xmlnData.childNodes[0].nodeType != 3))
		{
			arr_Children = new Array();
			
			for (var i:Number = 0; i < m_xmlnData.childNodes.length; i ++)
				arr_Children.push(new _XMLNode(m_xmlnData.childNodes[i]));
		}
		
		return arr_Children;
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
		return xtc_getNodeList(strNodeName, strID, 1, 0);
	}
	
	
	/**
	* Obtain XML data (by Node name/type and ID) but limit the search to parents only
	*
	* @param  strNodeName	name of the node to search for
	* @param  strID			ID attribute of the node to search for (optional)
	* @return				the node matching the search criteria
	**/		
	public function xtc_findParent(strNodeName:String, strID:String): _XMLNode
	{
		if (m_xmlnData.parentNode == null)
			return null;
			
		var xmlnParent: _XMLNode = xtc_getParent(); 
		if ((xmlnParent.xtc_getNodeName() == strNodeName) && (!strID || xmlnParent.xtc_getID() == strID))
			return xmlnParent;
		else
			return xmlnParent.xtc_findParent(strNodeName, strID);
	}
	

	/**
	* Obtain XML data (by Node name/type and ID)
	*
	* @param  strNodeName	name of the node to search for
	* @param  strID			ID attribute of the node to search for (optional)
	* @return				the node matching the search criteria
	**/			
	public function xtc_findNode(strNodeName:String, strID:String): _XMLNode
	{
		return xtc_getNodeList(strNodeName, strID, 1);
	}

	
	
	/**
	* Obtain XML node value (node Name/Type and ID are optional)
	*
	* @param  strNodeName	name of the node to search for
	* @param  strID			ID attribute of the node to search for (optional)
	* @return				the node matching the search criteria
	**/		
	public function xtc_getValue(strNodeName:String, strID:String): String
	{
		if ((strNodeName) || (strNodeName))
			return xtc_checkXMLValue(xtc_findNode(strNodeName, strID).xtc_getValue());
		else
			return xtc_checkXMLValue(m_xmlnData.firstChild.nodeValue);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////
	// ATTRIBUTE QUERYING
	///////////////////////////////////////////////////////////////////////////////////////////////////
	
	function xtc_setAttribute( str_Attribute:String, str_Value:String ):Void
	{
		m_xmlnData.attributes[str_Attribute] = str_Value;
	}
	
	/**
	* Obtain an XML node attribute (node Name/Type and ID are optional)
	*
	* @param  strAttribute	name of the attribute to search for
	* @param  strNodeName	name of the node to search for (optional)
	* @param  strID			ID attribute of the node to search for (optional)
	* @return				the attribute of the node matching the search criteria
	**/		
	public function xtc_getAttributes(strNodeName:String, strID:String): Object
	{
		if ((strNodeName) || (strID))
			return xtc_findNode(strNodeName, strID).xtc_getAttributes();
		else
			return m_xmlnData.attributes;
	}
	
	/**
	* Obtain an XML node attribute (node Name/Type and ID are optional)
	*
	* @param  strAttribute	name of the attribute to search for
	* @param  strNodeName	name of the node to search for (optional)
	* @param  strID			ID attribute of the node to search for (optional)
	* @return				the attribute of the node matching the search criteria
	**/		
	public function xtc_getAttribute(strAttribute:String, strNodeName:String, strID:String): String
	{
		if ((strNodeName) || (strID))
			return xtc_checkXMLValue(xtc_findNode(strNodeName, strID).xtc_getAttribute(strAttribute));
		else
			return xtc_checkXMLValue(m_xmlnData.attributes[strAttribute]);
	}
	
	/**
	* Obtain a boolean XML node attribute (node Name/Type and ID are optional)
	*
	* @param  strAttribute	name of the attribute to search for
	* @param  strNodeName	name of the node to search for (optional)
	* @param  strID			ID attribute of the node to search for (optional)
	* @return				the true/false attribute of the node matching the search criteria
	**/		
	public function xtc_getBooleanAttribute(strAttribute:String, strNodeName:String, strID:String): Boolean
	{
		if (xtc_getAttribute(strAttribute, strNodeName, strID) == "true")
			return true;
		else
			return false;
	}

	/**
	* Obtain a numeric XML node attribute (node Name/Type and ID are optional)
	*
	* @param  strAttribute	name of the attribute to search for
	* @param  strNodeName	name of the node to search for (optional)
	* @param  strID			ID attribute of the node to search for (optional)
	* @return				the numeric attribute of the node matching the search criteria
	**/		
	public function xtc_getNumericAttribute(strAttribute:String, strNodeName:String, strID:String): Number
	{
		var nValue = xtc_getAttribute(strAttribute, strNodeName, strID);
		if (!isNaN(Number(nValue)))
			return Number(nValue);
		else
			return null;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//	PROPERTY-INTERACTION METHODS
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	* Get a count of the number of child nodes
	*
	* @return	the total number of children
	**/		
	public function xtc_getChildCount(Void): Number				{	return m_xmlnData.childNodes.length;					}
	
	
	/**
	* Get a handle to the first child node
	*
	* @return	the first child node.
	**/		
	public function xtc_getFirstChild(Void): _XMLNode		
	{	
		if (m_xmlnData.firstChild)
			return new _XMLNode(m_xmlnData.firstChild);			
		else
			return null;
	}
			
	
	
	/**
	* Get a handle to a specific child node
	*
	* @param   nIndex  zero-based index of the child to obtain
	* @return		   the requested child node
	**/		
	public function xtc_getChild(nIndex:Number): _XMLNode	
	{	
		if (m_xmlnData.childNodes[nIndex])
			return new _XMLNode(m_xmlnData.childNodes[nIndex]);	
		else
			return null;
	}
	
	
	/**
	* Get a handle to the parent node
	*
	* @return	the parent node
	**/		
	public function xtc_getParent(Void): _XMLNode			
	{	
		if (m_xmlnData.parentNode)
			return new _XMLNode(m_xmlnData.parentNode);			
		else
			return null;
	}
	
	
	/**
	* Get the ID of the parent node
	*
	* @return	the parent's ID attribute
	**/		
	public function xtc_getParentID(Void): String				{	return m_xmlnData.parentNode.attributes.id;				}
	
	
	/**
	* Get the next sibling node
	*
	* @return	the next sibling node
	**/	
	public function xtc_getNextSibling(Void): _XMLNode		
	{	
		if (m_xmlnData.nextSibling)
			return new _XMLNode(m_xmlnData.nextSibling);			
		else
			return null;
	}
	
	
	/**
	* Get the node tag name
	*
	* @return	the node name/type
	**/	
	public function xtc_getNodeName(Void): String				{ 	return m_xmlnData.nodeName;								}
								

	/**
	* Get the node ID
	*
	* @return	the node ID
	**/	
	public function xtc_getID(Void): String						{ 	return m_xmlnData.attributes.id;						}
	
	
	/**
	* Get the class type of this object
	*
	* @return  the class ID
	**/
	public function xtc_getClassType(Void): String 				{ 	return p_strClassID; 	}	
	
	
	/**
	* Determine if an attribute exists
	*
	* @param  strAttribute	name of the attribute to verify
	* @param  szNodeName	name of the node to query (optional)
	* @param  strID			ID attribute of the node to query (optional)
	**/		
	public function xtc_attributeExists(strAttribute:String, strNodeName:String, strID:String): Boolean
	{
		if ((strNodeName) || (strID))
			return xtc_findNode(strNodeName, strID).xtc_attributeExists(strAttribute);
		else
		{
			if (m_xmlnData.attributes[strAttribute] == undefined)
				return false;
			else
				return true;
		}
	}

	
	///////////////////////////////////////////////////////////////////////////////////////////////////
	// DATA FILTERING
	///////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	* Parse a string, based on beginning and ending tag data
	*
	* @param  strValue	  the value to analyze
	* @param  strStartTag the beginning tag to search for
	* @param  strEndTag	  the ending tag to search for
	* @return			  the parsed value
	**/		
	static function sxtc_parseString(strValue:String, strStartTag:String, strEndTag:String): String
	{
		if ((strValue == null) || (strValue == undefined))
			return "";
			
		var inStart:   Number;
		var inEnd:	   Number;
		var arrSubStr: Array = Array(2);
		do
		{
			inStart = strValue.indexOf(strStartTag);
			if (inStart >= 0)
			{
				arrSubStr[0] = strValue.substring(0, inStart);	
				inEnd    	 = strValue.indexOf(strEndTag, inStart + strStartTag.length) + strEndTag.length;
				if (inEnd > 0)
				{
					arrSubStr[1] = strValue.substring(inEnd, strValue.length);
					strValue 	 = arrSubStr[0].concat(arrSubStr[1]);
				}
				else
					break;
			}
		}while(inStart >= 0)
		
		return strValue;
	}
	
	
	/**
	* Filter the specified HTML tag
	*
	* @param  strText	the value to analyze
	* @param  strTag 	the html tag to remove
	* @return			the parsed value
	**/			
	static function sxtc_removeHTMLTag(strText:String, strTag:String): String
	{
		strText = sxtc_parseString(strText, "<" + strTag, ">");
		strText = sxtc_parseString(strText, "</" + strTag, ">");
		
		return strText;
	}
	
	/**
	* Filter the specified HTML text in preparation to writing to XML
	*
	* @param  strValue		the value to analyze
	* @param  strPAlign 	the <P> alignment attribute to parse (optional)
	* @param  arrFormatAttr the <TEXTFORMAT> attribute(s) to parse (optional)
	* @param  arrFontAttr 	the <FONT> attribute(s) to parse (optional)
	* @return				the parsed value
	**/			
	static function sxtc_filterHTMLToXML(strValue:String, strPAlign:String, arrFormatAttr:Array, arrFontAttr:Array): String
	{
		strValue = sxtc_parseString(strValue, "<TEXTFORMAT", ">");
		strValue = sxtc_parseString(strValue, "</TEXTFORMAT", ">");
		strValue = sxtc_parseString(strValue, "<FONT", ">");
		strValue = sxtc_parseString(strValue, "</FONT", ">");
		
			// Only remove paragraph tags if it's just the outter tag
		if (strPAlign)
		{
			var nPFirst: Number = strValue.indexOf("<P ALIGN=\"" + strPAlign + "\">");
			var nPNext:  Number = strValue.indexOf("<P ALIGN=\"" + strPAlign + "\">", nPFirst + 1);		
			if ((nPFirst >= 0) && (nPNext < 0))
			{
				strValue = sxtc_parseString(strValue, "<P", ">");
				strValue = sxtc_parseString(strValue, "</P", ">");
			}
		}
		
		return strValue;
	}
	
	/**
	* Filter the specified HTML text
	*
	* @param  strValue	the value to analyze
	* @return			the parsed value
	**/		
	static function sxtc_filterHTML(strValue:String): String
	{
		strValue = sxtc_parseString(strValue, "<TEXTFORMAT", ">");
		strValue = sxtc_parseString(strValue, "</TEXTFORMAT", ">");
		strValue = sxtc_parseString(strValue, "<FONT", ">");	
		strValue = sxtc_parseString(strValue, "</FONT", ">");	
		strValue = sxtc_parseString(strValue, "<P", ">");	
		strValue = sxtc_parseString(strValue, "</P", ">");
		
		return strValue;
	}
	
	
}