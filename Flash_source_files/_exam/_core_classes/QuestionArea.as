class QuestionArea extends Expandable
{		
	[Inspectable(name="Spacing Between Questions" defaultValue="40")]
	private var $n_QuestionSpacing:Number;
	
	[Inspectable(name="Graphic Spacing" defaultValue="10")]
	private var $n_GraphicSpacing:Number;
	
	[Inspectable(name="Direction Spacing" defaultValue="5")]
	private var $n_DirectionSpacing:Number;
	
	[Inspectable(name="Vertical Option Spacing" defaultValue="5")]
	private var $n_VerticalOptionSpacing:Number;
	
	[Inspectable(name="Horizontal Option Spacing" defaultValue="10")]
	private var $n_HorizontalOptionSpacing:Number;
	
	[Inspectable(name="Horizontal Group Spacing" defaultValue="60")]
	private var $n_HorizontalGroupSpacing:Number;
	
	[Inspectable(name="Feedback Sapcing" defaultValue="5")]
	private var $n_FeedbackSpacing:Number;
	
	private var mc_Guide:Guide;
	
	public function get questionSpacing():Number
	{
		return $n_QuestionSpacing;
	}
	
	public function get graphicSpacing():Number
	{
		return $n_GraphicSpacing;
	}
	
	public function get directionSpacing():Number
	{
		return $n_DirectionSpacing;
	}
	
	public function get verticalOptionSpacing():Number
	{
		return $n_VerticalOptionSpacing;
	}
	
	public function get horizontalOptionSpacing():Number
	{
		return $n_HorizontalOptionSpacing;
	}
	
	public function get horizontalGroupSpacing():Number
	{
		return $n_HorizontalGroupSpacing;
	}
	
	public function get feedbackSpacing():Number
	{
		return $n_FeedbackSpacing;
	}
	
	public function QuestionArea()
	{
		//_visible = false;
		
		mc_Guide._width		= _width;
		mc_Guide._height	= _height;
		_xscale = _yscale	= 100;
	}
}