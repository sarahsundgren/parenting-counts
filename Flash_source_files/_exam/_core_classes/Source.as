class Source extends MovieClip
{		
	private var $xml_Data:_XMLNode;
	private var $n_AnchorSpacing:Number;
	private var $n_PreDragX:Number;
	private var $n_PreDragY:Number;
	private var $n_Width:Number;
	private var $str_Style:String;
	private var $n_Height:Number;
	private var $n_Index:Number;
	private var $n_Match:Number;
	private var $mc_Target:Target;
	private var $qst_Parent:Question;
	private var txt_Content:TextField;
	private var mc_DragItem:MovieClip;
	
	public function set xml( xml_Content:_XMLNode ):Void
	{
		$xml_Data = xml_Content;
	}
	
	public function get xml():_XMLNode
	{
		return $xml_Data;
	}
	
	public function set enabled( b_Enabled:Boolean ):Void
	{
		super.enabled = b_Enabled;
		
		dragItem.enabled = b_Enabled;
		dragItem.gotoAndStop(b_Enabled ? "_up" : "_disabled");
	}
	
	public function get dragArea():MovieClip
	{
		return mc_DragItem;
	}
	
	public function get dragItem():MovieClip
	{
		return mc_DragItem.mc_Drag;
	}
	
	public function get preDragX():Number
	{
		return $n_PreDragX;
	}
	
	public function get preDragY():Number
	{
		return $n_PreDragY;
	}
	
	public function get line():MovieClip
	{
		return mc_DragItem.mc_Line;
	}
	
	public function get anchor():MovieClip
	{
		return mc_DragItem.mc_Anchor;
	}
	
	public function get text():String
	{
		return txt_Content.text;
	}
	
	public function set text( str_Text:String ):Void
	{
		var nWidth:Number = txt_Content._width;
		
		txt_Content.multiline	= false;
		txt_Content.wordWrap	= false;
		txt_Content.htmlText = "<p align='right'>" + str_Text + "</p>";
		
		if (txt_Content._width > nWidth)
		{
			txt_Content.multiline	= true;
			txt_Content.wordWrap	= true;
			txt_Content._width		= nWidth;
			txt_Content._x			= 0;
		}
			// Store original height, because we don't want to include the drag ball position when measuring
		$n_Height = _height;
	}
	
	public function get question():Question
	{
		return $qst_Parent;
	}
	
	public function set question( qst_Parent:Question ):Void
	{
		$qst_Parent = qst_Parent;
	}
	
	public function set width( n_Width:Number ):Void
	{
		$n_Width = n_Width;
		mc_DragItem._x	= $n_Width - mc_DragItem._width;
		txt_Content._x		= 0;
		txt_Content._width	= mc_DragItem._x - $n_AnchorSpacing - txt_Content._x;
	}
	
	public function get width():Number
	{
		return $n_Width;
	}
	
	public function get height():Number
	{
		return $n_Height;
	}
	
	public function set index( n_Index:Number ):Void
	{
		$n_Index = n_Index;
	}
	
	public function get index():Number
	{
		return $n_Index;
	}
	
	public function set match( n_Match:Number ):Void
	{
		$n_Match = n_Match;
	}
	
	public function get match():Number
	{
		return $n_Match;
	}
	
	public function set target( mc_Target:Target ):Void
	{
		$mc_Target = mc_Target;
	}
	
	public function get target():Target
	{
		return $mc_Target;
	}
	
	public function get isAnswered():Boolean
	{
		return target != null;
	}
	
	public function Source()
	{
		txt_Content.autoSize	= "right";
		txt_Content.multiline	= true;
		txt_Content.wordWrap	= true;
		txt_Content.html		= true;
		_global.gInterface.initializeTextField(txt_Content, $str_Style);
		
		$n_AnchorSpacing	= mc_DragItem._x - txt_Content._width;
		$n_PreDragX			= dragItem._x;
		$n_PreDragY			= dragItem._y;
		dragItem.stop();
		
			// Store original height, because we don't want to include the drag ball position when measuring
		$n_Height = _height;
	}
	
	public function grade():Boolean
	{
		return target.index == match;
	}
	
	public function showGradeMark():Void
	{
		var obj_CorrectNode:Object		= _global.gInterface.getInterfaceNode("correct", "styles");
		var obj_IncorrectNode:Object	= _global.gInterface.getInterfaceNode("incorrect", "styles");
		
		if (target.index == match)
		{
			if (obj_CorrectNode != null)
				Question.tintClip(line, obj_CorrectNode.color, 100);
		}
		else
		{
			if (obj_IncorrectNode != null)
				Question.tintClip(line, obj_IncorrectNode.color, 100);
		}
	}
}