class Expandable extends MovieClip
{		
	[Inspectable(name="Adjust Siblings" enumeration="DEFAULT,TRUE,FALSE" defaultValue="DEFAULT")]
	private var $str_AdjustSiblings:String;
	
	public static var ADJUST_DEFAULT:String = "DEFAULT";
	public static var ADJUST_TRUE:String 	= "TRUE";
	public static var ADJUST_FALSE:String 	= "FALSE";
	
	private var $arr_SiblingsBelow:Array;
	private var $n_PreviousHeight:Number;
	
	public function Expandable()
	{
		$arr_SiblingsBelow = new Array();
		
		var bAdjustSiblings:Boolean;
		
		if ($str_AdjustSiblings == ADJUST_TRUE) 
			bAdjustSiblings = true;
			// If the adjust siblings setting is set to default
			// only adjust the siblings if they are inside of a scroll pane
		else if ($str_AdjustSiblings == ADJUST_DEFAULT)
		{
			var objParent:Object = _parent;
			
			while (objParent != null && objParent != _root)
			{
				if (objParent instanceof mx.containers.ScrollPane)
				{
					bAdjustSiblings = true;
					objParent = null;
				}
				else
					objParent = objParent._parent;
			}
		}
		
		if (bAdjustSiblings)
		{
			for (var str_Asset:String in _parent)
			{
					// Make sure the item is contained in the parent and not just a reference, also that it's below this item
				if (_parent[str_Asset]._parent == _parent && _parent[str_Asset]._y != null && _parent[str_Asset]._y >= _y + _height)
					$arr_SiblingsBelow.push(_parent[str_Asset]);
			}
		}
		
		$n_PreviousHeight = _height;
	}
	
	public function onExpand():Void
	{
		var n_OffsetY:Number = _height - $n_PreviousHeight;
		
		for (var i:Number = 0; i < $arr_SiblingsBelow.length; i ++)
			$arr_SiblingsBelow[i]._y += n_OffsetY;
		
		$n_PreviousHeight = _height;
	}
}