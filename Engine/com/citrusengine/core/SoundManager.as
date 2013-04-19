package com.citrusengine.core
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class SoundManager
	{
		private static var _instance:SoundManager;
		
		//Creating sound categories
		public static var MUSIC:uint = 1;
		public static var SPEECH:uint = 2;
		public static var HERO_EFFECTS:uint = 4;
		public static var OTHER_EFFECS:uint = 8;
		
		public var sounds:Dictionary;
		public var currPlayingSounds:Dictionary;
		private var tts:ITTS;
		
		public function SoundManager(pvt:PrivateClass)
		{
			sounds = new Dictionary();
			currPlayingSounds = new Dictionary();
		}
		
		public function init():void
		{
			var oreo:Oreo = CitrusEngine.getInstance() as Oreo;
			var loader:Loader = new Loader();
			loader.load(new URLRequest("assets/TTS.swf"));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, ttsLoaded);
			if(oreo._loadManager)
				oreo._loadManager.add(loader);
		}
		
		public static function getInstance():SoundManager 
		{
			if (!_instance)
				_instance = new SoundManager(new PrivateClass());
			return _instance;
		}
		
		public function addSound(id:String, url:String, category:uint):void 
		{
			sounds[id] = {URL: url, group: category} ;
		}
		
		public function removeSound(id:String):void 
		{
			var currID:String;
			
			for (currID in currPlayingSounds)
			{
				if (currID == id)
				{
					delete currPlayingSounds[id];
					break;
				}
			}
			
			for (currID in sounds)
			{
				if (currID == id)
				{
					delete sounds[id];
					break;
				}
			}
		}
		
		public function hasSound(id:String):Boolean 
		{
			return Boolean(sounds[id]);
		}
		
		public function playSound(id:String, volume:Number = 1.0, timesToRepeat:int = 999):void 
		{
			//Check for an existing sound, and play it.
			var t:SoundTransform;
			for (var currID:String in currPlayingSounds)
			{
				if (currID == id)
				{
					var c:SoundChannel = currPlayingSounds[id].channel as SoundChannel;
					var s:Sound = currPlayingSounds[id].sound as Sound;
					t = new SoundTransform(volume);
					c = s.play(0, timesToRepeat);
					c.soundTransform = t;
					currPlayingSounds[id] = {channel: c, sound: s, volume: volume};
					return;
				}
			}
			
			//Create a new sound
			var soundFactory:Sound = new Sound();
			soundFactory.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
			soundFactory.load(new URLRequest(sounds[id].URL));
			
			var channel:SoundChannel = new SoundChannel();
			channel = soundFactory.play(0, timesToRepeat);
			
			t = new SoundTransform(volume);
			channel.soundTransform = t;
			
			currPlayingSounds[id] = {channel: channel, sound: soundFactory, volume: volume, group: sounds[id].group};
		}
		
		public function stopSound(id:String):void 
		{
			for (var currID:String in currPlayingSounds)
			{
				if (currID == id)
					SoundChannel(currPlayingSounds[id].channel).stop();
			}
		}
		
		public function stopSoundByCategory(category:uint):void
		{
			if(category == SoundManager.SPEECH)
			{
				tts.stopSound();
				return;
			}
			for (var currID:String in currPlayingSounds)
			{
				if(currPlayingSounds[currID].group & category)
					SoundChannel(currPlayingSounds[currID].channel).stop();
			}
			if(category & SoundManager.SPEECH)
			{
				tts.stopSound();
			}
		}
		
		public function setGlobalVolume(volume:Number):void 
		{
			for (var currID:String in currPlayingSounds)
			{
				var s:SoundTransform = new SoundTransform(volume);
				SoundChannel(currPlayingSounds[currID].channel).soundTransform = s;
				currPlayingSounds[currID].volume = volume;
			}
		}
		
		public function muteAll(mute:Boolean = true):void
		{
			if (mute)
			{
				setGlobalVolume(0);
			}
			else
			{
				for (var currID:String in currPlayingSounds)
				{
					var s:SoundTransform = new SoundTransform(currPlayingSounds[currID].volume);
					SoundChannel(currPlayingSounds[currID].channel).soundTransform = s;
				}
			}
		}
		
		public function setVolume(id:String, volume:Number):void 
		{
			for (var currID:String in currPlayingSounds)
			{
				if( currID == id )
				{
					var s:SoundTransform = new SoundTransform(volume);
					SoundChannel(currPlayingSounds[id].channel).soundTransform = s;
					currPlayingSounds[id].volume = volume;
				}
			}
		}
		
		public function getSoundChannel(id:String):SoundChannel 
		{
			for (var currID:String in currPlayingSounds)
			{
				if (currID == id)
					return SoundChannel(currPlayingSounds[id].channel);
			}
			throw Error("You are trying to get a non-existent soundChannel. Play it first in order to assign a channel");
			return null;
		}
		
		public function getSoundTransform(id:String):SoundTransform 
		{
			for (var currID:String in currPlayingSounds)
			{
				if (currID == id)
					return SoundChannel(currPlayingSounds[id].channel).soundTransform;
			}
			throw Error("You are trying to get a non-existent soundTransform. Play it first in order to assign a transform");
			return null;
		}
		
		public function getSoundVolume(id:String):Number 
		{
			for (var currID:String in currPlayingSounds)
			{
				if(currID == id)
					return currPlayingSounds[id].volume;
			}
			throw Error("You are trying to get a non-existent volume. Play it first in order to assign a volume.");
			return NaN;
		}
		
		public function playSpeech(id:uint, volume:Number = 0.5):void
		{
			tts.stopSound();
			tts.playSound(id);
			tts.soundTransformObj = new SoundTransform(volume);
			
		}
		
		public function prepareSpeech(text:String,id:uint):void
		{
			tts.synthesize(text,id);
		}
		
		private function handleLoadError(e:IOErrorEvent):void
		{
			trace("Sound manager failed to load a sound: " + e.text);
		}
		
		private function ttsLoaded(e:Event):void
		{
			tts = e.target.loader.content as ITTS;
			tts.init();
		}
	}
}

class PrivateClass {}
