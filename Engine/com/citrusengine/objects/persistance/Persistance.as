package com.citrusengine.objects.persistance
{
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.objects.PhysicsObject;
	import com.citrusengine.objects.platformer.CheckPoint;
	
	import flash.display.MovieClip;

	public class Persistance
	{
		protected var _pointsAwarded:uint = 0;
		protected var cpScore:uint = 0;
		private var _name:String = "";
		private var _type:uint;
		private var _alive:Boolean;
		private var _cpAlive:Boolean;
		private var _obj:PhysicsObject;
		private var view:MovieClip;
		private var position:PositionInfo = null;
		private var _id:uint;
		public function Persistance(obj:CitrusObject, type:uint = PersistanceType.kNotSaved)
		{
			_id = obj.id;
			_pointsAwarded = 0;
			_type = type;
			_cpAlive = true;
			_alive = true;
			if(obj is PhysicsObject)
				_obj = obj as PhysicsObject;
		}
		
		public function get pointsAwarded():uint
		{
			return _pointsAwarded;
		}
		public function addPointsAwarded(value:uint):void
		{
			Score.addScore(value);
			_pointsAwarded += value;
			trace(_id + " added " + value);
		}
		public function resetPoints():void
		{
			_pointsAwarded = 0;
		}
		public function get Type():uint
		{
			return _type;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
			if(_obj)
				_id = obj.id;//For objects whose persistence is set early...
		}
		public function hitCheckPoint(saveCP:Boolean = false):void
		{
			if(CheckPoint.restoring && saveCP)
				return;
			cpScore = _pointsAwarded;
			_cpAlive = _alive;
			if(_type & PersistanceType.kPositionSaved && _alive)
			{
				if(position == null)
					position = new PositionInfo();
				position.set(_obj.x,_obj.y, _obj.inverted);
				
			}
		}
		
		public function get alive():Boolean
		{
			return _alive;
		}
		public function die():void
		{
			if(CheckPoint.restoring)
				return;
			_obj = null;
			_alive = false;
		}
		public function restore(obj:CitrusObject):void
		{
			if(obj.id != id)
				throw new Error("Unknown object to restore");
			if(obj is PhysicsObject)
			{
				var object:PhysicsObject = obj as PhysicsObject;
				if(_type & PersistanceType.kExistSaved && !_cpAlive)
				{
					object.persistance._alive = false;
					object.kill = true;
				}
				
				else{
					object.persistance._alive = true;
					this._alive = true;
					object.kill = false;
					if(_type & PersistanceType.kPositionSaved && position != null)
				{
					object.x = position.x;
					object.y = position.y;
					object.inverted = position.inverted;
				}}
			}
			obj.persistance.resetPoints();
			obj.persistance.addPointsAwarded(cpScore);
			_pointsAwarded = cpScore;
			obj.persistance.hitCheckPoint(true);
			if(cpScore)
				trace("Restored: " + _id + " Score:" + cpScore);
		}

		public function get obj():PhysicsObject
		{
			return _obj;
		}

		public function get id():uint
		{
			return _id;
		}


	}
}
//Note: You can save additional information here like 
//force/torque/velocity etc that you want to restore
//when checkpoint is hit.
class PositionInfo
{
	private var _x:Number = 0;
	private var _y:Number = 0;
	private var _inverted:Boolean = false;
	public function set(x:Number,y:Number,inverted:Boolean):void
	{
		_x = x; 
		_y = y;
		_inverted = inverted;
	}

	public function get y():Number
	{
		return _y;
	}

	public function get x():Number
	{
		return _x;
	}

	public function get inverted():Boolean
	{
		return _inverted;
	}
}