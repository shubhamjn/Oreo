package
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	public class Utils
	{
		public function Utils(pvt:PrivateClass):void{}
		/** Utilities**/
		public static function getBitmapData( target:DisplayObject ) :BitmapData
		{
			if ( bd )
			{
				bd = null;
			}
			//target.width and target.height can also be replaced with a fixed number.
			var bd : BitmapData = new BitmapData( 1080,768 );
			bd.draw( target );
			return bd;
		}	
	}
}

class PrivateClass{}