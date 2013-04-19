package
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.core.State;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.platformer.CheckPoint;
	import com.citrusengine.objects.platformer.Hero;
	import com.citrusengine.objects.platformer.SpeechSensor;
	import com.citrusengine.objects.platformer.Star;
	import com.citrusengine.physics.Box2D;
	import com.citrusengine.utils.ObjectMaker;
	import com.citrusengine.view.ExternalArt;
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	public class Level extends State
	{
		private var _objectsMC:MovieClip;
		private var _hero:Hero;
		private var oreo:Oreo;
		private var _score:Score;
		private var _mFactor:Number;
		
		public function Level()
		{
			super();
			oreo = CitrusEngine.getInstance() as Oreo;
			_objectsMC = oreo.levelMC;
			_score = Score.getInstance();
			_mFactor = 1;
			CitrusObject.resetObj();
		}
		
		public function set mFactor(value:Number):void
		{
			_mFactor = value;
			this.scaleX = mFactor;
			this.scaleY = mFactor;
			Score.getInstance().scale = value;
			Fuel.getInstance().scale = value;
		}

		public function get mFactor():Number
		{
			return _mFactor;
		}

		override public function initialize():void
		{	
			var box2D:Box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);
			view.loadManager.onLoadComplete.addOnce(handleLoadComplete);
			SpeechSensor.reset();
			ObjectMaker.FromMovieClip(_objectsMC);
			mFactor = _objectsMC.multFactor;
			_hero = getFirstObjectByType(Hero) as Hero;	
			Score.totalStars = getObjectsByType(Star).length;
			view.setupCamera(_hero, new MathVector(_objectsMC.heroX, _objectsMC.heroY), new Rectangle(_objectsMC.startX, _objectsMC.startY, _objectsMC.endX - _objectsMC.startX, _objectsMC.endY - _objectsMC.startY), new MathVector(_objectsMC.easeX, _objectsMC.easeY));
			
			ExternalArt.smoothBitmaps = true;
			addChild(Fuel.getInstance());
			addChild(_score);
			Score.sparePacks = _objectsMC.nJetPack;
			Fuel.totalFuel =  _objectsMC.totalFuel;
			Fuel.currentFuel = _objectsMC.initialFuel;
			//Mouse.hide();
			oreo.stage.addEventListener(KeyboardEvent.KEY_DOWN,pauseGame);
			Hero.jetEnabled = true;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			Score.update(timeDelta);
		}
		 
		private function handleLoadComplete():void
		{
			CheckPoint.restore();
			oreo.addChild(LevelScreen.get());
			SoundManager.getInstance().stopSoundByCategory(SoundManager.MUSIC);
			SoundManager.getInstance().stopSound("levelMusic");
			SoundManager.getInstance().playSound("levelMusic");
			
		}
		
		private function pauseGame(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.SPACE)
				oreo.addChild(LevelScreen.get(true));
		}


	}
}
