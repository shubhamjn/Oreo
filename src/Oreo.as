package
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.*;
	import com.citrusengine.utils.LoadManager;
	
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	[SWF(width="1024", height="768", backgroundColor="#ffffff")]
	public class Oreo extends CitrusEngine
	{
		public var levelMC:MovieClip;
		public var _loadManager:LoadManager;
		private var _level:uint = 0;
		public var levelSelector:LevelSelector;
		public var finishScreen:FinishScreen;
		
		public function Oreo()
		{
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, Score.handleInitializationArgs);
			//this.graphics.beginFill(0x000000,1);
			//this.graphics.drawRect(0,0,1024,768);
			var objects:Array = [Platform, Hero, CitrusSprite, Sensor, Baddy, Crate,
				Star, Water, MovingPlatform, BaddyReflector, TopBaddy, TopBackBaddy,
				CheckPoint, SpeechSensor];
			_loadScreen = new LoadScreen();
			addChild(_loadScreen);
			super();
			console.enabled = true;
			//setFullScreen();
			_menuLoader = new Loader();
			_loadManager = new LoadManager();
			_menuLoader.load(new URLRequest("assets/Menu.swf"));
			_loadManager.add(_menuLoader);
			Fuel.getInstance();
			Score.getInstance();
			Score.loadGame();
			stage.showDefaultContextMenu = false;
			sound.init();
			levelSelector = new LevelSelector();
			finishScreen = new FinishScreen();
			_loadManager.onLoadComplete.addOnce(handleSWFLoadComplete);
			sound.addSound("coinCollect","assets\\bleep.mp3",SoundManager.OTHER_EFFECS);
			sound.addSound("heroBounce","assets\\bounce.mp3",SoundManager.HERO_EFFECTS);
			sound.addSound("music","assets\\menu.mp3",SoundManager.MUSIC);
			sound.addSound("levelMusic","assets\\song.mp3",SoundManager.MUSIC);
			sound.addSound("crateFall","assets\\crate.mp3",SoundManager.OTHER_EFFECS);
			sound.playSound("music");
		}

		public function removeLoader():void
		{
			if(this.contains(_loadScreen))
				this.removeChild(_loadScreen);
		}
		
		public function addLoader():void
		{
			if(!this.contains(_loadScreen))
				addChild(_loadScreen);
		}
		
		private function handleSWFLoadComplete():void
		{
			menuMC = _menuLoader.content as MovieClip;
			menuMC.addEventListener("LoadLevel",loadLevelFromMenu);
			addChild(menuMC);
			removeChild(_loadScreen);
			_loadManager = null;
			
		}
		
		private function loadLevelFromMenu(e:Event):void
		{
			trace("LoadLevel: " + menuMC.level);
			//addChild(_loadScreen);
			levelSelector.show();
			removeChild(menuMC);
			//level = menuMC.level;
		}
		private function handleLevelLoadComplete(e:Event):void{
			trace("LevelLoaded");
			var levelObjectsMC:MovieClip = e.target.loader.content;
			levelMC = levelObjectsMC;
			state = new Level();
		}
		
		private function setFullScreen():void {
			try{
				if (stage.displayState== "normal") {
					stage.displayState=StageDisplayState.FULL_SCREEN_INTERACTIVE;
					if(Capabilities.screenResolutionX/Capabilities.screenResolutionY > 4/3)
						var screenRectangle:Rectangle = new Rectangle(0, 0, 1024, 640);
					else
						screenRectangle = new Rectangle(0, 0, 1024, 768);
					stage.fullScreenSourceRect = screenRectangle;
				} else {
					stage.displayState="normal";
				}
			}
			catch ( error:SecurityError ) {
				// your hide button code                        
			}
		}

		public function get level():uint
		{
			return _level;
		}

		public function set level(value:uint):void
		{
			if(value!=_level)
				CheckPoint.enabled = false;
			_level = value;
			Score.level = value;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLevelLoadComplete, false, 0, true);
			loader.load(new URLRequest("level/"+_level+"/layout.swf"));
		}
		
		public static function getInstance():Oreo
		{
			return CitrusEngine.getInstance() as Oreo;
		}
		
		private var _loadScreen:LoadScreen;
		private var menuMC:MovieClip;
		private var _menuLoader:Loader;
		
	}
}
