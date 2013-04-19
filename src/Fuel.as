package
{
	import com.citrusengine.core.CitrusEngine;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class Fuel extends Sprite
	{
		private static var _loader:Loader;
		private static var _fuelMeterMC:MovieClip;
		private static var _instance:Fuel;
		private static var _totalFuel:Number;
		private static var _currentFuel:Number;
		
		public function Fuel(pvt:PrivateClass)
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fuelMeterLoaded)
			var oreo:Oreo = CitrusEngine.getInstance() as Oreo;
			if(oreo._loadManager)
				oreo._loadManager.add(_loader);
			_totalFuel = 100;
			_currentFuel = 100;
			_loader.load(new URLRequest("assets/FuelMeter.swf"));
		}
		
		public static function get totalFuel():Number
		{
			return _totalFuel;
		}

		public static function set totalFuel(value:Number):void
		{
			_totalFuel = value;
			if(_currentFuel>_totalFuel) _currentFuel = _totalFuel;
			_fuelMeterMC.setFuel((_currentFuel/_totalFuel) *100);
		}

		public static function get currentFuel():Number
		{
			return _currentFuel;
		}

		public static function set currentFuel(value:Number):void
		{
			_currentFuel = value > _totalFuel?_totalFuel:value;
			_fuelMeterMC.setFuel((_currentFuel *100)/_totalFuel);
		}

		public static function getInstance():Fuel
		{
			if(!_instance)
				_instance = new Fuel(new PrivateClass());
			return _instance;
			
		}
		
		private function fuelMeterLoaded(e:Event):void
		{
			_fuelMeterMC = e.target.loader.content as MovieClip;
			addChild(_fuelMeterMC);
			_fuelMeterMC.x = 10;
			_fuelMeterMC.y =10;
		}
		public function set scale(value:Number):void
		{
			this.scaleX = 1/value;
			this.scaleY = 1/value;
		}
	}
}

class PrivateClass{}