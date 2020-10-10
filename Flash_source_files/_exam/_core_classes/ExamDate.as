class ExamDate extends Date
{		
	public function ExamDate( str_Value:String )
	{
		if (str_Value == null)
			super();
		else
		{
			var arr_Date:Array	= str_Value.split(":");
			var n_Yr:Number		= Number(arr_Date[0]);
			var n_Mo:Number		= Number(arr_Date[1]);
			var n_Dt:Number		= Number(arr_Date[2]);
			var n_Hr:Number		= Number(arr_Date[3]);
			var n_Mi:Number		= Number(arr_Date[4]);
			var n_Sc:Number		= Number(arr_Date[5]);
			
			super(n_Yr, n_Mo, n_Dt, n_Hr, n_Mi, n_Sc);
		}
	}
	
	public function toString():String
	{
		var str_Value:String = "";
		str_Value += Timer.formatNumber(getFullYear(), 4)	+ ":";
		str_Value += Timer.formatNumber(getMonth(), 2)		+ ":";
		str_Value += Timer.formatNumber(getDate(), 2)		+ ":";
		str_Value += Timer.formatNumber(getHours(), 2)		+ ":";
		str_Value += Timer.formatNumber(getMinutes(), 2)	+ ":";
		str_Value += Timer.formatNumber(getSeconds(), 2);

		return str_Value;
	}
	
	public function subtract( edt_Value:ExamDate ):TimeSpan
	{
		var n_Yr:Number = getFullYear() - edt_Value.getFullYear();
		var n_Mo:Number = getMonth() - edt_Value.getMonth();
		var n_Dt:Number = getDate() - edt_Value.getDate();
		var n_Hr:Number = getHours() - edt_Value.getHours();
		var n_Mi:Number = getMinutes() - edt_Value.getMinutes();
		var n_Sc:Number = getSeconds() - edt_Value.getSeconds();
		
		if (n_Sc < 0)
		{
			var n_FullSc:Number = 60;
			
			n_Sc += n_FullSc;
			n_Mi --;
		}
		
		if (n_Mi < 0)
		{
			var n_FullMi:Number = 60;
			
			n_Mi += n_FullMi;
			n_Hr --;
		}
		
		if (n_Hr < 0)
		{
			var n_FullHr:Number = 24;
			
			n_Hr += n_FullHr;
			n_Dt --;
		}
		
		if (n_Dt < 0)
		{
			var n_FullDt:Number = getDaysInMonth(edt_Value.getMonth(), edt_Value.getFullYear());
			
			n_Dt += n_FullDt;
			n_Mo --;
		}

		if (n_Mo < 0)
		{
			var n_FullMo:Number = 12;
			
			n_Mo += n_FullMo;
			n_Yr --;
		}
		
			// If this date is before the date we are subtracting... (A negative time span)
		if (n_Yr < 0)
		{
			var tsp_Value:TimeSpan = edt_Value.subtract(this);
			
			return new TimeSpan("-" + tsp_Value.toString());
		}
		else
			return new TimeSpan(n_Yr + ":" + n_Mo + ":" + n_Dt + ":" + n_Hr + ":" + n_Mi + ":" + n_Sc);
	}
	
	public static function getDaysInMonth( n_Month:Number, n_Year:Number ):Number
	{
		var arr_MonthDays:Array	= [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		var n_Days:Number		= arr_MonthDays[n_Month];
		
		if (n_Month == 1 && isLeapYear(n_Year))
			n_Days ++;
			
		return n_Days;
	}
	
	public static function isLeapYear( n_Year:Number ):Boolean
	{
		return n_Year != null && n_Year % 4 == 0;
	}
}