package com.citrusengine.objects.persistance
{
	import flash.geom.Point;

	public class PositionSaved extends Persistance
	{
		private var _x:uint;
		private var _y:uint;
		
		public function PositionSaved(name:String,x:Number,y:Number)
		{
			_x = x;
			_y = y;
			super(name);
		}
		public function get x():uint
		{
			return _x;
		}

		public function set x(value:uint):void
		{
			_x = value;
		}

		public function get y():uint
		{
			return _y;
		}

		public function set y(value:uint):void
		{
			_y = value;
		}
		public function get Type():uint
		{
			return PersistanceType.kPositionSaved;
		}
	}
}