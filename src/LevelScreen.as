package
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.objects.platformer.Hero;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	public class LevelScreen extends Sprite
	{
		private static var _instance:LevelScreen;
		private var _levelNo:TextField;
		private var _totalFuel:TextField;
		private var _pressText:TextField;
		private var oreo:Oreo;
		private var _timer:Timer;
		private var pauseMode:Boolean;
		public function LevelScreen(pvt:PrivateClass,pauseMode:Boolean = false)
		{
			super();
			this.pauseMode = pauseMode;
			//Mouse.show();
			oreo = CitrusEngine.getInstance() as Oreo;
			oreo.removeLoader();
			oreo.playing = false;
			//Added Faded Level
			var bmp:Bitmap= new Bitmap( Utils.getBitmapData(oreo));
			addChild(bmp);
			var myBlur:BlurFilter = new BlurFilter();
			bmp.filters = [myBlur];
			
			//Add text field - Level No
			_levelNo = new TextField;
			_levelNo.type = TextFieldType.DYNAMIC;
			if(!pauseMode)
				_levelNo.text = "Level " + oreo.level.toString();
			else
				_levelNo.text = "Game Paused";
			_levelNo.width = this.width;
			_levelNo.setTextFormat(new TextFormat("Arial",100,0x000000,true,false,false,null,null,TextFormatAlign.CENTER));
			_levelNo.selectable = false;
			_levelNo.x = 20;
			_levelNo.filters = [new GlowFilter(0x000000)];
			addChild(_levelNo);
			_levelNo.y = 100;
			
			
			//Add text field maximum fuel
			_totalFuel = new TextField();
			_totalFuel.type = TextFieldType.DYNAMIC;
			_totalFuel.selectable = false;
			_totalFuel.height = 200;
			if(!pauseMode)
				{
				_totalFuel.text = "Maximum Fuel   :" + Fuel.totalFuel.toString() + "\n\n"
								+ "No of Jet Packs:" + Score.sparePacks.toString() + "\n\n"
								+ "Lives Left     :" + Score.life.toString();
			}
			else
				_totalFuel.text = "Press 'd' to die.";
			_totalFuel.setTextFormat(new TextFormat("Courier",30,0x000000,true,false,false,null,null,TextFormatAlign.LEFT));
			_totalFuel.width = this.width;
			_totalFuel.filters = [new GlowFilter(0x000000,1,2,2,1)];
			_totalFuel.x = 100;
			_totalFuel.y = 300;
			addChild(_totalFuel);
				
			//Adding press any key text
			_pressText = new TextField();
			_pressText.type = TextFieldType.DYNAMIC;
			_pressText.selectable = false;
			_pressText.text = "Press arrow key/Click to play  ...";
			_pressText.setTextFormat(new TextFormat("Arial",30,0x000000,true,false,false,null,null,TextFormatAlign.CENTER));
			_pressText.width = this.width;
			_pressText.filters = [new GlowFilter(0x000000,1,2,2,1)];
			_pressText.y = 500;
			addChild(_pressText);
			
			//Making Press any key text to blink
			_timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER, flipOpacity);
			_timer.start();
			
			oreo.addEventListener(KeyboardEvent.KEY_DOWN, playGame);
			oreo.addEventListener(MouseEvent.CLICK, playGame);			
		}

		private function flipOpacity(e:TimerEvent):void
		{
			_pressText.alpha = 1- _pressText.alpha;
			if(this.stage)
			this.stage.focus = CitrusEngine.getInstance();
		}
		
		private function playGame(e:Event):void
		{
			if(e is KeyboardEvent)
			{
				var kbEvent:KeyboardEvent = e as KeyboardEvent;
				switch(kbEvent.keyCode)
				{
					case 68:
					case Keyboard.UP:
					case Keyboard.DOWN:
					case Keyboard.LEFT:
					case Keyboard.RIGHT:
						break;
					
					default:
						return;
					
				}
				if(pauseMode && kbEvent.keyCode == 68)//d
				{
					Hero.die();
				}
			}
			//Mouse.hide();
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, flipOpacity);
			oreo.removeEventListener(KeyboardEvent.KEY_DOWN, playGame);
			oreo.removeEventListener(MouseEvent.CLICK, playGame);
			this.parent.removeChild(this);
			oreo.playing = true;
			_instance = null;
		}
		
		public static function get(pauseMode:Boolean = false):LevelScreen
		{
			if(!_instance)
				_instance = new LevelScreen(new PrivateClass(),pauseMode);
			return _instance;
		}
	}
}

class PrivateClass{}