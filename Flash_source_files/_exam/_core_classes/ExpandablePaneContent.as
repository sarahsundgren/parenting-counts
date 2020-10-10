import mx.containers.*;
import mx.managers.*;
import mx.utils.*;

class ExpandablePaneContent extends MovieClip
{		
	[Inspectable(name="onLoad Event" defaultValue="expandablePaneLoaded")]
	private var $str_OnLoad:String;
	
	private static var NAME_SCROLLPANECONTENT:String	= "spContentHolder";
	private static var DEPTH_CONTENT_PANE:Number		= 0;
	private static var DEPTH_REMOVAL:Number				= 15;
	
	private var $pane_Container:ExpandablePane;
	private var mc_SizeGuide:MovieClip;
	
	public function get expandablePaneLoaded():Boolean
	{
		if ($pane_Container.content == null)
			return false;
		
		var b_Loading:Boolean;
		
		for (var str_Prop:String in $pane_Container.content)
		{
			if ($pane_Container.content[str_Prop].isLoading)
			{
				b_Loading = true;
				break;
			}
		}
		
		return !b_Loading;
	}
	
	public function ExpandablePaneContent()
	{
			// If this is already inside of a scroll pane don't create one
		if (_name == NAME_SCROLLPANECONTENT)
		{
			mc_SizeGuide._width		= 0;
			mc_SizeGuide._height	= 0;
		}
		else
		{
			_visible = false;
			
			var obj_Interface:Object	= _global.gInterface.getInterfaceNode("scroll_areas");
			var n_GlobalX:Number		= Number(obj_Interface.x);
			var n_GlobalY:Number		= Number(obj_Interface.y);
			var n_GlobalW:Number		= Number(obj_Interface.width);
			var n_GlobalH:Number		= Number(obj_Interface.height);
			var n_X:Number				= _x;
			var n_Y:Number				= _y;
			var n_Width:Number			= _width;
			var n_Height:Number			= _height;
			
			if (mc_SizeGuide != null)
			{
				n_Width		= mc_SizeGuide._width;
				n_Height	= mc_SizeGuide._height;
			}

			if (!isNaN(n_GlobalX))
			{
				n_Width	+= n_X - n_GlobalX;
				n_X		= n_GlobalX;
			}
			
			if (!isNaN(n_GlobalY))
			{
				n_Height	+= n_Y - n_GlobalY;
				n_Y			= n_GlobalY;
			}
			
			if (!isNaN(n_GlobalW))
				n_Width = n_GlobalW;
			
			if (!isNaN(n_GlobalH))
				n_Height = n_GlobalH;

			$pane_Container = ExpandablePane(_parent.attachMovie("comp_ExpandablePane", "pane_" + _name, DEPTH_CONTENT_PANE));
			$pane_Container.setStyle("borderStyle", "none");
			$pane_Container.move(n_X, n_Y);
			$pane_Container.setSize(Math.round(n_Width), Math.round(n_Height));
			$pane_Container.hScrollPolicy = "off";
			$pane_Container._visible = false;
			onEnterFrame = Delegate.create(this, monitorLoad);
			
				// The name must be assigned the same value as the linkage id for this to work!!
			$pane_Container.contentPath = _name;
		}
	}
	
	private function monitorLoad():Void
	{
		if (expandablePaneLoaded)
		{
			delete onEnterFrame;
			
			var ref_ReleaseTarget:MovieClip;
			var str_FunctionName:String;
			
			if ($str_OnLoad.indexOf(".") < 0)
			{
				ref_ReleaseTarget = _global.gInterface;
				str_FunctionName = $str_OnLoad;
			}
			else
			{
				var arr_OnLoad:Array = $str_OnLoad.split(".");
				
				if (this[arr_OnLoad[0]] != null)
					ref_ReleaseTarget = this[arr_OnLoad[0]];
				else
					ref_ReleaseTarget = _global.gInterface;
					
				str_FunctionName = arr_OnLoad[1];
			}
			
			ref_ReleaseTarget[str_FunctionName]($pane_Container);

				// Cleean up this placeholder
			this.swapDepths(DEPTH_REMOVAL);
			this.removeMovieClip();
		}
	}
}