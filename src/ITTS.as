package
{
	import flash.media.SoundTransform;
	
	public interface ITTS
	{
		/* Initialize the TTS Instance*/
		function init():void;
		
		function set soundTransformObj(volume:SoundTransform):void;
		
		function get soundTransformObj():SoundTransform;
		
		/*Stop the current playing sound*/
		function stopSound():void;
		
		/*Play this text as speech*/
		function playSound(id:uint):void;
		
		function synthesize(text:String,id:uint):void;
		
		/* Save the given text as speech file.*/
		function saveFile(text:String, fileName:String):void;
	}
}