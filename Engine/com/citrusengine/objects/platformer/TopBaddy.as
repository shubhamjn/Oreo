package com.citrusengine.objects.platformer
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.math.MathVector;

	public class TopBaddy extends Baddy
	{
		public function TopBaddy(name:String, params:Object=null)
		{
			super(name, params);
		}
	
		override protected function handleBeginContact(e:ContactEvent):void
		{
			if(CheckPoint.restoring)
				return;
			super.handleBeginContact(e);
			//Collision angle
			if (e.normal) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
			{
				var collisionAngle:Number = new MathVector(e.normal.x, e.normal.y).angle * 180 / Math.PI;
				if (collisionAngle < -80 && collisionAngle > -100)
				{
					if(e.other.GetBody().GetUserData() is Platform || 
						e.other.GetBody().GetUserData() is MovingPlatform ||
						e.other.GetBody().GetUserData() is BaddyReflector)
					{ trace("Strange: These things shouldn't kill");}
					else
					{
						kill = true;
						var velocity:V2 = e.other.GetBody().GetLinearVelocity();
						velocity.y = -3;
						e.other.GetBody().SetLinearVelocity(velocity);
						persistance.addPointsAwarded(points);
					}
				}
				else if(e.other.GetBody().GetUserData() is Hero)
				{
					Hero.die();
				}
			}
		}
	}
}