package com.citrusengine.objects.platformer
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.math.MathVector;

	public class TopBackBaddy extends Baddy
	{
		public function TopBackBaddy(name:String, params:Object=null)
		{
			super(name, params);
		}
		override protected function handleBeginContact(e:ContactEvent):void
		{
			if(CheckPoint.restoring)
				return;
			//Collision angle
			if (e.normal) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
			{
				var collisionAngle:Number = new MathVector(e.normal.x, e.normal.y).angle * 180 / Math.PI;
				if(collisionAngle < -80 && collisionAngle > -100)
				{ 	
					var velocity:V2 = e.other.GetBody().GetLinearVelocity();
					velocity.y = -3;
					e.other.GetBody().SetLinearVelocity(velocity);
				}
				if((collisionAngle < 190 && collisionAngle >170 && _inverted != true) ||
				   (collisionAngle >-190 && collisionAngle< -170 && _inverted != true) || 
				   (collisionAngle < 10 && collisionAngle> -10 && _inverted != false) ||
				   (collisionAngle < -80 && collisionAngle > -100))
				{
					if(e.other.GetBody().GetUserData() is Platform || 
					   e.other.GetBody().GetUserData() is MovingPlatform ||
					   e.other.GetBody().GetUserData() is BaddyReflector)
					{ trace("Strange: These things shouldn't kill");}
					else
					{
						kill = true;
						persistance.addPointsAwarded(points);
						return;
					}
				}
				else if(e.other.GetBody().GetUserData() is Hero)
				{
					Hero.die();
				}
			}
			super.handleBeginContact(e);
		}
	}
}