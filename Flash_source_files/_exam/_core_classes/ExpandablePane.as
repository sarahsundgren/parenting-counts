import mx.containers.*;

class ExpandablePane extends ScrollPane
{		
	private var $arr_SiblingsBelow:Array;
	private var $n_PreviousHeight:Number;
	
	private var $n_OriginalWidth:Number;
	private var $n_OriginalHeight:Number;
	
	public function get minWidth():Number
	{
		return 20;
	}
	
	public function get minHeight():Number
	{
		return 40;
	}
	
	public function get originalWidth():Number
	{
		return $n_OriginalWidth;
	}
	
	public function get originalHeight():Number
	{
		return $n_OriginalHeight;
	}
	
	public function get sizeGuide():MovieClip
	{
		return content.mc_SizeGuide;
	}
	
	public function ExpandablePane()
	{

	}
	
	public function expandTo( n_Width:Number, n_Height:Number ):Void
	{
		setSize(n_Width, n_Height);
		
		if (n_Height != null)
		{
			var n_OffsetY:Number = n_Height - $n_PreviousHeight;
			
			for (var i:Number = 0; i < $arr_SiblingsBelow.length; i ++)
				$arr_SiblingsBelow[i]._y += n_OffsetY;
				
			$n_PreviousHeight = n_Height;
		}
	}
	
	public function setSize( n_Width:Number, n_Height:Number ):Void
	{
		if ($n_PreviousHeight == null)
		{
			$arr_SiblingsBelow = new Array();
			
			for (var str_Asset:String in _parent)
			{
				if (_parent[str_Asset]._y != null && _parent[str_Asset]._y >= _y + n_Height)
					$arr_SiblingsBelow.push(_parent[str_Asset]);
			}
			
			$n_OriginalWidth	= n_Width;
			$n_OriginalHeight	= n_Height;
			$n_PreviousHeight	= n_Height;
		}
		
		sizeGuide._width	= n_Width;
		sizeGuide._height	= n_Height;
		super.setSize(n_Width, n_Height);
	}
	
	public function destroy():Void
	{
		this.destroyObject();
		this.removeMovieClip();
	}
}