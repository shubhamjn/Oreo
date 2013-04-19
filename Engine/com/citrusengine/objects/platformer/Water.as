package com.citrusengine.objects.platformer
{
	import Box2DAS.Controllers.b2BuoyancyEffect;
	import Box2DAS.Controllers.b2Controller;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.physics.Box2D;

	
	public class Water extends Sensor
	{
		
		private var controller:b2Controller;
		public var density:int;
		public var jetExtinguish:Boolean = false;
		public var drag:Boolean;
		public function Water(name:String, params:Object=null)
		{
			this.drag = true;
			this.density = 5;
			super(name, params);
			var box2D:Box2D = (CitrusEngine.getInstance().state.getObjectsByType(Box2D).shift() as Box2D);
			var b2Bouy:b2BuoyancyEffect = new b2BuoyancyEffect(-(this.y - this.height/2)/box2D.scale, this.drag);
			b2Bouy.density = this.density;
			controller = new b2Controller(box2D.world,b2Bouy,false);
			
		}
		
		override protected function handleBeginContact(e:ContactEvent):void
		{
			controller.AddBody(e.other.GetBody());
			if(e.other.GetBody().GetUserData() is Hero && jetExtinguish)
			{
				Hero.jetEnabled = false;
			}
		}
		
		override protected function handleEndContact(e:ContactEvent):void
		{
			controller.RemoveBody(e.other.GetBody());
		}
	}
}