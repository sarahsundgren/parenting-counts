class TimeSpan extends Object
{		
	private var $str_Value:String;
	private var $b_Negative:Boolean;
	
	public function TimeSpan( str_Value:String )
	{
			// Strip out any negative signs
		if (str_Value.indexOf("-") >= 0)
		{
			$b_Negative = true;
			str_Value = str_Value.split("-").join("");
		}
		
		var arr_TimeSpan:Array = str_Value.split(":");
		arr_TimeSpan[0] = Timer.formatNumber(Number(arr_TimeSpan[0]), 4);
		arr_TimeSpan[1] = Timer.formatNumber(Number(arr_TimeSpan[1]), 2);
		arr_TimeSpan[2] = Timer.formatNumber(Number(arr_TimeSpan[2]), 2);
		arr_TimeSpan[3] = Timer.formatNumber(Number(arr_TimeSpan[3]), 2);
		arr_TimeSpan[4] = Timer.formatNumber(Number(arr_TimeSpan[4]), 2);
		arr_TimeSpan[5] = Timer.formatNumber(Number(arr_TimeSpan[5]), 2);
		
		$str_Value = arr_TimeSpan.join(":");
	}
	
	public function toString():String
	{
		if ($b_Negative)
			return "-" + $str_Value;
			
		return $str_Value;
	}
	
	public function equals( tsp_Value:TimeSpan ):Boolean
	{
		return $str_Value == tsp_Value.$str_Value && $b_Negative == tsp_Value.$b_Negative;
	}
	
	public function isGreaterThan( tsp_Value:TimeSpan ):Boolean
	{
		var arr_Comparisons:Array = ["getYears", "getMonths", "getDays", "getHours", "getMinutes", "getSeconds"];
		
			// Read the TimeSpan from left to right, the first value that's different determines the relationship
		for (var i:Number = 0; i < arr_Comparisons.length; i ++)
		{
			if (this[arr_Comparisons[i]]() > tsp_Value[arr_Comparisons[i]]())
				return true;
			else if (this[arr_Comparisons[i]]() < tsp_Value[arr_Comparisons[i]]())
				return false;
		}
		
			// They were exactly the same
		return false;
	}
	
	public function getYears():Number
	{
		if ($b_Negative)
			return - Number($str_Value.split(":")[0]);
		
		return Number($str_Value.split(":")[0]);
	}
	
	public function getMonths():Number
	{
		if ($b_Negative)
			return - Number($str_Value.split(":")[1]);
		
		return Number($str_Value.split(":")[1]);
	}
	
	public function getDays():Number
	{
		if ($b_Negative)
			return - Number($str_Value.split(":")[2]);
		
		return Number($str_Value.split(":")[2]);
	}
	
	public function getHours():Number
	{
		if ($b_Negative)
			return - Number($str_Value.split(":")[3]);
		
		return Number($str_Value.split(":")[3]);
	}
	
	public function getMinutes():Number
	{
		if ($b_Negative)
			return - Number($str_Value.split(":")[4]);
		
		return Number($str_Value.split(":")[4]);
	}
	
	public function getSeconds():Number
	{
		if ($b_Negative)
			return - Number($str_Value.split(":")[5]);
		
		return Number($str_Value.split(":")[5]);
	}
}