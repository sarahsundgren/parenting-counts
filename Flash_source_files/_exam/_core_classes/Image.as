class Image extends DynamicMC
{
	public static var url:String;
	
	private var $mcl_Display:MovieClipLoader;
	private var $fn_OnError:Function;
	private var $b_Loaded:Boolean;
	private var $b_Initialized:Boolean;
	private var $n_BytesLoaded:Number;
	private var $n_BytesTotal:Number;
	private var $str_URL:String;
	
	public var onLoad:Function;
	
	public function get bytesLoaded():Number
	{
		return $n_BytesLoaded;
	}
	
	public function get bytesTotal():Number
	{
		return $n_BytesTotal;
	}
	
	public function set onError( fn_OnError:Function ):Void
	{
		$fn_OnError = fn_OnError;
	}
	
	public function get isLoaded():Boolean
	{
		return $b_Loaded && $b_Initialized;
	}
	
	public function get imageURL():String
	{
		return url + $str_URL;
	}
	
	public function Image()
	{
		$mcl_Display = new MovieClipLoader();
		$mcl_Display.addListener(this);
	}
	
	public function display( mc_ContentArea:MovieClip, url_Image:String ):Void
	{
		super.display(mc_ContentArea);

		$b_Loaded		= false;
		$b_Initialized	= false;
		$n_BytesLoaded	= null;
		$n_BytesTotal	= null;
		$str_URL		= url_Image;
		$mcl_Display.loadClip(url + $str_URL, $mc_Display);
	}
	
	private function onLoadInit( mc_Target:MovieClip, n_StatusHTTP:Number):Void
	{
		$b_Initialized = true;
		
		if ($b_Loaded && $b_Initialized)
			onLoad();
	}
	
	private function onLoadError( mc_Target:MovieClip, str_ErrorCode:String, n_StatusHTTP:Number ):Void
	{
		$fn_OnError();
	}
	
	private function onLoadProgress( mc_Target:MovieClip, n_BytesLoaded:Number, n_BytesTotal:Number ):Void
	{
		$n_BytesLoaded	= n_BytesLoaded;
		$n_BytesTotal	= n_BytesTotal;
		
		if ($n_BytesLoaded >= $n_BytesTotal)
		{
			$b_Loaded = true;
			
			if ($b_Loaded && $b_Initialized)
				onLoad();
		}
	}
}