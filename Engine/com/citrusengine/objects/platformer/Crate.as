package com.citrusengine.objects.platformer
{
	import Box2DAS.Collision.Shapes.b2CircleShape;
	import Box2DAS.Collision.Shapes.b2MassData;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.PhysicsObject;
	import com.citrusengine.objects.persistance.Persistance;
	import com.citrusengine.objects.persistance.PersistanceType;
	
	import flash.display.MovieClip;
	
	/**
	 * A very simple physics object. I just needed to add bullet mode and zero restitution
	 * to make it more stable, otherwise it gets very jittery. 
	 */	
	public class Crate extends PhysicsObject
	{
		public var rectangle:Boolean = true;
		public static function Make(name:String, x:Number, y:Number, width:Number, height:Number, view:* = null):Crate
		{
			if (view == null) view = MovieClip;
			return new Crate(name, { x: x, y: y, width: width, height: height, view: view } );
		}
		
		public function Crate(name:String, params:Object=null)
		{
			this.persistance = new Persistance(this,PersistanceType.kPositionSaved);
			super(name, params);
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			_bodyDef.bullet = false;
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.density /= 3.9;
			_fixtureDef.restitution = 0;
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
		}
		
		override public function destroy():void
		{
			_fixture.removeEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
			super.destroy();
		}
		
		override protected function createShape():void
		{
			if(rectangle == true)
			{	
				super.createShape();
				return;
			}
			else
			{
				_shape = new b2CircleShape();
				_shape.m_radius = _width/2;
			}
		}
		
		protected function handleBeginContact(e:ContactEvent):void
		{
			//var colliderBody:b2Body = e.other.GetBody();
			
			
			//Collision angle
			if (e.normal) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
			{
				//var collisionAngle:Number = new MathVector(e.normal.x, e.normal.y).angle * 180 / Math.PI;
				//if (collisionAngle < 135)
				//{
				SoundManager.getInstance().playSound("crateFall",1,1);
				//}
			}
			//else
			//{
			//	SoundManager.getInstance().playSound("crateFall",1,1);
			//}
		}
		
	}
}