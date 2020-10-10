class Audio extends Object
{		
	private static var $mc_Audio:MovieClip;
	
	public static var url:String;
	
	public static function play( str_URL:String ):Void
	{
		if ($mc_Audio == null)
			$mc_Audio = _root.createEmptyMovieClip("mc_Audio", _root.getNextHighestDepth());
		
		$mc_Audio.loadMovie(url + str_URL);
	}
	
	public static function stop():Void
	{
		$mc_Audio.stop();
	}
}