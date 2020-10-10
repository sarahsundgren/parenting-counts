stop();
preload();

function preload():Void
{
		// If were inside of Mamba hide the exam, they shouldn't see the preloader (Hide the entire exam)
	if (_root._SHELL_LOADED_)
		_visible = false;


	mc_Preloader.mc_Fill._width = 0;
	onEnterFrame = checkLoad;
}
	
function checkLoad():Void
{
	var n_PercentLoaded:Number = getBytesLoaded() / getBytesTotal();
	
	mc_Preloader.mc_Fill._width = n_PercentLoaded * mc_Preloader.mc_Background._width;
	
	if (n_PercentLoaded >= 1)
	{
		delete onEnterFrame;
		play();
	}
}