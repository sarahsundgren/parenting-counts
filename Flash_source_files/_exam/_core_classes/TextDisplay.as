class TextDisplay extends Expandable
{		
	[Inspectable(name="Text Node" defaultValue="")]
	private var $str_TextNode:String;
	
	[Inspectable(name="AutoSize" enumeration="LEFT,CENTER,RIGHT,NONE" defaultValue="LEFT")]
	private var $str_AutoSize:String;
	
	[Inspectable(name="Initially Visible" defaultValue="true")]
	private var $b_InitiallyVisible:Boolean;
	
	[Inspectable(name="Style" defaultValue="")]
	private var $str_Style:String;
	
	public static var AUTOSIZE_LEFT					:String = "LEFT";
	public static var AUTOSIZE_CENTER				:String = "CENTER";
	public static var AUTOSIZE_RIGHT				:String = "RIGHT";
	public static var AUTOSIZE_NONE					:String = "NONE";
	
	private static var $obj_DisplayLookUp			:Object = new Object();
	
	public var onPageChange							:Function;
	
	private var $obj_TextNode						:Object;
	private var $arr_Pages							:Array;
	private var $n_PageIndex						:Number;
	private var $b_Loading							:Boolean = true;
	private var $n_NextOffset						:Number;
	private var $n_PreviousOffset					:Number;
	private var txt_Content							:TextField;
	private var btn_Next							:ExamButton;
	private var btn_Previous						:ExamButton;
	
	public static function getTextDisplay( str_ID:String ):TextDisplay
	{
		return $obj_DisplayLookUp[str_ID];
	}
	
	public function get currentPage():Number
	{
		return $n_PageIndex + 1;
	}
	
	public function get totalPages():Number
	{
		return $arr_Pages.length;
	}
	
	public function get nextButton():ExamButton
	{
		return btn_Next;
	}
	
	public function get previousButton():ExamButton
	{
		return btn_Previous;
	}
	
	public function get isLoading():Boolean
	{
		return $b_Loading;
	}
	
	public function TextDisplay()
	{
		super();
		
		$obj_DisplayLookUp[_name]	= this;
		$obj_TextNode				= _global.gInterface.getInterfaceNode($str_TextNode, "text");
		txt_Content.autoSize		= $str_AutoSize.toLowerCase();
		$n_NextOffset				= btn_Next._y - txt_Content._height;
		$n_PreviousOffset			= btn_Previous._y - txt_Content._height;
		
		if (($obj_TextNode.style != null) && ($obj_TextNode.style != ""))
			$str_Style = $obj_TextNode.style;
			
		_global.gInterface.initializeTextField(txt_Content, $str_Style);
		display();
		
		if (!$b_InitiallyVisible)
			_visible = false;
	}
	
	public function display():Void
	{
		var n_X:Number				= Number($obj_TextNode.x);
		var n_Y:Number				= Number($obj_TextNode.y);
		var n_Width:Number			= Number($obj_TextNode.width);
		var n_TallestPage:Number	= 0;
		$arr_Pages					= new Array();
		$n_PageIndex				= 0;
			
		if (!isNaN(n_X))
			_x = n_X;
		
		if (!isNaN(n_Y))
			_y = n_Y;
		
		if (!isNaN(n_Width))
			txt_Content._width = n_Width;
		
		var arr_PageNodes:Array = $obj_TextNode.xml.xtc_findChildren("page");
		
		if (arr_PageNodes.length > 0)
		{
			for (var i:Number = 0; i < arr_PageNodes.length; i ++)
			{
				txt_Content.htmlText = _global.gInterface.formatText(arr_PageNodes[i].xtc_getValue());
				
				if (txt_Content._height > n_TallestPage)
					n_TallestPage = txt_Content._height;
					
				$arr_Pages.push(arr_PageNodes[i].xtc_getValue());
			}
		}
		else
		{
			txt_Content.htmlText = _global.gInterface.formatText($obj_TextNode.value);
			
			n_TallestPage = txt_Content._height;
			
			$arr_Pages.push($obj_TextNode.value);
		}
		
		btn_Previous._y	= n_TallestPage + $n_PreviousOffset;
		btn_Next._y		= n_TallestPage + $n_NextOffset;
		
		displayText($arr_Pages[$n_PageIndex]);

		if ($obj_TextNode.audio != null)
			Audio.play($obj_TextNode.audio);
		
		onEnterFrame = function():Void
		{
			enableButtons();
			$b_Loading = false;
			delete onEnterFrame;
		}
	}
	
	private function displayText( str_Text:String ):Void
	{
		if (str_Text != null)
		{
			txt_Content.htmlText = _global.gInterface.formatText(str_Text);
			
			var n_Color:Number = Number("0x" + $obj_TextNode.color.split("#").join(""));
			
			if (!isNaN(n_Color))
				txt_Content.textColor = n_Color;
		}
		else
		{
			txt_Content.htmlText = "";
			txt_Content._height = 0;
		}
		
		onExpand();
	}
	
	private function enableButtons():Void
	{
		if ($arr_Pages.length > 0)
		{
			btn_Next.isEnabled		= $n_PageIndex < $arr_Pages.length - 1;
			btn_Previous.isEnabled	= $n_PageIndex > 0;
		}
		else
		{
			btn_Next.isEnabled		= false;
			btn_Previous.isEnabled	= false;
		}
	}
	
	public function nextPage():Void
	{
		if ($n_PageIndex < $arr_Pages.length - 1)
		{
			displayText($arr_Pages[++ $n_PageIndex]);
			enableButtons();
			onPageChange();
		}
	}
	
	public function previousPage():Void
	{
		if ($n_PageIndex > 0)
		{
			displayText($arr_Pages[-- $n_PageIndex]);
			enableButtons();
			onPageChange();
		}
	}
}