import mx.utils.*;

class ImageDisplay extends MovieClip
{		
	private static var arr_ImageDisplays			:Array = new Array();

	[Inspectable(name="Image Node" defaultValue="")]
	private var $str_ImageNode:String;
	
	private var $b_Loading							:Boolean = true;
	private var $img_Content						:Image;
	
	public var onImageLoad							:Function;
	
	public static function get isDisplayLoading():Boolean
	{
		var b_Loading:Boolean = false;
		var ref_ImageDisplay:ImageDisplay;
		
		for (var i:Number = 0; i < arr_ImageDisplays.length; i ++)
		{
				// Clean up items that have been removed from the stage, or are duplicates
			if (arr_ImageDisplays[i]._parent == null || arr_ImageDisplays[i] == ref_ImageDisplay)
			{
				arr_ImageDisplays.splice(i, 1);
				i --;
			}
			else if (arr_ImageDisplays[i].isLoading)
			{
				b_Loading = true;
				ref_ImageDisplay = arr_ImageDisplays[i];
			}
		}

		return b_Loading;
	}
	
	public function get content():Image
	{
		return $img_Content;
	}
	
	public function get isLoading():Boolean
	{
		return $b_Loading;
	}
	
	public function ImageDisplay()
	{
		super();
		display();
		arr_ImageDisplays.push(this);
	}
	
	public function display():Void
	{
		var obj_ImageNode:Object	= _global.gInterface.getInterfaceNode($str_ImageNode, "images");
		var url_Image:String		= obj_ImageNode.value;
		
		$img_Content 			= new Image();
		$img_Content.onLoad		= Delegate.create(this, onImageLoaded);
		$img_Content.onError	= Delegate.create(this, onImageError);
		$img_Content.display(this, url_Image);
	}
	
	private function onImageLoaded():Void
	{
		$b_Loading	= false;
		onImageLoad();
	}
	
	private function onImageError():Void
	{
		$b_Loading = false;
	}
}