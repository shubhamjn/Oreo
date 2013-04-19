package com.citrusengine.objects.platformer
{
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.core.SoundManager;
	
	import flash.utils.getDefinitionByName;

	public class SpeechSensor extends Sensor
	{
		private var _collectorClass:Class = Hero;
		
		public var sentence:String;
		
		private var _id:uint;
		private static var num:uint = 0;
		
		public function SpeechSensor(name:String, params:Object=null)
		{
			this.sentence = "";
			super(name, params);
			this._id = num++;
			SoundManager.getInstance().prepareSpeech(sentence,_id);
		}
		
		public static function reset():void
		{
			num = 0;
		}
		
		public function set collectorClass(value:*):void
		{
			if (value is String)
				_collectorClass = getDefinitionByName(value as String) as Class;
			else if (value is Class)
				_collectorClass = value;
		}
		
		override protected function handleBeginContact(e:ContactEvent):void
		{
			super.handleBeginContact(e);
			
			if (_collectorClass && e.other.GetBody().GetUserData() is _collectorClass)
			{
				kill = true;
				SoundManager.getInstance().playSpeech(_id);
				
			}
		}
	}
}