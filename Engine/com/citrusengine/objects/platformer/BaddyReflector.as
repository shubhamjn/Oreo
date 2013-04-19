package com.citrusengine.objects.platformer
{
	import com.citrusengine.physics.CollisionCategories;

	public class BaddyReflector extends Platform
	{
		public function BaddyReflector(name:String, params:Object=null)
		{
			super(name, params);
		}
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.restitution = 0;
			_fixtureDef.filter.categoryBits = CollisionCategories.Get("Level");
			_fixtureDef.filter.maskBits = CollisionCategories.Get("BadGuys");
		}
	}
}