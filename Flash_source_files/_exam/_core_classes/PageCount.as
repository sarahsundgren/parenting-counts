class PageCount extends TextDisplay
{		
	private static var arr_PageCounters:Array = new Array();
	
	public function PageCount()
	{
		super();
		arr_PageCounters.push(this);
	}
	
	public static function update():Void
	{
		var ref_PreviousCounter:PageCount;
		
		for (var i:Number = 0; i < arr_PageCounters.length; i ++)
		{
				// Clean up items that have been removed from the stage, or are duplicates
			if (arr_PageCounters[i]._parent == null || arr_PageCounters[i] == ref_PreviousCounter)
			{
				arr_PageCounters.splice(i, 1);
				i --;
			}
			else
			{
				var obj_TextNode:Object = _global.gInterface.getInterfaceNode(arr_PageCounters[i].$str_TextNode, "text");
				arr_PageCounters[i].displayText(obj_TextNode.value);
				ref_PreviousCounter = arr_PageCounters[i];
			}
		}
	}
	
	private function displayText( str_Text:String ):Void
	{
			// If no questions are loaded yet, don't display anything
		if (_global.gInterface.examEngine == null)
			str_Text = "";
			
		super.displayText(str_Text);
	}
}