package com.citrusengine.objects.platformer
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.PhysicsObject;
	import com.citrusengine.objects.persistance.Persistance;
	import com.citrusengine.objects.persistance.PersistanceType;
	import com.citrusengine.physics.CollisionCategories;
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	/**
	 * This is a common example of a side-scrolling bad guy. He has limited logic, basically
	 * only turning around when he hits a wall.
	 * 
	 * When controlling collision interactions between two objects, such as a Horo and Baddy,
	 * I like to let each object perform its own actions, not control one object's action from the other object.
	 * For example, the Hero doesn't contain the logic for killing the Baddy, and the Baddy doesn't contain the
	 * logic for making the hero "Spring" when he kills him. 
	 */	
	public class Baddy extends PhysicsObject
	{
		public var speed:Number = 1.3;
		public var startingDirection:String = "left";
		public var leftBound:Number = -100000;
		public var rightBound:Number = 100000;
		public var points:uint = 8;
		
		public var _enemyClass:* = Hero;
		
		public static function Make(name:String, x:Number, y:Number, width:Number, height:Number, speed:Number, view:* = null, leftBound:Number = -100000, rightBound:Number = 100000, startingDirection:String = "left"):Baddy
		{
			if (view == null) view = MovieClip;
			return new Baddy(name, { x: x, y: y, width: width, height: height, speed: speed, view: view, leftBound: leftBound, rightBound: rightBound, startingDirection: startingDirection } );
		}
		
		public function Baddy(name:String, params:Object=null)
		{
			this.persistance = new Persistance(this,PersistanceType.kExistSaved | PersistanceType.kPositionSaved);
			super(name, params);
			
			if (startingDirection == "left")
			{
				_inverted = true;
			}
		}
		
		override public function destroy():void
		{
			_fixture.removeEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
			
			super.destroy();
		}
		
		public function get enemyClass():*
		{
			return _enemyClass;
		}
		
		public function set enemyClass(value:*):void
		{
			if (value is String)
				_enemyClass = getDefinitionByName(value) as Class;
			else if (value is Class)
				_enemyClass = value;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			var position:V2 = _body.GetPosition();
			
			//Turn around when they pass their left/right bounds
			if ((_inverted && position.x * 30 < leftBound) || (!_inverted && position.x * 30 > rightBound))
				_inverted = !_inverted;
			
			var velocity:V2 = _body.GetLinearVelocity();
			
			if (_inverted)
				velocity.x = -speed;
			else
				velocity.x = speed;
			
			
			_body.SetLinearVelocity(velocity);
			
			updateAnimation();
		}
		
		override protected function createBody():void
		{
			super.createBody();
			_body.SetFixedRotation(true);
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.friction = 0;
			_fixtureDef.filter.categoryBits = CollisionCategories.Get("BadGuys");
			_fixtureDef.filter.maskBits = CollisionCategories.GetAllExcept("Items");
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			_fixture.m_reportBeginContact = true;
			_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
		}
		
		protected function handleBeginContact(e:ContactEvent):void
		{
			if(CheckPoint.restoring)
				return;
			//Collision angle
			if (e.normal) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
			{
				var collisionAngle:Number = new MathVector(e.normal.x, e.normal.y).angle * 180 / Math.PI;
				if((collisionAngle < 190 && collisionAngle >170 && _inverted == true) || (collisionAngle >-190 && collisionAngle< -170 && _inverted == true) )
				{
					_inverted = false;
				}
				if(collisionAngle < 10 && collisionAngle> -10 && _inverted == false)
				{
					_inverted = true;
				}
			}
		}
		
		protected function updateAnimation():void
		{
				_animation = "walk";
		}
	}
}