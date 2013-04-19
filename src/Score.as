package
{
	import com.citrusengine.core.CitrusEngine;
	
	import flash.data.EncryptedLocalStore;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	public class Score extends MovieClip
	{
		[Embed(source="images/DS-DIGI.TTF", fontName="DS-Digital", mimeType="application/x-font-truetype")] 
		public static var digiFont:Class;
		private static var _scoreLabel:TextField;
		private static var _totalScoreLabel:TextField;
		private static var _scoreValue:TextField;
		private static var _totalScoreValue:TextField;
		private static var _timeValue:TextField;
		private static var _timeLabel:TextField;
		private static var _score:Vector.<uint>;
		private static var _currentScore:uint;
		private static var _level:uint;
		private static var _totalScoreTillNow:uint;
		private static var _totalScoreAfter:uint;
		private static var _scoreVar:Score;
		private static var _sparePacks:uint;
		private static var _packValue:TextField;
		private static var _lifeValue:TextField;
		private static var _stars:uint;
		private static var _totalStars:uint;
		private static var _life:uint;
		private static var _time:Number;
		private static const SCORE_PAD:uint = 6;
		private static var levelUnlocked:uint = 0;
		private static var _blackStar:uint = 0;
		
		private static const SAVE_VERSION:uint = 1;
		
		public function Score(pvt:PrivateClass)
		{
			Font.registerFont(digiFont);
			super();
			_time = 0;
			_sparePacks = 0;
			_score = new Vector.<uint>();
			_score.push(0);
			_scoreLabel = new TextField;
			_scoreLabel.type = TextFieldType.DYNAMIC;
			_scoreLabel.text = "Level Score: ";
			_timeLabel = new TextField;

			var format:TextFormat	      = new TextFormat();
			format.font = "DS-Digital";
			format.color = 0x000000;
			format.size = 40;
			_timeLabel.width = 0;
			_timeLabel.autoSize              = TextFieldAutoSize.CENTER;
			_timeLabel.antiAliasType         = AntiAliasType.ADVANCED;
			_timeLabel.defaultTextFormat     = format;
			_timeLabel.type = TextFieldType.DYNAMIC;
			_timeLabel.x = 512;
			_timeLabel.text = "12:00";
			_totalScoreLabel = new TextField;
			_totalScoreLabel.type = TextFieldType.DYNAMIC;
			_totalScoreLabel.text = "Total Score: ";
			var labelFormat:TextFormat = new TextFormat("Arial",14,0x000000,true,false,false);
			_scoreLabel.setTextFormat(labelFormat);
			_totalScoreLabel.setTextFormat(labelFormat);
			_packValue = new TextField;
			_packValue.type = TextFieldType.DYNAMIC;
			_level = 0;
			_currentScore = 0;
			_scoreLabel.x =800;
			_totalScoreLabel.x = 800;
			_totalScoreLabel.y = 20;
			_scoreValue = new TextField();
			_scoreValue.type = TextFieldType.DYNAMIC;
			_totalScoreValue = new TextField();
			_totalScoreValue.type = TextFieldType.DYNAMIC;
			_totalScoreValue.x = 850;
			_totalScoreValue.y = 20;
			_scoreValue.x = 850;
			_scoreValue.width = 150;
			_totalScoreValue.width = 150;
			var _packValueFormat:TextFormat = new TextFormat("Arial",25,0x000000,true,false,false);
			_lifeValue = new TextField();
			_lifeValue.x = 700;
			_lifeValue.text = "0";
			_lifeValue.defaultTextFormat = _packValueFormat;
			_packValue.x = 770;
			_packValue.text = "0";
			_packValue.defaultTextFormat = _packValueFormat;
			var valueFormat:TextFormat = new TextFormat("Arial",12,0x000000,true,false,false,null,null,TextFormatAlign.RIGHT);
			_totalScoreValue.text = "0 (0)";
			_scoreValue.text = "0 (0)";
			_totalScoreValue.defaultTextFormat = valueFormat;
			_scoreValue.defaultTextFormat = valueFormat;
			_scoreLabel.selectable = false;
			_totalScoreLabel.selectable = false;
			_scoreValue.selectable = false;
			_totalScoreValue.selectable = false;
			_packValue.selectable = false;
			_lifeValue.selectable = false;
			_timeLabel.selectable = false;
			_totalScoreTillNow = 0;
			_totalScoreAfter = 0;
			addChild(_scoreValue);
			addChild(_scoreLabel);
			addChild(_totalScoreLabel);
			addChild(_totalScoreValue);
			addChild(_packValue);
			addChild(_lifeValue);
			addChild(_timeLabel);
			var loader:Loader = new Loader();
			var oreo:Oreo = CitrusEngine.getInstance() as Oreo;
			if(oreo._loadManager)
				oreo._loadManager.add(loader);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,packUILoaded);
			loader.load(new URLRequest("assets/sparePacks.png"));
			loader = new Loader();
			if(oreo._loadManager)
				oreo._loadManager.add(loader);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,lifeUILoaded);
			loader.load(new URLRequest("assets/hero.png"));
			_stars=0;
			_totalStars = 0;
			life = 3;
		}
		
		public static function update(timeDelta:Number):void
		{
			_time = _time + timeDelta;
			_timeLabel.text = zeroPad(uint(_time/60),2) + " : " + zeroPad((uint(_time)%60),2);
		}
		
		public function set scale(value:Number):void
		{
			this.scaleX = 1/value;
			this.scaleY = 1/value;
		}

		public static function getInstance():Score
		{
			if(_scoreVar == null)
				_scoreVar = new Score(new PrivateClass());
			return _scoreVar;
		}
		
		public static function get score():uint
		{
			return _currentScore;
		}
		
		public static function addScore(value:uint):void
		{
			_currentScore += value;
			_scoreValue.text = zeroPad(_currentScore,SCORE_PAD);
			_scoreValue.appendText(" (");
			if(_currentScore>_score[_level])
			{
				_scoreValue.appendText(zeroPad(_currentScore,SCORE_PAD));
				_totalScoreValue.text = zeroPad((_totalScoreTillNow + _currentScore),SCORE_PAD) + " (";
				_totalScoreValue.appendText(zeroPad((_totalScoreTillNow + _currentScore + _totalScoreAfter),SCORE_PAD) + ")");
			}
			else
			{
				_scoreValue.appendText(zeroPad(_score[_level],SCORE_PAD));
				_totalScoreValue.text = zeroPad(_totalScoreTillNow + _score[_level],SCORE_PAD) + " (";
				_totalScoreValue.appendText(zeroPad(_totalScoreTillNow + _score[_level] + _totalScoreAfter,SCORE_PAD) + ")");

			}
			_scoreValue.appendText( ")");
			if(value !=0)
				trace("Score added:"+value+" Total:" + _currentScore);
		}

		public static function set level(value:uint):void
		{
			//if(_level == value)
				//return; 
			if(value > levelUnlocked) levelUnlocked = value;
			if(_currentScore > _score[_level])
				_score[_level] = _currentScore;
			_currentScore = 0;
			_level = value;
			while(_score.length < value)
			{
				_score.push(0);
			}
			_totalScoreTillNow = 0;
			_totalScoreAfter = 0;
			for(var i:uint=0;i<_level;i++)
			{
				_totalScoreTillNow += _score[i];
			}
			for(i=_level+1;i<_score.length;i++)
			{
				_totalScoreAfter += _score[i];
			}
			addScore(0);
			_stars=0;
			_time=0;
			_totalStars = 0;
			_timeLabel.text = "0 : 00";
			saveGame();
		}

		public static function get sparePacks():uint
		{
			return _sparePacks;
		}
		
		public static function set sparePacks(value:uint):void
		{
			_sparePacks = value;
			_packValue.text = _sparePacks.toString();
			//_packValue.setTextFormat(_packValueFormat);
		}
		
		private function lifeUILoaded(e:Event):void
		{
			var lifeImage:Bitmap;
			lifeImage = e.target.loader.content as Bitmap;
			addChild(lifeImage);
			lifeImage.filters = [new GlowFilter(0x000000,1,3,3,2)];
			lifeImage.x = 676;
			
		}
		
		private function packUILoaded(e:Event):void
		{
			var packImage:Bitmap;
			packImage = e.target.loader.content as Bitmap;
			addChild(packImage);
			packImage.x = 730;
			
		}
		
		public static function getScoreList():Vector.<uint>
		{
			return _score;
		}
		
		public static function get highScore():uint
		{
			return _score[_level];
		}

		public static function get stars():uint
		{
			return _stars;
		}

		public static function set stars(value:uint):void
		{
			_stars = value;
		}

		public static function get totalStars():uint
		{
			return _totalStars;
		}

		public static function set totalStars(value:uint):void
		{
			_totalStars = value;
		}

		public static function set life(value:uint):void
		{
			_life = value;
			_lifeValue.text = _life.toString();
			//_lifeValue.setTextFormat(_packValueFormat);
		}

		public static function get life():uint
		{
			return _life;
		}

		public static function get time():uint
		{
			return _time;
		}
		public static function getBlackStar():uint
		{
			return _blackStar;
		}
		
		public static function addBlackStar():uint
		{
			return ++_blackStar;
		}
		/*Utility Function*/
		private static function zeroPad(number:uint, width:uint):String {
			var ret:String = ""+number;
			while( ret.length < width )
				ret="0" + ret;
			return ret;
		}
		
		private static function prepareSaveContent():ByteArray
		{
			var saveInfo:Object = new Object();
			saveInfo.saveVersion = SAVE_VERSION;
			saveInfo.score = _score;
			saveInfo.levelUnlocked = levelUnlocked;
			saveInfo.life = life;
			saveInfo.blackStar = _blackStar;
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(saveInfo);
			bytes.compress();
			return bytes;
		}
		
		public static function saveGame():void{
			
			EncryptedLocalStore.setItem("oreo"+SAVE_VERSION, prepareSaveContent());
			saveToFile();
		}
		
		public static function saveToFile(fileName:String = "Oreo.oreo"):void
		{
			var file:File = File.documentsDirectory 
			file=file.resolvePath(fileName);  
			var fileStream:FileStream = new FileStream();  
			fileStream.open(file, FileMode.WRITE);  
			fileStream.writeObject(prepareSaveContent());
			fileStream.addEventListener(Event.CLOSE, saveComplete);  
			fileStream.close();  
			function saveComplete(event:Event):void {  
				trace("File Saved");  
			} 
		}
		
		public static function loadFromFile(fileName:String = "Oreo.oreo"):void
		{
			var file:File = File.documentsDirectory 
			file=file.resolvePath(fileName);  
			if(!file.exists)
				return;
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			loadContentFromBytes(stream.readObject());
		}
		
		public static function handleInitializationArgs(event:InvokeEvent):void {
			
			var args:Array = event.arguments as Array;
			if (args.length) {
				
				var fileToOpen:String = String(args[0]);
				var fileLoader:Loader = new Loader();
				fileLoader.load(new URLRequest(fileToOpen));
				fileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadGame);
			}
			function loadGame(e:Event):void
			{
				var bytes:ByteArray = e.target.contentLoaderInfo.content;
				loadContentFromBytes(bytes);
			}
		}
		private static function loadContentFromBytes(bytes:ByteArray):void
		{
			if(!bytes)
				return;
			bytes.uncompress();
			var saveInfo:Object = bytes.readObject();
			if(saveInfo.saveVersion != SAVE_VERSION)
			{
				throw new Error("Trying load an older saved game. Deleted!!");
			}
			_score = saveInfo.score;
			levelUnlocked = saveInfo.levelUnlocked;
			life = saveInfo.life;
			_blackStar = saveInfo.blackStar;
		}
		
		public static function loadGame():void{
			var bytes:ByteArray = EncryptedLocalStore.getItem("oreo"+SAVE_VERSION);
			loadContentFromBytes(bytes);
		} 
	}
}

class PrivateClass{}