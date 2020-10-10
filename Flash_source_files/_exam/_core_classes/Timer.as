import mx.utils.*;

class Timer extends TextDisplay
{		
	private static var arr_Timers:Array = new Array();
	private static var $n_TimeLimit:Number;
	private static var $n_TimeRemaining:Number;
	private static var $n_Interval:Number;
	private static var $n_PreviousSecond:Number;
	private static var $fn_Complete:Function;
	private static var $b_Paused:Boolean;
	
	public static function get inUse():Boolean
	{
		return arr_Timers.length > 0;
	}
	
	public function Timer()
	{
		super();
		arr_Timers.push(this);
		$b_Loading = false;
	}

	public function display():Void
	{
		if ($n_TimeRemaining != null)
		{
			var obj_TextNode:Object		= _global.gInterface.getInterfaceNode($str_TextNode, "text");
			var str_Format:String		= obj_TextNode.value;
			var n_Seconds:Number		= $n_TimeRemaining;
			var n_Minutes:Number;
	
				// If the minutes are displayed, calculate them and remove them from the seconds
			if (str_Format.indexOf("{#MINUTESREMAINING}") >= 0)
			{
				n_Minutes = Math.floor($n_TimeRemaining / 60);
				n_Seconds %= 60;
			}
			
			str_Format = str_Format.split("{#MINUTESREMAINING}").join(formatNumber(n_Minutes, 2)).split("{#SECONDSREMAINING}").join(formatNumber(n_Seconds, 2));
			displayText(str_Format);
			onExpand();
		}
	}
	
	public static function update():Void
	{
		var ref_PreviousTimer:Timer;
		
		for (var i:Number = 0; i < arr_Timers.length; i ++)
		{
				// Clean up items that have been removed from the stage, or are duplicates
			if (arr_Timers[i]._parent == null || arr_Timers[i] == ref_PreviousTimer)
			{
				arr_Timers.splice(i, 1);
				i --;
			}
			else
			{
				arr_Timers[i].display();
				ref_PreviousTimer = arr_Timers[i];
			}
		}
	}
	
	public static function set timeLimit( n_TimeLimit:Number ):Void
	{
		$n_TimeLimit		= n_TimeLimit;
		$n_TimeRemaining	= n_TimeLimit;
		update();
	}
	
	public static function start( fn_Complete:Function ):Void
	{
		$fn_Complete		= fn_Complete;
		$n_PreviousSecond	= null;
		$n_Interval			= setInterval(Delegate.create(Timer, checkTime), 100);
	}
	
	public static function pause():Void
	{
		$b_Paused = true;
	}
	
	public static function resume():Void
	{
		$b_Paused = false;
	}
	
	public static function stop():Void
	{
		clearInterval($n_Interval);
	}
	
	private static function checkTime():Void
	{
		if (!$b_Paused)
		{
				// Verify that an entire second has passed, because setting the interval to 1000 milleseconds is unreliable
			var n_CurrentSecond:Number = new Date().getSeconds();
			
			if ($n_PreviousSecond != null && $n_PreviousSecond != n_CurrentSecond)
			{
				$n_TimeRemaining --;
				update();
				
				if ($n_TimeRemaining <= 0)
				{
					clearInterval($n_Interval);
					$fn_Complete();
				}
			}
			
			$n_PreviousSecond = n_CurrentSecond;
		}
	}
	
	public static function formatNumber( n_Value:Number, n_Digits:Number ):String
	{
		var str_Value:String = n_Value.toString();
		
		while (str_Value.length < n_Digits)
			str_Value = "0" + str_Value;
			
		return str_Value;
	}
}