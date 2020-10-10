import mx.utils.*;

class Preloader extends MovieClip
{		
	public var onLoadComplete:Function;
	
	private var $obj_Target:Object;
	private var $b_Loaded:Boolean;
	private var mc_Fill:MovieClip;
	private var mc_Background:MovieClip;
	private var $n_Timeout:Number;
	
	public function Preloader()
	{
		_visible = false;
	}
	
	public function monitor( obj_Target:Object ):Void
	{
		$obj_Target		= obj_Target;
		$b_Loaded		= false;
		mc_Fill._width	= 0;
		onEnterFrame	= checkLoad;
		
			// Only show preloader if it takes longer than a half second
		$n_Timeout = _global.setTimeout(Delegate.create(this, checkVisibility), 500);
	}
	
	public function reset():Void
	{
		$obj_Target		= null;
		$b_Loaded		= false;
		mc_Fill._width	= 0;
		delete onEnterFrame;
		
		_global.clearTimeout($n_Timeout);
		_visible = false;
	}
	
	private function checkVisibility():Void
	{
		if (!$b_Loaded)
			_visible = true;
	}
	
	private function checkLoad():Void
	{
		var n_PercentLoaded:Number = $obj_Target.getBytesLoaded() / $obj_Target.getBytesTotal();
		mc_Fill._width = n_PercentLoaded * mc_Background._width;
		
		if (!isNaN(n_PercentLoaded) && n_PercentLoaded >= 1)
		{
			onComplete();
			delete onEnterFrame;
		}
	}
	
	private function onComplete():Void
	{
		$b_Loaded = true;
		onLoadComplete();
		onLoadComplete = null;
		
		_visible = false;
	}
}