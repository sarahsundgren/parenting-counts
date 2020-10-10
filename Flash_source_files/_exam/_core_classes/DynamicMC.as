class DynamicMC extends Object
{
	private var $mc_Display:MovieClip;
	private var $n_X:Number;
	private var $n_Y:Number;
	private var $n_Width:Number;
	private var $n_Height:Number;
	
	public function set enabled( b_Enabled:Boolean ):Void
	{
		$mc_Display.enabled = b_Enabled;
	}
	
	public function get enabled():Boolean
	{
		return $mc_Display.enabled;
	}
	
	public function set onRelease( fn_OnRelease:Function ):Void
	{
		$mc_Display.onRelease = fn_OnRelease;
	}
	
	public function get onRelease():Function
	{
		return $mc_Display.onRelease;
	}
	
	public function set width( n_Value:Number ):Void
	{
		$n_Width = n_Value;
		$mc_Display._width = n_Value;
	}
	
	public function get width():Number
	{
		return $mc_Display._width;
	}
	
	public function set height( n_Value:Number ):Void
	{
		$n_Height = n_Value;
		$mc_Display._height = n_Value;
	}
	
	public function get height():Number
	{
		return $mc_Display._height;
	}
	
	public function get fullWidth():Number
	{
		return $mc_Display._width / ($mc_Display._xscale / 100);
	}
	
	public function get fullHeight():Number
	{
		return $mc_Display._height / ($mc_Display._yscale / 100);
	}
	
	public function set x( n_Value:Number ):Void
	{
		$n_X = n_Value;
		$mc_Display._x = n_Value;
	}
	
	public function get x():Number
	{
		return $mc_Display._x;
	}
	
	public function set y( n_Value:Number ):Void
	{
		$n_Y = n_Value;
		$mc_Display._y = n_Value;
	}
	
	public function get y():Number
	{
		return $mc_Display._y;
	}
	
	public function set scaleX( n_Value:Number ):Void
	{
		$mc_Display._xscale = n_Value;
	}
	
	public function get scaleX():Number
	{
		return $mc_Display._xscale;
	}
	
	public function set scaleY( n_Value:Number ):Void
	{
		$mc_Display._yscale = n_Value;
	}
	
	public function get scaleY():Number
	{
		return $mc_Display._yscale;
	}
	
	public function get content():MovieClip
	{
		return $mc_Display;
	}
	
	public function display( mc_ContentArea:MovieClip ):Void
	{
		var n_Depth:Number = mc_ContentArea.getNextHighestDepth();
		
		$mc_Display	= mc_ContentArea.createEmptyMovieClip("mc_Display" + n_Depth, n_Depth);
		$mc_Display._x		= $n_X;
		$mc_Display._y		= $n_Y;
	}
	
	public function destroy():Void
	{
		$mc_Display.removeMovieClip();
	}
}