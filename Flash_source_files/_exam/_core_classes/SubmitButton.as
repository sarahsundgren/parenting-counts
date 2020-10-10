class SubmitButton extends ExamButton
{		
	[Inspectable(name="Allow Incomplete Submit" defaultValue="NO,YES,NO_WITH_MESSAGE" enumeration="NO")]
	private var $str_IncompleteSubmit:String;
	
	public static var INCOMPLETE_NO					:String = "NO";
	public static var INCOMPLETE_YES				:String = "YES";
	public static var INCOMPLETE_NO_WITH_MESSAGE	:String = "NO_WITH_MESSAGE";
	
	public function get allowIncompleteSubmit():String
	{
		return $str_IncompleteSubmit;
	}
}