package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	//import flash.text.TextField;
	//import flash.text.TextFormat;
	
	public class LoadScreen extends Sprite
	{
		[Embed(source="images/LoadingScreen.swf")] private var _loadScreenClass:Class;
		
		//public var pctText:TextField;
		
		public function LoadScreen()
		{
			var loadScreen:MovieClip = new _loadScreenClass();
			addChild(loadScreen);
			
			//create the percent loaded text field
			/*var tf:TextFormat = new TextFormat("Arial, Helvetica", 24, 0xFFFFFF, true);
			tf.align = "center";
			pctText = new TextField();
			addChild(pctText);
			pctText.selectable = false;
			pctText.autoSize = "center";
			pctText.width = 300;
			pctText.defaultTextFormat = tf;
			pctText.x = width / 2;
			pctText.y = height / 2 + 50;*/
		}
		
	}
}