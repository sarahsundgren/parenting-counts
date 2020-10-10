class QuestionTF extends QuestionMC
{		
	public function get SCORMType():String
	{
		return "true-false";
	}
	
	public function get currentResponse():String
	{
		if ($arr_OrderedOptions[0].isSelected)
			return "t";
		else if ($arr_OrderedOptions[1].isSelected)
			return "f";
			
		return "";
	}
	
	public function get correctResponse():String
	{
		var xml_Options	:_XMLNode	= $xml_Data.xtc_findNode("foils");
		var arr_Options	:Array	  	= xml_Options.xtc_findChildren("foil");
		
		return arr_Options[0].xtc_getBooleanAttribute("correct") ? "t" : "f";
	}
	
	public function get randomizeOptions():Boolean
	{
		return false;
	}
	
	public function QuestionTF( qp_Engine:QuestionPool, xml_Data:_XMLNode, xml_Config:_XMLNode, str_Response:String )
	{
		super(qp_Engine, xml_Data, xml_Config, str_Response);
	}
}