package
{
	import org.flixel.*; 
	[SWF(width="1280", height="800", backgroundColor="#000000")] 
	
	public class AdventureTime extends FlxGame
	{
		public static var currLevelIndex:uint = 0;
		
		public function AdventureTime()
		{
			super(640,400,PlayState,2);
		}
	}
}