package com.citrusengine.objects.platformer
{
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.objects.persistance.FinishData;
	import com.citrusengine.objects.persistance.FinishDataItem;
	import com.citrusengine.objects.persistance.Persistance;
	import com.citrusengine.physics.CollisionCategories;
	
	import flash.display.DisplayObject;

	public class CheckPoint extends Sensor
	{
		private static var objects:Vector.<Persistance>;
		private static var _enabled:Boolean = false;
		public var finish:Boolean = false;
		private static var finishData:FinishData = null;
		private static var names:Object;
		public function CheckPoint(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override protected function handleBeginContact(e:ContactEvent):void
		{
			if(e.other.GetBody().GetUserData() is Hero)
			{
				if(finish)
				{	
					levelFinished();
					return;
				}
				for each(var obj:Persistance in objects)
				{
					obj.hitCheckPoint();
				}
				enabled = true;
			}
		}
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.filter.categoryBits = CollisionCategories.Get("Items");
			_fixtureDef.filter.maskBits = CollisionCategories.Get("GoodGuys");
		}

		public static function get enabled():Boolean
		{
			return _enabled;
		}

		public static function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		public static function restore():void
		{
			if(enabled)
			{
				var ceobjects:Vector.<CitrusObject> = CitrusEngine.getInstance().state.objects;
				for (var i:int =0; i< ceobjects.length;i++)
				{
					objects[i].restore(ceobjects[i]);
					objects[i] = ceobjects[i].persistance;
				}
			}
			else
			{
				objects = new Vector.<Persistance>();
				for each(var co:CitrusObject in CitrusEngine.getInstance().state.objects)
				{
					objects.push(co.persistance);
				}
			}
			finishData = new FinishData();
			finishData.highScore = Score.highScore;
			finishData.levelCrossed = Oreo.getInstance().level;
			finishData.maxFuel = Fuel.totalFuel;
			names = new Object();
			for each(var persist:Persistance in objects)
			{
				if(persist.name == null || persist.name == "")
					continue;
				if(!names[persist.name])
				{
					var finishItem:FinishDataItem = 
						new FinishDataItem(persist.name,
							CitrusEngine.getInstance().state.view.getArt(persist.obj) as DisplayObject,1);
					names[persist.name]=finishItem;
					finishData.addItem(finishItem);
				}
				else
				{
					(names[persist.name] as FinishDataItem).numObjects++;
				}
			}
		}
		
		private static function levelFinished():void
		{
			enabled = false;
			finishData.blackStars = Score.getBlackStar();
			finishData.currentFuel = Fuel.currentFuel;
			finishData.currentScore = Score.score;
			finishData.jetPackLeft = Score.sparePacks;
			finishData.time = Score.time;
			for each(var persist:Persistance in objects)
			{
				if(persist.pointsAwarded != 0)
				{
					var finishItem:FinishDataItem = (names[persist.name] as FinishDataItem);
					finishItem.numCollected++;
					if(finishItem.numCollected == 1)
						finishItem.points = persist.pointsAwarded;
					else
						if(persist.pointsAwarded != finishItem.points)
						{
							finishData.otherScore = finishItem.points - persist.pointsAwarded;
						}
				}
			}
		}
	}	
}	