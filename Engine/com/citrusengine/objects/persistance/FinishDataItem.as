package com.citrusengine.objects.persistance
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class FinishDataItem
	{
		public var Category:String = null;
		public var view:DisplayObject = null;
		public var points:uint = 0;
		public var numCollected:uint = 0;
		public var numObjects:uint = 0;
		
		public function FinishDataItem(Category:String, view:DisplayObject, numObjects:uint )
		{
			this.Category = Category;
			this.view = view;
			this.numObjects = numObjects;
			
		}
	}
}