package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class LevelSelector extends Sprite
	{
		private static var _loader:Loader;
		private static var screen:MovieClip = null;
		public function LevelSelector()
		{
			super();
			_loader = new Loader();
			_loader.load(new URLRequest("assets/levelSelector.swf"));
			Oreo.getInstance()._loadManager.add(_loader);
		}
		public function show():void
		{
			if(screen == null)
				screen = _loader.content as MovieClip;
			screen.cleanUp();
			
			addChild(screen);
			Oreo.getInstance().addChild(this);
			Oreo.getInstance().removeLoader();
			screen.prepare(loadLevel,Score.getScoreList());
			
		}
		public function loadLevel(level:uint):void{
			Oreo.getInstance().addLoader();
			removeChild(screen);
			Oreo.getInstance().removeChild(this);
			Oreo.getInstance().level = level;
			Oreo.getInstance().playing = true;
		}
	}
}