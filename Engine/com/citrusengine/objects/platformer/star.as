package com.citrusengine.objects.platformer
{
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.objects.persistance.Persistance;
	import com.citrusengine.objects.persistance.PersistanceType;
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	import flashx.textLayout.utils.CharacterUtil;
	
	/**
	 * Star is basically a sensor that destroys itself when a particular class type touches it. 
	 */	
	public class Star extends Sensor
	{
		private var _collectorClass:Class = Hero;
		
		public var points:int;
		
		
		public static function Make(name:String, x:Number, y:Number, view:* = null):Star
		{
			if (view == null) view = MovieClip;
			return new Star(name, { x: x, y: y, view: view } );
		}
		
		public function Star(name:String, params:Object=null)
		{
			this.persistance = new Persistance(this,PersistanceType.kExistSaved);
			this.points=7;
			super(name, params);
		}
		
		/**
		 * The Star uses the collectorClass parameter to know who can collect it.
		 * Use this setter to to pass in which base class the collector should be, in String form
		 * or Object notation.
		 * For example, if you want to set the "Hero" class as your hero's enemy, pass
		 * "com.citrusengine.objects.platformer.Hero" or Hero directly (no quotes). Only String
		 * form will work when creating objects via a level editor.
		 */		
		public function set collectorClass(value:*):void
		{
			if (value is String)
				_collectorClass = getDefinitionByName(value as String) as Class;
			else if (value is Class)
				_collectorClass = value;
		}
		
		override protected function handleBeginContact(e:ContactEvent):void
		{
			if(CheckPoint.restoring)
				return;
			super.handleBeginContact(e);
			
			if (_collectorClass && e.other.GetBody().GetUserData() is _collectorClass)
			{
				die();
				SoundManager.getInstance().playSound("coinCollect",1,1);
				
			}
		}
		public function die():void
		{
			kill = true;
			this.persistance.addPointsAwarded(points);
		}
	}
}