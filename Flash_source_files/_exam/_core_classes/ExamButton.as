import mx.utils.*;

class ExamButton extends MovieClip
{		
	[Inspectable(name="Interface Label" defaultValue="")]
	private var $str_InterfaceLabel:String;
	
	[Inspectable(name="Initially Enabled" defaultValue="false")]
	private var $b_InitiallyEnabled:Boolean;
	
	[Inspectable(name="onRelease Event" defaultValue="")]
	private var $str_OnRelease:String;
	
	private var $str_Label:String;
	private var $fn_OnRelease:Function;
	
	private var mc_Content:MovieClip;
	private var txt_Label:TextField;
	
	public function set isEnabled( b_Enabled:Boolean ):Void
	{
		enabled = b_Enabled;
		gotoAndStop(b_Enabled ? "_up" : "_disabled");
	}
	
	public function gotoAndStop( obj_Frame:Object ):Void
	{
		if (!enabled)
			obj_Frame = "_disabled";
			
		super.gotoAndStop(obj_Frame);
		mc_Content.content.content.gotoAndStop(obj_Frame);
		mc_Content.content.content.txt_Label.htmlText = $str_Label;
		txt_Label.htmlText = $str_Label;
	}
	
	public function onRollOver():Void
	{
		gotoAndStop("_over");
	}
	
	public function onDragOver():Void
	{
		gotoAndStop("_over");
	}
	
	public function onRollOut():Void
	{
		gotoAndStop("_up");
	}
	
	public function onDragOut():Void
	{
		gotoAndStop("_up");
	}
	
	public function onPress():Void
	{
		gotoAndStop("_down");
	}
	
	public function onRelease():Void
	{
		$fn_OnRelease();
		gotoAndStop("_up");
	}
	
	private static var $obj_ButtonLookUp:Object = new Object();
	
	public function ExamButton()
	{
		$obj_ButtonLookUp[_name] = this;
		
		isEnabled = $b_InitiallyEnabled;
		
		var objl_LabelNode:Object = _global.gInterface.getInterfaceNode($str_InterfaceLabel, "buttons");
		var n_nodeX:Number;
		var n_nodeY:Number;
		
		if (objl_LabelNode.value == null)
			$str_Label = "";
		else
		{
			n_nodeX		= Number(objl_LabelNode.x);
			n_nodeY		= Number(objl_LabelNode.y);
			$str_Label	= objl_LabelNode.value;
		}
		
		_global.gInterface.initializeTextField(txt_Label);
		txt_Label.htmlText = $str_Label;
		
		if (!isNaN(n_nodeX))
			_x = n_nodeX;
		
		if (!isNaN(n_nodeY))
			_y = n_nodeY;
		
		var ref_ReleaseTarget:MovieClip;
		var str_FunctionName:String;
		
		if ($str_OnRelease.indexOf(".") < 0)
		{
			ref_ReleaseTarget = _global.gInterface;
			str_FunctionName = $str_OnRelease;
		}
		else
		{
			var arr_OnRelease:Array = $str_OnRelease.split(".");
			
			if (this[arr_OnRelease[0]] != null)
				ref_ReleaseTarget = this[arr_OnRelease[0]];
			else
				ref_ReleaseTarget = _global.gInterface;
				
			str_FunctionName = arr_OnRelease[1];
		}

		mc_Content._visible		= false;
		mc_Content.onImageLoad	= Delegate.create(this, onContentLoaded);
		$fn_OnRelease			= Delegate.create(ref_ReleaseTarget, ref_ReleaseTarget[str_FunctionName]);
	}
	
	private function onContentLoaded():Void
	{
		gotoAndStop(enabled ? "_up" : "_disabled");
		mc_Content._visible = true;
	}
	
	public static function getButton( str_ID:String ):ExamButton
	{
		return $obj_ButtonLookUp[str_ID];
	}
}